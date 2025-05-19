<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$connection = mysqli_connect('localhost', 'root', '', 'happypaws');
if (!$connection) {
    die(json_encode([
        'success' => false,
        'message' => 'Database connection failed'
    ]));
}

// Get all grooming records
$query = "SELECT * FROM grooming ORDER BY tanggal_grooming DESC, waktu_booking DESC";
$result = mysqli_query($connection, $query);

$data = array();
while ($row = mysqli_fetch_assoc($result)) {
    $data[] = $row;
}

echo json_encode(['success' => true, 'data' => $data]);
mysqli_close($connection);
?>