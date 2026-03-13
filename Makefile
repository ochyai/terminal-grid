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
	@NEW_HASH=$$(md5 -q "$(BUILD_DIR)/$(APP_NAME)"); \
	OLD_HASH=$$(cat .build_hash 2>/dev/null || echo ""); \
	if [ "$$NEW_HASH" != "$$OLD_HASH" ]; then \
		cp "$(BUILD_DIR)/$(APP_NAME)" "$(APP_BUNDLE)/Contents/MacOS/"; \
		cp Info.plist "$(APP_BUNDLE)/Contents/"; \
		codesign --force --sign - "$(APP_BUNDLE)"; \
		echo "$$NEW_HASH" > .build_hash; \
		echo "✓ Built & signed $(APP_BUNDLE) (re-grant Accessibility if needed)"; \
	else \
		cp Info.plist "$(APP_BUNDLE)/Contents/"; \
		echo "✓ Built (binary unchanged, signature preserved)"; \
	fi

run: build
	@-pkill -f "$(APP_NAME)" 2>/dev/null; sleep 0.5
	@open "$(APP_BUNDLE)"
	@echo "✓ Launched — grant Accessibility permission if prompted"

# Use this only when you want to force-reset accessibility permission
reset-accessibility:
	tccutil reset Accessibility $(BUNDLE_ID)
	@echo "✓ Reset accessibility permission for $(BUNDLE_ID)"

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
