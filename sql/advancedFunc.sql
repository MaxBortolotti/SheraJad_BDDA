USE `sherajad`;
-- Création des vues

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

-- Creation d'une vue d'un jeu jouable 4+
CREATE OR REPLACE VIEW jeu_jouable_4_plus AS
SELECT id, name, description, yearpublished, minplayers, maxplayers, playingtime, minplaytime, maxplaytime, minage, owned, trading, wanting, wishing, idRa
FROM game WHERE minplayers >= 4 AND maxplayers >= 4;

-- CREATION DES INDEX

#suppression des anciens indexes pour les redéfinir plus bas
DROP INDEX index_playing_time ON game;
DROP INDEX index_min_playing_time ON game;
DROP INDEX index_max_playing_time ON game;
DROP INDEX index_game_name ON game;
DROP INDEX index_mechanic_name ON mechanic;
DROP INDEX index_rating_average ON rating;

CREATE INDEX index_playing_time on game(playingtime);
CREATE INDEX index_min_playing_time on game(minplaytime);
CREATE INDEX index_max_playing_time on game(maxplaytime);

-- index game name
CREATE INDEX index_game_name on game(name);

-- index mechanic
CREATE INDEX index_mechanic_name on mechanic(name);

-- index rating
CREATE INDEX index_rating_average on rating(bayesaverage);


-- TRIGGERS

DROP TRIGGER IF EXISTS increment_user_rating;
DROP TRIGGER IF EXISTS recalculate_average_rating;
DROP TRIGGER IF EXISTS decrement_user_rating;
DROP TRIGGER IF EXISTS default_yearpublished_for_null;

-- trigger qui calcule la moyenne du rating une fois qu'un nouvel avis est inséré
DELIMITER $$
CREATE TRIGGER recalculate_average_rating
AFTER INSERT ON review
FOR EACH ROW
BEGIN 
    DECLARE user_rating DECIMAL(5,3);
    DECLARE avg_rating DECIMAL(5,3);
    DECLARE total_usersrated DECIMAL(5,3);
    DECLARE final_avg_rating DECIMAL(5,3);
    
    #On selectionne les variables que l'on va utiliser
    SELECT rating.usersrated INTO total_usersrated FROM rating WHERE rating.id = NEW.idRa;
    SELECT review.userrating INTO user_rating FROM review WHERE review.id = NEW.id;
    SELECT rating.average INTO avg_rating FROM rating WHERE rating.id = NEW.idRa;
    #Puis, on calcule la nouvelle moyenne a partir de ces variables selectionnees
    SELECT ((avg_rating + user_rating)/(total_usersrated+1)) INTO final_avg_rating;
    UPDATE review SET review.average = final_avg_rating WHERE review.id = NEW.id;
    #Enfin, on incremente le nombre total d'avis du jeu
    UPDATE rating SET rating.usersrated = rating.usersrated + 1 WHERE rating.id = NEW.idRa;
    
END$$
DELIMITER ;


-- trigger qui enlève une review
DELIMITER $$
CREATE TRIGGER decrement_user_rating
AFTER DELETE ON review
FOR EACH ROW
BEGIN  
    UPDATE rating
    SET usersrated = usersrated - 1
    WHERE id = OLD.idRa;
END$$
DELIMITER ;


# trigger qui definit l'annee de publication d'un jeu comme l'annee actuelle si ce nouveu jeu inséré n'a pas de d'annee de publication
DELIMITER $$
CREATE TRIGGER default_yearpublished_for_null
AFTER INSERT ON game
FOR EACH ROW
BEGIN  
	IF NEW.yearpublished <=> NULL THEN
		UPDATE game SET game.yearpublished = YEAR(curdate()) WHERE id = NEW.id;
	END IF;
END$$
DELIMITER ;


# FONCTIONS

USE SHERAJAD;
# fonction qui permet de vérifier si le mot de passe de l'utilisateur est bon
DROP FUNCTION check_user_password;
DELIMITER //
CREATE FUNCTION check_user_password(Iemail VARCHAR(50), Ipassword VARCHAR(50)) RETURNS BOOL
DETERMINISTIC
BEGIN
	DECLARE password_is_correct BOOL;
    DECLARE nbr_response INT;
    SET password_is_correct = 0;
	SELECT COUNT(*) INTO nbr_response FROM users
		WHERE users.email = Iemail AND users.password COLLATE utf8mb4_general_ci  = sha2(concat(users.creationdate, Ipassword), 224);
	IF nbr_response = 1 THEN
		SET password_is_correct = 1;
	END IF;
	
    RETURN password_is_correct;
END //
DELIMITER ;

SELECT check_user_password('user@example.com','user');



# Fonction qui compte le nombre total de jeux de la BDD