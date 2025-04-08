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


INSERT INTO v_edit_macrosector (macrosector_id, "name", descript, the_geom)
VALUES(-901, 'macrosector_901', 'macrosector_ud_901', NULL);

INSERT INTO sector (sector_id, "name", macrosector_id, descript, the_geom, active, parent_id, tstamp, insert_user, lastupdate, lastupdate_user, stylesheet, sector_type, graphconfig, link)
VALUES(-901, 'sector_901', -901, 'sector_project_ud', null, 0, true, NULL, '2025-02-04 14:54:56.592', 'postgres', NULL, NULL, NULL, NULL, 
'{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json, NULL);
INSERT INTO selector_sector (sector_id, cur_user) VALUES (-901, 'postgres');


SELECT is((SELECT count(*)::integer FROM v_edit_macrosector WHERE macrosector_id = -901), 1, 'INSERT: v_edit_macrosector -901 was inserted');
SELECT is((SELECT count(*)::integer FROM macrosector WHERE macrosector_id = -901), 1, 'INSERT: macrosector -901 was inserted');

UPDATE v_edit_macrosector SET descript = 'updated descript' WHERE macrosector_id = -901;
SELECT is((SELECT descript FROM v_edit_macrosector WHERE macrosector_id = -901), 'updated descript', 'UPDATE: v_edit_macrosector -901 was updated');
SELECT is((SELECT descript FROM macrosector WHERE macrosector_id = -901), 'updated descript', 'UPDATE: macrosector -901 was updated');

DELETE FROM v_edit_macrosector WHERE macrosector_id = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_macrosector WHERE macrosector_id = -901), 0, 'DELETE: v_edit_macrosector -901 was deleted');
SELECT is((SELECT count(*)::integer FROM macrosector WHERE macrosector_id = -901), 0, 'DELETE: macrosector -901 was deleted');


SELECT * FROM finish();


ROLLBACK;