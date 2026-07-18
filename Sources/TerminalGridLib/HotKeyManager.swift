import AppKit
import Carbon.HIToolbox

/// Registers system-wide keyboard shortcuts via the Carbon hotkey API.
/// Works regardless of which app is frontmost.
public final class HotKeyManager {

    public struct Shortcut {
        public let keyCode: UInt32
        public let carbonModifiers: UInt32

        public init(keyCode: UInt32, carbonModifiers: UInt32) {
            self.keyCode = keyCode
            self.carbonModifiers = carbonModifiers
        }

        /// ⌃⌥⌘ + key
        public static func controlOptionCommand(keyCode: UInt32) -> Shortcut {
            Shortcut(keyCode: keyCode, carbonModifiers: UInt32(controlKey | optionKey | cmdKey))
        }
    }

    private var hotKeyRefs: [EventHotKeyRef] = []
    private var handlers: [UInt32: () -> Void] = [:]
    private var eventHandler: EventHandlerRef?
    private var nextID: UInt32 = 1

    public init() {}

    deinit {
        for ref in hotKeyRefs {
            UnregisterEventHotKey(ref)
        }
        if let eventHandler {
            RemoveEventHandler(eventHandler)
        }
    }

    @discardableResult
    public func register(_ shortcut: Shortcut, handler: @escaping () -> Void) -> Bool {
        installHandlerIfNeeded()

        let hotKeyID = EventHotKeyID(signature: OSType(0x54474844) /* 'TGHD' */, id: nextID)
        var ref: EventHotKeyRef?
        let status = RegisterEventHotKey(
            shortcut.keyCode,
            shortcut.carbonModifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &ref
        )
        guard status == noErr, let ref else {
            NSLog("[TerminalGrid] RegisterEventHotKey failed: %d", status)
            return false
        }
        handlers[nextID] = handler
        hotKeyRefs.append(ref)
        nextID += 1
        return true
    }

    private func installHandlerIfNeeded() {
        guard eventHandler == nil else { return }

        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )
        InstallEventHandler(
            GetApplicationEventTarget(),
            { _, event, userData -> OSStatus in
                guard let userData, let event else { return noErr }
                let manager = Unmanaged<HotKeyManager>.fromOpaque(userData).takeUnretainedValue()
                var hotKeyID = EventHotKeyID()
                let err = GetEventParameter(
                    event,
                    EventParamName(kEventParamDirectObject),
                    EventParamType(typeEventHotKeyID),
                    nil,
                    MemoryLayout<EventHotKeyID>.size,
                    nil,
                    &hotKeyID
                )
                guard err == noErr else { return noErr }
                DispatchQueue.main.async {
                    manager.handlers[hotKeyID.id]?()
                }
                return noErr
            },
            1,
            &eventType,
            Unmanaged.passUnretained(self).toOpaque(),
            &eventHandler
        )
    }
}
