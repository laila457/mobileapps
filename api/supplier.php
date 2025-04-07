<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER["REQUEST_METHOD"] == "OPTIONS") {
    http_response_code(200);
    exit;
}

// Koneksi ke database
$conn = new mysqli("localhost", "root", "", "flutter_auth");
if ($conn->connect_error) {
    die(json_encode(["error" => "Koneksi gagal: " . $conn->connect_error]));
}

// Cek metode request
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case "GET":
        // Ambil semua supplier
        $result = $conn->query("SELECT * FROM supplier");
        $data = $result->fetch_all(MYSQLI_ASSOC);
        echo json_encode($data);
        break;

    case "POST":
        // Tambah supplier
        $input = json_decode(file_get_contents("php://input"), true);
        if (!$input) {
            $input = $_POST;
        }

        $nama = $conn->real_escape_string($input["nama"]);
        $email = $conn->real_escape_string($input["email"]);
        $telepon = $conn->real_escape_string($input["telepon"]);
        $alamat = $conn->real_escape_string($input["alamat"]);

        $stmt = $conn->prepare("INSERT INTO supplier (nama, email, telepon, alamat) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("ssss", $nama, $email, $telepon, $alamat);
        if ($stmt->execute()) {
            echo json_encode(["message" => "supplier berhasil ditambahkan"]);
        } else {
            echo json_encode(["error" => "Gagal menambahkan supplier", "detail" => $conn->error]);
        }
        break;

    case "PUT":
        // Update supplier
        $input = json_decode(file_get_contents("php://input"), true);
        $id = (int) $input["id"];
        $nama = $conn->real_escape_string($input["nama"]);
        $email = $conn->real_escape_string($input["email"]);
        $telepon = $conn->real_escape_string($input["telepon"]);
        $alamat = $conn->real_escape_string($input["alamat"]);

        $stmt = $conn->prepare("UPDATE supplier SET nama=?, email=?, telepon=?, alamat=? WHERE id=?");
        $stmt->bind_param("ssssi", $nama, $email, $telepon, $alamat, $id);
        if ($stmt->execute()) {
            echo json_encode(["message" => "supplier berhasil diperbarui"]);
        } else {
            echo json_encode(["error" => "Gagal memperbarui supplier", "detail" => $conn->error]);
        }
        break;

    
        case "DELETE":
            // Ambil ID dari query parameter
            if (isset($_GET['id'])) {
                $id = (int) $_GET['id'];

                $stmt = $conn->prepare("DELETE FROM supplier WHERE id=?");
                $stmt->bind_param("i", $id);

                if ($stmt->execute()) {
                    echo json_encode(["message" => "supplier berhasil dihapus"]);
                } else {
                    echo json_encode(["error" => "Gagal menghapus supplier", "detail" => $conn->error]);
                }
            } else {
                echo json_encode(["error" => "ID tidak ditemukan"]);
            }
        break;

    default:
        echo json_encode(["error" => "Metode tidak diizinkan"]);
        break;
}

$conn->close();
?>