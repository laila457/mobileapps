<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$conn = new mysqli('localhost', 'root', '', 'happypaws');

if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => 'Connection failed: ' . $conn->connect_error]));
}

$data = $_POST;

$sql = "INSERT INTO penitipan (
    check_in,
    check_out,
    nama_pemilik,
    no_hp,
    nama_hewan,
    jenis_hewan,
    paket_penitipan,
    pengantaran,
    kecamatan,
    desa,
    detail_alamat,
    catatan,
    total_harga,
    metode_pembayaran
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

$stmt = $conn->prepare($sql);
$stmt->bind_param(
    "ssssssssssssds",
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
    $data['metode_pembayaran']
);

if ($stmt->execute()) {
    $booking_id = $conn->insert_id;
    echo json_encode(['success' => true, 'booking_id' => $booking_id]);
} else {
    echo json_encode(['success' => false, 'message' => $stmt->error]);
}

$stmt->close();
$conn->close();
?>