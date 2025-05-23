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

// Get email and type from request
$email = isset($_GET['email']) ? mysqli_real_escape_string($connection, $_GET['email']) : '';
$type = isset($_GET['type']) ? mysqli_real_escape_string($connection, $_GET['type']) : 'grooming';

if (empty($email)) {
    die(json_encode([
        'success' => false,
        'message' => 'Email parameter is required'
    ]));
}

// Prepare the query based on type
$table = $type === 'grooming' ? 'grooming' : 'penitipan';
$query = "SELECT 
            b.*,
            u.username,
            u.email
          FROM $table b 
          INNER JOIN users u ON b.id = u.id 
          WHERE u.email = ?
          ORDER BY b.id DESC";

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
        if ($type === 'penitipan') {
            // Format penitipan dates
            $row['check_in'] = date('d F Y', strtotime($row['check_in']));
            $row['check_out'] = date('d F Y', strtotime($row['check_out']));
            $row['nama_hewan_display'] = $row['nama_hewan'] . ' (' . ucfirst($row['jenis_hewan']) . ')';
            $row['paket_penitipan'] = ucfirst($row['paket_penitipan']);
            $row['catatan'] = $row['catatan'] ?? '-';
            
            // Format price with Rp prefix
            $row['total_harga'] = 'Rp ' . number_format($row['total_harga'], 0, ',', '.');
            
            // Status and payment method as separate badges
            $row['status'] = ucfirst(strtolower($row['status']));
            $row['metode_pembayaran'] = strtoupper($row['metode_pembayaran'] ?? 'QRIS');
        } else {
            // Existing grooming formatting
            $row['tanggal_grooming'] = $row['tanggal_grooming'] ? date('d-m-Y', strtotime($row['tanggal_grooming'])) : null;
            $row['waktu_booking'] = $row['waktu_booking'] ? date('H:i', strtotime($row['waktu_booking'])) : null;
            $row['paket_grooming'] = strtoupper($row['paket_grooming']);
        }
        
        // Common fields
        $row['created_at'] = date('d-m-Y H:i', strtotime($row['created_at']));
        $row['pengantaran'] = strtoupper($row['pengantaran']);
        
        // Other nullable fields
        $row['kecamatan'] = $row['kecamatan'] ?? '-';
        $row['desa'] = $row['desa'] ?? '-';
        $row['detail_alamat'] = $row['detail_alamat'] ?? '-';
        $row['bukti_transaksi'] = $row['bukti_transaksi'] ?? '';
        $row['nama_pemilik'] = $row['nama_pemilik'] ?? '-';
        $row['no_hp'] = $row['no_hp'] ?? '-';
        
        $data[] = $row;
    }

    echo json_encode([
        'success' => true,
        'data' => $data,
        'type' => $type
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