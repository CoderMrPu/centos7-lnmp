# 欢迎使用

### 克隆项目

```shell
git clone https://github.com/CoderMrPu/centos7-lnmp.git
```

### 进入项目

```shell
cd centos7-lnmp
```

### 初始化

```shell
# Windows
./init.bat

# Linux
./init.sh
```

### 配置Lnmp.yaml文件

> 根据自己的需求来配置

- name （设置虚拟机的名称，不能重名）
- cpus （设置虚拟机cpu数）
- memory （设置虚拟机内存量）
- networks （设置虚拟机网络）
  - type （网络类型：一般默认）
  - ip （网络ip：根据自己虚拟机来配置，不能有冲突）
- ports （设置虚拟机端口转发）
  - send （虚拟机的端口）
  - to （本地端口）
- folders （设置文件夹共享）
  - map （本地文件夹路径）
  - to （虚拟机的路径）
- sites （设置apache站点）
  - map （站点域名）
  - to （站点路径）
- databases （设置数据库）
  - lnmp （创建《lnmp》数据库）

### 启动vagrant

```shell
vagrant up
```

### 设置hosts文件

```
192.168.10.10 www.lnmp.com
```

### 账户信息

- Linux （root：vagrant；vagrant：vagrant）
- MySQL （root：password；cluster：password）
- Redis （root：“”）

