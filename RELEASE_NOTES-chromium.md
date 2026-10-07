# FoxTrace Chromium 154.0 内核

FoxTrace 双端环境管理器配套的定制 Chromium 内核，基于 Chromium 154.0.8037.0 源码自编译。

## 构建信息

| 项目 | 值 |
| --- | --- |
| 内核版本 | Chromium 154.0.8037.0 |
| 压缩包 | `FoxChrome-154.0.8037.0-win64-20261007e.zip` |
| 压缩包大小 | 286446040 字节（约 273.2 MB） |
| 解压后体积 | 约 715 MB（522 个条目），顶层目录 `chromium154\` |
| 编译来源 | Chromium 154.0.8037.0 源码自编译（HEAD `e967b7961d80199276ce493904c95f5fbbc42fca`） |
| 附带驱动 | chromedriver 154.0.8037.0（与内核同源编译，版本匹配） |
| 完整性校验 | 见附件 `SHA256SUMS-chromium.txt`（含历代包） |

## 安装方法

把 zip 解压到 **XiTrace 管理器 exe 所在目录**，与管理器 exe 同级，得到 `chromium154\` 目录：

```
XiTrace 管理器目录\
├─ XiTrace.exe
├─ chromium154\
│   ├─ chrome.exe
│   ├─ FoxChrome.exe
│   └─ chromedriver.exe
└─ ...
```

也可在管理器内新建 / 编辑测试环境时点「下载内核」一键安装。

## 新版变化（相对上一版 20261007d）

本批**只修一处自相矛盾，不改其它任何数据面行为**：

- **修掉「音频两条读取 API 结果不一致」**。同一个 `AudioBuffer`，此前
  `getChannelData()` 会注入确定性噪声，而 **`copyFromChannel()` 拿到的仍是干净数据** ——
  两个标准 API 对同一份数据给出不同结果，交叉比对一次就能识别出来。
- 现在 `copyFromChannel`（含带 `buffer_offset` 的部分拷贝）与 `getChannelData`
  走**同一条判定**、作用于**整条声道**，因此两者读到的永远是同一份数据。
  注入仍然是幂等的：同一份数据不会被重复加噪。
- **验证**：同一 buffer 按「先 `copyFromChannel`、再 `getChannelData`」的顺序读，
  两者逐采样完全一致（修复前有 64 个采样不同）；「先 `getChannelData`、再
  `copyFromChannel`」也一致；静音（全等采样）仍不被扰动；三个 API 均保持原生函数。
- **未改动**：品牌标识、界面外观、网络协议行为、扩展机制，以及既有各项数据面定制。
- 内核版本号保持不变（仍是 154.0.8037.0），只替换了内核二进制。
- **能力令牌不变**：本批没有新增开关键、也没有新增管理器需要感知的能力，
  只是把既有音频能力的覆盖面补全，因此沿用 `…-webgpu-tz` 令牌。
