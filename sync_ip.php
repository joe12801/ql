<?php
// sync_ip.php - 全自动批量同步节点IP版  panel

// ================= 1. 配置区域 =================
// 数据库配置
$dbHost = '127.0.0.1'; // 数据库地址，通常是 localhost 或 127.0.0.1
$dbName = ''; // 你的数据库名
$dbUser = ''; // 你的数据库用户名
$dbPass = 'XXXXX'; // 你的数据库密码
$tablePrefix = '';    // 如果有前缀如 ss_ 请填写
// ===============================================

echo "[" . date('Y-m-d H:i:s') . "] 开始自动同步节点IP...\n";

try {
    // 2. 连接数据库
    $dsn = "mysql:host={$dbHost};dbname={$dbName};charset=utf8mb4";
    $pdo = new PDO($dsn, $dbUser, $dbPass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $tableName = $tablePrefix . 'node'; 

    // 3. 从数据库获取所有的节点 ID 和 server 字段
    $stmt = $pdo->query("SELECT `id`, `server` FROM `{$tableName}`");
    $nodes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (count($nodes) === 0) {
        die("面板中没有节点。\n");
    }

    // 4. 遍历每一个节点
    foreach ($nodes as $node) {
        $nodeId = $node['id'];
        $server = trim($node['server']);
        
        // 如果 server 字段本身就是 IP，或者为空，跳过
        if (empty($server) || filter_var($server, FILTER_VALIDATE_IP)) {
            echo " - 节点 #{$nodeId} (地址: {$server}) 不是域名，跳过。\n";
            continue;
        }

        echo " - 正在处理节点 #{$nodeId} (域名: {$server}) ... ";

        // 5. 使用 DoH 强制获取最新 IP (绕过本地DNS缓存)
        $dohUrl = "https://1.1.1.1/dns-query?name={$server}&type=A";
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $dohUrl);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Accept: application/dns-json'));
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        
        $response = curl_exec($ch);
        curl_close($ch);

        if (!$response) {
            echo "失败 (DoH请求超时)\n";
            continue;
        }

        $data = json_decode($response, true);
        
        // 解析返回的 JSON 提取 IP
        $newIp = '';
        if (isset($data['Answer']) && count($data['Answer']) > 0) {
            foreach ($data['Answer'] as $ans) {
                if ($ans['type'] == 1) { // A记录
                    $newIp = $ans['data'];
                    break; 
                }
            }
        }

        if (empty($newIp)) {
            echo "失败 (无法解析出IPv4)\n";
            continue;
        }

        // 6. 更新数据库中的 node_ip 字段
        $updateStmt = $pdo->prepare("UPDATE `{$tableName}` SET `node_ip` = :ip WHERE `id` = :id");
        $updateStmt->execute([
            ':ip' => $newIp,
            ':id' => $nodeId
        ]);

        if ($updateStmt->rowCount() > 0) {
            echo "成功更新为 {$newIp}\n";
        } else {
            echo "IP无变化 ({$newIp})\n";
        }
        
        // 稍微停顿一下，防止并发请求 1.1.1.1 太频繁被限制
        usleep(200000); // 暂停 0.2 秒
    }

    echo "[" . date('Y-m-d H:i:s') . "] 所有节点同步完毕！\n";

} catch (Exception $e) {
    echo "[" . date('Y-m-d H:i:s') . "] 发生错误: " . $e->getMessage() . "\n";
}
