<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

$conn = new mysqli("localhost", "root", "", "happypaws");

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed']));
}

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

$sql = "INSERT INTO penitipan (check_in, check_out, nama_pemilik, no_hp, nama_hewan, 
        jenis_hewan, paket_penitipan, pengantaran, kecamatan, desa, detail_alamat, 
        catatan, total_harga, metode_pembayaran, bukti_transaksi) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

$stmt = $conn->prepare($sql);
$stmt->bind_param("ssssssssssssdss", 
    $_POST['check_in'],
    $_POST['check_out'],
    $_POST['nama_pemilik'],
    $_POST['no_hp'],
    $_POST['nama_hewan'],
    $_POST['jenis_hewan'],
    $_POST['paket_penitipan'],
    $_POST['pengantaran'],
    $_POST['kecamatan'],
    $_POST['desa'],
    $_POST['detail_alamat'],
    $_POST['catatan'],
    $_POST['total_harga'],
    $_POST['metode_pembayaran'],
    $bukti_transaksi
);

if ($stmt->execute()) {
    echo json_encode([
        'status' => 'success',
        'message' => 'Booking created successfully'
    ]);
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Failed to create booking: ' . $stmt->error
    ]);
}

$stmt->close();
$conn->close();
?>