CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  product_name VARCHAR(100),
  price NUMERIC
);

CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  product_id INT REFERENCES products(product_id),
  quantity INT,
  total_amount NUMERIC
);

CREATE OR REPLACE FUNCTION fn_get_total_amount()
	RETURNS TRIGGER AS 
$$
DECLARE
	v_price NUMERIC;
BEGIN
	SELECT price INTO v_price
    FROM products
    WHERE product_id = NEW.product_id;
	NEW.total_amount := NEW.quantity * v_price;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_total_amount
BEFORE INSERT ON orders 
FOR EACH ROW
EXECUTE FUNCTION fn_get_total_amount();

INSERT INTO products (product_name, price) VALUES
('Laptop Dell',15000000),   -- Laptop Dell
('Chuột Logitech',500000),     -- Chuột Logitech
('Bàn phím cơ Keychron',2000000),    -- Bàn phím cơ Keychron
('Màn hình Samsung 24 inch',3500000),    -- Màn hình Samsung 24 inch
('Tai nghe Sony WH-1000XM4',7000000);    -- Tai nghe Sony WH-1000XM4

INSERT INTO orders (product_id, quantity, total_amount) VALUES
(1, 2, 30000000),   -- 2 Laptop Dell
(2, 5, 2500000),    -- 5 Chuột Logitech
(3, 3, 6000000),    -- 3 Bàn phím Keychron
(4, 1, 3500000),    -- 1 Màn hình Samsung
(5, 2, 14000000),   -- 2 Tai nghe Sony
(1, 1, 15000000),   -- 1 Laptop Dell
(2, 10, 5000000),   -- 10 Chuột Logitech
(3, 2, 4000000),    -- 2 Bàn phím Keychron
(4, 4, 14000000),   -- 4 Màn hình Samsung
(5, 1, 7000000);    -- 1 Tai nghe Sony

INSERT INTO orders (product_id, quantity) VALUES
(1, 3);