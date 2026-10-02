# FoxTrace 浏览器内核

FoxTrace 双端环境管理器配套的**自编译定制内核**下载仓库。从 [Releases](../../releases) 页下载对应压缩包即可。

## 内核版本

| 内核 | 版本 | 下载文件 | 大小 | SHA256（前 16 位） |
| --- | --- | --- | --- | --- |
| Firefox | 155.0 | [Firefox-155.0-win64-20261002.zip](../../releases/download/firefox-155.0/Firefox-155.0-win64-20261002.zip) | 128.6 MB | `277549F006772796` |
| Chromium | 154.0.8037.0 | [FoxChrome-154.0.8037.0-win64-20261002.zip](../../releases/download/chromium-154.0/FoxChrome-154.0.8037.0-win64-20261002.zip) | 273.2 MB | `ACCCA5CCB1BAF80D` |

完整 SHA256 见 Release 附件 `SHA256SUMS-firefox.txt` / `SHA256SUMS-chromium.txt`。
解压后：Firefox 约 340 MB（顶层目录 `firefox155\`），Chromium 约 715 MB（顶层目录 `chromium154\`）。

## 使用要求

- 需配合 **XiTrace 管理器**使用。管理器内置一键下载，也可以按下方「方式二」手动解压。
- 环境无法启动时，依次确认：
  1. 浏览器主程序未被安全软件拦截；
  2. 内核目录完整（**Firefox 目录里必须有 `mozglue.dll`**；**Chromium 目录里必须有 `chrome_elf.dll`**，只有 `firefox.exe` / `chrome.exe` 的目录一定起不来）；
  3. 该环境的配置文件没有被另一个还开着的浏览器窗口占用。

## 安装方法

**方式一：管理器内一键下载（推荐）**

XiTrace 管理器内置了内核下载：新建/编辑测试环境 → 内核下拉框旁的「下载内核」→ 等待下载解压完成（有实时进度，支持断点续传）→ 在内核下拉框中选择即可。

**方式二：手动下载解压**

1. 在 [Releases](../../releases) 页下载内核 zip（**不要**用页面右上角的绿色 Code 按钮下载源码）。
2. 把 zip **解压到 XiTrace 管理器 exe 所在目录**，与管理器 exe 同级，得到：

   ```
   XiTrace 管理器目录\
   ├─ XiTrace.exe
   ├─ firefox155\
   │   ├─ firefox.exe
   │   └─ geckodriver.exe
   └─ chromium154\
       ├─ chrome.exe
       ├─ FoxChrome.exe
       └─ chromedriver.exe
   ```

   两个内核可只装其一，也可同时装。
3. 启动管理器，新建/编辑环境时，内核下拉框会自动出现刚解压的内核；也可在全局设置中指定默认内核路径。

每个包内都附带**与内核同源编译 / 版本匹配**的驱动（Firefox → geckodriver，Chromium → chromedriver），无需另外下载。

## 国内下载慢 / 无法下载？

GitHub 在国内部分网络环境下直连缓慢或超时。两种解决办法：

**用管理器一键下载（推荐）**：管理器内置多个下载通道（公共加速 + 直连自动切换），无需任何设置；某个通道中断会自动换通道断点续传，下载完成后自动做 SHA256 完整性校验。

**手动下载**：把下面的加速前缀直接拼接在下载直链前面即可，例如：

```
https://gh-proxy.com/https://github.com/Chen168886/foxtrace-kernels/releases/download/firefox-155.0/Firefox-155.0-win64-20261002.zip
https://gh-proxy.com/https://github.com/Chen168886/foxtrace-kernels/releases/download/chromium-154.0/FoxChrome-154.0.8037.0-win64-20261002.zip
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

**Firefox 155.0**：基于 Mozilla Firefox 155.0 源码自编译（BuildID `20261002165256`），未做品牌定制，行为与官方 155.0 一致；随包附带 geckodriver 0.37.1（与内核版本匹配，**请勿混用官方驱动**）。

**Chromium 154.0.8037.0**：基于 Chromium 154.0.8037.0 源码自编译，行为与官方 154.0.8037.0 一致；随包附带 chromedriver 154.0.8037.0（与内核同源编译、版本匹配，**请勿混用官方驱动**）。主程序为 `chrome.exe`，另附改名副本 `FoxChrome.exe`（部分安全软件会按文件名拦截非系统目录下未签名的 `chrome.exe`，改名副本不受影响）；两者同时存在时管理器优先使用 `FoxChrome.exe`。

## 开源许可

- Firefox 内核与 geckodriver 部分：Mozilla 项目，MPL 2.0 许可，见 https://www.mozilla.org/MPL/2.0/ 。
- Chromium 内核与 chromedriver 部分：The Chromium Authors，BSD 3-Clause 许可，见 https://chromium.googlesource.com/chromium/src/+/main/LICENSE 。

本仓库仅分发 FoxTrace 配套内核二进制。
