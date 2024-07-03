DROP VIEW liste_employes_departements;
DROP TABLE employe;
DROP TABLE departement;

CREATE TABLE departement (
    id_dep NUMBER(2),
    denomination VARCHAR(70) NOT NULL UNIQUE,
    etage NUMBER(1) NOT NULL,
    PRIMARY KEY (id_dep)
);

CREATE TABLE employe (
    id_emp VARCHAR(6),
    prenom VARCHAR(100) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    id_dep NUMBER(2),
    PRIMARY KEY (id_emp),
    FOREIGN KEY (id_dep) REFERENCES departement (id_dep)
);



--Insert into departement
INSERT INTO departement 
VALUES (1, 'Informatique', 4);

INSERT INTO departement 
VALUES (2, 'Comptabilité', 7);

INSERT INTO departement 
VALUES (3, 'Ressources Humaines', 1);

INSERT INTO departement 
VALUES (4, 'Administration', 2);

INSERT INTO departement 
VALUES (5, 'Technique', 5);

--Insert into employe
INSERT INTO employe 
VALUES ('EMP001', 'John', 'Doe', 1);

INSERT INTO employe 
VALUES ('EMP002', 'Jane', 'Doe', 2);

INSERT INTO employe 
VALUES ('EMP003', 'John', 'Smith', 3);

INSERT INTO employe 
VALUES ('EMP004', 'Jane', 'Smith', 4);

INSERT INTO employe 
VALUES ('EMP005', 'Lorem', 'Ipsum', 5);

INSERT INTO employe 
VALUES ('EMP006', 'Lorraine', 'Ipsum', 1);

INSERT INTO employe 
VALUES ('EMP007', 'Max', 'Mustermann', 2);

INSERT INTO employe 
VALUES ('EMP008', 'Monsieur', 'Dupond', 3);

INSERT INTO employe 
VALUES ('EMP009', 'Johny', 'Doe', 4);

INSERT INTO employe 
VALUES ('EMP010', 'Doe', 'Jane', 5);

INSERT INTO employe 
VALUES ('EMP011', 'Ipsum', 'Doe', 1);

INSERT INTO employe 
VALUES ('EMP012', 'Lorem', 'Jane', 5);

INSERT INTO employe 
VALUES ('EMP013', 'John', 'Doe', 1);

INSERT INTO employe 
VALUES ('EMP014', 'Jane', 'Doe', 4);

INSERT INTO employe 
VALUES ('EMP015', 'Monsieur', 'Dupond', 5);

/*
--METTRE A JOUR UNE COLONNE
--UPDATE A COLUMN
--Vérifier avant les modifications
SELECT * FROM EMPLOYE WHERE ID_EMP = 'EMP009' ; 

--Mettre à jour les données 
UPDATE EMPLOYE
SET PRENOM = 'Cookie'
WHERE ID_EMP = 'EMP009' ; 

--Vérifier après les modifications
SELECT * FROM EMPLOYE WHERE ID_EMP = 'EMP009' ;


--CREATE A VIEW 
--CREER UNE VUES
--Vérifier avant la création de la vue 
SELECT * FROM liste_employes_departements; 

--Creer une table virtuelle (vue) 
CREATE OR REPLACE VIEW liste_employes_departements AS
SELECT e.id_emp, e.prenom, e.nom, d.id_dep, d.denomination, d.etage
FROM employe e, departement d
WHERE d.id_dep = e.id_dep;

--Vérifier après la création de la vue 
SELECT * FROM liste_employes_departements;


--SUPPRIMER UNE LIGNE
--DROP A ROW
--Vérifier avant les modifications
SELECT * FROM EMPLOYE WHERE ID_EMP = 'EMP015' ; 

--Mettre à jour les données 
DELETE FROM EMPLOYE
WHERE ID_EMP = 'EMP015' ; 

--Vérifier après les modifications
SELECT * FROM EMPLOYE WHERE ID_EMP = 'EMP015' ; 


DROP VIEW liste_employes_departements;
DROP TABLE employe;
DROP TABLE departement;
*/
