<?php
require_once '../config/database.php';
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

try {
    if (!isset($_FILES['bukti_transaksi'])) {
        throw new Exception('No file uploaded');
    }

    // Handle file upload
    $uploadDir = '../uploads/';
    if (!file_exists($uploadDir)) {
        mkdir($uploadDir, 0777, true);
    }

    $file = $_FILES['bukti_transaksi'];
    $fileName = time() . '_' . $file['name'];
    $uploadPath = $uploadDir . $fileName;

    if (!move_uploaded_file($file['tmp_name'], $uploadPath)) {
        throw new Exception('Failed to upload file');
    }

    // Update database
    $stmt = $conn->prepare("UPDATE grooming SET 
        metode_pembayaran = ?,
        bukti_transaksi = ?,
        status_pembayaran = 'pending'
        WHERE id = ?");

    $stmt->execute([
        $_POST['payment_method'],
        $fileName,
        $_POST['booking_id']
    ]);

    echo json_encode([
        'success' => true,
        'message' => 'Payment updated successfully'
    ]);

} catch(Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}
?>