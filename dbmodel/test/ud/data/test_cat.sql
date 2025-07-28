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

SELECT plan(8);

-- Subtest 1: Testing cat_work operations | insert/update/delete
INSERT INTO cat_work (id, descript, link, workid_key1, workid_key2, builtdate, workcost, active)
VALUES('work5', 'Description work5', NULL, NULL, NULL, '2024-08-19', NULL, true);
SELECT is((SELECT count(*)::integer FROM cat_work WHERE id = 'work5'), 1, 'INSERT: cat_work "work5" was inserted');

UPDATE cat_work SET descript = 'updated test' WHERE id = 'work5';
SELECT is((SELECT descript FROM cat_work WHERE id = 'work5'), 'updated test', 'UPDATE: descript was updated to "updated test"');

INSERT INTO cat_work (id, descript, link, workid_key1, workid_key2, builtdate, workcost, active)
VALUES('work5', 'upsert test', NULL, NULL, NULL, '2024-08-19', NULL, true)
ON CONFLICT (id) DO UPDATE SET descript = EXCLUDED.descript;
SELECT is((SELECT descript FROM cat_work WHERE id = 'work5'), 'upsert test', 'UPSERT: descript was updated to "upsert test" using ON CONFLICT');

DELETE FROM cat_work WHERE id = 'work5';
SELECT is((SELECT count(*)::integer FROM cat_work WHERE id = 'work5'), 0, 'DELETE: cat_work "work5" was deleted');


-- Subtest 2: Testing cat_feature_node operations | insert/update/delete (junction, circ_manhole, sewer_storage)
-- JUNCTION
-- INSERT INTO cat_feature (id, system_id, feature_type, shortcut_key, parent_layer, child_layer, descript, link_path, code_autofill, active, addparam)
-- VALUES('JUNCTION2', 'JUNCTION', 'NODE', NULL, 've_node', 've_node_junction', NULL, NULL, true, true, NULL);
-- SELECT is((SELECT count(*)::integer FROM cat_feature_node WHERE id = 'JUNCTION2'), 1, 'INSERT: cat_feature_node "JUNCTION2" was inserted');

-- UPDATE cat_feature_node SET num_arcs = 1 WHERE id = 'JUNCTION2';
-- SELECT is((SELECT num_arcs FROM cat_feature_node WHERE id = 'JUNCTION2'), 1, 'UPDATE: num_arcs was updated to 1');

-- INSERT INTO cat_feature_node (id, "type", epa_default, num_arcs, choose_hemisphere, isarcdivide, isprofilesurface, isexitupperintro, double_geom)
-- VALUES('JUNCTION2', 'JUNCTION', 'JUNCTION', 3, true, true, true, 0, '{"activated":false,"value":1}'::json);
-- ON CONFLICT (id) DO UPDATE SET num_arcs = EXCLUDED.num_arcs;
-- SELECT is((SELECT num_arcs FROM cat_feature_node WHERE id = 'JUNCTION2'), 3, 'UPSERT: num_arcs was updated to 3 using ON CONFLICT');

-- DELETE FROM cat_feature_node WHERE id = 'JUNCTION2';
-- SELECT is((SELECT count(*)::integer FROM cat_feature_node WHERE id = 'JUNCTION2'), 0, 'DELETE: cat_feature_node "JUNCTION2" was deleted');

-- -- CIRC_MANHOLE
-- INSERT INTO cat_feature (id, system_id, feature_type, shortcut_key, parent_layer, child_layer, descript, link_path, code_autofill, active, addparam)
-- VALUES('CIRC_MANHOLE2', 'MANHOLE', 'NODE', NULL, 've_node', 've_node_circ_manhole', NULL, NULL, true, true, '{"code_prefix":"CM_"}'::json);
-- SELECT is((SELECT count(*)::integer FROM cat_feature_node WHERE id = 'CIRC_MANHOLE2'), 1, 'INSERT: cat_feature_node "CIRC_MANHOLE2" was inserted');

-- UPDATE cat_feature_node SET num_arcs = 1 WHERE id = 'CIRC_MANHOLE2';
-- SELECT is((SELECT num_arcs FROM cat_feature_node WHERE id = 'CIRC_MANHOLE2'), 1, 'UPDATE: num_arcs was updated to 1');

-- INSERT INTO cat_feature_node (id, "type", epa_default, num_arcs, choose_hemisphere, isarcdivide, isprofilesurface, isexitupperintro, double_geom)
-- VALUES('CIRC_MANHOLE2', 'MANHOLE', 'JUNCTION', 3, true, true, true, 0, '{"activated":false,"value":1}'::json);
-- ON CONFLICT (id) DO UPDATE SET num_arcs = EXCLUDED.num_arcs;
-- SELECT is((SELECT num_arcs FROM cat_feature_node WHERE id = 'CIRC_MANHOLE2'), 3, 'UPSERT: num_arcs was updated to 3 using ON CONFLICT');

