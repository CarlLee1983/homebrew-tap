class Glance < Formula
  desc "Native macOS menu-bar system monitor with a companion CLI"
  homepage "https://github.com/CarlLee1983/Glance"
  url "https://github.com/CarlLee1983/Glance.git",
      tag:      "v0.3.3",
      revision: "2b736b8c88495bb6188e3b59ec50e733e7f80e9d"
  license "MIT"

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  def install
    # brew 自身的 sandbox-exec 內,swiftpm/xcodebuild 會再套一層 sandbox 導致
    # sandbox_apply: Operation not permitted。改為純 swift build(--disable-sandbox)
    # 編出 app 與 cli,再手動組成 .app bundle,完全避開 xcodebuild 解析套件的 nested sandbox。
    # swiftpm/xcodebuild nest a sandbox inside brew's, which fails; build with
    # --disable-sandbox and assemble the .app by hand to avoid it entirely.
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/glance-cli"

    app = prefix/"Glance.app"
    (app/"Contents/MacOS").mkpath
    cp ".build/release/Glance", app/"Contents/MacOS/Glance"
    (app/"Contents/Info.plist").write <<~PLIST
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>LSUIElement</key><true/>
        <key>CFBundleExecutable</key><string>Glance</string>
        <key>CFBundleName</key><string>Glance</string>
        <key>CFBundleIdentifier</key><string>com.carl.glance</string>
        <key>CFBundlePackageType</key><string>APPL</string>
        <key>CFBundleShortVersionString</key><string>#{version}</string>
        <key>CFBundleVersion</key><string>1</string>
        <key>LSMinimumSystemVersion</key><string>14.0</string>
        <key>NSHighResolutionCapable</key><true/>
      </dict>
      </plist>
    PLIST

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
