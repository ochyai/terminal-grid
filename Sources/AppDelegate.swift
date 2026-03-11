import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private var statusItem: NSStatusItem!
    private let windowManager = WindowManager()
    private var terminalCountItem: NSMenuItem!
    private var browserCountItem: NSMenuItem!
    private var stickiesCountItem: NSMenuItem!

    func applicationDidFinishLaunching(_ notification: Notification) {
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

    func menuWillOpen(_ menu: NSMenu) {
        let tc = windowManager.countWindows(category: .terminal)
        terminalCountItem.title = "  \(tc) window\(tc == 1 ? "" : "s")"
        let bc = windowManager.countWindows(category: .browser)
        browserCountItem.title = "  \(bc) window\(bc == 1 ? "" : "s")"
        let sc = windowManager.countWindows(category: .stickies)
        stickiesCountItem.title = "  \(sc) window\(sc == 1 ? "" : "s")"
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

    @objc private func arrangeAllGrid() {
        handleResult(windowManager.arrangeInGrid(category: .all))
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
            alert.messageText = "No Terminal Windows Found"
            alert.informativeText = "Supported: Terminal, iTerm2, Alacritty, Warp, kitty, WezTerm, Ghostty, Hyper, Tabby"
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
        let opts = [kAXTrustedCheckOptionPrompt.takeRetainedValue(): true] as CFDictionary
        if !AXIsProcessTrustedWithOptions(opts) {
            NSLog("[TerminalGrid] Accessibility permission not yet granted — system prompt shown.")
        }
    }
}
