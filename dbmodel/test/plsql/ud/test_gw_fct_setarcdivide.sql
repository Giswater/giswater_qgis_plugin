/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for 1 test
SELECT plan(1);

-- initial data is prepared before proceeding with the test
INSERT INTO node (node_id, code, top_elev, ymax, elev, custom_top_elev, custom_ymax, custom_elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, observ, "comment", dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, rotation, link, verified, the_geom, undelete, label_x, label_y, label_rotation, publish, inventory, xyz_date, uncertain, unconnected, expl_id, num_value, feature_type, tstamp, arc_id, lastupdate, lastupdate_user, insert_user, matcat_id, district_id, workcat_id_plan, asset_id, drainzone_id, parent_id, expl_id2, adate, adescript, hemisphere, placement_type)
VALUES('-901', '-901', 43.810, NULL, NULL, NULL, NULL, NULL, 'CHAMBER', 'CHAMBER-01', 'STORAGE', 1, 1, 2, NULL, NULL, NULL, 1, 'soil1', NULL, NULL, NULL, NULL, 'work1', NULL, NULL, '2024-08-21', NULL, 'owner1', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '1', 'SRID=25831;POINT (419178.51934327977 4576785.174134543)'::public.geometry, NULL, NULL, NULL, NULL, true, true, NULL, false, false, 1, NULL, 'NODE', '2024-08-21 15:27:00.827', NULL, '2024-08-21 15:19:33.000', 'postgres', 'postgres', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO node (node_id, code, top_elev, ymax, elev, custom_top_elev, custom_ymax, custom_elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, observ, "comment", dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, rotation, link, verified, the_geom, undelete, label_x, label_y, label_rotation, publish, inventory, xyz_date, uncertain, unconnected, expl_id, num_value, feature_type, tstamp, arc_id, lastupdate, lastupdate_user, insert_user, matcat_id, district_id, workcat_id_plan, asset_id, drainzone_id, parent_id, expl_id2, adate, adescript, hemisphere, placement_type)
VALUES('-902', '-902', 43.810, NULL, NULL, NULL, NULL, NULL, 'CHAMBER', 'CHAMBER-01', 'STORAGE', 1, 1, 2, NULL, NULL, NULL, 1, 'soil1', NULL, NULL, NULL, NULL, 'work1', NULL, NULL, '2024-08-21', NULL, 'owner1', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '1', 'SRID=25831;POINT (419179.1158701493 4576785.631744197)'::public.geometry, NULL, NULL, NULL, NULL, true, true, NULL, false, false, 1, NULL, 'NODE', '2024-08-21 15:27:00.827', NULL, '2024-08-21 15:19:39.000', 'postgres', 'postgres', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO node (node_id, code, top_elev, ymax, elev, custom_top_elev, custom_ymax, custom_elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, observ, "comment", dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, rotation, link, verified, the_geom, undelete, label_x, label_y, label_rotation, publish, inventory, xyz_date, uncertain, unconnected, expl_id, num_value, feature_type, tstamp, arc_id, lastupdate, lastupdate_user, insert_user, matcat_id, district_id, workcat_id_plan, asset_id, drainzone_id, parent_id, expl_id2, adate, adescript, hemisphere, placement_type)
VALUES('-903', '-903', 43.810, NULL, NULL, NULL, NULL, NULL, 'CHAMBER', 'CHAMBER-01', 'STORAGE', 1, 1, 2, NULL, NULL, NULL, 1, 'soil1', NULL, NULL, NULL, NULL, 'work1', NULL, NULL, '2024-08-21', NULL, 'owner1', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '1', 'SRID=25831;POINT (419178.790046 4576785.38173)'::public.geometry, NULL, NULL, NULL, NULL, true, true, NULL, false, false, 1, NULL, 'NODE', '2024-08-21 15:27:00.827', NULL, '2024-08-21 15:19:43.000', 'postgres', 'postgres', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO ve_arc_conduit (arc_id, code, node_1, nodetype_1, y1, custom_y1, elev1, custom_elev1, sys_elev1, sys_y1, r1, z1, node_2, nodetype_2, y2, custom_y2, elev2, custom_elev2, sys_elev2, sys_y2, r2, z2, slope, arc_type, sys_type, arccat_id, matcat_id, cat_shape, cat_geom1, cat_geom2, cat_width, cat_area, epa_type, state, state_type, expl_id, macroexpl_id, sector_id, macrosector_id, drainzone_id, annotation, gis_length, custom_length, inverted_slope, observ, "comment", dma_id, macrodma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, workcat_id_plan, builtdate, enddate, buildercat_id, ownercat_id, muni_id, postcode, district_id, streetname, postnumber, postcomplement, streetname2, postnumber2, postcomplement2, region_id, province_id, descript, link, verified, undelete, "label", label_x, label_y, label_rotation, publish, inventory, uncertain, num_value, asset_id, pavcat_id, parent_id, expl_id2, is_operative, adate, adescript, visitability, tstamp, insert_user, lastupdate, lastupdate_user, the_geom, inp_type, bottom_mat)
VALUES('-904', '-904', '-902', 'CHAMBER', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '-901', 'CHAMBER', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CONDUIT', 'CONDUIT', 'CC100', NULL, 'CIRCULAR', 1.0000, 0.0000, 1.30, 0.7854, 'CONDUIT', 1, 2, 1, 1, 1, 1, NULL, NULL, 0.75, NULL, false, NULL, NULL, 1, NULL, 'soil1', NULL, NULL, NULL, NULL, 'work1', NULL, NULL, '2024-08-21', NULL, NULL, 'owner1', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '1', NULL, NULL, NULL, NULL, NULL, true, true, false, NULL, NULL, 'Asphalt', NULL, NULL, true, NULL, NULL, 1, '2024-08-21 16:20:55.000', 'postgres', '2024-08-21 16:20:55.000', 'postgres', 'SRID=25831;LINESTRING (419179.1158701493 4576785.631744197, 419178.51934327977 4576785.174134543)'::public.geometry, 'CONDUIT', NULL);

UPDATE node SET the_geom = ST_GeomFromText('POINT(419178.790046 4576785.381730)', 25831) WHERE node_id = '-903';

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_setarcdivide($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"id":["-903"]}, "data":{"filterFields":{}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setarcdivide returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;