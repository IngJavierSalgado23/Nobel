
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

SELECT CAMPO, OU_Q.VECES_GANADAS
  FROM (SELECT CAMPO_ID,
               VECES_GANADAS,
               ROW_NUMBER () OVER (ORDER BY VECES_GANADAS DESC) AS ORDEN
          FROM (  SELECT CAMPO_ID, COUNT (CAMPO_ID) AS VECES_GANADAS
                    FROM nobel.INTER_CAMPO
                GROUP BY CAMPO_ID
                ORDER BY CAMPO_ID DESC) IN_Q) OU_Q
       INNER JOIN NOBEL.CAMPO CAM ON CAM.CAMPO_ID = OU_Q.CAMPO_ID
 WHERE OU_Q.ORDEN = 1;

--5-Obtener los premios ganados desde el anio 1980 al 1990 en quimica

SELECT nombre,
       fecha,
       motivacion,
       categoria
  FROM nobel.premio  prem
       INNER JOIN nobel.categoria cat ON cat.categoria_id = prem.categoria_id
 WHERE categoria = 'QUIMICA' AND fecha BETWEEN '01/01/1981' AND '31/12/1990';

--6-Obtener el premio nobel ganados en menos ocasiones

SELECT NOMBRE, VECES_GANADAS
  FROM (SELECT NOMBRE,
               VECES_GANADAS,
               ROW_NUMBER () OVER (ORDER BY VECES_GANADAS ASC) AS ORDEN
          FROM (  SELECT NOMBRE, COUNT (NOMBRE) AS VECES_GANADAS
                    FROM NOBEL.PREMIO
                GROUP BY NOMBRE))
 WHERE ORDEN = 1;

--7-Obtener el pais con mas premios nobels

SELECT country, in_q.nobels_ganados
  FROM (SELECT country_id,
               nobels_ganados,
               ROW_NUMBER () OVER (ORDER BY nobels_ganados DESC) AS orden
          FROM (  SELECT country_id, COUNT (country_id) AS nobels_ganados
                    FROM nobel.premio
                GROUP BY country_id
                ORDER BY nobels_ganados DESC)) in_q
       INNER JOIN nobel.country con ON con.country_id = in_q.country_id
 WHERE orden = 1;

--8-Obtener los premios nobel compartidos (mas de un ganador en la misma categoria y anio)

  SELECT prem.nombre,
         usuario.nombre,
         ganadores,
         prem.premio_id
    FROM (  SELECT premio_id, COUNT (premio_id) AS ganadores
              FROM NOBEL.INTER_PREMIO
          GROUP BY premio_id
          ORDER BY ganadores ASC) in_q
         INNER JOIN NOBEL.INTER_PREMIO inter
             ON inter.premio_id = in_q.premio_id
         INNER JOIN nobel.usuarios usuario ON usuario.user_id = inter.user_id
         INNER JOIN nobel.premio prem ON inter.premio_id = prem.premio_id
   WHERE ganadores > 1
ORDER BY prem.premio_id ASC;

--9- Obtener el promedio de edad de todos los ganadores al momento en que ganan su premio

SELECT (promedio_en_dias / 365) as Edad_Promedio
  FROM (SELECT AVG (edad) AS promedio_en_dias
          FROM (SELECT usuario, fecha - birthday AS edad
                  FROM (SELECT prem.nombre,
                               prem.fecha,
                               usuario.nombre AS usuario,
                               usuario.BIRTHDAY,
                               usuario.user_id
                          FROM nobel.premio  prem
                               INNER JOIN nobel.inter_premio inter
                                   ON inter.premio_id = prem.premio_id
                               INNER JOIN nobel.usuarios usuario
                                   ON usuario.user_id = inter.user_id) in_q));