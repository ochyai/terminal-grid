cask "terminal-grid" do
  version "1.2.0"
  sha256 "6a3dbeb728a9e6547cd7f002dbde5c33f852b0a1b79e67c13ac8d9bdf92606e3"

  url "https://github.com/ochyai/terminal-grid/releases/download/v#{version}/TerminalGrid-v#{version}.zip"
  name "TerminalGrid"
  desc "macOS terminal grid overlay app"
  homepage "https://github.com/ochyai/terminal-grid"

  app "TerminalGrid.app"

  caveats <<~EOS
    TerminalGrid requires Accessibility permission to function properly.

    After launching, go to:
      System Settings > Privacy & Security > Accessibility
    and grant access to TerminalGrid.

    You may need to restart the app after granting permission.
  EOS
end
