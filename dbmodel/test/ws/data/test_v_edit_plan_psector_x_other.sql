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

INSERT INTO v_edit_plan_psector_x_other (measurement, price_id, psector_id)
VALUES( -901, 'S_EXC', 1);
SELECT is((SELECT count(*)::integer FROM v_edit_plan_psector_x_other WHERE measurement = -901), 1, 'INSERT: v_edit_plan_psector_x_other -901 was inserted');
SELECT is((SELECT count(*)::integer FROM plan_psector_x_other WHERE measurement = -901), 1, 'INSERT: plan_psector_x_connec -901 was inserted');


UPDATE v_edit_plan_psector_x_other SET observ = 'updated observ' WHERE measurement = -901;
SELECT is((SELECT observ FROM v_edit_plan_psector_x_other WHERE measurement = -901), 'updated observ', 'UPDATE: v_edit_plan_psector_x_other -901 was updated');
SELECT is((SELECT observ FROM plan_psector_x_other WHERE measurement = -901), 'updated observ', 'UPDATE: plan_psector_x_connec -901 was updated');


DELETE FROM v_edit_plan_psector_x_other WHERE measurement = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_plan_psector_x_other WHERE measurement = -901), 0, 'DELETE: v_edit_plan_psector_x_other -901 was deleted');
SELECT is((SELECT count(*)::integer FROM plan_psector_x_other WHERE measurement = -901), 0, 'DELETE: plan_psector_x_connec -901 was deleted');


SELECT * FROM finish();

ROLLBACK;