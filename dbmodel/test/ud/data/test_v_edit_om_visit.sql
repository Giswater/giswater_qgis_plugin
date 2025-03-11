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

INSERT INTO v_edit_om_visit (id, visitcat_id, ext_code, startdate, enddate, user_name, the_geom, webclient_id, expl_id)
VALUES(-901, 1, NULL, '2024-03-27 08:43:51.527', '2024-03-27 08:43:51.527', 'postgres', NULL, NULL, 1);



SELECT is((SELECT count(*)::integer FROM v_edit_om_visit WHERE id = -901), 1, 'INSERT: v_edit_om_visit -901 was inserted');
SELECT is((SELECT count(*)::integer FROM om_visit WHERE id = -901), 1, 'INSERT: om_visit -901 was inserted');

UPDATE v_edit_om_visit SET ext_code = 'updated ext_code' WHERE id = -901;
SELECT is((SELECT ext_code FROM v_edit_om_visit WHERE id = -901), 'updated ext_code', 'UPDATE: v_edit_om_visit -901 was updated');
SELECT is((SELECT ext_code FROM om_visit WHERE id = -901), 'updated ext_code', 'UPDATE: om_visit -901 was updated');

DELETE FROM v_edit_om_visit WHERE id = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_om_visit WHERE id = -901), 0, 'DELETE: v_edit_om_visit -901 was deleted');
SELECT is((SELECT count(*)::integer FROM om_visit WHERE id = -901), 0, 'DELETE: om_visit -901 was deleted');


SELECT * FROM finish();


ROLLBACK;