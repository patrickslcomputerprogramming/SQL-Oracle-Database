/*1.	Quels sont tous les cours (id_cours_offert, code_cours, id_semestre) 
enseignés à tous les semestres ?*/
SELECT id_cours_offert, code_cours, id_semestre
FROM cours_semestre;

/* 2.	Quels sont tous les étudiants (id_etudiant, prénom, nom, date_naissance)
qui ont au moins 25 ans ?*/
SELECT id_etudiant, prenom, nom, date_naissance
FROM etudiant
WHERE (TO_CHAR(sysdate,'YYYY') - TO_CHAR(date_naissance,'YYYY')) >= 25;

--OU

SELECT id_etudiant, prenom, nom, date_naissance
FROM etudiant
WHERE (EXTRACT(YEAR FROM sysdate) - EXTRACT(YEAR FROM date_naissance)) >= 25;

--OU

SELECT id_etudiant, prenom, nom, date_naissance
FROM etudiant
WHERE MONTHS_BETWEEN(SYSDATE,date_naissance)>= 25*12;

/*3.	Suivant les données stockées dans la table Cours, quels sont les différentes 
langues (langue) enseignées et affichez les en ordre alphabétique décroissant Z-A ?
*/
SELECT DISTINCT (langue)
FROM cours
ORDER BY langue DESC;


/*4.	Quels sont tous les étudiants (id_etudiant, prénom, nom)
avec leur prénom et leur nom  affiches en ordre alphabétique croissant A-Z. 8 */
SELECT id_etudiant, prenom, nom
FROM etudiant
ORDER BY prenom ASC, nom ASC;


/*5.	Quels sont tous les semestres (Saison et Année) 
et ordonnez les en ordre décroissante (plus récent au plus ancien) 
suivant la date de début.*/
SELECT saison, annee
FROM semestre
ORDER BY date_debut DESC;


/*6.	Quels sont les étudiants (ID, Prénom et Nom, Civilité) 
qui ont la civilité Monsieur et Madame ? */
SELECT id_etudiant, prenom, nom, civilite
FROM  etudiant
WHERE civilite = 'Monsieur' OR civilite = 'Madame';

--OU

SELECT id_etudiant, prenom, nom, civilite
FROM  etudiant
WHERE civilite IN ('Monsieur', 'Madame');


/*7. Quels sont les étudiants (ID, Prénom et Nom, Civilité) 
qui n’ont encore aucune information stockée pour la civilité ?  */
SELECT id_etudiant, prenom, nom, civilite
FROM  etudiant
WHERE civilite IS NULL;


/* 8.	Quels sont les étudiants (id_etudiant, date_inscription) 
qui ont été inscrits entre 1e janvier 2023 et le 31 décembre 2023 ? (BETWEEN)*/
SELECT id_etudiant,date_inscription
FROM inscription
WHERE date_inscription BETWEEN 
    to_date('01-01-2023','DD-MM-YYYY') AND to_date('31-12-2023','DD-MM-YYYY');

--OU

SELECT id_etudiant,date_inscription
FROM inscription
WHERE TO_CHAR(date_inscription, 'YYYY') = 2023;

--OU

SELECT id_etudiant,date_inscription
FROM inscription
WHERE date_inscription >= to_date('01-01-2023','DD-MM-YYYY') 
    AND date_inscription <= to_date('31-12-2023','DD-MM-YYYY');


/*9.	Quels sont tous les enseignants (id_instructeur, prenom, nom) dont le prénom 
ne commence pas la lettre J ? */
SELECT id_instructeur, prenom, nom
FROM instructeur
WHERE prenom NOT LIKE 'J%';

/*10.	Quels sont tous les enseignants (id_instructeur, prenom, nom) dont le prénom 
et le nom contiennent chacun 3 lettres ? */
SELECT id_instructeur, prenom, nom
FROM instructeur
WHERE prenom LIKE '___' AND nom LIKE '___' ;


