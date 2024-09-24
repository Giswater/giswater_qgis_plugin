/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- to change presszone_id::varchar to presszone_id::integer
-- drop foreign key
ALTER TABLE arc DROP CONSTRAINT arc_presszonecat_id_fkey;
ALTER TABLE node DROP CONSTRAINT node_presszonecat_id_fkey;
ALTER TABLE connec DROP CONSTRAINT connec_presszonecat_id_fkey;

ALTER TABLE minsector DROP CONSTRAINT minsector_presszonecat_id_fkey;
ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_presszonecat_id_fkey;

ALTER TABLE plan_netscenario_presszone DROP CONSTRAINT plan_netscenario_presszone_netscenario_id_fkey;
ALTER TABLE plan_netscenario_arc DROP CONSTRAINT plan_netscenario_arc_netscenario_id_presszone_id_fkey;
ALTER TABLE plan_netscenario_node DROP CONSTRAINT plan_netscenario_node_netscenario_id_presszone_id_fkey;
ALTER TABLE plan_netscenario_connec DROP CONSTRAINT plan_netscenario_connec_netscenario_id_presszone_id_fkey;

-- drop triggers
DROP TRIGGER IF EXISTS gw_trg_presszone_check_datatype ON presszone;
DROP TRIGGER IF EXISTS gw_trg_presszone_check_datatype ON plan_netscenario_presszone;

-- drop rules
DROP RULE IF EXISTS presszone_conflict ON presszone;
DROP RULE IF EXISTS presszone_del_uconflict ON presszone;
DROP RULE IF EXISTS presszone_del_undefined ON presszone;
DROP RULE IF EXISTS presszone_undefined ON presszone;

-- change presszone_id to integer arc/node/connec/link/presszone/plan_netscenario_presszone
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"arc", "column":"presszone_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"node", "column":"presszone_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"connec", "column":"presszone_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"link", "column":"presszone_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"presszone", "column":"presszone_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"plan_netscenario_presszone", "column":"presszone_id", "dataType":"integer"}}$$);
