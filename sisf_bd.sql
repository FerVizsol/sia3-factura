-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Sep 13, 2023 at 02:40 AM
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
-- Database: `sisf`
--

-- --------------------------------------------------------

--
-- Table structure for table `cliente`
--

CREATE TABLE `cliente` (
  `codRuc` int(11) NOT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `telefono` int(9) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cliente`
--

INSERT INTO `cliente` (`codRuc`, `nombre`, `email`, `direccion`, `telefono`) VALUES
(1, 'Cliente A', 'clienteA@example.com', 'Dirección A', 123456789),
(2, 'Cliente B', 'clienteB@example.com', 'Dirección B', 987654321),
(3, 'Cliente C', 'clienteC@example.com', 'Dirección C', 555555555);

-- --------------------------------------------------------

--
-- Table structure for table `detalle_factura`
--

CREATE TABLE `detalle_factura` (
  `codDetalle` int(10) NOT NULL,
  `codFactura` varchar(255) DEFAULT NULL,
  `codProducto` int(10) DEFAULT NULL,
  `cantidadComprada` int(11) DEFAULT NULL,
  `costoSubTotal` float(10,2) DEFAULT NULL,
  `costoIGV` float(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detalle_factura`
--

INSERT INTO `detalle_factura` (`codDetalle`, `codFactura`, `codProducto`, `cantidadComprada`, `costoSubTotal`, `costoIGV`) VALUES
(1, 'F001', 1, 5, 52.50, 9.45),
(2, 'F002', 2, 8, 70.00, 11.20),
(282, 'F1003', 3, 1, 15.25, 2.75),
(283, 'F1003', 40, 1, 5.20, 0.00),
(284, 'F1003', 1, 4, 42.00, 7.56),
(285, 'F1004', 40, 10, 52.00, 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `empresa`
--

CREATE TABLE `empresa` (
  `codEmpresa` int(10) NOT NULL,
  `nombreEmpresa` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `correoElectronico` varchar(255) DEFAULT NULL,
  `telefono` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `empresa`
--

INSERT INTO `empresa` (`codEmpresa`, `nombreEmpresa`, `direccion`, `correoElectronico`, `telefono`) VALUES
(1, 'Empresa 1', 'Dirección 1', 'empresa1@example.com', '111111111'),
(2, 'Empresa 2', 'Dirección 2', 'empresa2@example.com', '222222222');

-- --------------------------------------------------------

--
-- Table structure for table `estadosfactura`
--

CREATE TABLE `estadosfactura` (
  `codEstado` char(1) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `estadosfactura`
--

INSERT INTO `estadosfactura` (`codEstado`, `descripcion`) VALUES
('A', 'Anulada'),
('C', 'Completada'),
('R', 'Registrado');

-- --------------------------------------------------------

--
-- Table structure for table `factura`
--

CREATE TABLE `factura` (
  `codFactura` varchar(255) NOT NULL,
  `codEmpresa` int(10) DEFAULT NULL,
  `codVendedor` int(10) DEFAULT NULL,
  `codPuntoVenta` int(10) DEFAULT NULL,
  `codCliente` int(11) DEFAULT NULL,
  `fecha_emision` datetime DEFAULT NULL,
  `costoTotal` float(10,2) DEFAULT NULL,
  `codEstado` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `factura`
--

INSERT INTO `factura` (`codFactura`, `codEmpresa`, `codVendedor`, `codPuntoVenta`, `codCliente`, `fecha_emision`, `costoTotal`, `codEstado`) VALUES
('F001', 1, 1, 1, 1, '2023-09-05 10:00:00', 50.00, 'C'),
('F002', 2, 2, 2, 2, '2023-09-06 11:30:00', 75.50, 'C'),
('F1003', 1, 2, 2, 2, '2023-09-10 23:08:07', 72.75, 'R'),
('F1004', 1, 2, 1, 3, '2023-09-10 23:10:34', 52.00, 'R');

-- --------------------------------------------------------

--
-- Table structure for table `igvtipos`
--

CREATE TABLE `igvtipos` (
  `codIgv` char(1) NOT NULL,
  `igvDecimal` float(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `igvtipos`
--

INSERT INTO `igvtipos` (`codIgv`, `igvDecimal`) VALUES
('A', 0.18),
('B', 0.16),
('C', 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `producto`
--

CREATE TABLE `producto` (
  `codProducto` int(10) NOT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `costoUnitario` float(10,2) DEFAULT NULL,
  `afectaIgv` tinyint(1) DEFAULT NULL,
  `tipoIgv` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `producto`
--

INSERT INTO `producto` (`codProducto`, `nombre`, `costoUnitario`, `afectaIgv`, `tipoIgv`) VALUES
(1, 'Producto A', 10.50, 1, 'A'),
(2, 'Producto B', 8.75, 1, 'B'),
(3, 'Producto C', 15.25, 1, 'A'),
(40, 'Ramo de Uvas', 5.20, 0, 'C');

-- --------------------------------------------------------

--
-- Table structure for table `puntoventa`
--

CREATE TABLE `puntoventa` (
  `codPunto` int(10) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `puntoventa`
--

INSERT INTO `puntoventa` (`codPunto`, `descripcion`) VALUES
(1, 'Punto 1'),
(2, 'Punto 2');

-- --------------------------------------------------------

--
-- Table structure for table `vendedor`
--

CREATE TABLE `vendedor` (
  `codVendedor` int(10) NOT NULL,
  `NombreApellido` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vendedor`
--

INSERT INTO `vendedor` (`codVendedor`, `NombreApellido`) VALUES
(1, 'Vendedor 1'),
(2, 'Vendedor 2');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`codRuc`);

--
-- Indexes for table `detalle_factura`
--
ALTER TABLE `detalle_factura`
  ADD PRIMARY KEY (`codDetalle`),
  ADD KEY `codFactura` (`codFactura`),
  ADD KEY `codProducto` (`codProducto`);

--
-- Indexes for table `empresa`
--
ALTER TABLE `empresa`
  ADD PRIMARY KEY (`codEmpresa`);

--
-- Indexes for table `estadosfactura`
--
ALTER TABLE `estadosfactura`
  ADD PRIMARY KEY (`codEstado`);

--
-- Indexes for table `factura`
--
ALTER TABLE `factura`
  ADD PRIMARY KEY (`codFactura`),
  ADD KEY `codEmpresa` (`codEmpresa`),
  ADD KEY `codVendedor` (`codVendedor`),
  ADD KEY `codPuntoVenta` (`codPuntoVenta`),
  ADD KEY `codCliente` (`codCliente`),
  ADD KEY `codEstado` (`codEstado`);

--
-- Indexes for table `igvtipos`
--
ALTER TABLE `igvtipos`
  ADD PRIMARY KEY (`codIgv`);

--
-- Indexes for table `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`codProducto`),
  ADD KEY `tipoIgv` (`tipoIgv`);

--
-- Indexes for table `puntoventa`
--
ALTER TABLE `puntoventa`
  ADD PRIMARY KEY (`codPunto`);

--
-- Indexes for table `vendedor`
--
ALTER TABLE `vendedor`
  ADD PRIMARY KEY (`codVendedor`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cliente`
--
ALTER TABLE `cliente`
  MODIFY `codRuc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `detalle_factura`
--
ALTER TABLE `detalle_factura`
  MODIFY `codDetalle` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=286;

--
-- AUTO_INCREMENT for table `empresa`
--
ALTER TABLE `empresa`
  MODIFY `codEmpresa` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `puntoventa`
--
ALTER TABLE `puntoventa`
  MODIFY `codPunto` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `vendedor`
--
ALTER TABLE `vendedor`
  MODIFY `codVendedor` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detalle_factura`
--
ALTER TABLE `detalle_factura`
  ADD CONSTRAINT `detalle_factura_ibfk_1` FOREIGN KEY (`codFactura`) REFERENCES `factura` (`codFactura`),
  ADD CONSTRAINT `detalle_factura_ibfk_2` FOREIGN KEY (`codProducto`) REFERENCES `producto` (`codProducto`);

--
-- Constraints for table `factura`
--
ALTER TABLE `factura`
  ADD CONSTRAINT `factura_ibfk_1` FOREIGN KEY (`codEmpresa`) REFERENCES `empresa` (`codEmpresa`),
  ADD CONSTRAINT `factura_ibfk_2` FOREIGN KEY (`codVendedor`) REFERENCES `vendedor` (`codVendedor`),
  ADD CONSTRAINT `factura_ibfk_3` FOREIGN KEY (`codPuntoVenta`) REFERENCES `puntoventa` (`codPunto`),
  ADD CONSTRAINT `factura_ibfk_4` FOREIGN KEY (`codCliente`) REFERENCES `cliente` (`codRuc`),
  ADD CONSTRAINT `factura_ibfk_5` FOREIGN KEY (`codEstado`) REFERENCES `estadosfactura` (`codEstado`);

--
-- Constraints for table `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `producto_ibfk_1` FOREIGN KEY (`tipoIgv`) REFERENCES `igvtipos` (`codIgv`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
