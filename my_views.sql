-- Affiche tous les travailleurs présents dans toutes les usines avec leur date d'arrivée
CREATE OR REPLACE  VIEW ALL_WORKERS AS
SELECT
    w.first_name AS firstname,
    w.last_name AS lastname,
    w.age,
    w.first_day AS start_date
FROM
    WORKERS_FACTORY_1 w
WHERE
    w.last_day IS NULL 
UNION
SELECT
    w2.first_name AS firstname,
    w2.last_name AS lastname,
    NULL AS age, 
    w2.start_date
FROM
    WORKERS_FACTORY_2 w2
WHERE
    w2.end_date IS NULL;



-- Affiche le nombre de jours écoulés depuis l'arrivée de chaque employé
CREATE OR REPLACE VIEW ALL_WORKERS_ELAPSED AS
SELECT
    aw.*,
    CASE
        WHEN aw.start_date IS NOT NULL THEN
            TRUNC(SYSDATE) - TRUNC(aw.start_date)
        ELSE
            NULL
    END AS days_elapsed
FROM
    ALL_WORKERS aw;



-- Affiche les meilleurs fournisseurs (livré plus de 1000 pièces)
CREATE OR REPLACE VIEW BEST_SUPPLIERS AS
SELECT 
    s.name AS supplier_name, 
    COUNT(sb.spare_part_id) AS total_parts_delivered
FROM 
    SUPPLIERS_BRING_TO_FACTORY_1 sb
JOIN 
    SUPPLIERS s ON sb.supplier_id = s.supplier_id
GROUP BY 
    s.name
HAVING 
    COUNT(sb.spare_part_id) > 1000
UNION ALL
SELECT 
    s.name AS supplier_name, 
    COUNT(sb2.spare_part_id) AS total_parts_delivered
FROM 
    SUPPLIERS_BRING_TO_FACTORY_2 sb2
JOIN 
    SUPPLIERS s ON sb2.supplier_id = s.supplier_id
GROUP BY 
    s.name
HAVING 
    COUNT(sb2.spare_part_id) > 1000
ORDER BY 
    total_parts_delivered DESC;


-- Usine ayant assemblé chaque robot
CREATE OR REPLACE VIEW ROBOTS_FACTORIES AS
SELECT 
    r.id AS robot_id,
    r.model AS robot_model,
    rf.factory_id AS factory_id
FROM 
    ROBOTS_FROM_FACTORY rf
JOIN 
    ROBOTS r ON rf.robot_id = r.id;
