<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$conn = new mysqli("localhost", "root", "", "happypaws");

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed']));
}

$booking_id = $_POST['booking_id'];
$metode_pembayaran = $_POST['metode_pembayaran'];
$bukti_transaksi = null;

if (isset($_FILES['bukti_transaksi']) && $_FILES['bukti_transaksi']['error'] === UPLOAD_ERR_OK) {
    $upload_dir = 'assets/uploads/payments/';
    if (!file_exists($upload_dir)) {
        mkdir($upload_dir, 0777, true);
    }
    
    $file_extension = pathinfo($_FILES['bukti_transaksi']['name'], PATHINFO_EXTENSION);
    $file_name = uniqid() . '.' . $file_extension;
    $file_path = $upload_dir . $file_name;
    
    if (move_uploaded_file($_FILES['bukti_transaksi']['tmp_name'], $file_path)) {
        $bukti_transaksi = $file_path;
    }
}

$sql = "UPDATE penitipan SET metode_pembayaran = ?, bukti_transaksi = ? WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssi", $metode_pembayaran, $bukti_transaksi, $booking_id);

if ($stmt->execute()) {
    echo json_encode([
        'status' => 'success',
        'message' => 'Payment updated successfully'
    ]);
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Failed to update payment: ' . $stmt->error
    ]);
}

$stmt->close();
$conn->close();
?>