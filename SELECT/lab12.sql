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
