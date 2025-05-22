<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: GET');

// Database connection
$connection = mysqli_connect('localhost', 'root', '', 'happypaws');
if (!$connection) {
    die(json_encode([
        'success' => false,
        'message' => 'Database connection failed: ' . mysqli_connect_error()
    ]));
}

// Get email from request
$email = isset($_GET['email']) ? mysqli_real_escape_string($connection, $_GET['email']) : '';

if (empty($email)) {
    die(json_encode([
        'success' => false,
        'message' => 'Email parameter is required'
    ]));
}

// Prepare the query
// Update the query to use user_id and get latest bookings
$query = "SELECT 
            g.id,
            g.tanggal_grooming,
            g.waktu_booking,
            g.nama_pemilik,
            g.no_hp,
            g.jenis_hewan,
            g.paket_grooming,
            g.pengantaran,
            g.kecamatan,
            g.desa,
            g.detail_alamat,
            g.total_harga,
            g.metode_pembayaran,
            g.bukti_transaksi,
            g.status,
            g.created_at,
            u.username,
            u.email
          FROM grooming g 
          INNER JOIN users u ON g.id = u.id 
          WHERE u.email = ?
          ORDER BY g.id DESC";

try {
    $stmt = mysqli_prepare($connection, $query);
    if (!$stmt) {
        throw new Exception('Query preparation failed: ' . mysqli_error($connection));
    }

    mysqli_stmt_bind_param($stmt, "s", $email);
    if (!mysqli_stmt_execute($stmt)) {
        throw new Exception('Query execution failed: ' . mysqli_stmt_error($stmt));
    }

    $result = mysqli_stmt_get_result($stmt);
    $data = [];

    while ($row = mysqli_fetch_assoc($result)) {
        // Format dates and times
        $row['tanggal_grooming'] = $row['tanggal_grooming'] ? date('d-m-Y', strtotime($row['tanggal_grooming'])) : null;
        $row['waktu_booking'] = $row['waktu_booking'] ? date('H:i', strtotime($row['waktu_booking'])) : null;
        $row['created_at'] = date('d-m-Y H:i', strtotime($row['created_at']));
        
        // Format price
        $row['total_harga'] = number_format($row['total_harga'], 0, ',', '.');
        
        // Handle enums
        $row['paket_grooming'] = strtoupper($row['paket_grooming']);
        $row['pengantaran'] = strtoupper($row['pengantaran']);
        
        // Handle nullable fields with defaults
        $row['status'] = $row['status'] ?? 'pending';
        $row['metode_pembayaran'] = $row['metode_pembayaran'] ?? 'pending';
        $row['kecamatan'] = $row['kecamatan'] ?? '-';
        $row['desa'] = $row['desa'] ?? '-';
        $row['detail_alamat'] = $row['detail_alamat'] ?? '-';
        $row['bukti_transaksi'] = $row['bukti_transaksi'] ?? '';
        $row['nama_pemilik'] = $row['nama_pemilik'] ?? '-';
        $row['no_hp'] = $row['no_hp'] ?? '-';
        $row['jenis_hewan'] = $row['jenis_hewan'] ?? '-';
        
        $data[] = $row;
    }

    echo json_encode([
        'success' => true,
        'data' => $data,
        'timestamp' => date('Y-m-d H:i:s')
    ]);

} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
} finally {
    if (isset($stmt)) {
        mysqli_stmt_close($stmt);
    }
    mysqli_close($connection);
}
?>