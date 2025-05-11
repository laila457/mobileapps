<?php
header('Content-Type: application/json');
require_once 'db_connect.php';

$data = json_decode(file_get_contents('php://input'), true);

if (isset($data['booking_id']) && isset($data['payment_method'])) {
    $booking_id = $data['booking_id'];
    $payment_method = $data['payment_method'];
    $payment_status = $data['payment_status'];
    $payment_date = $data['payment_date'];

    $sql = "UPDATE hotel_bookings SET 
            payment_status = ?, 
            payment_method = ?, 
            payment_date = ? 
            WHERE id = ?";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssss", $payment_status, $payment_method, $payment_date, $booking_id);

    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false, 'error' => $conn->error]);
    }
} else {
    echo json_encode(['success' => false, 'error' => 'Missing required fields']);
}

$conn->close();
?>