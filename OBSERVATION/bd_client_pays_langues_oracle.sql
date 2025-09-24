-- @ residents
-- database entity and dummy data
-- author : Patrick Saint-Louis 
-- date : 2025

--1-CREATE A DATABASE 
--1-CREER UNE BASE DE DONNEES 
--Create a new user account (Replace admin456 by your own password)
--Créer un nouveau compte utilisateur (Remplacez admin456 par votre propre mot de passe)
CREATE USER c##bd_residents IDENTIFIED BY admin456 DEFAULT TABLESPACE USERS;

--Assign privileges and roles to the new user
--Assigner des privilèges et roles au nouvel l'utilisateur
GRANT UNLIMITED TABLESPACE TO c##bd_residents;

GRANT CONNECT,
RESOURCE TO c##bd_residents;

--Connect with the new user in SQL *Plus
--Connecter avec le nouvel utilisateur dans SQL *Plus
CONNECT c##bd_residents / admin456
--Check the new user is successfully connected in SQL *Plus
--Vérifier que le nouvel utilisateur est connecté avec succès dans SQL *Plus
SHOW user;

--2-CREATE THE PHYSICAL MODEL CODE (including TABLES, COLUMNS, ASSOCIATIONS, AND CARDINALITIES)
--2-CREER LE CODE DU MODELE PHYSIQUE (incluant des TABLES, COLONNES, ASSOCIATIONS ET CARDINALITES)
--Delete permanently the tables if they already exist
--Supprimer le table de maniere permanente si elles existent 
DROP TABLE LANGUES_PARLEES;
DROP TABLE CLIENT;
DROP TABLE LIEU;
DROP TABLE LANGUE;

-- 3.Create the Tables | Créer les Tables
/*
Table : LANGUE
NOM_LANGUE : Nom de la langue. Par exemple français, anglais ou créole haïtien. Clé primaire.
PAYS_ORIGINE : Pays d’origine de la langue. Par exemple Haiti.
NOMBRE_DE_LOCUTEURS : Nombre de locuteurs qui parlent cette langue à travers le monde. Par exemple 500000
NIVEAU_DE_DIFFICULTÉ : classements de difficulté linguistique du Foreign Service Institute, donc un chiffre de 1 (plus facile) à 4 (plus difficile). 
STATUT : statut de la langue, c’est-à-dire langue officielle ou langue non officiel.
*/

-- Création de la table LANGUE
CREATE TABLE LANGUE (
    NOM_LANGUE VARCHAR2(50) PRIMARY KEY,
    PAYS_ORIGINE VARCHAR2(50) NOT NULL,
    NOMBRE_DE_LOCUTEURS NUMBER NOT NULL,
    NIVEAU_DE_DIFFICULTE NUMBER CHECK (NIVEAU_DE_DIFFICULTE BETWEEN 1 AND 4),
    STATUT VARCHAR2(20) CHECK (STATUT IN ('officielle', 'non officielle')) NOT NULL
);

/*
Table : LIEU
CODE_LIEU : Code de l’adresse. Clé primaire. Créé automatiquement avec le numéro et le code postale. Par exemple 330H1L4F4.
NUMERO : Numéro de l’adresse. Par exemple, 330.
RUE : Rue de l’adresse. Par exemple, Avenue Bien-être.
VILLE : Ville de l’adresse. Par exemple, Montréal.
PROVINCE : Province de l’adresse. Par exemple, Québec.
PAYS : Pays de l’adresse. Par exemple, Canada. 
CODE_POSTAL : Code postal de l’adresse. Par exemple, H1L4F4.
*/

-- Création de la table LIEU
CREATE TABLE LIEU (
    NUMERO VARCHAR2(10) NOT NULL,
    RUE VARCHAR2(100) NOT NULL,
    VILLE VARCHAR2(50) NOT NULL,
    PROVINCE VARCHAR2(50),
    PAYS VARCHAR2(50) NOT NULL,
    CODE_POSTAL VARCHAR2(15) NOT NULL,
    CODE_LIEU VARCHAR2(25) GENERATED ALWAYS AS (NUMERO || CODE_POSTAL) VIRTUAL PRIMARY KEY
);

