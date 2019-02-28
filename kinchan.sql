-- MySQL dump 10.13  Distrib 5.7.23, for osx10.13 (x86_64)
--
-- Host: localhost    Database: kinchan_development
-- ------------------------------------------------------
-- Server version	5.7.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ar_internal_metadata`
--

DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ar_internal_metadata`
--

LOCK TABLES `ar_internal_metadata` WRITE;
/*!40000 ALTER TABLE `ar_internal_metadata` DISABLE KEYS */;
INSERT INTO `ar_internal_metadata` VALUES ('environment','development','2019-02-24 06:56:20','2019-02-24 06:56:20');
/*!40000 ALTER TABLE `ar_internal_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendances`
--

DROP TABLE IF EXISTS `attendances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attendances` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `in_time` datetime DEFAULT NULL,
  `out_time` datetime DEFAULT NULL,
  `is_remote` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_attendances_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_77ad02f5c5` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendances`
--

LOCK TABLES `attendances` WRITE;
/*!40000 ALTER TABLE `attendances` DISABLE KEYS */;
INSERT INTO `attendances` VALUES (1,1,'2019-02-24 15:56:50','2019-02-24 15:56:59',0,'2019-02-24 06:56:50','2019-02-24 06:56:59'),(2,1,'2019-02-24 15:57:00','2019-02-24 16:00:55',1,'2019-02-24 06:57:00','2019-02-24 07:00:55'),(3,1,'2019-02-24 16:00:56','2019-02-24 16:01:01',0,'2019-02-24 07:00:56','2019-02-24 07:01:01'),(4,1,'2019-02-24 16:01:03','2019-02-24 16:02:30',0,'2019-02-24 07:01:03','2019-02-24 07:02:30'),(5,2,'2019-02-24 16:07:37','2019-02-24 16:16:12',0,'2019-02-24 07:07:37','2019-02-24 07:16:12'),(6,1,'2019-02-24 16:14:56','2019-02-24 16:25:03',1,'2019-02-24 07:14:56','2019-02-24 07:25:03'),(8,3,'2019-02-24 16:17:23','2019-02-24 17:17:27',0,'2019-02-24 07:17:23','2019-02-24 07:17:27'),(9,3,'2019-02-24 17:19:15','2019-02-24 18:19:20',1,'2019-02-24 07:19:15','2019-02-24 07:19:20'),(10,1,'2019-02-25 11:38:27','2019-02-25 11:38:39',1,'2019-02-25 02:38:27','2019-02-25 02:38:39'),(11,1,'2019-02-25 11:39:09','2019-02-25 11:39:12',0,'2019-02-25 02:39:10','2019-02-25 02:39:12'),(12,1,'2019-02-25 11:39:13','2019-02-25 11:39:37',1,'2019-02-25 02:39:13','2019-02-25 02:39:37'),(13,2,'2019-02-25 15:04:55','2019-02-25 16:02:27',0,'2019-02-25 06:04:55','2019-02-25 07:02:27'),(14,1,'2019-03-25 16:05:04','2019-03-25 17:27:45',0,'2019-02-25 07:05:04','2019-02-25 07:27:45'),(15,2,'2019-02-25 15:04:55','2019-02-25 16:02:27',0,'2019-02-25 06:04:55','2019-02-25 07:02:27'),(16,2,'2019-02-25 16:33:27','2019-02-25 16:42:54',1,'2019-02-25 07:33:27','2019-02-25 07:42:54'),(17,2,'2019-02-25 16:43:01',NULL,0,'2019-02-25 07:43:01','2019-02-25 07:43:01');
/*!40000 ALTER TABLE `attendances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `breaks`
--

DROP TABLE IF EXISTS `breaks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breaks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `in_time` datetime DEFAULT NULL,
  `out_time` datetime DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `attendance_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_breaks_on_user_id` (`user_id`),
  KEY `index_breaks_on_attendance_id` (`attendance_id`),
  CONSTRAINT `fk_rails_a84f9f8b22` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_faa41c08ff` FOREIGN KEY (`attendance_id`) REFERENCES `attendances` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `breaks`
--

LOCK TABLES `breaks` WRITE;
/*!40000 ALTER TABLE `breaks` DISABLE KEYS */;
INSERT INTO `breaks` VALUES (1,'2019-02-24 15:56:55','2019-02-24 15:56:58',1,1,'2019-02-24 06:56:55','2019-02-24 06:56:58'),(2,'2019-02-24 16:00:49','2019-02-24 16:00:53',1,2,'2019-02-24 07:00:49','2019-02-24 07:00:53'),(3,'2019-02-24 16:15:57','2019-02-24 16:16:11',2,5,'2019-02-24 07:15:57','2019-02-24 07:16:11'),(4,'2019-02-24 16:17:24','2019-02-24 16:17:26',3,8,'2019-02-24 07:17:24','2019-02-24 07:17:26'),(5,'2019-02-24 16:19:16','2019-02-24 16:39:17',3,9,'2019-02-24 07:19:16','2019-02-24 07:19:17'),(6,'2019-02-24 16:19:18','2019-02-24 16:19:19',3,9,'2019-02-24 07:19:18','2019-02-24 07:19:19'),(7,'2019-02-25 11:38:30','2019-02-25 11:38:32',1,10,'2019-02-25 02:38:30','2019-02-25 02:38:32'),(8,'2019-02-25 11:38:33','2019-02-25 11:38:34',1,10,'2019-02-25 02:38:33','2019-02-25 02:38:34'),(9,'2019-02-25 15:52:52','2019-02-25 16:00:02',2,13,'2019-02-25 06:52:52','2019-02-25 07:00:02');
/*!40000 ALTER TABLE `breaks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `earnings`
--

DROP TABLE IF EXISTS `earnings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `earnings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `revenue` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `location` varchar(255) NOT NULL DEFAULT '',
  `address` varchar(255) NOT NULL,
  `longitude` float NOT NULL,
  `latitude` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `earnings`
--

LOCK TABLES `earnings` WRITE;
/*!40000 ALTER TABLE `earnings` DISABLE KEYS */;
/*!40000 ALTER TABLE `earnings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20190209025713'),('20190209032607'),('20190209032924'),('20190210050449'),('20190212100930'),('20190224053123');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL DEFAULT '',
  `is_admin` tinyint(1) NOT NULL DEFAULT '0',
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `travel_cost` int(11) NOT NULL DEFAULT '0',
  `hourly_wage` int(11) NOT NULL DEFAULT '0',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'きょん',0,'ky0ya38365388@gmail.com','$2a$11$qPxmFjTjhR9tyEN9Yb/om.qRoT9zLigXehjSE6LplSvm/z8.L.d5y',500,1400,NULL,NULL,NULL,'2019-02-24 06:56:43','2019-02-24 06:56:43'),(2,'管理者',1,'a@gmail.com','$2a$11$CtQF2WnI3u9eofHaZ5QRY.11zAe187sfjx0F4GsFeKTdOUAMb1HsK',300,2000,NULL,NULL,NULL,'2019-02-24 07:03:08','2019-02-24 07:03:08'),(3,'ccccc',0,'c@gmail.com','$2a$11$9q.n0xSYYEXUa41hGHa2j.G8Ys7n75eTyOUJigb.UBh4Z..5wcMp.',700,10000,NULL,NULL,NULL,'2019-02-24 07:16:51','2019-02-24 07:16:51');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-02-25 16:46:24
