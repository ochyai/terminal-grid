# TerminalGrid

---

## :jp: 日本語

ターミナル、ブラウザ、スティッキーズ、そして**任意のアプリ**のウィンドウをグリッド状に自動整列するmacOSメニューバーアプリ。

<!-- スクリーンショット: メニューバーアイコンとグリッド整列後の画面 -->

### 機能

- メニューバーからワンクリックでウィンドウをグリッド配置
- ターミナル / ブラウザ / スティッキーズを個別または一括で整列
- **カスタムアプリの追加**: 起動中のアプリやApplicationsフォルダから任意のアプリを登録可能
- ウィンドウ数に応じた最適なグリッドサイズを自動計算
- 最小化されたウィンドウやポップアップは自動でスキップ
- 現在のウィンドウ数をメニューにリアルタイム表示
- 登録したカスタムアプリは再起動後も保持

### 対応アプリ

**ターミナル:** Terminal, iTerm2, Alacritty, Warp, kitty, WezTerm, Ghostty, Hyper, Tabby

**ブラウザ:** Chrome, Safari, Arc, Brave, Firefox, Edge, Opera, Vivaldi

**その他:** Stickies + ユーザーが追加した任意のアプリ

### インストール

#### GitHub Releasesからダウンロード

[Releases](https://github.com/ochyai/terminal-grid/releases) から最新版をダウンロードして展開し、`TerminalGrid.app` を `/Applications` に移動してください。

#### ソースからビルド

```bash
git clone https://github.com/ochyai/terminal-grid.git
cd terminal-grid
make build
make run
```

`make install` で `/Applications` にコピーできます。

### 使い方

1. アプリを起動するとメニューバーにグリッドアイコンが表示されます
2. アイコンをクリックしてメニューを開きます
3. 各カテゴリの「Arrange ... in Grid」を選んでウィンドウを整列

#### カスタムアプリの追加

1. メニューの **CUSTOM APPS** セクションにある「Add Running App...」を開く
2. 現在起動中のアプリ一覧からグリッド整列したいアプリを選択
3. または「Add from Applications...」で `/Applications` から `.app` ファイルを選択
4. 登録済みアプリは「Registered Apps」サブメニューに表示され、クリックで削除可能

### 動作要件

- macOS 13 (Ventura) 以降
- アクセシビリティ権限

### アクセシビリティ権限について

TerminalGridは他のアプリのウィンドウ位置とサイズを操作するため、macOSのアクセシビリティ権限が必要です。初回起動時にシステムダイアログが表示されます。「システム設定 → プライバシーとセキュリティ → アクセシビリティ」でTerminalGridを許可してください。

### ライセンス

MIT

---

## :us: English

A macOS menu bar app that arranges terminal, browser, stickies, and **any custom app** windows in a grid layout.

<!-- Screenshot: menu bar icon and windows arranged in grid -->

### Features

- One-click window grid arrangement from the menu bar
- Arrange terminals, browsers, and stickies separately or all at once
- **Custom app support**: add any running app or pick from the Applications folder
- Automatically calculates optimal grid size based on window count
- Skips minimized windows and small popups
- Shows live window count in the menu
- Custom app registrations persist across restarts

### Supported Apps

**Terminals:** Terminal, iTerm2, Alacritty, Warp, kitty, WezTerm, Ghostty, Hyper, Tabby

**Browsers:** Chrome, Safari, Arc, Brave, Firefox, Edge, Opera, Vivaldi

**Other:** Stickies + any user-added apps

### Install

#### Download from GitHub Releases

Download the latest release from [Releases](https://github.com/ochyai/terminal-grid/releases), extract it, and move `TerminalGrid.app` to `/Applications`.

#### Build from source

```bash
git clone https://github.com/ochyai/terminal-grid.git
cd terminal-grid
make build
make run
```

Run `make install` to copy the app to `/Applications`.

### Usage

1. Launch the app and a grid icon appears in the menu bar
2. Click the icon to open the menu
3. Select "Arrange ... in Grid" for any category

#### Adding Custom Apps

1. Open "Add Running App..." under the **CUSTOM APPS** section in the menu
2. Pick any currently running app from the list
3. Or use "Add from Applications..." to choose a `.app` from `/Applications`
4. Registered apps appear in "Registered Apps" submenu — click to remove

### Requirements

- macOS 13 (Ventura) or later
- Accessibility permission

### Accessibility Permission

TerminalGrid requires macOS Accessibility permission to read and modify window positions and sizes of other applications. A system dialog will appear on first launch. Grant access in System Settings > Privacy & Security > Accessibility.

### License

MIT

---

## :cn: 中文

一款 macOS 菜单栏应用，可将终端、浏览器、便签及**任意自定义应用**的窗口自动排列为网格布局。

<!-- 截图：菜单栏图标与网格排列后的窗口 -->

### 功能

- 在菜单栏一键将窗口排列为网格
- 可分别或统一排列终端、浏览器和便签窗口
- **自定义应用支持**：可从正在运行的应用或 Applications 文件夹添加任意应用
- 根据窗口数量自动计算最佳网格尺寸
- 自动跳过最小化窗口和小型弹出窗口
- 在菜单中实时显示当前窗口数量
- 自定义应用注册在重启后保持

### 支持的应用

**终端：** Terminal、iTerm2、Alacritty、Warp、kitty、WezTerm、Ghostty、Hyper、Tabby

**浏览器：** Chrome、Safari、Arc、Brave、Firefox、Edge、Opera、Vivaldi

**其他：** Stickies（便签）+ 用户添加的任意应用

### 安装

#### 从 GitHub Releases 下载

从 [Releases](https://github.com/ochyai/terminal-grid/releases) 下载最新版本，解压后将 `TerminalGrid.app` 移动到 `/Applications`。

#### 从源码构建

```bash
git clone https://github.com/ochyai/terminal-grid.git
cd terminal-grid
make build
make run
```

执行 `make install` 可将应用复制到 `/Applications`。

### 使用方法

1. 启动应用后，菜单栏会出现网格图标
2. 点击图标打开菜单
3. 选择各类别的「Arrange ... in Grid」排列窗口

#### 添加自定义应用

1. 打开菜单中 **CUSTOM APPS** 下的「Add Running App...」
2. 从正在运行的应用列表中选择
3. 或使用「Add from Applications...」从 `/Applications` 选择 `.app` 文件
4. 已注册应用显示在「Registered Apps」子菜单中，点击可删除

### 系统要求

- macOS 13 (Ventura) 或更高版本
- 辅助功能权限

### 关于辅助功能权限

TerminalGrid 需要 macOS 辅助功能权限来读取和调整其他应用的窗口位置与大小。首次启动时系统会弹出授权对话框。请在「系统设置 → 隐私与安全性 → 辅助功能」中允许 TerminalGrid。

### 许可证

MIT
