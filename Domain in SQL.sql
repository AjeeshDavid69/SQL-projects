--section 1

-- A domain for valid email addresses (not null, must contain @)
CREATE DOMAIN email_domain AS VARCHAR(255)
    NOT NULL
    CHECK (VALUE ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$');

-- A domain for positive integers only
CREATE DOMAIN positive_int AS INTEGER
    CHECK (VALUE > 0);

-- A domain for a rating between 1 and 5
CREATE DOMAIN star_rating AS SMALLINT
    CHECK (VALUE BETWEEN 1 AND 5);
    
    
 CREATE TABLE users (
 id       SERIAL PRIMARY KEY,
 email    email_domain,         -- uses our custom domain
 age      positive_int          -- must be > 0
);

-- ✅ Works fine
INSERT INTO users (email, age) VALUES ('davi@example.com', 25);

-- ❌ Fails: invalid email format
INSERT INTO users (email, age) VALUES ('joyboy_an-email', 25);

-- ❌ Fails: age must be > 0
INSERT INTO users (email, age) VALUES ('Robin@=example.com', -5);

SELECT * FROM users;


--section2(reusability)



-- Shared domains
CREATE DOMAIN phone_number AS VARCHAR(20)
    CHECK (VALUE ~ '^\+?[0-9\s\-]{7,20}$');

CREATE DOMAIN money_amount AS NUMERIC(12, 2)
    NOT NULL
    DEFAULT 0.00
    CHECK (VALUE >= 0);

-- Table 1: Customers
CREATE TABLE customers (
    id           SERIAL PRIMARY KEY,
    email        email_domain,       -- reused
    phone        phone_number,       -- reused
    balance      money_amount        -- reused
);

-- Table 2: Vendors
CREATE TABLE vendors (
    id           SERIAL PRIMARY KEY,
    contact_email email_domain,      -- same domain, different table
    phone         phone_number,      -- same domain again
    credit_limit  money_amount
);

-- Table 3: Orders
CREATE TABLE orders (
    id           SERIAL PRIMARY KEY,
    total        money_amount,       -- same domain
    discount     money_amount        -- reused again in same table
);
SELECT* FROM customers;



-- ✅ Valid customer
INSERT INTO customers (email, phone, balance)
VALUES ('edwardnewgate@gmail.com', '+912345678901', 500.00);

-- wrong eg
INSERT INTO customers (email, phone, balance)
VALUES ('edward -89new gate@gmail.com', '+91 234-567-8901', 500.00);

-- ✅ Valid vendor
INSERT INTO vendors (id, contact_email,  phone,credit_limit)
VALUES ( 1,'ajesh777@gmail.com',98980989097,500);
SELECT* FROM public.vendors;

-- ✅ Valid order (status defaults to 'active' if not specified)
INSERT INTO orders (id , total  ,discount)
VALUES (1, 450, 50);



--section 3(alter/drop)

-- ❌ This currently works (phone is optional)
INSERT INTO customers (email, phone, balance)
VALUES ('alice@gmail.com', NULL, 500.00);
SELECT * FROM public.customers;



-- Step 3: NOT NULL
ALTER DOMAIN phone_number
    SET NOT NULL;

-- Step 4: This will now correctly FAIL ✅
INSERT INTO customers (email, phone, balance)
VALUES ('alice@gmail.com', NULL, 500.00);
-- ERROR: domain phone_number does not allow null values

-- remove not null from domain
ALTER DOMAIN phone_number
    DROP NOT NULL;
    
    
  --replace the exisiting and add new
  
  ALTER DOMAIN money_amount
    ADD CONSTRAINT money_amount_check
    CHECK (VALUE >= -10000);
    -- Step 1: Drop the existing constraint
ALTER DOMAIN money_amount
    DROP CONSTRAINT money_amount_check;

-- Step 2: Add the new constraint
ALTER DOMAIN money_amount
    ADD CONSTRAINT money_amount_check
    CHECK (VALUE >= -1000);

-- Step 3: Now insert
INSERT INTO customers (email, phone, balance)
VALUES ('king69@mail.com', '+912345678901', -100.00);  -- ✅ works

-- ✅ Works: -100 is above -10000
INSERT INTO customers (email, phone, balance)
VALUES ( 'queen5@mail.com','+91 234-567-8901', -100.00);

-- ❌ Fails: -50000 is below -10000
INSERT INTO customers (email, phone, balance)
VALUES ('dan@gmail.com', '+93 234-567-8901', -50000.00);
-- ERROR: value for domain money_domain violates check constraint  
    
    SELECT * FROM public.customers;
    
    
    -- drop and cascade
    DROP DOMAIN money_amount;
    DROP DOMAIN money_amount CASCADE;
    SELECT * FROM public.vendors;
   SELECT * FROM public.orders; 
    
