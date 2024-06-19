/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TABLE _inp_shortpipe_ AS SELECT * FROM inp_shortpipe;

INSERT INTO config_graph_checkvalve SELECT node_id, to_arc 
FROM inp_shortpipe WHERE to_arc IS NOT NULL
ON CONFLICT (node_id) DO NOTHING;

ALTER TABLE IF EXISTS config_graph_inlet RENAME TO config_graph_mincut;

ALTER TABLE config_graph_mincut DROP CONSTRAINT config_graph_inlet_pkey;
ALTER TABLE config_graph_mincut ADD CONSTRAINT config_graph_mincut_pkey PRIMARY KEY (node_id);
ALTER TABLE config_graph_mincut DROP CONSTRAINT config_graph_inlet_expl_id_fkey;
ALTER TABLE config_graph_mincut DROP COLUMN expl_id;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dqa", "column":"avg_press", "dataType":"float"}}$$);
