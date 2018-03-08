/* 1) Setting up Oracle chinook
* Oracle chinook has been setup
*/

/* 2.0 SQL Queries 
*
*  2.1 SELECT
*/

SELECT * FROM EMPLOYEE;
SELECT * FROM EMPLOYEE WHERE LASTNAME='King';
SELECT * FROM EMPLOYEE WHERE FIRSTNAME='Andrew' AND REPORTSTO IS NULL;

/* 2.2 ORDER BY */

SELECT * FROM ALBUM ORDER BY TITLE DESC;
SELECT FIRSTNAME FROM CUSTOMER ORDER BY CITY ASC;

/* 2.3 INSERT INTO */

INSERT ALL 
    INTO GENRE (GENREID, NAME) VALUES (26, 'Funk')
    INTO GENRE (GENREID, NAME) VALUES (27, 'Folk')
SELECT * FROM DUAL;

INSERT ALL 
    INTO EMPLOYEE (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE, REPORTSTO, HIREDATE) 
        VALUES (9, 'Stevens', 'Robert', 'Sales Support Agent', 2, '31-JAN-05')
    INTO EMPLOYEE (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE, REPORTSTO, HIREDATE) 
        VALUES (10, 'Smith', 'Susan', 'Sales Support Manager', 1, '22-FEB-05')
SELECT * FROM DUAL;

INSERT ALL 
    INTO CUSTOMER (CUSTOMERID, LASTNAME, FIRSTNAME, EMAIL) 
        VALUES (60, 'Li', 'Xiu Ying', 'l.xiuying@baidu.com')
    INTO CUSTOMER (CUSTOMERID, LASTNAME, FIRSTNAME, EMAIL) 
        VALUES (61, 'Zhang', 'Yong', 'zyong88@weibo.com')
SELECT * FROM DUAL;

/* 2.4 UPDATE */

UPDATE CUSTOMER
SET LASTNAME='Mitchell', FIRSTNAME='Aaron'
WHERE LASTNAME='Walter' AND FIRSTNAME='Robert';

UPDATE ARTIST
SET NAME='CCR'
WHERE NAME='Creedence Clearwater Revival';

/* 2.5 LIKE */

SELECT * FROM INVOICE WHERE BILLINGADDRESS LIKE 'T%';

/* 2.6 BETWEEN */

SELECT * FROM INVOICE WHERE TOTAL BETWEEN 15 AND 50;

SELECT * FROM EMPLOYEE WHERE HIREDATE BETWEEN '01-JUN-03' AND '01-MAR-04'; 

/* 2.7 DELETE */

/*delete a record in Customer where Name is Robert Walter, resolve constraints*/
