/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(6);

INSERT INTO ve_plan_psector ( "name", descript, priority, text1, text2, observ, rotation, "scale", atlas_id, gexpenses, vat, other, the_geom, expl_id, psector_type, active, archived, ext_code, status, text3, text4, text5, text6, num_value, workcat_id, parent_id)
VALUES('-901', 'Expanding the capacity of the pipes located on Francesc Layret street.', '2', NULL, NULL, 'Action caused by the headloss of the pipe.', 0.0000, 750.00, '01', 19.00, 21.00, 0.00, 'SRID=25831;MULTIPOLYGON (((419209.60503196524 4576553.424854076, 419209.60503196524 4576503.357122214, 419089.7020131364 4576503.357122214, 419089.7020131364 4576553.424854076, 419209.60503196524 4576553.424854076)))'::public.geometry, 1, 1, true, false, NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT is((SELECT count(*)::integer FROM ve_plan_psector WHERE name = '-901'), 1, 'INSERT: ve_plan_psector -901 was inserted');
SELECT is((SELECT count(*)::integer FROM plan_psector WHERE name = '-901'), 1, 'INSERT: plan_psector -901 was inserted');


UPDATE ve_plan_psector SET descript = 'updated descript' WHERE name = '-901';
SELECT is((SELECT descript FROM ve_plan_psector WHERE name = '-901'), 'updated descript', 'UPDATE: ve_plan_psector -901 was updated');
SELECT is((SELECT descript FROM plan_psector WHERE name = '-901'), 'updated descript', 'UPDATE: plan_psector -901 was updated');


DELETE FROM ve_plan_psector WHERE name = '-901';
SELECT is((SELECT count(*)::integer FROM ve_plan_psector WHERE name = '-901'), 0, 'DELETE: ve_plan_psector -901 was deleted');
SELECT is((SELECT count(*)::integer FROM plan_psector WHERE name = '-901'), 0, 'DELETE: plan_psector -901 was deleted');


SELECT * FROM finish();

ROLLBACK;