<?php
header('Content-Type: application/json');

// Database connection
$host = 'localhost'; // Update with your database host
$db_name = 'flutter_auth'; // Your database name
$username = 'your_username'; // Your database username
$password = 'your_password'; // Your database password

$conn = new mysqli($host, $username, $password, $db_name);

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Database connection failed']));
}

// Fetch bookings
$result = $conn->query("SELECT * FROM bookings");
$bookings = [];

while ($row = $result->fetch_assoc()) {
    $bookings[] = $row;
}

echo json_encode($bookings);

$conn->close();
?>