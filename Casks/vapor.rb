cask "vapor" do
  arch arm: "aarch64", intel: "x64"

  version "0.2.0"
  sha256 arm:   "cef02e1b739b8fb79aeb089c1e5acc4a4dffbae8a31de8f67d091a26fd5b59ef",
         intel: "a958ce2335f85fb92edcb7a9b17c554fadbdd3bbdb02febe7824da6aa64e3b9f"

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
