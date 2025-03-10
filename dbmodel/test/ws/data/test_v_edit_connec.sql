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


INSERT INTO v_edit_connec (code, top_elev, "depth", connec_type, sys_type, conneccat_id, cat_matcat_id, cat_pnom, cat_dnom, cat_dint, epa_type, inp_type, state, state_type, expl_id, macroexpl_id, sector_id, presszone_id, presszone_type, presszone_head, dma_id, dma_type, macrodma_id, dqa_id, dqa_type, macrodqa_id, crmzone_id, crmzone_name, customer_code, connec_length, n_hydrometer, arc_id, annotation, observ, "comment", staticpressure, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, workcat_id_plan, builtdate, enddate, ownercat_id, muni_id, postcode, district_id, streetname, postnumber, postcomplement, streetname2, postnumber2, postcomplement2, region_id, province_id, descript, svg, rotation, link, verified, undelete, "label", label_x, label_y, label_rotation, label_quadrant, publish, inventory, num_value, pjoint_id, pjoint_type, adate, adescript, accessibility, asset_id, dma_style, presszone_style, priority, valve_location, valve_type, shutoff_valve, access_type, placement_type, om_state, conserv_state, expl_id2, is_operative, plot_code, brand_id, model_id, serial_number, cat_valve, minsector_id, macrominsector_id, demand_base, press_max, press_min, press_avg, quality_max, quality_min, quality_avg, tstamp, insert_user, lastupdate, lastupdate_user, the_geom, demand_max, demand_min, demand_avg)
VALUES('-901', 38.0963, NULL, 'WJOIN', 'WJOIN', 'PVC25-PN16-DOM', 'PVC', '16', '25', 25.00000, 'JUNCTION', 'JUNCTION', 1, 2, 1, 1, 3, '3', NULL, 71.75, 2, NULL, NULL, 1, NULL, NULL, NULL, NULL, 'cc3279', NULL, NULL, '2031', NULL, NULL, NULL, 33.654, 'soil1', 'St. Function', 'St. Category', 'St. Fluid', 'St. Location', 'work2', NULL, NULL, '1993-09-02', NULL, 'owner1', 1, '08830', 1, 'Salvador Seguí, C. de', 58, '58', NULL, NULL, NULL, 1, 1, NULL, NULL, 2.564, 'https://www.giswater.org', '0', NULL, NULL, '5', NULL, 2.564, NULL, true, true, NULL, '2031', 'ARC', NULL, NULL, NULL, NULL, '179,205,227', '204,235,197', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, 113921, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-03-28 17:06:35.000', 'postgres', '2024-02-21 12:08:24.000', 'postgres', 'SRID=25831;POINT (414234.94619056734 4576497.812674751)'::public.geometry, NULL, NULL, NULL);
SELECT is((SELECT count(*)::integer FROM v_edit_connec WHERE code = '-901'), 1, 'INSERT: v_edit_connec -901 was inserted');
SELECT is((SELECT count(*)::integer FROM connec WHERE code = '-901'), 1, 'INSERT: connec -901 was inserted');


UPDATE v_edit_connec SET descript = 'updated descript' WHERE code = '-901';
SELECT is((SELECT descript FROM v_edit_connec WHERE code = '-901'), 'updated descript', 'UPDATE: v_edit_connec -901 was updated');
SELECT is((SELECT descript FROM connec WHERE code = '-901'), 'updated descript', 'UPDATE: connec -901 was updated');


DELETE FROM v_edit_connec WHERE code = '-901';
SELECT is((SELECT count(*)::integer FROM v_edit_connec WHERE code = '-901'), 0, 'DELETE: v_edit_connec -901 was deleted');
SELECT is((SELECT count(*)::integer FROM connec WHERE code = '-901'), 0, 'DELETE: connec -901 was deleted');


SELECT * FROM finish();

ROLLBACK;