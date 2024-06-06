/* @ Code   : Pour SQL Oracle Database 21c
@ Auteur : Patrick Saint-Louis 
@ Date   : 2024
 */
--1-CREATE A DATABASE 
--1-CREER UNE BASE DE DONNEES 
--Create a new user account (Replace admin123 by your own password)
--Créer un nouveau compte utilisateur (Remplacez admin123 par votre propre mot de passe)
CREATE USER c##institut_langues IDENTIFIED BY admin456 DEFAULT TABLESPACE USERS;

--Assign privileges and roles to the new user
--Assigner des privilèges et roles au nouvel l'utilisateur
GRANT UNLIMITED TABLESPACE TO c##institut_langues;

GRANT CONNECT,
RESOURCE TO c##institut_langues;

--Connect with the new user in SQL *Plus
--Connecter avec le nouvel utilisateur dans SQL *Plus
CONNECT c##institut_langues / admin456
--Check the new user is successfully connected in SQL *Plus
--Vérifier que le nouvel utilisateur est connecté avec succès dans SQL *Plus
SHOW user;

--VERSION 1 : ANONYMOUS CONSTRAINTS 
--VERSION 1 : CONTRAINTES ANONYMES
--2-CREATE THE PHYSICAL MODEL CODE (including TABLES, COLUMNS, ASSOCIATIONS, AND CARDINALITIES)
--2-CREER LE CODE DU MODELE PHYSIQUE (incluant des TABLES, COLONNES, ASSOCIATIONS ET CARDINALITES)
--Delete permanently the tables if they already exist
--Supprimer le table de maniere permanente si elles existent 
DROP TABLE Affectation;

DROP TABLE Inscription;

DROP TABLE Cours_Semestre;

DROP TABLE Etudiant;

DROP TABLE Instructeur;

DROP TABLE Code_Ville_Province;

DROP TABLE Semestre;

DROP Table Cours;

--Create table Cours (Course)
--Créer table Cours  
CREATE TABLE
  Cours (
    Code_Cours VARCHAR2(20) PRIMARY KEY,
    Titre VARCHAR2(45) NOT NULL,
    Description VARCHAR2(255),
    Langue VARCHAR2(45) DEFAULT 'Français' NOT NULL CONSTRAINT CHECK_Langue_Cours CHECK (Langue IN ('Français', 'English')),
    Duree NUMBER(2) NOT NULL CHECK (Duree IN (30, 60, 90))
  );

--Create table Semestre (Semester)
--Créer table Semestre  
CREATE TABLE
  Semestre (
    ID_Semestre VARCHAR2(19) AS (CONCAT(Saison, TO_CHAR(Date_Debut, 'YYYY'))) PRIMARY KEY,
    Saison VARCHAR2(15) NOT NULL CONSTRAINT CHECK_Saison_Semestre CHECK (Saison IN ('Hiver', 'Eté', 'Automne')),
    Annee NUMBER(4) AS (TO_CHAR(Date_Debut, 'YYYY')),
    Date_Debut DATE NOT NULL UNIQUE,
    Date_Fin DATE NOT NULL UNIQUE
  );

--Create table Code_Ville_Province (Code_City_Province)
--Créer table Code_Ville_Province  
CREATE TABLE
  Code_Ville_Province (
    Code_Postal CHAR(6) PRIMARY KEY,
    Ville VARCHAR2(15) NOT NULL,
    Province VARCHAR2(80) DEFAULT 'Quebec' NOT NULL
  );

--Create table Instructeur (Instructor)
--Créer table Instructeur  
CREATE TABLE
  Instructeur (
    ID_Instructeur VARCHAR2(20) PRIMARY KEY,
    Civilite VARCHAR2(15),
    Prenom VARCHAR2(80) NOT NULL,
    Nom VARCHAR2(80) NOT NULL,
    Date_Naissance DATE NOT NULL,
    Telephone CHAR(12),
    Courriel VARCHAR2(50) NOT NULL,
    Adresse VARCHAR2(50) NOT NULL,
    Code_Postal CHAR(6) NOT NULL CONSTRAINT CHECK_Code_Postal_Instructeur CHECK (
      REGEXP_LIKE (Code_Postal, '^[A-Z][0-9][A-Z][0-9][A-Z][0-9]')
    ),
    FOREIGN KEY (Code_Postal) REFERENCES Code_Ville_Province (Code_Postal)
  );

