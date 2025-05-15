
<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$host = 'localhost';
$database = 'happypaws';
$username = 'root';
$password = '';

try {
    $conn = new PDO("mysql:host=$host;dbname=$database", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Handle file upload
    if (!isset($_FILES['bukti_transaksi'])) {
        throw new Exception('No file uploaded');
    }

    $file = $_FILES['bukti_transaksi'];
    $fileName = time() . '_' . $file['name'];
    $uploadPath = 'uploads/' . $fileName;
    
    // Create uploads directory if it doesn't exist
    if (!file_exists('uploads')) {
        mkdir('uploads', 0777, true);
    }

    // Move uploaded file
    if (!move_uploaded_file($file['tmp_name'], $uploadPath)) {
        throw new Exception('Failed to upload file');
    }

    // Update database
    $stmt = $conn->prepare("UPDATE grooming SET 
        metode_pembayaran = ?,
        bukti_transaksi = ?,
        status_pembayaran = ?
        WHERE id = ?");

    $stmt->execute([
        $_POST['payment_method'],
        $fileName,
        $_POST['status_pembayaran'],
        $_POST['booking_id']
    ]);

    echo json_encode([
        'success' => true,
        'message' => 'Payment updated successfully'
    ]);

} catch(Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}
?>