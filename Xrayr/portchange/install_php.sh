#!/bin/bash

if ! [ -x "$(command -v php)" ]; then
  echo 'PHP 未安装，开始安装 PHP...'
  apt-get update
  apt-get install php -y
else
  echo 'PHP 已经安装，不需要再次安装。'
fi
