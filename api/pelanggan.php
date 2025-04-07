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
        // Ambil semua pelanggan
        $result = $conn->query("SELECT * FROM pelanggan");
        $data = $result->fetch_all(MYSQLI_ASSOC);
        echo json_encode($data);
        break;

    case "POST":
        // Tambah pelanggan
        $input = json_decode(file_get_contents("php://input"), true);
        if (!$input) {
            $input = $_POST;
        }

        $nama = $conn->real_escape_string($input["nama"]);
        $email = $conn->real_escape_string($input["email"]);
        $telepon = $conn->real_escape_string($input["telepon"]);
        $alamat = $conn->real_escape_string($input["alamat"]);

        $stmt = $conn->prepare("INSERT INTO pelanggan (nama, email, telepon, alamat) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("ssss", $nama, $email, $telepon, $alamat);
        if ($stmt->execute()) {
            echo json_encode(["message" => "Pelanggan berhasil ditambahkan"]);
        } else {
            echo json_encode(["error" => "Gagal menambahkan pelanggan", "detail" => $conn->error]);
        }
        break;

    case "PUT":
        // Update pelanggan
        $input = json_decode(file_get_contents("php://input"), true);
        $id = (int) $input["id"];
        $nama = $conn->real_escape_string($input["nama"]);
        $email = $conn->real_escape_string($input["email"]);
        $telepon = $conn->real_escape_string($input["telepon"]);
        $alamat = $conn->real_escape_string($input["alamat"]);

        $stmt = $conn->prepare("UPDATE pelanggan SET nama=?, email=?, telepon=?, alamat=? WHERE id=?");
        $stmt->bind_param("ssssi", $nama, $email, $telepon, $alamat, $id);
        if ($stmt->execute()) {
            echo json_encode(["message" => "Pelanggan berhasil diperbarui"]);
        } else {
            echo json_encode(["error" => "Gagal memperbarui pelanggan", "detail" => $conn->error]);
        }
        break;


        case "DELETE":
            // Ambil ID dari query parameter
            if (isset($_GET['id'])) {
                $id = (int) $_GET['id'];

                $stmt = $conn->prepare("DELETE FROM pelanggan WHERE id=?");
                $stmt->bind_param("i", $id);

                if ($stmt->execute()) {
                    echo json_encode(["message" => "pelanggan berhasil dihapus"]);
                } else {
                    echo json_encode(["error" => "Gagal menghapus pelanggan", "detail" => $conn->error]);
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