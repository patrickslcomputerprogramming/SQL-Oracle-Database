--1
select TABLE_NAME AS "NOM TABLE", 
NUM_ROWS AS "NOMBRE LIGNES"
from USER_TABLES
order by NUM_ROWS desc;


--2
select CONSTRAINT_NAME AS "NOM CONTRAINTE", 
COLUMN_NAME AS "NOM COLONNE", 
TABLE_NAME AS "NOM TABLE"
from USER_CONS_COLUMNS
where TABLE_NAME in (
    select TABLE_NAME
    from USER_TABLES
)
order by TABLE_NAME asc, COLUMN_NAME asc;


--3
select TABLE_NAME AS "NOM TABLE", 
COMMENTS AS "COMMENTAIRES"
from USER_TAB_COMMENTS
where TABLE_NAME in (
    select TABLE_NAME
    from USER_TABLES
)
order by TABLE_NAME asc;


--4
select ID_ETUDIANT, PRENOM, NOM, 
TO_CHAR(DATE_NAISSANCE,'DD MONTH YYYY') AS "DATE NAISSANCE"
from ETUDIANT
where DATE_NAISSANCE = (
    select max(DATE_NAISSANCE)
    from ETUDIANT
)
order by DATE_NAISSANCE desc;


--5
select CODE_COURS, LANGUE, 
DUREE AS "ANCIENNE DUREE", 
(DUREE + DUREE/2) AS "NOUVELLE DUREE"
from COURS
order by LANGUE desc ;


--6
select ID_ETUDIANT, PRENOM, NOM 
from ETUDIANT
where (PRENOM LIKE '%e%e%' AND PRENOM NOT LIKE '%ee%')
OR (NOM LIKE '%e%e%' AND NOM NOT LIKE '%ee%')
order by PRENOM asc, NOM asc;


--7
SELECT i.id_etudiant, e.prenom, e.nom,
COUNT (i.id_cours_offert) AS "NOMBRE COURS SUIVIS", 
SUM(c.duree) AS "SOMME TOTALE DUREE COURS SUIVIS"
FROM inscription i, cours_semestre cs, cours c, etudiant e
WHERE i.id_cours_offert = cs.id_cours_offert AND
cs.code_cours = c.code_cours AND
e.id_etudiant = i.id_etudiant AND
i.statut != 'Désinscrit'
GROUP BY  i.id_etudiant, e.prenom, e.nom
ORDER BY SUM(c.duree) DESC;


--8
SELECT e.id_etudiant, e.prenom, e.nom,
COUNT (i.id_cours_offert) AS "NOMBRE COURS SUIVIS"
FROM etudiant e
LEFT JOIN inscription i
ON e.id_etudiant = i.id_etudiant 
GROUP BY  e.id_etudiant, e.prenom, e.nom
HAVING COUNT (i.id_cours_offert) = 0
ORDER BY prenom ASC, nom ASC;


--9
SELECT s.id_semestre, i.statut,
COUNT (i.id_cours_offert) AS "NOMBRE ETUDIANTS INSCRITS"
FROM inscription i, semestre s, cours_semestre cs
WHERE i.id_cours_offert =  cs.id_cours_offert AND
cs.id_semestre = s.id_semestre  
GROUP BY i.statut, s.id_semestre
ORDER BY COUNT (i.id_cours_offert) DESC;


--10
SELECT a.id_instructeur, i.prenom, i.nom,
COUNT(a.id_cours_offert) AS "NOMBRE COURS ENSEIGNES"
FROM affectation a, instructeur i
WHERE a.id_instructeur = i.id_instructeur
GROUP BY a.id_instructeur, i.prenom, i.nom
HAVING COUNT(a.id_cours_offert) = (
SELECT MAX(COUNT(id_cours_offert))
FROM affectation
GROUP BY id_instructeur
)
ORDER BY prenom ASC, nom ASC;
