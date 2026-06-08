cask "vapor" do
  arch arm: "aarch64", intel: "x64"

  version "0.1.0"
  sha256 arm:   "0ca36ea74529cb08f03d00b4582fcfbfe9a7993638e1709366adbdd03cf31669",
         intel: "5c184127fa6d46753ec1013efc906a106893b9e01e39fc85fa5cb55f9c9adc9b"

  url "https://github.com/CarlLee1983/Vapor/releases/download/v#{version}/Vapor_#{version}_#{arch}.dmg"
  name "Vapor"
  desc "Lightweight desktop Git workbench (Tauri + React + Rust)"
  homepage "https://github.com/CarlLee1983/Vapor"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :catalina

  app "Vapor.app"

  zap trash: [
    "~/Library/Application Support/com.vapor.app",
    "~/Library/Caches/com.vapor.app",
    "~/Library/HTTPStorages/com.vapor.app",
    "~/Library/Preferences/com.vapor.app.plist",
    "~/Library/Saved Application State/com.vapor.app.savedState",
  ]

  caveats <<~EOS
    Vapor is ad-hoc signed and not notarized by Apple, so Gatekeeper
    blocks the first launch. After installing, clear the quarantine flag once:

      xattr -dr com.apple.quarantine "#{appdir}/Vapor.app"

    (Or open it the first time via System Settings > Privacy & Security >
    "Open Anyway".)

    Vapor wraps the system `git`; make sure `git` is installed and on PATH.
  EOS
end
