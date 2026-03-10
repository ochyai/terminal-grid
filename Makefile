APP_NAME    = TerminalGrid
BUILD_DIR   = .build/release
APP_BUNDLE  = $(APP_NAME).app

.PHONY: build run install clean

build:
	swift build -c release
	@mkdir -p "$(APP_BUNDLE)/Contents/MacOS"
	@mkdir -p "$(APP_BUNDLE)/Contents/Resources"
	@cp "$(BUILD_DIR)/$(APP_NAME)" "$(APP_BUNDLE)/Contents/MacOS/"
	@cp Info.plist "$(APP_BUNDLE)/Contents/"
	@echo "✓ Built $(APP_BUNDLE)"

run: build
	@open "$(APP_BUNDLE)"

install: build
	@cp -R "$(APP_BUNDLE)" /Applications/
	@echo "✓ Installed to /Applications/$(APP_BUNDLE)"

clean:
	swift package clean
	rm -rf "$(APP_BUNDLE)"
