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
$database = 'flutter_auth';
$username = 'root';
$password = '';

try {
    $conn = new PDO("mysql:host=$host;dbname=$database", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Check if it's a payment request
    if (isset($_POST['booking_id']) && isset($_POST['amount']) && isset($_POST['payment_method'])) {
        // Handle payment
        $stmt = $conn->prepare("INSERT INTO payments (booking_id, amount, payment_method) VALUES (:booking_id, :amount, :payment_method)");
        
        $stmt->execute([
            ':booking_id' => $_POST['booking_id'],
            ':amount' => $_POST['amount'],
            ':payment_method' => $_POST['payment_method']
        ]);

        // Update booking status
        $updateStmt = $conn->prepare("UPDATE pet_grooming SET status = 'confirmed' WHERE id = :booking_id");
        $updateStmt->execute([':booking_id' => $_POST['booking_id']]);

        echo json_encode(['success' => true, 'message' => 'Payment created successfully']);
    } else {
        // Handle grooming booking
        $data = json_decode(file_get_contents('php://input'), true);
        
        if (!$data) {
            throw new Exception('Invalid input data');
        }

        $stmt = $conn->prepare("INSERT INTO pet_grooming (owner_name, pet_name, pet_type, service_date, service_time, phone_number, package, delivery_type, kecamatan, kelurahan, address, notes) VALUES (:owner_name, :pet_name, :pet_type, :service_date, :service_time, :phone_number, :package, :delivery_type, :kecamatan, :kelurahan, :address, :notes)");
        
        $stmt->execute([
            ':owner_name' => $data['owner_name'],
            ':pet_name' => $data['pet_name'],
            ':pet_type' => $data['pet_type'],
            ':service_date' => $data['service_date'],
            ':service_time' => $data['service_time'],
            ':phone_number' => $data['phone_number'],
            ':package' => $data['package'],
            ':delivery_type' => $data['delivery_type'],
            ':kecamatan' => $data['kecamatan'],
            ':kelurahan' => $data['kelurahan'],
            ':address' => $data['address'],
            ':notes' => $data['notes']
        ]);

        $bookingId = $conn->lastInsertId();
        echo json_encode(['success' => true, 'message' => 'Booking created successfully', 'booking_id' => $bookingId]);
    }
} catch(Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
?>