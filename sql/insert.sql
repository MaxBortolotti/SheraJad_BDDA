USE `sherajad`;

INSERT IGNORE INTO rating (id, average, bayesaverage, usersrated) VALUES
(1, 8.38, 8.25, 45000),
(2, 8.85, 8.70, 60000),
(3, 8.60, 8.50, 20000),
(4, 7.80, 7.70, 50000),
(5, 8.10, 8.00, 30000),
(6, 8.25, 8.15, 55000),
(7, 8.40, 8.30, 35000),
(8, 8.10, 8.00, 60000),
(9, 7.90, 7.80, 30000),
(10, 8.35, 8.25, 50000),
(11, 7.75, 7.65, 120000),
(12, 7.40, 7.30, 110000),
(13, 7.50, 7.40, 100000),
(14, 7.60, 7.50, 90000),
(15, 7.20, 7.10, 100000);



INSERT IGNORE INTO game (id, name, description, yearpublished, minplayers, maxplayers, playingtime, minplaytime, maxplaytime, minage, owned, trading, wanting, wishing, idRa) VALUES
(1, 'Terraforming Mars', 'In Terraforming Mars, you compete to build the best and most efficient city on Mars.', 2016, 1, 5, 120, 120, 120, 12, 50000, 1000, 2000, 3000, 1),
(2, 'Gloomhaven', 'Gloomhaven is a tactical miniatures combat-driven game in a persistent world of dark fantasy.', 2017, 1, 4, 60, 60, 120, 14, 70000, 1500, 2500, 3500, 2),
(3, 'Brass Birmingham', 'Brass: Birmingham is an economic strategy game where players compete as entrepreneurs in Birmingham during the industrial revolution.', 2018, 2, 4, 120, 120, 120, 14, 25000, 500, 1500, 2000, 3),
(4, 'Azul', 'Azul is a tile-laying game where players draft colored tiles and carefully create a stained glass window pattern.', 2017, 1, 4, 45, 30, 45, 8, 60000, 2000, 3000, 4000, 4),
(5, 'Root', 'Root is a game of woodland might and right, where players control factions vying for control of a vast forest.', 2018, 2, 4, 90, 60, 120, 10, 40000, 1000, 2000, 2500, 5),
(6, 'Scythe', 'Scythe is an engine-building game set in an alternate-history 1920s period, where players conquer territory in Eastern Europa.', 2016, 1, 5, 115, 90, 115, 14, 65000, 1500, 2500, 3000, 6),
(7, 'Spirit Island', 'Spirit Island is a cooperative settler-destruction game where players act as spirits of the land defending their island from invaders.', 2017, 1, 4, 90, 60, 120, 13, 45000, 1000, 2000, 2500, 7),
(8, 'Wingspan', 'Wingspan is a competitive bird-collection game where players are bird enthusiasts seeking to discover and attract the best birds to their network of wildlife preserves.', 2019, 1, 5, 60, 40, 70, 10, 70000, 1500, 2500, 3000, 8),
(9, 'Viticulture', 'Viticulture is a worker-placement game about the wine-making business in rustic, pre-modern Tuscany.', 2013, 1, 6, 90, 45, 150, 13, 40000, 1000, 2000, 2500, 9),
(10, 'Twilight Struggle', 'Twilight Struggle is a two-player game simulating the 45-year struggle between the USSR and the USA for world dominance.', 2005, 2, 2, 180, 120, 240, 13, 60000, 1500, 2000, 2500, 10),
(11, '7 Wonders', '7 Wonders is a civilization-building game where players develop commercial routes and affirm their supremacy through prestige buildings and military might.', 2010, 2, 7, 30, 30, 30, 10, 130000, 2000, 3000, 4000, 11),
(12, 'Carcassonne', 'Carcassonne is a tile-placement game where players draw and place a tile with a piece of southern French landscape on it.', 2000, 2, 5, 30, 30, 45, 7, 120000, 2000, 3000, 4000, 12),
(13, 'Ticket to Ride', 'Ticket to Ride is a railway-themed board game where players collect and play matching train cards to claim railway routes.', 2004, 2, 5, 45, 30, 60, 8, 110000, 2000, 3000, 4000, 13),
(14, 'Pandemic', 'Pandemic is a cooperative game where players work together to cure diseases that threaten to wipe out humanity.', 2008, 2, 4, 45, 45, 45, 8, 100000, 2000, 3000, 4000, 14),
(15, 'Catan', 'Catan is a classic game of trading and building where players collect resources and use them to build settlements, cities, and roads on a variable game board.', 1995, 3, 4, 75, 60, 90, 10, 110000, 2000, 3000, 11000, 15);



INSERT IGNORE INTO category (id, name) VALUES
(1, 'Science Fiction'),
(2, 'Terrain Building'),
(3, 'Fantasy'),
(4, 'Adventure'),
(5, 'Economic'),
(6, 'Industry / Manufacturing'),
(7, 'Abstract Strategy'),
(8, 'Wargame'),
(9, 'Cooperative Play'),
(10, 'Civilization'),
(11, 'City Building'),
(12, 'Medieval'),
(13, 'Trains'),
(14, 'Transportation'),
(15, 'Medical');

INSERT IGNORE INTO connGC (idG, idC) VALUES
(1, 1), (1, 2),
(2, 3), (2, 4),
(3, 5), (3, 6),
(4, 7),
(5, 8),
(6, 5),
(7, 9),
(8, 10),
(9, 5), (9, 6),
(10, 8),
(11, 10),
(12, 11), (12, 12),
(13, 13), (13, 14),
(14, 15),
(15, 5), (15, 6);



