<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$connection = mysqli_connect('localhost', 'root', '', 'happypaws');
if (!$connection) {
    die(json_encode(['success' => false, 'message' => 'Database connection failed']));
}

$email = isset($_GET['email']) ? $_GET['email'] : '';

if (empty($email)) {
    die(json_encode(['success' => false, 'message' => 'Email is required']));
}

$query = "SELECT g.* 
          FROM grooming g 
          INNER JOIN users u ON g.user_id = u.id 
          WHERE u.email = ?
          ORDER BY g.created_at DESC";

$stmt = mysqli_prepare($connection, $query);
mysqli_stmt_bind_param($stmt, "s", $email);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);

$data = [];
while ($row = mysqli_fetch_assoc($result)) {
    // Format the values
    $row['tanggal_grooming'] = $row['tanggal_grooming'] ? date('d-m-Y', strtotime($row['tanggal_grooming'])) : null;
    $row['waktu_booking'] = $row['waktu_booking'] ? date('H:i', strtotime($row['waktu_booking'])) : null;
    $row['total_harga'] = number_format($row['total_harga'], 0, ',', '.');
    $data[] = $row;
}

echo json_encode([
    'success' => true,
    'data' => $data
]);

mysqli_close($connection);
?>