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
DELETE FROM INVOICELINE
WHERE INVOICEID IN
(SELECT INVOICEID FROM INVOICE
WHERE CUSTOMERID=
(SELECT CUSTOMERID FROM CUSTOMER
    WHERE FIRSTNAME='Robert' AND LASTNAME='Walter'));

SELECT * FROM INVOICE
WHERE CUSTOMERID=
(SELECT CUSTOMERID FROM CUSTOMER C 
WHERE FIRSTNAME='Robert' AND LASTNAME='Walter');

DELETE FROM CUSTOMER
WHERE FIRSTNAME='Robert' AND LASTNAME='Walter';

--Could also use ALTER TABLE to add DELETE ON CASCADE to the FK references in CUSTOMER (and INVOICE if needed)

/* 3.0 SQL Functions */

/* 3.1 System Defined Functions */
--Function that returns the current time
CREATE OR REPLACE FUNCTION The_Time_Please
    return varchar2
IS
    the_time    varchar2(20) := to_char(SYSDATE, 'HH24:MI:SS' );
    the_message varchar2(30) := 'The current time is : ' || the_time;
BEGIN
    dbms_output.put_line( the_message );
    return the_message;
END;
/

SELECT The_Time_Please FROM dual;

--function that returns the length of a mediatype from the mediatype table

CREATE OR REPLACE FUNCTION MEDIATYPE_NAME_LENGTH ( MEDIATYPEID_ARG number )
    RETURN number
IS  
    MEDIA_NAME     varchar2(20); 
    NAME_LENGTH    number(20);
    CURSOR c1 is SELECT NAME FROM MEDIATYPE WHERE MEDIATYPEID=MEDIATYPEID_ARG;
BEGIN
    OPEN c1;
    FETCH c1 INTO MEDIA_NAME;
    CLOSE c1;
    NAME_LENGTH := LENGTH(MEDIA_NAME);

RETURN NAME_LENGTH;
END;
/

SELECT MEDIATYPE_NAME_LENGTH(1) FROM DUAL;

/* 3.2 System Defined Aggregate Functions */
--Create a function that returns the average total of all invoices
CREATE OR REPLACE FUNCTION AVG_INVOICE_TOTAL
    RETURN number
IS  
    AVG_TOTAL    number(5);
    CURSOR c1 is SELECT AVG(TOTAL) FROM INVOICE;
BEGIN
    OPEN c1;
    FETCH c1 INTO AVG_TOTAL;
    CLOSE c1;
RETURN AVG_TOTAL;
END;
/

SELECT AVG_INVOICE_TOTAL FROM DUAL;

--Create a function that returns the most expensive track
CREATE OR REPLACE FUNCTION MOST_EXP_TRACK
    RETURN number
IS  
    MOST_EXP    number(5);
    CURSOR c1 is SELECT MAX(UNITPRICE) FROM TRACK;
BEGIN
    OPEN c1;
    FETCH c1 INTO MOST_EXP;
    CLOSE c1;
RETURN MOST_EXP;
END;
/

SELECT MOST_EXP_TRACK FROM DUAL;

/* 3.3 User Defined Scalar Functions */
--Creat a function that returns the average price of invoiceline items in invoiceline
CREATE OR REPLACE FUNCTION AVG_TRACK_IN_INVOICE ( INVOICEID_ARG NUMBER )
    RETURN number
IS  
    AVG_PRICE    number(5);
    CURSOR c1 is SELECT AVG(UNITPRICE) FROM INVOICELINE WHERE INVOICEID=INVOICEID_ARG;
BEGIN
    OPEN c1;
    FETCH c1 INTO AVG_PRICE;
    CLOSE c1;
RETURN AVG_PRICE;
END;
/

SELECT AVG_TRACK_IN_INVOICE(123) FROM DUAL;

/* 3.4 User Defined Table Valued Functions */
--Create a function that returns all employees born after 1968
CREATE OR REPLACE FUNCTION YOUNG_EMPLOYEES
RETURN SYS_REFCURSOR
IS cursorname SYS_REFCURSOR;
BEGIN
    OPEN cursorname FOR SELECT EMPLOYEEID, LASTNAME, FIRSTNAME FROM EMPLOYEE WHERE BIRTHDATE > '31-DEC-68';
RETURN cursorname;
END;
/
SELECT YOUNG_EMPLOYEES FROM DUAL;
/

/* 4.0 Stored Procedures */
/* 4.1 Basic Stored Procedures */
--Create a SP that selects the first and last names of all the employees
CREATE OR REPLACE PROCEDURE GET_EMPL_NAMES(CURSOR_ OUT SYS_REFCURSOR)
AS BEGIN
OPEN CURSOR_ FOR
SELECT LASTNAME, FIRSTNAME FROM EMPLOYEE;
END;
/

/* 4.2 Stored Procedure Input Parameters */
--create a SP that updates employee personal info
CREATE OR REPLACE PROCEDURE EMPLOYEE_ (EMPLOYEEID_ARG NUMBER, NEW_ADDRESS VARCHAR2, NEW_CITY VARCHAR2, NEW_STATE VARCHAR2)
AS BEGIN
    UPDATE EMPLOYEE SET ADDRESS=NEW_ADDRESS, CITY=NEW_CITY, STATE=NEW_STATE WHERE EMPLOYEEID=EMPLOYEEID_ARG;
