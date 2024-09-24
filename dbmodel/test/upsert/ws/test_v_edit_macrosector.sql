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

INSERT INTO v_edit_macrosector (macrosector_id, "name", descript, the_geom, undelete, active) 
VALUES(-901, 'Undefined', NULL, NULL, NULL, true);
SELECT is((SELECT count(*)::integer FROM v_edit_macrosector WHERE macrosector_id = -901), 1, 'INSERT: v_edit_macrosector -901 was inserted');
SELECT is((SELECT count(*)::integer FROM macrosector WHERE macrosector_id = -901), 1, 'INSERT: macrosector -901 was inserted');


UPDATE v_edit_macrosector SET name = 'updated name' WHERE macrosector_id = -901;
SELECT is((SELECT name FROM v_edit_macrosector WHERE macrosector_id = -901), 'updated name', 'UPDATE: v_edit_macrosector -901 was updated');
SELECT is((SELECT name FROM macrosector WHERE macrosector_id = -901), 'updated name', 'UPDATE: macrosector -901 was updated');


DELETE FROM v_edit_macrosector WHERE macrosector_id = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_macrosector WHERE macrosector_id = -901), 0, 'DELETE: v_edit_macrosector -901 was deleted');
SELECT is((SELECT count(*)::integer FROM macrosector WHERE macrosector_id = -901), 0, 'DELETE: macrosector -901 was deleted');


SELECT * FROM finish();

ROLLBACK;