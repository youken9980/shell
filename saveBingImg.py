#!/usr/bin/env python3
# -*- coding:utf-8 -*-

import requests
import json
import os


# 请求方法中使用的各常量
HEADERS = {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.87 Safari/537.36"}
CHARSET = "UTF-8"
TIMEOUT = 60
# bing 页面地址
BING_ROOT_URL = "https://cn.bing.com"
# BING_API_URL参数说明：
# format：xml(默认)-xml，js-json
# idx(取值范围1~7)：天数，1-今天，2-昨天，以此类推
# n(取值范围1~8)：返回数据条数
BING_API_URL = "/HPImageArchive.aspx?format=js&idx=1&n=8"
# 截取id开始标记
ID_BEGIN = "?id=OHR."
# 截取id结束标记
ID_END = "&rf="
# 本地储存路径
LOCAL_PATH = "/Users/youken/Destiny/Image/bing"


def send_request(url):
    response = requests.get(url, params=HEADERS, timeout=TIMEOUT)
    return response.content


def assemble_img_url_list():
    img_url_list = []
    response = send_request(BING_ROOT_URL + BING_API_URL)
    json_obj = json.loads(response.decode(CHARSET))
    for img in json_obj["images"]:
        img_url_list.append(BING_ROOT_URL + img["url"])
    return img_url_list


def save_img():
    # 若本地存储路径不存在则创建
    if os.path.exists(LOCAL_PATH) == False:
        try:
            os.mkdir(LOCAL_PATH)
        except:
            print("新建本地存储文件夹失败")
            exit(1)
    # 保存图像
    for img_url in assemble_img_url_list():
        img_id = img_url[img_url.find(ID_BEGIN) + len(ID_BEGIN) : img_url.find(ID_END)]
        img_local_path = "%s/%s" % (LOCAL_PATH, img_id)
        if os.path.exists(img_local_path):
            print("文件已存在：%s" % img_local_path)
            continue
        response = send_request(img_url)
        try:
            file = open(img_local_path, "wb")
            file.write(response)
            file.close()
            print("保存成功：%s" % img_local_path)
        except:
            print("保存失败：%s" % img_local_path)

save_img()
