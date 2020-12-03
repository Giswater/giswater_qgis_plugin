/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE anl_mincut_result_arc DROP CONSTRAINT IF EXISTS anl_mincut_result_arc_unique_result_arc;
ALTER TABLE anl_mincut_result_arc ADD CONSTRAINT anl_mincut_result_arc_unique_result_arc UNIQUE (result_id, arc_id);

ALTER TABLE anl_mincut_result_node DROP CONSTRAINT IF EXISTS anl_mincut_result_arc_unique_result_node;
ALTER TABLE anl_mincut_result_node ADD CONSTRAINT anl_mincut_result_arc_unique_result_node UNIQUE (result_id, node_id);

ALTER TABLE anl_mincut_result_connec DROP CONSTRAINT IF EXISTS anl_mincut_result_connec_unique_result_connec;
ALTER TABLE anl_mincut_result_connec ADD CONSTRAINT anl_mincut_result_connec_unique_result_connec UNIQUE (result_id, connec_id);

ALTER TABLE anl_mincut_result_valve DROP CONSTRAINT IF EXISTS anl_mincut_result_valve_unique_result_node;
ALTER TABLE anl_mincut_result_valve ADD CONSTRAINT anl_mincut_result_valve_unique_result_node UNIQUE (result_id, node_id);

ALTER TABLE anl_mincut_result_hydrometer DROP CONSTRAINT IF EXISTS anl_mincut_result_hydrometer_unique_result_hydrometer;
ALTER TABLE anl_mincut_result_hydrometer ADD CONSTRAINT anl_mincut_result_hydrometer_unique_result_hydrometer UNIQUE (result_id, hydrometer_id);

