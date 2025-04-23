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

SELECT plan(12);

-- IMPORTANT: In this test, we check for existence using the code, not the ID,
-- because we don't allow the user to change the code.
-- In test_connec.sql, we test the `connec` table and can check `connec_id`,
-- but here we are testing the views.

-- connec -> ve_connec_connec
INSERT INTO ve_connec_connec
(connec_id, code, sys_code, customer_code, top_elev, y1, y2, conneccat_id, connec_type, sys_type, matcat_id, state, state_type, expl_id, macroexpl_id, sector_id, macrosector_id, drainzone_id, demand, connec_depth, connec_length, arc_id, annotation, observ, "comment", omzone_id, macroomzone_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, district_id, streetname, postnumber, postcomplement, streetname2, postnumber2, postcomplement2, region_id, province_id, descript, svg, rotation, link, verified, "label", label_x, label_y, label_rotation, accessibility, diagonal, publish, inventory, uncertain, num_value, pjoint_id, pjoint_type, created_at, created_by, updated_at, updated_by, the_geom, workcat_id_plan, asset_id, is_operative, adate, adescript, plot_code, placement_type)
VALUES('-901', '-901', '-901', '-901', 33.2200, NULL, NULL, 'CON-CC040_I', 'CONNEC', 'CONNEC', NULL, 1, 2, 2, 1, 2, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, NULL, 'soil1', NULL, NULL, NULL, NULL, 'work1', NULL, '2024-08-23', NULL, 'owner1', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, '', '1', NULL, NULL, NULL, NULL, NULL, NULL, true, true, false, NULL, NULL, NULL, '2024-08-23 09:38:22.000', 'postgres', NULL, NULL, 'SRID=25831;POINT (418456.45053275774 4577991.751653385)'::public.geometry, NULL, NULL, true, NULL, NULL, NULL, NULL);
SELECT is((SELECT count(*)::integer FROM ve_connec_connec WHERE code = '-901'), 1, 'INSERT: ve_connec_connec "-901" was inserted');
SELECT is((SELECT count(*)::integer FROM connec WHERE code = '-901'), 1, 'INSERT: connec "-901" was inserted');

UPDATE ve_connec_connec SET top_elev = 33.0000 WHERE code = '-901';
SELECT is((SELECT top_elev FROM ve_connec_connec WHERE code = '-901'), 33.0000, 'UPDATE: ve_connec_connec "-901" was updated');
SELECT is((SELECT top_elev FROM connec WHERE code = '-901'), 33.0000, 'UPDATE: connec "-901" was updated');

DELETE FROM ve_connec_connec WHERE code = '-901';
SELECT is((SELECT count(*)::integer FROM ve_connec_connec WHERE code = '-901'), 0, 'DELETE: ve_connec_connec "-901" was deleted');
SELECT is((SELECT count(*)::integer FROM connec WHERE code = '-901'), 0, 'DELETE: connec "-901" was deleted');


-- connec -> ve_connec_vconnec
INSERT INTO ve_connec_vconnec
(connec_id, code, sys_code, customer_code, top_elev, y1, y2, conneccat_id, connec_type, sys_type, matcat_id, state, state_type, expl_id, macroexpl_id, sector_id, macrosector_id, drainzone_id, demand, connec_depth, connec_length, arc_id, annotation, observ, "comment", omzone_id, macroomzone_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, district_id, streetname, postnumber, postcomplement, streetname2, postnumber2, postcomplement2, region_id, province_id, descript, svg, rotation, link, verified, "label", label_x, label_y, label_rotation, accessibility, diagonal, publish, inventory, uncertain, num_value, pjoint_id, pjoint_type, created_at, created_by, updated_at, updated_by, the_geom, workcat_id_plan, asset_id, is_operative, adate, adescript, plot_code, placement_type)
VALUES('-902', '-902', '-902', '-902', 33.0900, NULL, NULL, 'VIRTUAL', 'VCONNEC', 'CONNEC', NULL, 1, 2, 2, 1, 2, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, NULL, 'soil1', NULL, NULL, NULL, NULL, 'work1', NULL, '2024-08-23', NULL, 'owner1', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, '', '1', NULL, NULL, NULL, NULL, NULL, NULL, true, true, false, NULL, NULL, NULL, '2024-08-23 09:38:37.000', 'postgres', NULL, NULL, 'SRID=25831;POINT (418458.1128530885 4577992.084117452)'::public.geometry, NULL, NULL, true, NULL, NULL, NULL, NULL);
SELECT is((SELECT count(*)::integer FROM ve_connec_vconnec WHERE code = '-902'), 1, 'INSERT: ve_connec_vconnec "-902" was inserted');
SELECT is((SELECT count(*)::integer FROM connec WHERE code = '-902'), 1, 'INSERT: connec "-902" was inserted');

UPDATE ve_connec_vconnec SET top_elev = 33.0000 WHERE code = '-902';
SELECT is((SELECT top_elev FROM ve_connec_vconnec WHERE code = '-902'), 33.0000, 'UPDATE: ve_connec_vconnec "-902" was updated');
SELECT is((SELECT top_elev FROM connec WHERE code = '-902'), 33.0000, 'UPDATE: connec "-902" was updated');

DELETE FROM ve_connec_vconnec WHERE code = '-902';
SELECT is((SELECT count(*)::integer FROM ve_connec_vconnec WHERE code = '-902'), 0, 'DELETE: ve_connec_vconnec "-902" was deleted');
SELECT is((SELECT count(*)::integer FROM connec WHERE code = '-902'), 0, 'DELETE: connec "-902" was deleted');


SELECT * FROM finish();

ROLLBACK;
