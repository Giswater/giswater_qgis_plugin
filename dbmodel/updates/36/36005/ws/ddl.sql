/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;


DROP FUNCTION IF EXISTS gw_fct_pg2epa_check_nodarc;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_dma", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE plan_netscenario_dma ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_presszone", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE plan_netscenario_presszone ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_presszone", "column":"lastupdate", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_presszone", "column":"lastupdate_user", "dataType":"character varying(30)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_dma", "column":"lastupdate", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_dma", "column":"lastupdate_user", "dataType":"character varying(30)", "isUtils":"False"}}$$);

CREATE TABLE plan_netscenario_valve (
netscenario_id integer, 
node_id character varying(16),
closed boolean  DEFAULT false,
CONSTRAINT plan_netscenario_valve_pkey PRIMARY KEY (netscenario_id, node_id)); 

