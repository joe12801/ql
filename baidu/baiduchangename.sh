#!/bin/bash

# Prompt the user for input
read -p "请输入 path: " path
read -p "请输入 old_char: " old_char
read -p "请输入 new_char: " new_char

# 获取文件列表
file_list=$(BaiduPCS-Go ls | awk -F ' ' '{print $NF}' | sed 1d)

BaiduPCS-Go cd $path

# 批量修改文件名（将 old_char 替换为 new_char）
for file in $file_list; do
       new_file="${file//$old_char/$new_char}"
      BaiduPCS-Go mv "$file" "$new_file"
   done

