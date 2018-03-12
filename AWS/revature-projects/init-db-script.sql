CREATE TABLE accounts (
    id              NUMBER(5)   PRIMARY KEY,
    num             NUMBER(10)  UNIQUE NOT NULL,
    owner_count     NUMBER(1)   CONSTRAINT acct_need_owner CHECK (owner_count > 0),   
    balance         NUMBER(10,2),
    active          NUMBER(1)
);
/
--TODO - create Sequence for aaccount id

CREATE TABLE users (
    id              NUMBER(5)     PRIMARY KEY,
    username        VARCHAR2(8)   UNIQUE    NOT NULL,
    userpw          VARCHAR2(16)  CONSTRAINT pw_gt_7 CHECK (LENGTH(userpw) > 7),   
    fullname        VARCHAR2(16)  NOT NULL,
    access_level    NUMBER(1)     CONSTRAINT alvl_limits CHECK (access_level < 2 OR access_level > -2)
);
/

--TODO - create Sequence for user id

CREATE TABLE users_accounts (
    user_id     NUMBER(5), CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id),
    account_id  NUMBER(5), CONSTRAINT fk_acct_id FOREIGN KEY (account_id) REFERENCES accounts(id)
);
/

CREATE TABLE applications (
    id              NUMBER(5)   PRIMARY KEY,
    username        VARCHAR2(8) UNIQUE  NOT NULL,
    status          NUMBER(1)   CONSTRAINT  app_status_limit CHECK (status < 2 OR status > -2),
    joint           NUMBER(1)   CONSTRAINT  joint_boolean CHECK (joint > -1 OR joint < 2),
    joint_acc_num   NUMBER(10), CONSTRAINT jt_ac_num_fk FOREIGN KEY (joint_acc_num) REFERENCES accounts(num),
    active          NUMBER(1)   CONSTRAINT  active_limit CHECK (active = 1 OR active = 0)
);
/
--TODO - create Sequence for application id

CREATE VIEW open_applications AS
  SELECT username, status, joint, joint_acc_num
  FROM applications
  WHERE active=1;
/
--TODO - create Trigger or Procedure to inactivate applications when status changes from 0

