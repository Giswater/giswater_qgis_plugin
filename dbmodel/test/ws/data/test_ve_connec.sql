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
-- In test_connec.sql, we test the `connec` table and can check `connec_id`,
-- but here we are testing the views.

-- connec -> ve_connec_fountain
INSERT INTO ve_connec_fountain
(connec_id, code, top_elev, "depth", connec_type, sys_type, conneccat_id, cat_matcat_id, cat_pnom, cat_dnom, cat_dint, epa_type, inp_type, state, state_type, expl_id, macroexpl_id, sector_id, presszone_id, presszone_type, presszone_head, dma_id, dma_type, macrodma_id, dqa_id, dqa_type, macrodqa_id, crmzone_id, crmzone_name, customer_code, connec_length, n_hydrometer, arc_id, annotation, observ, "comment", staticpressure, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, workcat_id_plan, buildercat_id, builtdate, enddate, ownercat_id, muni_id, postcode, district_id, streetname, postnumber, postcomplement, streetname2, postnumber2, postcomplement2, region_id, province_id, descript, svg, rotation, link, verified, undelete, "label", label_x, label_y, label_rotation, publish, inventory, num_value, pjoint_id, pjoint_type, adate, adescript, accessibility, asset_id, dma_style, presszone_style, priority, valve_location, valve_type, shutoff_valve, access_type, placement_type, om_state, conserv_state, expl_id2, is_operative, plot_code, brand_id, model_id, serial_number, cat_valve, minsector_id, macrominsector_id, demand_base, press_max, press_min, press_avg, quality_max, quality_min, quality_avg, tstamp, insert_user, lastupdate, lastupdate_user, the_geom, linked_connec, vmax, vtotal, container_number, pump_number, power, regulation_tank, chlorinator, arq_patrimony, "name", demand_max, demand_min, demand_avg)
VALUES('-901', '-901', 33.0000, NULL, 'FOUNTAIN', 'FOUNTAIN', 'PVC63-PN16-FOU', 'PVC', '16', '63', 63.00000, 'JUNCTION', 'JUNCTION', 1, 2, 2, 1, 5, '6', NULL, 85.00, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '-901', NULL, NULL, NULL, NULL, NULL, NULL, 52.070, 'soil1', NULL, NULL, NULL, NULL, 'work1', NULL, NULL, NULL, '2024-08-22', NULL, 'owner1', 2, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, '', '1', NULL, NULL, NULL, NULL, NULL, true, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '204,235,197', '255,255,204', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-08-22 16:38:55.000', 'postgres', '2024-08-22 16:44:08.000', 'postgres', 'SRID=25831;POINT (418470.98314069357 4577984.057125445)'::public.geometry, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL);
SELECT is((SELECT count(*)::integer FROM ve_connec_fountain WHERE code = '-901'), 1, 'INSERT: ve_connec_fountain "-901" was inserted');
SELECT is((SELECT count(*)::integer FROM connec WHERE code = '-901'), 1, 'INSERT: connec:fountain "-901" was inserted');

UPDATE ve_connec_fountain SET top_elev = 33.0000 WHERE code = '-901';
SELECT is((SELECT top_elev FROM ve_connec_fountain WHERE code = '-901'), 33.0000, 'UPDATE: ve_connec_fountain "-901" was updated');
SELECT is((SELECT top_elev FROM connec WHERE code = '-901'), 33.0000, 'UPDATE: connec:fountain "-901" was updated');

DELETE FROM ve_connec_fountain WHERE code = '-901';
SELECT is((SELECT count(*)::integer FROM ve_connec_fountain WHERE code = '-901'), 0, 'DELETE: ve_connec_fountain "-901" was deleted');
SELECT is((SELECT count(*)::integer FROM connec WHERE code = '-901'), 0, 'DELETE: connec:fountain "-901" was deleted');


-- connec -> ve_connec_greentap
INSERT INTO ve_connec_greentap
(connec_id, code, top_elev, "depth", connec_type, sys_type, conneccat_id, cat_matcat_id, cat_pnom, cat_dnom, cat_dint, epa_type, inp_type, state, state_type, expl_id, macroexpl_id, sector_id, presszone_id, presszone_type, presszone_head, dma_id, dma_type, macrodma_id, dqa_id, dqa_type, macrodqa_id, crmzone_id, crmzone_name, customer_code, connec_length, n_hydrometer, arc_id, annotation, observ, "comment", staticpressure, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, workcat_id_plan, buildercat_id, builtdate, enddate, ownercat_id, muni_id, postcode, district_id, streetname, postnumber, postcomplement, streetname2, postnumber2, postcomplement2, region_id, province_id, descript, svg, rotation, link, verified, undelete, "label", label_x, label_y, label_rotation, publish, inventory, num_value, pjoint_id, pjoint_type, adate, adescript, accessibility, asset_id, dma_style, presszone_style, priority, valve_location, valve_type, shutoff_valve, access_type, placement_type, om_state, conserv_state, expl_id2, is_operative, plot_code, brand_id, model_id, serial_number, cat_valve, minsector_id, macrominsector_id, demand_base, press_max, press_min, press_avg, quality_max, quality_min, quality_avg, tstamp, insert_user, lastupdate, lastupdate_user, the_geom, linked_connec, greentap_type, demand_max, demand_min, demand_avg)
VALUES('-902', '-902', 32.9300, NULL, 'GREENTAP', 'GREENTAP', 'PVC50-PN16-GRE', 'PVC', '16', '50', 50.00000, 'JUNCTION', 'JUNCTION', 1, 2, 2, 1, 5, '6', NULL, 85.00, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '-902', NULL, NULL, NULL, NULL, NULL, NULL, 52.070, 'soil1', NULL, NULL, NULL, NULL, 'work1', NULL, NULL, NULL, '2024-08-22', NULL, 'owner1', 2, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, '', '1', NULL, NULL, NULL, NULL, NULL, true, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '204,235,197', '255,255,204', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-08-22 16:39:07.000', 'postgres', '2024-08-22 16:39:07.000', 'postgres', 'SRID=25831;POINT (418471.1473305661 4577983.030938743)'::public.geometry, NULL, NULL, NULL, NULL, NULL);
SELECT is((SELECT count(*)::integer FROM ve_connec_greentap WHERE code = '-902'), 1, 'INSERT: ve_connec_greentap "-902" was inserted');
SELECT is((SELECT count(*)::integer FROM connec WHERE code = '-902'), 1, 'INSERT: connec:greentap "-902" was inserted');

UPDATE ve_connec_greentap SET top_elev = 33.0000 WHERE code = '-902';
SELECT is((SELECT top_elev FROM ve_connec_greentap WHERE code = '-902'), 33.0000, 'UPDATE: ve_connec_greentap "-902" was updated');
SELECT is((SELECT top_elev FROM connec WHERE code = '-902'), 33.0000, 'UPDATE: connec:greentap "-902" was updated');

DELETE FROM ve_connec_greentap WHERE code = '-902';
SELECT is((SELECT count(*)::integer FROM ve_connec_greentap WHERE code = '-902'), 0, 'DELETE: ve_connec_greentap "-902" was deleted');
SELECT is((SELECT count(*)::integer FROM connec WHERE code = '-902'), 0, 'DELETE: connec:greentap "-902" was deleted');


-- connec -> ve_connec_wjoin
INSERT INTO ve_connec_wjoin
(connec_id, code, top_elev, "depth", connec_type, sys_type, conneccat_id, cat_matcat_id, cat_pnom, cat_dnom, cat_dint, epa_type, inp_type, state, state_type, expl_id, macroexpl_id, sector_id, presszone_id, presszone_type, presszone_head, dma_id, dma_type, macrodma_id, dqa_id, dqa_type, macrodqa_id, crmzone_id, crmzone_name, customer_code, connec_length, n_hydrometer, arc_id, annotation, observ, "comment", staticpressure, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, workcat_id_plan, buildercat_id, builtdate, enddate, ownercat_id, muni_id, postcode, district_id, streetname, postnumber, postcomplement, streetname2, postnumber2, postcomplement2, region_id, province_id, descript, svg, rotation, link, verified, undelete, "label", label_x, label_y, label_rotation, publish, inventory, num_value, pjoint_id, pjoint_type, adate, adescript, accessibility, asset_id, dma_style, presszone_style, priority, valve_location, valve_type, shutoff_valve, access_type, placement_type, om_state, conserv_state, expl_id2, is_operative, plot_code, brand_id, model_id, serial_number, cat_valve, minsector_id, macrominsector_id, demand_base, press_max, press_min, press_avg, quality_max, quality_min, quality_avg, tstamp, insert_user, lastupdate, lastupdate_user, the_geom, top_floor, wjoin_type, demand_max, demand_min, demand_avg)
VALUES('-903', '-903', 33.0300, NULL, 'WJOIN', 'WJOIN', 'PVC32-PN16-DOM', 'PVC', '16', '32', 32.00000, 'JUNCTION', 'JUNCTION', 1, 2, 2, 1, 5, '6', NULL, 85.00, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '-903', NULL, NULL, NULL, NULL, NULL, NULL, 51.970, 'soil1', NULL, NULL, NULL, NULL, 'work1', NULL, NULL, NULL, '2024-08-22', NULL, 'owner1', 2, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, '', '1', NULL, NULL, NULL, NULL, NULL, true, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '204,235,197', '255,255,204', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-08-22 16:39:19.000', 'postgres', '2024-08-22 16:39:19.000', 'postgres', 'SRID=25831;POINT (418471.2704729705 4577982.127894443)'::public.geometry, NULL, NULL, NULL, NULL, NULL);
SELECT is((SELECT count(*)::integer FROM ve_connec_wjoin WHERE code = '-903'), 1, 'INSERT: ve_connec_wjoin "-903" was inserted');
SELECT is((SELECT count(*)::integer FROM connec WHERE code = '-903'), 1, 'INSERT: connec:wjoin "-903" was inserted');

UPDATE ve_connec_wjoin SET top_elev = 33.0000 WHERE code = '-903';
SELECT is((SELECT top_elev FROM ve_connec_wjoin WHERE code = '-903'), 33.0000, 'UPDATE: ve_connec_wjoin "-903" was updated');
SELECT is((SELECT top_elev FROM connec WHERE code = '-903'), 33.0000, 'UPDATE: connec:wjoin "-903" was updated');

DELETE FROM ve_connec_wjoin WHERE code = '-903';
SELECT is((SELECT count(*)::integer FROM ve_connec_wjoin WHERE code = '-903'), 0, 'DELETE: ve_connec_wjoin "-903" was deleted');
SELECT is((SELECT count(*)::integer FROM connec WHERE code = '-903'), 0, 'DELETE: connec:wjoin "-903" was deleted');


SELECT * FROM finish();

ROLLBACK;
