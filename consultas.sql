use `GAMES_2024`;

SELECT * FROM games_2024.games;
#

SELECT MIN(YEAR(release_date)) AS primer_anio
FROM games;
## primer año registrado 1977

###ventas-totales
SELECT title, total_sales 
FROM games 
ORDER BY total_sales DESC 
LIMIT 10;

#
SELECT title, jp_sales 
FROM games 
ORDER BY total_sales DESC 
LIMIT 10;

#
SELECT title, na_sales 
FROM games 
ORDER BY total_sales DESC 
LIMIT 10;

#
SELECT title, eu_af_sales 
FROM games 
ORDER BY total_sales DESC 
LIMIT 10;
#gta5 es el juego con más ventas en los registros historicos

# consola
#puntaje promedio de consola teniendo en cuenta la catiad de juegos para evitar outliders
SELECT console, AVG(critic_score) AS promedio_critica, COUNT(*) AS cantidad_juegos
FROM games
WHERE critic_score IS NOT NULL
GROUP BY console
HAVING COUNT(*) >= 5
ORDER BY promedio_critica DESC
LIMIT 5;

#m demuestra que game boy es un autlider
SELECT title, critic_score
FROM games
WHERE console = 'GBC' AND critic_score IS NOT NULL
ORDER BY critic_score DESC;

## JUEGOS Y CRITICA
##JUEGO CON MEJOR CRITICA promedio
SELECT title, genre, AVG(critic_score) AS promedio_critica, COUNT(*) AS cantidad_juegos
FROM games
WHERE critic_score IS NOT NULL
GROUP BY title, genre
HAVING COUNT(*) >= 5
ORDER BY promedio_critica DESC
LIMIT 5;

#OUTLIER 'Red Dead Redemption: Undead Nightmare'
SELECT title, AVG(critic_score) AS promedio_critica
from games
WHERE critic_score IS NOT NULL
GROUP BY title
ORDER BY promedio_critica DESC
LIMIT 5;

select * from
games
where title = 'Red Dead Redemption: Undead Nightmare';

####developer--cual el el desarollador con el mejor pormedio de critica-promedio
SELECT developer, avg(critic_score) AS promedio_critica
FROM games 
WHERE critic_score IS NOT NULL
GROUP BY developer
ORDER BY promedio_critica  DESC
LIMIT 10;
#Rockstar Games es el developer con el mejor promedio de critica en los datos historicos

###developer--cual el el desarollador con el mejor pormedio de critica-promedio-por-año
SELECT 
    anio,
    developer,
    promedio_critica
FROM (
    SELECT 
        YEAR(release_date) AS anio,
        developer,
        AVG(critic_score) AS promedio_critica,
        RANK() OVER (PARTITION BY YEAR(release_date) ORDER BY AVG(critic_score) DESC) AS rnk
    FROM games
    WHERE critic_score IS NOT NULL
    GROUP BY anio, developer
) AS ranked
WHERE rnk = 1
ORDER BY anio DESC;

###########
########
#

###Evolución de lanzamientos por año
SELECT YEAR(release_date) AS anio, COUNT(*) AS juegos
FROM games
GROUP BY anio
ORDER BY anio DESC;
#segun lso reirstor en os ltios añls cayo la cantidad de jeugos estrenados.
#siendo 22 en  2020 y 30 en 2019 comparados con más de 400 juegos por año en los 20 años anteriores segun los registros
#esto puede ser en realcion a los cambios tecnologicos y el aumento de la complejisdades los juegos y las historiars qeu esots posibilitan al igual quwe lo quedemandasn lo susuarios
# ademas en el caso de las sagas de juegos ya instañladsa, la esecttiva es mayor y el tiepo de espera entre juegos es un factor de exito

SELECT COUNT(*) AS juegos_sin_fecha
FROM games
WHERE release_date IS NULL;

###########
########
#
#GENERO
#cantidad de juegos por genero-¿Qué géneros son más populares en términos de cantidad de juegos?
SELECT genre, COUNT(*) AS cantidad
FROM games
GROUP BY genre
ORDER BY cantidad DESC;
#action y sports son histricamente los generos más populares

#canida de de genero por año
SELECT 
  YEAR(release_date) AS anio,
  genre,
  COUNT(*) AS cantidad
FROM 
  games
GROUP BY 
  anio, genre
ORDER BY 
  anio DESC, cantidad DESC;
###generos ventas-¿Qué géneros venden más?
#GENERAL
   SELECT 
  genre,
  SUM(total_sales) AS ventas_totales,
  COUNT(*) AS cantidad_juegos
FROM 
  games
GROUP BY 
  genre
ORDER BY 
  ventas_totales DESC
  limit 10;

SELECT 
  genre,
  SUM(jp_sales) AS ventas_totales,
  COUNT(*) AS cantidad_juegos
FROM 
  games
GROUP BY 
  genre
ORDER BY 
  ventas_totales DESC;
  
  SELECT 
  genre,
  SUM(eu_af_sales) AS ventas_totales,
  COUNT(*) AS cantidad_juegos
FROM 
  games
GROUP BY 
  genre
ORDER BY 
  ventas_totales DESC;
  
  SELECT 
  genre,
  SUM(na_sales) AS ventas_totales,
  COUNT(*) AS cantidad_juegos
