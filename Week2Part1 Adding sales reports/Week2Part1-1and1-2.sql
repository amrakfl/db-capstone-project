SHOW DATABASES;
USE LittleLemonDB;
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `newmysqluser`@`%` 
    SQL SECURITY DEFINER
VIEW `OrdersView` AS
    SELECT 
        `Orders`.`OrderID` AS `OrderID`,
        `Orders`.`Quanitity` AS `Quanitity`,
        `Orders`.`TotalCost` AS `TotalCost`
    FROM
        `Orders`
    WHERE
        (`Orders`.`Quanitity` > 2);
SELECT * FROM OrdersView;
#--MenuName is added later in this task.--
ALTER TABLE Menus ADD MenuName VARCHAR(225); 
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `newmysqluser`@`%` 
    SQL SECURITY DEFINER
VIEW `Task2` AS
    SELECT 
        `c`.`CustomerID` AS `CustomerID`,
        CONCAT(`c`.`FirstName`, ' ', `c`.`LastName`) AS `CONCAT(c.FirstName, " ", c.LastName)`,
        `o`.`OrderID` AS `OrderID`,
        `o`.`TotalCost` AS `TotalCost`,
        `m`.`MenuName` AS `MenuName`,
        `mi`.`CourseName` AS `CourseName`,
        `mi`.`StarterName` AS `StarterName`
    FROM
        ((((`Customers` `c`
        JOIN `Bookings` `b` ON ((`c`.`CustomerID` = `b`.`CustomerID`)))
        JOIN `Orders` `o` ON ((`b`.`BookingID` = `o`.`BookingID`)))
        JOIN `Menus` `m` ON ((`o`.`OrderID` = `m`.`OrderID`)))
        JOIN `MenuItems` `mi` ON ((`m`.`MenuID` = `mi`.`MenuID`)))
    ORDER BY `o`.`TotalCost`;
SELECT * FROM Task2;

USE `LittleLemonDB`;
CREATE  OR REPLACE VIEW Task3 AS
SELECT MenuName FROM Menus
WHERE MenuName = ANY (
	SELECT m.MenuName FROM Menus as m
	INNER JOIN Orders as o 
	ON o.OrderID = m.OrderID
	WHERE o.Quanitity > 2);
SELECT * FROM Task3;

USE `LittleLemonDB`;
DROP procedure IF EXISTS `GetMaxQuantity`;
DELIMITER $$
USE `LittleLemonDB`$$
CREATE PROCEDURE GetMaxQuantity ()
BEGIN
SELECT MAX(Quanitity) FROM Orders;
END$$
DELIMITER ;
CALL GetMaxQuantity(); #since I didn't populate the database, it returns NULL.

#in my LittleLemonDM, Customers table and Orders table are connected through Bookings table. So, the statements are bit different in my case.
USE `LittleLemonDB`;
PREPARE GetOrderDetail FROM 'SELECT OrderID, Quanitity, TotalCost 
FROM Orders 
WHERE BookingID = (
SELECT b.BookingID
FROM Bookings AS b
INNER JOIN Customers AS c
ON c.CustomerID = b.CustomerID
WHERE c.CustomerID = ?
)';
SET @id = 1;
EXECUTE GetOrderDetail USING @id; #since I didn't populate the database, it returns nothing.

USE `LittleLemonDB`;
DROP procedure IF EXISTS `CancelOrder`;
DELIMITER $$
USE `LittleLemonDB`$$
CREATE PROCEDURE CancelOrder (CancelOrderID INT)
BEGIN
DELETE FROM Orders WHERE OrderID = CancelOrderID;
SELECT CONCAT("Order ", CancelOrderID, " is cancelled") AS Confirmation;
END$$
DELIMITER ;
CALL CancelOrder(5);
