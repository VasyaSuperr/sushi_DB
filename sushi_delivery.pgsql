-- Предметна область «ДОСТАВКА СУШІ»
--  * Магазин виготовляє різні види суші.
--  * Кожна страва характеризується певним складом, вагою та ціною.
--  * Клієнти здійснюють замовлення певної страви у потрібній кількості.

-- №1 =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
-- clients, orders, dishes
-- clients 1:m orders, orders m:n dishes


-- №2 =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
-- clients (id, name, phone_number, email, loyalty_points, notes)
-- orders (id, client_id, date, delivery_address, status)
-- dishes (id, name, ingredients, weight, price)
-- dishes_to_orders (id, order_id, dish_id, quantity)


-- №3 =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
-- У нашому випадку стовпець ingredients відповідає як discription 
-- Відповідає всім трьом нормальним формам

-- №4 =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
CREATE DATABASE sushi_delivery;
DROP DATABASE sushi_delivery;

CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL CHECK(TRIM(name) <> ''),
    phone_number VARCHAR(13) NOT NULL UNIQUE CHECK (phone_number LIKE '+380_________'),
    email VARCHAR(50) NOT NULL UNIQUE CHECK(email LIKE '%_@__%._%'),
    loyalty_points SMALLINT DEFAULT 0,
    notes VARCHAR(250) DEFAULT ''
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    date TIMESTAMP NOT NULL CHECK(date <= CURRENT_TIMESTAMP),
    delivery_address VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK(status IN ('Pending', 'Delivered', 'Cancelled')),
    client_id INTEGER NOT NULL REFERENCES clients(id)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE dishes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL CHECK(TRIM(name) <> ''),
    ingredients VARCHAR(250) NOT NULL,
    weight FLOAT NOT NULL CHECK(weight > 0),
    price FLOAT NOT NULL CHECK(price >= 0)
);

CREATE TABLE dishes_to_orders (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
    dish_id INTEGER NOT NULL REFERENCES dishes(id)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
    quantity INT NOT NULL CHECK(quantity > 0)
);

INSERT INTO clients (name, phone_number, email, loyalty_points, notes) VALUES
('Іван', '+380123456789', 'ivan.petrov@example.com', 50, ''),
('Олена', '+380987654321', 'olena.koval@example.com', 30, 'Не використовувати соуси з глютеном.'),
('Сергій', '+380234567890', 'sergiy.ivanov@example.com', 20, ''),
('Марія', '+380345678901', 'maria.sidor@example.com', 0, 'Зателефонувати перед доставкою.'),
('Петро', '+380456789012', 'petro.hnatyuk@example.com', 10, ''),
('Тетяна', '+380567890123', 'tetiana.bondarenko@example.com', 5, 'Алергія на морепродукти, будь ласка, не включати в замовлення.'),
('Владислав', '+380678901234', 'vladislav.shevchenko@example.com', 15, ''),
('Анастасія', '+380789012345', 'anastasia.volodymyrova@example.com', 25, ''),
('Олександр', '+380890123456', 'oleksandr.kuzmenko@example.com', 12, 'Алергія на лактозу, не використовувати молочні продукти.'),
('Юлія', '+380901234567', 'yulia.solovyova@example.com', 8, '');

INSERT INTO dishes (name, ingredients, weight, price) VALUES
('Суші з лососем', 'Рис, Лосось, Авокадо', 200, 120.50),
('Филадельфія', 'Рис, Лосось, Сир Філадельфія, Огірок', 250, 140.00),
('Каліфорнія', 'Рис, Креветки, Авокадо, Огірок', 300, 150.00),
('Унагі', 'Рис, Унагі, Соус теріякі', 200, 130.00),
('Темпура', 'Рис, Овочі, Креветки', 250, 160.00),
('Суші з тунцем', 'Рис, Тунць, Огірок', 220, 135.00),
('Суші з авокадо', 'Рис, Авокадо', 180, 90.00),
('Сет «Морська симфонія»', 'Рис, Лосось, Тунець, Креветки', 600, 300.00),
('Гункани з ікрою', 'Рис, Ікра, Норі', 150, 180.00),
('Маки з крабом', 'Рис, Крабове м’ясо, Огірок', 250, 200.00);

