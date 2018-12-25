/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP
ALTER TABLE anl_mincut_result_polygon ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE anl_mincut_result_polygon ALTER COLUMN polygon_id DROP NOT NULL;

ALTER TABLE anl_mincut_result_node ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE anl_mincut_result_node ALTER COLUMN node_id DROP NOT NULL;

ALTER TABLE anl_mincut_result_arc ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE anl_mincut_result_arc ALTER COLUMN arc_id DROP NOT NULL;

ALTER TABLE anl_mincut_result_connec ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE anl_mincut_result_connec ALTER COLUMN connec_id DROP NOT NULL;

ALTER TABLE anl_mincut_result_hydrometer ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE anl_mincut_result_hydrometer ALTER COLUMN hydrometer_id DROP NOT NULL;

ALTER TABLE anl_mincut_result_valve_unaccess ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE anl_mincut_result_valve_unaccess ALTER COLUMN node_id DROP NOT NULL;

ALTER TABLE anl_mincut_result_valve ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE anl_mincut_result_valve ALTER COLUMN node_id DROP NOT NULL;

ALTER TABLE anl_mincut_result_selector ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE anl_mincut_result_selector ALTER COLUMN cur_user DROP NOT NULL;


--SET
ALTER TABLE anl_mincut_result_polygon ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE anl_mincut_result_polygon ALTER COLUMN polygon_id SET NOT NULL;

ALTER TABLE anl_mincut_result_node ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE anl_mincut_result_node ALTER COLUMN node_id SET NOT NULL;

ALTER TABLE anl_mincut_result_arc ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE anl_mincut_result_arc ALTER COLUMN arc_id SET NOT NULL;

ALTER TABLE anl_mincut_result_connec ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE anl_mincut_result_connec ALTER COLUMN connec_id SET NOT NULL;

ALTER TABLE anl_mincut_result_hydrometer ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE anl_mincut_result_hydrometer ALTER COLUMN hydrometer_id SET NOT NULL;

ALTER TABLE anl_mincut_result_valve_unaccess ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE anl_mincut_result_valve_unaccess ALTER COLUMN node_id SET NOT NULL;

ALTER TABLE anl_mincut_result_valve ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE anl_mincut_result_valve ALTER COLUMN node_id SET NOT NULL;

ALTER TABLE anl_mincut_result_selector ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE anl_mincut_result_selector ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE anl_mincut_inlet_x_exploitation ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE anl_mincut_inlet_x_exploitation ALTER COLUMN expl_id SET NOT NULL;
