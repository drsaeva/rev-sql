CREATE TABLE accounts (
    id              NUMBER(5)   PRIMARY KEY,
    num             NUMBER(10)  UNIQUE NOT NULL,
    owner_count     NUMBER(1)   CONSTRAINT acct_need_owner CHECK (owner_count > 0),   
    balance         NUMBER(10,2)
);
/

CREATE TABLE users (
    id              NUMBER(5)     PRIMARY KEY,
    username        VARCHAR2(8)   UNIQUE NOT NULL,
    userpw          VARCHAR2(16)  CONSTRAINT pw_gt_7 CHECK (LENGTH(userpw) > 7),   
    fullname        VARCHAR2(16)  NOT NULL,
    access_level    NUMBER(1)     CONSTRAINT alvl_limits CHECK (access_level < 2 OR access_level > -2)
);
/

CREATE TABLE users_accounts (
    user_id     NUMBER(5), CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id),
    account_id  NUMBER(5), CONSTRAINT fk_acct_id FOREIGN KEY (account_id) REFERENCES accounts(id)
);
/

