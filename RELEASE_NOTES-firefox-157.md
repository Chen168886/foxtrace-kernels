# FoxTrace Firefox 157.0.1 内核

FoxTrace 双端环境管理器配套的定制 Firefox 内核，基于 Mozilla Firefox 157.0.1 源码自编译。

## 构建信息

| 项目 | 值 |
| --- | --- |
| 内核版本 | Firefox 157.0.1 |
| 压缩包 | `Firefox-157.0.1-win64-20261009.zip` |
| 压缩包大小 | 139254123 字节（约 132.8 MB） |
| 解压后体积 | 约 367 MB（8087 个条目），顶层目录 `firefox157\` |
| BuildID | `20261009183206`（application.ini） / `20261009183240`（platform.ini） |
| 编译来源 | Mozilla Firefox 157.0.1 源码自编译（SourceStamp `737ec77d798755890b062aab541a90d6c75afd19`） |
| 附带驱动 | geckodriver 0.37.1（与内核版本匹配） |
| 完整性校验 | 见附件 `SHA256SUMS-firefox.txt` |

## 本批次改动

### 1. 上游版本 155.0 → 157.0.1

指纹补丁（`foxfp.*`，12 文件 / 32 hunk）在 157.0.1 源码上**全部干净应用、0 冲突**。
`dom/canvas/SanitizeRenderer.cpp` 与 `dom/webidl/WebGLRenderingContext.webidl` 两个关键文件
在 155 与 157 之间**逐字节相同**（md5 一致），说明补丁依赖的 Gecko 内部实现未变动。

### 2. ★ 新增：去除自动化检测特征（防检测，**必需**）

以下两处此前**从未处理过**，是"被自动化驱动时自曝"的硬特征，本批次已修复：

**(1) `navigator.webdriver` 恒为 `false`**

- 文件：`dom/base/Navigator.cpp` → `Navigator::Webdriver()`
- 原实现：查询 `nsIMarionette` / `nsIRemoteAgent` 的 `isBrowserAutomationRunning`，
  被 geckodriver / Marionette 驱动时返回 **true**（页面脚本一次 `navigator.webdriver` 即可识别）
- 本批次改为：`return false;`

**(2) 去掉窗口顶部红色"受远程控制"标记**

- 文件：`browser/base/content/browser.js` → `gRemoteControl.updateVisualCue()`
- 原实现：在 `<html>` 上写 `remotecontrol="true"` 属性并点亮 `#remote-control-icon`
  （红色小方块）；该属性/元素可被页面 CSS 选择器或 DOM 直接读取
- 本批次改为：仅执行 `document.documentElement.removeAttribute("remotecontrol")`，
  **不再查询** DevTools / Marionette / RemoteAgent，连查询痕迹都不留

### 3. 编译适配

- 157 给 `BrowsingContext::SetTimezoneOverride` / `SetLanguageOverride` 加了 `[[nodiscard]]`
  （155 没有），补丁中相应改为显式 `(void)` 忽略返回值，消除 `-Wunused-result`
- 157 新增 WinAppSDK 运行时依赖（`Microsoft.WindowsAppRuntime.dll` /
  `Microsoft.WindowsAppRuntime.Insights.Resource.dll` 等，155 无需），已随包完整附带

## 指纹与一致性能力（沿用 155 批次）

在**渲染与读取路径**上做内核侧定制，使同一环境多次启动 / 多次读取给出**一致**结果：

- Canvas / WebGL / WebGPU 读取路径
- Audio（`getChannelData` 与 `copyFromChannel` 两条 API 结果一致）
- 字体白名单、几何（ClientRects / getBoundingClientRect）
- 屏幕 / 硬件声明（只降不升）
- **环境语言 / 时区**内核通道（页面脚本看到的日期、数字、排序规则与时区跟环境配置一致）

随包附带 geckodriver 0.37.1（与内核版本匹配，**请勿混用官方驱动**）。

## 安装方法

把 zip 解压到 **XiTrace 管理器 exe 所在目录**，与管理器 exe 同级，得到 `firefox157\` 目录：

```
XiTrace 管理器目录\
├─ XiTrace.exe
├─ firefox157\
│   ├─ firefox.exe
│   └─ geckodriver.exe
└─ ...
```

## 版本保留说明

- 本版本为**独立 Release**（tag `firefox-157.0`）。
- **Firefox 155.0 内核的 Release（tag `firefox-155.0`）继续完整保留**，含 155.0 的历代构建包，
  可随时回退，不受本版本影响。

## 开源许可

Firefox 内核与 geckodriver 部分：Mozilla 项目，MPL 2.0 许可，见 https://www.mozilla.org/MPL/2.0/ 。
