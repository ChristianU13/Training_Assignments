----Creating USER TABLE (User_table)
Create table User_table (User_id varchar(6) primary key,
username varchar(30),
email varchar(50)CONSTRAINT not_an_email CHECK(EMAIL LIKE '%@%'),
password varchar(20),
date_of_reg date default '10-May-96',
address varchar(50),
contact_no varchar(11));

select * from User_table
CREATE SEQUENCE user_id_seq;

CREATE OR REPLACE TRIGGER user_tgr
    BEFORE INSERT
    ON User_table
    REFERENCING NEW AS NEW OLD AS OLD
    FOR EACH ROW
BEGIN
    IF :NEW.User_id IS NULL THEN
        SELECT 'C'||TO_CHAR(user_id_seq.NEXTVAL,'0000000') INTO :NEW.User_id FROM DUAL;
    END IF;
END;

----Creating ADMIN TABLE (Admin)
Create table Admin (admin_id varchar2(6) primary key,
email varchar(50)CONSTRAINT email_val_Admin CHECK(EMAIL LIKE '%@%'),
password varchar(23));

select * from Admin

CREATE SEQUENCE admin_id_seq;

CREATE OR REPLACE TRIGGER adm_tgr
    BEFORE INSERT
    ON Admin
    REFERENCING NEW AS NEW OLD AS OLD
    FOR EACH ROW
BEGIN
    IF :NEW.admin_id IS NULL THEN
        SELECT 'A'||TO_CHAR(admin_id_seq.NEXTVAL,'0000000') INTO :NEW.admin_id FROM DUAL;
    END IF;
END;

----Creating CATEGORY TABLE (Category)
Create table Category (Category_id varchar(6)primary key,
Category_name varchar(20));

Select * from Category

CREATE SEQUENCE category_id_seq;
CREATE OR REPLACE TRIGGER cat_tgr
    BEFORE INSERT
    ON Category
    REFERENCING NEW AS NEW OLD AS OLD
    FOR EACH ROW
BEGIN
    IF :NEW.category_id IS NULL THEN
        SELECT 'CAT'||TO_CHAR(category_id_seq.NEXTVAL,'0000000') INTO :NEW.category_id FROM DUAL;
    END IF;
END;

----Creating PRODUCT TABLE (Product)
Create table Product(Product_id varchar2(6)primary key,
product_name varchar(10),
category_id varchar(10) references Category(Category_id),
product_price number,
product_image varchar2(10),
product_available_qty number);

CREATE SEQUENCE product_id_seq;

CREATE OR REPLACE TRIGGER prod_tgr
    BEFORE INSERT
    ON Product
    REFERENCING NEW AS NEW OLD AS OLD
    FOR EACH ROW
BEGIN
    IF :NEW.product_id IS NULL THEN
        SELECT 'P'||TO_CHAR(Product_id_seq.NEXTVAL,'0000000') INTO :NEW.Product_id FROM DUAL;
    END IF;
END;

----Creating COUPON TABLE (Coupon)
Create table Coupon (coupon_id varchar(6) primary key,
coupon_name char(30),
discount_val number,
expiry_date date default '10-MAY-96');

CREATE SEQUENCE coupon_id_seq;

CREATE OR REPLACE TRIGGER coup_tgr
    BEFORE INSERT
    ON Coupon
    REFERENCING NEW AS NEW OLD AS OLD
    FOR EACH ROW
BEGIN
    IF :NEW.coupon_id IS NULL THEN
        SELECT 'CO'||TO_CHAR(coupon_id_seq.NEXTVAL,'0000000') INTO :NEW.coupon_id FROM DUAL;
    END IF;
END;

----Creating CART TABLE (Cart)
Create table Cart (Cart_id varchar(6)primary key,
User_id varchar(6)references User_table(User_id));


CREATE SEQUENCE cart_id_seq;

CREATE OR REPLACE TRIGGER cart_tgr
    BEFORE INSERT
    ON Cart
    REFERENCING NEW AS NEW OLD AS OLD
    FOR EACH ROW
BEGIN
    IF :NEW.cart_id IS NULL THEN
        SELECT 'CA'||TO_CHAR(cart_id_seq.NEXTVAL,'0000000') INTO :NEW.cart_id FROM DUAL;
    END IF;
END;

----Creating CART ITEMS TABLE (Cart_items)
Create table Cart_items (cart_items_id varchar(20) primary key,
Cart_id varchar(6)  references Cart(Cart_id),
User_id varchar(6) references User_table(User_id),
Product_id varchar(6)references Product(Product_id),
Product_Qty number );

CREATE SEQUENCE cart_items_id_seq;

CREATE OR REPLACE TRIGGER cart_items_tgr
    BEFORE INSERT
    ON Cart_items
    REFERENCING NEW AS NEW OLD AS OLD
    FOR EACH ROW
BEGIN
    IF :NEW.cart_items_id IS NULL THEN
        SELECT 'CI'||TO_CHAR(cart_items_id_seq.NEXTVAL,'0000000') INTO :NEW.cart_items_id FROM DUAL;
    END IF;
END;

----Creating ORDER TABLE (Order_table)
Create table Order_table (Order_id varchar (6),
Cart_id varchar(6) references Cart(Cart_id),
User_id varchar(6) references User_table(User_id),
Order_date DATE DEFAULT SYSDATE NOT NULL,
Delivery_date DATE DEFAULT SYSDATE + 7,
Coupon_id VARCHAR(7),
Bill_amount NUMBER,
Payment_method VARCHAR(23) CONSTRAINT PM_CHECK CHECK(LOWER(PAYMENT_METHOD)IN('cod', 'debit/credit card', 'online wallet'))
);

CREATE SEQUENCE order_id_seq;

CREATE OR REPLACE TRIGGER order_tgr
    BEFORE INSERT
    ON Order_table
    REFERENCING NEW AS NEW OLD AS OLD
    FOR EACH ROW
BEGIN
    IF :NEW.order_id IS NULL THEN
        SELECT 'O'||TO_CHAR(order_id_seq.NEXTVAL,'0000000') INTO :NEW.order_id FROM DUAL;
    END IF;
END;

