# Welcome to use

[中文文档](https://github.com/CoderMrPu/cluster/blob/master/README-ZH_CN.MD)

### Clone the project

```shell
git clone https://github.com/CoderMrPu/centos7-lnmp.git
```

### Enter the project

```shell
cd centos7-lnmp
```

### Initialization

```shell
# Windows
./init.bat

# Linux
./init.sh
```

### Configure the Lnmp.yaml file

> configure according to your needs

- name (Set the name of the virtual machine, can not be renamed)
- cpus (Set the number of virtual machine CPU)
- memory (Set the amount of virtual machine memory)
- networks (Set up a virtual machine network)
  - type (Network type: general default)
  - ip (Network ip: Configure according to your virtual machine, there must be no conflict)
- ports (Set up virtual machine port forwarding)
  - send (Virtual machine port)
  - to (Local port)
- folders (Set up folder sharing)
  - map (Local folder path)
  - to (The path of the virtual machine)
- sites (Set up the apache site)
  - map (Domain name)
  - to (Site path)
- databases （set up the database）
  - lnmp （create a <lnmp> database）

### start vagrant

```shell
vagrant up
```

### Set up the hosts file

```
192.168.10.10 www.lnmp.com
```

### account information

- Linux (root:vagrant;vagrant:vagrant)
- MySQL (root:password;cluster:password)
- Redis (root:"")