/*14 Combien d’étudiants ont annulé leur inscription (statut = ‘Désinscrit’) en 2023 ? 
Affichez le texte suivant comme titre de la colonne (DESCRIPTION) qui affiche le résultat : « Nombre Etudiants Désinscrits en 2023 »*/

SELECT 'Nombre Etudiants Désinscrits en 2023' AS DESCRIPTION, 
COUNT (id_etudiant)  
FROM inscription
WHERE statut = 'Désinscrit'
AND id_cours_offert LIKE '%23%';




--lab 2

--1
SELECT e.id_etudiant, e.prenom, e.nom, i.id_cours_offert, 
TO_CHAR(i.date_inscription,'MONTH,DD YYYY') 
FROM etudiant e, inscription i
WHERE e.id_etudiant = i.id_etudiant
AND i.id_cours_offert LIKE '___-E22%'
AND i.statut = 'Inscrit-Actif'
ORDER BY prenom,nom ASC;

--2
SELECT * 
FROM cours_semestre cs
LEFT JOIN inscription i
ON cs.id_cours_offert = i.id_cours_offert
WHERE i.id_cours_offert IS NULL;


SELECT * 
FROM cours_semestre
WHERE id_cours_offert NOT IN (
    SELECT DISTINCT(id_cours_offert)
    FROM inscription) ;

--3
SELECT i.id_instructeur, i.prenom, i.nom, a.id_cours_offert 
FROM instructeur i
INNER JOIN affectation a
ON i.id_instructeur = a.id_instructeur
WHERE i.id_instructeur = 'JANEROE20001010DF';


--4
SELECT id_cours_offert, 
COUNT (id_cours_offert) AS "nombre d’étudiant inscrits"
FROM inscription
WHERE statut != 'Désinscrit'
GROUP BY id_cours_offert
ORDER BY COUNT(id_cours_offert) DESC;

--
SELECT id_instructeur, 
COUNT (id_cours_offert) AS "nombre de cours enseignés"
FROM affectation
GROUP BY id_instructeur
ORDER BY COUNT(id_cours_offert) ASC;

--5
SELECT a.id_instructeur,i.prenom, i.nom, 
COUNT (a.id_cours_offert) AS "nombre de cours enseignés"
FROM affectation a, instructeur i
WHERE i.id_instructeur = a.id_instructeur
GROUP BY a.id_instructeur, i.prenom, i.nom
ORDER BY COUNT(a.id_cours_offert) ASC;


--6
SELECT langue, 
COUNT(code_cours) AS "Nombre de Cours", 
AVG (duree) AS "Durée Moyenne des Cours",
SUM (duree) AS "Durée Totale des Cours"
FROM COURS
GROUP BY langue
ORDER BY SUM (duree) ASC;

--7
SELECT i.id_etudiant, e.prenom, e.nom, COUNT(i.id_cours_offert)
FROM etudiant e, inscription i
WHERE e.id_etudiant = i.id_etudiant
AND i.statut != 'Désinscrit'
GROUP BY  i.id_etudiant,e.prenom, e.nom
ORDER BY COUNT(id_cours_offert) DESC;

--
SELECT i.id_etudiant, e.prenom, e.nom 
FROM etudiant e, inscription i
WHERE e.id_etudiant = i.id_etudiant
AND i.statut != 'Désinscrit'
GROUP BY  i.id_etudiant,e.prenom, e.nom
HAVING MAX(COUNT(i.id_cours_offert));

--8
SELECT MAX(COUNT(id_cours_offert)) 
FROM inscription
WHERE statut != 'Désinscrit'
GROUP BY  id_etudiant;

--
SELECT i.id_etudiant  
FROM inscription i
WHERE i.statut != 'Désinscrit'
GROUP BY  i.id_etudiant
HAVING COUNT(i.id_cours_offert) = MAX(COUNT(i.id_cours_offert));

--9
SELECT i.id_etudiant, e.prenom, e.nom, 
COUNT(i.id_cours_offert) AS "Nombre de cours suivi"
FROM etudiant e, inscription i
WHERE e.id_etudiant = i.id_etudiant
AND i.statut != 'Désinscrit'
GROUP BY  i.id_etudiant,e.prenom, e.nom
HAVING COUNT(i.id_cours_offert)=(SELECT MAX(COUNT(id_cours_offert)) 
    FROM inscription 
    WHERE statut != 'Désinscrit'
    GROUP BY  id_etudiant);

