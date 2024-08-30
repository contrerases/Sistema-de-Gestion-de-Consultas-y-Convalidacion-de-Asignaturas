-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: sgc
-- ------------------------------------------------------
-- Server version	11.3.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `administrators`
--

DROP TABLE IF EXISTS `administrators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administrators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `second_name` varchar(255) NOT NULL,
  `first_last_name` varchar(255) NOT NULL,
  `second_last_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrators`
--

/*!40000 ALTER TABLE `administrators` DISABLE KEYS */;
INSERT INTO `administrators` VALUES (1,'Juan','Carlos','Gonzalez','Perez','juan.gonzalez@example.com','securepassword123'),(2,'Maria','Elena','Martinez','Lopez','maria.martinez@example.com','securepassword456');
/*!40000 ALTER TABLE `administrators` ENABLE KEYS */;

--
-- Table structure for table `convalidations`
--

DROP TABLE IF EXISTS `convalidations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `convalidations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_request` int(11) NOT NULL,
  `id_convalidation_type` int(11) NOT NULL,
  `state` enum('Enviada','Rechazada','Aprobada por DI','En espera de DE','Aprobada por DE') NOT NULL DEFAULT 'Enviada',
  `id_curriculum_course` int(11) NOT NULL,
  `id_subject_to_convalidate` int(11) DEFAULT NULL,
  `id_workshop_to_convalidate` int(11) DEFAULT NULL,
  `certified_course_name` varchar(255) DEFAULT NULL,
  `personal_project_name` varchar(255) DEFAULT NULL,
  `file_data` longblob DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_convalidation_type` (`id_convalidation_type`),
  KEY `id_curriculum_course` (`id_curriculum_course`),
  KEY `fk_subject` (`id_subject_to_convalidate`),
  KEY `fk_workshop` (`id_workshop_to_convalidate`),
  KEY `id_request` (`id_request`),
  CONSTRAINT `convalidations_ibfk_1` FOREIGN KEY (`id_request`) REFERENCES `requests` (`id`),
  CONSTRAINT `convalidations_ibfk_2` FOREIGN KEY (`id_convalidation_type`) REFERENCES `types_convalidations` (`id`),
  CONSTRAINT `convalidations_ibfk_3` FOREIGN KEY (`id_curriculum_course`) REFERENCES `curriculum_courses` (`id`),
  CONSTRAINT `fk_subject` FOREIGN KEY (`id_subject_to_convalidate`) REFERENCES `subjects` (`id`),
  CONSTRAINT `fk_workshop` FOREIGN KEY (`id_workshop_to_convalidate`) REFERENCES `workshops` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `convalidations`
--

/*!40000 ALTER TABLE `convalidations` DISABLE KEYS */;
INSERT INTO `convalidations` VALUES (1,1,1,'Enviada',1,1,NULL,NULL,NULL,NULL,NULL),(2,2,1,'Aprobada por DI',1,1,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `convalidations` ENABLE KEYS */;

--
-- Table structure for table `curriculum_courses`
--

DROP TABLE IF EXISTS `curriculum_courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curriculum_courses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `id_type_curriculum_course` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `id_type_curriculum_course` (`id_type_curriculum_course`),
  CONSTRAINT `curriculum_courses_ibfk_1` FOREIGN KEY (`id_type_curriculum_course`) REFERENCES `types_curriculm_courses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum_courses`
--

/*!40000 ALTER TABLE `curriculum_courses` DISABLE KEYS */;
INSERT INTO `curriculum_courses` VALUES (1,'Libre 1',1),(2,'Electivo 1',2),(3,'Electivo Informatica 2',3);
/*!40000 ALTER TABLE `curriculum_courses` ENABLE KEYS */;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'Departamento de Informática'),(2,'Departamento de Matemáticas');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;

