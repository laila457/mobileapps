<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

$conn = new mysqli("localhost", "root", "", "happypaws");

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed']));
}

// Get JSON data
$data = json_decode(file_get_contents('php://input'), true);

$sql = "INSERT INTO penitipan (
    user_id, check_in, check_out, nama_pemilik, no_hp, nama_hewan, 
    jenis_hewan, paket_penitipan, pengantaran, kecamatan, desa, 
    detail_alamat, catatan, total_harga, metode_pembayaran, status
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

$stmt = $conn->prepare($sql);
$stmt->bind_param("issssssssssssdss", 
    $data['user_id'],
    $data['check_in'],
    $data['check_out'],
    $data['nama_pemilik'],
    $data['no_hp'],
    $data['nama_hewan'],
    $data['jenis_hewan'],
    $data['paket_penitipan'],
    $data['pengantaran'],
    $data['kecamatan'],
    $data['desa'],
    $data['detail_alamat'],
    $data['catatan'],
    $data['total_harga'],
    $data['metode_pembayaran'],
    $data['status']
);

if ($stmt->execute()) {
    $booking_id = $stmt->insert_id;
    echo json_encode([
        'status' => 'success',
        'message' => 'Booking created successfully',
        'booking_id' => $booking_id
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