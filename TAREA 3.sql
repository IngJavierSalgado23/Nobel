/* Formatted on 07/03/2018 07:23:13 p.m. (QP5 v5.300) */
SELECT * FROM NOBEL.BIRTHPLACE; --Y

SELECT * FROM NOBEL.CAMPO; -- n

SELECT * FROM NOBEL.CATEGORIA; -- N

SELECT * FROM NOBEL.COUNTRY; --Y

  SELECT *
    FROM NOBEL.INTER_CAMPO
ORDER BY campo_id DESC; -- borrar los datos

SELECT * FROM NOBEL.INTER_PREMIO;

SELECT * FROM NOBEL.PREMIO; --y

SELECT * FROM NOBEL.RESIDENCIA; --y

  SELECT *
    FROM NOBEL.RESIDENCIA_INTER
ORDER BY premio_id; -- Borrar esta

SELECT * FROM NOBEL.ROLES; --y

SELECT * FROM NOBEL.USUARIOS; --Y


INSERT INTO NOBEL.CATEGORIA (CATEGORIA_ID, CATEGORIA)
     VALUES (NOBEL.CAT_SEQ.NEXTVAL, 'PAZ');

INSERT INTO NOBEL.PREMIO (Premio_id,
                          fecha,
                          nombre,
                          motivacion,
                          country_id,
                          categoria_id)
     VALUES (NOBEL.PREMIO_SEQ.NEXTVAL,
             '01/01/1981',
             'Nobel de la FISICA',
             'Por que estaba aburrido al cuadrado',
             6,
             1);

--1-Obtener las 5 premios nobel mas recientes

SELECT *
  FROM (SELECT NOMBRE,
               FECHA,
               MOTIVACION,
               ROW_NUMBER () OVER (ORDER BY FECHA DESC) AS ORDEN
          FROM NOBEL.PREMIO)
 WHERE ORDEN < 6;

--2-Obtener los ultimos 10 premios nobel de fisica

SELECT *
  FROM (SELECT NOMBRE                                   FECHA,
               CATEGORIA,
               MOTIVACION,
               ROW_NUMBER () OVER (ORDER BY FECHA DESC) AS ORDEN
          FROM NOBEL.PREMIO  PREM
               INNER JOIN NOBEL.CATEGORIA CAT
                   ON CAT.CATEGORIA_ID = PREM.CATEGORIA_ID
         WHERE CAT.CATEGORIA = 'FISICA')
 WHERE ORDEN < 11;

--3-Obtener las personas que han ganado mas de un premio

  SELECT *
    FROM (  SELECT user_id, COUNT (user_id) AS Veces_Ganadas
              FROM nobel.inter_premio
          GROUP BY user_id)
   WHERE veces_ganadas > 1
ORDER BY veces_ganadas ASC;

--4-Obtener el campo o lenguaje con mas premios nobel

SELECT * FROM nobel.campo;

--5-Obtener los premios ganados desde el anio 1980 al 1990 en quimica

SELECT nombre,
       fecha,
       motivacion,
       categoria
  FROM nobel.premio  prem
       INNER JOIN nobel.categoria cat ON cat.categoria_id = prem.categoria_id
 WHERE categoria = 'QUIMICA' and fecha between '01/01/1981' and '31/12/1990';

--6-Obtener el premio nobel ganados en menos ocasiones
--7-Obtener el pais con mas premios nobel

select * from (
select country_id, count(country_id) as cont_pais from nobel.premio group by country_id order by cont_pais desc) in_q inner join nobel.country con on 
con.COUNTRY_ID = in_q.country_id;
select country_id, row_number () over () from (
select country_id, count(country_id) as cont_pais from nobel.premio group by country_id order by cont_pais desc) group by country_id;
--8-Obtener los premios nobel compartidos (mas de un ganador en la misma categoria y anio)
--9- Obtener el promedio de edad de todos los ganadores al momento en que ganan su premio