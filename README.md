# FoxTrace 浏览器内核

FoxTrace 双端环境管理器配套的**自编译定制内核**下载仓库。从 [Releases](../../releases) 页下载对应压缩包即可。

## 内核版本

| 内核 | 版本 | 下载文件 | 大小 | SHA256（前 16 位） |
| --- | --- | --- | --- | --- |
| Chrome（FoxChrome） | Chromium 154.0.8037.0 | [FoxChrome-154.0.8037.0-win64.zip](../../releases/download/chromium-154.0.8037.0/FoxChrome-154.0.8037.0-win64.zip) | 274 MB | `CA61F2E74EA94F2C` |
| Firefox | 155.0 | [Firefox-155.0-win64.zip](../../releases/download/firefox-155.0/Firefox-155.0-win64.zip) | 134 MB | `B585BF3247E0CCDA` |

完整 SHA256 见各 Release 说明或 `SHA256SUMS.txt`（随 Release 附带）。解压后体积：Chrome 约 715 MB，Firefox 约 366 MB。

## 安装方法

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

## 系统要求

- Windows 10 / 11，64 位
- 无需安装运行库（VC 运行库已随包附带）

## 内核说明

两个内核均为定制自编译版本，与管理器配套使用（驱动与内核版本匹配，请勿混用官方浏览器驱动）：

- **FoxChrome 154.0.8037.0**：基于 Chromium 154.0.8037.0 源码自编译。定制内容：工作室品牌标识、`--foxtrace-env-number` 环境序号工具栏显示、QA 自动化接管时 `navigator.webdriver` 固定为 `false`（保证接管测试环境与真实用户环境表现一致）。
- **Firefox 155.0**：基于 Mozilla Firefox 155.0 源码自编译（BuildID 20260901120612），随包附带 geckodriver 0.37.1。

## 开源许可

- Chromium 内核部分：Chromium 项目，BSD 3-Clause 许可，全文见 [LICENSE](LICENSE)。
- Firefox 内核与 geckodriver 部分：Mozilla 项目，MPL 2.0 许可，见 https://www.mozilla.org/MPL/2.0/ 。

本仓库仅分发 FoxTrace 配套内核二进制；各内核的修改仅限于上文说明的定制项。