--Ou

SELECT id_etudiant, prenom, nom,
COUNT(id_cours_offert) AS "Nombre de cours suivi"
FROM (
    SELECT e.id_etudiant, e.prenom, e.nom, i.id_cours_offert
    FROM etudiant e
    INNER JOIN inscription i
    ON e.id_etudiant = i.id_etudiant
    WHERE i.statut != 'Désinscrit')
GROUP BY  id_etudiant, prenom, nom
HAVING COUNT(id_cours_offert)=(SELECT MAX(COUNT(id_cours_offert)) 
    FROM inscription
    WHERE statut != 'Désinscrit'
    GROUP BY  id_etudiant);

------------------------------------------------
------------------------------------------------

--1
--DECODE
--Quel est le nombre de code cours par langue?
--Ordonnez suivant un ordre personnalisé, ainsi: Espanol, English, Francais 
--Utilisation de DECODE
SELECT langue, 
COUNT (code_cours) AS "Nombre de code cours",
AVG (duree) AS "Durée moyenne des cours",
SUM (duree) AS "Durée totale des cours"
FROM cours
GROUP BY langue
ORDER BY DECODE (langue,'Espanol',1,'English',2,3);


--2
--DECODE Expressions
SELECT id_etudiant, prenom, nom,
DECODE (civilite, 
        'Madame', 'NON',
        'Monsieur', 'NON',
        'OUI') AS "civilité manquante"
FROM etudiant
ORDER BY "civilité manquante" DESC;

--3
--CASE Expressions
SELECT id_etudiant, prenom, nom,
CASE civilite 
    WHEN 'Madame' THEN 'NON'
    WHEN 'Monsieur' THEN 'NON'
    ELSE 'OUI'
END AS "civilite manquante"
FROM etudiant
ORDER BY "civilite manquante" DESC;


--4
--Utilise GROUP BY ROLLUP sans afficher TOTAL
SELECT s.saison, s.annee, i.statut, COUNT (i.id_etudiant) AS "Nombre étudiant inscrits"
FROM inscription i, cours_semestre cs, semestre s 
WHERE cs.id_semestre =  s.id_semestre AND i.id_cours_offert = cs.id_cours_offert 
GROUP BY  ROLLUP (s.saison, s.annee, statut)
ORDER BY s.saison; 

--5
--Utilise GROUP BY CUBE sans afficher TOTAL
SELECT s.saison, s.annee, i.statut, COUNT (i.id_etudiant) AS "Nombre étudiant inscrits"
FROM inscription i, cours_semestre cs, semestre s 
WHERE cs.id_semestre =  s.id_semestre AND i.id_cours_offert = cs.id_cours_offert 
GROUP BY  ROLLUP (s.saison, s.annee, statut)
ORDER BY s.saison; 


--6
--Utilise GROUPING, GROUP BY ROLLUP pour afficher TOTAL dans la colonne STATUT
--GROUPING returns 1 for aggregated or 0 for not aggregated in the result set
SELECT s.saison, s.annee, 
CASE GROUPING (i.statut)
    WHEN 1 THEN '-> TOTAL'
    ELSE i.statut
END AS statut,
COUNT (i.id_etudiant) AS "Nombre étudiant inscrits"
FROM inscription i, cours_semestre cs, semestre s 
WHERE cs.id_semestre =  s.id_semestre AND i.id_cours_offert = cs.id_cours_offert 
GROUP BY  ROLLUP (s.saison, s.annee, statut)
ORDER BY s.saison;

--Utilise GROUPING, DECODE, GROUP BY ROLLUP pour afficher TOTAL dans les colonnes SAISON, ANNEE, STATUT
SELECT 
CASE GROUPING (s.saison)
    WHEN 1 THEN '-> TOTAL'
    ELSE s.saison