--Create table Etudiant (Student)
--Créer table Etudiant  
CREATE TABLE
  Etudiant (
    ID_Etudiant VARCHAR2(20) PRIMARY KEY,
    Civilite VARCHAR2(15),
    Prenom VARCHAR2(80) NOT NULL,
    Nom VARCHAR2(80) NOT NULL,
    Date_Naissance DATE NOT NULL,
    Telephone CHAR(12),
    Courriel VARCHAR2(50) NOT NULL,
    Adresse VARCHAR2(50) NOT NULL,
    Code_Postal CHAR(6) NOT NULL CONSTRAINT CHECK_Code_Postal_Etudiant CHECK (
      REGEXP_LIKE (Code_Postal, '^[A-Z][0-9][A-Z][0-9][A-Z][0-9]')
    ),
    FOREIGN KEY (Code_Postal) REFERENCES Code_Ville_Province (Code_Postal)
  );

--Create table Cours_Semestre (Course_Semester)
--Créer table Cours_Semestre  
CREATE TABLE
  Cours_Semestre (
    ID_Cours_Offert VARCHAR2(20) PRIMARY KEY,
    Code_Cours VARCHAR2(20),
    FOREIGN KEY (Code_Cours) REFERENCES Cours (Code_Cours) ON DELETE SET NULL,
    ID_Semestre VARCHAR2(19),
    FOREIGN KEY (ID_Semestre) REFERENCES Semestre (ID_Semestre) ON DELETE SET NULL
  );

--Create table Inscription (Registration)
--Créer table Inscription  
CREATE TABLE
  Inscription (
    ID_Etudiant VARCHAR2(20),
    FOREIGN KEY (ID_Etudiant) REFERENCES Etudiant (ID_Etudiant) ON DELETE CASCADE,
    ID_Cours_Offert VARCHAR2(20),
    FOREIGN KEY (ID_Cours_Offert) REFERENCES Cours_Semestre (ID_Cours_Offert) ON DELETE CASCADE,
    Date_Inscription DATE
  );

--Create table Affectation (Assignment)
--Créer table Affectation  
CREATE TABLE
  Affectation (
    ID_Instructeur VARCHAR2(20),
    FOREIGN KEY (ID_Instructeur) REFERENCES Instructeur (ID_Instructeur) ON DELETE CASCADE,
    ID_Cours_Offert VARCHAR2(20) UNIQUE,
    FOREIGN KEY (ID_Cours_Offert) REFERENCES Cours_Semestre (ID_Cours_Offert) ON DELETE CASCADE,
    Date_Attribution DATE NOT NULL
  );

--Tables comments
--Commentaires sur les tables
COMMENT ON TABLE Cours IS 'Table Cours pour enregistrer des informations sur chaque cours';

COMMENT ON TABLE Semestre IS 'Table Semestre pour enregistrer des informations sur chaque semestre';

COMMENT ON TABLE Code_Ville_Province IS 'Table Code_Ville_Province pour enregistrer les villes et provinces qui correspondent à chaque code postal';

COMMENT ON TABLE Instructeur IS 'Table Instructeur pour enregistrer des informations sur chaque instructeur';

COMMENT ON TABLE Etudiant IS 'Table Etudiant pour enregistrer des informations sur chaque étudiant';

COMMENT ON TABLE Cours_Semestre IS 'Table Cours_Semestre pour enregistrer des informations sur chaque groupe cours offert chaque semestre';

COMMENT ON TABLE Inscription IS 'Table Inscription pour enregistrer des informations sur chaque inscription d''un étudiant inscrit à un groupe cours offert par semestre';

COMMENT ON TABLE Affectation IS 'Table Affectation pour enregistrer des informations sur chaque affectation d''un groupe cours offert par semestre à instructeur';

--3-CONFIRM THE CREATION OF THE PHYSICAL MODEL
--3-CONFIRMER LA CREATION DU MODELE PHYSIQUE
--Show all user account tables to confirm the tables was successfully created
--Afficher toutes les tables de l'utilisateur pour confirmer la creation des tables 
SELECT
  table_name
FROM
  user_tables
ORDER BY
  table_name ASC;

--Show the table columns
--Afficher les colonnes des tables
DESC Affectation;

DESC Inscription;

DESC Cours_Semestre;

DESC Etudiant;

DESC Instructeur;

DESC Code_Ville_Province;

DESC Semestre;

DESC Cours;

--Show info about the column integrity constraints
--Afficher les informations sur des contraintes d'integrité des colonnes
SELECT
  *
FROM
  user_cons_columns
WHERE
  table_name IN (
    SELECT
      table_name
    FROM
      user_tables
  );

--Show the table comments
--Afficher les commentaires des table
SELECT
  *
FROM
  user_tab_comments
WHERE
  table_name IN (
    SELECT
      table_name
    FROM
      user_tables
  );
