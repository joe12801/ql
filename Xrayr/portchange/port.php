<?php 
$str = shell_exec("/etc/nginx/portchage.sh");
$regex = "/(\d+)/";
preg_match_all($regex, $str, $matches);  
#var_dump($matches);
$offset_port = $matches[0][1];
if($offset_port == ""){
   echo "ädont need to change port";
	exit();
}
echo  $offset_port;

$node_id = shell_exec("/etc/nginx/node.sh");

$server = shell_exec("/etc/nginx/ser.sh");

echo $node_id."</br/>";

echo $server;
$url = "http://port.994938.xyz/update_node.php?offset_port=" . urlencode($offset_port) . "&node_id=" . urlencode($node_id) . "&server=" . urlencode($server);

#$url = "http://port.994938.xyz/update_node.php?offset_port=" . urlencode($offset_port) . "&node_id=" . urlencode($node_id);

#$url = "http://port.994938.xyz/update_node.php?offset_port=" . urlencode($offset_port);
$response = file_get_contents($url);

#echo $response;
