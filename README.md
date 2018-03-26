# WebView-Experimentation

UIWebView 与 WKWebView 测试。

实现目的：UIWebView 与 WKWebView 的对比。

## 实现功能需求

- 输入URL；
- 跳转到 webView；
- 对比两种 webView；
- 功能开关；
- 列出各种浏览器的配置项；
	+ 列出各种浏览器的各种配置；
	+ 恢复默认设置；


### 配置列表

配置列表项都支持 UIWebView 和 WKWebView。

#### 通用

- 允许链接预览
- 禁止缩放页面
- 抑制增量渲染
- 允许数据检测
- 允许内嵌播放
- 禁止自动播放
- 允许 AirPlay
- 允许画中画

#### WKWebView

- WK - 允许手势导航

#### UIWebView

### 浏览器操作

以下列出的操作都可以应用与 UIWebView 和 WKWebView。

- 加载请求
- 停止加载
- 前进|后退

#### 后期增加功能

- 加载本地文件
- 从原点重新加载
- 运行 JavaScript 文本

### 浏览器信息

- 加载状态
- WK - 预估进度
- WK - 只有安全内容
- 请求/URL
- WK-11 - 获取快照
