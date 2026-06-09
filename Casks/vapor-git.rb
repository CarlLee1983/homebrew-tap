cask "vapor-git" do
  arch arm: "aarch64", intel: "x64"

  version "0.3.1"
  sha256 arm:   "76c1f6ba9e9eb072ef8749fe082592f5d0f821344977f011cb8777b0701bc070",
         intel: "7c38b7683c3caa1df6bb843c421eaa13877173ff8dbbeabbb4d65bc96755a8a5"

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
