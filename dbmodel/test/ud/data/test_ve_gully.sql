/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(18);

-- IMPORTANT: In this test, we check for existence using the code, not the ID,
-- because we don't allow the user to change the code.
-- In test_gully.sql, we test the `gully` table and can check `gully_id`,
-- but here we are testing the views.

-- gully -> ve_gully_gully
INSERT INTO ve_gully_gully
(gully_id, code, top_elev, ymax, sandbox, matcat_id, gully_type, sys_type, gullycat_id, cat_gully_matcat, units, groove, groove_height, groove_length, siphon, connec_arccat_id, connec_length, connec_depth, connec_matcat_id, connec_y1, connec_y2, grate_width, grate_length, arc_id, epa_type, inp_type, state, state_type, expl_id, macroexpl_id, sector_id, macrosector_id, drainzone_id, dma_id, macrodma_id, annotation, observ, "comment", soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, workcat_id_plan, builtdate, enddate, ownercat_id, muni_id, postcode, district_id, streetname, postnumber, postcomplement, streetname2, postnumber2, postcomplement2, region_id, province_id, descript, svg, rotation, link, verified, undelete, "label", label_x, label_y, label_rotation, publish, inventory, uncertain, num_value, pjoint_id, pjoint_type, asset_id, gullycat2_id, units_placement, expl_id2, is_operative, adate, adescript, siphon_type, odorflap, placement_type, tstamp, insert_user, lastupdate, lastupdate_user, the_geom)
VALUES('-901', '-901', 33.0000, NULL, NULL, 'N/I', 'GULLY', 'GULLY', 'SGRT3', 'FD', 1.00, false, NULL, NULL, false, 'CC020_D', NULL, NULL, NULL, NULL, NULL, 30.0000, 64.0000, NULL, 'GULLY', 'GULLY', 1, 2, 2, 1, 2, 2, NULL, 3, NULL, NULL, NULL, NULL, 'soil1', NULL, NULL, NULL, NULL, 'work1', NULL, NULL, '2024-08-23', NULL, 'owner1', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, 350.443, '', '1', NULL, NULL, NULL, NULL, NULL, true, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, '2024-08-23 09:44:56.000', 'postgres', '2024-08-23 09:44:56.000', 'postgres', 'SRID=25831;POINT (418460.4262488815 4577992.6105188895)'::public.geometry);
SELECT is((SELECT count(*)::integer FROM ve_gully_gully WHERE code = '-901'), 1, 'INSERT: ve_gully_gully "-901" was inserted');
SELECT is((SELECT count(*)::integer FROM gully WHERE code = '-901'), 1, 'INSERT: gully "-901" was inserted');

UPDATE ve_gully_gully SET top_elev = 33.0000 WHERE code = '-901';
SELECT is((SELECT top_elev FROM ve_gully_gully WHERE code = '-901'), 33.0000, 'UPDATE: ve_gully_gully "-901" was updated');
SELECT is((SELECT top_elev FROM gully WHERE code = '-901'), 33.0000, 'UPDATE: gully "-901" was updated');

DELETE FROM ve_gully_gully WHERE code = '-901';
SELECT is((SELECT count(*)::integer FROM ve_gully_gully WHERE code = '-901'), 0, 'DELETE: ve_gully_gully "-901" was deleted');
SELECT is((SELECT count(*)::integer FROM gully WHERE code = '-901'), 0, 'DELETE: gully "-901" was deleted');


-- gully -> ve_gully_pgully
INSERT INTO ve_gully_pgully
(gully_id, code, top_elev, ymax, sandbox, matcat_id, gully_type, sys_type, gullycat_id, cat_gully_matcat, units, groove, groove_height, groove_length, siphon, connec_arccat_id, connec_length, connec_depth, connec_matcat_id, connec_y1, connec_y2, grate_width, grate_length, arc_id, epa_type, inp_type, state, state_type, expl_id, macroexpl_id, sector_id, macrosector_id, drainzone_id, dma_id, macrodma_id, annotation, observ, "comment", soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, workcat_id_plan, builtdate, enddate, ownercat_id, muni_id, postcode, district_id, streetname, postnumber, postcomplement, streetname2, postnumber2, postcomplement2, region_id, province_id, descript, svg, rotation, link, verified, undelete, "label", label_x, label_y, label_rotation, publish, inventory, uncertain, num_value, pjoint_id, pjoint_type, asset_id, gullycat2_id, units_placement, expl_id2, is_operative, adate, adescript, siphon_type, odorflap, placement_type, tstamp, insert_user, lastupdate, lastupdate_user, the_geom, grate_param_1, grate_param_2)
VALUES('-902', '-902', 33.0000, NULL, NULL, 'N/I', 'PGULLY', 'GULLY', 'PGULLY', 'FD', 1.00, false, NULL, NULL, false, 'CC020_D', NULL, NULL, NULL, NULL, NULL, 25.0000, 50.0000, NULL, 'GULLY', 'GULLY', 1, 2, 2, 1, 2, 2, NULL, 3, NULL, NULL, NULL, NULL, 'soil1', NULL, NULL, NULL, NULL, 'work1', NULL, NULL, '2024-08-23', NULL, 'owner1', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, 350.443, '', '1', NULL, NULL, NULL, NULL, NULL, true, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, '2024-08-23 09:45:07.000', 'postgres', '2024-08-23 09:45:07.000', 'postgres', 'SRID=25831;POINT (418461.31281972467 4577992.776750923)'::public.geometry, NULL, false);
SELECT is((SELECT count(*)::integer FROM ve_gully_pgully WHERE code = '-902'), 1, 'INSERT: ve_gully_pgully "-902" was inserted');
SELECT is((SELECT count(*)::integer FROM gully WHERE code = '-902'), 1, 'INSERT: gully "-902" was inserted');

