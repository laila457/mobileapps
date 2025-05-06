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

    $data = json_decode(file_get_contents('php://input'), true);
    
    if (!$data) {
        throw new Exception('Invalid input data');
    }

    $stmt = $conn->prepare("INSERT INTO pet_hotel (owner_name, pet_name, pet_type, check_in_date, check_out_date, phone_number, package, delivery_type, kecamatan, kelurahan, address, special_requirements) VALUES (:owner_name, :pet_name, :pet_type, :check_in_date, :check_out_date, :phone_number, :package, :delivery_type, :kecamatan, :kelurahan, :address, :special_requirements)");
    
    $stmt->execute([
        ':owner_name' => $data['owner_name'],
        ':pet_name' => $data['pet_name'],
        ':pet_type' => $data['pet_type'],
        ':check_in_date' => $data['check_in_date'],
        ':check_out_date' => $data['check_out_date'],
        ':phone_number' => $data['phone_number'],
        ':package' => $data['package'],
        ':delivery_type' => $data['delivery_type'],
        ':kecamatan' => $data['kecamatan'],
        ':kelurahan' => $data['kelurahan'],
        ':address' => $data['address'],
        ':special_requirements' => $data['special_requirements']
    ]);

    echo json_encode(['success' => true, 'message' => 'Hotel booking created successfully']);
} catch(Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
?>