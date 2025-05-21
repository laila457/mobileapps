
<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$connection = mysqli_connect('localhost', 'root', '', 'happypaws');
if (!$connection) {
    die(json_encode(['success' => false, 'message' => 'Database connection failed']));
}

$booking_id = $_POST['booking_id'] ?? '';
$metode_pembayaran = $_POST['metode_pembayaran'] ?? '';
$status = $_POST['status'] ?? 'pending';

// Handle file upload
$bukti_transaksi = '';
if (isset($_FILES['bukti_transaksi']) && $_FILES['bukti_transaksi']['error'] === UPLOAD_ERR_OK) {
    $upload_dir = 'uploads/';
    if (!file_exists($upload_dir)) {
        mkdir($upload_dir, 0777, true);
    }
    
    $file_extension = pathinfo($_FILES['bukti_transaksi']['name'], PATHINFO_EXTENSION);
    $filename = uniqid() . '.' . $file_extension;
    $target_path = $upload_dir . $filename;
    
    if (move_uploaded_file($_FILES['bukti_transaksi']['tmp_name'], $target_path)) {
        $bukti_transaksi = $target_path;
    }
}

// Update grooming record
$query = "UPDATE grooming SET 
            metode_pembayaran = ?,
            bukti_transaksi = ?,
            status = ?
          WHERE id = ?";

$stmt = mysqli_prepare($connection, $query);
mysqli_stmt_bind_param($stmt, "sssi", $metode_pembayaran, $bukti_transaksi, $status, $booking_id);

if (mysqli_stmt_execute($stmt)) {
    echo json_encode(['success' => true, 'message' => 'Payment updated successfully']);
} else {
    echo json_encode(['success' => false, 'message' => 'Failed to update payment']);
}

mysqli_close($connection);
?>