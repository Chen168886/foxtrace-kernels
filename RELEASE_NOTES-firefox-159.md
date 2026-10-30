# FoxTrace Firefox 159.0 内核

FoxTrace 双端环境管理器配套的定制 Firefox 内核，基于 Mozilla Firefox 159.0 源码自编译。

## 构建信息

| 项目 | 值 |
| --- | --- |
| 内核版本 | Firefox 159.0 |
| 压缩包 | `Firefox-159.0-win64-20261030.zip` |
| 压缩包大小 | 152391941 字节（约 145.3 MB） |
| 解压后体积 | 约 398 MB（8280 个条目），顶层目录 `firefox159\` |
| BuildID | `20261030113449` |
| 编译来源 | Mozilla Firefox 159.0 源码自编译（SourceStamp `5add844c26613d7e4d84c799d6e23cf987b1240d`） |
| 附带驱动 | geckodriver 0.37.1（与内核版本匹配） |
| 完整性校验 | 见附件 `SHA256SUMS-firefox.txt` |

## 本批次改动

### 1. 上游版本 157.0.1 → 159.0

跨 2 个大版本（Mozilla 自 155 起把发布节奏改为**两周一个大版本**）。指纹补丁在 159.0 源码上
**13 个文件全部干净应用、0 冲突**，无需任何人工改写。

唯一的模糊匹配：`dom/base/AbstractRange.cpp` 的第一个 hunk 以 `fuzz 2` 落位 —— 159 删掉了
`#include "nsRange.h"`，补丁靠模糊匹配跳过该行，插入点仍在 `nsINode.h` 之后，语义正确。

### 2. 去除自动化检测特征（防检测，**必需**）

沿用 157 批次的两处修复，159 上重新打了一遍（2 hunk 全部成功）：

**(1) `navigator.webdriver` 恒为 `false`**

- `dom/base/Navigator.cpp` → `Navigator::Webdriver()` 改为 `return false;`
- 原实现查询 `nsIMarionette` / `nsIRemoteAgent` 的 `isBrowserAutomationRunning`，
  被 geckodriver / Marionette 驱动时返回 `true`

**(2) 去掉窗口顶部"受远程控制"标记**

- `browser/base/content/browser.js` → `gRemoteControl.updateVisualCue()` 不再写
  `remotecontrol="true"` 属性

### 3. 指纹伪装能力（与 155/157 一致）

- 屏幕尺寸 / 色深 / devicePixelRatio / 可用区域
- WebGL 厂商与渲染器（`gl.RENDERER`、`UNMASKED_*`，两条路径都过 `SanitizeRenderer`，保持自洽）
- WebGL 扩展列表（只删不加）、GL limit 钳制（只报 ≤ 真实能力）
- `readPixels` 确定性像素扰动、Canvas 2D 提取噪声
- AudioBuffer 采样噪声、ClientRects 亚像素偏移
- 环境时区 / 语言（走 BrowsingContext Field，天然跨进程）

## 验证记录

| 层 | 项目 | 结果 |
| --- | --- | --- |
| 产物扫描 | `foxfp.canvas.seed` / `audio.seed` / `rects.seed` / `timezone` / `locale` / `gpu.vendor` | 6/6 命中 `xul.dll` |
| 发布自检 | `firefox.js` 里 `pref("foxfp.` 注册数 | 18 条（≥12 通过） |
| 发布自检 | `browser.js` 的 remotecontrol 移除逻辑 | 存在 |
| 真机 | `navigator.webdriver`（geckodriver 驱动下） | **false**（未打补丁时应为 true） |
| 真机 | UA | `Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:159.0) Gecko/20100101 Firefox/159.0` |

## 安装

1. 解压到管理器的内核目录，得到 `firefox159\firefox.exe`
2. 管理器会自动扫描同级内核目录（`discover_firefox_binaries`）
3. 新建环境时在内核下拉里选 `159.0`；已有环境的内核字段在创建后不可改，需新建

## 说明

- 本内核**只做指纹伪装与自动化特征去除**，不改变浏览器的网络行为；代理、省流量等由管理器
  通过 `user.js` 与启动参数下发。
- 需要的 `foxfp.*` 偏好由管理器按环境写入 `user.js`，手工使用时需自行提供（见项目文档
  「Firefox内核编译交接文档」§2.1）。
- 音频噪声、Canvas 噪声的种子在未填 `foxfp.audio.seed` / `foxfp.canvas.seed` 时会按环境 ID 派生，
  同一环境跨会话稳定、不同环境互不相同。
