/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/08/30
ALTER TABLE selector_inp_result ALTER COLUMN cur_user SET DEFAULT "current_user"();
ALTER TABLE selector_plan_psector ALTER COLUMN cur_user SET DEFAULT "current_user"();
ALTER TABLE selector_plan_result ALTER COLUMN cur_user SET DEFAULT "current_user"();
ALTER TABLE selector_rpt_compare ALTER COLUMN cur_user SET DEFAULT "current_user"();
ALTER TABLE selector_rpt_compare_tstep ALTER COLUMN cur_user SET DEFAULT "current_user"();
ALTER TABLE selector_rpt_main ALTER COLUMN cur_user SET DEFAULT "current_user"();
ALTER TABLE selector_rpt_main_tstep ALTER COLUMN cur_user SET DEFAULT "current_user"();
ALTER TABLE selector_sector ALTER COLUMN cur_user SET DEFAULT "current_user"();

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector", "column":"workcat_id", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector", "column":"parent_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_arc", "column":"flag", "dataType":"boolean", "isUtils":"False"}}$$);


DROP TRIGGER IF EXISTS gw_trg_notify ON vnode;
DROP TRIGGER IF EXISTS gw_trg_vnode_update ON vnode;
DROP FUNCTION IF EXISTS gw_trg_vnode_update();

UPDATE sys_table SET notify_action = null where id = 'vnode';

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_manager", "column":"sector_id", "dataType":"integer[]", "isUtils":"False"}}$$);

CREATE TABLE config_user_x_sector (
  sector_id integer NOT NULL,
  username character varying(50) NOT NULL,
  manager_id integer,
  active boolean DEFAULT true,
  CONSTRAINT config_user_x_sector_pkey PRIMARY KEY (sector_id, username),
  CONSTRAINT config_user_x_sector_sector_id_fkey FOREIGN KEY (sector_id)
      REFERENCES sector (sector_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT config_user_x_sector_manager_id_fkey FOREIGN KEY (manager_id)
      REFERENCES cat_manager (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT config_user_x_sector_username_fkey FOREIGN KEY (username)
      REFERENCES cat_users (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT);

--2021/09/17
CREATE TABLE cat_workspace (
id serial PRIMARY KEY,
name character varying(50),
descript text,
config json,
isautomatic boolean DEFAULT FALSE);
ALTER TABLE cat_workspace ADD CONSTRAINT cat_workspace_unique_name UNIQUE(name);
