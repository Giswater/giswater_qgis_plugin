/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = am, public;
UPDATE config_engine_def AS t
SET label = v.label, descript = v.descript, placeholder = v.placeholder
FROM (
    VALUES
    ('rleak_1', 'WM', 'Actual breaks', NULL, NULL),
    ('strategic_1', 'WM', 'Strategic', NULL, NULL),
    ('rleak_2', 'WM', 'Actual breaks', NULL, NULL),
    ('strategic_2', 'WM', 'Strategic', NULL, NULL),
    ('mleak_1', 'WM', 'Probability of failure', NULL, NULL),
    ('mleak_2', 'WM', 'Probability of failure', NULL, NULL),
    ('compliance_1', 'WM', 'Regulatory', NULL, NULL),
    ('longevity_1', 'WM', 'Longevity', NULL, NULL),
    ('compliance_2', 'WM', 'Regulatory', NULL, NULL),
    ('longevity_2', 'WM', 'Longevity', NULL, NULL),
    ('strategic', 'SH', 'Strategic weight', 'Weight in final matrix by strategic factors', NULL),
    ('flow_1', 'WM', 'Circulating flow', NULL, NULL),
    ('flow_2', 'WM', 'Circulating flow', NULL, NULL),
    ('nrw_1', 'WM', 'ANC', NULL, NULL),
    ('nrw_2', 'WM', 'ANC', NULL, NULL),
    ('expected_year', 'SH', 'Expected year weight', 'Weight in final matrix by expected year', NULL),
    ('compliance', 'SH', 'Regulatory weight', 'Weight in final matrix by regulatory compliance', NULL),
    ('bratemain0', 'SH', 'Breakage rate coefficient', 'Growth rate of leaks in pipes', NULL),
    ('drate', 'SH', 'Discount rate (%)', 'Real price update rate (discount rate). Takes into account price increases by discounting inflation.', NULL)
) AS v(parameter, method, label, descript, placeholder)
WHERE t.parameter = v.parameter AND t.method = v.method;

UPDATE value_result_type AS t
SET idval = v.idval
FROM (
    VALUES
    ('GLOBAL', 'GLOBAL'),
    ('SELECTION', 'SELECTION')
) AS v(id, idval)
WHERE t.id = v.id;

UPDATE value_status AS t
SET idval = v.idval
FROM (
    VALUES
    ('FINISHED', 'FINISHED'),
    ('ON PLANNING', 'ON PLANNING'),
    ('CANCELED', 'CANCELED')
) AS v(id, idval)
WHERE t.id = v.id;

