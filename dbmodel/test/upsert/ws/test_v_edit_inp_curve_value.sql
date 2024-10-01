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

INSERT INTO v_edit_inp_curve_value (id, curve_id, x_value, y_value)
VALUES(-901, 'PUMP_02', 10.0000, 50.0000);
SELECT is((SELECT count(*)::integer FROM v_edit_inp_curve_value WHERE id = -901), 1, 'INSERT: v_edit_inp_curve_value -901 was inserted');
SELECT is((SELECT count(*)::integer FROM inp_curve_value WHERE id = -901), 1, 'INSERT: inp_curve_value -901 was inserted');

UPDATE v_edit_inp_curve_value SET x_value = -902 WHERE id = -901;
SELECT is((SELECT x_value::integer FROM v_edit_inp_curve_value WHERE id = -901), -902, 'UPDATE: v_edit_inp_curve_value -901 was updated');
SELECT is((SELECT x_value::integer FROM inp_curve_value WHERE id = -901), -902, 'UPDATE: inp_curve_value -901 was updated');

DELETE FROM v_edit_inp_curve_value WHERE id = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_inp_curve_value WHERE id = -901), 0, 'DELETE: v_edit_inp_curve_value -901 was deleted');
SELECT is((SELECT count(*)::integer FROM inp_curve_value WHERE id = -901), 0, 'DELETE: inp_curve_value -901 was deleted');


SELECT * FROM finish();


ROLLBACK;