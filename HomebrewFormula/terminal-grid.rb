cask "terminal-grid" do
  version "1.0.0"
  sha256 "0115edbb3423d4ca09ac951ca7fb4b8d1b18e304ac1652916d9538e1663a1639"

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
