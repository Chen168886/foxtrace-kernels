# FoxTrace 浏览器内核

FoxTrace 双端环境管理器配套的**自编译定制内核**下载仓库。从 [Releases](../../releases) 页下载对应压缩包即可。

## 内核版本

| 内核 | 版本 | 下载文件 | 大小 | SHA256（前 16 位） |
| --- | --- | --- | --- | --- |
| Chrome（FoxChrome） | Chromium 154.0.8037.0（含启动授权保护） | [FoxChrome-154.0.8037.0-win64-20260915.zip](../../releases/download/chromium-154.0.8037.0/FoxChrome-154.0.8037.0-win64-20260915.zip) | 273 MB | `905CB2E68584F32A` |
| Firefox | 155.0（含启动授权保护） | [Firefox-155.0-win64-20260915b.zip](../../releases/download/firefox-155.0/Firefox-155.0-win64-20260915b.zip) | 128 MB | `1416CF5C3ACA9032` |

完整 SHA256 见各 Release 附件（Chrome 为 `SHA256SUMS-chrome.txt`，Firefox 为 `SHA256SUMS-firefox.txt`）。解压后体积：Chrome 约 715 MB，Firefox 约 340 MB。

## 使用要求（Firefox / Chromium 内核）

- **必须配合最新版 FoxTrace 管理器使用。** 两款内核均内建启动授权保护，与旧版管理器不兼容；两者必须为同期版本，请先升级管理器再更换内核。
- 内核仅能在已授权的 FoxTrace 管理器中运行。脱离管理器或未经授权取得的副本不会启动——这是保护机制的正常表现，不是文件损坏。
- 环境无法启动时，请依次确认：管理器已升级到最新版 → 已正常登录 → 网络通畅。


## 安装方法

**方式一：管理器内一键下载（推荐）**

新版 FoxTrace 管理器内置了内核下载：新建/编辑测试环境 → 内核下拉框旁点「下载内核」→ 选择需要的内核 → 等待下载解压完成（有实时进度，支持断点续传）→ 在内核下拉框中选择即可。

**方式二：手动下载解压**

1. 在 [Releases](../../releases) 页下载需要的内核 zip（**不要**用页面右上角的绿色 Code 按钮下载源码）。
2. 把 zip **解压到 FoxTrace 管理器 exe 所在目录**，与管理器 exe 同级，得到：
   ```
   FoxTrace 管理器目录\
   ├─ FoxTrace.exe（管理器）
   ├─ chromium154\        ← Chrome 内核
   │   ├─ FoxChrome.exe
   │   └─ chromedriver.exe
   └─ firefox155\         ← Firefox 内核
       ├─ firefox.exe
       └─ geckodriver.exe
   ```
3. 启动管理器，新建/编辑环境时，内核下拉框会自动出现刚解压的内核；也可在全局设置中指定默认内核路径。

两个包内均已附带**与内核同源编译/版本匹配**的驱动（chromedriver / geckodriver），无需另外下载。

## 国内下载慢 / 无法下载？

GitHub 在国内部分网络环境下直连缓慢或超时。两种解决办法：

**用管理器一键下载（推荐）**：管理器内置多个下载通道（公共加速 + 直连自动切换），无需任何设置；某个通道中断会自动换通道断点续传，下载完成后自动做 SHA256 完整性校验。

**手动下载**：把下面的加速前缀直接拼接在下载直链前面即可，例如：

```
https://gh-proxy.com/https://github.com/Chen168886/foxtrace-kernels/releases/download/firefox-155.0/Firefox-155.0-win64-20260915b.zip
```

常用前缀（任选其一，公共加速服务稳定性不保证，失效可换一个）：

- `https://gh-proxy.com/`
- `https://ghfast.top/`
- `https://ghproxy.net/`
- `https://gh.ddlc.top/`

无论通过哪种方式下载，都建议解压前用 Release 附件中的 SHA256 校验文件核对一遍，确保文件完整未被篡改。

## 系统要求

- Windows 10 / 11，64 位
- 无需安装运行库（VC 运行库已随包附带）

## 内核说明

两个内核均为定制自编译版本，与管理器配套使用（驱动与内核版本匹配，请勿混用官方浏览器驱动）：

- **FoxChrome 154.0.8037.0**：基于 Chromium 154.0.8037.0 源码自编译。定制内容：工作室品牌标识、`--foxtrace-env-number` 环境序号工具栏显示、QA 自动化接管时 `navigator.webdriver` 固定为 `false`（保证接管测试环境与真实用户环境表现一致）、内建启动授权保护（与 Firefox 内核同代）。
- **Firefox 155.0**：基于 Mozilla Firefox 155.0 源码自编译（BuildID 20260915005256），随包附带 geckodriver 0.37.1。内建启动授权保护，**仅限通过最新版 FoxTrace 管理器在已授权环境下使用**（详见上方「使用要求」）。

## 开源许可

- Chromium 内核部分：Chromium 项目，BSD 3-Clause 许可，全文见 [LICENSE](LICENSE)。
- Firefox 内核与 geckodriver 部分：Mozilla 项目，MPL 2.0 许可，见 https://www.mozilla.org/MPL/2.0/ 。

本仓库仅分发 FoxTrace 配套内核二进制；各内核的修改仅限于上文说明的定制项。
