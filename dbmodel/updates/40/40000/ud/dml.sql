/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 15/10/2024
INSERT INTO cat_arc (id, arc_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1, z2, width, area, estimated_depth, bulk, cost_unit, "cost", m2bottom_cost, m3protec_cost, active, "label", tsect_id, curve_id, acoeff, connect_cost, visitability_vdef)
SELECT id, arc_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1, z2, width, area, estimated_depth, bulk, cost_unit, "cost", m2bottom_cost, m3protec_cost, active, "label", tsect_id, curve_id, acoeff, connect_cost, visitability_vdef
FROM _cat_arc;

INSERT INTO cat_node (id, node_type, matcat_id, shape, geom1, geom2, geom3, descript, link, brand, model, svg, estimated_y, cost_unit, "cost", active, "label", acoeff)
SELECT id, node_type, matcat_id, shape, geom1, geom2, geom3, descript, link, brand, model, svg, estimated_y, cost_unit, "cost", active, "label", acoeff
FROM _cat_node;

INSERT INTO cat_connec (id, connec_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom_r, descript, link, brand, model, svg, active, "label")
SELECT id, connec_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom_r, descript, link, brand, model, svg, active, "label"
FROM _cat_connec;

INSERT INTO cat_grate (id, gully_type, matcat_id, length, width, total_area, effective_area, n_barr_l, n_barr_w, n_barr_diag, a_param, b_param, descript, link, brand, model, svg, active, "label")
SELECT id, gully_type, matcat_id, length, width, total_area, effective_area, n_barr_l, n_barr_w, n_barr_diag, a_param, b_param, descript, link, brand, model, svg, active, "label"
FROM _cat_grate;
