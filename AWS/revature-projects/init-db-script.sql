--Accounts table
CREATE TABLE accounts (
    id              NUMBER(5)   PRIMARY KEY,
    num             NUMBER(10)  UNIQUE NOT NULL,
    owner_count     NUMBER(1)   CONSTRAINT acct_need_owner CHECK (owner_count > 0),   
    balance         NUMBER(10,2),
    active          NUMBER(1)
);
/
--Accounts - auto-incrementing primary key sequence and trigger
CREATE SEQUENCE accounts_seq START WITH 1;
    
CREATE OR REPLACE TRIGGER accounts_id_inc
BEFORE INSERT ON accounts
FOR EACH ROW

BEGIN
    SELECT accounts_seq.NEXTVAL
    INTO :new.id
    FROM DUAL;
END;
/
-- Transfer Procedure
CREATE OR REPLACE PROCEDURE transfer_funds(account_from NUMBER, account_to NUMBER, amount NUMBER)
AS BEGIN
    UPDATE ACCOUNTS SET balance=balance-amount WHERE num=account_from;
    UPDATE ACCOUNTS SET balance=balance+amount WHERE num=account_to;
END;
/

--Users table 
CREATE TABLE users (
    id              NUMBER(5)     PRIMARY KEY,
    username        VARCHAR2(12)   UNIQUE    NOT NULL,
    userpw          VARCHAR2(16)  CONSTRAINT pw_gt_7 CHECK (LENGTH(userpw) > 7),   
    fullname        VARCHAR2(25)  NOT NULL,
    access_level    NUMBER(1)     CONSTRAINT alvl_limits CHECK (access_level < 2 OR access_level > -2)
);
/
--Users - auto-incrementing primary key sequence and trigger
CREATE SEQUENCE users_seq START WITH 1;
    
CREATE OR REPLACE TRIGGER users_id_inc
BEFORE INSERT ON users
FOR EACH ROW

BEGIN
    SELECT users_seq.NEXTVAL
    INTO :new.id
    FROM DUAL;
END;
/
--Customers view of users with access_level=-1 (Customer-level permissions)
CREATE VIEW customers AS
  SELECT id,username
  FROM users
  WHERE access_level=-1;
/

--Customers-Accounts Joining table
CREATE TABLE customers_accounts (
    customer_id NUMBER(5), CONSTRAINT fk_user_id FOREIGN KEY (customer_id) REFERENCES users(id),
    account_id  NUMBER(5), CONSTRAINT fk_acct_id FOREIGN KEY (account_id) REFERENCES accounts(id)
);
/

--Applications table
CREATE TABLE applications (
    id              NUMBER(5)   PRIMARY KEY,
    username        VARCHAR2(12) UNIQUE  NOT NULL,
    status          NUMBER(1)   CONSTRAINT  app_status_limit CHECK (status < 2 OR status > -2),
    joint           NUMBER(1)   CONSTRAINT  joint_boolean CHECK (joint > -1 OR joint < 2),
    joint_acc_num   NUMBER(10), CONSTRAINT jt_ac_num_fk FOREIGN KEY (joint_acc_num) REFERENCES accounts(num),
    active          NUMBER(1)   CONSTRAINT  active_limit CHECK (active = 1 OR active = 0)
);
/
--Applications - auto-incrementing primary key sequence and trigger
CREATE SEQUENCE applications_seq START WITH 1;
    
CREATE OR REPLACE TRIGGER applications_id_inc
BEFORE INSERT ON applications
FOR EACH ROW

BEGIN
    SELECT applications_seq.NEXTVAL
    INTO :new.id
    FROM DUAL;
END;
/

--Applications View for Open Applications only
CREATE VIEW open_applications AS
  SELECT username, status, joint, joint_acc_num
  FROM applications
  WHERE active=1;
/
--Trigger firing after updates to applications, inactivating applications with an approved (1) or denied (-1) status flag
CREATE OR REPLACE TRIGGER app_den_apps_inactive
AFTER UPDATE ON applications

BEGIN
    UPDATE applications SET active=0 WHERE status!=0;
END;
/