FROM 
  games
GROUP BY 
  genre
ORDER BY 
  ventas_totales DESC;
  
  SELECT 
  genre,
  SUM(other_sales) AS ventas_totales,
  COUNT(*) AS cantidad_juegos
FROM 
  games
GROUP BY 
  genre
ORDER BY 
  ventas_totales DESC;
  
  ##en el registro historico Action, Sport, Shooter son los juegos más popoulares en la mayoria de los mercados, en japon el primer lugar
  #lo ocupa Rolepaling en lugar de shooter
  
  ##cómo evoluciona todo en el tiempo--evolucion de la popularidad de geneos en los diferentes mercados en lo sultimos 5 años de registo.
  SELECT
    anio,
    genre,
    total_ventas
FROM (
    SELECT 
        YEAR(release_date) AS anio,
        genre,
        SUM(total_sales) AS total_ventas
    FROM games
    GROUP BY anio, genre
) AS ventas_por_genero
-- Ahora filtro los máximos
WHERE (anio, total_ventas) IN (
    SELECT 
        anio,
        MAX(total_ventas)
    FROM (
        SELECT 
            YEAR(release_date) AS anio,
            genre,
            SUM(total_sales) AS total_ventas
        FROM games
        GROUP BY anio, genre
    ) AS subventas
    GROUP BY anio
)
ORDER BY anio DESC;
## en venteas generales los ultimos años  role palying accion y shooter fueron los más poplares


###########
########
#
#titulo con mas ventas en cada año, de los ultimos años, mostrar TODO de lso mas vendidos en lso ultimos años 2020-2015
SELECT 
    anio,
    title,
    genre,
    na_sales,
    developer,
    console,
    critic_score
FROM (
    SELECT 
        YEAR(release_date) AS anio,
        title,
        genre,
        na_sales,
        developer,
        console,
        critic_score,
        RANK() OVER (PARTITION BY YEAR(release_date) ORDER BY total_sales DESC) AS rnk
    FROM games
    WHERE total_sales IS NOT NULL
) AS ventas_rankeadas
WHERE rnk = 1
ORDER BY anio DESC;
#en ventas generales el juego 'Final Fantasy Type-0' de role palig fue el más popular con más ventas en 2020

###top5 de 2020
select
title, genre, sum(total_sales), developer, console, critic_score, year(release_date)
from games
where year(release_date)=2020
group by title, genre, developer,  console, critic_score, year(release_date)
order by sum(total_sales) desc
limit 5;
##Final Fantasy Type-0,Dragon Quest Monsters: Caravan Heart,Imagine: Makeup Artist,Tokyo Jungle son los jegos mas populares del 2020

###########
########
#
#developer mas popular-por-añop
SELECT
    anio,
    developer,
    total_ventas
FROM (
    SELECT 
        YEAR(release_date) AS anio,
        developer,
        SUM(total_sales) AS total_ventas
    FROM games
    GROUP BY anio, developer
) AS ventas_por_developer
-- Ahora filtro los máximos
WHERE (anio, total_ventas) IN (
    SELECT 
        anio,
        MAX(total_ventas)
    FROM (
        SELECT 
            YEAR(release_date) AS anio,
            developer,
            SUM(total_sales) AS total_ventas
        FROM games
        GROUP BY anio, developer
    ) AS subventas
    GROUP BY anio
)
ORDER BY anio DESC;
#los developer más populares coinciden

###########
#######
##
######-- Género más vendido en Japón y América por año para un developer
SELECT 
    j.anio,
    j.genre AS genero_japon,
    j.ventas AS ventas_japon,
    a.genre AS genero_america,
    a.ventas AS ventas_america
FROM (
    SELECT 
        YEAR(release_date) AS anio,
        genre,
        SUM(jp_sales) AS ventas,
        RANK() OVER (PARTITION BY YEAR(release_date) ORDER BY SUM(jp_sales) DESC) AS rnk
    FROM games
    WHERE developer = 'Rockstar North'
    GROUP BY anio, genre
) AS j
JOIN (
    SELECT 
        YEAR(release_date) AS anio,
        genre,
        SUM(na_sales) AS ventas,
        RANK() OVER (PARTITION BY YEAR(release_date) ORDER BY SUM(na_sales) DESC) AS rnk
    FROM games
    WHERE developer = 'Rockstar North'
    GROUP BY anio, genre
) AS a
ON j.anio = a.anio
WHERE j.rnk = 1 AND a.rnk = 1
ORDER BY j.anio desc;

###########
########
#
#consolas mas vendidas por año
SELECT 
    anio,
    console,
    ventas
FROM (
    SELECT 
        YEAR(release_date) AS anio,
        console,
        SUM(total_sales) AS ventas,
        RANK() OVER (PARTITION BY YEAR(release_date) ORDER BY SUM(total_sales) DESC) AS rnk
    FROM games
    GROUP BY anio, console
) AS ventas_rankeadas
WHERE rnk = 1
ORDER BY anio DESC;

select title, year(release_date) as anio, sum(total_sales) as ventas, console
from games
where console = 'PSP' and year(release_date)= 2020
group by anio, title, console
order by ventas desc;
#los juegos mas vendidos coinciden