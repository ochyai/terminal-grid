APP_NAME    = TerminalGrid
BUNDLE_ID   = com.ochyai.terminal-grid
BUILD_DIR   = .build/release
APP_BUNDLE  = $(APP_NAME).app

.PHONY: build run install clean

build:
	swift build -c release
	@mkdir -p "$(APP_BUNDLE)/Contents/MacOS"
	@mkdir -p "$(APP_BUNDLE)/Contents/Resources"
	@cp "$(BUILD_DIR)/$(APP_NAME)" "$(APP_BUNDLE)/Contents/MacOS/"
	@cp Info.plist "$(APP_BUNDLE)/Contents/"
	@codesign --force --sign - "$(APP_BUNDLE)"
	@echo "✓ Built & signed $(APP_BUNDLE)"

run: build
	@-pkill -f "$(APP_NAME)" 2>/dev/null; sleep 0.5
	@tccutil reset Accessibility $(BUNDLE_ID) 2>/dev/null; true
	@open "$(APP_BUNDLE)"
	@echo "✓ Launched — grant Accessibility permission if prompted"

install: build
	@cp -R "$(APP_BUNDLE)" /Applications/
	@echo "✓ Installed to /Applications/$(APP_BUNDLE)"

clean:
	swift package clean
	rm -rf "$(APP_BUNDLE)"