INSERT INTO orders (date, delivery_address, status, client_id) VALUES
('2023-09-01 10:00:00', 'вул. Лесі Українки, 1', 'Delivered', 1),
('2023-09-01 12:30:00', 'вул. Шевченка, 2', 'Delivered', 2),
('2023-09-03 14:15:00', 'вул. Козацька, 3', 'Cancelled', 3),
('2023-09-04 16:45:00', 'вул. Грушевського, 4', 'Delivered', 4),
('2023-09-05 11:30:00', 'вул. Франка, 5', 'Pending', 5),
('2023-09-06 15:00:00', 'вул. Садова, 6', 'Delivered', 6),
('2023-09-07 18:20:00', 'вул. Соборна, 7', 'Delivered', 7),
('2023-09-08 19:00:00', 'вул. Броварська, 8', 'Cancelled', 8),
('2023-09-10 09:50:00', 'вул. Лікарняна, 9', 'Delivered', 9),
('2023-09-12 17:30:00', 'вул. Кафедральна, 10', 'Pending', 10),

('2023-10-01 10:00:00', 'вул. Лесі Українки, 1', 'Delivered', 1),
('2023-10-02 12:30:00', 'вул. Шевченка, 2', 'Pending', 2),
('2023-10-03 14:15:00', 'вул. Козацька, 3', 'Delivered', 3),
('2023-10-03 16:45:00', 'вул. Грушевського, 4', 'Cancelled', 4),
('2023-10-03 11:30:00', 'вул. Франка, 5', 'Delivered', 5),
('2023-10-06 15:00:00', 'вул. Садова, 6', 'Pending', 6),
('2023-10-07 18:20:00', 'вул. Соборна, 7', 'Delivered', 7),
('2023-10-08 19:00:00', 'вул. Броварська, 8', 'Cancelled', 8),
('2023-10-09 09:50:00', 'вул. Лікарняна, 9', 'Delivered', 9),
('2023-10-10 17:30:00', 'вул. Кафедральна, 10', 'Pending', 10),

('2023-11-01 10:00:00', 'вул. Лесі Українки, 1', 'Delivered', 1),
('2023-11-02 12:30:00', 'вул. Шевченка, 2', 'Pending', 2),
('2023-11-03 14:15:00', 'вул. Козацька, 3', 'Delivered', 3),
('2023-11-03 16:45:00', 'вул. Грушевського, 4', 'Cancelled', 4),
('2023-11-03 11:30:00', 'вул. Франка, 5', 'Delivered', 5),
('2023-11-03 15:00:00', 'вул. Садова, 6', 'Pending', 6),
('2023-11-03 18:20:00', 'вул. Соборна, 7', 'Delivered', 7),
('2023-11-08 19:00:00', 'вул. Броварська, 8', 'Cancelled', 8),
('2023-11-09 09:50:00', 'вул. Лікарняна, 9', 'Delivered', 9),
('2023-11-10 17:30:00', 'вул. Кафедральна, 10', 'Pending', 10);

INSERT INTO dishes_to_orders (order_id, dish_id, quantity) VALUES
(1, 1, 2), (1, 2, 1), 
(2, 3, 3), (2, 4, 2),
(3, 1, 1), (3, 5, 2),
(4, 2, 1), (4, 6, 1),
(5, 3, 1), (5, 7, 3),
(6, 6, 4), (6, 8, 2),
(7, 5, 2), (7, 9, 1),
(8, 4, 3), (8, 10, 1),
(9, 8, 5), (9, 1, 1),
(10, 2, 2), (10, 6, 3),
(11, 7, 2), (11, 9, 1),
(12, 8, 4), (12, 5, 3),
(13, 1, 2), (13, 4, 1),
(14, 2, 1), (14, 6, 1),
(15, 3, 1), (15, 10, 2),
(16, 4, 3), (16, 1, 1),
(17, 5, 2), (17, 8, 1),
(18, 6, 4), (18, 2, 2),
(19, 9, 1), (19, 3, 3),
(20, 7, 2), (20, 10, 1),
(21, 2, 1), (21, 6, 1),
(22, 3, 1), (22, 1, 2),
(23, 4, 3), (23, 5, 1),
(24, 8, 4), (24, 9, 1),
(25, 10, 2), (25, 2, 3),
(26, 6, 4), (26, 7, 2),
(27, 1, 2), (27, 5, 3),
(28, 4, 1), (28, 3, 2),
(29, 2, 3), (29, 6, 1),
(30, 10, 1), (30, 8, 2);









