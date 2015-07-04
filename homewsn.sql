SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;


DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `actuators_data_float_day_for_date`(IN `date` DATE)
BEGIN

DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE beg DATETIME;
DECLARE idd, par INT UNSIGNED;
DECLARE cur CURSOR FOR SELECT `id`, `param` FROM `actuators_parameters`;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur;

SET beg = TIMESTAMP(date, MAKETIME(0, 0, 0));

mainLoop: LOOP
  FETCH cur INTO idd, par;
  IF done THEN
    LEAVE mainLoop;
  END IF;
  CALL calc_data_float_day_for_id_par_beg(idd, par, beg);
END LOOP mainLoop;

CLOSE cur;
  
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `actuators_data_float_hour_for_date`(IN `date` DATE)
BEGIN

DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE beg DATETIME;
DECLARE idd, par, hour INT UNSIGNED;
DECLARE cur CURSOR FOR SELECT `id`, `param` FROM `actuators_parameters`;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur;

mainLoop: LOOP
  FETCH cur INTO idd, par;
  IF done THEN
    LEAVE mainLoop;
  END IF;
  SET hour = 0;
  WHILE hour < 24 DO
    SET beg = TIMESTAMP(date, MAKETIME(hour, 0, 0));
    CALL calc_data_float_hour_for_id_par_beg(idd, par, beg);
    SET hour = hour + 1;
  END WHILE;
END LOOP mainLoop;

CLOSE cur;
  
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `actuators_data_float_month_for_date`(IN `date` DATE)
BEGIN

DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE beg DATETIME;
DECLARE idd, par INT UNSIGNED;
DECLARE cur CURSOR FOR SELECT `id`, `param` FROM `actuators_parameters`;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur;

SET beg = TIMESTAMP(date, MAKETIME(0, 0, 0));

mainLoop: LOOP
  FETCH cur INTO idd, par;
  IF done THEN
    LEAVE mainLoop;
  END IF;
  CALL calc_data_float_month_for_id_par_beg(idd, par, beg);
END LOOP mainLoop;

CLOSE cur;
  
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `actuators_data_long_day_for_date`(IN `date` DATE)
BEGIN

DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE beg DATETIME;
DECLARE idd, par INT UNSIGNED;
DECLARE cur CURSOR FOR SELECT `id`, `param` FROM `actuators_parameters`;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur;

SET beg = TIMESTAMP(date, MAKETIME(0, 0, 0));

mainLoop: LOOP
  FETCH cur INTO idd, par;
  IF done THEN
    LEAVE mainLoop;
  END IF;
  CALL calc_data_long_day_for_id_par_beg(idd, par, beg);
END LOOP mainLoop;

CLOSE cur;
  
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `actuators_data_long_hour_for_date`(IN `date` DATE)
BEGIN

DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE beg DATETIME;
DECLARE idd, par, hour INT UNSIGNED;
DECLARE cur CURSOR FOR SELECT `id`, `param` FROM `actuators_parameters`;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur;

mainLoop: LOOP
  FETCH cur INTO idd, par;
  IF done THEN
    LEAVE mainLoop;
  END IF;
  SET hour = 0;
  WHILE hour < 24 DO
    SET beg = TIMESTAMP(date, MAKETIME(hour, 0, 0));
    CALL calc_data_long_hour_for_id_par_beg(idd, par, beg);
    SET hour = hour + 1;
  END WHILE;
END LOOP mainLoop;

CLOSE cur;
  
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `actuators_data_long_month_for_date`(IN `date` DATE)
BEGIN

DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE beg DATETIME;
DECLARE idd, par INT UNSIGNED;
DECLARE cur CURSOR FOR SELECT `id`, `param` FROM `actuators_parameters`;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur;

SET beg = TIMESTAMP(date, MAKETIME(0, 0, 0));

mainLoop: LOOP
  FETCH cur INTO idd, par;
  IF done THEN
    LEAVE mainLoop;
  END IF;
  CALL calc_data_long_month_for_id_par_beg(idd, par, beg);
END LOOP mainLoop;

CLOSE cur;
  
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `calc_data_float_day_for_id_par_beg`(IN `idd` INT(4) UNSIGNED, IN `par` INT(4) UNSIGNED, IN `beg` DATETIME)
BEGIN

