/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = am, public;
UPDATE config_engine_def AS t
SET label = v.label, descript = v.descript, placeholder = v.placeholder
FROM (
    VALUES
    ('rleak_2', 'WM', 'Actual breaks', NULL, NULL),
    ('flow_1', 'WM', 'Working capital', NULL, NULL),
    ('flow_2', 'WM', 'Working capital', NULL, NULL),
    ('nrw_1', 'WM', 'ANC', NULL, NULL),
    ('bratemain0', 'SH', 'Breakage rate coefficient', 'Pipe leak growth rate', NULL),
    ('nrw_2', 'WM', 'ANC', NULL, NULL),
    ('expected_year', 'SH', 'Expected annual weight', 'Weight in final matrix per year of renewal', NULL),
    ('compliance', 'SH', 'Regulatory weight', 'Weight in final matrix for regulatory compliance', NULL),
    ('drate', 'SH', 'Discount rate (%)', 'Real price discount rate. Takes into account price increases by discounting inflation.', NULL),
    ('strategic_1', 'WM', 'Strategice', NULL, NULL),
    ('strategic_2', 'WM', 'Strategice', NULL, NULL),
    ('longevity_1', 'WM', 'Longevitate', NULL, NULL),
    ('longevity_2', 'WM', 'Longevitate', NULL, NULL),
    ('compliance_1', 'WM', 'Reglementare', NULL, NULL),
    ('compliance_2', 'WM', 'Reglementare', NULL, NULL),
    ('strategic', 'SH', 'Pondere strategică', 'Ponderea în matricea finală pe factori strategici', NULL),
    ('mleak_1', 'WM', 'Probabilitatea de eșec', NULL, NULL),
    ('mleak_2', 'WM', 'Probabilitatea de eșec', NULL, NULL),
    ('rleak_1', 'WM', 'Pauze reale', NULL, NULL)
) AS v(parameter, method, label, descript, placeholder)
WHERE t.parameter = v.parameter AND t.method = v.method;

UPDATE value_result_type AS t
SET idval = v.idval
FROM (
    VALUES
    ('SELECTION', 'SELECȚIE'),
    ('GLOBAL', 'GLOBAL')
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

