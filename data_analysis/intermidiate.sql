--------------------------------------------------------------
--------------------------------------------------------------

--------------------- SQL JOINS ------------------------------

------ The most popular join is the left join ------

/*
╔══════════════╦═════════════════════════════╦════════════════════════════════════════════╗
║   Tipo JOIN  ║ Descripción                 ║ Ejemplo Visual                             ║
╠══════════════╬═════════════════════════════╬════════════════════════════════════════════╣
║ INNER JOIN   ║ Solo filas con coincidencias║ Tabla A ┌───┐  Tabla B → Resultado: ┌───┐  ║
║              ║ en AMBAS tablas              │ A │ B │       │ B │ C │            │A│B│C│ ║
║              ║                             └┬──┘  └┬─┘      └──┘              └─┘└┘ ║
╠══════════════╬═════════════════════════════╬════════════════════════════════════════════╣
║ LEFT JOIN    ║ Todas filas de tabla A +    ║ Tabla A ┌───┐  Tabla B → Resultado: ┌───┐ ║
║ (LEFT OUTER) ║ coincidencias en B (NULL si  │ A │ B │       │ B │ C │            │A│B│C│║
║              ║ no hay match)               └──┘  └┬─┘      └──┘              │A│B│NULL║
╠══════════════╬═════════════════════════════╬════════════════════════════════════════════╣
║ RIGHT JOIN   ║ Todas filas de tabla B +    ║ Similar a LEFT JOIN pero prioriza tabla B ║
║ (RIGHT OUTER)║ coincidencias en A (NULL si  ║                                        ║
║              ║ no hay match)               ║                                        ║
╠══════════════╬═════════════════════════════╬════════════════════════════════════════════╣
║ FULL JOIN    ║ Todas filas de AMBAS tablas ║ Combina LEFT + RIGHT JOIN. Muestra NULL   ║
║ (FULL OUTER) ║ (NULL donde no hay match)   ║ en columnas sin coincidencia              ║
╠══════════════╬═════════════════════════════╬════════════════════════════════════════════╣
║ CROSS JOIN   ║ Producto cartesiano: todas  ║ Tabla A (3 filas) x Tabla B (2 filas) = 6 ║
║              ║ combinaciones posibles      ║ filas en resultado                        ║
╚══════════════╩═════════════════════════════╩════════════════════════════════════════════╝
*/



SELECT
    j.job_id,
    j.job_title_short,
    j.company_id,
    c.name AS company_name  -- Alias más claro para la columna
FROM
    job_postings_fact AS j  -- Alias más corto
LEFT JOIN company_dim AS c  -- Alias más corto
    ON j.company_id = c.company_id
WHERE 
    c.company_id IS NOT NULL
ORDER BY 
    j.job_id;

------------------------------------------------------------------------
------------------------------------------------------------------------

SELECT
    j.job_id,
    j.job_title,
    sj.skill_id,
    s.skills
FROM
    job_postings_fact AS j
INNER JOIN  skills_job_dim AS sj
    ON j.job_id = sj.job_id
INNER JOIN skills_dim AS s
    ON sj.skill_id = s.skill_id;



