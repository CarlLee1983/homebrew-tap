class SwiftbarAiUsage < Formula
  desc "SwiftBar plugin for Claude/Codex/Antigravity rate-limit headroom"
  homepage "https://github.com/CarlLee1983/claude-context-statusline"
  url "https://github.com/CarlLee1983/claude-context-statusline/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "05852f05824848bd6b4ebbb0619f6567e8743b8ba225311e891f78ee8998c2c1"
  license "MIT"

  def install
    libexec.install "swiftbar/ai-usage.60s.py"
  end

  def caveats
    <<~EOS
      This is a SwiftBar plugin (requires SwiftBar: brew install --cask swiftbar).
      Symlink it into your SwiftBar plugin folder, then refresh SwiftBar:
        ln -sf "#{opt_libexec}/ai-usage.60s.py" \\
          "$HOME/Library/Application Support/SwiftBar/Plugins/ai-usage.60s.py"
      Optional: `/usr/bin/python3 -m pip install Pillow` for capsule icons (falls back to text otherwise).
    EOS
  end

  test do
    output = shell_output("/usr/bin/python3 #{libexec}/ai-usage.60s.py")
    refute_empty output
  end
end
