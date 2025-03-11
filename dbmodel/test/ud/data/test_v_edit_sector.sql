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

INSERT INTO v_edit_sector
(sector_id, "name", descript, macrosector_id, sector_type, the_geom, parent_id, graphconfig, stylesheet)
VALUES(-901, 'sector_01', 'sector_project_ud', 1, NULL, NULL, NULL, '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}', NULL);
SELECT is((SELECT count(*)::integer FROM v_edit_sector WHERE sector_id = -901), 1, 'INSERT: v_edit_sector -901 was inserted');
SELECT is((SELECT count(*)::integer FROM sector WHERE sector_id = -901), 1, 'INSERT: sector -901 was inserted');

UPDATE v_edit_sector SET descript = 'updated descript' WHERE sector_id = -901;
SELECT is((SELECT descript FROM v_edit_sector WHERE sector_id = -901), 'updated descript', 'UPDATE: v_edit_sector -901 was updated');
SELECT is((SELECT descript FROM sector WHERE sector_id = -901), 'updated descript', 'UPDATE: sector -901 was updated');

DELETE FROM v_edit_sector WHERE sector_id = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_sector WHERE sector_id = -901), 0, 'DELETE: v_edit_sector -901 was deleted');
SELECT is((SELECT count(*)::integer FROM sector WHERE sector_id = -901), 0, 'DELETE: sector -901 was deleted');


SELECT * FROM finish();


ROLLBACK;