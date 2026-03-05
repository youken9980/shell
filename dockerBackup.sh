#!/bin/bash

# Docker 镜像备份脚本
# 用法: ./dockerBackup.sh [镜像标识|镜像 ID]
#   镜像标识格式: "Repository:Tag"
#   不传参数则备份所有镜像

set -e

# 配置
BACKUP_DIR="./docker_backups"

# 获取系统时间，格式: yyyy-MM-dd hh-mm-ss
get_timestamp() {
    date +"%Y-%m-%d %H-%M-%S"
}

# 日志输出
log() {
    echo "$(get_timestamp) $1"
}

# 将 Repository 中的 / 替换为 --
normalize_repo() {
    echo "$1" | sed 's/\//--/g'
}

# 生成备份文件名
# 格式: Repository---Tag---Architecture---ImageID.img
generate_backup_filename() {
    local repo="$1"
    local tag="$2"
    local arch="$3"
    local image_id="$4"
    
    local normalized_repo=$(normalize_repo "$repo")
    echo "${normalized_repo}---${tag}---${arch}---${image_id}.img"
}

# 检查镜像是否已备份
# 规则 1: Repository、Tag、Architecture、ImageID 四部分完全一致 -> 已备份
# 规则 2: Repository、Tag、Architecture 一致，但 ImageID 不同 -> 镜像有更新
# 返回: "BACKUP_EXISTS" | "UPDATE_AVAILABLE" | "NOT_BACKED_UP"
check_backup_status() {
    local repo="$1"
    local tag="$2"
    local arch="$3"
    local image_id="$4"
    
    local normalized_repo=$(normalize_repo "$repo")
    local filename_prefix="${normalized_repo}---${tag}---${arch}"
    
    # 检查是否存在完全匹配的备份文件
    if [ -f "${BACKUP_DIR}/${normalized_repo}---${tag}---${arch}---${image_id}.img" ]; then
        echo "BACKUP_EXISTS"
        return
    fi
    
    # 检查是否存在相同前三部分但不同 image_id 的文件（镜像更新）
    for existing_file in "${BACKUP_DIR}/${filename_prefix}"---*.img; do
        if [ -f "$existing_file" ]; then
            # 提取现有文件的 image_id（最后一部分，去掉 .img 后缀）
            local existing_basename=$(basename "$existing_file" .img)
            local existing_image_id=$(echo "$existing_basename" | awk -F'---' '{print $NF}')
            
            if [ "$existing_image_id" != "$image_id" ]; then
                echo "UPDATE_AVAILABLE"
                return
            fi
        fi
    done
    
    echo "NOT_BACKED_UP"
}

# 重命名旧镜像文件，添加 .none 后缀
# 找到所有前三部分 (repo---tag---arch) 匹配但 image_id 不同的文件并重命名
rename_old_backup() {
    local repo="$1"
    local tag="$2"
    local arch="$3"
    local new_image_id="$4"
    
    local normalized_repo=$(normalize_repo "$repo")
    local filename_prefix="${normalized_repo}---${tag}---${arch}"
    
    # 查找所有匹配前三部分的文件
    for existing_file in "${BACKUP_DIR}/${filename_prefix}"---*.img; do
        if [ -f "$existing_file" ]; then
            # 提取现有文件的 image_id（最后一部分，去掉 .img 后缀）
            local existing_basename=$(basename "$existing_file" .img)
            local existing_image_id=$(echo "$existing_basename" | awk -F'---' '{print $NF}')
            
            # 只重命名不同的 image_id（旧镜像）
            if [ "$existing_image_id" != "$new_image_id" ]; then
                local new_file="${existing_file}.none"
                mv "$existing_file" "$new_file"
                log "旧镜像已重命名：$(basename "$new_file")"
            fi
        fi
    done
}

# 获取镜像信息
get_image_info() {
    local image_id="$1"
    
    # 获取架构
    local arch=$(docker inspect "$image_id" 2>/dev/null | jq -r '.[0].Architecture' 2>/dev/null)
    if [ -z "$arch" ] || [ "$arch" = "null" ]; then
        arch="unknown"
    fi
    
    echo "$arch"
}

# 获取镜像大小
get_image_size() {
    local image_id="$1"
    
    docker inspect "$image_id" 2>/dev/null | jq -r '.[0].Size' 2>/dev/null | while read size_in_bytes; do
        if [ "$size_in_bytes" != "null" ] && [ -n "$size_in_bytes" ]; then
            # 转换为 MB
            local size_mb=$((size_in_bytes / 1024 / 1024))
            echo "${size_mb}M"
        else
            echo "unknown"
        fi
    done
}

