import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private var statusItem: NSStatusItem!
    private let windowManager = WindowManager()
    private var windowCountItem: NSMenuItem!

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

        let arrangeItem = NSMenuItem(
            title: "Arrange in Grid",
            action: #selector(arrangeGrid),
            keyEquivalent: ""
        )
        arrangeItem.target = self
        menu.addItem(arrangeItem)

        menu.addItem(NSMenuItem.separator())

        // Column presets submenu
        let columnsMenu = NSMenu()
        for n in 2...5 {
            let item = NSMenuItem(
                title: "\(n) Columns",
                action: #selector(arrangeWithColumns(_:)),
                keyEquivalent: ""
            )
            item.target = self
            item.tag = n
            columnsMenu.addItem(item)
        }
        let columnsItem = NSMenuItem(title: "Fixed Columns", action: nil, keyEquivalent: "")
        columnsItem.submenu = columnsMenu
        menu.addItem(columnsItem)

        menu.addItem(NSMenuItem.separator())

        windowCountItem = NSMenuItem(title: "Scanning...", action: nil, keyEquivalent: "")
        windowCountItem.isEnabled = false
        menu.addItem(windowCountItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    // MARK: - NSMenuDelegate

    func menuWillOpen(_ menu: NSMenu) {
        let count = windowManager.countTerminalWindows()
        windowCountItem.title = "\(count) terminal window\(count == 1 ? "" : "s") detected"
    }

    // MARK: - Actions

    @objc private func arrangeGrid() {
        windowManager.arrangeInGrid()
    }

    @objc private func arrangeWithColumns(_ sender: NSMenuItem) {
        windowManager.arrangeInGrid(forcedColumns: sender.tag)
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
