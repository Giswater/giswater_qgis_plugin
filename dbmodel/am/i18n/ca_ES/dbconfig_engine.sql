/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = am, public;
UPDATE config_engine_def AS t SET label = v.label, descript = v.descript, placeholder = v.placeholder FROM (
	VALUES
	('bratemain0', 'SH', 'Coeficient de velocitat de trencament', 'Taxa de creixement de fuites de canonades', NULL),
    ('compliance', 'SH', 'Pes regulador', 'Pes a la matriu final per al compliment normatiu', NULL),
    ('compliance_1', 'WM', 'Regulatòria', NULL, NULL),
    ('compliance_2', 'WM', 'Regulatòria', NULL, NULL),
    ('drate', 'SH', 'Taxa de descompte (%)', 'Taxa de descompte de preu real.Té en compte els augments de preus descomptant la inflació.', NULL),
    ('expected_year', 'SH', 'Pes anual previst', 'Pes en matriu final per any de renovació', NULL),
    ('flow_1', 'WM', 'Capital circulant', NULL, NULL),
    ('flow_2', 'WM', 'Capital circulant', NULL, NULL),
    ('longevity_1', 'WM', 'Longevitat', NULL, NULL),
    ('longevity_2', 'WM', 'Longevitat', NULL, NULL),
    ('mleak_1', 'WM', 'Probabilitat de fracàs', NULL, NULL),
    ('mleak_2', 'WM', 'Probabilitat de fracàs', NULL, NULL),
    ('nrw_1', 'WM', 'ANC', NULL, NULL),
    ('nrw_2', 'WM', 'ANC', NULL, NULL),
    ('rleak_1', 'WM', 'Pauses reals', NULL, NULL),
    ('rleak_2', 'WM', 'Pauses reals', NULL, NULL),
    ('strategic', 'SH', 'Pes estratègic', 'Pes en la matriu final per factors estratègics', NULL),
    ('strategic_1', 'WM', 'Estratègic', NULL, NULL),
    ('strategic_2', 'WM', 'Estratègic', NULL, NULL)
) AS v(parameter, method, label, descript, placeholder)
WHERE t.parameter = v.parameter AND t.method = v.method;

