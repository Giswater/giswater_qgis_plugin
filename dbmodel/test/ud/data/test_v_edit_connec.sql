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


INSERT INTO v_edit_connec (code, sys_code, customer_code, top_elev, y1, y2, conneccat_id, connec_type, sys_type, matcat_id, state, state_type, expl_id, macroexpl_id, sector_id, sector_type, macrosector_id, drainzone_id, drainzone_type, demand, connec_depth, connec_length, arc_id, annotation, observ, "comment", omzone_id, macroomzone_id, omzone_type, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, district_id, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, region_id, province_id, descript, svg, rotation, link, verified, "label", label_x, label_y, label_rotation, label_quadrant, accessibility, diagonal, publish, inventory, uncertain, num_value, pjoint_id, pjoint_type, created_at, created_by, updated_at, updated_by, the_geom, workcat_id_plan, asset_id, is_operative, minsector_id, adate, adescript, plot_code, placement_type, access_type)
VALUES('-901', '-901', null, 55.2583, 2.1380, 1.7380, 'CC025_D', 'CJOIN', 'CONNEC', 'PVC', 1, 2, 1, 1, 1, NULL, 1, 1, NULL, NULL, 1.938, 17.979, '171', NULL, NULL, NULL, 1, NULL, NULL, 'soil1', 'St. Function', 'St. Category', 0, 'St. Location', NULL, NULL, '2013-05-14', NULL, 'owner1', 1, '08830', 1, '1-9100C', 106, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, -56.687, 'https://www.giswater.org', '0', NULL, '5', NULL, -56.687, NULL, NULL, NULL, NULL, true, NULL, NULL, '171', 'ARC', '2021-09-05 15:42:47.000', 'postgres', NULL, NULL, 'SRID=25831;POINT (418802.5740642579 4576477.885736115)'::public.geometry, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL);

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