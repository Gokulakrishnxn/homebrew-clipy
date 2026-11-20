# Homebrew cask for Clipy.
#
# Lives in the tap repo `Gokulakrishnxn/homebrew-clipy` at `Casks/clipy.rb`
# (this copy in the app repo is the source of truth; the release workflow
# pushes it to the tap with the version/sha256 filled in).
#
#   brew install --cask gokulakrishnxn/clipy/clipy   (fully qualified ⇒ trusted on Homebrew ≥ 6)
#
# Always use the fully-qualified name: Homebrew's own catalog has an unrelated
# cask called "clipy" (the original Clipy app).
cask "clipy" do
  version "0.3.2"
  sha256 "1628791d32c406af822eb6e9ca791793c227777548f9e22729a2ef95b1b6db92"

  url "https://github.com/Gokulakrishnxn/Clipy/releases/download/v#{version}/Clipy-#{version}.dmg",
      verified: "github.com/Gokulakrishnxn/Clipy/"
  name "Clipy"
  desc "Menu-bar clipboard manager with category tabs and offline smart actions"
  homepage "https://github.com/Gokulakrishnxn/Clipy"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates false
  depends_on macos: ">= :sonoma"

  app "Clipy.app"

  # The DMG is ad-hoc signed (no Apple Developer ID yet), so Gatekeeper would
  # otherwise refuse to open it. Stripping the quarantine attribute is what
  # `xattr -cr` in the README does, automated.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Clipy.app"],
                   sudo: false
  end

  uninstall quit:       "com.gokulakrishnxn.clipy",
            launchctl:  "com.gokulakrishnxn.clipy"

  zap trash: [
    "~/Library/Application Support/Clipy",
    "~/Library/Caches/com.gokulakrishnxn.clipy",
    "~/Library/HTTPStorages/com.gokulakrishnxn.clipy",
    "~/Library/Preferences/com.gokulakrishnxn.clipy.plist",
    "~/Library/Saved Application State/com.gokulakrishnxn.clipy.savedState",
  ]

  caveats <<~EOS
    Clipy lives in the menu bar. Press ⇧⌘V to open it (change it in Preferences).

    To let Clipy paste directly into other apps, grant it Accessibility
    access the first time it asks:
      System Settings → Privacy & Security → Accessibility → Clipy
  EOS
end
