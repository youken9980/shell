########
# 
# 抽取各网关、微服务proto文件中所有Service类，供后台开发同学直连调试使用
# 
########

# proto文件列表
proto_file_list="
NDPSplitPackageService/src/main/proto/ability_label_association_service.proto
NDPUserService/src/main/proto/ability_label_domain_service.proto
NDPUserService/src/main/proto/ability_label_metadata_service.proto
NDPUserService/src/main/proto/ability_label_metadata_type_service.proto
NDPUserService/src/main/proto/ability_label_rule.proto
NDPUserService/src/main/proto/ability_label_service.proto
NDPUserService/src/main/proto/ability_label_type_service.proto
NDPOrderService/src/main/proto/alter_service.proto
NDPLoggerService/src/main/proto/app_error_service.proto
NDPEvaluateService/src/main/proto/appraise_service.proto
NDPUserService/src/main/proto/auth_edu_experience_service.proto
NDPAuthService/src/main/proto/auth_ha_service.proto
NDPUserService/src/main/proto/auth_manage_service.proto
NDPUserService/src/main/proto/auth_performance_project_service.proto
NDPUserService/src/main/proto/auth_positional_qualification_service.proto
NDPUserService/src/main/proto/auth_regist_qualification_service.proto
NDPAuthService/src/main/proto/auth_service.proto
NDPUserService/src/main/proto/auth_service.proto
NDPUserService/src/main/proto/auth_token_service.proto
NDPUserService/src/main/proto/auth_ttzz_service.proto
NDPUserService/src/main/proto/auth_work_experience_service.proto
NDPUserService/src/main/proto/auth_yyzz_service.proto
NDPUserService/src/main/proto/authentication_service.proto
NDPOrderService/src/main/proto/bid_evaluate_service.proto
NDPUserService/src/main/proto/capacity_lable_service.proto
NDPSplitPackageService/src/main/proto/category_service.proto
NDPSplitPackageService/src/main/proto/character_type_service.proto
NDPLoggerService/src/main/proto/chart_service.proto
NDPOrderService/src/main/proto/check_task_service.proto
NDPSplitPackageService/src/main/proto/common_param.proto
NDPDemandService/src/main/proto/contractmilestone_service.proto
NDPCooperativeService/src/main/proto/cooperative_ha_service.proto
NDPOrderService/src/main/proto/cooperative_service.proto
NDPOrderService/src/main/proto/create_task_service.proto
NDPEvaluateService/src/main/proto/credit_details.proto
NDPOrderService/src/main/proto/deliver_ongoing_service.proto
NDPDemandService/src/main/proto/demand_ha_service.proto
NDPSplitPackageService/src/main/proto/demand_list_service.proto
NDPDemandService/src/main/proto/demand_service.proto
NDPSplitPackageService/src/main/proto/design_stage_service.proto
NDPSplitPackageService/src/main/proto/device_service.proto
NDPSystemService/src/main/proto/dynamical_service.proto
NDPEvaluateService/src/main/proto/evaluate_ha_service.proto
NDPUserService/src/main/proto/expert_field_service.proto
NDPCooperativeService/src/main/proto/failRecord_service.proto
NDPSystemService/src/main/proto/feedback_service.proto
NDPSplitPackageService/src/main/proto/file_service.proto
NDPSystemService/src/main/proto/file_service.proto
NDPOrderService/src/main/proto/find_task_service.proto
NDPDemandService/src/main/proto/follow_record_service.proto
NDPUserService/src/main/proto/function_manage_service.proto
NDPUserService/src/main/proto/im_group_info.proto
NDPUserService/src/main/proto/im_group_user_service.proto
NDPUserService/src/main/proto/im_message.proto
NDPUserService/src/main/proto/im_notification_service.proto
NDPUserService/src/main/proto/im_user_relation_service.proto
NDPUserService/src/main/proto/im_user_settings_service.proto
NDPSplitPackageService/src/main/proto/industry_character_type_service.proto
NDPSplitPackageService/src/main/proto/industry_service.proto
NDPEvaluateService/src/main/proto/integral_service.proto
NDPCooperativeService/src/main/proto/interfaceLog_service.proto
NDPLoggerService/src/main/proto/interfaceLog_service.proto
NDPCooperativeService/src/main/proto/intermediateFiles_service.proto
NDPEvaluateService/src/main/proto/label_service.proto
NDPUserService/src/main/proto/ldap_service.proto
NDPOrderService/src/main/proto/leaderboard_service.proto
NDPSplitPackageService/src/main/proto/level_service.proto
NDPAuthService/src/main/proto/load_ldap_service.proto
NDPLoggerService/src/main/proto/logger_ha_service.proto
NDPSplitPackageService/src/main/proto/major_service.proto
NDPMessageService/src/main/proto/message_ha_service.proto
NDPMessageService/src/main/proto/message_service.proto
NDPCooperativeService/src/main/proto/milestone_service.proto
NDPOrderService/src/main/proto/model_service.proto
NDPSplitPackageService/src/main/proto/new_category_service.proto
NDPSplitPackageService/src/main/proto/new_technical_standard_service.proto
NDPSystemService/src/main/proto/news_service.proto
NDPSystemService/src/main/proto/norm_service.proto
NDPLoggerService/src/main/proto/operate_log_service.proto
NDPDemandService/src/main/proto/operate_record_service.proto
NDPOrderService/src/main/proto/order_ha_service.proto
NDPOrderService/src/main/proto/order_service.proto
NDPUserService/src/main/proto/order_user_own_ability_label_detail_service.proto
NDPUserService/src/main/proto/order_user_subscribe_ability_label_detail_service.proto
NDPUserService/src/main/proto/org_service.proto
NDPUserService/src/main/proto/people_show_service.proto
NDPUserService/src/main/proto/platform_user_service.proto
NDPSplitPackageService/src/main/proto/project_model_type.proto
NDPSystemService/src/main/proto/project_people_service.proto
NDPDemandService/src/main/proto/project_record.proto
NDPSplitPackageService/src/main/proto/project_service.proto
NDPSplitPackageService/src/main/proto/project_stage_service.proto
NDPSplitPackageService/src/main/proto/project_structure_label_service.proto
NDPSplitPackageService/src/main/proto/project_structure_service.proto
NDPSplitPackageService/src/main/proto/project_type_service.proto
NDPUserService/src/main/proto/reject_label_service.proto
NDPSplitPackageService/src/main/proto/response_result.proto
NDPCooperativeService/src/main/proto/resultFiles_service.proto
NDPUserService/src/main/proto/role_service.proto
NDPSplitPackageService/src/main/proto/role_type_service.proto
NDPUserService/src/main/proto/send_message_tool_service.proto
NDPOrderService/src/main/proto/sensitive_task_service.proto
NDPSystemService/src/main/proto/sensitive_words_service.proto
NDPOrderService/src/main/proto/sign_up_service.proto
NDPSplitPackageService/src/main/proto/skill_role_service.proto
NDPMessageService/src/main/proto/sms_service.proto
NDPSystemService/src/main/proto/software_version_service.proto
NDPSplitPackageService/src/main/proto/split_package_ha_service.proto
NDPEvaluateService/src/main/proto/star_service.proto
NDPOrderService/src/main/proto/start_service.proto
NDPOrderService/src/main/proto/statistics_service.proto
NDPSplitPackageService/src/main/proto/subsystem_role_service.proto
NDPSplitPackageService/src/main/proto/subsystem_service.proto
NDPSystemService/src/main/proto/sys_banner_service.proto
NDPSystemService/src/main/proto/sys_lable.proto
NDPSystemService/src/main/proto/sys_lable_type.proto
NDPSystemService/src/main/proto/sys_link_service.proto
NDPSystemService/src/main/proto/sys_partner_service.proto
NDPSystemService/src/main/proto/sys_update_log_service.proto
NDPSystemService/src/main/proto/system_banner_service.proto
NDPSystemService/src/main/proto/system_data_service.proto
NDPSystemService/src/main/proto/system_expert_service.proto
NDPSystemService/src/main/proto/system_ha_service.proto
NDPSystemService/src/main/proto/system_industry_service.proto
NDPSystemService/src/main/proto/system_link_service.proto
NDPSystemService/src/main/proto/system_news_service.proto
NDPSystemService/src/main/proto/system_notice_service.proto
NDPSystemService/src/main/proto/system_partner_service.proto
NDPSystemService/src/main/proto/system_project_service.proto
NDPSystemService/src/main/proto/system_standard_service.proto
NDPDemandService/src/main/proto/t_demand__file_service.proto
NDPDemandService/src/main/proto/t_demand_follow_record_service.proto
NDPDemandService/src/main/proto/t_demand_operate_record_service.proto
NDPDemandService/src/main/proto/t_demand_service.proto
NDPUserService/src/main/proto/t_im_user_category.proto
NDPUserService/src/main/proto/t_user_outer_account_service.proto
NDPOrderService/src/main/proto/task_cal_service.proto
NDPOrderService/src/main/proto/task_hall_service.proto
NDPOrderService/src/main/proto/task_need_ability_label.proto
NDPOrderService/src/main/proto/task_service.proto
NDPUserService/src/main/proto/team_manage_service.proto
NDPUserService/src/main/proto/team_user_service.proto
NDPSplitPackageService/src/main/proto/technical_file.proto
NDPSystemService/src/main/proto/technical_share_service.proto
NDPSplitPackageService/src/main/proto/technical_standard_service.proto
NDPLoggerService/src/main/proto/test_service.proto
NDPSplitPackageService/src/main/proto/unit_device_service.proto
NDPSplitPackageService/src/main/proto/unit_major_service.proto
NDPSplitPackageService/src/main/proto/unit_project_service.proto
NDPSplitPackageService/src/main/proto/unit_service.proto
NDPSplitPackageService/src/main/proto/univalent_service.proto
NDPUserService/src/main/proto/user_authentication_attach_service.proto
NDPUserService/src/main/proto/user_authentication_service.proto
NDPUserService/src/main/proto/user_ha_service.proto
NDPUserService/src/main/proto/user_own_ability_label_detail_service.proto
NDPUserService/src/main/proto/user_own_ability_label_service.proto
NDPUserService/src/main/proto/user_role_service.proto
NDPUserService/src/main/proto/user_statistics_service.proto
NDPOrderService/src/main/proto/user_subscribe_ability_label_detail.proto
NDPUserService/src/main/proto/user_subscribe_ability_label_service.proto
NDPUserService/src/main/proto/zoom_meeting_detail_service.proto
NDPUserService/src/main/proto/zoom_meeting_info_service.proto
NDPUserService/src/main/proto/zoom_user_service.proto
"

