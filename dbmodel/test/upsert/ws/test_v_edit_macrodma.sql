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

INSERT INTO v_edit_macrodma (macrodma_id, "name", descript, the_geom, expl_id)
VALUES(-901, 'Undefined', NULL, NULL, 0);
SELECT is((SELECT count(*)::integer FROM v_edit_macrodma WHERE macrodma_id = -901), 1, 'INSERT: v_edit_macrodma -901 was inserted');
SELECT is((SELECT count(*)::integer FROM macrodma WHERE macrodma_id = -901), 1, 'INSERT: macrodma -901 was inserted');


UPDATE v_edit_macrodma SET descript = 'updated descript' WHERE macrodma_id = -901;
SELECT is((SELECT descript FROM v_edit_macrodma WHERE macrodma_id = -901), 'updated descript', 'UPDATE: v_edit_macrodma -901 was updated');
SELECT is((SELECT descript FROM macrodma WHERE macrodma_id = -901), 'updated descript', 'UPDATE: macrodma -901 was updated');


DELETE FROM v_edit_macrodma WHERE macrodma_id = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_macrodma WHERE macrodma_id = -901), 0, 'DELETE: v_edit_macrodma -901 was deleted');
SELECT is((SELECT count(*)::integer FROM macrodma WHERE macrodma_id = -901), 0, 'DELETE: macrodma -901 was deleted');


SELECT * FROM finish();

ROLLBACK;