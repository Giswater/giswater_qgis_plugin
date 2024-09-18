/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE doc ADD the_geom public.geometry(point, SRID_VALUE) NULL;
ALTER TABLE doc ADD name varchar(30) NULL;
ALTER TABLE doc ADD CONSTRAINT name_chk UNIQUE ("name");


--25/07/2024
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"addparam", "dataType":"json"}}$$);

--26/07/2024
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"expl_id_", "dataType":"int[]"}}$$);

UPDATE rpt_cat_result SET expl_id_ = ARRAY[expl_id];

DROP VIEW v_ui_rpt_cat_result;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"expl_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"rpt_cat_result", "column":"expl_id_", "newName":"expl_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"network_type", "dataType":"text"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"sector_id", "dataType":"int[]"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"descript", "dataType":"text"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_anlgraph", "column":"cur_user", "dataType":"text"}}$$);

ALTER TABLE temp_anlgraph ALTER COLUMN cur_user SET DEFAULT CURRENT_USER;

-- 08/08/2024
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"uncertain", "dataType":"boolean"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"muni_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"muni_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"sector_id", "dataType":"integer"}}$$);
ALTER TABLE element ALTER COLUMN sector_id set default 0;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"samplepoint", "column":"muni_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"samplepoint", "column":"sector_id", "dataType":"integer"}}$$);
ALTER TABLE samplepoint ALTER COLUMN sector_id set default 0;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit", "column":"muni_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit", "column":"sector_id", "dataType":"integer"}}$$);
ALTER TABLE om_visit ALTER COLUMN sector_id set default 0;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dimensions", "column":"muni_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dimensions", "column":"sector_id", "dataType":"integer"}}$$);
ALTER TABLE dimensions ALTER COLUMN sector_id set default 0;
UPDATE dimensions SET sector_id = 0;


CREATE INDEX arc_muni ON arc USING btree (muni_id);
CREATE INDEX node_muni ON node USING btree (muni_id);
CREATE INDEX connec_muni ON connec USING btree (muni_id);
CREATE INDEX link_muni ON link USING btree (muni_id);
CREATE INDEX element_muni ON element USING btree (muni_id);
CREATE INDEX samplepoint_muni ON samplepoint USING btree (muni_id);
CREATE INDEX element_sector ON element USING btree (sector_id);
CREATE INDEX om_visit_muni ON om_visit USING btree (muni_id);
CREATE INDEX om_visit_sector ON om_visit USING btree (sector_id);
CREATE INDEX dimensions_muni ON dimensions USING btree (muni_id);
CREATE INDEX dimensions_sector ON dimensions USING btree (sector_id);
CREATE INDEX config_param_user_value ON config_param_user USING btree (value);
CREATE INDEX config_param_user_cur_user ON config_param_user USING btree (cur_user);

ALTER TABLE sys_table DROP CONSTRAINT sys_table_style_id_fkey;

ALTER TABLE sys_style RENAME TO _sys_style_;
ALTER TABLE "_sys_style_" DROP CONSTRAINT sys_style_pkey;

CREATE TABLE sys_style (
  layername text NOT NULL,
  styleconfig_id integer NULL,
  styletype character varying(30),
  stylevalue text,
  active boolean DEFAULT true);

INSERT INTO sys_style SELECT idval, NULL, styletype, stylevalue, active FROM _sys_style_;

CREATE TABLE config_style (
	id integer NOT NULL,
	idval text NOT NULL,
	descript text NULL,
	sys_role varchar(30) NULL,
	addparam json NULL,
    is_templayer bool DEFAULT false NULL,
	active bool DEFAULT true NULL,
	CONSTRAINT config_style_pkey PRIMARY KEY (id));

do $$
declare
    v_utils boolean;
begin
     SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	 if v_utils is true then

		-- create fk
		ALTER TABLE SCHEMA_NAME.link ADD CONSTRAINT link_muni_id_fkey FOREIGN KEY (muni_id)
		REFERENCES utils.municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

		ALTER TABLE SCHEMA_NAME.samplepoint ADD CONSTRAINT samplepoint_muni_id_fkey FOREIGN KEY (muni_id)
		REFERENCES utils.municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

	 	ALTER TABLE SCHEMA_NAME.element ADD CONSTRAINT element_muni_id_fkey FOREIGN KEY (muni_id)
		REFERENCES utils.municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

		ALTER TABLE SCHEMA_NAME.om_visit ADD CONSTRAINT om_visit_muni_id_fkey FOREIGN KEY (muni_id)
		REFERENCES utils.municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

		ALTER TABLE SCHEMA_NAME.dimensions ADD CONSTRAINT dimensions_muni_id_fkey FOREIGN KEY (muni_id)
		REFERENCES utils.municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

     else

		-- create fk
		ALTER TABLE SCHEMA_NAME.link ADD CONSTRAINT link_muni_id_fkey FOREIGN KEY (muni_id)
		REFERENCES SCHEMA_NAME.ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

		ALTER TABLE SCHEMA_NAME.samplepoint ADD CONSTRAINT samplepoint_muni_id_fkey FOREIGN KEY (muni_id)
		REFERENCES SCHEMA_NAME.ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

	 	ALTER TABLE SCHEMA_NAME.element ADD CONSTRAINT element_muni_id_fkey FOREIGN KEY (muni_id)
		REFERENCES SCHEMA_NAME.ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

		ALTER TABLE SCHEMA_NAME.om_visit ADD CONSTRAINT om_visit_muni_id_fkey FOREIGN KEY (muni_id)
		REFERENCES SCHEMA_NAME.ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

		ALTER TABLE SCHEMA_NAME.dimensions ADD CONSTRAINT dimensions_muni_id_fkey FOREIGN KEY (muni_id)
		REFERENCES SCHEMA_NAME.ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

	 end if;
end; $$;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_table", "column":"style_id"}}$$);
