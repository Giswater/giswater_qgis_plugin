/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/22

ALTER TABLE IF EXISTS minsector_graf RENAME TO minsector_graph;

ALTER TABLE cat_feature_node RENAME CONSTRAINT node_type_graf_delimiter_check TO node_type_graph_delimiter_check;
ALTER TABLE config_graph_inlet RENAME CONSTRAINT config_graf_inlet_pkey TO config_graph_inlet_pkey;
ALTER TABLE minsector_graph RENAME CONSTRAINT minsector_graf_pkey TO minsector_graph_pkey;
ALTER TABLE config_graph_inlet RENAME CONSTRAINT config_graf_inlet_expl_id_fkey TO config_graph_inlet_expl_id_fkey;
ALTER TABLE config_graph_inlet RENAME CONSTRAINT config_graf_inlet_node_id_fkey TO config_graph_inlet_node_id_fkey;

