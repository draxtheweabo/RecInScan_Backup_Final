-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 12, 2024 at 06:36 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `recinscan`
--

-- --------------------------------------------------------

--
-- Table structure for table `ingredients`
--

CREATE TABLE `ingredients` (
  `id` int(11) NOT NULL,
  `ingredient_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ingredients`
--

INSERT INTO `ingredients` (`id`, `ingredient_name`) VALUES
(1, 'all purpose cream'),
(2, 'annatto powder'),
(3, 'bay leaf'),
(4, 'beef brisket'),
(5, 'bell pepper'),
(6, 'black pepper'),
(7, 'brown sugar'),
(8, 'calamansi'),
(9, 'calamansi juice'),
(10, 'carrot'),
(11, 'chicken liver'),
(12, 'chili pepper'),
(13, 'fish sauce'),
(14, 'garlic'),
(15, 'grated cheese'),
(16, 'green bell pepper'),
(17, 'green chili'),
(18, 'green peas'),
(19, 'hotdogs'),
(20, 'lemon'),
(21, 'lemon juice'),
(22, 'liver spread'),
(23, 'oregano'),
(24, 'pineapple juice'),
(25, 'pork belly'),
(26, 'pork butt'),
(27, 'pork ear'),
(28, 'pork face'),
(29, 'pork liver'),
(30, 'pork skin'),
(31, 'potato'),
(32, 'raisin'),
(33, 'red bell pepper'),
(34, 'red chili'),
(35, 'red onion'),
(36, 'salt'),
(37, 'soy sauce'),
(38, 'tomato'),
(39, 'tomato paste'),
(40, 'tomato sauce'),
(41, 'white onion');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ingredients`
--
ALTER TABLE `ingredients`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ingredients`
--
ALTER TABLE `ingredients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
