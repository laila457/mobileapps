<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

echo json_encode(["status" => "success", "message" => "Server is running"]);
?>
