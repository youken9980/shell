#!/bin/bash

list="
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/demand/DemandController.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/im/IMNotificationController.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/im/IMUserRelationController.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/order/AlertContrller.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/order/CheckContrller.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/order/ConventionalGasFactTaskPriceController.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/order/CreateTaskController.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/order/PostPricingController.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/order/StartController.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/order/TaskController.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/order/TaskHallcontroller.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/splitPackage/ProjectController.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/splitPackage/ProjectPriceController.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/splitPackage/TechnicalStandardController.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/splitPackage/UnitController.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/system/SystemNoticeController.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/user/BankCardController.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/user/PlatformUserController.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/user/UserBankCardController.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/user/UserOwnAbilityLabelController.java
CDTPWebGateway/src/main/java/com/xindny/ndp/controller/zoom/ZoomController.java

CDWPWebGateway/src/main/java/com/xindny/ndp/controller/demand/ContractController.java
CDWPWebGateway/src/main/java/com/xindny/ndp/controller/demand/DemandController.java
CDWPWebGateway/src/main/java/com/xindny/ndp/controller/demand/ProjectRecordController.java
CDWPWebGateway/src/main/java/com/xindny/ndp/controller/order/AlertContrller.java
CDWPWebGateway/src/main/java/com/xindny/ndp/controller/order/CheckContrller.java
CDWPWebGateway/src/main/java/com/xindny/ndp/controller/order/ConventionalGasFactTaskPriceController.java
CDWPWebGateway/src/main/java/com/xindny/ndp/controller/order/CreateTaskController.java
CDWPWebGateway/src/main/java/com/xindny/ndp/controller/order/MilestoneContrller.java
CDWPWebGateway/src/main/java/com/xindny/ndp/controller/order/NewlyBuildTaskController.java
CDWPWebGateway/src/main/java/com/xindny/ndp/controller/order/PostPricingController.java
CDWPWebGateway/src/main/java/com/xindny/ndp/controller/order/StartController.java
CDWPWebGateway/src/main/java/com/xindny/ndp/controller/order/TaskController.java
CDWPWebGateway/src/main/java/com/xindny/ndp/controller/order/TaskHallcontroller.java
CDWPWebGateway/src/main/java/com/xindny/ndp/controller/splitPackage/ProjectPriceController.java
CDWPWebGateway/src/main/java/com/xindny/ndp/controller/user/AbilityLabelController.java

CDMPWebGateway/src/main/java/com/xindny/ndp/controller/ability/AbilityLabelController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/appraise/LableController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/demand/DemandCustomerServiceController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/facilitator/FacilitatorController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/label/CapacityLableManagementController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/order/AlterController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/order/ConventionalGasTypeController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/order/ConventionalGasUnitPriceController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/order/TaskController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/splitpackage/AttatchmentFileController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/splitpackage/DeviceController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/splitpackage/LevelController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/splitpackage/MajorController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/splitpackage/NewTechnicalStandardController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/splitpackage/ProjectController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/splitpackage/ProjectModelTypeController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/splitpackage/ProjectStructureController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/splitpackage/ProjectStructureLabelController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/splitpackage/SkillRoleController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/splitpackage/SubsystemController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/splitpackage/SubsystemRoleAssociationController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/splitpackage/TechnicalStandardController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/splitpackage/UnitController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/splitpackage/UnitMajorAssociationController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/splitpackage/UnitPriceManagementController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/statistics/UserStatisticsController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/system/ActiveConfigController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/system/SystemIndustryController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/user/AuthController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/user/BankCardController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/user/OrgController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/user/RoleController.java
CDMPWebGateway/src/main/java/com/xindny/ndp/controller/user/UserController.java
"

for item in ${list}; do
	echo "${item}"
	grep "@RequestMapping" -C0 "${item}"
	echo ""
done
