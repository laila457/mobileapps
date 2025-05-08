<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST');

include 'connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $booking_id = $_POST['booking_id'];
        $amount = $_POST['amount'];
        $payment_method = $_POST['payment_method'];
        $booking_type = $_POST['booking_type'];

        // Begin transaction
        $conn->begin_transaction();

        // Insert payment record
        $query = "INSERT INTO payments (booking_id, booking_type, amount, payment_method, payment_status) 
                 VALUES (?, ?, ?, ?, 'paid')";
        
        $stmt = $conn->prepare($query);
        $stmt->bind_param("isds", $booking_id, $booking_type, $amount, $payment_method);
        $stmt->execute();

        // Update booking status
        $updateQuery = "UPDATE pet_grooming SET status = 'confirmed' WHERE id = ?";
        $updateStmt = $conn->prepare($updateQuery);
        $updateStmt->bind_param("i", $booking_id);
        $updateStmt->execute();

        // Commit transaction
        $conn->commit();

        echo json_encode([
            'success' => true,
            'message' => 'Payment processed successfully'
        ]);

    } catch (Exception $e) {
        // Rollback on error
        $conn->rollback();
        
        echo json_encode([
            'success' => false,
            'message' => 'Error: ' . $e->getMessage()
        ]);
    }
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid request method'
    ]);
}

$conn->close();
?>