--
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_student` int(11) NOT NULL,
  `creation_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `revision_date` timestamp NULL DEFAULT NULL,
  `comments` text DEFAULT NULL,
  `id_user_approves` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_student` (`id_student`),
  KEY `id_user_approves` (`id_user_approves`),
  CONSTRAINT `requests_ibfk_1` FOREIGN KEY (`id_student`) REFERENCES `students` (`id`),
  CONSTRAINT `requests_ibfk_2` FOREIGN KEY (`id_user_approves`) REFERENCES `administrators` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests`
--

/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
INSERT INTO `requests` VALUES (1,1,'2024-08-01 14:00:00','2024-08-05 19:30:00','Solicitud de convalidación para asignatura externa.',1),(2,2,'2024-08-02 15:00:00',NULL,'En espera de revisión de taller de INF.',NULL);
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rol_student` varchar(10) NOT NULL,
  `rut_student` varchar(12) NOT NULL,
  `campus_student` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `second_name` varchar(255) NOT NULL,
  `first_last_name` varchar(255) NOT NULL,
  `second_last_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rol_student` (`rol_student`),
  UNIQUE KEY `rut_student` (`rut_student`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (1,'2020123456','12345678-9','Campus Santiago','Pedro','Antonio','Rodriguez','Sanchez','pedro.rodriguez@example.com','securepassword789'),(2,'2020234567','98765432-1','Campus Valparaiso','Ana','Beatriz','Fernandez','Torres','ana.fernandez@example.com','securepassword012');
/*!40000 ALTER TABLE `students` ENABLE KEYS */;

--
-- Table structure for table `subjects`
--

DROP TABLE IF EXISTS `subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `acronym` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `id_department` int(11) NOT NULL,
  `credits` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `acronym` (`acronym`),
  UNIQUE KEY `name` (`name`),
  KEY `id_department` (`id_department`),
  CONSTRAINT `subjects_ibfk_1` FOREIGN KEY (`id_department`) REFERENCES `departments` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subjects`
--

/*!40000 ALTER TABLE `subjects` DISABLE KEYS */;
INSERT INTO `subjects` VALUES (1,'INF-101','Introducción a la Programación',1,10),(2,'MAT-101','Cálculo I',2,10);
/*!40000 ALTER TABLE `subjects` ENABLE KEYS */;

--
-- Table structure for table `types_convalidations`
--

DROP TABLE IF EXISTS `types_convalidations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `types_convalidations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `types_convalidations`
--

/*!40000 ALTER TABLE `types_convalidations` DISABLE KEYS */;
INSERT INTO `types_convalidations` VALUES (2,'Asignatura Externa'),(1,'Asignatura INF'),(3,'Curso Certificado'),(5,'Proyecto Personal'),(4,'Taller de INF');
/*!40000 ALTER TABLE `types_convalidations` ENABLE KEYS */;

--
-- Table structure for table `types_curriculum_courses`
--

DROP TABLE IF EXISTS `types_curriculum_courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `types_curriculum_courses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `types_curriculum_courses`
--

/*!40000 ALTER TABLE `types_curriculum_courses` DISABLE KEYS */;
INSERT INTO `types_curriculum_courses` VALUES (2,'Electivo'),(3,'Electivo INF'),(1,'Libre');
/*!40000 ALTER TABLE `types_curriculum_courses` ENABLE KEYS */;

--
-- Table structure for table `workshops`
--

DROP TABLE IF EXISTS `workshops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workshops` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `semester` enum('1','2') NOT NULL,
  `year` int(11) NOT NULL,
  `professor` varchar(255) NOT NULL,
  `initial_date` timestamp NOT NULL,
  `file_data` longblob DEFAULT NULL,
  `available` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workshops`
--

/*!40000 ALTER TABLE `workshops` DISABLE KEYS */;
INSERT INTO `workshops` VALUES (1,'Taller de Programación Avanzada','1',2024,'Dr. Luis Sanchez','2024-03-01 11:00:00',NULL,1),(2,'Taller de Innovación Tecnológica','2',2024,'Dra. Paula Medina','2024-08-01 13:00:00',NULL,1),(3,'Ciberseguridad','1',2021,'Juan Gomez','2000-02-21 03:00:00',NULL,1),(4,'Ciberseguridad 2','1',2000,'Pedro','2024-12-21 03:00:00',NULL,1),(5,'Hola test1','1',2,'juan 123','1999-02-21 03:00:00',NULL,1);
/*!40000 ALTER TABLE `workshops` ENABLE KEYS */;

