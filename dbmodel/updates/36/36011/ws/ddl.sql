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
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"presszone", "column":"presszone_type", "dataType":"text"}}$$);
ALTER TABLE presszone ADD CONSTRAINT presszone_presszone_type_check CHECK (presszone_type::text=ANY 
(ARRAY['buster', 'tank', 'reductora', 'bomba']));

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_presszone", "column":"presszone_type", "dataType":"text"}}$$);
ALTER TABLE plan_netscenario_presszone ADD CONSTRAINT plan_netscenario_presszone_presszone_type_check CHECK (presszone_type::text=ANY 
(ARRAY['buster', 'tank', 'reductora', 'bomba']));

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_dma", "column":"stylesheet", "dataType":"json"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_presszone", "column":"stylesheet", "dataType":"json"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"expl_id2", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dqa", "column":"expl_id2", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"expl_id2", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"presszone", "column":"expl_id2", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_dma", "column":"expl_id2", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_presszone", "column":"expl_id2", "dataType":"text"}}$$);
