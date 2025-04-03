USE `sherajad`;
--Création des vues

-- Création de la vue liste_jeux_plus_récent 10 dernières années
CREATE OR REPLACE VIEW liste_jeux_plus_récent AS 
SELECT id, name, description, yearpublished, minplayers, maxplayers, playingtime, minplaytime, maxplaytime, minage, owned, trading, wanting, wishing, idRa
FROM game WHERE yearpublished >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- Création de la vue avec une review avec seulement une étoile
CREATE OR REPLACE VIEW review_une_etoile AS
SELECT id, userrating, message, idRa, idP
FROM review WHERE userrating BETWEEN 1.0 AND 2.0;

-- Création de la vue jeu avec la mechanic area control
CREATE OR REPLACE VIEW jeu_avec_areacontrol AS
SELECT id, name 
FROM mechanic WHERE name = 'Area Control';

--Creation d'une vue d'un jeu jouable 4+
CREATE OR REPLACE VIEW jeu_jouable_4_plus AS
SELECT id, name, description, yearpublished, minplayers, maxplayers, playingtime, minplaytime, maxplaytime, minage, owned, trading, wanting, wishing, idRa
FROM game WHERE minplayers >= 4 AND maxplayers >= 4;

-- CREATION DES INDEXS
CREATE INDEX index_playing_time on game(playingtime);
CREATE INDEX index_min_playing_time on game(minplaytime);
CREATE INDEX index_max_playing_time on game(maxplaytime);

--index game name
CREATE INDEX index_game_name on game(name);

--index mechanic
CREATE INDEX index_mechanic_name on mechanic(name);

--index rating
CREATE INDEX index_rating_average on rating(bayesaverage);


--TRIGGERS

DELIMITER $$
CREATE TRIGGER 

DELIMITER;

