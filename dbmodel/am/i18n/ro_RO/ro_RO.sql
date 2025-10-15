/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = am, public;
UPDATE config_engine_def AS t
SET label = v.label, descript = v.descript, placeholder = v.placeholder
FROM (
    VALUES
    ('bratemain0', 'SH', 'Coeficientul ratei de rupere', 'Rata de creștere a scurgerilor din conducte', NULL),
    ('compliance', 'SH', 'Greutatea de reglementare', 'Pondere în matricea finală pentru conformitatea cu reglementările', NULL),
    ('compliance_1', 'WM', 'Reglementare', NULL, NULL),
    ('compliance_2', 'WM', 'Reglementare', NULL, NULL),
    ('drate', 'SH', 'Rata de actualizare (%)', 'Rata reală de actualizare a prețurilor. Ia în considerare creșterea prețurilor prin actualizarea inflației.', NULL),
    ('expected_year', 'SH', 'Greutatea anuală preconizată', 'Pondere în matricea finală pe an de reînnoire', NULL),
    ('flow_1', 'WM', 'Capital de lucru', NULL, NULL),
    ('flow_2', 'WM', 'Capital de lucru', NULL, NULL),
    ('longevity_1', 'WM', 'Longevitate', NULL, NULL),
    ('longevity_2', 'WM', 'Longevitate', NULL, NULL),
    ('mleak_1', 'WM', 'Probabilitatea de eșec', NULL, NULL),
    ('mleak_2', 'WM', 'Probabilitatea de eșec', NULL, NULL),
    ('nrw_1', 'WM', 'ANC', NULL, NULL),
    ('nrw_2', 'WM', 'ANC', NULL, NULL),
    ('rleak_1', 'WM', 'Pauze reale', NULL, NULL),
    ('rleak_2', 'WM', 'Pauze reale', NULL, NULL),
    ('strategic', 'SH', 'Pondere strategică', 'Ponderea în matricea finală pe factori strategici', NULL),
    ('strategic_1', 'WM', 'Strategice', NULL, NULL),
    ('strategic_2', 'WM', 'Strategice', NULL, NULL)
) AS v(parameter, method, label, descript, placeholder)
WHERE t.parameter = v.parameter AND t.method = v.method;

UPDATE value_result_type AS t
SET idval = v.idval
FROM (
    VALUES
    ('GLOBAL', 'GLOBAL'),
    ('SELECTION', 'SELECȚIE')
) AS v(id, idval)
WHERE t.id = v.id;

UPDATE value_status AS t
SET idval = v.idval
FROM (
    VALUES
    ('CANCELED', 'ANULAT'),
    ('FINISHED', 'TERMINAT'),
    ('ON PLANNING', 'PRIVIND PLANIFICAREA')
) AS v(id, idval)
WHERE t.id = v.id;

