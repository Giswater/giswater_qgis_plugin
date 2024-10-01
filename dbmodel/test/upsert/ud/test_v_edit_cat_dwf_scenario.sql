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


INSERT INTO v_edit_cat_dwf_scenario (id, idval, startdate, enddate, observ, expl_id, active, log)
VALUES(-901, 'Default values', NULL, NULL, NULL, NULL, true, NULL);

SELECT is((SELECT count(*)::integer FROM v_edit_cat_dwf_scenario WHERE id = -901), 1, 'INSERT: v_edit_cat_dwf_scenario -901 was inserted');
SELECT is((SELECT count(*)::integer FROM cat_dwf_scenario WHERE id = -901), 1, 'INSERT: cat_dwf_scenario -901 was inserted');

UPDATE v_edit_cat_dwf_scenario SET observ = 'updated observ' WHERE id = -901;
SELECT is((SELECT observ FROM v_edit_cat_dwf_scenario WHERE id = -901), 'updated observ', 'UPDATE: v_edit_cat_dwf_scenario -901 was updated');
SELECT is((SELECT observ FROM cat_dwf_scenario WHERE id = -901), 'updated observ', 'UPDATE: cat_dwf_scenario -901 was updated');

DELETE FROM v_edit_cat_dwf_scenario WHERE id = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_cat_dwf_scenario WHERE id = -901), 0, 'DELETE: v_edit_cat_dwf_scenario -901 was deleted');
SELECT is((SELECT count(*)::integer FROM cat_dwf_scenario WHERE id = -901), 0, 'DELETE: cat_dwf_scenario -901 was deleted');


SELECT * FROM finish();


ROLLBACK;