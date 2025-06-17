-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 05, 2024 at 04:25 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dtrdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_employee`
--

CREATE TABLE `tbl_employee` (
  `employee_id` int(11) NOT NULL,
  `user_id` int(12) NOT NULL,
  `employee_fullname` varchar(50) NOT NULL,
  `employee_age` int(15) NOT NULL,
  `employee_gender` varchar(50) NOT NULL,
  `employee_address` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_employee`
--

INSERT INTO `tbl_employee` (`employee_id`, `user_id`, `employee_fullname`, `employee_age`, `employee_gender`, `employee_address`) VALUES
(2, 1, 'Nimriel', 21, 'Male', 'Bulua'),
(3, 1, 'Feliciano Sherdy Pagaran', 21, 'Male', 'Carmen'),
(4, 1, 'Ernest Carton', 21, 'Male', 'Lumbia');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_employeelogs`
--

CREATE TABLE `tbl_employeelogs` (
  `logs_id` int(12) NOT NULL,
  `employee_id` int(12) DEFAULT NULL,
  `log_type` varchar(30) DEFAULT NULL,
  `log_time` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_employeelogs`
--

INSERT INTO `tbl_employeelogs` (`logs_id`, `employee_id`, `log_type`, `log_time`) VALUES
(1, 3, 'Time In', '2024-02-05 04:02:10'),
(2, 3, 'Time In', '2024-02-05 11:05:12 AM'),
(3, 3, 'Time In', '2024-02-05 11:07:51 AM'),
(4, 3, 'Time In', '2024-02-05 11:07:55 AM'),
(5, 3, 'Time In', '2024-02-05 11:07:55 AM'),
(6, 3, 'Time Out', '2024-02-05 11:15:34 AM');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(12) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `pass_word` varchar(50) NOT NULL,
  `full_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_name`, `pass_word`, `full_name`) VALUES
(1, 'admin', '123', 'Joshua Gumahad');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_employee`
--
ALTER TABLE `tbl_employee`
  ADD PRIMARY KEY (`employee_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `tbl_employeelogs`
--
ALTER TABLE `tbl_employeelogs`
  ADD PRIMARY KEY (`logs_id`),
  ADD KEY `employee_id` (`employee_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_employee`
--
ALTER TABLE `tbl_employee`
  MODIFY `employee_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_employeelogs`
--
ALTER TABLE `tbl_employeelogs`
  MODIFY `logs_id` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_employee`
--
ALTER TABLE `tbl_employee`
  ADD CONSTRAINT `tbl_employee_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`);

--
-- Constraints for table `tbl_employeelogs`
--
ALTER TABLE `tbl_employeelogs`
  ADD CONSTRAINT `tbl_employeelogs_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `tbl_employee` (`employee_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