/*
Table : CLIENT
CODE_CLIENT : Code du client. Clé primaire. 
PRENOM : Prénom du client. Par exemple, Jean.
NOM : Nom du client. Par exemple Dupont.
DATE_DE_NAISSANCE : Date de naissance du client. Par exemple, 30-05-1981. 
NUMERO_DE_TELEPHONE : Numéro de téléphone du client. Par exemple 514-415-00-00.
COURRIEL : Adresse du courriel électronique du client. Par exemple, jeandupont@gmail.com.
CODE_ADRESSE_RESIDENTIELLE : Code de l’adresse de la résidence du client. Clé secondaire de CODE_LIEU. 
CODE_LIEU_DE_NAISSANCE : Code du lieu de naissance du client. Clé secondaire de CODE_LIEU. 
*/

-- Création de la table CLIENT
CREATE TABLE CLIENT (
    CODE_CLIENT VARCHAR2(20) PRIMARY KEY,
    PRENOM VARCHAR2(50) NOT NULL,
    NOM VARCHAR2(50) NOT NULL,
    DATE_DE_NAISSANCE DATE NOT NULL,
    NUMERO_DE_TELEPHONE VARCHAR2(20),
    COURRIEL VARCHAR2(100),
    CODE_ADRESSE_RESIDENTIELLE VARCHAR2(15) NOT NULL,
    CODE_LIEU_DE_NAISSANCE VARCHAR2(15) NOT NULL,
    FOREIGN KEY (CODE_ADRESSE_RESIDENTIELLE) REFERENCES LIEU(CODE_LIEU),
    FOREIGN KEY (CODE_LIEU_DE_NAISSANCE) REFERENCES LIEU(CODE_LIEU)
);


/*
Table : LANGUES_PARLEES
CODE_CLIENT : Code du client. Clé secondaire de CODE-CLIENT dans CLIENT.
NOM_LANGUE : Nom de la langue. Clé secondaire de NOM_LANGUE dans LANGUE.
*/

-- Création de la table LANGUES_PARLEES
CREATE TABLE LANGUES_PARLEES (
    CODE_CLIENT VARCHAR2(20),
    NOM_LANGUE VARCHAR2(50),
    PRIMARY KEY (CODE_CLIENT, NOM_LANGUE),
    FOREIGN KEY (CODE_CLIENT) REFERENCES CLIENT(CODE_CLIENT),
    FOREIGN KEY (NOM_LANGUE) REFERENCES LANGUE(NOM_LANGUE)
);


--4-CONFIRM THE CREATION OF THE PHYSICAL MODEL
--4-CONFIRMER LA CREATION DU MODELE PHYSIQUE
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
DESC LANGUES_PARLEES;
DESC CLIENT;
DESC LIEU;
DESC LANGUE;





-- 5.Insert dummy data to the Tables | Insérer des données de test dans les Tables 

