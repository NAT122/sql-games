create database if not exists `GAMES_2024`;
use `GAMES_2024`;

CREATE TABLE IF NOT EXISTS `games` (
	id INT auto_increment PRIMARY KEY,
    title VARCHAR(100),
    console VARCHAR(100),
    genre VARCHAR(100),
    publisher VARCHAR(100),
    developer VARCHAR(100),
    critic_score FLOAT, 
    total_sales  FLOAT,
    na_sales FLOAT,
    jp_sales FLOAT,
    eu_af_sales FLOAT,
    other_sales FLOAT,
    release_date DATE,
    last_update DATE 
    );
    DROP TABLE IF EXISTS `games`;
   