prefix="NDP"
suffix_api="Api"
project_name=""
for proto_file in $proto_file_list
do
	package=$(cat "$proto_file" | grep "package ")
	package="${package##* }"
	package="${package%%;*}"
	service=$(cat "$proto_file" | grep "service ")
	service="${service#* }"
	service="${service%% *}"
	service="${service%%'{'*}"
	# echo "$proto_file ---> $package.$service"
	if [ "$service" == "" ]
	then
		echo ">>> Ignore, no service in $proto_file"
	else
		case $package in
			# 鉴权
			"auth")
				project_name="Auth"
			;;
			# 协同
			"cooperative")
				project_name="Cooperative"
			;;
			# 需求
			"demand")
				project_name="Demand"
			;;
			# 评价
			"evaluate"|"appraise")
				project_name="Evaluate"
			;;
			# 日志
			"chart"|"logger")
				project_name="Logger"
			;;
			# 消息
			"message")
				project_name="Message"
			;;
			# 订单
			"order")
				project_name="Order"
			;;
			# 拆包
			"split"|"splitpackage")
				project_name="SplitPackage"
			;;
			# 系统
			"system")
				project_name="System"
			;;
			# 用户
			"user"|"im"|"zoom")
				project_name="User"
			;;
			# 其它
			*)
				project_name="ThirdParty"
		esac
		echo "$proto_file ---> NDPFramework/$prefix$project_name$suffix_api/src/main/proto"
		eval "cp $proto_file NDPFramework/$prefix$project_name$suffix_api/src/main/proto/."
	fi
done
echo ""
