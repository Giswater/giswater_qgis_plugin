/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/28
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"nodetype_1", "dataType":"character varying(30)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"elevation1", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"depth1", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"staticpress1", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"nodetype_2", "dataType":"character varying(30)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"elevation2", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"depth2", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"staticpress2", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);

ALTER TABLE arc_add RENAME to _arc_add_;
ALTER TABLE _arc_add_ DROP CONSTRAINT arc_add_pkey;
ALTER TABLE _arc_add_ DROP CONSTRAINT arc_add_arc_id_fkey;

CREATE TABLE arc_add 
(arc_id character varying(16) NOT NULl PRIMARY KEY, 
flow_max numeric(12,2), 
flow_min numeric(12,2), 
flow_avg numeric(12,2), 
vel_max numeric(12,2), 
vel_min numeric(12,2), 
vel_avg numeric(12,2));

ALTER TABLE node_add RENAME to _node_add_;
ALTER TABLE _node_add_ DROP CONSTRAINT node_add_pkey;
ALTER TABLE _node_add_ DROP CONSTRAINT node_add_node_id_fkey;

CREATE TABLE node_add 
(node_id character varying(16) NOT NULl PRIMARY KEY, 
demand_max numeric(12,2), 
demand_min numeric(12,2), 
demand_avg numeric(12,2), 
press_max numeric(12,2), 
press_min numeric(12,2),
press_avg numeric(12,2), 
head_max numeric(12,2),
head_min numeric(12,2),
head_avg numeric(12,2),
quality_max numeric(12,2),
quality_min numeric(12,2),
quality_avg numeric(12,2));


ALTER TABLE connec_add RENAME to _connec_add_;
ALTER TABLE _connec_add_ DROP CONSTRAINT connec_add_pkey;
ALTER TABLE _connec_add_ DROP CONSTRAINT connec_add_connec_id_fkey;

CREATE TABLE connec_add 
(connec_id character varying(16) NOT NULl PRIMARY KEY, 
press_max numeric(12,2), 
press_min numeric(12,2),
press_avg numeric(12,2));



