--1
/*
Quels sont tous les semestres ? 
Affichez les 4 informations suivantes dans l’ordre indiqué : 
saison, année, date de fin et date de début.
*/

SELECT saison, annee, 
date_fin AS "date de fin", 
date_debut AS "date de début"
FROM semestre;


--2
/*
Quels sont tous les instructeurs ? 
Affichez les 3 informations suivantes dans l’ordre indiqué : 
prénom, nom et id instructeur, 
en les ordonnant de A à Z suivant le prénom des instructeurs, puis leur nom. 
*/

SELECT prenom, nom, id_instructeur
FROM instructeur
ORDER BY prenom ASC, nom ASC;

--3
/*
Quels sont tous les instructeurs qui ont plus de 30 ans ? 
Affichez les 4 informations suivantes dans l’ordre indiqué : 
id_instructeur, prénom, nom et date_naissance, 
en les ordonnant de la date de naissance la plus lointaine à la plus proche. 
*/

SELECT id_instructeur, prenom, nom, date_naissance
FROM instructeur
WHERE TO_CHAR (sysdate, 'YYYY') - TO_CHAR (date_naissance, 'YYYY') > 30
ORDER BY date_naissance ASC;

--OU

SELECT id_instructeur, prenom, nom, date_naissance
FROM instructeur
WHERE EXTRACT (YEAR FROM sysdate) - EXTRACT (YEAR FROM date_naissance) > 30
ORDER BY date_naissance ASC;





--4
/*
Quels sont tous les étudiants et tous les instructeurs 
qui ont un code postal qui commence par les caractères suivants : H1 ? 
Affichez les 4 informations suivantes dans l’ordre indiqué : 
id_etudiant AS ID (ou id_instructeur AS ID), prénom, nom et code postal.
*/

SELECT id_etudiant AS ID, prenom, nom, code_postal
FROM etudiant
WHERE code_postal LIKE 'H1%'
UNION
SELECT id_instructeur AS ID, prenom, nom, code_postal
FROM instructeur
WHERE code_postal LIKE 'H1%';



--5
/*
Quels sont tous les cours qui enseignent la langue anglaise ? 
Affichez les 3 informations suivantes dans l’ordre indiqué : 
code cours, titre et description.
*/

SELECT code_cours, titre , description 
FROM cours
WHERE langue = 'English';



--6
/*
Quels sont tous les pairs d’instructeurs et étudiants qui habitant à la même adresse ? 
Affichez les 4 informations suivantes dans l’ordre indiqué : 
adresse, code postal, ID instructeur et ID étudiant.  
*/

SELECT i.adresse, i.code_postal, i.id_instructeur, e.id_etudiant
FROM etudiant e, instructeur i
WHERE i.adresse = e.adresse AND i.code_postal = e.code_postal;

--OU

SELECT i.adresse, i.code_postal, i.id_instructeur, e.id_etudiant
FROM etudiant e
INNER JOIN instructeur i
ON i.adresse = e.adresse AND i.code_postal = e.code_postal;


--7
/*
Quel est le nombre d’étudiants inscrits à chacun des semestres ? 
Affichez les 3 informations suivantes dans l’ordre indiqué : 
saison, annee, "Nombre étudiant inscrits".   
*/

SELECT s.saison, s.annee, COUNT (i.id_etudiant) AS "Nombre étudiant inscrits"
FROM inscription i, cours_semestre cs, semestre s 
WHERE cs.id_semestre =  s.id_semestre AND i.id_cours_offert = cs.id_cours_offert 
GROUP BY  s.saison, s.annee;


--8
/*
Quels sont tous les étudiants inscrits au semestre Hiver 2022 
et qui ont un statut Inscrit-Inactif ? 
Affichez les 4 informations suivantes dans l’ordre indiqué : 
id étudiant, prénom, nom, id cours offert et statut. 
*/

SELECT e.id_etudiant, e.prenom, e.nom, i.id_cours_offert, i.statut
FROM etudiant e, inscription i 
WHERE e.id_etudiant = i.id_etudiant AND
i.id_cours_offert LIKE '%H22%' AND 
i.statut = 'Inscrit-Inactif';

--OU

SELECT e.id_etudiant, e.prenom, e.nom, i.id_cours_offert, i.statut
FROM etudiant e
INNER JOIN inscription i 
ON e.id_etudiant = i.id_etudiant 
WHERE i.id_cours_offert LIKE '%H22%' AND 
i.statut = 'Inscrit-Inactif';



--9
/*
À combien d’étudiants a enseigné chacun des instructeurs ? 
Affichez les 4 informations suivantes dans l’ordre indiqué : 
id instructeur, prénom, nom, id cours offert, et "Nombre d’étudiants inscrits ".
*/

SELECT a.id_instructeur, t.prenom, t.nom, i.id_cours_offert, 
COUNT(i.id_etudiant)
FROM inscription i, affectation a, instructeur t
WHERE i.id_cours_offert = a.id_cours_offert AND
a.id_instructeur = t.id_instructeur
GROUP BY i.id_cours_offert, a.id_instructeur, t.prenom, t.nom;


--10
/*
Quel est l’étudiant qui a suivi le plus petit nombre de cours, 
considérant qu’un cours suivi ne doit pas avoir le statut « Désinscrit » 
dans la table inscription ?Affichez les 4 informations suivantes dans l’ordre indiqué : 
id étudiant, prénom, nom, et "Nombre de cours suivis".
*/

SELECT i.id_etudiant, e.prenom, e.nom, 
COUNT(i.id_cours_offert) AS "Nombre de cours suivi"
FROM etudiant e, inscription i
WHERE e.id_etudiant = i.id_etudiant
AND i.statut != 'Désinscrit'
GROUP BY  i.id_etudiant,e.prenom, e.nom
HAVING COUNT(i.id_cours_offert)=(SELECT MIN(COUNT(id_cours_offert)) 
    FROM inscription 
    WHERE statut != 'Désinscrit'
    GROUP BY  id_etudiant);

--OU

SELECT id_etudiant, prenom, nom,
COUNT(id_cours_offert) AS "Nombre de cours suivi"
FROM (
    SELECT e.id_etudiant, e.prenom, e.nom, i.id_cours_offert
    FROM etudiant e
    INNER JOIN inscription i
    ON e.id_etudiant = i.id_etudiant
    WHERE i.statut != 'Désinscrit')
GROUP BY  id_etudiant, prenom, nom
HAVING COUNT(id_cours_offert)=(SELECT MIN(COUNT(id_cours_offert)) 
    FROM inscription
    WHERE statut != 'Désinscrit'
    GROUP BY  id_etudiant);

--Fonctionne uniquement si on a 1 seule ligne
SELECT i.id_etudiant, e.prenom, e.nom, 
COUNT(i.id_cours_offert) AS "Nombre de cours suivi"
FROM etudiant e 
LEFT JOIN inscription i
ON e.id_etudiant = i.id_etudiant
LEFT JOIN cours_semestre cs
ON i.id_cours_offert = cs.id_cours_offert
LEFT JOIN semestre s
ON cs.id_semestre = s.id_semestre
WHERE i.statut != 'Désinscrit'
GROUP BY  i.id_etudiant,e.prenom, e.nom
ORDER BY COUNT(i.id_cours_offert) ASC
FETCH FIRST 1 ROW ONLY;

HAVING COUNT(i.id_cours_offert)=(SELECT MIN(COUNT(id_cours_offert)) 
    FROM inscription 
    WHERE statut != 'Désinscrit'
    GROUP BY  id_etudiant);
