<?php
// 数据库配置信息
$host = '124.221.86.129'; // 数据库服务器地址 
$username = 'ports'; // 数据库用户名 
$password = 'db4pfnxWY6Fk7aJt'; 
// 数据库密码 
$database = 'ports'; // 数据库名
// 创建数据库连接
$conn = new mysqli($host, $username, $password, $database);
// 检查连接
if ($conn->connect_error) { die("连接失败: " . $conn->connect_error);
}
// 准备SQL语句
$sql = "INSERT INTO PORTS (port, switch, node, ip) VALUES (?, ?, ?, ?)";
// 创建预处理语句
$stmt = $conn->prepare($sql); 
// 绑定参数
$stmt->bind_param("iiis", $port, $switch, $node, $ip);

$port=shell_exec("/etc/nginx/check_port.sh"); 
$node=shell_exec("/etc/nginx/node.sh");
$ip=$server=shell_exec("/etc/nginx/ser.sh"); 
$switch = 1; 

// 执行预处理语句
if ($stmt->execute()) { echo "记录插入成功";
} else {
    echo "错误: " . $conn->error;
}
// 关闭预处理语句
$stmt->close();
// 关闭数据库连接
$conn->close();
?>
