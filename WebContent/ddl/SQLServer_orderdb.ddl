CREATE DATABASE orders;
go

USE orders;
go

DROP TABLE review;
DROP TABLE shipment;
DROP TABLE productinventory;
DROP TABLE warehouse;
DROP TABLE orderproduct;
DROP TABLE incart;
DROP TABLE product;
DROP TABLE category;
DROP TABLE ordersummary;
DROP TABLE paymentmethod;
DROP TABLE customer;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(40),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO category(categoryName) VALUES ('Laptops');
INSERT INTO category(categoryName) VALUES ('Phones');
INSERT INTO category(categoryName) VALUES ('Accessories');
INSERT INTO category(categoryName) VALUES ('Smart Home');

INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('iPhone 15 Pro', 2, '256GB Storage, Space Black', 999.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('iPhone 16 Pro', 2, '256GB Storage, Natural Titanium', 1099.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Samsung Galaxy S24 Ultra', 2, '512GB Storage, Titanium Gray', 1299.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('MacBook Air M3', 1, '13-inch, 8GB RAM, 256GB SSD', 1099.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('MacBook Pro M3', 1, '14-inch, 16GB RAM, 512GB SSD', 1599.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Lenovo ThinkPad', 1, 'X1 Carbon, 16GB RAM, 512GB SSD', 1399.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('AirPods Pro Second Gen', 3, 'With MagSafe Charging Case', 249.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Apple Watch Ultra', 3, '49mm Titanium Case with Alpine Loop', 799.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('MagSafe Charger', 3, '15W Wireless Charging', 39.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Amazon Echo', 4, '4th Generation Smart Speaker', 99.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Google Nest Thermostat', 4, 'Smart Temperature Control', 129.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('HomePod Mini', 4, 'Smart Speaker with Siri', 99.00);

INSERT INTO warehouse(warehouseName) VALUES ('Main warehouse');
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (1, 1, 10, 999.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (2, 1, 8, 1099.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (3, 1, 5, 1299.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (4, 1, 15, 1099.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (5, 1, 12, 1599.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (6, 1, 7, 1399.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (7, 1, 20, 249.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (8, 1, 10, 799.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (9, 1, 30, 39.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (10, 1, 15, 99.00);

INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , '304Arnold!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , '304Bobby!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , '304Candace!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , '304Darren!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , '304Beth!');

-- Order 1 can be shipped as have enough inventory
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 91.70)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 1, 18)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 2, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 10, 1, 31);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-16 18:00:00', 106.75)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 5, 21.35);

-- Order 3 cannot be shipped as do not have enough inventory for item 7
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (3, '2019-10-15 3:30:22', 140)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 6, 2, 25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 7, 3, 30);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-17 05:45:11', 327.85)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 3, 4, 10)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 8, 3, 40)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 13, 3, 23.25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 28, 2, 21.05)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 29, 4, 14);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (5, '2019-10-15 10:25:55', 277.40)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 4, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 19, 2, 81)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 20, 3, 10);

-- First, let's check current image paths
SELECT productId, productName, productImageURL FROM product;

-- Update product images with correct paths
UPDATE product SET productImageURL = 'img/1.jpeg' WHERE productName = 'iPhone 15 Pro';
UPDATE product SET productImageURL = 'img/2.jpeg' WHERE productName = 'iPhone 16 Pro';
UPDATE product SET productImageURL = 'img/3.jpeg' WHERE productName = 'Samsung Galaxy S24 Ultra';
UPDATE product SET productImageURL = 'img/4.jpeg' WHERE productName = 'MacBook Air M3';
UPDATE product SET productImageURL = 'img/5.jpeg' WHERE productName = 'MacBook Pro M3';
UPDATE product SET productImageURL = 'img/6.jpeg' WHERE productName = 'Lenovo ThinkPad';
UPDATE product SET productImageURL = 'img/7.jpeg' WHERE productName = 'AirPods Pro Second Gen';
UPDATE product SET productImageURL = 'img/8.jpeg' WHERE productName = 'Google Nest Thermostat';
UPDATE product SET productImageURL = 'img/9.jpeg' WHERE productName = 'HomePod Mini';
UPDATE product SET productImageURL = 'img/10.jpg' WHERE productName = 'Amazon Echo';
UPDATE product SET productImageURL = 'img/11.jpg' WHERE productName = 'MagSafe Charger';
UPDATE product SET productImageURL = 'img/12.jpeg' WHERE productName = 'Apple Watch Ultra';

-- Update product descriptions with detailed information
UPDATE product SET productDesc = 'iPhone 15 Pro in Natural Titanium, featuring a stunning design and advanced technology.' WHERE productName = 'iPhone 15 Pro';
UPDATE product SET productDesc = 'iPhone 16 Pro in Desert Titanium, offering cutting-edge features and a sleek finish.' WHERE productName = 'iPhone 16 Pro';
UPDATE product SET productDesc = 'MacBook Air with M3 chip in Space Grey, delivering powerful performance in a lightweight design.' WHERE productName = 'MacBook Air M3';
UPDATE product SET productDesc = 'MacBook Pro with M3 chip in Space Black, combining professional-grade performance with a bold look.' WHERE productName = 'MacBook Pro M3';
UPDATE product SET productDesc = 'Lenovo Laptop in Black, providing reliable performance and a classic design for everyday use.' WHERE productName = 'Lenovo Laptop';
UPDATE product SET productDesc = 'Samsung Galaxy S23 Ultra, a flagship phone with a stunning display and powerful camera capabilities.' WHERE productName = 'Samsung Galaxy S23 Ultra';
UPDATE product SET productDesc = 'Google Pixel 8 Pro, known for its exceptional camera and seamless integration with Google services.' WHERE productName = 'Google Pixel 8 Pro';
UPDATE product SET productDesc = 'OnePlus 12, offering high performance and fast charging in a sleek design.' WHERE productName = 'OnePlus 12';
UPDATE product SET productDesc = 'Xiaomi 14 Pro, featuring cutting-edge technology and a vibrant display.' WHERE productName = 'Xiaomi 14 Pro';
UPDATE product SET productDesc = 'ASUS ROG Phone 8, a gaming powerhouse with top-tier specs and immersive features.' WHERE productName = 'ASUS ROG Phone 8';
UPDATE product SET productDesc = 'Sony Xperia 1 V, delivering exceptional audio and visual experiences in a compact form.' WHERE productName = 'Sony Xperia 1 V';
UPDATE product SET productDesc = 'Nothing Phone 2, a unique design with innovative features and a focus on simplicity.' WHERE productName = 'Nothing Phone 2';
UPDATE product SET productDesc = 'Motorola Edge 40 Pro, combining sleek design with powerful performance and 5G connectivity.' WHERE productName = 'Motorola Edge 40 Pro';
UPDATE product SET productDesc = 'OPPO Find X7 Ultra, offering a premium experience with advanced camera technology and fast charging.' WHERE productName = 'OPPO Find X7 Ultra';