/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/04/06
CREATE TABLE IF NOT EXISTS inp_dscenario_controls
(id serial NOT NULL PRIMARY KEY,
dscenario_id integer NOT NULL,
sector_id integer NOT NULL,
text text NOT NULL,
active boolean);

ALTER TABLE inp_dscenario_controls ADD CONSTRAINT inp_dscenario_controls_sector_id_fkey FOREIGN KEY (sector_id)
REFERENCES sector (sector_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_controls ADD CONSTRAINT inp_dscenario_controls_dscenario_id_fkey FOREIGN KEY (dscenario_id)
REFERENCES cat_dscenario (dscenario_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_table", "column":"expl_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_table", "column":"macroexpl_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_table", "column":"sector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_table", "column":"macrosector_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_anlgraf", "column":"orderby", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_report", "column":"descript", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_report", "column":"active", "dataType":"boolean"}}$$);

ALTER TABLE config_report ALTER COLUMN active SET DEFAULT true;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_data", "column":"float_value", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_data", "column":"int_value", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_data", "column":"flag", "dataType":"boolean"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_fprocess", "column":"addparam", "dataType":"json"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_fprocess", "column":"active", "dataType":"boolean"}}$$);


CREATE INDEX IF NOT EXISTS temp_data_feature_id ON temp_data
 USING btree (feature_id);
  
CREATE INDEX IF NOT EXISTS temp_data_feature_type ON temp_data
  USING btree (feature_type);

CREATE INDEX IF NOT EXISTS plan_psector_x_arc_arc_id ON plan_psector_x_arc
  USING btree (arc_id);

CREATE INDEX IF NOT EXISTS plan_psector_x_node_node_id ON plan_psector_x_node
  USING btree (node_id);

CREATE INDEX IF NOT EXISTS plan_psector_x_connec_connec_id ON plan_psector_x_connec
  USING btree (connec_id);

CREATE INDEX IF NOT EXISTS plan_psector_x_arc_state ON plan_psector_x_arc
  USING btree (state);

CREATE INDEX IF NOT EXISTS plan_psector_x_node_state ON plan_psector_x_node
  USING btree (state);

CREATE INDEX IF NOT EXISTS plan_psector_x_connec_state ON plan_psector_x_connec
  USING btree (state);

CREATE INDEX IF NOT EXISTS plan_psector_x_arc_psector_id ON plan_psector_x_arc
  USING btree (psector_id);

CREATE INDEX IF NOT EXISTS plan_psector_x_node_psector_id ON plan_psector_x_node
  USING btree (psector_id);

CREATE INDEX IF NOT EXISTS plan_psector_x_connec_psector_id ON plan_psector_x_connec
  USING btree (psector_id);

CREATE INDEX IF NOT EXISTS plan_psector_x_connec_arc_id ON plan_psector_x_connec
  USING btree (arc_id);