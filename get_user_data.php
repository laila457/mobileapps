<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$conn = mysqli_connect('localhost', 'root', '', 'happypaws');

if (!$conn) {
    die(json_encode(['success' => false, 'message' => 'Connection failed']));
}

$email = isset($_GET['email']) ? mysqli_real_escape_string($conn, $_GET['email']) : '';

if (empty($email)) {
    die(json_encode(['success' => false, 'message' => 'Email required']));
}

$query = "SELECT id, username, email, phone, address FROM users WHERE email = ?";
$stmt = mysqli_prepare($conn, $query);
mysqli_stmt_bind_param($stmt, "s", $email);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);
$user = mysqli_fetch_assoc($result);

if (!$user) {
    echo json_encode([
        'success' => false,
        'message' => 'User not found'
    ]);
} else {
    echo json_encode([
        'success' => true,
        'data' => [
            'id' => $user['id'],
            'username' => $user['username'],
            'email' => $user['email'],
            'phone' => $user['phone'],
            'address' => $user['address']
        ]
    ]);
}

mysqli_close($conn);
?>