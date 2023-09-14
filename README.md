# x2nestos

将通用形态操作系统转换为 NestOS For Container 版本的快捷部署工具。

#### 介绍

基于已部署的 openeuler 等通用 OS 形态，转换为基于不可变操作系统的 NestOS For Container。适用于不方便重新引导安装或大批量转换的场景。

**注意：**

**1.非迁移工具，不保留磁盘数据。**

**2.此转换不可逆。**

#### 安装教程

本工具为 shell 脚本，可下载或 git clone 本仓库直接使用。

如您使用 NestOS For Virt 版本，已默认集成该工具，可直接执行 x2nestos 命令。

如您使用 openeuler，可在开启 epol 情况下执行如下命令安装本工具。

```
sudo dnf install x2nestos
```

#### 使用说明

当您安装完毕后，可按如下步骤使用本工具：

1. 根据需要下载待转换 NestOS ISO 镜像至本地环境，可至 [NestOS 官方网站](https://nestos.openeuler.org/) 获取
2. 准备供 NestOS For Container 部署使用的 ign 点火文件。什么是 ign 点火文件及如何生成点火文件请至 [NestOS 官方网站](https://nestos.openeuler.org/) 或 [NestOS 用户指南](https://docs.openeuler.org/zh/docs/22.03_LTS_SP2/docs/NestOS/overview.html) 查阅
3. 本工具当前方案仅支持部署阶段 ign 文件通过远程获取，因此您需以 http(s)的形式提供可供 NestOS 部署阶段远程获取 ign 文件的 URL，形如：http://example.com/xxx.ign <br><br>
   TIPS: 一个以 python 简单实现的 http 文件服务如下，在 ign 文件所在目录执行：

   ```
   python -m http.server 8080
   ```

4. 正式开始转换，在待转换环境中执行如下命令：
   ```
   x2nestos -d 目标安装硬盘(必选) -i 点火文件URL(必选) -s ISO文件路径(必选)
   ```
   示例：
   ```
   x2nestos -d /dev/vda -i http://example.com/config.ign -s ./nestos-22.03-LTS-SP2.20230704.0-live.x86_64.iso
   ```
5. 完整支持参数列表及说明如下：
   ```
   Usage:
   x2nestos [-d DEVICE] [-i IGNITION_URL] [-s INSTALL_SOURCE]
   -d, --dev DEVICE          Specify the installation target device (e.g., /dev/vda)
   -i, --ignition-url        IGNITION_URL Specify the URL for the Ignition config
   -s, --install-source      The path where the NestOS installation ISO is located, may require you to download it locally in advance
   --debug                   Output every commands during the execution process
   --work_dir                Specify the working directory path, default to /tmp
   -h, --help                Display this help message
   -v, --version             Display Version info
   ```
6. 转换正式开始前会再次确认是否执行，输入 y 或 yes 执行转换

enjoy it.

#### 参与贡献

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request

#### Roadmap

- [x] 支持 openeuler 转换为 NestOS 基本能力
  - [x] 支持手动指定完整参数
  - [x] 支持手动指定 ISO 路径自动挂载部署
  - [ ] 支持指定版本自动下载待部署镜像
- [ ] 支持保留数据分区
- [ ] 支持保留原操作系统，将 NestOS 部署于空闲分区
  - [ ] 支持指定硬盘及所需空间后，自动压缩当前磁盘空间并部署
- [ ] 支持将当前部署中的部分配置生成为部署 NestOS 时所需 ign 文件
- [ ] 支持选择待转换 NestOS 版本及发布流
- [ ] 扩展支持其他操作系统
- [ ] ...

#### License

SPDX-License-Identifier: MulanPSL-2.0
