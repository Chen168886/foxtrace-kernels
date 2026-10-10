# FoxTrace Chromium 157.0 内核

FoxTrace 双端环境管理器配套的定制 Chromium 内核，基于 **Chromium 157.0.8089.0** 源码自编译，
带**指纹伪装**与**防自动化检测**改造。

> 本 Release 与 **Chromium 154.0**（tag `chromium-154.0`）**并存**，互不覆盖。
> 管理器里两个版本各自一个下拉项，选哪个就下载哪个。

## 构建信息

| 项目 | 值 |
| --- | --- |
| 内核版本 | Chromium 157.0.8089.0 |
| 压缩包 | `FoxChrome-157.0.8089.0-win64-20261010.zip` |
| 压缩包大小 | 288,205,714 字节（约 274.9 MB） |
| 压缩包 SHA256 | `CBF8D659BF5837AC75EA075E247B78CF2D8F80894CEBC7998868E8314FD43260` |
| 解压后体积 | 约 720 MB（48 个顶层条目 / 561 个文件），顶层目录 `chromium157\` |
| 编译来源 | Chromium 157.0.8089.0 源码自编译（`is_official_build=false`） |
| 附带驱动 | chromedriver 157.0.8089.0（与内核同源，版本匹配） |
| 能力令牌 | `foxtrace-fp-cap-20261007-webgl3-webgpu-tz` |
| 完整性校验 | 见附件 `SHA256SUMS-chromium.txt`（含历代包） |

## 安装方法

把 zip 解压到 **XiTrace 管理器 exe 所在目录**，与管理器 exe 同级，得到 `chromium157\` 目录：

```
XiTrace 管理器目录\
├─ XiTrace.exe
├─ chromium157\
│   ├─ chrome.exe
│   ├─ FoxChrome.exe
│   └─ chromedriver.exe
└─ ...
```

也可在管理器内新建 / 编辑测试环境时点「下载内核」一键安装（下拉选 `Chrome Browser 157`）。

> 解压后请确保 `chromium157\` 拥有 AppContainer 读执行权限（管理器自动处理；
> 手工解压的执行一次即可）：
> ```
> icacls "chromium157" /grant "*S-1-15-2-1:(OI)(CI)RX" /T /C /Q
> icacls "chromium157" /grant "*S-1-15-2-2:(OI)(CI)RX" /T /C /Q
> ```

## 新版变化（相对 Chromium 154.0）

### 1. 上游大版本升级 154 → 157.0.8089.0

整套指纹与防检测改造已移植到 157 源码树，**能力集与 154 完全一致**：

- 指纹串扫逐项对齐 154：`foxtrace-fp`×3、`foxtrace-fp-cap`×1、
  `foxtrace-env-number`×1、`foxfp`×1 —— 无缺项、无多余项。
- 启动通道不变：`--foxtrace-fp=k=v;...`（Canvas / readPixels / Audio / WebGL /
  GL 扩展 / 字体白名单 / 时区 / 能力令牌）。

### 2. ★ 防自动化检测（本版重点）

**`navigator.webdriver` 恒为 `false`** —— 无论是否带 `--enable-automation`。

`--enable-automation` 是 Chromium **强制**把 `navigator.webdriver` 置真的开关。
差分测试（同参数、同机器）：

| 组 | 内核 | 启动参数 | `navigator.webdriver` |
| --- | --- | --- | --- |
| A | 官方 CfT 157.0.8089.0 | `--enable-automation` | **true**（对照） |
| B | **本内核** | `--enable-automation` | **false** ✅ |
| C | 本内核 | 常规 | false ✅ |

官方版如实返回 `true` 而本内核仍返回 `false` ⇒ 该改造确实编入且生效。
项目自带探针 `probe_chromium_webdriver.py` 4/4 通过（基线 / 删 flag 不退化 /
非 0 调试端口 / `port=0` 触发点）。

### 3. 与 154 一致的既有能力

- 品牌标识与界面外观、网络协议行为、扩展机制均未改动。
- 内核二进制重新编译，能力令牌沿用 `…-webgpu-tz`（无新增管理器需感知的能力）。

## 已知限制

- 普通（非指纹）环境的「WebRTC 关闭」无原生开关可用，仅指纹环境经注入实现。
- 页面自行新开的标签页不会自动获得注入（已打开的标签页全覆盖）。

## 回退

如需回到 Chromium 154，直接下载 tag `chromium-154.0` 下的
`FoxChrome-154.0.8037.0-win64-20261007e.zip`，解压出 `chromium154\` 即可，
两个内核目录可以同时存在。
