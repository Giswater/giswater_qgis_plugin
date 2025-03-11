/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(6);


INSERT INTO cat_dscenario ( "name", descript, parent_id, dscenario_type, active, expl_id, log) 
VALUES('-901', '', null, null, true, 0, '');

INSERT INTO v_edit_inp_dscenario_controls (dscenario_id, sector_id, "text", active)
VALUES( (select dscenario_id from cat_dscenario where name = '-901'), 0, '-901', false);


SELECT is((SELECT count(*)::integer FROM v_edit_inp_dscenario_controls WHERE "text" = '-901'), 1, 'INSERT: v_edit_inp_dscenario_controls -901 was inserted');
SELECT is((SELECT count(*)::integer FROM inp_dscenario_controls WHERE "text" = '-901'), 1, 'INSERT: inp_dscenario_controls -901 was inserted');

UPDATE v_edit_inp_dscenario_controls SET active = true WHERE "text" = '-901';
SELECT is((SELECT active FROM v_edit_inp_dscenario_controls WHERE "text" = '-901'), true, 'UPDATE: v_edit_inp_dscenario_controls -901 was updated');
SELECT is((SELECT active FROM inp_dscenario_controls WHERE "text" = '-901'), true, 'UPDATE: inp_dscenario_controls -901 was updated');

DELETE FROM v_edit_inp_dscenario_controls WHERE "text" = '-901';
SELECT is((SELECT count(*)::integer FROM v_edit_inp_dscenario_controls WHERE "text" = '-901'), 0, 'DELETE: v_edit_inp_dscenario_controls -901 was deleted');
SELECT is((SELECT count(*)::integer FROM inp_dscenario_controls WHERE "text" = '-901'), 0, 'DELETE: inp_dscenario_controls -901 was deleted');


SELECT * FROM finish();


ROLLBACK;