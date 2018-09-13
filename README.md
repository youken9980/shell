[TOC]

# 常用脚本

使用说明
```shell
git clone https://github.com/youken9980/shell.git
cd shell
ln -snf *.sh ~/.
```

## 网络设计院 CDI

### cloneCdiProject.sh

克隆所有工程。
使用方法：
> 克隆后台开发1个架构项目、3个网关项目、13个微服务项目
```shell
cloneCdiProject.sh
```
> 克隆前端开发3个页面项目
```shell
cloneCdiProject.sh frontpage
```

### generateCdiDockerRun.sh

生成所有工程对应的docker命令。
使用方法：
```shell
generateCdiDockerRun.sh
```

### generateCommand.sh

生成所有工程对应的批处理命令，在Windows系统当前用户桌面的command目录。
使用方法：
```shell
generateCommand.sh
```

### generateResolveProperties.sh

抽取各网关、微服务proto文件中所有Service类，供后台开发同学直连调试使用。
使用方法：
```shell
generateResolveProperties.sh
```

### grepDeployTxt.sh

编译并上传Framework中所有API项目到中央库。
使用方法：
```shell
grepDeployTxt.sh
```

### grepCompileTxt.sh

编译所有工程。
使用方法：
```shell
grepCompileTxt.sh
```

### prepareCdiProject.sh

删除`.iml`文件、删除`.idea`目录、删除`target`目录，编译网关及微服务工程。
使用方法：
```shell
prepareCdiProject.sh
```

### sedFrontpage.sh

替换三个页面工程所有html文件里js的版本，使浏览器主动读取修改后的js，防止加载缓存。
使用方法：
```shell
sedFrontpage.sh
```

### sedPlatformUserService.sh

将PlatformUserServiceImpl.java中的@CeresReference(domain = "cn.enncloud.ceres.base")注释掉。
使用方法：
```shell
sedPlatformUserService.sh
```

### startCDIService.sh

启动所有微服务工程，使用kill命令或stopCDIBackend.sh终止。
使用方法：
```shell
startCDIService.sh
```

### startCDIGateway.sh

启动所有网关工程，使用kill命令或stopCDIBackend.sh终止。
使用方法：
```shell
startCDIGateway.sh
```

### startCDIFrontpage.sh

启动所有页面工程，control + c终止。
使用方法：
```shell
startCDIFrontpage.sh
```

### stopCDIBackend.sh

终止微服务和网关工程。
使用方法：
```shell
stopCDIBackend.sh
```

### updateFrameworkVersion.sh

更新版本号，MacOS版本。
使用方法：

```shell
updateFrameworkVersion.sh
```

### updateFrameworkVersion_windows.sh

更新版本号，Windows版本。
使用方法：
```shell
updateFrameworkVersion_windows.sh
```



## 通用

### batch.sh

批处理命令，对当前目录下所有子目录，执行命令列表。
使用方法：
```shell
batch.sh [frontpage|gateway|service] <'command1'> ['command2'] ['command3'] ...
```

### batchList.sh

批处理命令，对脚本中指定的子目录，执行命令列表。
使用方法：
```shell
batchList.sh <'command1'> ['command2'] ['command3'] ...
```

### cleanLastUpdated.sh

清理maven生成的lastupdated文件。
使用方法：
```shell
cleanLastUpdated.sh
```

### gitPullAllBranch.sh

更新当前Git库的所有分支。
使用方法：
```shell
gitPullAllBranch.sh
```

### mvn.sh

mvn命令的简便格式，其中默认已含`mvn clean -Dmaven.test.skip=true -U`。
使用方法：
```shell
mvn.sh [clean|compile|package|install|deploy|spring-boot:run|jetty:run|docker:build]
```

### jettyrun.sh

`~/mvn.sh jetty:run`。
使用方法：
```shell
jettyrun.sh
```

### springbootrun.sh

`~/mvn.sh spring-boot:run`。
使用方法：
```shell
springbootrun.sh
```



## Docker

### dockerlsimg.sh

列印本地所有docker镜像，格式 ***Image:Tag***，便于复制粘贴。
使用方法：
```shell
dockerlsimg.sh
```

### dockersave.sh

保存本地所有镜像到当前目录下的tar目录。
使用方法：
```shell
dockersave.sh
```

### dockerupdate.sh

更新本地所有镜像。
使用方法：
```shell
dockerupdate.sh
```

### dockerrminone.sh

停止并删除本地所有Tag为&lt;none&gt;的镜像。
使用方法：
```shell
dockerrminone.sh
```

### dockerrmall.sh

停止并删除本地所有运行中的docker容器。
使用方法：
```shell
dockerrmall.sh
```

