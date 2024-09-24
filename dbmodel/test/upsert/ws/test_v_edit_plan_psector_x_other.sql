/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(6);

INSERT INTO v_edit_plan_psector_x_other (id, psector_id, price_id, unit, price_descript, price, measurement, total_budget, observ, atlas_id, the_geom) 
VALUES(-901, 1, 'S_EXC', '', '', 0, 0, 0, '', '', null);
SELECT is((SELECT count(*)::integer FROM v_edit_plan_psector_x_other WHERE plan_psector_x_other_id = -901), 1, 'INSERT: v_edit_plan_psector_x_other -901 was inserted');
SELECT is((SELECT count(*)::integer FROM plan_psector_x_other WHERE plan_psector_x_other_id = -901), 1, 'INSERT: plan_psector_x_connec -901 was inserted');


UPDATE v_edit_plan_psector_x_other SET unit = 'updated unit' WHERE plan_psector_x_other_id = -901;
SELECT is((SELECT unit FROM v_edit_plan_psector_x_other WHERE plan_psector_x_other_id = -901), 'updated unit', 'UPDATE: v_edit_plan_psector_x_other -901 was updated');
SELECT is((SELECT unit FROM plan_psector_x_connec WHERE plan_psector_x_other_id = -901), 'updated unit', 'UPDATE: plan_psector_x_connec -901 was updated');


DELETE FROM v_edit_plan_psector_x_other WHERE plan_psector_x_other_id = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_plan_psector_x_other WHERE plan_psector_x_other_id = -901), 0, 'DELETE: v_edit_plan_psector_x_other -901 was deleted');
SELECT is((SELECT count(*)::integer FROM plan_psector_x_connec WHERE plan_psector_x_other_id = -901), 0, 'DELETE: plan_psector_x_connec -901 was deleted');


SELECT * FROM finish();

ROLLBACK;