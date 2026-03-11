import XCTest
@testable import TerminalGridLib

final class GridSizeTests: XCTestCase {

    private var wm: WindowManager!

    override func setUp() {
        super.setUp()
        wm = WindowManager()
    }

    // MARK: - gridSize(for:) basic cases

    func testGridSize_0_returns1x1() {
        // 0 windows: guard count > 1 returns (1,1)
        let result = wm.gridSize(for: 0)
        XCTAssertEqual(result.cols, 1)
        XCTAssertEqual(result.rows, 1)
    }

    func testGridSize_1_returns1x1() {
        let result = wm.gridSize(for: 1)
        XCTAssertEqual(result.cols, 1)
        XCTAssertEqual(result.rows, 1)
    }

    func testGridSize_2_returns2x1() {
        let result = wm.gridSize(for: 2)
        // ceil(sqrt(2)) = 2, ceil(2/2) = 1
        XCTAssertEqual(result.cols, 2)
        XCTAssertEqual(result.rows, 1)
    }

    func testGridSize_3_returns2x2() {
        let result = wm.gridSize(for: 3)
        // ceil(sqrt(3)) = 2, ceil(3/2) = 2
        XCTAssertEqual(result.cols, 2)
        XCTAssertEqual(result.rows, 2)
    }

    func testGridSize_4_returns2x2() {
        let result = wm.gridSize(for: 4)
        // ceil(sqrt(4)) = 2, ceil(4/2) = 2
        XCTAssertEqual(result.cols, 2)
        XCTAssertEqual(result.rows, 2)
    }

    func testGridSize_5_returns3x2() {
        let result = wm.gridSize(for: 5)
        // ceil(sqrt(5)) = 3, ceil(5/3) = 2
        XCTAssertEqual(result.cols, 3)
        XCTAssertEqual(result.rows, 2)
    }

    func testGridSize_6_returns3x2() {
        let result = wm.gridSize(for: 6)
        // ceil(sqrt(6)) = 3, ceil(6/3) = 2
        XCTAssertEqual(result.cols, 3)
        XCTAssertEqual(result.rows, 2)
    }

    func testGridSize_7_returns3x3() {
        let result = wm.gridSize(for: 7)
        // ceil(sqrt(7)) = 3, ceil(7/3) = 3
        XCTAssertEqual(result.cols, 3)
        XCTAssertEqual(result.rows, 3)
    }

    func testGridSize_8_returns3x3() {
        let result = wm.gridSize(for: 8)
        // ceil(sqrt(8)) = 3, ceil(8/3) = 3
        XCTAssertEqual(result.cols, 3)
        XCTAssertEqual(result.rows, 3)
    }

    func testGridSize_9_returns3x3() {
        let result = wm.gridSize(for: 9)
        // ceil(sqrt(9)) = 3, ceil(9/3) = 3
        XCTAssertEqual(result.cols, 3)
        XCTAssertEqual(result.rows, 3)
    }

    func testGridSize_10_returns4x3() {
        let result = wm.gridSize(for: 10)
        // ceil(sqrt(10)) = 4, ceil(10/4) = 3
        XCTAssertEqual(result.cols, 4)
        XCTAssertEqual(result.rows, 3)
    }

    func testGridSize_11_returns4x3() {
        let result = wm.gridSize(for: 11)
        XCTAssertEqual(result.cols, 4)
        XCTAssertEqual(result.rows, 3)
    }

    func testGridSize_12_returns4x3() {
        let result = wm.gridSize(for: 12)
        XCTAssertEqual(result.cols, 4)
        XCTAssertEqual(result.rows, 3)
    }

    func testGridSize_13_returns4x4() {
        let result = wm.gridSize(for: 13)
        // ceil(sqrt(13)) = 4, ceil(13/4) = 4
        XCTAssertEqual(result.cols, 4)
        XCTAssertEqual(result.rows, 4)
    }

