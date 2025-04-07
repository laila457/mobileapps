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
        // Ambil semua barang
        $result = $conn->query("SELECT * FROM barang");
        $data = $result->fetch_all(MYSQLI_ASSOC);
        echo json_encode($data);
        break;

    case "POST":
        // Tambah barang
        $input = json_decode(file_get_contents("php://input"), true);
        if (!$input) {
            $input = $_POST; // Jika JSON gagal, coba ambil dari POST
        }

        $nama = $conn->real_escape_string($input["nama"]);
        $harga = (int) $input["harga"];
        $stok = (int) $input["stok"];

        $stmt = $conn->prepare("INSERT INTO barang (nama, harga, stok) VALUES (?, ?, ?)");
        $stmt->bind_param("sii", $nama, $harga, $stok);
        if ($stmt->execute()) {
            echo json_encode(["message" => "Barang berhasil ditambahkan"]);
        } else {
            echo json_encode(["error" => "Gagal menambahkan barang", "detail" => $conn->error]);
        }
        break;

    case "PUT":
        // Update barang
        $input = json_decode(file_get_contents("php://input"), true);
        $id = (int) $input["id"];
        $nama = $conn->real_escape_string($input["nama"]);
        $harga = (int) $input["harga"];
        $stok = (int) $input["stok"];

        $stmt = $conn->prepare("UPDATE barang SET nama=?, harga=?, stok=? WHERE id=?");
        $stmt->bind_param("siii", $nama, $harga, $stok, $id);
        if ($stmt->execute()) {
            echo json_encode(["message" => "Barang berhasil diperbarui"]);
        } else {
            echo json_encode(["error" => "Gagal memperbarui barang", "detail" => $conn->error]);
        }
        break;

        case "DELETE":
            // Ambil ID dari query parameter
            if (isset($_GET['id'])) {
                $id = (int) $_GET['id'];

                $stmt = $conn->prepare("DELETE FROM barang WHERE id=?");
                $stmt->bind_param("i", $id);

                if ($stmt->execute()) {
                    echo json_encode(["message" => "Barang berhasil dihapus"]);
                } else {
                    echo json_encode(["error" => "Gagal menghapus barang", "detail" => $conn->error]);
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