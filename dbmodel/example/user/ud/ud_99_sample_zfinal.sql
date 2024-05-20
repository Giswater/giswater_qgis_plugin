/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = 'SCHEMA_NAME', public, pg_catalog;


INSERT INTO selector_sector SELECT sector_id, current_user from sector where sector_id > 0 ON CONFLICT (sector_id, cur_user) DO NOTHING;
DELETE FROM selector_psector;

INSERT INTO cat_node (id, matcat_id, shape, geom1, geom2, geom3, descript, link, brand, model, svg, estimated_y, cost_unit, "cost", active, "label", node_type, acoeff) VALUES('CHANGE_1', NULL, NULL, 1.00, 1.00, NULL, 'Change', NULL, NULL, NULL, NULL, 2.00, 'u', NULL, true, NULL, 'CHANGE', NULL);
INSERT INTO cat_node (id, matcat_id, shape, geom1, geom2, geom3, descript, link, brand, model, svg, estimated_y, cost_unit, "cost", active, "label", node_type, acoeff) VALUES('OWERFLOW_STORAGE_1', NULL, NULL, 1.00, 1.00, NULL, 'Overflow storage', NULL, NULL, NULL, NULL, 2.00, 'u', NULL, true, NULL, 'OWERFLOW_STORAGE', NULL);
INSERT INTO cat_node (id, matcat_id, shape, geom1, geom2, geom3, descript, link, brand, model, svg, estimated_y, cost_unit, "cost", active, "label", node_type, acoeff) VALUES('SANDBOX_1', NULL, NULL, 1.00, 1.00, NULL, 'Sandbox', NULL, NULL, NULL, NULL, 2.00, 'u', NULL, true, NULL, 'SANDBOX', NULL);
INSERT INTO cat_node (id, matcat_id, shape, geom1, geom2, geom3, descript, link, brand, model, svg, estimated_y, cost_unit, "cost", active, "label", node_type, acoeff) VALUES('PUMP_STATION', NULL, NULL, 1.00, 1.00, NULL, 'Pump station', NULL, NULL, NULL, NULL, 2.00, 'u', NULL, true, NULL, 'PUMP_STATION', NULL);

INSERT INTO cat_grate (id, matcat_id, length, width, total_area, effective_area, n_barr_l, n_barr_w, n_barr_diag, a_param, b_param, descript, link, brand, model, svg, active, "label", gully_type) VALUES('PGULLY', 'FD', 50.0000, 25.0000, 860.0000, 400.0000, 3.0000, 1.0000, 0.0000, 0.3485, 0.6580, NULL, NULL, NULL, NULL, NULL, true, NULL, 'PGULLY');

UPDATE om_visit SET startdate = startdate -  random() * (startdate - timestamp '2022-01-01 10:00:00');
UPDATE om_visit SET enddate = startdate;

UPDATE arc SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');
UPDATE node SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');
UPDATE connec SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');
UPDATE gully SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');
UPDATE link SET builtdate = c.builtdate FROM connec c WHERE feature_id = connec_id;
UPDATE link SET builtdate = g.builtdate FROM gully g WHERE feature_id = gully_id;
UPDATE element SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');

UPDATE config_param_system SET value = '{"setArcObsolete":"true","setOldCode":"false"}' WHERE parameter = 'edit_arc_divide';

UPDATE cat_arc SET geom2 = null WHERE id = 'EG150';