    func testGridSize_14_returns4x4() {
        let result = wm.gridSize(for: 14)
        XCTAssertEqual(result.cols, 4)
        XCTAssertEqual(result.rows, 4)
    }

    func testGridSize_15_returns4x4() {
        let result = wm.gridSize(for: 15)
        XCTAssertEqual(result.cols, 4)
        XCTAssertEqual(result.rows, 4)
    }

    func testGridSize_16_returns4x4() {
        let result = wm.gridSize(for: 16)
        XCTAssertEqual(result.cols, 4)
        XCTAssertEqual(result.rows, 4)
    }

    func testGridSize_17_returns5x4() {
        let result = wm.gridSize(for: 17)
        // ceil(sqrt(17)) = 5, ceil(17/5) = 4
        XCTAssertEqual(result.cols, 5)
        XCTAssertEqual(result.rows, 4)
    }

    func testGridSize_18_returns5x4() {
        let result = wm.gridSize(for: 18)
        XCTAssertEqual(result.cols, 5)
        XCTAssertEqual(result.rows, 4)
    }

    func testGridSize_19_returns5x4() {
        let result = wm.gridSize(for: 19)
        XCTAssertEqual(result.cols, 5)
        XCTAssertEqual(result.rows, 4)
    }

    func testGridSize_20_returns5x4() {
        let result = wm.gridSize(for: 20)
        XCTAssertEqual(result.cols, 5)
        XCTAssertEqual(result.rows, 4)
    }

    // MARK: - gridSize properties: cols*rows always >= count

    func testGridSize_allWindowsFit_1to100() {
        for count in 1...100 {
            let result = wm.gridSize(for: count)
            XCTAssertGreaterThanOrEqual(
                result.cols * result.rows, count,
                "Grid \(result.cols)x\(result.rows) cannot hold \(count) windows"
            )
        }
    }

    // MARK: - gridSize: cols >= rows (wider layout)

    func testGridSize_colsGreaterOrEqualRows_1to100() {
        for count in 1...100 {
            let result = wm.gridSize(for: count)
            XCTAssertGreaterThanOrEqual(
                result.cols, result.rows,
                "For count=\(count), cols (\(result.cols)) should be >= rows (\(result.rows))"
            )
        }
    }

    // MARK: - Large numbers

    func testGridSize_100_returns10x10() {
        let result = wm.gridSize(for: 100)
        XCTAssertEqual(result.cols, 10)
        XCTAssertEqual(result.rows, 10)
    }

    func testGridSize_1000() {
        let result = wm.gridSize(for: 1000)
        // ceil(sqrt(1000)) = 32, ceil(1000/32) = 32
        XCTAssertEqual(result.cols, 32)
        XCTAssertEqual(result.rows, 32)
        XCTAssertGreaterThanOrEqual(result.cols * result.rows, 1000)
    }

    // MARK: - Negative count (defensive)

    func testGridSize_negative_returns1x1() {
        // Negative numbers should be handled gracefully by the guard
        let result = wm.gridSize(for: -1)
        XCTAssertEqual(result.cols, 1)
        XCTAssertEqual(result.rows, 1)
    }
}

// MARK: - AppCategory Tests

final class AppCategoryTests: XCTestCase {

    func testAllCategoriesExist() {
        // Verify all expected cases are present
        let categories: [WindowManager.AppCategory] = [
            .terminal, .browser, .stickies, .all
        ]
        XCTAssertEqual(categories.count, 4)
    }

    func testCategoryRawValues() {
        XCTAssertEqual(WindowManager.AppCategory.terminal.rawValue, "Terminal")
        XCTAssertEqual(WindowManager.AppCategory.browser.rawValue, "Browser")
        XCTAssertEqual(WindowManager.AppCategory.stickies.rawValue, "Stickies")
        XCTAssertEqual(WindowManager.AppCategory.all.rawValue, "All")
    }

