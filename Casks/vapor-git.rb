cask "vapor-git" do
  arch arm: "aarch64", intel: "x64"

  version "0.7.0"
  sha256 arm:   "df77366f2e20371776b5ee198882471558eab74d2a5ec54441c9753240f36147",
         intel: "d47065d3cbefb05306ad4101b1c9ea9615d300e321261aa12caffe6fe53c61f4"

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
