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

INSERT INTO ve_cat_feature_connec (id, system_id, epa_default, code_autofill, shortcut_key, link_path, descript, active)
VALUES('999001', 'WJOIN', 'JUNCTION', true, 'Ctrl+A', NULL, 'Wjoin', true);
SELECT is((SELECT count(*)::integer FROM ve_cat_feature_connec WHERE id = '999001'), 1, 'INSERT: ve_cat_feature_connec 999001 was inserted');
SELECT is((SELECT count(*)::integer FROM cat_feature_connec WHERE id = '999001'), 1, 'INSERT: cat_feature_connec 999001 was inserted');

UPDATE ve_cat_feature_connec SET epa_default = 'JUNCTION' WHERE id = '999001';
SELECT is((SELECT epa_default FROM ve_cat_feature_connec WHERE id = '999001'), 'JUNCTION', 'UPDATE: ve_cat_feature_connec 999001 was updated');
SELECT is((SELECT epa_default FROM cat_feature_connec WHERE id = '999001'), 'JUNCTION', 'UPDATE: cat_feature_connec 999001 was updated');

DELETE FROM ve_cat_feature_connec WHERE id = '999001';
SELECT is((SELECT count(*)::integer FROM ve_cat_feature_connec WHERE id = '999001'), 0, 'DELETE: ve_cat_feature_connec 999001 was deleted');
SELECT is((SELECT count(*)::integer FROM cat_feature_connec WHERE id = '999001'), 0, 'DELETE: cat_feature_connec 999001 was deleted');

SELECT * FROM finish();

ROLLBACK;