-- Insertion des langues
INSERT ALL  
    INTO LANGUE (NOM_LANGUE, PAYS_ORIGINE, NOMBRE_DE_LOCUTEURS, NIVEAU_DE_DIFFICULTE, STATUT) 
    VALUES ('français', 'France', 300000000, 1, 'officielle')
    INTO LANGUE (NOM_LANGUE, PAYS_ORIGINE, NOMBRE_DE_LOCUTEURS, NIVEAU_DE_DIFFICULTE, STATUT) 
    VALUES ('anglais', 'États-Unis', 1500000000, 1, 'officielle')
    INTO LANGUE (NOM_LANGUE, PAYS_ORIGINE, NOMBRE_DE_LOCUTEURS, NIVEAU_DE_DIFFICULTE, STATUT) 
    VALUES ('mandarin', 'Chine', 1100000000, 4, 'officielle')
    INTO LANGUE (NOM_LANGUE, PAYS_ORIGINE, NOMBRE_DE_LOCUTEURS, NIVEAU_DE_DIFFICULTE, STATUT) 
    VALUES ('japonais', 'Japon', 130000000, 4, 'officielle')
    INTO LANGUE (NOM_LANGUE, PAYS_ORIGINE, NOMBRE_DE_LOCUTEURS, NIVEAU_DE_DIFFICULTE, STATUT) 
    VALUES ('portugais', 'Brésil', 260000000, 1, 'officielle')
    INTO LANGUE (NOM_LANGUE, PAYS_ORIGINE, NOMBRE_DE_LOCUTEURS, NIVEAU_DE_DIFFICULTE, STATUT) 
    VALUES ('créole haïtien', 'Haïti', 12000000, 2, 'officielle')
    INTO LANGUE (NOM_LANGUE, PAYS_ORIGINE, NOMBRE_DE_LOCUTEURS, NIVEAU_DE_DIFFICULTE, STATUT) 
    VALUES ('espagnol', 'Espagne', 550000000, 1, 'officielle')
    INTO LANGUE (NOM_LANGUE, PAYS_ORIGINE, NOMBRE_DE_LOCUTEURS, NIVEAU_DE_DIFFICULTE, STATUT) 
    VALUES ('italien', 'Italie', 85000000, 1, 'officielle')
    INTO LANGUE (NOM_LANGUE, PAYS_ORIGINE, NOMBRE_DE_LOCUTEURS, NIVEAU_DE_DIFFICULTE, STATUT) 
    VALUES ('fon', 'Bénin', 2000000, 3, 'non officielle')
    INTO LANGUE (NOM_LANGUE, PAYS_ORIGINE, NOMBRE_DE_LOCUTEURS, NIVEAU_DE_DIFFICULTE, STATUT) 
    VALUES ('yoruba', 'Bénin', 30000000, 3, 'non officielle')
    INTO LANGUE (NOM_LANGUE, PAYS_ORIGINE, NOMBRE_DE_LOCUTEURS, NIVEAU_DE_DIFFICULTE, STATUT) 
    VALUES ('allemand', 'Allemagne', 95000000, 2, 'officielle')
    INTO LANGUE (NOM_LANGUE, PAYS_ORIGINE, NOMBRE_DE_LOCUTEURS, NIVEAU_DE_DIFFICULTE, STATUT) 
    VALUES ('catalan', 'Espagne', 7500000, 2, 'non officielle')
    INTO LANGUE (NOM_LANGUE, PAYS_ORIGINE, NOMBRE_DE_LOCUTEURS, NIVEAU_DE_DIFFICULTE, STATUT) 
    VALUES ('néerlandais', 'Belgique', 24000000, 2, 'officielle')
SELECT * FROM DUAL;

-- Insertion des lieux (CODE_LIEU sera généré automatiquement avec numéro + code postal)
INSERT ALL
    INTO LIEU (NUMERO, RUE, VILLE, PROVINCE, PAYS, CODE_POSTAL) 
    VALUES ('123', 'Rue Principale', 'Montréal', 'Québec', 'Canada', 'H1L4F4')
    INTO LIEU (NUMERO, RUE, VILLE, PROVINCE, PAYS, CODE_POSTAL) 
    VALUES ('456', 'Avenue des Champs', 'Paris', 'Île-de-France', 'France', '75008')
    INTO LIEU (NUMERO, RUE, VILLE, PROVINCE, PAYS, CODE_POSTAL) 
    VALUES ('789', 'Main Street', 'New York', 'New York', 'États-Unis', '10001')
    INTO LIEU (NUMERO, RUE, VILLE, PROVINCE, PAYS, CODE_POSTAL) 
    VALUES ('101', 'Wangfujing', 'Pékin', 'Beijing', 'Chine', '100006')
    INTO LIEU (NUMERO, RUE, VILLE, PROVINCE, PAYS, CODE_POSTAL) 
    VALUES ('202', 'Shibuya', 'Tokyo', 'Tokyo', 'Japon', '1500043')
    INTO LIEU (NUMERO, RUE, VILLE, PROVINCE, PAYS, CODE_POSTAL) 
    VALUES ('330', 'Avenue Bien-être', 'Montréal', 'Québec', 'Canada', 'H2X1Y8')
    INTO LIEU (NUMERO, RUE, VILLE, PROVINCE, PAYS, CODE_POSTAL) 
    VALUES ('25', 'Rue de la Paix', 'Lyon', 'Auvergne-Rhône-Alpes', 'France', '69002')
    INTO LIEU (NUMERO, RUE, VILLE, PROVINCE, PAYS, CODE_POSTAL) 
    VALUES ('500', 'Broadway', 'Los Angeles', 'California', 'États-Unis', '90012')
    INTO LIEU (NUMERO, RUE, VILLE, PROVINCE, PAYS, CODE_POSTAL) 
    VALUES ('88', 'Nanjing Road', 'Shanghai', 'Shanghai', 'Chine', '200003')
    INTO LIEU (NUMERO, RUE, VILLE, PROVINCE, PAYS, CODE_POSTAL) 
    VALUES ('15', 'Ginza', 'Osaka', 'Osaka', 'Japon', '5420081')
    INTO LIEU (NUMERO, RUE, VILLE, PROVINCE, PAYS, CODE_POSTAL) 
    VALUES ('200', 'Copacabana', 'Rio de Janeiro', 'Rio de Janeiro', 'Brésil', '22050')
    INTO LIEU (NUMERO, RUE, VILLE, PROVINCE, PAYS, CODE_POSTAL) 
    VALUES ('75', 'Champs-Élysées', 'Paris', 'Île-de-France', 'France', '75008')
    INTO LIEU (NUMERO, RUE, VILLE, PROVINCE, PAYS, CODE_POSTAL) 
    VALUES ('300', 'Alexanderplatz', 'Berlin', 'Berlin', 'Allemagne', '10178')
    INTO LIEU (NUMERO, RUE, VILLE, PROVINCE, PAYS, CODE_POSTAL) 
    VALUES ('42', 'Paseo de la Reforma', 'Mexico', 'Mexico', 'Mexique', '06500')
    INTO LIEU (NUMERO, RUE, VILLE, PROVINCE, PAYS, CODE_POSTAL) 
    VALUES ('18', 'Rue du Commerce', 'Bruxelles', 'Bruxelles', 'Belgique', '1000')
