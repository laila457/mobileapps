<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
error_reporting(0);

try {
    $conn = new mysqli("localhost", "root", "", "happypaws");

    if ($conn->connect_error) {
        throw new Exception($conn->connect_error);
    }

    $sql = "SELECT id, username, email, phone, address, profile_picture, role, created_at 
            FROM users 
            WHERE id = (SELECT MAX(id) FROM users)";
    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {
        $user = $result->fetch_assoc();
        echo json_encode([
            'success' => true,
            'data' => $user
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'No user found',
            'data' => null
        ]);
    }

    $conn->close();
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage(),
        'data' => null
    ]);
}
?>