class Glance < Formula
  desc "Native macOS menu-bar system monitor with a companion CLI"
  homepage "https://github.com/CarlLee1983/Glance"
  url "https://github.com/CarlLee1983/Glance.git",
      tag:      "v0.1.0",
      revision: "8d91170b45f12bd3b5b4f248f68771a260d67191"
  license "MIT"

  depends_on xcode: ["16.0", :build]
  depends_on "xcodegen" => :build
  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--product", "glance-cli"
    bin.install ".build/release/glance-cli"

    system "xcodegen", "generate"
    xcodebuild "-project", "Glance.xcodeproj",
               "-scheme", "Glance",
               "-configuration", "Release",
               "-derivedDataPath", buildpath/".build/xcode-derived",
               "CODE_SIGNING_ALLOWED=NO",
               "CODE_SIGNING_REQUIRED=NO",
               "CODE_SIGN_IDENTITY=-",
               "build"
    prefix.install ".build/xcode-derived/Build/Products/Release/Glance.app"

    (bin/"glance").write <<~EOS
      #!/bin/bash
      set -euo pipefail
      SRC="#{opt_prefix}/Glance.app"
      DEST="$HOME/Applications/Glance.app"
      BIN="Contents/MacOS/Glance"
      mkdir -p "$HOME/Applications"
      if [ ! -d "$DEST" ] || [ "$SRC/$BIN" -nt "$DEST/$BIN" ]; then
        osascript -e 'tell application "Glance" to quit' 2>/dev/null || true
        pkill -x Glance 2>/dev/null || true
        rm -rf "$DEST"
        cp -R "$SRC" "$DEST"
      fi
      open "$DEST"
    EOS
    chmod 0755, bin/"glance"
  end

  def caveats
    <<~EOS
      Launch the menu-bar app (first run installs it to ~/Applications):
        glance
      Print a one-shot system snapshot in Terminal:
        glance-cli
      After `brew upgrade`, run `glance` again to refresh the app copy.
    EOS
  end

  test do
    assert_predicate prefix/"Glance.app/Contents/MacOS/Glance", :executable?
    assert_predicate bin/"glance", :executable?
    assert_predicate bin/"glance-cli", :executable?
  end
end