    func testCategoryIsCaseIterable() {
        // Verify CaseIterable conformance covers all 4 cases
        let allCases = WindowManager.AppCategory.allCases
        XCTAssertEqual(allCases.count, 4)
        XCTAssertTrue(allCases.contains(.terminal))
        XCTAssertTrue(allCases.contains(.browser))
        XCTAssertTrue(allCases.contains(.stickies))
        XCTAssertTrue(allCases.contains(.all))
    }
}

// MARK: - Bundle ID Tests

final class BundleIDTests: XCTestCase {

    private var wm: WindowManager!

    override func setUp() {
        super.setUp()
        wm = WindowManager()
    }

    // MARK: - Terminal bundle IDs

    func testTerminalBundleIDs_containsAppleTerminal() {
        XCTAssertTrue(wm.terminalBundleIDs.contains("com.apple.Terminal"))
    }

    func testTerminalBundleIDs_containsITerm2() {
        XCTAssertTrue(wm.terminalBundleIDs.contains("com.googlecode.iterm2"))
    }

    func testTerminalBundleIDs_containsAlacritty() {
        XCTAssertTrue(wm.terminalBundleIDs.contains("org.alacritty"))
    }

    func testTerminalBundleIDs_containsWarp() {
        XCTAssertTrue(wm.terminalBundleIDs.contains("dev.warp.Warp-Stable"))
    }

    func testTerminalBundleIDs_containsKitty() {
        XCTAssertTrue(wm.terminalBundleIDs.contains("net.kovidgoyal.kitty"))
    }

    func testTerminalBundleIDs_containsWezTerm() {
        XCTAssertTrue(wm.terminalBundleIDs.contains("com.github.wez.wezterm"))
    }

    func testTerminalBundleIDs_containsHyper() {
        XCTAssertTrue(wm.terminalBundleIDs.contains("co.zeit.hyper"))
    }

    func testTerminalBundleIDs_containsGhostty() {
        XCTAssertTrue(wm.terminalBundleIDs.contains("com.mitchellh.ghostty"))
    }

    func testTerminalBundleIDs_containsTabby() {
        XCTAssertTrue(wm.terminalBundleIDs.contains("io.tabby"))
    }

    func testTerminalBundleIDs_count() {
        XCTAssertEqual(wm.terminalBundleIDs.count, 9)
    }

    // MARK: - Browser bundle IDs

    func testBrowserBundleIDs_containsChrome() {
        XCTAssertTrue(wm.browserBundleIDs.contains("com.google.Chrome"))
    }

    func testBrowserBundleIDs_containsChromeCanary() {
        XCTAssertTrue(wm.browserBundleIDs.contains("com.google.Chrome.canary"))
    }

    func testBrowserBundleIDs_containsBrave() {
        XCTAssertTrue(wm.browserBundleIDs.contains("com.brave.Browser"))
    }

    func testBrowserBundleIDs_containsEdge() {
        XCTAssertTrue(wm.browserBundleIDs.contains("com.microsoft.edgemac"))
    }

    func testBrowserBundleIDs_containsVivaldi() {
        XCTAssertTrue(wm.browserBundleIDs.contains("com.vivaldi.Vivaldi"))
    }

    func testBrowserBundleIDs_containsArc() {
        XCTAssertTrue(wm.browserBundleIDs.contains("company.thebrowser.Browser"))
    }

    func testBrowserBundleIDs_containsFirefox() {
        XCTAssertTrue(wm.browserBundleIDs.contains("org.mozilla.firefox"))
    }

    func testBrowserBundleIDs_containsOpera() {
        XCTAssertTrue(wm.browserBundleIDs.contains("com.operasoftware.Opera"))
    }

    func testBrowserBundleIDs_containsSafari() {
        XCTAssertTrue(wm.browserBundleIDs.contains("com.apple.Safari"))
    }

