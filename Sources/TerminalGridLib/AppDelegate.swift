import AppKit

public final class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private var statusItem: NSStatusItem!
    private let windowManager = WindowManager()
    private var terminalCountItem: NSMenuItem!
    private var browserCountItem: NSMenuItem!
    private var stickiesCountItem: NSMenuItem!
    private var customCountItem: NSMenuItem!
    private var customAppsSubmenu: NSMenu!
    private var addAppSubmenu: NSMenu!

    public override init() {
        super.init()
    }

    public func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem.button {
            button.image = NSImage(
                systemSymbolName: "square.grid.2x2",
                accessibilityDescription: "Terminal Grid"
            )
        }

        setupMenu()
        checkAccessibility()
    }

    // MARK: - Menu Setup

    private func setupMenu() {
        let menu = NSMenu()
        menu.delegate = self

        // --- Terminal section ---
        let terminalHeader = NSMenuItem(title: "TERMINAL", action: nil, keyEquivalent: "")
        terminalHeader.isEnabled = false
        menu.addItem(terminalHeader)

        let arrangeTerminals = NSMenuItem(title: "Arrange Terminals in Grid", action: #selector(arrangeTerminalGrid), keyEquivalent: "")
        arrangeTerminals.target = self
        menu.addItem(arrangeTerminals)

        terminalCountItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        terminalCountItem.isEnabled = false
        menu.addItem(terminalCountItem)

        menu.addItem(NSMenuItem.separator())

        // --- Browser section ---
        let browserHeader = NSMenuItem(title: "BROWSER", action: nil, keyEquivalent: "")
        browserHeader.isEnabled = false
        menu.addItem(browserHeader)

        let arrangeBrowsers = NSMenuItem(title: "Arrange Browsers in Grid", action: #selector(arrangeBrowserGrid), keyEquivalent: "")
        arrangeBrowsers.target = self
        menu.addItem(arrangeBrowsers)

        browserCountItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        browserCountItem.isEnabled = false
        menu.addItem(browserCountItem)

        menu.addItem(NSMenuItem.separator())

        // --- Stickies section ---
        let stickiesHeader = NSMenuItem(title: "STICKIES", action: nil, keyEquivalent: "")
        stickiesHeader.isEnabled = false
        menu.addItem(stickiesHeader)

        let arrangeStickies = NSMenuItem(title: "Arrange Stickies in Grid", action: #selector(arrangeStickiesGrid), keyEquivalent: "")
        arrangeStickies.target = self
        menu.addItem(arrangeStickies)

        stickiesCountItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        stickiesCountItem.isEnabled = false
        menu.addItem(stickiesCountItem)

        menu.addItem(NSMenuItem.separator())

        // --- Custom Apps section ---
        let customHeader = NSMenuItem(title: "CUSTOM APPS", action: nil, keyEquivalent: "")
        customHeader.isEnabled = false
        menu.addItem(customHeader)

        let arrangeCustom = NSMenuItem(title: "Arrange Custom Apps in Grid", action: #selector(arrangeCustomGrid), keyEquivalent: "")
        arrangeCustom.target = self
        menu.addItem(arrangeCustom)

        customCountItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        customCountItem.isEnabled = false
        menu.addItem(customCountItem)

        // Registered custom apps submenu (with remove option)
        let customAppsItem = NSMenuItem(title: "  Registered Apps", action: nil, keyEquivalent: "")
        customAppsSubmenu = NSMenu()
        customAppsItem.submenu = customAppsSubmenu
        menu.addItem(customAppsItem)

        // Add App submenu (shows running apps)
        let addAppItem = NSMenuItem(title: "  Add Running App...", action: nil, keyEquivalent: "")
        addAppSubmenu = NSMenu()
        addAppItem.submenu = addAppSubmenu
        menu.addItem(addAppItem)

        // Add from /Applications
        let addFromDisk = NSMenuItem(title: "  Add from Applications...", action: #selector(addAppFromDisk), keyEquivalent: "")
        addFromDisk.target = self
        menu.addItem(addFromDisk)

        menu.addItem(NSMenuItem.separator())

        // --- All windows ---
        let arrangeAll = NSMenuItem(title: "Arrange ALL in Grid", action: #selector(arrangeAllGrid), keyEquivalent: "")
        arrangeAll.target = self
        menu.addItem(arrangeAll)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    // MARK: - NSMenuDelegate

    public func menuWillOpen(_ menu: NSMenu) {
        let tc = windowManager.countWindows(category: .terminal)
        terminalCountItem.title = "  \(tc) window\(tc == 1 ? "" : "s")"
        let bc = windowManager.countWindows(category: .browser)
        browserCountItem.title = "  \(bc) window\(bc == 1 ? "" : "s")"
        let sc = windowManager.countWindows(category: .stickies)
        stickiesCountItem.title = "  \(sc) window\(sc == 1 ? "" : "s")"
        let cc = windowManager.countWindows(category: .custom)
        customCountItem.title = "  \(cc) window\(cc == 1 ? "" : "s")"

        rebuildCustomAppsSubmenu()
        rebuildAddAppSubmenu()
    }

    // MARK: - Custom Apps Submenus

    private func rebuildCustomAppsSubmenu() {
        customAppsSubmenu.removeAllItems()
        let ids = windowManager.customBundleIDs.sorted()
        if ids.isEmpty {
            let empty = NSMenuItem(title: "(none)", action: nil, keyEquivalent: "")
            empty.isEnabled = false
            customAppsSubmenu.addItem(empty)
            return
        }
        for bid in ids {
            let name = windowManager.appName(for: bid)
            let item = NSMenuItem(title: "\(name)  ✕", action: #selector(removeCustomApp(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = bid
            customAppsSubmenu.addItem(item)
        }
    }

    private func rebuildAddAppSubmenu() {
        addAppSubmenu.removeAllItems()
        let apps = windowManager.addableRunningApps()
        if apps.isEmpty {
            let empty = NSMenuItem(title: "(no new apps running)", action: nil, keyEquivalent: "")
            empty.isEnabled = false
            addAppSubmenu.addItem(empty)
            return
        }
        for app in apps {
            let item = NSMenuItem(title: app.name, action: #selector(addRunningApp(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = app.bundleID
            addAppSubmenu.addItem(item)
        }
    }

    // MARK: - Actions

    @objc private func arrangeTerminalGrid() {
        handleResult(windowManager.arrangeInGrid(category: .terminal))
    }

    @objc private func arrangeBrowserGrid() {
        handleResult(windowManager.arrangeInGrid(category: .browser))
    }

    @objc private func arrangeStickiesGrid() {
        handleResult(windowManager.arrangeInGrid(category: .stickies))
    }

    @objc private func arrangeCustomGrid() {
        if windowManager.customBundleIDs.isEmpty {
            let alert = NSAlert()
            alert.messageText = "No Custom Apps Registered"
            alert.informativeText = "Use \"Add Running App...\" or \"Add from Applications...\" to register apps."
            alert.runModal()
            return
        }
        handleResult(windowManager.arrangeInGrid(category: .custom))
    }

    @objc private func arrangeAllGrid() {
        handleResult(windowManager.arrangeInGrid(category: .all))
    }

    @objc private func addRunningApp(_ sender: NSMenuItem) {
        guard let bundleID = sender.representedObject as? String else { return }
        windowManager.addCustomApp(bundleID: bundleID)
        NSLog("[TerminalGrid] Added custom app: %{public}@", bundleID)
    }

    @objc private func removeCustomApp(_ sender: NSMenuItem) {
        guard let bundleID = sender.representedObject as? String else { return }
        windowManager.removeCustomApp(bundleID: bundleID)
        NSLog("[TerminalGrid] Removed custom app: %{public}@", bundleID)
    }

    @objc private func addAppFromDisk() {
        let panel = NSOpenPanel()
        panel.title = "Choose an Application"
        panel.allowedContentTypes = [.application]
        panel.allowsMultipleSelection = false
        panel.directoryURL = URL(fileURLWithPath: "/Applications")
        panel.canChooseDirectories = false

        guard panel.runModal() == .OK, let url = panel.url else { return }

        guard let bundle = Bundle(url: url),
              let bundleID = bundle.bundleIdentifier else {
            let alert = NSAlert()
            alert.messageText = "Invalid Application"
            alert.informativeText = "Could not read bundle identifier from the selected app."
            alert.runModal()
            return
        }

        if windowManager.builtinBundleIDs.contains(bundleID) {
            let alert = NSAlert()
            alert.messageText = "Already Built-in"
            alert.informativeText = "\(url.deletingPathExtension().lastPathComponent) is already in a built-in category."
            alert.runModal()
            return
        }

        windowManager.addCustomApp(bundleID: bundleID)
        NSLog("[TerminalGrid] Added custom app from disk: %{public}@", bundleID)
    }

    private func handleResult(_ result: String) {
        switch result {
        case "accessibility_denied":
            let alert = NSAlert()
            alert.messageText = "Accessibility Permission Required"
            alert.informativeText = "Grant access in System Settings → Privacy & Security → Accessibility, then restart the app."
            alert.addButton(withTitle: "Open Settings")
            alert.addButton(withTitle: "OK")
            if alert.runModal() == .alertFirstButtonReturn {
                NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
            }
        case "no_windows":
            let alert = NSAlert()
            alert.messageText = "No Windows Found"
            alert.informativeText = "No visible windows detected for the selected category."
            alert.runModal()
        default:
            break  // success
        }
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }

    // MARK: - Accessibility

    private func checkAccessibility() {
        let opts = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true] as CFDictionary
        if !AXIsProcessTrustedWithOptions(opts) {
            NSLog("[TerminalGrid] Accessibility permission not yet granted — system prompt shown.")
        }
    }
}
