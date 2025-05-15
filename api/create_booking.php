<?php
require_once '../config/database.php';
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

try {
    $data = json_decode(file_get_contents('php://input'), true);
    
    $sql = "INSERT INTO grooming (
        tanggal_grooming, 
        waktu_booking, 
        nama_pemilik, 
        no_hp, 
        jenis_hewan, 
        paket_grooming, 
        pengantaran, 
        kecamatan, 
        desa, 
        detail_alamat, 
        total_harga,
        metode_pembayaran,
        status_pembayaran
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    $stmt = $conn->prepare($sql);
    $stmt->execute([
        $data['tanggal_grooming'],
        $data['waktu_booking'],
        $data['nama_pemilik'],
        $data['no_hp'],
        $data['jenis_hewan'],
        $data['paket_grooming'],
        $data['pengantaran'],
        $data['kecamatan'] ?: null,
        $data['desa'] ?: null,
        $data['detail_alamat'] ?: null,
        $data['total_harga'],
        'pending',
        'pending'
    ]);

    $bookingId = $conn->lastInsertId();
    echo json_encode(['success' => true, 'booking_id' => $bookingId]);

} catch(Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
?>