--
-- Table structure for table `workshops_grades`
--

DROP TABLE IF EXISTS `workshops_grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workshops_grades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_student` int(11) NOT NULL,
  `id_workshop` int(11) NOT NULL,
  `grade` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_student` (`id_student`),
  KEY `id_workshop` (`id_workshop`),
  CONSTRAINT `workshops_grades_ibfk_1` FOREIGN KEY (`id_student`) REFERENCES `students` (`id`),
  CONSTRAINT `workshops_grades_ibfk_2` FOREIGN KEY (`id_workshop`) REFERENCES `workshops` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workshops_grades`
--

/*!40000 ALTER TABLE `workshops_grades` DISABLE KEYS */;
INSERT INTO `workshops_grades` VALUES (1,1,1,85),(2,2,2,90);
/*!40000 ALTER TABLE `workshops_grades` ENABLE KEYS */;

--
-- Table structure for table `workshops_inscriptions`
--

DROP TABLE IF EXISTS `workshops_inscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workshops_inscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_student` int(11) NOT NULL,
  `id_workshop` int(11) NOT NULL,
  `id_curriculum_course` int(11) NOT NULL,
  `is_convalidated` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `id_student` (`id_student`),
  KEY `id_workshop` (`id_workshop`),
  KEY `id_curriculum_course` (`id_curriculum_course`),
  CONSTRAINT `workshops_inscriptions_ibfk_1` FOREIGN KEY (`id_student`) REFERENCES `students` (`id`),
  CONSTRAINT `workshops_inscriptions_ibfk_2` FOREIGN KEY (`id_workshop`) REFERENCES `workshops` (`id`),
  CONSTRAINT `workshops_inscriptions_ibfk_3` FOREIGN KEY (`id_curriculum_course`) REFERENCES `curriculum_courses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workshops_inscriptions`
--

/*!40000 ALTER TABLE `workshops_inscriptions` DISABLE KEYS */;
INSERT INTO `workshops_inscriptions` VALUES (1,1,1,1,0),(2,2,1,1,1),(10,1,2,1,1);
/*!40000 ALTER TABLE `workshops_inscriptions` ENABLE KEYS */;

