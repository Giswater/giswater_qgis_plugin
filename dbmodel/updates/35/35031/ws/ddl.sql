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
press_avg numeric(12,2),
demand numeric(12,2));


SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_virtualvalve", "column":"to_arc", "newName":"_to_arc_"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"presszone_id", "dataType":"varchar(16)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"dqa_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"minsector_id", "dataType":"integer", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"link", "column":"vnode_elevation", "newName":"exit_elev"}}$$);


-- change pjoint_type (VNODE to ARC)
ALTER TABLE connec DROP CONSTRAINT connec_pjoint_type_ckeck;
UPDATE connec SET pjoint_id = arc_id, pjoint_type = 'ARC' WHERE  pjoint_type = 'VNODE';
UPDATE link SET exit_id = arc_id, exit_type = 'ARC' FROM connec WHERE feature_id = connec_id and exit_type = 'VNODE';
ALTER TABLE connec ADD CONSTRAINT connec_pjoint_type_ckeck CHECK (pjoint_type::text = ANY  (ARRAY['NODE', 'ARC', 'CONNEC']));

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_valve", "column":"valve_type", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wjoin", "column":"wjoin_type", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_greentap", "column":"greentap_type", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_greentap", "column":"cat_valve", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_hydrant", "column":"hydrant_type", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"om_state", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"conserv_state", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"om_state", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"conserv_state", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"om_state", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"conserv_state", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"priority", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"valve_location", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"valve_type", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"shutoff_valve", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"access_type", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"placement_type", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"access_type", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"placement_type", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"crmzone_id", "dataType":"integer", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"crm_zone", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE crm_zone ALTER COLUMN active SET DEFAULT TRUE;