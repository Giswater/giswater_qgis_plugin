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

INSERT INTO v_edit_cat_feature_arc (id, system_id, epa_default, code_autofill, shortcut_key, link_path, descript, active)
VALUES('999000', 'PIPE', 'PIPE', true, 'Y', NULL, 'Water distribution pipe', true);
SELECT is((SELECT count(*)::integer FROM v_edit_cat_feature_arc WHERE id = '999000'), 1, 'INSERT: v_edit_cat_feature_arc 999000 was inserted');
SELECT is((SELECT count(*)::integer FROM cat_feature_arc WHERE id = '999000'), 1, 'INSERT: cat_feature_arc 999000 was inserted');

UPDATE v_edit_cat_feature_arc SET epa_default = 'PIPE' WHERE id = '999000';
SELECT is((SELECT epa_default FROM v_edit_cat_feature_arc WHERE id = '999000'), 'PIPE', 'UPDATE: v_edit_cat_feature_arc 999000 was updated');
SELECT is((SELECT epa_default FROM cat_feature_arc WHERE id = '999000'), 'PIPE', 'UPDATE: cat_feature_arc 999000 was updated');

DELETE FROM v_edit_cat_feature_arc WHERE id = '999000';
SELECT is((SELECT count(*)::integer FROM v_edit_cat_feature_arc WHERE id = '999000'), 0, 'DELETE: v_edit_cat_feature_arc 999000 was deleted');
SELECT is((SELECT count(*)::integer FROM cat_feature_arc WHERE id = '999000'), 0, 'DELETE: cat_feature_arc 999000 was deleted');

SELECT * FROM finish();

ROLLBACK;