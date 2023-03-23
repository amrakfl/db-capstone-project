USE LittleLemonDB;
INSERT INTO LittleLemonDB.Bookings(BookingID, TableNo, BookingDate, CustomerID) VALUES (1, 5, '2022-10-10', 1);
INSERT INTO LittleLemonDB.Bookings(BookingID, TableNo, BookingDate, CustomerID) VALUES (2, 3, '2022-11-12', 3);
INSERT INTO LittleLemonDB.Bookings(BookingID, TableNo, BookingDate, CustomerID) VALUES (3, 2, '2022-10-11', 2);
INSERT INTO LittleLemonDB.Bookings(BookingID, TableNo, BookingDate, CustomerID) VALUES (4, 2, '2022-10-13', 1);
SELECT * FROM Bookings;

USE `LittleLemonDB`;
DROP procedure IF EXISTS `CheckBooking`;
USE `LittleLemonDB`;
DROP procedure IF EXISTS `LittleLemonDB`.`CheckBooking`;
;
DELIMITER $$
USE `LittleLemonDB`$$
CREATE DEFINER=`newmysqluser`@`%` PROCEDURE `CheckBooking`(datep DATE, tablenop INT)
BEGIN
DECLARE stat INT DEFAULT 0;
SELECT COUNT(BookingID) INTO stat FROM Bookings WHERE BookingDate=datep AND TableNo=tablenop;
SELECT CASE
	WHEN stat = 1 THEN CONCAT('Table ', tablenop, ' is already booked')
    ELSE CONCAT('Table ', tablenop, ' has not booked yet')
END AS 'Booking status';
END$$

DELIMITER ;

CALL CheckBooking("2022-11-12", 3);



#In SQL Execution in preference, disable "new connections use auto-commit. And in Other in SQL Editor, disable "Safe Updates". USE BEGIN-END for any multi-line statements.

USE `LittleLemonDB`;
DROP procedure IF EXISTS `AddValidBooking`;

USE `LittleLemonDB`;
DROP procedure IF EXISTS `LittleLemonDB`.`AddValidBooking`;
;

DELIMITER $$
USE `LittleLemonDB`$$
CREATE DEFINER=`newmysqluser`@`%` PROCEDURE `AddValidBooking`(IN datep DATE, tablenop INT)
BEGIN
SET autocommit = 0;
START TRANSACTION;
BEGIN
DECLARE stat INT DEFAULT 0;
INSERT INTO Bookings (TableNo, BookingDate, CustomerID) VALUES (tablenop, datep, 1);
SELECT COUNT(BookingID) INTO stat FROM Bookings WHERE BookingDate = datep AND TableNo = tablenop;
IF stat < 2 THEN
	BEGIN
	COMMIT;
    SELECT CONCAT('Table ', tablenop, ' has successfully booked') AS 'Booking status';
    END;
ELSE
	BEGIN
	ROLLBACK;
    SELECT CONCAT('Table ', tablenop, ' is already booked - booking cancelled') AS 'Booking status';
    END; 
END IF;
END;
END$$
DELIMITER ;
;
CALL AddValidBooking("2022-12-17", 6);
SELECT * FROM Bookings;


#Week2Part2-2
USE `LittleLemonDB`;
DROP procedure IF EXISTS `AddBooking`;
USE `LittleLemonDB`;
DROP procedure IF EXISTS `LittleLemonDB`.`AddBooking`;
;
DELIMITER $$
USE `LittleLemonDB`$$
CREATE DEFINER=`newmysqluser`@`%` PROCEDURE `AddBooking`(bookingidp INT, customeridp INT, tablenumberp INT, bookingdatep DATE)
BEGIN
INSERT INTO Bookings (BookingID, CustomerID, TableNo, BookingDate) VALUES (bookingidp, customeridp, tablenumberp, bookingdatep);
SELECT 'New booking added' AS 'Confirmation'; 
END$$
DELIMITER ;
;
CALL AddBooking(9, 3, 4, "2022-12-30");
#DELETE FROM Bookings WHERE BookingID = 9;


USE `LittleLemonDB`;
DROP procedure IF EXISTS `UpdateBooking`;
DELIMITER $$
USE `LittleLemonDB`$$
CREATE PROCEDURE UpdateBooking (bookingidp INT, bookingdatep DATE)
BEGIN
UPDATE Bookings SET BookingDate = bookingdatep WHERE BookingID = bookingidp;
SELECT CONCAT('Booking ', bookingidp, ' updated') AS 'Confirmation';
END$$
DELIMITER ;
CALL UpdateBooking(9, "2022-12-17");


USE `LittleLemonDB`;
DROP procedure IF EXISTS `CancelBooking`;
DELIMITER $$
USE `LittleLemonDB`$$
CREATE PROCEDURE CancelBooking(bookingidp INT)
BEGIN
DELETE FROM Bookings WHERE BookingID = bookingidp;
SELECT CONCAT('Booking ', bookingidp, ' cancelled') AS 'Confirmation';
END$$
DELIMITER ;
CALL CancelBooking(9);

