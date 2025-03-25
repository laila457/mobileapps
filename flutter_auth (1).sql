-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 25, 2025 at 09:40 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `flutter_auth`
--

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `harga` int(11) NOT NULL,
  `stok` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`id`, `nama`, `harga`, `stok`) VALUES
(4, 'minyak wijen', 10000, 1000),
(5, 'sirup marjan', 20000, 1000),
(6, 'saus Indofood', 24000, 1000),
(7, 'minyak sayur', 3000, 1000),
(8, 'beras putih ', 1000, 1000),
(9, 'garam', 1000, 1000),
(10, 'minyak baby oil', 13000, 200),
(11, 'korek api ', 2000, 2000);

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `month` varchar(20) NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `animal_type` varchar(50) NOT NULL,
  `package` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telepon` varchar(15) NOT NULL,
  `alamat` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`id`, `nama`, `email`, `telepon`, `alamat`) VALUES
(1, 'Ahmad Fauzi 2', 'ahmad@example.com', '081234567890', 'Bandung'),
(2, 'Siti Aisyah', 'siti@example.com', '081298765432', 'Jakarta');

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telepon` varchar(15) NOT NULL,
  `alamat` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`id`, `nama`, `email`, `telepon`, `alamat`) VALUES
(2, 'Siti Aisyah', 'siti@example.com', '081298765432', 'Jakarta'),
(3, 'Budi Santoso', 'budi@example.com', '081211223344', 'Bekasi'),
(4, 'Agus2', 'denzoe.da@gmail.com', '087780226969', 'Karawang');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`) VALUES
(1, 'admin', 'admin@gmail.com', '$2y$10$sTTtI236SXyFcKHQP8meYu1g/xtMbX2uATVZnlS0IcMQxtZ.Uvm0e'),
(2, 'nazwa', 'nazwa@gmail.com', '$2y$10$Xpo2Wtdnm2ZOYFPd/ZTTduU7CicT9ja.07Cajx8wXw9LsmHryCPkm'),
(3, 'salsa lismaya', 'lismayacaca@gmail.com', '$2y$10$3yc5mCHZXrGcJY6LpFtFie7FEGEfVE6IdmoJ3dPEpFMIIy6xikZ1a'),
(4, 'jane', 'jane@gmail.com', '$2y$10$M3y7W7UzhXY1jY5HyyVZLeB4TacXETkUXBSzdUxTRhkHfcCzOzWMe'),
(5, 'ola', 'ola@gmail.com', '$2y$10$7WOS0/iz.VwEdgs0UoV11.cVXNWMB9AuAlmDAUs.AMVYk1CmxLGLC'),
(6, 'il', 'il@gmail.com', '$2y$10$E28JcWPZKFIbH7snxyxmiOB.G.xeleU0f/en/oPx/kapgNaAfSyTa'),
(7, 'ira', 'ira@gmail.com', '$2y$10$dq2JZJcM/BHJrWhZ1AKZWe0dwR8gWbm5ZBprdnLN1phDcCf48iON.'),
(8, 'gina', 'gina@gmail.com', '$2y$10$dBBpNRU3at.3czDoaTeDUuMpcWqc6od4UEhhR.8Cc6de7yEOsYXS2'),
(9, 'mia', 'mia@gmail.com', '$2y$10$AQu5djR.pRpXqb3xEOZMbewK.kQ0RdJHkGPotYvXvqLTwd0jZCLS6');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `barang`
--
ALTER TABLE `barang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
