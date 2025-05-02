<?php
require_once "../config/database.php";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);
    
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
?>