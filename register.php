<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$conn = new mysqli("localhost", "root", "", "happypaws");

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed']));
}

$username = $_POST['username'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$address = $_POST['address'];
$password = password_hash($_POST['password'], PASSWORD_DEFAULT);
$role = 'user';

$created_at = date('Y-m-d H:i:s');

$sql = "INSERT INTO users (username, email, phone, address, password, role, created_at) 
        VALUES (?, ?, ?, ?, ?, ?, ?)";

$stmt = $conn->prepare($sql);
$stmt->bind_param("sssssss", $username, $email, $phone, $address, $password, $role, $created_at);


// Check if email already exists
$stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    echo json_encode(['status' => 'error', 'message' => 'Email already registered']);
    $stmt->close();
    $conn->close();
    exit();
}
$stmt->close();

// Insert new user
$stmt = $conn->prepare("INSERT INTO users (username, email, phone, address, password, role) VALUES (?, ?, ?, ?, ?, ?)");
$stmt->bind_param("ssssss", $username, $email, $phone, $address, $password, $role);

if ($stmt->execute()) {
    echo json_encode([
        'status' => 'success',
        'message' => 'Registration successful'
    ]);
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Registration failed: ' . $stmt->error
    ]);
}

$stmt->close();
$conn->close();
?>