#!/bin/bash

if [ ! -d "NDPUserService" ]; then
	exit 1
fi

cd NDPUserService
# git checkout -- src/main/java/com/xindny/ndp/user/service/impl/PlatformUserServiceImpl.java
sed -i "" 's|@CeresReference(domain = "cn.enncloud.ceres.base")|// @CeresReference(domain = "cn.enncloud.ceres.base")|g' src/main/java/com/xindny/ndp/user/service/impl/PlatformUserServiceImpl.java
cd ..