SELECT * FROM DUAL;

-- Insertion des clients (CODE_CLIENT sera généré automatiquement)
INSERT ALL
    INTO CLIENT (CODE_CLIENT, PRENOM, NOM, DATE_DE_NAISSANCE, NUMERO_DE_TELEPHONE, COURRIEL, CODE_ADRESSE_RESIDENTIELLE, CODE_LIEU_DE_NAISSANCE) 
    VALUES ('MT1982-04-15-1', 'Marie', 'Tremblay', TO_DATE('1982-04-15','YYYY-MM-DD'), '514-123-4567', 'marietremblay@hotmail.com', '330H2X1Y8', '45675008') 
    INTO CLIENT (CODE_CLIENT, PRENOM, NOM, DATE_DE_NAISSANCE, NUMERO_DE_TELEPHONE, COURRIEL, CODE_ADRESSE_RESIDENTIELLE, CODE_LIEU_DE_NAISSANCE) 
    VALUES ('JG1983-07-12-1','John', 'Gagnon', TO_DATE('1983-07-12','YYYY-MM-DD'), '438-999-8888', 'johngagnon@yahoo.com', '78910001', '78910001') 
    INTO CLIENT (CODE_CLIENT, PRENOM, NOM, DATE_DE_NAISSANCE, NUMERO_DE_TELEPHONE, COURRIEL, CODE_ADRESSE_RESIDENTIELLE, CODE_LIEU_DE_NAISSANCE) 
    VALUES ('LC1984-01-01-1','Li', 'Chen', TO_DATE('1984-01-01','YYYY-MM-DD'), '514-777-6666', 'lichen@outlook.com', '101100006', '101100006') 
    INTO CLIENT (CODE_CLIENT, PRENOM, NOM, DATE_DE_NAISSANCE, NUMERO_DE_TELEPHONE, COURRIEL, CODE_ADRESSE_RESIDENTIELLE, CODE_LIEU_DE_NAISSANCE) 
    VALUES ('YS1985-05-05-1','Yuki', 'Sato', TO_DATE('1985-05-05','YYYY-MM-DD'), '514-222-3333', 'yukisato@gmail.com', '2021500043', '2021500043') 
    INTO CLIENT (CODE_CLIENT, PRENOM, NOM, DATE_DE_NAISSANCE, NUMERO_DE_TELEPHONE, COURRIEL, CODE_ADRESSE_RESIDENTIELLE, CODE_LIEU_DE_NAISSANCE) 
    VALUES ('SM1990-12-25-1','Sophie', 'Martin', TO_DATE('1990-12-25','YYYY-MM-DD'), '514-555-4444', 'sophiemartin@hotmail.com', '2569002', '2569002') 
    INTO CLIENT (CODE_CLIENT, PRENOM, NOM, DATE_DE_NAISSANCE, NUMERO_DE_TELEPHONE, COURRIEL, CODE_ADRESSE_RESIDENTIELLE, CODE_LIEU_DE_NAISSANCE) 
    VALUES ('CS1988-08-18-1','Carlos', 'Silva', TO_DATE('1988-08-18','YYYY-MM-DD'), '514-111-2222', 'carlossilva@gmail.com', '20022050', '20022050') 
    INTO CLIENT (CODE_CLIENT, PRENOM, NOM, DATE_DE_NAISSANCE, NUMERO_DE_TELEPHONE, COURRIEL, CODE_ADRESSE_RESIDENTIELLE, CODE_LIEU_DE_NAISSANCE) 
    VALUES ('AM1992-03-08-1','Anna', 'Müller', TO_DATE('1992-03-08','YYYY-MM-DD'), '514-333-4444', 'annamuller@yahoo.com', '7575008', '45675008') 
    INTO CLIENT (CODE_CLIENT, PRENOM, NOM, DATE_DE_NAISSANCE, NUMERO_DE_TELEPHONE, COURRIEL, CODE_ADRESSE_RESIDENTIELLE, CODE_LIEU_DE_NAISSANCE) 
    VALUES ('PL1987-11-11-1','Pierre', 'Lavoie', TO_DATE('1987-11-11','YYYY-MM-DD'), '514-666-7777', 'pierrelavoie@gmail.com', '123H1L4F4', '330H2X1Y8') 
    INTO CLIENT (CODE_CLIENT, PRENOM, NOM, DATE_DE_NAISSANCE, NUMERO_DE_TELEPHONE, COURRIEL, CODE_ADRESSE_RESIDENTIELLE, CODE_LIEU_DE_NAISSANCE) 
    VALUES ('EB1995-06-30-1','Élise', 'Bouchard', TO_DATE('1995-06-30','YYYY-MM-DD'), '514-888-9999', 'elisebouchard@hotmail.com', '45675008', '123H1L4F4') 
    INTO CLIENT (CODE_CLIENT, PRENOM, NOM, DATE_DE_NAISSANCE, NUMERO_DE_TELEPHONE, COURRIEL, CODE_ADRESSE_RESIDENTIELLE, CODE_LIEU_DE_NAISSANCE) 
    VALUES ('TW1991-09-14-1','Thomas', 'Weber', TO_DATE('1991-09-14','YYYY-MM-DD'), '514-444-5555', 'thomasweber@gmail.com', '30010178', '30010178') 
    INTO CLIENT (CODE_CLIENT, PRENOM, NOM, DATE_DE_NAISSANCE, NUMERO_DE_TELEPHONE, COURRIEL, CODE_ADRESSE_RESIDENTIELLE, CODE_LIEU_DE_NAISSANCE) 
    VALUES ('MG1989-02-20-1','Maria', 'Garcia', TO_DATE('1989-02-20','YYYY-MM-DD'), '514-777-8888', 'mariagarcia@hotmail.com', '4206500', '4206500') 
    INTO CLIENT (CODE_CLIENT, PRENOM, NOM, DATE_DE_NAISSANCE, NUMERO_DE_TELEPHONE, COURRIEL, CODE_ADRESSE_RESIDENTIELLE, CODE_LIEU_DE_NAISSANCE) 
    VALUES ('DJ1986-07-07-1','David', 'Johnson', TO_DATE('1986-07-07','YYYY-MM-DD'), '514-999-0000', 'davidjohnson@yahoo.com', '50090012', '50090012') 
    INTO CLIENT (CODE_CLIENT, PRENOM, NOM, DATE_DE_NAISSANCE, NUMERO_DE_TELEPHONE, COURRIEL, CODE_ADRESSE_RESIDENTIELLE, CODE_LIEU_DE_NAISSANCE) 
    VALUES ('SK1993-10-03-1','Sarah', 'Kim', TO_DATE('1993-10-03','YYYY-MM-DD'), '514-222-1111', 'sarahkim@gmail.com', '88200003', '88200003') 
    INTO CLIENT (CODE_CLIENT, PRENOM, NOM, DATE_DE_NAISSANCE, NUMERO_DE_TELEPHONE, COURRIEL, CODE_ADRESSE_RESIDENTIELLE, CODE_LIEU_DE_NAISSANCE) 
    VALUES ('LR1994-04-18-1','Luca', 'Rossi', TO_DATE('1994-04-18','YYYY-MM-DD'), '514-333-2222', 'lucarossi@hotmail.com', '155420081', '155420081')
