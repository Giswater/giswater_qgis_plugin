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

-- error one or more connections are closer than the configured minimum distance

INSERT INTO v_edit_gully (code, top_elev, ymax, sandbox, matcat_id, gully_type, sys_type, gullycat_id, cat_gully_matcat, units, groove, groove_height, groove_length, siphon, connec_arccat_id, connec_length, connec_depth, connec_matcat_id, connec_y1, connec_y2, grate_width, grate_length, arc_id, epa_type, inp_type, state, state_type, expl_id, macroexpl_id, sector_id, sector_type, macrosector_id, drainzone_id, drainzone_type, dma_id, macrodma_id, annotation, observ, "comment", soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, workcat_id_plan, buildercat_id, builtdate, enddate, ownercat_id, muni_id, postcode, district_id, streetname, postnumber, postcomplement, streetname2, postnumber2, postcomplement2, region_id, province_id, descript, svg, rotation, link, verified, undelete, "label", label_x, label_y, label_rotation, label_quadrant, publish, inventory, uncertain, num_value, pjoint_id, pjoint_type, asset_id, gullycat2_id, units_placement, expl_id2, is_operative, minsector_id, macrominsector_id, adate, adescript, siphon_type, odorflap, placement_type, access_type, tstamp, insert_user, lastupdate, lastupdate_user, the_geom)
VALUES('-901', 40.8700, 0.8000, 0.0000, 'Concret', 'GULLY', 'GULLY', 'SGRT3', 'FD', 1.00, false, NULL, NULL, false, 'PVC-CC025_D', 7.078, 1.200, 'Concret', 40.0700, NULL, 30.0000, 64.0000, '177', 'GULLY', NULL, 1, 2, 1, 1, 1, NULL, 1, 1, NULL, 1, NULL, NULL, NULL, NULL, 'soil1', 'St. Function', 'St. Category', 'St. Fluid', 'St. Location', 'work1', NULL, NULL, 'builder1', '2008-10-04', NULL, 'owner1', 1, '08830', 1, 'Aragó, Av. de', NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, 'https://www.giswater.org', '0', NULL, NULL, NULL, NULL, NULL, NULL, true, true, false, NULL, '177', 'ARC', NULL, NULL, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-09-05 15:42:47.000', 'postgres', NULL, NULL, 'SRID=25831;POINT (429089.6348767015 4576325.2010902)'::public.geometry);



SELECT is((SELECT count(*)::integer FROM v_edit_gully WHERE code = '-901'), 1, 'INSERT: v_edit_gully -901 was inserted');
SELECT is((SELECT count(*)::integer FROM gully WHERE code = '-901'), 1, 'INSERT: gully -901 was inserted');

UPDATE v_edit_gully SET observ = 'updated observ' WHERE code = '-901';
SELECT is((SELECT observ FROM v_edit_gully WHERE code = '-901'), 'updated observ', 'UPDATE: v_edit_gully -901 was updated');
SELECT is((SELECT observ FROM gully WHERE code = '-901'), 'updated observ', 'UPDATE: gully -901 was updated');

DELETE FROM v_edit_gully WHERE code = '-901';
SELECT is((SELECT count(*)::integer FROM v_edit_gully WHERE code = '-901'), 0, 'DELETE: v_edit_gully -901 was deleted');
SELECT is((SELECT count(*)::integer FROM gully WHERE code = '-901'), 0, 'DELETE: gully -901 was deleted');


SELECT * FROM finish();


ROLLBACK;