--
-- Dumping routines for database 'sgc'
--
/*!50003 DROP PROCEDURE IF EXISTS `GetAllCurriculumCourses` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllCurriculumCourses`()
BEGIN
    SELECT id, name, id_type_curriculum_course FROM CURRICULUM_COURSES;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllDepartments` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllDepartments`()
BEGIN
    SELECT * FROM DEPARTMENTS;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllRequestsProcessed` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllRequestsProcessed`()
BEGIN
    SELECT 
        REQUESTS.id,
        REQUESTS.id_student,
        REQUESTS.creation_date,
        REQUESTS.revision_date,
        REQUESTS.comments,
        REQUESTS.id_user_approves,
        IF(REQUESTS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves,
        STUDENTS.rol_student,
        STUDENTS.rut_student,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.first_last_name) AS name_student,
        STUDENTS.campus_student
    FROM 
        REQUESTS
    INNER JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
    LEFT JOIN ADMINISTRATORS ON REQUESTS.id_user_approves = ADMINISTRATORS.id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllSubjectsProcessedData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllSubjectsProcessedData`()
BEGIN
SELECT
    SUBJECTS.id,
    SUBJECTS.acronym,
    SUBJECTS.name,
    DEPARTMENTS.name AS department_name,
    SUBJECTS.credits
FROM
    SUBJECTS
    INNER JOIN DEPARTMENTS ON SUBJECTS.id_department = DEPARTMENTS.id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllTypesConvalidations` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllTypesConvalidations`()
BEGIN
    SELECT TYPES_CONVALIDATIONS.id, TYPES_CONVALIDATIONS.name 
    FROM TYPES_CONVALIDATIONS;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllTypesCurriculumCourses` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllTypesCurriculumCourses`()
BEGIN
    SELECT TYPES_CURRICULUM_COURSES.id, TYPES_CURRICULUM_COURSES.name 
    FROM TYPES_CURRICULUM_COURSES;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllWorkshops` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllWorkshops`()
BEGIN
    SELECT * FROM WORKSHOPS;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAvailableWorkshopsNotEnrolledByStudent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAvailableWorkshopsNotEnrolledByStudent`(
    IN student_id INT
)
BEGIN
    SELECT 
        WORKSHOPS.id,
        WORKSHOPS.name,
        WORKSHOPS.semester,
        WORKSHOPS.year,
        WORKSHOPS.professor,
        WORKSHOPS.initial_date,
        WORKSHOPS.file_data,
        WORKSHOPS.available
    FROM 
        WORKSHOPS
    WHERE 
        WORKSHOPS.available = TRUE
        AND WORKSHOPS.id NOT IN (
            SELECT 
                WORKSHOPS_INSCRIPTIONS.id_workshop
            FROM 
                WORKSHOPS_INSCRIPTIONS
            WHERE 
                WORKSHOPS_INSCRIPTIONS.id_student = student_id
        );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetCompletedWorkshopsByStudent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCompletedWorkshopsByStudent`(
    IN student_id INT
)
BEGIN
    SELECT 
        WORKSHOPS.id,
        WORKSHOPS.name,
        WORKSHOPS.semester,
        WORKSHOPS.year,
        WORKSHOPS.professor,
        WORKSHOPS.initial_date,
        WORKSHOPS.file_data,
        WORKSHOPS.available
    FROM 
        WORKSHOPS
    JOIN 
        WORKSHOPS_INSCRIPTIONS ON WORKSHOPS.id = WORKSHOPS_INSCRIPTIONS.id_workshop
    WHERE 
        WORKSHOPS_INSCRIPTIONS.id_student = student_id
        AND WORKSHOPS.available = FALSE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetConvalidationsByRequestId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetConvalidationsByRequestId`(IN request_id INT)
BEGIN
    SELECT
        CONVALIDATIONS.id,
        CONVALIDATIONS.id_request,
        CONVALIDATIONS.state,
        CONVALIDATIONS.id_convalidation_type,
        TYPES_CONVALIDATIONS.name AS convalidation_type,
        CONVALIDATIONS.id_curriculum_course,
        CURRICULUM_COURSES.name AS curriculum_course,
        CONVALIDATIONS.id_subject_to_convalidate,
        SUBJECTS.name AS subject,
        CONVALIDATIONS.id_workshop_to_convalidate,
        WORKSHOPS.name AS workshop,
        CONVALIDATIONS.certified_course_name,
        CONVALIDATIONS.personal_project_name,
        CONVALIDATIONS.file_data,
        CONVALIDATIONS.file_name
    FROM
        CONVALIDATIONS
    LEFT JOIN 
        TYPES_CONVALIDATIONS ON CONVALIDATIONS.id_convalidation_type = TYPES_CONVALIDATIONS.id
    LEFT JOIN 
        CURRICULUM_COURSES ON CONVALIDATIONS.id_curriculum_course = CURRICULUM_COURSES.id
    LEFT JOIN 
        SUBJECTS ON CONVALIDATIONS.id_subject_to_convalidate = SUBJECTS.id
    LEFT JOIN 
        WORKSHOPS ON CONVALIDATIONS.id_workshop_to_convalidate = WORKSHOPS.id
    WHERE
        CONVALIDATIONS.id_request = request_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetEnrolledAvailableWorkshopsByStudent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetEnrolledAvailableWorkshopsByStudent`(
    IN student_id INT
)
BEGIN
    SELECT 
        WORKSHOPS.id,
        WORKSHOPS.name,
        WORKSHOPS.semester,
        WORKSHOPS.year,
        WORKSHOPS.professor,
        WORKSHOPS.initial_date,
        WORKSHOPS.file_data,
        WORKSHOPS.available
    FROM 
        WORKSHOPS
    JOIN 
        WORKSHOPS_INSCRIPTIONS ON WORKSHOPS.id = WORKSHOPS_INSCRIPTIONS.id_workshop
    WHERE 
        WORKSHOPS_INSCRIPTIONS.id_student = student_id
        AND WORKSHOPS.available = TRUE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetRequestByID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetRequestByID`(IN request_id INT)
BEGIN
    SELECT 
        REQUESTS.id,
        REQUESTS.id_student,
        REQUESTS.creation_date,
        REQUESTS.revision_date,
        REQUESTS.comments,
        REQUESTS.id_user_approves,
        IF(REQUESTS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves,
        STUDENTS.rol_student,
        STUDENTS.rut_student,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.last_name) AS name_student,
        STUDENTS.campus_student
    FROM 
        REQUESTS
    INNER JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
    LEFT JOIN ADMINISTRATORS ON REQUESTS.id_user_approves = ADMINISTRATORS.id
    WHERE
        REQUESTS.id = request_id
    ORDER BY
        REQUESTS.creation_date DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetRequestsByCampus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetRequestsByCampus`(IN campus VARCHAR(255))
BEGIN
SELECT 
        REQUESTS.id,
        REQUESTS.id_student,
        REQUESTS.creation_date,
        REQUESTS.revision_date,
        REQUESTS.comments,
        REQUESTS.id_user_approves,
        IF(REQUESTS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves,
        STUDENTS.rol_student,
        STUDENTS.rut_student,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.first_last_name) AS name_student,
        STUDENTS.campus_student
    FROM 
        REQUESTS
    INNER JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
    LEFT JOIN ADMINISTRATORS ON REQUESTS.id_user_approves = ADMINISTRATORS.id
WHERE
    STUDENTS.campus_student = campus;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetRequestsByDateRangeCreation` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetRequestsByDateRangeCreation`(IN start_date DATE, IN end_date DATE)
BEGIN
SELECT 
        REQUESTS.id,
        REQUESTS.id_student,
        REQUESTS.creation_date,
        REQUESTS.revision_date,
        REQUESTS.comments,
        REQUESTS.id_user_approves,
        IF(REQUESTS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves,
        STUDENTS.rol_student,
        STUDENTS.rut_student,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.first_last_name) AS name_student,
        STUDENTS.campus_student
    FROM 
        REQUESTS
    INNER JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
    LEFT JOIN ADMINISTRATORS ON REQUESTS.id_user_approves = ADMINISTRATORS.id
WHERE
    REQUESTS.creation_date BETWEEN start_date AND end_date;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetRequestsByState` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetRequestsByState`(IN p_state VARCHAR(50))
BEGIN
SELECT 
        REQUESTS.id,
        REQUESTS.id_student,
        REQUESTS.creation_date,
        REQUESTS.revision_date,
        REQUESTS.comments,
        REQUESTS.id_user_approves,
        IF(REQUESTS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves,
        STUDENTS.rol_student,
        STUDENTS.rut_student,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.first_last_name) AS name_student,
        STUDENTS.campus_student
    FROM 
        REQUESTS
    INNER JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
    LEFT JOIN ADMINISTRATORS ON REQUESTS.id_user_approves = ADMINISTRATORS.id
    WHERE 
        REQUESTS.id IN (
            SELECT 
                id_request 
            FROM 
                CONVALIDATIONS 
            WHERE 
                state = 'Enviada'
        );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetRequestsByStudentRol` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetRequestsByStudentRol`(IN student_rol VARCHAR(255))
BEGIN
SELECT 
        REQUESTS.id,
        REQUESTS.id_student,
        REQUESTS.creation_date,
        REQUESTS.revision_date,
        REQUESTS.comments,
        REQUESTS.id_user_approves,
        IF(REQUESTS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves,
        STUDENTS.rol_student,
        STUDENTS.rut_student,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.first_last_name) AS name_student,
        STUDENTS.campus_student
    FROM 
        REQUESTS
    INNER JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
    LEFT JOIN ADMINISTRATORS ON REQUESTS.id_user_approves = ADMINISTRATORS.id
WHERE
    STUDENTS.rol_student = student_rol;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetRequestsByStudentRUT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetRequestsByStudentRUT`(IN student_rut VARCHAR(255))
BEGIN
SELECT 
        REQUESTS.id,
        REQUESTS.id_student,
        REQUESTS.creation_date,
        REQUESTS.revision_date,
        REQUESTS.comments,
        REQUESTS.id_user_approves,
        IF(REQUESTS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves,
        STUDENTS.rol_student,
        STUDENTS.rut_student,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.first_last_name) AS name_student,
        STUDENTS.campus_student
    FROM 
        REQUESTS
    INNER JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
    LEFT JOIN ADMINISTRATORS ON REQUESTS.id_user_approves = ADMINISTRATORS.id
WHERE
    STUDENTS.rut_student = student_rut;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetWorkshopGradeByStudentID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetWorkshopGradeByStudentID`(IN p_id_student INT)
BEGIN
    SELECT *
    FROM WORKSHOPS_GRADES
    WHERE id_student = p_id_student;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetWorkshopGradeByWorkshopID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetWorkshopGradeByWorkshopID`(IN p_id_workshop INT)
BEGIN
    SELECT *
    FROM WORKSHOPS_GRADES
    WHERE id_workshop = p_id_workshop;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetWorkshopsByAvailable` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetWorkshopsByAvailable`(IN p_available BOOLEAN)
BEGIN
    SELECT * 
    FROM WORKSHOPS
    WHERE available = p_available;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetWorkshopsByCurrentlySemester` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetWorkshopsByCurrentlySemester`(IN p_year INT, IN p_semester ENUM('1', '2'))
BEGIN
    SELECT * 
    FROM WORKSHOPS
    WHERE year = p_year AND semester = p_semester;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetWorkshopsInscriptionsByStudentID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetWorkshopsInscriptionsByStudentID`(IN p_id_student INT)
BEGIN
    SELECT *
    FROM WORKSHOPS_INSCRIPTIONS
    WHERE id_student = p_id_student;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetWorkshopsInscriptionsByWorkshopID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetWorkshopsInscriptionsByWorkshopID`(
    IN workshop_id INT
)
BEGIN
    SELECT 
        WORKSHOPS_INSCRIPTIONS.id AS id,
        WORKSHOPS_INSCRIPTIONS.id_student AS id_student,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.first_last_name) AS name_student,
        STUDENTS.rut_student AS rut_student,
        WORKSHOPS_INSCRIPTIONS.id_workshop AS id_workshop,
        WORKSHOPS.name AS workshop,
        WORKSHOPS_INSCRIPTIONS.id_curriculum_course AS id_curriculum_course,
        CURRICULUM_COURSES.name AS curriculum_course,
        WORKSHOPS_INSCRIPTIONS.is_convalidated AS is_convalidated
    FROM 
        WORKSHOPS_INSCRIPTIONS
    JOIN 
        STUDENTS ON WORKSHOPS_INSCRIPTIONS.id_student = STUDENTS.id
    JOIN 
        WORKSHOPS ON WORKSHOPS_INSCRIPTIONS.id_workshop = WORKSHOPS.id
    LEFT JOIN 
        CURRICULUM_COURSES ON WORKSHOPS_INSCRIPTIONS.id_curriculum_course = CURRICULUM_COURSES.id
    WHERE 
        WORKSHOPS_INSCRIPTIONS.id_workshop = workshop_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertConvalidation` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertConvalidation`(
    IN id_request INT,
    IN id_convalidation_type INT,
    IN id_curriculum_course INT,
    IN id_subject_to_convalidate INT,
    IN id_workshop_to_convalidate INT,
    IN certified_course_name VARCHAR(255),
    IN personal_project_name VARCHAR(255),
    IN file_data BLOB,
    IN file_name VARCHAR(255)
)
BEGIN
    INSERT INTO CONVALIDATIONS (
        id_request,
        id_convalidation_type,
        id_curriculum_course,
        id_subject_to_convalidate,
        id_workshop_to_convalidate,
        certified_course_name,
        personal_project_name,
        file_data,
        file_name
    )
    VALUES (
        id_request,
        id_convalidation_type,
        id_curriculum_course,
        id_subject_to_convalidate,
        id_workshop_to_convalidate,
        certified_course_name,
        personal_project_name,
        file_data,
        file_name
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertDepartment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertDepartment`(IN dept_name VARCHAR(255))
BEGIN
    INSERT INTO DEPARTMENTS (name) VALUES (dept_name);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertRequest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertRequest`(
    IN p_id_student INT,
    IN p_comments VARCHAR(255),
    IN p_id_user_approves INT
)
BEGIN
    INSERT INTO REQUESTS (
        id_student,
        comments,
        id_user_approves
    )
    VALUES (
        p_id_student,
        p_comments,
        p_id_user_approves
    );
    
    SELECT LAST_INSERT_ID() AS id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertSubject` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertSubject`(
    IN subject_acronym VARCHAR(255),
    IN subject_name VARCHAR(255),
    IN department_id INT,
    IN subject_credits INT
)
BEGIN
    INSERT INTO SUBJECTS (acronym, name, id_department, credits)
    VALUES (subject_acronym, subject_name, department_id, subject_credits);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertWorkshop` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertWorkshop`(
    IN p_name VARCHAR(255),
    IN p_semester ENUM('1', '2'),
    IN p_year INT,
    IN p_professor VARCHAR(255),
    IN p_initial_date TIMESTAMP,
    IN p_file_data LONGBLOB
)
BEGIN
    INSERT INTO WORKSHOPS (name, semester, year, professor, initial_date, file_data)
    VALUES (p_name, p_semester, p_year, p_professor, p_initial_date, p_file_data);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertWorkshopGrade` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertWorkshopGrade`(
    IN p_id_student INT,
    IN p_id_workshop INT,
    IN p_grade INT
)
BEGIN
    INSERT INTO WORKSHOPS_GRADES (id_student, id_workshop, grade)
    VALUES (p_id_student, p_id_workshop, p_grade);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertWorkshopInscription` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertWorkshopInscription`(
    IN p_id_student INT,
    IN p_id_workshop INT,
    IN p_id_curriculum_course INT,
    IN p_is_convalidated BOOLEAN
)
BEGIN
    INSERT INTO WORKSHOPS_INSCRIPTIONS (id_student, id_workshop, id_curriculum_course, is_convalidated)
    VALUES (p_id_student, p_id_workshop, p_id_curriculum_course, p_is_convalidated);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateConvalidation` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateConvalidation`(
    IN p_id_convalidation INT,
    IN p_state ENUM('Enviada', 'Rechazada', 'Aprobada por DI', 'En espera de DE', 'Aprobada por DE')
)
BEGIN
    UPDATE CONVALIDATIONS
    SET state = p_state
    WHERE id = p_id_convalidation;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateRequest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateRequest`(
    IN p_request_id INT,
    IN p_comments TEXT,
    IN p_id_user_approves INT
)
BEGIN
    UPDATE REQUESTS
    SET 
        comments = p_comments,
        id_user_approves = p_id_user_approves,
        revision_date = CURRENT_TIMESTAMP
    WHERE 
        id = p_request_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateWorkshopAvailable` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateWorkshopAvailable`(
    IN p_id INT,
    IN p_available BOOLEAN
)
BEGIN
    UPDATE WORKSHOPS
    SET available = p_available
    WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-08-30 12:36:54
