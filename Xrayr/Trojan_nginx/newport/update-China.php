<?php
// 数据库配置信息
$host = 'localhost'; // 数据库服务器地址
$username = 'ports'; // 数据库用户名
$password = 'db4pfnxWY6Fk7aJt'; // 数据库密码
$database = 'ports'; // 数据库名

// 创建数据库连接
$conn = new mysqli($host, $username, $password, $database);

// 检查连接
if ($conn->connect_error) {
    die("连接失败: " . $conn->connect_error);
}

// 查询数据库
$sql = "SELECT * FROM PORTS";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // 输出每行数据
    while($row = $result->fetch_assoc()) {
        
        
        echo "ID: " . $row["ID"]. " - Port: " . $row["port"]. " - Switch: " . $row["switch"]. " - Node: " . $row["node"]. " - Timestamp: " . $row["timestamp"]. " - IP: " . $row["ip"]. "<br>";
        
        $target = $row["ip"]; // 目标 IP 地址
        $port = $row["port"]; // 指定要扫描的端口
        
        $fp = @fsockopen($target, $port, $errno, $errstr, 5);
        
        if ($fp) {
               echo 1;
                    $sql = "UPDATE PORTS SET switch = 1 WHERE node = ".$row["node"];
                    
                    if ($conn->query($sql) === TRUE) {
                        echo "记录更新成功";
                    } else {
                        echo "错误: " . $conn->error;
                    }
                                
            echo "端口 $port 开放";
            
            fclose($fp);
            
        } else {
            echo "OK";
            
                echo     $sql = "UPDATE PORTS SET switch = 0 WHERE node = ".$row["node"];
                    
                    if ($conn->query($sql) === TRUE) {
                        echo "记录更新成功";
                    } else {
                        echo "错误: " . $conn->error;
                    }
            echo "端口 $port 关闭";
        }
    }
} else {
    echo "0 结果";
}

// 关闭数据库连接
$conn->close();
?>