# 备份单个镜像
backup_image() {
    local repo="$1"
    local tag="$2"
    local image_id="$3"
    
    # 获取架构
    local arch=$(get_image_info "$image_id")
    
    # 生成备份文件名
    local backup_filename=$(generate_backup_filename "$repo" "$tag" "$arch" "$image_id")
    local backup_path="${BACKUP_DIR}/${backup_filename}"
    
    # 检查备份状态
    local status=$(check_backup_status "$repo" "$tag" "$arch" "$image_id")
    
    # 输出镜像信息
    log "镜像信息：${repo}:${tag} (ID: ${image_id})"
    log "备份路径: ${backup_path}"
    
    case "$status" in
        "BACKUP_EXISTS")
            log "备份结果: ⚠️ 跳过备份"
            ;;
        "UPDATE_AVAILABLE")
            # 重命名旧镜像
            rename_old_backup "$repo" "$tag" "$arch" "$image_id"
            
            # 备份新镜像
            if docker save -o "$backup_path" "$image_id" 2>/dev/null; then
                local size=$(get_image_size "$image_id")
                log "备份结果: ✅ 保存成功 (${size})"
            else
                log "备份结果: ❌ 保存失败"
                return 1
            fi
            ;;
        "NOT_BACKED_UP")
            # 备份镜像
            if docker save -o "$backup_path" "$image_id" 2>/dev/null; then
                local size=$(get_image_size "$image_id")
                log "备份结果: ✅ 保存成功 (${size})"
            else
                log "备份结果: ❌ 保存失败"
                return 1
            fi
            ;;
    esac
    
    # 输出分隔符
    log "===================="
    
    return 0
}

# 从 docker_list 中查找镜像
find_image_in_list() {
    local docker_list="$1"
    local search_key="$2"
    local search_field="$3"  # "repo_tag" | "image_id"
    
    while IFS= read -r line; do
        if [ -z "$line" ]; then
            continue
        fi
        
        local img_repo=$(echo "$line" | awk '{print $1}')
        local img_tag=$(echo "$line" | awk '{print $2}')
        local img_id=$(echo "$line" | awk '{print $3}')
        
        if [ "$search_field" = "repo_tag" ]; then
            # 搜索 "Repository:Tag" 格式
            local search_pattern="$search_key"
            if [[ "${img_repo}:${img_tag}" == *"$search_pattern"* ]] || [[ "$search_pattern" == "${img_repo}:${img_tag}" ]]; then
                echo "$line"
                return 0
            fi
        elif [ "$search_field" = "image_id" ]; then
            # 搜索 Image ID
            if [[ "$img_id" == *"$search_key"* ]]; then
                echo "$line"
                return 0
            fi
        fi
    done <<< "$docker_list"
    
    return 1
}

# 主函数
main() {
    # 创建备份目录
    mkdir -p "$BACKUP_DIR"
    
    # 获取镜像列表
    local docker_list=$(docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}" -f dangling=false | grep -v 'REPOSITORY' | grep -v '<none>')
    
    if [ -z "$docker_list" ]; then
        log "没有可备份的镜像"
        exit 0
    fi
    
    # 根据参数决定备份策略
    if [ $# -ge 1 ]; then
        # 场景一或场景二：备份指定镜像
        local search_key="$1"
        local found_line=""
        
        # 判断是镜像标识还是镜像 ID
        if [[ "$search_key" == *":"* ]]; then
            # 场景一：镜像标识 "Repository:Tag"
            found_line=$(find_image_in_list "$docker_list" "$search_key" "repo_tag")
        else
            # 场景二：镜像 ID
            found_line=$(find_image_in_list "$docker_list" "$search_key" "image_id")
        fi
        
        if [ -z "$found_line" ]; then
            log "错误：未找到镜像 '$search_key'"
            exit 1
        fi
        
        # 解析镜像信息
        local img_repo=$(echo "$found_line" | awk '{print $1}')
        local img_tag=$(echo "$found_line" | awk '{print $2}')
        local img_id=$(echo "$found_line" | awk '{print $3}')
        
        backup_image "$img_repo" "$img_tag" "$img_id"
    else
        # 场景三：备份所有镜像
        local success_count=0
        local fail_count=0
        local skip_count=0
        
        while IFS= read -r line; do
            if [ -z "$line" ]; then
                continue
            fi
            
            local img_repo=$(echo "$line" | awk '{print $1}')
            local img_tag=$(echo "$line" | awk '{print $2}')
            local img_id=$(echo "$line" | awk '{print $3}')
            
            # 获取架构
            local arch=$(get_image_info "$img_id")
            local backup_filename=$(generate_backup_filename "$img_repo" "$img_tag" "$arch" "$img_id")
            local status=$(check_backup_status "$img_repo" "$img_tag" "$arch" "$img_id")
            
            case "$status" in
                "BACKUP_EXISTS")
                    ((skip_count++))
                    ;;
                "UPDATE_AVAILABLE"|"NOT_BACKED_UP")
                    if backup_image "$img_repo" "$img_tag" "$img_id"; then
                        ((success_count++))
                    else
                        ((fail_count++))
                    fi
                    ;;
            esac
        done <<< "$docker_list"
        
        echo ""
        log "备份完成：成功=${success_count}, 失败=${fail_count}, 跳过=${skip_count}"
    fi
}

# 执行主函数
main "$@"
