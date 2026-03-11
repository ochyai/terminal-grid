APP_NAME    = TerminalGrid
BUNDLE_ID   = com.ochyai.terminal-grid
BUILD_DIR   = .build/release
APP_BUNDLE  = $(APP_NAME).app
VERSION     = $(shell /usr/libexec/PlistBuddy -c "Print CFBundleVersion" Info.plist)
RELEASE_ZIP = $(APP_NAME)-v$(VERSION).zip
RELEASE_DMG = $(APP_NAME)-v$(VERSION).dmg

.PHONY: build run install clean release dmg gh-release

# ── Build & sign ──────────────────────────────────────────────

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
	rm -f $(APP_NAME)-v*.zip $(APP_NAME)-v*.dmg

# ── Release packaging ────────────────────────────────────────

release: build
	@rm -f "$(RELEASE_ZIP)"
	ditto -c -k --sequesterRsrc --keepParent "$(APP_BUNDLE)" "$(RELEASE_ZIP)"
	@echo "✓ Created $(RELEASE_ZIP) ($$(du -h "$(RELEASE_ZIP)" | cut -f1))"

dmg: build
	@rm -f "$(RELEASE_DMG)"
	hdiutil create -volname "$(APP_NAME)" \
		-srcfolder "$(APP_BUNDLE)" \
		-ov -format UDZO \
		"$(RELEASE_DMG)"
	@echo "✓ Created $(RELEASE_DMG) ($$(du -h "$(RELEASE_DMG)" | cut -f1))"

# ── GitHub release ────────────────────────────────────────────

gh-release: release dmg
	@echo "Creating GitHub release v$(VERSION)..."
	gh release create "v$(VERSION)" \
		"$(RELEASE_ZIP)" \
		"$(RELEASE_DMG)" \
		--title "$(APP_NAME) v$(VERSION)" \
		--notes "Release v$(VERSION) of $(APP_NAME)." \
		--draft
	@echo "✓ Draft release v$(VERSION) created — review and publish on GitHub"