INSERT IGNORE INTO mechanic (id, name) VALUES
(1, 'Tile Placement'),
(2, 'Variable Player Powers'),
(3, 'Modular Board'),
(4, 'Legacy Game'),
(5, 'Network Building'),
(6, 'Variable Setup'),
(7, 'Area Control'),
(8, 'Hand Management'),
(9, 'Card Drafting'),
(10, 'Set Collection'),
(11, 'Action Points'),
(12, 'Grid Movement'),
(13, 'Worker Placement'),
(14, 'Deck Building'),
(15, 'Route Building');

INSERT IGNORE INTO connGM (idG, idM) VALUES
(1, 1), (1, 2),
(2, 3), (2, 4),
(3, 5), (3, 6),
(4, 1), (4, 9),
(5, 7), (5, 2),
(6, 11), (6, 12),
(7, 3), (7, 2),
(8, 9), (8, 10),
(9, 13), (9, 6),
(10, 7), (10, 8),
(11, 9), (11, 10),
(12, 7), (12, 1),
(13, 15), (13, 10),
(14, 9), (14, 2),
(15, 13), (15, 3);


INSERT IGNORE INTO person (id, firstname, lastname) VALUES
(1, 'Jacob', 'Fryxelius'),
(2, 'Isaac', 'Fryxelius'),
(3, 'Isaac', 'Childres'),
(4, 'Josh', 'McDowell'),
(5, 'Martin', 'Wallace'),
(6, 'Gavan', 'Brown'),
(7, 'Matt', 'Tolman'),
(8, 'Damien', 'Mammoliti'),
(9, 'Lina', 'Cossette'),
(10, 'Michael', 'Kiesling'),
(11, 'Chris', 'Quilliams'),
(12, 'Cole', 'Wehrle'),
(13, 'Kyle', 'Ferrin'),
(14, 'Jamey', 'Stegmaier'),
(15, 'Jakub', 'Rozalski'),
(16, 'R. Eric', 'Reuss'),
(17, 'Jason', 'Dobson'),
(18, 'Elizabeth', 'Hargrave'),
(19, 'Ana', 'Maria Martinez Jaramillo'),
(20, 'Natalia', 'Rojas'),
(21, 'Beth', 'Sobel'),
(22, 'Antoine', 'Bauza'),
(23, 'Miguel', 'Coimbra'),
(24, 'Klaus-Jürgen', 'Wrede'),
(25, 'Doris', 'Matthäus'),
(26, 'Anne', 'Pätzke'),
(27, 'Leo', 'Colovini'),
(28, 'Alan', 'R. Moon'),
(29, 'Julien', 'Delval'),
(30, 'Cyrille', 'Daujean'),
(31, 'Matt', 'Leacock'),
(32, 'Volkan', 'Baga'),
(33, 'Jean-Aymeric', 'Diet'),
(34, 'Dennis', 'Lohausen'),
(35, 'Donald X.', 'Vaccarino'),
(36, 'Matthias', 'Catrein'),
(37, 'Ryan', 'Laukat'),
(38, 'Marcel-André', 'Casper'),
(39, 'Uwe', 'Rosenberg'),
(40, 'Klemens', 'Franz');

INSERT IGNORE INTO connGP (idG, idP) VALUES
(1, 1), (1, 2),
(2, 3), (2, 4),
(3, 5), (3, 6), (3, 7),
(4, 10), (4, 11),
(5, 12), (5, 13),
(6, 14), (6, 15),
(7, 16), (7, 17),
(8, 18), (8, 19), (8, 20),
(9, 21), (9, 20),
(10, 35), (10, 36),
(11, 22), (11, 23),
(12, 24), (12, 25), (12, 26), (12, 27),
(13, 28), (13, 29), (13, 30),
(14, 31), (14, 11),
(15, 32), (15, 33), (15, 34);

INSERT IGNORE INTO review (id, userrating, message, idRa, idP) VALUES
(1, 8.5, 'Great game! Very engaging.', 1, 1),
(2, 7.5, 'Fun but complex rules.', 2, 2),
(3, 9.0, 'Best strategy game ever!', 3, 3),
(4, 8.5, 'Beautiful components.', 4, 4),
(5, 7.5, 'Good for family game nights.', 5, 5),
(6, 8.5, 'High replayability.', 6, 6),
(7, 9.5, 'Amazing artwork and theme.', 7, 7),
(8, 8.0, 'Easy to learn, hard to master.', 8, 8),
(9, 8.0, 'Great cooperative experience.', 9, 9),
(10, 9.0, 'Very immersive gameplay.', 10, 10),
(11, 1.5, 'Very bad game.', 5, 7);

INSERT IGNORE INTO users (id, email, password, creationdate, idP) VALUES (1, "user@example.com", SHA2(CONCAT(NOW(), "user"), 224), NOW(), 33);
/*
DELETE FROM users WHERE idP = 33;
SELECT * FROM users;
*/

/*
SELECT * FROM game;
SELECT * FROM category;
SELECT * FROM mechanic;
SELECT * FROM rating;
SELECT * FROM review;
SELECT * FROM person;
SELECT * FROM connGC;
SELECT * FROM connGM;
SELECT * FROM connGP;
SELECT * FROM person;
SELECT * FROM users;
*/

#SELECT game.id, game.name, game.idRa, rating.id, rating.average, rating.bayesaverage, rating.usersrated FROM game JOIN rating ON game.idRa = rating.id;

#SELECT * FROM rating JOIN review ON rating.id = review.idRa;

#SELECT * FROM person WHERE person.id = 33;