#!/bin/bash
file_name="tree_src_main_java_controller_service.txt"
rm $file_name
touch $file_name
search_path="src/main/java"
search_suffix="java"
list="
CDMPWebGateway
CDTPWebGateway
CDWPWebGateway
NDPAuthService
NDPCooperativeService
NDPDemandService
NDPEvaluateService
NDPLoggerService
NDPMessageService
NDPOrderService
NDPReportService
NDPScheduleService
NDPSplitPackageService
NDPSystemService
NDPUserService
"
for dir in $list; do
	if [[ -d "$dir" ]]; then
		echo "$dir"
		for item in $(tree -f -P "*.$search_suffix" "$dir/$search_path"); do
			item_file_path="${item##* }"
			if [[ ! -f "$item_file_path" ]]; then
				continue
			fi
			grep_suffix=$(echo $item | grep "[.]$search_suffix")
			grep_controller=$(echo $grep_suffix | grep "/controller/")
			grep_service=$(echo $grep_suffix | grep "/service/impl/")
			keywords=""
			count=0
			if [[ "$grep_controller" != "" ]]; then
				keywords="@Autowired"
			elif [[ "$grep_service" != "" ]]; then
				keywords="@CeresReference"
			else
				continue
			fi
			while read line; do
				if [[ "$line" =~ "$keywords" ]]; then
					count=$(($count+1))
				fi
			done < $item_file_path
			if [[ "$keywords" == "@Autowired" ]] && [[ "$count" -gt 1 ]] || [[ "$keywords" == "@CeresReference" ]] && [[ "$count" -gt 0 ]]; then
				echo "$item_file_path" >> $file_name
			fi
		done
	else
		echo "======== IGNORE $dir"
	fi
done
