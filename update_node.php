<?php
// ========== 1. 请求方法与参数校验 ==========
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    die(json_encode(['status' => 'error', 'message' => 'Method Not Allowed']));
}

$node_id    = isset($_GET['node_id']) ? trim($_GET['node_id']) : '';
$offset_port = isset($_GET['offset_port']) ? trim($_GET['offset_port']) : '';
$server     = isset($_GET['server']) ? trim($_GET['server']) : '';
$token      = isset($_GET['token']) ? trim($_GET['token']) : '';

if (!ctype_digit($node_id) || !ctype_digit($offset_port)) {
    http_response_code(400);
    die(json_encode(['status' => 'error', 'message' => 'node_id and offset_port must be numeric']));
}
$node_id    = (int)$node_id;
$offset_port = (int)$offset_port;

// 身份验证 Token（从环境变量读取）
/*
$valid_token = getenv('UPDATE_TOKEN');
if (empty($valid_token)) {
    // 若未设置，可临时使用默认值（仅开发用），生产务必设置
    $valid_token = 'change_me_in_production';
}
if ($token !== $valid_token) {
    http_response_code(403);
    die(json_encode(['status' => 'error', 'message' => 'Forbidden: invalid token']));
}
*/

// ========== 2. 数据库连接（全部从环境变量读取） ==========
$db_host = getenv('DB_HOST') ?: 'localhost';
$db_user = getenv('DB_USER') ?: 'sql_panel_994938_xyz';  // 若未设置，可给默认值
$db_pass = getenv('DB_PASS') ?: '307f75c3d307e8';                      // 强烈建议设置
$db_name = getenv('DB_NAME') ?: 'sql_panel_994938_xyz';

try {
    $pdo = new PDO("mysql:host=$db_host;dbname=$db_name;charset=utf8mb4", $db_user, $db_pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    error_log("DB connection error: " . $e->getMessage());
    http_response_code(500);
    die(json_encode(['status' => 'error', 'message' => 'Database connection failed']));
}

// ========== 3. 更新 custom_config ==========
try {
    // 查询现有配置
    $stmt = $pdo->prepare("SELECT custom_config FROM node WHERE id = ?");
    $stmt->execute([$node_id]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$row) {
        http_response_code(404);
        die(json_encode(['status' => 'error', 'message' => "Node $node_id not found"]));
    }

    // 解析并更新 offset_port_user
    $config = json_decode($row['custom_config'], true);
    if (!is_array($config)) {
        $config = [];
    }
    $config['offset_port_user'] = (string)$offset_port;

    $new_config = json_encode($config, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    if ($new_config === false) {
        throw new Exception('JSON encoding failed');
    }

    // 执行更新
    $stmt = $pdo->prepare("UPDATE node SET custom_config = ? WHERE id = ?");
    $stmt->execute([$new_config, $node_id]);

    // 记录审计日志（可选）
    $log = sprintf("[%s] node=%d, new_port=%d, server=%s, ip=%s\n",
        date('Y-m-d H:i:s'), $node_id, $offset_port, $server, $_SERVER['REMOTE_ADDR'] ?? 'unknown');
    file_put_contents('/var/log/node_port_updates.log', $log, FILE_APPEND);

    header('Content-Type: application/json');
    echo json_encode(['status' => 'ok', 'node_id' => $node_id, 'new_offset_port' => $offset_port]);

} catch (PDOException $e) {
    error_log("SQL error: " . $e->getMessage());
    http_response_code(500);
    die(json_encode(['status' => 'error', 'message' => 'Database update failed']));
} catch (Exception $e) {
    error_log("General error: " . $e->getMessage());
    http_response_code(500);
    die(json_encode(['status' => 'error', 'message' => 'Internal error']));
}
exit;