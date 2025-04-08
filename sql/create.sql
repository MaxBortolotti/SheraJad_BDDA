CREATE SCHEMA IF NOT EXISTS `sherajad`;
USE `sherajad`;


SET FOREIGN_KEY_CHECKS=0;
DROP TABLE if exists category;
DROP TABLE if exists mechanic;
DROP TABLE if exists rating;
DROP TABLE if exists person;
DROP TABLE if exists review;
DROP TABLE if exists users;
DROP TABLE if exists game;
DROP TABLE if exists connGC;
DROP TABLE if exists connGM;
DROP TABLE if exists connGP;
SET FOREIGN_KEY_CHECKS=1;


CREATE TABLE category(
   id INT,
   name VARCHAR(50)  NOT NULL,
   PRIMARY KEY(id)
);

CREATE TABLE mechanic(
   id INT,
   name VARCHAR(50)  NOT NULL,
   PRIMARY KEY(id)
);

CREATE TABLE rating(
   id INT,
   average DECIMAL(5,3)  ,
   bayesaverage DECIMAL(5,3)  ,
   usersrated INT,
   PRIMARY KEY(id)
);

CREATE TABLE person(
   id INT,
   firstname VARCHAR(50) ,
   lastname VARCHAR(50) ,
   PRIMARY KEY(id)
);

CREATE TABLE review(
   id INT,
   userrating DECIMAL(5,3)  ,
   message VARCHAR(50) ,
   idRa INT NOT NULL,
   idP INT NOT NULL,
   PRIMARY KEY(id),
   FOREIGN KEY(idRa) REFERENCES rating(id),
   FOREIGN KEY(idP) REFERENCES person(id)
);

CREATE TABLE users(
   id INT,
   email VARCHAR(50) ,
   password VARCHAR(50) ,
   creationdate DATE,
   idP INT NOT NULL,
   PRIMARY KEY(id),
   UNIQUE(idP),
   UNIQUE(email),
   FOREIGN KEY(idP) REFERENCES person(id)
);

CREATE TABLE game(
   id INT,
   name VARCHAR(50)  NOT NULL,
   description VARCHAR(1024) ,
   yearpublished INT,
   minplayers INT,
   maxplayers INT,
   playingtime INT,
   minplaytime INT,
   maxplaytime INT,
   minage INT,
   owned INT,
   trading INT,
   wanting INT,
   wishing INT,
   idRa INT,
   PRIMARY KEY(id),
   UNIQUE(idRa),
   FOREIGN KEY(idRa) REFERENCES rating(id)
);

CREATE TABLE connGC(
   idG INT,
   idC INT,
   PRIMARY KEY(idG, idC),
   FOREIGN KEY(idG) REFERENCES game(id),
   FOREIGN KEY(idC) REFERENCES category(id)
);

CREATE TABLE connGM(
   idG INT,
   idM INT,
   PRIMARY KEY(idG, idM),
   FOREIGN KEY(idG) REFERENCES game(id),
   FOREIGN KEY(idM) REFERENCES mechanic(id)
);

CREATE TABLE connGP(
   idG INT,
   idP INT,
   PRIMARY KEY(idG, idP),
   FOREIGN KEY(idG) REFERENCES game(id),
   FOREIGN KEY(idP) REFERENCES person(id)
);


