<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$conn = new mysqli("localhost", "root", "", "flutter_auth"); // Sesuaikan dengan kredensial database Anda

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $name = $_POST['name'];
    $phone = $_POST['phone'];
    $month = $_POST['month'];
    $date = $_POST['date'];
    $time = $_POST['time'];
    $animal_type = $_POST['animal_type'];
    $package = $_POST['package'];

    $sql = "INSERT INTO bookings (name, phone, month, date, time, animal_type, package) VALUES ('$name', '$phone', '$month', '$date', '$time', '$animal_type', '$package')";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "Booking created successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error: " . $conn->error]);
    }
}
?>