-- DELETE FROM cat_feature_node WHERE id = 'CIRC_MANHOLE2';
-- SELECT is((SELECT count(*)::integer FROM cat_feature_node WHERE id = 'CIRC_MANHOLE2'), 0, 'DELETE: cat_feature_node "CIRC_MANHOLE2" was deleted');

-- -- SEWER_STORAGE
-- INSERT INTO cat_feature (id, system_id, feature_type, shortcut_key, parent_layer, child_layer, descript, link_path, code_autofill, active, addparam)
-- VALUES('SEWER_STORAGE2', 'STORAGE', 'NODE', NULL, 've_node', 've_node_sewer_storage', NULL, NULL, true, true, NULL);
-- SELECT is((SELECT count(*)::integer FROM cat_feature_node WHERE id = 'SEWER_STORAGE2'), 1, 'INSERT: cat_feature_node "SEWER_STORAGE2" was inserted');

-- UPDATE cat_feature_node SET num_arcs = 1 WHERE id = 'SEWER_STORAGE2';
-- SELECT is((SELECT num_arcs FROM cat_feature_node WHERE id = 'SEWER_STORAGE2'), 1, 'UPDATE: num_arcs was updated to 1');

-- INSERT INTO cat_feature_node (id, "type", epa_default, num_arcs, choose_hemisphere, isarcdivide, isprofilesurface, isexitupperintro, double_geom)
-- VALUES('SEWER_STORAGE2', 'SEWER_STORAGE', 'SEWER_STORAGE', 3, true, true, false, 0, '{"activated":false,"value":1}'::json);
-- ON CONFLICT (id) DO UPDATE SET num_arcs = EXCLUDED.num_arcs;
-- SELECT is((SELECT num_arcs FROM cat_feature_node WHERE id = 'SEWER_STORAGE2'), 3, 'UPSERT: num_arcs was updated to 3 using ON CONFLICT');

-- DELETE FROM cat_feature_node WHERE id = 'SEWER_STORAGE2';
-- SELECT is((SELECT count(*)::integer FROM cat_feature_node WHERE id = 'SEWER_STORAGE2'), 0, 'DELETE: cat_feature_node "SEWER_STORAGE2" was deleted');


-- Subtest 3: Testing cat_feature_arc operations | insert/update/delete (conduit, siphon, waccel, pump_pipe)

-- Subtest 4: Testing cat_feature_connec operations | insert/update/delete

-- Subtest 5: Testing cat_feature_gully operations | insert/update/delete (gully, pgully)

-- Subtest 6: Testing cat_mat_node operations | insert/update/delete

-- Subtest 7: Testing cat_mat_roughness operations | insert/update/delete

-- Subtest 8: Testing cat_mat_arc operations | insert/update/delete

-- Subtest 9: Testing cat_arc operations | insert/update/delete
INSERT INTO cat_arc
(id, matcat_id, shape, geom1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1, z2, width, area, estimated_depth, thickness, cost_unit, "cost", m2bottom_cost, m3protec_cost, active, "label", tsect_id, curve_id, arc_type, acoeff, connect_cost, visitability_vdef)
VALUES('-902', NULL, 'RECT_CLOSED', 2.0000, 2.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 2.60, 4.0000, 3.20, 0.30, 'm', 'A_CON_R200', 'S_REP', 'S_NULL', true, NULL, NULL, NULL, 'SIPHON', NULL, 'N_CONNECTION', 3);
SELECT is((SELECT count(*)::integer FROM cat_arc WHERE id = '-902'), 1, 'INSERT: cat_arc "-902" was inserted');

UPDATE cat_arc SET geom1 = 0.2 WHERE id = '-902';
SELECT is((SELECT geom1 FROM cat_arc WHERE id = '-902'), 0.2, 'UPDATE: cat_arc "-902" was updated');

INSERT INTO cat_arc
(id, matcat_id, shape, geom1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1, z2, width, area, estimated_depth, thickness, cost_unit, "cost", m2bottom_cost, m3protec_cost, active, "label", tsect_id, curve_id, arc_type, acoeff, connect_cost, visitability_vdef)
VALUES('-902', NULL, 'RECT_CLOSED', 4.0000, 2.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 2.60, 4.0000, 3.20, 0.30, 'm', 'A_CON_R200', 'S_REP', 'S_NULL', true, NULL, NULL, NULL, 'SIPHON', NULL, 'N_CONNECTION', 3)
ON CONFLICT (id) DO UPDATE SET geom1 = EXCLUDED.geom1;
SELECT is((SELECT geom1 FROM cat_arc WHERE id = '-902'), 4.0000, 'UPDATE: cat_arc "-902" was upserted');

DELETE FROM cat_arc WHERE id = '-902';
SELECT is((SELECT count(*)::integer FROM cat_arc WHERE id = '-902'), 0, 'DELETE: cat_arc "-902" was deleted');

-- Subtest 10: Testing cat_node operations | insert/update/delete

-- Subtest 11: Testing cat_gully operations | insert/update/delete


SELECT * FROM finish();

ROLLBACK;