END;
/

--create a SP that returns the managers of an employee
CREATE OR REPLACE PROCEDURE GET_EMPL_MNGRS(LASTNAME_ARG VARCHAR2, FIRSTNAME_ARG VARCHAR2, CURSOR_ OUT SYS_REFCURSOR)
AS BEGIN
OPEN CURSOR_ FOR
    SELECT LASTNAME, FIRSTNAME FROM EMPLOYEE WHERE EMPLOYEEID=(SELECT REPORTSTO 
            FROM EMPLOYEE WHERE LASTNAME=LASTNAME_ARG AND FIRSTNAME=FIRSTNAME_ARG);
END;
/

/* 4.3 Stored Procedure Output Parameters */
--create a SP that returns the name and company of a customer
CREATE OR REPLACE PROCEDURE GET_CUST_INFO(LASTNAME_ARG VARCHAR2, CURSOR_ OUT SYS_REFCURSOR)
AS BEGIN
OPEN CURSOR_ FOR
    SELECT LASTNAME, FIRSTNAME,COMPANY FROM CUSTOMER WHERE LASTNAME=LASTNAME_ARG;
END;
/


/* 5.0 Transactions */
--create a transaction that will delete an invoice and all relationally-constrained records given the invoiceid
CREATE OR REPLACE PROCEDURE DELETE_INVOICE(INVOICEID_ARG NUMBER)
AS
BEGIN
    SAVEPOINT sp_new;
    
    DELETE FROM INVOICELINE WHERE INVOICEID=INVOICEID_ARG;
    DELETE FROM INVOICE WHERE INVOICEID=INVOICEID_ARG;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK TO sp_new;
    RAISE;
END;
/

--create a transaction nested within a SP that inserts a new record in Customer
CREATE OR REPLACE PROCEDURE NEW_CUST(CUSTOMERID_ARG NUMBER, FIRSTNAME_ARG VARCHAR2, LASTNAME_ARG VARCHAR2, EMAIL_ARG VARCHAR2)
AS
BEGIN
    SAVEPOINT sp_new;
    
    INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL) 
        VALUES (CUSTOMERID_ARG, FIRSTNAME_ARG, LASTNAME_ARG, EMAIL_ARG)
        
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK TO sp_new;
    RAISE;
END;
/

/* 6.0 Triggers */
/* 6.1 AFTER/FOR */
--create an after insert trigger on employee fired after a new record is inserted into the table
CREATE OR REPLACE TRIGGER NOTIFY_NEW_EMP AFTER INSERT ON EMPLOYEE
FOR EACH ROW 
BEGIN
    DBMS_OUTPUT.ENABLE;
    DBMS_OUTPUT.PUT_LINE('new record inserted');
END;
/

DBMS_OUTPUT.PRINT_LN;
/

--create an after update trigger on album that fires after a row is update
CREATE OR REPLACE TRIGGER NOTIFY_ALB_UPD AFTER UPDATE ON ALBUM
FOR EACH ROW 
BEGIN
    DBMS_OUTPUT.ENABLE;
    DBMS_OUTPUT.PUT_LINE('record in album updated');
END;
/

DBMS_OUTPUT.GET_LINES;

--create or replace a delete trigger that fires after a row is deleted from customer
CREATE OR REPLACE TRIGGER NOTIFY_CUST_DEL AFTER DELETE ON CUSTOMER
FOR EACH ROW 
BEGIN
    DBMS_OUTPUT.ENABLE;
    DBMS_OUTPUT.PUT_LINE('record in customer deleted');
END;
/

DBMS_OUTPUT.GET_LINES;


/* JOINS */
/* 7.1 INNER */
--create an inner join for customers and orders specifying the name of the customer and invoiceid
SELECT C.LASTNAME, C.FIRSTNAME, I.INVOICEID
    FROM CUSTOMER C
    JOIN INVOICE I
    ON C.CUSTOMERID = I.CUSTOMERID;
    
/* 7.2 OUTER */
--create an outer join tat joins customer and invoice, specifying customerid, firstname, lastname, invoiceid, total
SELECT C.CUSTOMERID, C.LASTNAME, C.FIRSTNAME, I.INVOICEID, I.TOTAL
    FROM CUSTOMER C
    FULL OUTER JOIN INVOICE I
    ON C.CUSTOMERID = I.CUSTOMERID;

/* 7.3 RIGHT */
--create a right join that joins album and artist specifying artist name and title
SELECT AR.NAME, AL.TITLE
    FROM ARTIST AR
    RIGHT JOIN ALBUM AL
    ON AR.ARTISTID = AL.ARTISTID;
    
/* 7.4 CROSS */
--create a cross join that joins album and artist, sort by artist name in asc order
SELECT *
    FROM ARTIST AR
    CROSS JOIN ALBUM AL
    ORDER BY AR.NAME ASC;

/* 7.5 SELF */
--peform a self join on employee, joining to reportsto
SELECT E1.LASTNAME||' works for '||E2.LASTNAME
   "Employees and Their Managers"
    FROM EMPLOYEE E1, EMPLOYEE E2
    WHERE E2.REPORTSTO=E1.EMPLOYEEID;