SELECT * FROM DUAL;

-- Insertion des langues parlées
INSERT ALL
    INTO LANGUES_PARLEES 
    VALUES ('MT1982-04-15-1', 'français') 
    INTO LANGUES_PARLEES
    VALUES ('MT1982-04-15-1', 'anglais') 
    INTO LANGUES_PARLEES
    VALUES ('JG1983-07-12-1', 'français') 
    INTO LANGUES_PARLEES
    VALUES ('JG1983-07-12-1', 'espagnol') 
    INTO LANGUES_PARLEES
    VALUES ('LC1984-01-01-1', 'anglais') 
    INTO LANGUES_PARLEES
    VALUES ('LC1984-01-01-1', 'français') 
    INTO LANGUES_PARLEES
    VALUES ('YS1985-05-05-1', 'mandarin') 
    INTO LANGUES_PARLEES
    VALUES ('YS1985-05-05-1', 'anglais') 
    INTO LANGUES_PARLEES
    VALUES ('SM1990-12-25-1', 'japonais') 
    INTO LANGUES_PARLEES
    VALUES ('SM1990-12-25-1', 'anglais') 
    INTO LANGUES_PARLEES
    VALUES ('CS1988-08-18-1', 'français') 
    INTO LANGUES_PARLEES
    VALUES ('CS1988-08-18-1', 'créole haïtien') 
    INTO LANGUES_PARLEES
    VALUES ('AM1992-03-08-1', 'portugais') 
    INTO LANGUES_PARLEES
    VALUES ('AM1992-03-08-1', 'espagnol') 
    INTO LANGUES_PARLEES
    VALUES ('PL1987-11-11-1', 'allemand') 
    INTO LANGUES_PARLEES
    VALUES ('PL1987-11-11-1', 'français') 
    INTO LANGUES_PARLEES
    VALUES ('EB1995-06-30-1', 'français') 
    INTO LANGUES_PARLEES
    VALUES ('EB1995-06-30-1', 'anglais') 
    INTO LANGUES_PARLEES
    VALUES ('TW1991-09-14-1', 'français') 
    INTO LANGUES_PARLEES
    VALUES ('TW1991-09-14-1', 'espagnol') 
    INTO LANGUES_PARLEES
    VALUES ('MG1989-02-20-1', 'allemand') 
    INTO LANGUES_PARLEES
    VALUES ('MG1989-02-20-1', 'créole haïtien') 
    INTO LANGUES_PARLEES
    VALUES ('DJ1986-07-07-1', 'espagnol') 
    INTO LANGUES_PARLEES
    VALUES ('DJ1986-07-07-1', 'anglais') 
    INTO LANGUES_PARLEES
    VALUES ('SK1993-10-03-1', 'créole haïtien') 
    INTO LANGUES_PARLEES
    VALUES ('SK1993-10-03-1', 'espagnol') 
    INTO LANGUES_PARLEES
    VALUES ('LR1994-04-18-1', 'mandarin') 
    INTO LANGUES_PARLEES
    VALUES ('LR1994-04-18-1', 'anglais') 
    INTO LANGUES_PARLEES
    VALUES ('MG1989-02-20-1', 'italien') 
    INTO LANGUES_PARLEES
    VALUES ('MG1989-02-20-1', 'anglais')
SELECT * FROM DUAL;

-- 5.Display the data saved in the Table stucture  | Afficher les données insérer dans la structure des Tables 
SELECT * FROM LANGUES_PARLEES;
SELECT * FROM  CLIENT;
SELECT * FROM  LIEU;
SELECT * FROM  LANGUE;
