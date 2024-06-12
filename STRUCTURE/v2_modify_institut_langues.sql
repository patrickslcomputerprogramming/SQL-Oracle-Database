-- @ Code   : Pour SQL Oracle Database 21c
-- @ Auteur : Patrick Saint-Louis 
-- @ Date   : 2024


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
--Convert Annee to a computed or virtual column
--Convertir Annee en une colonne calculée automatiquement
ALTER TABLE Semestre
ADD CONSTRAINT CHECK_Date_Fin 
CHECK (Date_Fin > Date_Debut);


--TABLE 3 Code_Ville_Province
--Add "Montreal" a the default value for Ville
--Ajouter "Montreal" comme valeur par defaut pour Ville
ALTER TABLE Code_Ville_Province
MODIFY Ville DEFAULT 'Montreal';
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
