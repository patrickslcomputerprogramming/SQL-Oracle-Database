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



--DECODE
--Not ASC or DESC but customized order Esp, Eng, Fra
SELECT DISTINCT (langue)
FROM cours
ORDER BY DECODE (langue,'Espanol',1,'English',2,3);

SELECT langue, titre, count(code_cours)
FROM cours
GROUP BY langue, titre;