UPDATE ve_gully_pgully SET top_elev = 33.0000 WHERE code = '-902';
SELECT is((SELECT top_elev FROM ve_gully_pgully WHERE code = '-902'), 33.0000, 'UPDATE: ve_gully_pgully "-902" was updated');
SELECT is((SELECT top_elev FROM gully WHERE code = '-902'), 33.0000, 'UPDATE: gully "-902" was updated');

DELETE FROM ve_gully_pgully WHERE code = '-902';
SELECT is((SELECT count(*)::integer FROM ve_gully_pgully WHERE code = '-902'), 0, 'DELETE: ve_gully_pgully "-902" was deleted');
SELECT is((SELECT count(*)::integer FROM gully WHERE code = '-902'), 0, 'DELETE: gully "-902" was deleted');


-- gully -> ve_gully_vgully
INSERT INTO ve_gully_vgully
(gully_id, code, top_elev, ymax, sandbox, matcat_id, gully_type, sys_type, gullycat_id, cat_gully_matcat, units, groove, groove_height, groove_length, siphon, connec_arccat_id, connec_length, connec_depth, connec_matcat_id, connec_y1, connec_y2, grate_width, grate_length, arc_id, epa_type, inp_type, state, state_type, expl_id, macroexpl_id, sector_id, macrosector_id, drainzone_id, dma_id, macrodma_id, annotation, observ, "comment", soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, workcat_id_plan, builtdate, enddate, ownercat_id, muni_id, postcode, district_id, streetname, postnumber, postcomplement, streetname2, postnumber2, postcomplement2, region_id, province_id, descript, svg, rotation, link, verified, undelete, "label", label_x, label_y, label_rotation, publish, inventory, uncertain, num_value, pjoint_id, pjoint_type, asset_id, gullycat2_id, units_placement, expl_id2, is_operative, adate, adescript, siphon_type, odorflap, placement_type, tstamp, insert_user, lastupdate, lastupdate_user, the_geom)
VALUES('-903', '-903', 33.0000, NULL, NULL, 'N/I', 'VGULLY', 'GULLY', 'SGRT6', 'FD', 1.00, false, NULL, NULL, false, 'CC020_D', NULL, NULL, NULL, NULL, NULL, 29.5000, 56.5000, NULL, 'GULLY', 'GULLY', 1, 2, 2, 1, 2, 2, NULL, 3, NULL, NULL, NULL, NULL, 'soil1', NULL, NULL, NULL, NULL, 'work1', NULL, NULL, '2024-08-23', NULL, 'owner1', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, 350.443, '', '1', NULL, NULL, NULL, NULL, NULL, true, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, '2024-08-23 09:52:22.000', 'postgres', '2024-08-23 09:52:22.000', 'postgres', 'SRID=25831;POINT (418462.42103327863 4577992.942982956)'::public.geometry);
SELECT is((SELECT count(*)::integer FROM ve_gully_vgully WHERE code = '-903'), 1, 'INSERT: ve_gully_vgully "-903" was inserted');
SELECT is((SELECT count(*)::integer FROM gully WHERE code = '-903'), 1, 'INSERT: gully "-903" was inserted');

UPDATE ve_gully_vgully SET top_elev = 33.0000 WHERE code = '-903';
SELECT is((SELECT top_elev FROM ve_gully_vgully WHERE code = '-903'), 33.0000, 'UPDATE: ve_gully_vgully "-903" was updated');
SELECT is((SELECT top_elev FROM gully WHERE code = '-903'), 33.0000, 'UPDATE: gully "-903" was updated');

DELETE FROM ve_gully_vgully WHERE code = '-903';
SELECT is((SELECT count(*)::integer FROM ve_gully_vgully WHERE code = '-903'), 0, 'DELETE: ve_gully_vgully "-903" was deleted');
SELECT is((SELECT count(*)::integer FROM gully WHERE code = '-903'), 0, 'DELETE: gully "-903" was deleted');


SELECT * FROM finish();

ROLLBACK;