    func testBrowserBundleIDs_count() {
        XCTAssertEqual(wm.browserBundleIDs.count, 9)
    }

    // MARK: - Stickies bundle IDs

    func testStickiesBundleIDs_containsAppleStickies() {
        XCTAssertTrue(wm.stickiesBundleIDs.contains("com.apple.Stickies"))
    }

    func testStickiesBundleIDs_count() {
        XCTAssertEqual(wm.stickiesBundleIDs.count, 1)
    }

    // MARK: - bundleIDs(for:) routing

    func testBundleIDsForTerminal_returnsTerminalSet() {
        XCTAssertEqual(wm.bundleIDs(for: .terminal), wm.terminalBundleIDs)
    }

    func testBundleIDsForBrowser_returnsBrowserSet() {
        XCTAssertEqual(wm.bundleIDs(for: .browser), wm.browserBundleIDs)
    }

    func testBundleIDsForStickies_returnsStickiesSet() {
        XCTAssertEqual(wm.bundleIDs(for: .stickies), wm.stickiesBundleIDs)
    }

    func testBundleIDsForAll_returnsUnionOfAllSets() {
        let allIDs = wm.bundleIDs(for: .all)
        let expectedUnion = wm.terminalBundleIDs
            .union(wm.browserBundleIDs)
            .union(wm.stickiesBundleIDs)
        XCTAssertEqual(allIDs, expectedUnion)
    }

    func testBundleIDsForAll_containsEveryTerminalID() {
        let allIDs = wm.bundleIDs(for: .all)
        for id in wm.terminalBundleIDs {
            XCTAssertTrue(allIDs.contains(id), "All category missing terminal ID: \(id)")
        }
    }

    func testBundleIDsForAll_containsEveryBrowserID() {
        let allIDs = wm.bundleIDs(for: .all)
        for id in wm.browserBundleIDs {
            XCTAssertTrue(allIDs.contains(id), "All category missing browser ID: \(id)")
        }
    }

    func testBundleIDsForAll_containsEveryStickiesID() {
        let allIDs = wm.bundleIDs(for: .all)
        for id in wm.stickiesBundleIDs {
            XCTAssertTrue(allIDs.contains(id), "All category missing stickies ID: \(id)")
        }
    }

    func testBundleIDsForAll_countEqualsSum() {
        // No overlap expected between terminal, browser, and stickies sets
        let allIDs = wm.bundleIDs(for: .all)
        let expectedCount = wm.terminalBundleIDs.count
            + wm.browserBundleIDs.count
            + wm.stickiesBundleIDs.count
        XCTAssertEqual(allIDs.count, expectedCount,
                       "Bundle ID sets should not overlap")
    }

    // MARK: - No overlap between categories

    func testTerminalAndBrowser_noOverlap() {
        let overlap = wm.terminalBundleIDs.intersection(wm.browserBundleIDs)
        XCTAssertTrue(overlap.isEmpty,
                      "Terminal and browser sets should not overlap: \(overlap)")
    }

    func testTerminalAndStickies_noOverlap() {
        let overlap = wm.terminalBundleIDs.intersection(wm.stickiesBundleIDs)
        XCTAssertTrue(overlap.isEmpty,
                      "Terminal and stickies sets should not overlap: \(overlap)")
    }

    func testBrowserAndStickies_noOverlap() {
        let overlap = wm.browserBundleIDs.intersection(wm.stickiesBundleIDs)
        XCTAssertTrue(overlap.isEmpty,
                      "Browser and stickies sets should not overlap: \(overlap)")
    }

    // MARK: - Negative: unknown bundle IDs not present

    func testTerminalBundleIDs_doesNotContainBrowser() {
        XCTAssertFalse(wm.terminalBundleIDs.contains("com.google.Chrome"))
    }

    func testBrowserBundleIDs_doesNotContainTerminal() {
        XCTAssertFalse(wm.browserBundleIDs.contains("com.apple.Terminal"))
    }
}
