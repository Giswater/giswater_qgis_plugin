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

INSERT INTO v_edit_cat_feature_node (id, system_id, epa_default, isarcdivide, isprofilesurface, choose_hemisphere, code_autofill, double_geom, num_arcs, graph_delimiter, shortcut_key, link_path, descript, active)
VALUES('999002', 'JUNCTION', 'JUNCTION', true, false, true, true, '{"activated":false,"value":1}', 2, 'NONE', 'Alt+A', NULL, 'Junction', true);
SELECT is((SELECT count(*)::integer FROM v_edit_cat_feature_node WHERE id = '999002'), 1, 'INSERT: v_edit_cat_feature_node 999002 was inserted');
SELECT is((SELECT count(*)::integer FROM cat_feature_node WHERE id = '999002'), 1, 'INSERT: cat_feature_node 999002 was inserted');

UPDATE v_edit_cat_feature_node SET epa_default = 'JUNCTION' WHERE id = '999002';
SELECT is((SELECT epa_default FROM v_edit_cat_feature_node WHERE id = '999002'), 'JUNCTION', 'UPDATE: v_edit_cat_feature_node 999002 was updated');
SELECT is((SELECT epa_default FROM cat_feature_node WHERE id = '999002'), 'JUNCTION', 'UPDATE: cat_feature_node 999002 was updated');

DELETE FROM v_edit_cat_feature_node WHERE id = '999002';
SELECT is((SELECT count(*)::integer FROM v_edit_cat_feature_node WHERE id = '999002'), 0, 'DELETE: v_edit_cat_feature_node 999002 was deleted');
SELECT is((SELECT count(*)::integer FROM cat_feature_node WHERE id = '999002'), 0, 'DELETE: cat_feature_node 999002 was deleted');

SELECT * FROM finish();

ROLLBACK;