DECLARE end DATETIME;
SET end = DATE_ADD(beg, INTERVAL 86399 SECOND);

SELECT AVG(`value_avg`)
FROM(SELECT `value_avg`
FROM `data_float_hour`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @avg;

SELECT MIN(`value_min`)
FROM(SELECT `value_min`
FROM `data_float_hour`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @min;

SELECT MAX(`value_max`)
FROM(SELECT `value_max`
FROM `data_float_hour`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @max;

IF (@avg IS NOT NULL) THEN
 INSERT INTO `data_float_day` (`id`, `param`, `time`, `value_avg`, `value_min`, `value_max`)
 VALUES (idd, par, beg, @avg, @min, @max)
 ON DUPLICATE KEY UPDATE value_avg=@avg, value_min=@min, value_max=@max;
END IF;

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `calc_data_float_hour_for_id_par_beg`(IN `idd` INT(4) UNSIGNED, IN `par` INT(4) UNSIGNED, IN `beg` DATETIME)
BEGIN

DECLARE end DATETIME;
SET end = DATE_ADD(beg, INTERVAL 3599 SECOND);

SELECT AVG(`value`)
FROM(SELECT `value`
FROM `data_float`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @avg;

SELECT MIN(`value`)
FROM(SELECT `value`
FROM `data_float`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @min;

SELECT MAX(`value`)
FROM(SELECT `value`
FROM `data_float`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @max;

IF (@avg IS NOT NULL) THEN
 INSERT INTO `data_float_hour` (`id`, `param`, `time`, `value_avg`, `value_min`, `value_max`)
 VALUES (idd, par, beg, @avg, @min, @max)
 ON DUPLICATE KEY UPDATE value_avg=@avg, value_min=@min, value_max=@max;
END IF;

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `calc_data_float_month_for_id_par_beg`(IN `idd` INT(4) UNSIGNED, IN `par` INT(4) UNSIGNED, IN `beg` DATETIME)
BEGIN

DECLARE end DATETIME;
SET end = TIMESTAMP(LAST_DAY(beg), MAKETIME(23, 59, 59));

SELECT AVG(`value_avg`)
FROM(SELECT `value_avg`
FROM `data_float_day`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @avg;

SELECT MIN(`value_min`)
FROM(SELECT `value_min`
FROM `data_float_day`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @min;

SELECT MAX(`value_max`)
FROM(SELECT `value_max`
FROM `data_float_day`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @max;

IF (@avg IS NOT NULL) THEN
 INSERT INTO `data_float_month` (`id`, `param`, `time`, `value_avg`, `value_min`, `value_max`)
 VALUES (idd, par, beg, @avg, @min, @max)
 ON DUPLICATE KEY UPDATE value_avg=@avg, value_min=@min, value_max=@max;
END IF;

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `calc_data_for_date`(IN `date` DATE)
BEGIN

CALL actuators_data_float_hour_for_date(date);
CALL actuators_data_long_hour_for_date(date);
CALL sensors_data_float_hour_for_date(date);
CALL sensors_data_long_hour_for_date(date);
CALL actuators_data_float_day_for_date(date);
CALL actuators_data_long_day_for_date(date);
CALL sensors_data_float_day_for_date(date);
CALL sensors_data_long_day_for_date(date);

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `calc_data_long_day_for_id_par_beg`(IN `idd` INT(4) UNSIGNED, IN `par` INT(4) UNSIGNED, IN `beg` DATETIME)
BEGIN

DECLARE end DATETIME;
SET end = DATE_ADD(beg, INTERVAL 86399 SECOND);

SELECT AVG(`value_avg`)
FROM(SELECT `value_avg`
FROM `data_long_hour`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @avg;

SELECT MIN(`value_min`)
FROM(SELECT `value_min`
FROM `data_long_hour`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @min;

SELECT MAX(`value_max`)
FROM(SELECT `value_max`
FROM `data_long_hour`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @max;

IF (@avg IS NOT NULL) THEN
 INSERT INTO `data_long_day` (`id`, `param`, `time`, `value_avg`, `value_min`, `value_max`)
 VALUES (idd, par, beg, @avg, @min, @max)
 ON DUPLICATE KEY UPDATE value_avg=@avg, value_min=@min, value_max=@max;
END IF;

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `calc_data_long_hour_for_id_par_beg`(IN `idd` INT(4) UNSIGNED, IN `par` INT(4) UNSIGNED, IN `beg` DATETIME)
BEGIN

DECLARE end DATETIME;
SET end = DATE_ADD(beg, INTERVAL 3599 SECOND);

SELECT AVG(`value`)
FROM(SELECT `value`
FROM `data_long`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @avg;

SELECT MIN(`value`)
FROM(SELECT `value`
FROM `data_long`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @min;

SELECT MAX(`value`)
FROM(SELECT `value`
FROM `data_long`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @max;

IF (@avg IS NOT NULL) THEN
 INSERT INTO `data_long_hour` (`id`, `param`, `time`, `value_avg`, `value_min`, `value_max`)
 VALUES (idd, par, beg, @avg, @min, @max)
 ON DUPLICATE KEY UPDATE value_avg=@avg, value_min=@min, value_max=@max;
END IF;

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `calc_data_long_month_for_id_par_beg`(IN `idd` INT(4) UNSIGNED, IN `par` INT(4) UNSIGNED, IN `beg` DATETIME)
BEGIN

DECLARE end DATETIME;
SET end = TIMESTAMP(LAST_DAY(beg), MAKETIME(23, 59, 59));

SELECT AVG(`value_avg`)
FROM(SELECT `value_avg`
FROM `data_long_day`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @avg;

SELECT MIN(`value_min`)
FROM(SELECT `value_min`
FROM `data_long_day`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @min;

SELECT MAX(`value_max`)
FROM(SELECT `value_max`
FROM `data_long_day`
WHERE `time` >= beg
AND `time` <= end
AND `id` = idd
AND `param` = par)
AS temp
INTO @max;

IF (@avg IS NOT NULL) THEN
 INSERT INTO `data_long_month` (`id`, `param`, `time`, `value_avg`, `value_min`, `value_max`)
 VALUES (idd, par, beg, @avg, @min, @max)
 ON DUPLICATE KEY UPDATE value_avg=@avg, value_min=@min, value_max=@max;
END IF;

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `calc_data_month_for_date`(IN `date` DATE)
BEGIN

CALL actuators_data_float_month_for_date(date);
CALL actuators_data_long_month_for_date(date);
CALL sensors_data_float_month_for_date(date);
CALL sensors_data_long_month_for_date(date);

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sensors_data_float_day_for_date`(IN `date` DATE)
BEGIN

DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE beg DATETIME;
DECLARE idd, par INT UNSIGNED;
DECLARE cur CURSOR FOR SELECT `id`, `param` FROM `sensors_parameters`;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur;

SET beg = TIMESTAMP(date, MAKETIME(0, 0, 0));

mainLoop: LOOP
  FETCH cur INTO idd, par;
  IF done THEN
    LEAVE mainLoop;
  END IF;
  CALL calc_data_float_day_for_id_par_beg(idd, par, beg);
END LOOP mainLoop;

CLOSE cur;
  
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sensors_data_float_hour_for_date`(IN `date` DATE)
BEGIN

DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE beg DATETIME;
DECLARE idd, par, hour INT UNSIGNED;
DECLARE cur CURSOR FOR SELECT `id`, `param` FROM `sensors_parameters`;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur;

mainLoop: LOOP
  FETCH cur INTO idd, par;
  IF done THEN
    LEAVE mainLoop;
  END IF;
  SET hour = 0;
  WHILE hour < 24 DO
    SET beg = TIMESTAMP(date, MAKETIME(hour, 0, 0));
    CALL calc_data_float_hour_for_id_par_beg(idd, par, beg);
    SET hour = hour + 1;
  END WHILE;
END LOOP mainLoop;

CLOSE cur;
  
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sensors_data_float_month_for_date`(IN `date` DATE)
BEGIN

DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE beg DATETIME;
DECLARE idd, par INT UNSIGNED;
DECLARE cur CURSOR FOR SELECT `id`, `param` FROM `sensors_parameters`;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur;

SET beg = TIMESTAMP(date, MAKETIME(0, 0, 0));

mainLoop: LOOP
  FETCH cur INTO idd, par;
  IF done THEN
    LEAVE mainLoop;
  END IF;
  CALL calc_data_float_month_for_id_par_beg(idd, par, beg);
END LOOP mainLoop;

CLOSE cur;
  
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sensors_data_long_day_for_date`(IN `date` DATE)
BEGIN

DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE beg DATETIME;
DECLARE idd, par INT UNSIGNED;
DECLARE cur CURSOR FOR SELECT `id`, `param` FROM `sensors_parameters`;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur;

SET beg = TIMESTAMP(date, MAKETIME(0, 0, 0));

mainLoop: LOOP
  FETCH cur INTO idd, par;
  IF done THEN
    LEAVE mainLoop;
  END IF;
  CALL calc_data_long_day_for_id_par_beg(idd, par, beg);
END LOOP mainLoop;

CLOSE cur;
  
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sensors_data_long_hour_for_date`(IN `date` DATE)
BEGIN

DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE beg DATETIME;
DECLARE idd, par, hour INT UNSIGNED;
DECLARE cur CURSOR FOR SELECT `id`, `param` FROM `sensors_parameters`;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur;

mainLoop: LOOP
  FETCH cur INTO idd, par;
  IF done THEN
    LEAVE mainLoop;
  END IF;
  SET hour = 0;
  WHILE hour < 24 DO
    SET beg = TIMESTAMP(date, MAKETIME(hour, 0, 0));
    CALL calc_data_long_hour_for_id_par_beg(idd, par, beg);
    SET hour = hour + 1;
  END WHILE;
END LOOP mainLoop;

CLOSE cur;
  
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sensors_data_long_month_for_date`(IN `date` DATE)
BEGIN

DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE beg DATETIME;
DECLARE idd, par INT UNSIGNED;
DECLARE cur CURSOR FOR SELECT `id`, `param` FROM `sensors_parameters`;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur;

SET beg = TIMESTAMP(date, MAKETIME(0, 0, 0));

mainLoop: LOOP
  FETCH cur INTO idd, par;
  IF done THEN
    LEAVE mainLoop;
  END IF;
  CALL calc_data_long_month_for_id_par_beg(idd, par, beg);
END LOOP mainLoop;

CLOSE cur;
  
END$$

DELIMITER ;

CREATE TABLE IF NOT EXISTS `actuators` (
  `id` int(4) unsigned NOT NULL,
  `location` varchar(128) NOT NULL DEFAULT '',
  `ip` char(15) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `actuators_parameters` (
  `id` int(4) unsigned NOT NULL,
  `param` int(4) unsigned NOT NULL,
  `unit` varchar(32) NOT NULL DEFAULT '',
  `data_type` varchar(8) NOT NULL DEFAULT '',
  `icon_type` varchar(32) NOT NULL DEFAULT '',
  `icon_url_na` varchar(128) NOT NULL DEFAULT '',
  `icon_url_0` varchar(128) NOT NULL DEFAULT '',
  `icon_url_1` varchar(128) NOT NULL DEFAULT '',
  `value_0` varchar(32) NOT NULL DEFAULT '',
  `value_1` varchar(32) NOT NULL DEFAULT '',
  `type` varchar(32) NOT NULL DEFAULT '',
  `comment` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`param`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `data_float` (
  `id` int(4) unsigned NOT NULL,
  `param` int(4) unsigned NOT NULL,
  `time` datetime NOT NULL,
  `value` float NOT NULL,
  KEY `id` (`id`),
  KEY `parameter` (`id`,`param`),
  KEY `time` (`id`,`param`,`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `data_float_day` (
  `id` int(4) unsigned NOT NULL,
  `param` int(4) unsigned NOT NULL,
  `time` datetime NOT NULL,
  `value_avg` float NOT NULL,
  `value_min` float NOT NULL,
  `value_max` float NOT NULL,
  PRIMARY KEY (`id`,`param`,`time`),
  KEY `id` (`id`),
  KEY `parameter` (`id`,`param`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `data_float_hour` (
  `id` int(4) unsigned NOT NULL,
  `param` int(4) unsigned NOT NULL,
  `time` datetime NOT NULL,
  `value_avg` float NOT NULL,
  `value_min` float NOT NULL,
  `value_max` float NOT NULL,
  PRIMARY KEY (`id`,`param`,`time`),
  KEY `id` (`id`),
  KEY `parameter` (`id`,`param`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `data_float_month` (
  `id` int(4) unsigned NOT NULL,
  `param` int(4) unsigned NOT NULL,
  `time` datetime NOT NULL,
  `value_avg` float NOT NULL,
  `value_min` float NOT NULL,
  `value_max` float NOT NULL,
  PRIMARY KEY (`id`,`param`,`time`),
  KEY `id` (`id`),
  KEY `parameter` (`id`,`param`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `data_long` (
  `id` int(4) unsigned NOT NULL,
  `param` int(4) unsigned NOT NULL,
  `time` datetime NOT NULL,
  `value` int(4) NOT NULL,
  KEY `id` (`id`),
  KEY `parameter` (`id`,`param`),
  KEY `time` (`id`,`param`,`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `data_long_day` (
  `id` int(4) unsigned NOT NULL,
  `param` int(4) unsigned NOT NULL,
  `time` datetime NOT NULL,
  `value_avg` float NOT NULL,
  `value_min` int(4) NOT NULL,
  `value_max` int(4) NOT NULL,
  PRIMARY KEY (`id`,`param`,`time`),
  KEY `id` (`id`),
  KEY `parameter` (`id`,`param`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `data_long_hour` (
  `id` int(4) unsigned NOT NULL,
  `param` int(4) unsigned NOT NULL,
  `time` datetime NOT NULL,
  `value_avg` float NOT NULL,
  `value_min` int(4) NOT NULL,
  `value_max` int(4) NOT NULL,
  PRIMARY KEY (`id`,`param`,`time`),
  KEY `id` (`id`),
  KEY `parameter` (`id`,`param`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `data_long_month` (
  `id` int(4) unsigned NOT NULL,
  `param` int(4) unsigned NOT NULL,
  `time` datetime NOT NULL,
  `value_avg` float NOT NULL,
  `value_min` int(4) NOT NULL,
  `value_max` int(4) NOT NULL,
  PRIMARY KEY (`id`,`param`,`time`),
  KEY `id` (`id`),
  KEY `parameter` (`id`,`param`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `data_utf8str` (
  `id` int(4) unsigned NOT NULL,
  `param` int(4) unsigned NOT NULL,
  `time` datetime NOT NULL,
  `value` varchar(73) NOT NULL,
  KEY `id` (`id`),
  KEY `parameter` (`id`,`param`),
  KEY `time` (`id`,`param`,`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `sensors` (
  `id` int(4) unsigned NOT NULL,
  `st_duration` int(4) unsigned NOT NULL DEFAULT '0',
  `location` varchar(128) NOT NULL DEFAULT '',
  `ip` char(15) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `sensors_parameters` (
  `id` int(4) unsigned NOT NULL,
  `param` int(4) unsigned NOT NULL,
  `unit` varchar(32) NOT NULL DEFAULT '',
  `data_type` varchar(8) NOT NULL DEFAULT '',
  `icon_type` varchar(32) NOT NULL DEFAULT '',
  `icon_url_na` varchar(128) NOT NULL DEFAULT '',
  `icon_url_0` varchar(128) NOT NULL DEFAULT '',
  `icon_url_1` varchar(128) NOT NULL DEFAULT '',
  `value_0` varchar(32) NOT NULL DEFAULT '',
  `value_1` varchar(32) NOT NULL DEFAULT '',
  `type` varchar(32) NOT NULL DEFAULT '',
  `comment` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`param`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DELIMITER $$
CREATE DEFINER=`root`@`%` EVENT `calc_data_for_yesterday` ON SCHEDULE EVERY 1 DAY STARTS '2015-07-01 00:05:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL calc_data_for_date(DATE_ADD(CURDATE(), INTERVAL -1 DAY))$$

CREATE DEFINER=`root`@`%` EVENT `calc_data_for_last_month` ON SCHEDULE EVERY 1 MONTH STARTS '2015-07-01 00:15:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL calc_data_month_for_date(DATE_ADD(LAST_DAY(DATE_SUB(NOW(), INTERVAL 2 MONTH)), INTERVAL 1 DAY))$$

DELIMITER ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
