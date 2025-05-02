<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../config/database.php';

error_reporting(E_ALL);
ini_set('display_errors', 1);

$database = new Database();
$db = $database->getConnection();

$rawData = file_get_contents("php://input");
file_put_contents('debug.log', "Received data: " . $rawData . "\n", FILE_APPEND);

$data = json_decode($rawData);

if ($data) {
    try {
        $query = "INSERT INTO pet_hotel SET 
            owner_name = :owner_name,
            pet_name = :pet_name,
            pet_type = :pet_type,
            check_in_date = :check_in_date,
            check_out_date = :check_out_date,
            phone_number = :phone_number,
            package = :package,
            delivery_type = :delivery_type,
            kecamatan = :kecamatan,
            kelurahan = :kelurahan,
            address = :address,
            special_requirements = :special_requirements";

        $stmt = $db->prepare($query);

        // Bind parameters
        $stmt->bindParam(":owner_name", $data->owner_name);
        $stmt->bindParam(":pet_name", $data->pet_name);
        $stmt->bindParam(":pet_type", $data->pet_type);
        $stmt->bindParam(":check_in_date", $data->check_in_date);
        $stmt->bindParam(":check_out_date", $data->check_out_date);
        $stmt->bindParam(":phone_number", $data->phone_number);
        $stmt->bindParam(":package", $data->package);
        $stmt->bindParam(":delivery_type", $data->delivery_type);
        $stmt->bindParam(":kecamatan", $data->kecamatan);
        $stmt->bindParam(":kelurahan", $data->kelurahan);
        $stmt->bindParam(":address", $data->address);
        $stmt->bindParam(":special_requirements", $data->special_requirements);

        if ($stmt->execute()) {
            http_response_code(201);
            echo json_encode(["message" => "Hotel booking created successfully"]);
        } else {
            file_put_contents('debug.log', "Execute failed: " . print_r($stmt->errorInfo(), true) . "\n", FILE_APPEND);
            http_response_code(503);
            echo json_encode(["message" => "Failed to create booking"]);
        }
    } catch (PDOException $e) {
        file_put_contents('debug.log', "Database error: " . $e->getMessage() . "\n", FILE_APPEND);
        http_response_code(503);
        echo json_encode(["message" => "Database error: " . $e->getMessage()]);
    }
} else {
    file_put_contents('debug.log', "Invalid JSON data received\n", FILE_APPEND);
    http_response_code(400);
    echo json_encode(["message" => "Invalid data format"]);
}
?>