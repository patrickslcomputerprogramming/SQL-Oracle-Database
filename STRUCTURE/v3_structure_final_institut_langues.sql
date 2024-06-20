/* @ Code   : Pour SQL Oracle Database 21c
@ Auteur : Patrick Saint-Louis 
@ Date   : 2024
*/

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
CREATE TABLE Cours (
    Code_Cours VARCHAR2(20) PRIMARY KEY,
    Titre VARCHAR2(45) NOT NULL,
    Description VARCHAR2(255),
    Langue VARCHAR2(45) DEFAULT 'Français' NOT NULL 
    CONSTRAINT CHECK_Langue_Cours CHECK (Langue IN ('Francais', 'English')),
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
    Province VARCHAR2(80) DEFAULT 'Québec' NOT NULL
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


--1-MODIFY THE STRUCTURE OF THE PHYSICAL MODEL CODE (including TABLES, COLUMNS, ASSOCIATIONS, AND CARDINALITIES)
--1-MODIFIER LA STUCTURE DU DU MODELE PHYSIQUE (incluant des TABLES, COLONNES, ASSOCIATIONS ET CARDINALITES)   

--TABLE 1 Cours
--Add "Espanol" to the Check Constraint of "Langue"
--Ajouter Modify "Espanol" au Contrainte Check de "Langue"
ALTER TABLE Cours
DROP CONSTRAINT CHECK_Langue_Cours; 

ALTER TABLE Cours
ADD CONSTRAINT CHECK_Langue_Cours
CHECK (Langue IN('Francais','English', 'Espanol'));
-------------------------------------------------

--TABLE 2 Semestre
--Ajouter une contrainte verifiant que Date_Fin ulterieure a Date_Debut
--Add a constraint checking that Date_Fin greater than Date_Debut 
ALTER TABLE Semestre
ADD CONSTRAINT CHECK_Date_Fin 
CHECK (Date_Fin > Date_Debut);


--TABLE 3 Code_Ville_Province
--Add "Montreal" a the default value for Ville
--Ajouter "Montreal" comme valeur par defaut pour Ville
ALTER TABLE Code_Ville_Province
MODIFY Ville VARCHAR2(15) DEFAULT 'Montréal';
-----------------------------------------------------------


--TABLE 4 Instructeur
--Add a Check Constraint to validate Telephone using the format DDD-DDD-DDDD where D is a digit from 0 to 9
--Add a Check Constraint to validate Courriel using the format xxx@xxx.xx where x is an alphanumeric value  
--Ajouter une Contrainte Check pour valider Telephone suivant le format DDD-DDD-DDDD avec D comme chiffre de 0 à 9
--Ajouter une Contrainte Check pour valider Courriel suivant le format xxx@xxx.xx avec x comme une valeur alphanumerique
ALTER TABLE Instructeur
ADD CONSTRAINT CHECK_Telephone_Instructeur
CHECK (REGEXP_LIKE (Telephone,'^[0-9]{3}+[-]+[0-9]{3}+[-]+[0-9]{4}'));

ALTER TABLE Instructeur
ADD CONSTRAINT CHECK_Courriel_Instructeur 
CHECK (REGEXP_LIKE (Courriel,'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$'));
                             


--TABLE 5 Etudiant
--Delete Telephone permanently
--Add a Check Constraint to validate Courriel using the format xxx@xxx.xx where x is an alphanumeric value 
--Supprimer Telephone de maniere permanente
 --Ajouter une Contrainte Check pour valider Courriel suivant le format xxx@xxx.xx avec x comme une valeur alphanumerique
ALTER TABLE Etudiant
DROP COLUMN Telephone;

ALTER TABLE Etudiant
ADD CONSTRAINT CHECK_Courriel_Etudiant
CHECK (REGEXP_LIKE (Courriel,'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$'));


--TABLE 6 Cours_Semestre
--Modify Table Comment to : 
--Modifier Commentaire de table par:
--'Table Cours_Semestre pour enregistrer le titre de chaque groupe cours offert à chaque semestre';
COMMENT ON TABLE Cours_Semestre IS 
'Table Cours_Semestre pour enregistrer le titre de chaque groupe cours offert chaque semestre';


--TABLE 7 Inscription
--Add a new column named Statut (Status) that must mandatory receive one of the values 'Inscrit-Actif', 'Inscrit-Inactif', and 'Désincrit' 
--Ajouter une nouvelle colonne nommée Statut qui doit obligatoirement recevoir l'une des valeurs 'Inscrit-Actif', 'Inscrit-Inactif', and 'Désincrit'
ALTER TABLE Inscription
ADD Statut VARCHAR2(18) NOT NULL
CONSTRAINT CHECK_Inscription 
CHECK (Statut IN('Inscrit-Actif','Inscrit-Inactif', 'Désinscrit'));


--TABLE 8 Affectation
--Rename Date_Attribution to Date_Affectation
--Renommer Date_Attribution par Date_Affectation
ALTER TABLE Affectation
RENAME COLUMN Date_Attribution TO Date_Affectation;


--2-CONFIRM THE MODIDFICATIONS WERE APPLIED SUCCESSFULLY
--2-CONFIRMER L'APPLICATION REUSSIE DES MODIFICATIONS

--Show all user account tables to confirm the tables was successfully created
--Afficher toutes les tables de l'utilisateur pour confirmer la creation des tables 
SELECT table_name FROM user_tables ORDER BY table_name ASC;

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
SELECT * 
FROM user_cons_columns 
WHERE table_name IN (SELECT table_name FROM user_tables ) ;


--Show the table comments
--Afficher les commentaires des table
SELECT * FROM user_tab_comments
WHERE table_name IN (SELECT table_name FROM user_tables ) ;
