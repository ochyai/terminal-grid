import AppKit
import ApplicationServices

public final class WindowManager {

    public enum AppCategory: String, CaseIterable {
        case terminal  = "Terminal"
        case browser   = "Browser"
        case stickies  = "Stickies"
        case custom    = "Custom"
        case all       = "All"
    }

    private static let customBundleIDsKey = "CustomBundleIDs"

    // Known terminal bundle identifiers
    public let terminalBundleIDs: Set<String> = [
        "com.apple.Terminal",
        "com.googlecode.iterm2",
        "org.alacritty",
        "dev.warp.Warp-Stable",
        "net.kovidgoyal.kitty",
        "com.github.wez.wezterm",
        "co.zeit.hyper",
        "com.mitchellh.ghostty",
        "io.tabby",
    ]

    // Stickies
    public let stickiesBundleIDs: Set<String> = [
        "com.apple.Stickies",
    ]

    // Known browser bundle identifiers
    public let browserBundleIDs: Set<String> = [
        "com.google.Chrome",
        "com.google.Chrome.canary",
        "com.brave.Browser",
        "com.microsoft.edgemac",
        "com.vivaldi.Vivaldi",
        "company.thebrowser.Browser",   // Arc
        "org.mozilla.firefox",
        "com.operasoftware.Opera",
        "com.apple.Safari",
    ]

    public init() {}

    // MARK: - Custom Apps

    public var customBundleIDs: Set<String> {
        get {
            Set(UserDefaults.standard.stringArray(forKey: Self.customBundleIDsKey) ?? [])
        }
        set {
            UserDefaults.standard.set(Array(newValue).sorted(), forKey: Self.customBundleIDsKey)
        }
    }

    public func addCustomApp(bundleID: String) {
        var ids = customBundleIDs
        ids.insert(bundleID)
        customBundleIDs = ids
    }

    public func removeCustomApp(bundleID: String) {
        var ids = customBundleIDs
        ids.remove(bundleID)
        customBundleIDs = ids
    }

    /// All bundle IDs that are already in a built-in category.
    public var builtinBundleIDs: Set<String> {
        terminalBundleIDs.union(browserBundleIDs).union(stickiesBundleIDs)
    }

    /// Running apps that are not in any built-in or custom category (candidates to add).
    public func addableRunningApps() -> [(name: String, bundleID: String)] {
        let allKnown = builtinBundleIDs.union(customBundleIDs)
        var result: [(name: String, bundleID: String)] = []
        for app in NSWorkspace.shared.runningApplications {
            guard app.activationPolicy == .regular,
                  let bid = app.bundleIdentifier,
                  !allKnown.contains(bid) else { continue }
            let name = app.localizedName ?? bid
            result.append((name: name, bundleID: bid))
        }
        result.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        return result
    }