END AS saison, 
DECODE (s.annee, 
    null, '-> TOTAL',
    s.annee)
    annee, 
CASE GROUPING (i.statut)
    WHEN 1 THEN '-> TOTAL'
    ELSE i.statut
END AS statut,
COUNT (i.id_etudiant) AS "Nombre étudiant inscrits"
FROM inscription i, cours_semestre cs, semestre s 
WHERE cs.id_semestre =  s.id_semestre AND i.id_cours_offert = cs.id_cours_offert 
GROUP BY  ROLLUP (s.saison, s.annee, statut)
ORDER BY s.saison;

--7
--Utilise GROUPING, GROUP BY ROLLUP pour afficher TOTAL dans la colonne STATUT
--GROUPING returns 1 for aggregated or 0 for not aggregated in the result set
SELECT s.saison, s.annee, 
CASE GROUPING (i.statut)
    WHEN 1 THEN '-> TOTAL'
    ELSE i.statut
END AS statut,
COUNT (i.id_etudiant) AS "Nombre étudiant inscrits"
FROM inscription i, cours_semestre cs, semestre s 
WHERE cs.id_semestre =  s.id_semestre AND i.id_cours_offert = cs.id_cours_offert 
GROUP BY  CUBE (s.saison, s.annee, statut)
ORDER BY s.saison;

--Utilise GROUPING, DECODE, GROUP BY ROLLUP pour afficher TOTAL dans les colonnes SAISON, ANNEE, STATUT
SELECT 
CASE GROUPING (s.saison)
    WHEN 1 THEN '-> TOTAL'
    ELSE s.saison
END AS saison, 
DECODE (s.annee, 
    null, '-> TOTAL',
    s.annee)
    annee, 
CASE GROUPING (i.statut)
    WHEN 1 THEN '-> TOTAL'
    ELSE i.statut
END AS statut,
COUNT (i.id_etudiant) AS "Nombre étudiant inscrits"
FROM inscription i, cours_semestre cs, semestre s 
WHERE cs.id_semestre =  s.id_semestre AND i.id_cours_offert = cs.id_cours_offert 
GROUP BY  CUBE (s.saison, s.annee, statut)
ORDER BY s.saison;

--8
--Creer la fonction definie par l'utilisateur
--Qui recoit la date de naissance d'une personne (ex. etudiant, instructeur)
--Qui calcule et retourne son age 
CREATE OR REPLACE FUNCTION calcule_age (date_naissance_recu IN DATE)
RETURN NUMBER
IS
 age NUMBER(5,2) := 0;
BEGIN
    age := MONTHS_BETWEEN(SYSDATE,date_naissance_recu) / 12;
    RETURN (age);
END;
/

--Appeler la fonction definie par l'utilisateur
SELECT calcule_age(date_naissance) AS "AGE", 
prenom, nom, id_etudiant
FROM etudiant
ORDER BY AGE ASC;

--Appeler la fonction definie par l'utilisateur
SELECT calcule_age(date_naissance) AS "AGE", 
prenom, nom, id_instructeur
FROM instructeur
ORDER BY AGE ASC;

--9
--Creer la fonction definie par l'utilisateur
--Qui recoit le code d'un etudiant (id_etudiant)
--Qui calcule et retourne le nombre de cours suivis par un etudiant
CREATE OR REPLACE FUNCTION nombre_cours_suivis(id_this_etudiant IN VARCHAR2)
RETURN NUMBER
IS
 quantite NUMBER(3) := 0;
BEGIN
    SELECT COUNT(id_cours_offert) AS "Nombre de cours suivi"
    INTO quantite
    FROM inscription
    WHERE statut != 'Désinscrit' AND id_etudiant = id_this_etudiant
    GROUP BY id_etudiant
    ORDER BY COUNT(id_cours_offert) DESC;
    RETURN (quantite);
END;
/

--Appeler la fonction definie par l'utilisateur
SELECT nombre_cours_suivis(id_etudiant) AS "Nombre de Cours Suivis", 
prenom, nom, id_etudiant
FROM etudiant;


