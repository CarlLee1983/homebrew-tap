cask "vapor-git" do
  arch arm: "aarch64", intel: "x64"

  version "0.3.0"
  sha256 arm:   "93fe442c7a3090a25d5cb74a4885039fc26c138b41a16a537a2257d1e2a91efe",
         intel: "eda82fd2aa5bd4c0b5389e3ab8c51344bf88524667b9052e4aa331c1bca10626"

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