    /// Display name for a bundle ID (from running app or bundle on disk).
    public func appName(for bundleID: String) -> String {
        if let app = NSWorkspace.shared.runningApplications.first(where: { $0.bundleIdentifier == bundleID }) {
            return app.localizedName ?? bundleID
        }
        if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) {
            return FileManager.default.displayName(atPath: url.path)
        }
        return bundleID
    }

    // MARK: - Public

    public func countWindows(category: AppCategory = .terminal) -> Int {
        return collectWindows(category: category).count
    }

    /// Whether Accessibility API is available.
    public var isAccessibilityTrusted: Bool {
        AXIsProcessTrusted()
    }

    /// Arrange all visible terminal windows into an optimal grid on the main screen.
    /// If `forcedColumns` is provided, use that column count instead of auto-calculating.
    /// Returns a status message describing the result.
    @discardableResult
    public func arrangeInGrid(category: AppCategory = .terminal, forcedColumns: Int? = nil) -> String {
        guard isAccessibilityTrusted else {
            return "accessibility_denied"
        }

        let windows = collectWindows(category: category)
        guard !windows.isEmpty else {
            return "no_windows"
        }
        guard let screen = NSScreen.main else { return "no_screen" }

        let visibleFrame = screen.visibleFrame
        let screenFrame = screen.frame

        let count = windows.count
        let cols: Int
        let rows: Int

        if let forced = forcedColumns {
            cols = forced
            rows = Int(ceil(Double(count) / Double(forced)))
        } else {
            (cols, rows) = gridSize(for: count)
        }

        let cellWidth = visibleFrame.width / CGFloat(cols)
        let cellHeight = visibleFrame.height / CGFloat(rows)

        // AX coordinates: origin at top-left of the primary display.
        // NSScreen.visibleFrame uses bottom-left origin, so convert.
        let topOffset = screenFrame.height - visibleFrame.origin.y - visibleFrame.height

        for (index, axWindow) in windows.enumerated() {
            let col = index % cols
            let row = index / cols

            var position = CGPoint(
                x: visibleFrame.origin.x + CGFloat(col) * cellWidth,
                y: topOffset + CGFloat(row) * cellHeight
            )
            var size = CGSize(width: cellWidth, height: cellHeight)

            guard let posValue = AXValueCreate(.cgPoint, &position),
                  let sizeValue = AXValueCreate(.cgSize, &size) else { continue }

            // Set position first, then size (some apps behave better this way)
            AXUIElementSetAttributeValue(axWindow, kAXPositionAttribute as CFString, posValue)
            AXUIElementSetAttributeValue(axWindow, kAXSizeAttribute as CFString, sizeValue)
        }
        return "ok:\(count)"
    }

    // MARK: - Bundle ID Lookup

    public func bundleIDs(for category: AppCategory) -> Set<String> {
        switch category {
        case .terminal:  return terminalBundleIDs
        case .browser:   return browserBundleIDs
        case .stickies:  return stickiesBundleIDs
        case .custom:    return customBundleIDs
        case .all:       return terminalBundleIDs.union(browserBundleIDs).union(stickiesBundleIDs).union(customBundleIDs)
        }
    }

    private func collectWindows(category: AppCategory) -> [AXUIElement] {
        guard isAccessibilityTrusted else {
            NSLog("[TerminalGrid] collectWindows: Accessibility not trusted — returning empty")
            return []
        }

        let targetIDs = bundleIDs(for: category)
        var result: [AXUIElement] = []

        for app in NSWorkspace.shared.runningApplications {
            guard let bundleID = app.bundleIdentifier,
                  targetIDs.contains(bundleID) else { continue }

            let appElement = AXUIElementCreateApplication(app.processIdentifier)
            var windowsRef: CFTypeRef?

            let axError = AXUIElementCopyAttributeValue(
                appElement,
                kAXWindowsAttribute as CFString,
                &windowsRef
            )

            guard axError == .success,
                  let axWindows = windowsRef as? [AXUIElement] else {
                NSLog("[TerminalGrid] collectWindows: AXError=%{public}d for %{public}@ (pid=%d)", axError.rawValue, bundleID, app.processIdentifier)
                continue
            }

            NSLog("[TerminalGrid] collectWindows: %{public}@ has %d AX windows", bundleID, axWindows.count)

            for axWindow in axWindows {
                // Skip minimized windows
                if isMinimized(axWindow) { continue }

                // Skip tiny helper/popup windows
                let size = self.size(of: axWindow)
                if size.width < 50 || size.height < 50 { continue }

                result.append(axWindow)
            }
        }

        // Sort by current position (top-to-bottom, then left-to-right) so
        // the resulting grid preserves roughly the same spatial order.
        result.sort { w1, w2 in
            let p1 = position(of: w1)
            let p2 = position(of: w2)
            if abs(p1.y - p2.y) > 50 { return p1.y < p2.y }
            return p1.x < p2.x
        }

        return result
    }

    // MARK: - Private: AX Helpers

    private func position(of window: AXUIElement) -> CGPoint {
        var ref: CFTypeRef?
        AXUIElementCopyAttributeValue(window, kAXPositionAttribute as CFString, &ref)
        guard let ref = ref else { return .zero }
        var point = CGPoint.zero
        AXValueGetValue(ref as! AXValue, .cgPoint, &point)
        return point
    }

    private func size(of window: AXUIElement) -> CGSize {
        var ref: CFTypeRef?
        AXUIElementCopyAttributeValue(window, kAXSizeAttribute as CFString, &ref)
        guard let ref = ref else { return .zero }
        var s = CGSize.zero
        AXValueGetValue(ref as! AXValue, .cgSize, &s)
        return s
    }

    private func isMinimized(_ window: AXUIElement) -> Bool {
        var ref: CFTypeRef?
        AXUIElementCopyAttributeValue(window, kAXMinimizedAttribute as CFString, &ref)
        return (ref as? Bool) ?? false
    }

    // MARK: - Grid Calculation

    /// Calculate optimal (cols, rows) for `count` windows.
    /// Prefers wider layouts to match typical screen aspect ratios.
    public func gridSize(for count: Int) -> (cols: Int, rows: Int) {
        guard count > 1 else { return (1, 1) }

        let cols = Int(ceil(sqrt(Double(count))))
        let rows = Int(ceil(Double(count) / Double(cols)))
        return (cols, rows)
    }
}
