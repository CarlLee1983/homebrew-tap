cask "vapor-git" do
  arch arm: "aarch64", intel: "x64"

  version "0.9.0"
  sha256 arm:   "8a75d1e1499bebf9a3917390e0cfbd542cbddc67fa7c04036078722d4b463c18",
         intel: "bdad5e8d950eaed54e731882e961056c3949f416fad20208ccdb43f0f16a3910"

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

  # Vapor is only ad-hoc signed (no Apple Developer ID / notarization), so on
  # Apple Silicon + recent macOS a quarantined build is reported as "damaged"
  # with no "Open Anyway" path. Strip the quarantine flag on install so the
  # app launches normally. The app installs under the user-owned appdir, so no
  # sudo is required.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Vapor.app"]
  end

  zap trash: [
    "~/Library/Application Support/com.vapor.app",
    "~/Library/Caches/com.vapor.app",
    "~/Library/HTTPStorages/com.vapor.app",
    "~/Library/Preferences/com.vapor.app.plist",
    "~/Library/Saved Application State/com.vapor.app.savedState",
  ]

  caveats <<~EOS
    Vapor is ad-hoc signed and not notarized by Apple. This cask clears the
    quarantine flag on install so it launches normally; you should not see a
    Gatekeeper "damaged" prompt. If macOS ever still blocks it, run:

      xattr -dr com.apple.quarantine "#{appdir}/Vapor.app"

    Vapor wraps the system `git`; make sure `git` is installed and on PATH.
  EOS
end
