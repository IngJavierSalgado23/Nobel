/* Formatted on 02/04/2018 09:31:14 p.m. (QP5 v5.300) */
--1

CREATE OR REPLACE FUNCTION getActualAge (startD IN DATE)
    RETURN NUMBER
AS
    result   NUMBER (10, 2);
BEGIN
    result := (SYSDATE - startD) / 365;
    RETURN result;
END;

--2

CREATE OR REPLACE FUNCTION winningAge (startD IN DATE, endD IN DATE)
    RETURN NUMBER
AS
    result   NUMBER (10, 2);
BEGIN
    result := (endD - startD) / 365;
    RETURN result;
END;



--1

CREATE OR REPLACE FUNCTION getActualAge2 (userid IN NUMBER)
    RETURN NUMBER
AS
    result   NUMBER (10, 2);
    valor2   DATE;
BEGIN
    SELECT fecha
      INTO valor2
      FROM nobel.usuarios
     WHERE nobel.usuarios.user_id = userid;

    result := (SYSDATE - valor2) / 365;
    RETURN result;
END;