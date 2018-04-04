/* Formatted on 04/04/2018 12:02:10 a.m. (QP5 v5.300) */
--1 crear una funcion que me regrese la edad actual

CREATE OR REPLACE FUNCTION getActualAge (startD IN DATE)
    RETURN NUMBER
AS
    result   NUMBER (10, 2);
BEGIN
    result := (SYSDATE - startD) / 365;
    RETURN result;
END;
------------

SELECT getActualAge (birthday) AS edad FROM nobel.usuarios;

---Metodo 2

CREATE OR REPLACE FUNCTION getActualAge2 (userid IN NUMBER)
    RETURN NUMBER
AS
    result   NUMBER (10, 2);
    tempo    DATE;
BEGIN
    SELECT birthday
      INTO tempo
      FROM nobel.usuarios
     WHERE nobel.usuarios.user_id = userid;

    result := (SYSDATE - tempo) / 365;
    RETURN result;
END;

SELECT getActualAge2 (420) FROM DUAL;

--2 crear una funcion que me regresa la edad al momento de ganar el premio nobel

CREATE OR REPLACE FUNCTION difBetweenDates (startD IN DATE, endD IN DATE)
    RETURN NUMBER
AS
    result   NUMBER (10, 2);
BEGIN
    result := (endD - startD) / 365;
    RETURN result;
END;
--------

SELECT difBetweenDates (birthday, fecha) AS edad_cuando_gano_premio,
       birthday,
       premio.fecha,
       usuarios.nombre
  FROM nobel.usuarios  usuarios
       INNER JOIN nobel.inter_premio inter
           ON inter.user_id = usuarios.user_id
       INNER JOIN nobel.premio premio ON premio.premio_id = inter.premio_id;

--3 Crear un procedimiento almacenado para insertar a un ganador de algun premio nobel

----

CREATE OR REPLACE PROCEDURE insert_premio (nombre       IN NVARCHAR2,
                                           motivacion   IN NVARCHAR2,
                                           fecha        IN DATE,
                                           country      IN NUMBER,
                                           categoria    IN NUMBER)
IS
BEGIN
    INSERT INTO NOBEL.PREMIO (Premio_id,
                              fecha,
                              nombre,
                              motivacion,
                              country_id,
                              categoria_id)
         VALUES (NOBEL.PREMIO_SEQ.NEXTVAL,
                 fecha,
                 nombre,
                 motivacion,
                 country,
                 categoria);
END;

EXEC insert_premio('Premio de la Paz', 'Para ser una mejor persona', '01/01/2016', 1,3);