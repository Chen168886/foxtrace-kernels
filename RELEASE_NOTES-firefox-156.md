# FoxTrace Firefox 156.0 内核

FoxTrace 双端环境管理器配套的定制 Firefox 内核，基于 Mozilla Firefox 156.0 源码自编译。

## 构建信息

| 项目 | 值 |
| --- | --- |
| 内核版本 | Firefox 156.0 |
| 压缩包 | `Firefox-156.0-win64-20261101.zip` |
| 压缩包大小 | 151230565 字节（约 144.2 MB） |
| 解压后体积 | 约 399 MB（8201 个文件），顶层目录 `firefox156\` |
| BuildID | `20261101194032` |
| 编译来源 | Mozilla Firefox 156.0 源码自编译（SourceStamp `a80bd15ddee3b4bf3679aeba340e9d2db933c467`） |
| 附带驱动 | geckodriver 0.37.1（与内核版本匹配） |
| 完整性校验 | 见附件 `SHA256SUMS-firefox.txt` |

## 本批次改动

### 1. 上游版本 155.0 → 156.0

156.0 是 Mozilla 改成「两周一个大版本」节奏后的中间版本，位于 155 与 157 之间。
指纹补丁在这棵树上 **12 个文件、32 个 hunk 全部干净应用、0 冲突**（行偏移 1~66 行不等，属正常漂移），
反自动化补丁 2 个 hunk 全部成功，无需任何人工改写。

### 2. 去除自动化检测特征（防检测，**必需**）

**(1) `navigator.webdriver` 恒为 `false`**

- `dom/base/Navigator.cpp` → `Navigator::Webdriver()` 改为 `return false;`
- 原实现查询 `nsIMarionette` / `nsIRemoteAgent` 的 `isBrowserAutomationRunning`，
  被 geckodriver / Marionette 驱动时返回 `true`

**(2) 去掉窗口顶部"受远程控制"标记**

- `browser/base/content/browser.js` → `gRemoteControl.updateVisualCue()` 不再写
  `remotecontrol="true"` 属性

### 3. 指纹伪装能力（与 155/157/158/159 一致）

- 屏幕尺寸 / 色深 / devicePixelRatio / 可用区域
- WebGL 厂商与渲染器（`gl.RENDERER`、`UNMASKED_*`，两条路径都过 `SanitizeRenderer`，保持自洽）
- WebGL 扩展列表（只删不加）、GL limit 钳制（只报 ≤ 真实能力）
- `readPixels` 确定性像素扰动、Canvas 2D 提取噪声
- AudioBuffer 采样噪声、ClientRects 亚像素偏移
- 环境时区 / 语言（走 BrowsingContext Field，天然跨进程）

## 验证记录

| 层 | 项目 | 结果 |
| --- | --- | --- |
| 产物扫描 | `xul.dll` 里 9 个 `foxfp.*` 标记（`enabled` / `screen.dprPercent` / `gpu.renderer` / `readpixels.seed` / `canvas.seed` / `audio.seed` / `audio.amplitudeNano` / `rects.seed` / `timezone`） | **9/9 命中** |
| 发布自检 | `firefox.js` 里 `pref("foxfp.` 注册数 | 18 条（≥12 通过） |
| 发布自检 | `browser.js` 的 remotecontrol 移除逻辑 | 存在 |
| 真机 | `navigator.webdriver`（geckodriver 驱动下） | **false**（未打补丁时应为 true） |
| 真机 | UA | `Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:156.0) Gecko/20100101 Firefox/156.0` |
| 真机 | 屏幕指纹注入（测试环境 1920×1200、dpr 1） | 页面读到 `1920×1200`、`devicePixelRatio 1` |
| 编译 | `mach build` | `rc=0`，30 分 19 秒（`-j12`），4773 个 .obj，0 error |

> 真机验证方式：管理器 API 新建一个 `kernel_version: 156.0` 的环境并启动，通过 geckodriver 会话执行
> `execute/sync` 读取 `navigator.userAgent` / `screen.*` / `window.devicePixelRatio` / `navigator.webdriver`。

## 安装

1. 解压到管理器的内核目录，得到 `firefox156\firefox.exe`
2. 管理器会自动扫描同级内核目录（`discover_firefox_binaries`）
3. 新建环境时在内核下拉里选 `156.0`；已有环境的内核字段在创建后不可改，需新建

## 说明

- 本内核**只做指纹伪装与自动化特征去除**，不改变浏览器的网络行为；代理、省流量等由管理器
  通过 `user.js` 与启动参数下发。
- 需要的 `foxfp.*` 偏好由管理器按环境写入 `user.js`，手工使用时需自行提供（见项目文档
  「Firefox内核编译交接文档」§2.1）。
- 音频噪声、Canvas 噪声的种子在未填 `foxfp.audio.seed` / `foxfp.canvas.seed` 时会按环境 ID 派生，
  同一环境跨会话稳定、不同环境互不相同。
