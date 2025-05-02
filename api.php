<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Database connection
$host = "localhost";
$user = "root";
$password = "";
$database = "flutter_auth";

$conn = new mysqli($host, $user, $password, $database);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the request type
$action = isset($_GET['action']) ? $_GET['action'] : '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);
    
    switch($action) {
        case 'grooming':
            createGroomingReservation($conn, $data);
            break;
            
        case 'hotel':
            createHotelReservation($conn, $data);
            break;
            
        default:
            echo json_encode(["success" => false, "message" => "Invalid action"]);
    }
}

function createGroomingReservation($conn, $data) {
    $owner_name = $data['owner_name'];
    $pet_name = $data['pet_name'];
    $pet_type = $data['pet_type'];
    $service_date = $data['service_date'];
    $service_time = $data['service_time'];
    $phone_number = $data['phone_number'];
    $notes = $data['notes'];
    
    $sql = "INSERT INTO pet_grooming (owner_name, pet_name, pet_type, service_date, service_time, phone_number, notes) 
            VALUES (?, ?, ?, ?, ?, ?, ?)";
            
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssssss", $owner_name, $pet_name, $pet_type, $service_date, $service_time, $phone_number, $notes);
    
    if ($stmt->execute()) {
        echo json_encode(["success" => true, "message" => "Grooming reservation created successfully"]);
    } else {
        echo json_encode(["success" => false, "message" => "Error: " . $conn->error]);
    }
    
    $stmt->close();
}

function createHotelReservation($conn, $data) {
    $owner_name = $data['owner_name'];
    $pet_name = $data['pet_name'];
    $pet_type = $data['pet_type'];
    $check_in_date = $data['check_in_date'];
    $check_out_date = $data['check_out_date'];
    $phone_number = $data['phone_number'];
    $special_requirements = $data['special_requirements'];
    
    $sql = "INSERT INTO pet_hotel (owner_name, pet_name, pet_type, check_in_date, check_out_date, phone_number, special_requirements) 
            VALUES (?, ?, ?, ?, ?, ?, ?)";
            
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssssss", $owner_name, $pet_name, $pet_type, $check_in_date, $check_out_date, $phone_number, $special_requirements);
    
    if ($stmt->execute()) {
        echo json_encode(["success" => true, "message" => "Hotel reservation created successfully"]);
    } else {
        echo json_encode(["success" => false, "message" => "Error: " . $conn->error]);
    }
    
    $stmt->close();
}

$conn->close();
?>