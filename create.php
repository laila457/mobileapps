<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$host = 'localhost';
$database = 'happypaws';
$username = 'root';
$password = '';

// Add this function before the try block
function validatePaymentMethod($method) {
    $validMethods = ['qris', 'cash', 'bankTransfer'];
    return in_array($method, $validMethods) ? $method : 'pending';
}

try {
    $conn = new PDO("mysql:host=$host;dbname=$database", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $data = json_decode(file_get_contents('php://input'), true);
    
    if (!$data) {
        throw new Exception('Invalid input data');
    }

    // Validate and format payment method
    $paymentMethod = validatePaymentMethod($data['metode_pembayaran'] ?? '');

    $sql = "INSERT INTO grooming (
        user_id,
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
        status
    ) VALUES (
        :user_id,
        :tanggal_grooming,
        :waktu_booking,
        :nama_pemilik,
        :no_hp,
        :jenis_hewan,
        :paket_grooming,
        :pengantaran,
        :kecamatan,
        :desa,
        :detail_alamat,
        :total_harga,
        :metode_pembayaran,
        :status
    )";

    $stmt = $conn->prepare($sql);

    $stmt->execute([
        ':user_id' => $data['user_id'] ?? null,
        ':tanggal_grooming' => $data['tanggal_grooming'],
        ':waktu_booking' => $data['waktu_booking'],
        ':nama_pemilik' => $data['nama_pemilik'],
        ':no_hp' => $data['no_hp'],
        ':jenis_hewan' => $data['jenis_hewan'],
        ':paket_grooming' => $data['paket_grooming'],
        ':pengantaran' => $data['pengantaran'],
        ':kecamatan' => $data['kecamatan'] ?: null,
        ':desa' => $data['desa'] ?: null,
        ':detail_alamat' => $data['detail_alamat'] ?: null,
        ':total_harga' => $data['total_harga'],
        ':metode_pembayaran' => $paymentMethod,
        ':status' => $data['status'] ?: 'pending'
    ]);

    $bookingId = $conn->lastInsertId();

    // Add payment method info to response
    echo json_encode([
        'success' => true,
        'message' => 'Booking created successfully',
        'booking_id' => $bookingId,
        'payment_method' => [
            'value' => $paymentMethod,
            'label' => ucfirst($paymentMethod),
            'style' => match($paymentMethod) {
                'qris' => 'success',
                'cash' => 'warning',
                'bankTransfer' => 'info',
                default => 'secondary'
            }
        ]
    ]);

} catch(Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}
?>