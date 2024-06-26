# PLUS2047 BLOG

[![Language](https://img.shields.io/badge/Jekyll-Theme-blue)](https://github.com/plus2047/plus2047.github.io)
[![license](https://img.shields.io/github/license/plus2047/plus2047.github.io)](https://github.com/plus2047/plus2047.github.io)

博客地址：[plus2047.github.io](http://plus2047.github.io)

主题：一款 jekyll 主题（[GitHub 地址](https://github.com/TMaize/tmaize-blog)），简洁纯净(主题资源请求<20KB)，未引入任何框架，秒开页面，支持自适应，支持全文检索

# 运行

一般提交到 github 过个几十秒就可以看到效果，如果你需要对在本地查看效果需要安装 ruby 环境

```bash
gem install jekyll
gem install bundler
```

```bash
# 第一次运行需要在项目下执行 bundle install
# 国内依赖下载慢可以使用ruby-china的镜像站进行请求重定向
# bundle config mirror.https://rubygems.org https://gems.ruby-china.com
bundle exec jekyll serve --watch --host=0.0.0.0 --port=8080
```

如果是 windows 系统，环境搭建好后可以运行项目下的`cli.bat`快速启动，Mac / Linux 手动装好依赖后可以运行 `run.sh` 启动本地服务。

# 项目配置

1. 如果使用自己的域名，`CNAME` 文件里的内容请换成你自己的域名，然后 CNAME 解析到 `用户名.github.com`

2. 如果使用 GitHub 的的域名，请删除 `CNAME` 文件,然后把你的项目修改为 `用户名.github.io`

3. 修改 `pages/about.md` 中关于我的内容

4. 修改 `_config.yml` 文件，具体作用请参考注释

5. 清空 `post _posts` 目录下所有文件，注意是清空，不是删除这两个目录

6. 网站的 logo 和 favicon 放在了 `static/img/` 下，替换即可，大小无所谓，图片比例最好是 1:1

7. 如果你是把项目 fork 过去的，想要删除我的提交记录可以先软重置到第一个提交，然后再提交一次，最后强制推送一次就行了（或者删除 .git 文件夹，重新创建项目）

# 使用

文章放在 `_posts` 目录下，命名为 `yyyy-MM-dd-xxxx-xxxx.md`，内容格式如下

```yaml
---
layout: mypost
title: 标题
categories: [分类1, 分类2]
---
文章内容，Markdown格式
```

文章资源放在 `posts` 目录下跟文件同名目录中。在文章使用时直接引用即可。可以在 typora, vscode 等软件中正常编辑文件、检测到图片等资源。

```md
![这是图片](xxx.png)
[xxx.zip 下载](xxx.zip)
<img src="image.jpg" alt="image" style="width:200px;"/>
<img src="image.jpg" alt="image" style="zoom:50%;"/>
```