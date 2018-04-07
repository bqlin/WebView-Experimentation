# WebView-Experimentation

UIWebView 与 WKWebView 测试。

实现目的：UIWebView 与 WKWebView 的对比。

## 实现功能需求

1.3.x 功能：

- 支持修改请求；
  - 修改请求头信息；
- 支持 loadjs；

---

1.2.x 功能：

- 通过状态监听动态更改前进、后退、刷新、停止按钮以及缓冲状态的动态更新；
  - 前进按钮启用|禁用
  - 后退按钮启用|禁用
  - 刷新|停止按钮显示
  - 缓冲状态开始|结束
  - 显示缓冲进度
- 刷新按钮与停止按钮的重用；
- 获取当前页面 URL；
  - 获取当前URL；
  - 复制到剪贴板；
  - *详细信息；*
- 检测剪贴板；
  - 开屏检测剪贴板，若为 URL 则可让用户选择使用；
  - 提供开关设置；
- 错误提示；
- iPad 适配；
  - iPad 双屏仅为左右双屏；
  - iPad 左右双屏支持独立的工具条、导航条；
- 更新截图；

---

1.1.x 功能：

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

## 开发手札

仅在控制器跳转时才创建浏览器；

切换浏览器需销毁前面创建的浏览器。

双屏显示