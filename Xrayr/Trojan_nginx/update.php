<?php
// 数据库配置信息
$host = '175.178.196.61'; // 数据库服务器地址 
$username = 'ports'; // 数据库用户名 
$password = 'db4pfnxWY6Fk7aJt'; 
// 数据库密码 
$database = 'ports'; // 数据库名
// 创建数据库连接
$conn = new mysqli($host, $username, $password, $database);
// 检查连接
if ($conn->connect_error)	
{
	die("连接失败: " . $conn->connect_error);
}


//$sql = "SELECT switch FROM PORTS WHERE node=53";
$port=shell_exec("/etc/nginx/check_port.sh"); 
$node=shell_exec("/etc/nginx/node.sh"); 
$sql = "SELECT switch FROM PORTS WHERE node=".$node; 
$server=shell_exec("/etc/nginx/ser.sh"); 
echo $port; 
echo $server; 
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // 输出查询结果
    $row = $result->fetch_assoc();
    echo "第一个记录的switch值是: " . $row["switch"];
	       if($row["switch"]==0){ 
				$new_port=shell_exec("/etc/nginx/new_port.sh");
			// 更新第一条记录的switch字段
			echo 	$sql = "UPDATE PORTS SET port=$new_port,switch=1 WHERE node=$node";
				 
				$url = "http://port.994938.xyz/update_node.php?offset_port=" . urlencode($new_port) . "&node_id=" . urlencode($node) . "&server=" . urlencode($server);
				$response = file_get_contents($url);
				var_dump($response);
				//$nginx=shell_exec("/etc/nginx/nginxport.sh");

				if ($conn->query($sql) === TRUE) {
					echo "记录更新成功";
					 $nginx=shell_exec("/etc/nginx/nginxport.sh");
				} else {
					echo "错误: " . $conn->error;
				}	
				
				
				
			   
			   
		   }else{
			   
			   echo "1 端口还没有封";
			   
		   }
	
} else {
	
    echo "没有找到记录或记录的switch字段为空";
}

 exit();



// 关闭数据库连接
$conn->close();
?>
