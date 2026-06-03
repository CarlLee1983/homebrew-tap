# homebrew-tap

[claude-context-statusline](https://github.com/CarlLee1983/claude-context-statusline) 工具集的 Homebrew tap。
Homebrew tap for the [claude-context-statusline](https://github.com/CarlLee1983/claude-context-statusline) toolkit.

```bash
brew tap CarlLee1983/tap
brew install ctx-statusline ai-usage-monitor swiftbar-ai-usage
```

| Formula | 說明 / What |
|---------|-------------|
| `ctx-statusline` | Claude Code 狀態列：目前 session 的 context window 用量 |
| `ai-usage-monitor` | 原生 macOS 選單列 App：Claude / Codex / Antigravity 速率限制（從源碼 build） |
| `swiftbar-ai-usage` | SwiftBar 外掛：同樣的速率限制資訊 |

安裝後各自跑一次設定（`brew install` 不會改你的設定檔）：
After install, run each tool's one-time setup (install never touches your config):

```bash
ctx-statusline-setup     # 併入 ~/.claude/settings.json，再重開 Claude Code session
ai-usage-monitor         # 首次執行把 App 裝到 ~/Applications 並啟動
# swiftbar-ai-usage：依 brew caveats 把外掛 symlink 進 SwiftBar plugins 目錄
```

三個 formula 皆從源碼建置（無需簽章/公證）。formula 由上游 `Scripts/release.sh` 自動發布。
All formulae build from source (no signing/notarization); published by the upstream `Scripts/release.sh`.

## 授權 / License

[MIT](https://github.com/CarlLee1983/claude-context-statusline/blob/main/LICENSE)
