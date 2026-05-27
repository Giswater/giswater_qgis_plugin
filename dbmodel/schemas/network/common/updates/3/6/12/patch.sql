/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE doc ADD the_geom public.geometry(point, SRID_VALUE) NULL;
ALTER TABLE doc ADD name varchar(30) NULL;
ALTER TABLE doc ADD CONSTRAINT name_chk UNIQUE ("name");



SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"addparam", "dataType":"json"}}$$);


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


--deprecated
DROP VIEW if EXISTS v_ui_document;

DROP VIEW if EXISTS v_ui_doc;
CREATE OR REPLACE VIEW v_ui_doc
AS SELECT doc.id,
    doc.name,
    doc.observ,
    doc.doc_type,
    doc.path,
    doc.date,
    doc.user_name,
    doc.tstamp
   FROM doc;


DROP VIEW if EXISTS v_ui_doc_x_workcat;
CREATE OR REPLACE VIEW v_ui_doc_x_workcat
AS SELECT doc_x_workcat.id,
    doc_x_workcat.workcat_id,
    doc.name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_workcat
     JOIN doc ON doc.id::text = doc_x_workcat.doc_id::text;

CREATE OR REPLACE VIEW v_ext_municipality AS
SELECT DISTINCT s.muni_id,
    m.name,
    m.active,
    m.the_geom
   FROM v_ext_streetaxis s
     JOIN ext_municipality m USING (muni_id);


DROP VIEW if EXISTS v_ui_doc_x_psector;
CREATE OR REPLACE VIEW v_ui_doc_x_psector AS
SELECT
    doc_x_psector.id,
    plan_psector."name" AS psector_name,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
FROM
    doc_x_psector
JOIN
    doc ON doc.id::text = doc_x_psector.doc_id::text
JOIN
    plan_psector ON plan_psector.psector_id ::text = doc_x_psector.psector_id::text;


DROP VIEW if EXISTS v_ui_doc_x_visit;
CREATE OR REPLACE VIEW v_ui_doc_x_visit
AS SELECT doc_x_visit.id,
    doc_x_visit.visit_id,
    doc. "name" AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_visit
     JOIN doc ON doc.id::text = doc_x_visit.doc_id::text;

DROP VIEW if EXISTS v_ui_doc_x_arc;
CREATE OR REPLACE VIEW v_ui_doc_x_arc
AS SELECT doc_x_arc.id,
    doc_x_arc.arc_id,
    doc."name" AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_arc
     JOIN doc ON doc.id::text = doc_x_arc.doc_id::text;

DROP VIEW if EXISTS v_ui_doc_x_connec;
CREATE OR REPLACE VIEW v_ui_doc_x_connec
AS SELECT doc_x_connec.id,
    doc_x_connec.connec_id,
    doc."name" AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_connec
     JOIN doc ON doc.id::text = doc_x_connec.doc_id::text;

DROP VIEW if EXISTS v_ui_doc_x_node;
CREATE OR REPLACE VIEW v_ui_doc_x_node
AS SELECT doc_x_node.id,
    doc_x_node.node_id,
    doc."name" AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_node
     JOIN doc ON doc.id::text = doc_x_node.doc_id::text;

-- drop depedency views from arc
-----------------------------------
DROP VIEW IF EXISTS v_plan_psector_budget_detail;
DROP VIEW IF EXISTS v_plan_psector_budget_arc;
DROP VIEW IF EXISTS v_plan_psector_budget;
DROP VIEW IF EXISTS v_plan_psector_all;
DROP VIEW IF EXISTS v_plan_current_psector;
DROP VIEW IF EXISTS v_plan_psector_arc;
DROP VIEW IF EXISTS v_plan_psector_connec;
DROP VIEW IF EXISTS v_plan_psector_node;
DROP VIEW IF EXISTS v_plan_psector;
DROP VIEW IF EXISTS v_plan_result_arc;
DROP VIEW IF EXISTS v_ui_plan_arc_cost;

DROP VIEW IF EXISTS v_ui_workcat_x_feature;
DROP VIEW IF EXISTS v_ui_workcat_x_feature_end;
DROP VIEW IF EXISTS v_ui_node_x_connection_downstream;
DROP VIEW IF EXISTS v_ui_node_x_connection_upstream;

DROP VIEW IF EXISTS v_edit_inp_orifice;
DROP VIEW IF EXISTS v_edit_inp_outlet;
DROP VIEW IF EXISTS v_edit_inp_pump;
DROP VIEW IF EXISTS v_edit_inp_virtual;
DROP VIEW IF EXISTS v_edit_inp_weir;

DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_orifice;
DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_pump;
DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_weir;
DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_outlet;
DROP VIEW IF EXISTS v_edit_inp_flwreg_orifice;
DROP VIEW IF EXISTS v_edit_inp_flwreg_pump;
DROP VIEW IF EXISTS v_edit_inp_flwreg_weir;
DROP VIEW IF EXISTS v_edit_inp_flwreg_outlet;

DROP VIEW IF EXISTS v_edit_inp_dscenario_inflows;
DROP VIEW IF EXISTS v_edit_inp_dscenario_inflows_poll;
DROP VIEW IF EXISTS v_edit_inp_dscenario_junction;
DROP VIEW IF EXISTS v_edit_inp_dscenario_treatment;
DROP VIEW IF EXISTS v_edit_inp_dwf;
DROP VIEW IF EXISTS v_edit_inp_inflows;
DROP VIEW IF EXISTS v_edit_inp_inflows_poll;
DROP VIEW IF EXISTS v_edit_inp_treatment;
DROP VIEW IF EXISTS v_edit_inp_junction;

DROP VIEW IF EXISTS v_edit_inp_divider;
DROP VIEW IF EXISTS v_edit_inp_dscenario_outfall;
DROP VIEW IF EXISTS v_edit_inp_outfall;
DROP VIEW IF EXISTS v_edit_inp_dscenario_storage;
DROP VIEW IF EXISTS v_edit_inp_storage;
DROP VIEW IF EXISTS v_edit_inp_netgully;
DROP VIEW IF EXISTS v_edit_man_netelement;
DROP VIEW IF EXISTS v_plan_psector_budget_node;
DROP VIEW IF EXISTS v_plan_result_node;
DROP VIEW IF EXISTS v_ui_plan_node_cost;
DROP VIEW IF EXISTS v_plan_node;
DROP VIEW IF EXISTS ve_pol_chamber;
DROP VIEW IF EXISTS ve_pol_netgully;
DROP VIEW IF EXISTS ve_pol_node;
DROP VIEW IF EXISTS ve_pol_storage;
DROP VIEW IF EXISTS ve_pol_wwtp;
DROP VIEW IF EXISTS vi_coverages;
DROP VIEW IF EXISTS vi_groundwater;

DROP VIEW IF EXISTS v_edit_inp_dscenario_conduit;
DROP VIEW IF EXISTS v_edit_inp_conduit;

DROP VIEW IF EXISTS v_rtc_period_dma;
DROP VIEW IF EXISTS v_rtc_period_node;
DROP VIEW IF EXISTS v_rtc_period_pjoint;
DROP VIEW IF EXISTS v_rtc_period_hydrometer;

DROP VIEW IF EXISTS ve_pol_connec;

DROP VIEW IF EXISTS v_ui_arc_x_relations;
DROP VIEW IF EXISTS v_ui_arc_x_node;
DROP VIEW IF EXISTS v_ui_node_x_relations;

DROP VIEW IF EXISTS v_ui_element;
DROP VIEW IF EXISTS v_ui_element_x_arc;
DROP VIEW IF EXISTS v_ui_element_x_connec;
DROP VIEW IF EXISTS v_ui_element_x_node;
DROP VIEW IF EXISTS ve_pol_element;

DROP VIEW IF EXISTS v_ext_raster_dem;

DROP VIEW IF EXISTS v_plan_arc;
DROP VIEW IF EXISTS v_plan_aux_arc_pavement;

DROP VIEW IF EXISTS vi_parent_dma;
DROP VIEW IF EXISTS vi_parent_arc;
DROP VIEW IF EXISTS vi_parent_hydrometer;
DROP VIEW IF EXISTS vi_parent_connec;

DROP VIEW IF EXISTS v_edit_field_valve;
DROP VIEW IF EXISTS ve_pol_register;
DROP VIEW IF EXISTS ve_pol_tank;
DROP VIEW IF EXISTS ve_pol_fountain;
DROP VIEW IF EXISTS v_edit_inp_dscenario_pump;
DROP VIEW IF EXISTS v_edit_inp_pump_additional;
DROP VIEW IF EXISTS v_edit_inp_dscenario_pump_additional;
DROP VIEW IF EXISTS v_edit_inp_dscenario_shortpipe;
DROP VIEW IF EXISTS v_edit_inp_dscenario_connec;
DROP VIEW IF EXISTS v_edit_inp_connec;
DROP VIEW IF EXISTS v_edit_inp_shortpipe;
DROP VIEW IF EXISTS v_edit_inp_dscenario_tank;
DROP VIEW IF EXISTS v_edit_inp_tank;
DROP VIEW IF EXISTS v_edit_inp_dscenario_reservoir;
DROP VIEW IF EXISTS v_edit_inp_reservoir;
DROP VIEW IF EXISTS v_edit_inp_dscenario_valve;
DROP VIEW IF EXISTS v_edit_inp_valve;
DROP VIEW IF EXISTS v_edit_inp_dscenario_inlet;
DROP VIEW IF EXISTS v_edit_inp_inlet;

DROP VIEW IF EXISTS v_edit_inp_dscenario_virtualvalve;
DROP VIEW IF EXISTS v_edit_inp_dscenario_virtualpump;
DROP VIEW IF EXISTS v_edit_inp_dscenario_pipe;
DROP VIEW IF EXISTS v_edit_inp_virtualvalve;
DROP VIEW IF EXISTS v_edit_inp_virtualpump;
DROP VIEW IF EXISTS v_edit_inp_pipe;

SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-DELETE" }}$$);

DROP VIEW IF EXISTS v_edit_arc;
DROP VIEW IF EXISTS v_edit_node;
DROP VIEW IF EXISTS v_edit_connec;

DROP VIEW IF EXISTS ve_arc CASCADE;
DROP VIEW IF EXISTS v_arc; -- permanently delete
DROP VIEW IF EXISTS vu_arc;

DROP VIEW IF EXISTS ve_node CASCADE;
DROP VIEW IF EXISTS v_node; -- permanently delete
DROP VIEW IF EXISTS vu_node;

DROP VIEW IF EXISTS ve_connec CASCADE;
DROP VIEW IF EXISTS v_connec; -- permanently delete
DROP VIEW IF EXISTS vu_connec;

DROP VIEW IF EXISTS v_om_mincut_hydrometer;

DROP VIEW IF EXISTS v_edit_dma;
DROP VIEW IF EXISTS v_edit_presszone;
DROP VIEW IF EXISTS v_edit_dqa;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"arc", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"node", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"connec", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"anl_arc", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"anl_node", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"audit_arc_traceability", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"audit_psector_arc_traceability", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"audit_psector_node_traceability", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"audit_psector_connec_traceability", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"config_visit_parameter", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_cat_hydrometer_priority", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_cat_hydrometer_type", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_cat_raster", "column":"code", "dataType":"text"}}$$);


CREATE OR REPLACE VIEW v_ext_address AS
	SELECT ext_address.id,
    ext_address.muni_id,
    ext_address.postcode,
    ext_address.streetaxis_id,
    ext_address.postnumber,
    ext_address.plot_id,
    ext_address.expl_id,
    ext_streetaxis.name,
    ext_address.the_geom
	FROM selector_municipality s, ext_address
    LEFT JOIN ext_streetaxis ON ext_streetaxis.id::text = ext_address.streetaxis_id::text
	WHERE ext_address.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_ext_plot AS
	SELECT ext_plot.id,
    ext_plot.plot_code,
    ext_plot.muni_id,
    ext_plot.postcode,
    ext_plot.streetaxis_id,
    ext_plot.postnumber,
    ext_plot.complement,
    ext_plot.placement,
    ext_plot.square,
    ext_plot.observ,
    ext_plot.text,
    ext_plot.the_geom,
    ext_plot.expl_id
	FROM selector_municipality s, ext_plot
	WHERE ext_plot.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_dimensions AS
 SELECT dimensions.id,
    dimensions.distance,
    dimensions.depth,
    dimensions.the_geom,
    dimensions.x_label,
    dimensions.y_label,
    dimensions.rotation_label,
    dimensions.offset_label,
    dimensions.direction_arrow,
    dimensions.x_symbol,
    dimensions.y_symbol,
    dimensions.feature_id,
    dimensions.feature_type,
    dimensions.state,
    dimensions.expl_id,
    dimensions.observ,
    dimensions.comment,
	dimensions.sector_id,
	dimensions.muni_id
    FROM selector_expl, dimensions
    JOIN v_state_dimensions ON dimensions.id = v_state_dimensions.id
	right join selector_municipality m using (muni_id)
	join selector_sector s using (sector_id)
	where (m.cur_user = current_user or dimensions.muni_id is null) and
	s.cur_user = current_user and dimensions.expl_id = selector_expl.expl_id
	AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_sector_node AS
SELECT node_id, sum(sector_id)::integer as sector_id FROM(
 SELECT node.node_id, node.sector_id FROM selector_sector, node
 WHERE selector_sector.cur_user = "current_user"()::text AND node.sector_id = selector_sector.sector_id
UNION SELECT node_border_sector.node_id, node_border_sector.sector_id
 FROM selector_sector, node_border_sector
 WHERE selector_sector.cur_user = "current_user"()::text AND node_border_sector.sector_id = selector_sector.sector_id) a
 group by node_id;


CREATE OR REPLACE VIEW v_ui_sys_style AS
SELECT
    sys_style.layername,
    config_style.idval as category,
    sys_style.styletype,
    sys_style.active
FROM sys_style
JOIN config_style
ON sys_style.styleconfig_id = config_style.id
WHERE config_style.is_templayer IS NULL OR config_style.is_templayer = false;


INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('v_ui_doc', 'SELECT * FROM v_ui_doc WHERE id IS NOT NULL', 4, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, NULL);

INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','id',6,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
    VALUES ('edit toolbar','utils','v_ui_doc','name',0,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','observ',1,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','doc_type',2,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','path',3,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','date',4,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','user_name',5,true);


UPDATE config_form_tabs
    SET orderby=0
    WHERE formname IN ('v_edit_arc', 'v_edit_connec', 'v_edit_node', 'v_edit_gully') AND tabname='tab_data';

UPDATE config_form_tabs
    SET orderby=1
    WHERE tabname='tab_epa';


UPDATE config_form_tabs
	SET "label"='Elements' WHERE tabname='tab_elements';
UPDATE config_form_tabs
	SET "label"='Events' WHERE tabname='tab_event';
UPDATE config_form_tabs
	SET "label"='Documents' WHERE tabname='tab_documents';
UPDATE config_form_tabs
	SET "label"='Plan' WHERE tabname='tab_plan';
UPDATE config_form_tabs
	SET "label"='Hydrometer' WHERE tabname='tab_hydrometer';
UPDATE config_form_tabs
	SET "label"='Hydrometer consumptions' WHERE tabname='tab_hydrometer_val';

UPDATE doc SET name = id WHERE name IS NULL;



UPDATE config_form_tableview
	SET columnindex=0
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='result_id';
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('epa_toolbar','utils','v_ui_rpt_cat_result','expl_id',1,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('epa_toolbar','utils','v_ui_rpt_cat_result','sector_id',2,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('epa_toolbar','utils','v_ui_rpt_cat_result','network_type',3,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('epa_toolbar','utils','v_ui_rpt_cat_result','descript',4,true);
UPDATE config_form_tableview
	SET columnindex=5
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='status';
UPDATE config_form_tableview
	SET columnindex=6
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='iscorporate';
UPDATE config_form_tableview
	SET columnindex=7
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='cur_user';
UPDATE config_form_tableview
	SET columnindex=8
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='exec_date';
UPDATE config_form_tableview
	SET columnindex=9
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='export_options';
UPDATE config_form_tableview
	SET columnindex=10
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='network_stats';
UPDATE config_form_tableview
	SET columnindex=11
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='inp_options';
UPDATE config_form_tableview
	SET columnindex=12
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='rpt_stats';
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('epa_toolbar','utils','v_ui_rpt_cat_result','addparam',13,false);


INSERT INTO sys_table (id, descript, sys_role, "source" )
VALUES('v_ext_municipality', 'View of town cities and villages based filtered by active exploitations', 'role_edit', 'core');


UPDATE config_param_system SET value='{"sys_table_id":"v_ext_municipality", "sys_id_field":"muni_id", "sys_search_field":"name", "sys_geom_field":"the_geom"}'
WHERE "parameter"='basic_search_muni';


UPDATE config_form_fields SET web_layoutorder = NULL
WHERE tabname = 'tab_elements' AND columnname = 'element_id';

UPDATE config_form_fields SET web_layoutorder = 1
WHERE tabname = 'tab_elements' AND columnname = 'tbl_elements';

UPDATE config_form_fields SET web_layoutorder = NULL
WHERE tabname = 'tab_documents' AND columnname = 'doc_id';

UPDATE config_form_fields SET web_layoutorder = 4
WHERE tabname = 'tab_documents' AND columnname = 'tbl_documents';


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('sys_table_context', '{"level_1":"OM","level_2":"ANALYTICS"}', NULL, NULL, '{"orderBy":26}'::json);
UPDATE sys_table SET context='{"level_1":"OM","level_2":"ANALYTICS"}', orderby=1, alias='Auxiliar Hydrants' WHERE id='v_edit_anl_hydrant';


UPDATE config_form_fields
	SET label = NULL
	WHERE formname = 'infoplan' AND widgettype = 'divider';


DELETE FROM sys_function where id  = 2806;
DROP FUNCTION IF EXISTS gw_fct_admin_test_ci();


UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'sys_geom', ''::text)
	WHERE parameter IN (
		'basic_search_v2_tab_address',
		'basic_search_v2_tab_hydrometer',
		'basic_search_v2_tab_network_arc',
		'basic_search_v2_tab_network_connec',
		'basic_search_v2_tab_network_gully',
		'basic_search_v2_tab_network_node',
		'basic_search_v2_tab_workcat'
	);


ALTER TABLE sys_role DROP CONSTRAINT sys_role_check;
ALTER TABLE sys_role
ADD CONSTRAINT sys_role_check CHECK (id::text = ANY (ARRAY['role_admin'::character varying, 'role_basic'::character varying,
'role_edit'::character varying, 'role_epa'::character varying, 'role_master'::character varying, 'role_om'::character varying,
'role_crm'::character varying, 'role_system'::character varying]::text[]));

INSERT INTO sys_role VALUES ('role_system', 'system');

UPDATE sys_table SET sys_role = 'role_system' WHERE id = 'sys_feature_cat';
UPDATE sys_table SET sys_role = 'role_system' WHERE id = 'sys_feature_epa_type';
UPDATE sys_table SET sys_role = 'role_system' WHERE id = 'sys_feature_type';
UPDATE sys_table SET sys_role = 'role_system' WHERE id = 'sys_role';
UPDATE sys_table SET sys_role = 'role_system' WHERE id = 'sys_typevalue';
UPDATE sys_table SET sys_role = 'role_system' WHERE id = 'sys_version';

DELETE FROM sys_function WHERE function_name = 'gw_fct_admin_manage_roles';

UPDATE sys_table SET sys_role='role_edit' WHERE id='plan_psector';
UPDATE sys_table SET sys_role='role_edit' WHERE id='plan_psector_x_arc';
UPDATE sys_table SET sys_role='role_edit' WHERE id='plan_psector_x_node';
UPDATE sys_table SET sys_role='role_edit' WHERE id='plan_psector_x_other';
UPDATE sys_table SET sys_role='role_edit' WHERE id='plan_psector_x_connec';


INSERT INTO config_param_system (parameter, value, descript, isenabled, project_type)
VALUES ('edit_link_autoupdate_connect_length', 'FALSE', 'Enable the automatic update for connect (connec & gully) length when link is inserted or geometry of link is updated',
FALSE, 'utils')
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype,
widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields
where layoutname ='lyt_data_1' and formname = 'v_edit_link' group by formname)
SELECT c.formname, formtype, tabname, 'uncertain', 'lyt_data_1', lytorder+1, datatype, widgettype, 'Uncertain', 'Uncertain', NULL, false, false, true, false, false
FROM config_form_fields c join lyt using (formname) WHERE c.formname = 'v_edit_link'
AND columnname = 'is_operative'
group by c.formname, formtype, tabname,  layoutname, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent,
iseditable, isautoupdate,  dv_querytext, dv_orderby_id, dv_isnullvalue, lytorder, hidden
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN
		INSERT INTO selector_municipality SELECT muni_id,current_user FROM utils.municipality;
    ELSE
		INSERT INTO selector_municipality SELECT muni_id,current_user FROM ext_municipality;
    END IF;
END; $$;

-- clean code for user's selector function
UPDATE config_param_system set value = gw_fct_json_object_delete_keys(value::json, 'explFromMuni') where parameter = 'basic_selector_tab_municipality';
UPDATE config_param_system set value = gw_fct_json_object_delete_keys(value::json, 'explFromSector') where parameter = 'basic_selector_tab_sector';
UPDATE config_param_system set value = gw_fct_json_object_delete_keys(value::json, 'explFromMuni') where parameter = 'basic_selector_tab_exploitation';
UPDATE config_param_system set value = gw_fct_json_object_delete_keys(value::json, 'explFromMacroexpl') where parameter = 'basic_selector_tab_macrosector';
UPDATE config_param_system set value = gw_fct_json_object_delete_keys(value::json, 'sectorFromMacroexpl') where parameter = 'basic_selector_tab_macrosector';
UPDATE config_param_system set value = gw_fct_json_object_delete_keys(value::json, 'explFromMacroexpl') where parameter = 'basic_selector_tab_macroexploitation';
UPDATE config_param_system set value = gw_fct_json_object_delete_keys(value::json, 'sectorFromMacroexpl') where parameter = 'basic_selector_tab_macroexploitation';

UPDATE config_param_system set value = gw_fct_json_object_set_key(value::json, 'selectionMode', 'keepPreviousUsingShift'::text) where parameter = 'basic_selector_tab_municipality';
UPDATE config_param_system set value = gw_fct_json_object_set_key(value::json, 'selectionMode', 'keepPreviousUsingShift'::text) where parameter = 'basic_selector_tab_sector';
UPDATE config_param_system set value = gw_fct_json_object_set_key(value::json, 'selectionMode', 'keepPreviousUsingShift'::text) where parameter = 'basic_selector_tab_exploitation';
UPDATE config_param_system set value = gw_fct_json_object_set_key(value::json, 'selectionMode', 'keepPreviousUsingShift'::text) where parameter = 'basic_selector_tab_macrosector';
UPDATE config_param_system set value = gw_fct_json_object_set_key(value::json, 'selectionMode', 'keepPreviousUsingShift'::text) where parameter = 'basic_selector_tab_macroexploitation';

UPDATE config_param_system set value = gw_fct_json_object_set_key(value::json, 'selectionMode', 'keepPreviousUsingShift'::text) where parameter = 'basic_selector_tab_psector';
UPDATE config_param_system set value = gw_fct_json_object_set_key(value::json, 'selectionMode', 'keepPreviousUsingShift'::text) where parameter = 'basic_selector_tab_dscenario';

UPDATE config_param_system set value = replace(value, 'sector_id >=0', 'sector_id >0') where parameter = 'basic_selector_tab_sector';

UPDATE link SET muni_id = c.muni_id FROM connec c WHERE connec_id =  feature_id;


INSERT INTO config_function (id, function_name, "style", layermanager, actions) VALUES(3303, 'gw_fct_getinpdata', '{
  "style": {
    "point": {
      "style": "categorized",
      "field": "fid",
      "width": 2,
      "transparency": 0.5
    },
    "line": {
      "style": "categorized",
      "field": "result_id",
      "width": 2,
      "transparency": 0.5
    },
    "polygon": {
      "style": "categorized",
      "field": "fid",
      "width": 2,
      "transparency": 0.5
    }
  }
}'::json, NULL, NULL);

INSERT INTO sys_function (id,function_name,project_type,function_type,input_params,return_type,descript,sys_role,"source")
VALUES (3310,'gw_fct_getinpdata','utils','function','json','json','The function retrieves GeoJSON data for nodes and arcs based on selected result IDs and returns it in a structured JSON format.','role_epa','core');

INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
VALUES('selector_muni', 'Selector of municipalities', 'role_basic', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);

INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
VALUES('config_style', 'Catalog of different style context', 'role_basic', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);

INSERT INTO config_param_system ("parameter", value, descript, "label", isenabled, project_type, "datatype", widgettype)
VALUES('qgis_layers_symbology', '{"styleconfig_vdef":101}', 'Variable to configure parameters related with layer symbology tool', 'Layers symbology', false, 'utils', 'json', 'text');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES(3264, 'Wrong configuration. Check config_form_fields on column widgetcontrol key ''reloadfields'' for columnname:', null, 2, true, 'utils', 'core') ON CONFLICT (id) DO NOTHING;



INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source") VALUES(3316,'gw_fct_admin_transfer_addfields_values', 'utils', 'function', 'json', 'json', 'Function to transfer the addfields values', 'role_admin', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source") VALUES(3190, 'gw_trg_feature_border', 'utils', 'trigger', NULL, NULL, NULL, 'role_basic', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source") VALUES(3272, 'gw_fct_import_scada_flowmeteragg_values', 'utils', 'function', 'json', 'json', 'Function to import flowmeter aggregated values with random interval in order to transform to daily values', 'role_om', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source") VALUES(3166, 'gw_fct_import_scada_values', 'utils', 'function', 'json', 'json', 'Function to import scada values ', 'role_om', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source") VALUES(1348, 'gw_trg_node_rotation_update', 'utils', 'trigger', NULL, NULL, 'Trigger that allows to update the node rotation', 'role_basic', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source") VALUES(3312, 'gw_fct_mincut_minsector', 'ws', 'function', 'character varying, integer, bool', 'json', 'Function to mincut minsector', 'role_basic', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source") VALUES(3314, 'gw_fct_mincut_minsector_inverted', 'ws', 'function', 'integer, integer', 'integer', 'Function to mincut minsector inverted ', 'role_om', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source") VALUES(3318, 'gw_fct_utils_update_dma_hydroval', 'ws', 'function', null, 'integer', 'Function to update dma hydroval', 'role_edit', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES ('layout_name_typevalue', 'lyt_buttons', 'lyt_buttons', 'layoutButtons', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('arc', 'form_feature', 'tab_none', 'btn_accept', 'lyt_buttons', 0, NULL, 'button', NULL, 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Accept"}'::json, '{"functionName": "accept", "params": {}}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('arc', 'form_feature', 'tab_none', 'btn_apply', 'lyt_buttons', 0, NULL, 'button', NULL, 'Apply', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Apply"}'::json, '{"functionName": "apply", "params": {}}'::json, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('arc', 'form_feature', 'tab_none', 'btn_cancel', 'lyt_buttons', 0, NULL, 'button', NULL, 'Cancel', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Cancel"}'::json, '{"functionName": "cancel", "params": {}}'::json, NULL, false, 2);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('node', 'form_feature', 'tab_none', 'btn_accept', 'lyt_buttons', 0, NULL, 'button', NULL, 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Accept"}'::json, '{"functionName": "accept", "params": {}}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('node', 'form_feature', 'tab_none', 'btn_apply', 'lyt_buttons', 0, NULL, 'button', NULL, 'Apply', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Apply"}'::json, '{"functionName": "apply", "params": {}}'::json, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('node', 'form_feature', 'tab_none', 'btn_cancel', 'lyt_buttons', 0, NULL, 'button', NULL, 'Cancel', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Cancel"}'::json, '{"functionName": "cancel", "params": {}}'::json, NULL, false, 2);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('connec', 'form_feature', 'tab_none', 'btn_accept', 'lyt_buttons', 0, NULL, 'button', NULL, 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Accept"}'::json, '{"functionName": "accept", "params": {}}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('connec', 'form_feature', 'tab_none', 'btn_apply', 'lyt_buttons', 0, NULL, 'button', NULL, 'Apply', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Apply"}'::json, '{"functionName": "apply", "params": {}}'::json, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('connec', 'form_feature', 'tab_none', 'btn_cancel', 'lyt_buttons', 0, NULL, 'button', NULL, 'Cancel', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Cancel"}'::json, '{"functionName": "cancel", "params": {}}'::json, NULL, false, 2);



INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
	VALUES(3320, 'gw_fct_set_rpt_archived', 'ud', 'function', 'json', 'json', 'Function to archive or restore results.', 'role_epa', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO config_param_user ("parameter", "value", cur_user) VALUES('edit_municipality_vdefault', NULL, current_user) ON CONFLICT ("parameter", cur_user) DO NOTHING;


update samplepoint sp set sector_id = a.sector_id, muni_id = a.muni_id from (
select ss.sample_id, s.sector_id, m.muni_id from samplepoint ss
	left join sector s on st_dwithin(s.the_geom, ss.the_geom, 1)
	left join ext_municipality m on st_intersects(s.the_geom, m.the_geom)
)a where sp.sample_id = a.sample_id;

update samplepoint set sector_id = 0 where sector_id is null;


update "element" e set muni_id = a.muni_id, sector_id = a.sector_id from (
select element_id, node_id, n.muni_id, n.sector_id from element_x_node
	left join node n using (node_id)
)a where e.element_id = a.element_id;

update "element" e set muni_id = a.muni_id, sector_id = a.sector_id from (
select element_id, arc_id, b.muni_id, b.sector_id from element_x_arc
	left join arc b using (arc_id)
)a where e.element_id = a.element_id;

update "element" e set muni_id = a.muni_id, sector_id = a.sector_id from (
select element_id, connec_id, c.muni_id, c.sector_id from element_x_connec
	left join connec c using (connec_id)
)a where e.element_id = a.element_id;

update "element" set sector_id=0 where sector_id is null;


update link b set sector_id = a.sector_id, muni_id = a.muni_id from (
select feature_id, c.sector_id, c.muni_id from link l
	left join connec c on l.feature_id = c.connec_id where l.feature_type = 'CONNEC'
)a where b.feature_id = a.feature_id;


update dimensions d set sector_id = a.sector_id, muni_id = a.muni_id from (
select d.id, s.sector_id, e.muni_id from dimensions d
	left join sector s on st_dwithin(s.the_geom, d.the_geom, 0.01)
	left join ext_municipality e on st_dwithin(e.the_geom, d.the_geom, 0.01)
)a where d.id = a.id;

UPDATE dimensions SET sector_id = 0 WHERE sector_id IS NULL;

update om_visit e set muni_id = a.muni_id, sector_id = a.sector_id from (
select visit_id, node_id, n.muni_id, n.sector_id from om_visit_x_node
	left join node n using (node_id)
)a where e.id = a.visit_id;

update om_visit e set muni_id = a.muni_id, sector_id = a.sector_id from (
select visit_id, arc_id, n.muni_id, n.sector_id from om_visit_x_arc
	left join arc n using (arc_id)
)a where e.id = a.visit_id;

update om_visit e set muni_id = a.muni_id, sector_id = a.sector_id from (
select visit_id, connec_id, n.muni_id, n.sector_id from om_visit_x_connec
	left join connec n using (connec_id)
)a where e.id = a.visit_id;

update om_visit set sector_id = 0 where sector_id is null;

delete from sys_table where id='v_ui_document';


UPDATE config_form_list SET query_text='SELECT value as url, tstamp FROM om_visit_event_photo WHERE id IS NOT NULL', addparam='{"displayField":"tstamp"}'::json WHERE listname='om_visit_event_photo' AND device=5;




ALTER TABLE sys_style ADD CONSTRAINT sys_style_styleconfig_id_fk FOREIGN KEY (styleconfig_id) REFERENCES config_style(id);

ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);

ALTER TABLE element ADD CONSTRAINT element_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);

ALTER TABLE link ADD CONSTRAINT link_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);

ALTER TABLE dimensions ADD CONSTRAINT dimensions_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);


DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

        ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id);
        ALTER TABLE element ADD CONSTRAINT element_muni_id FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id);
        ALTER TABLE link ADD CONSTRAINT link_muni_id FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id);
        ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id);

    ELSE

        ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id);
        ALTER TABLE element ADD CONSTRAINT element_muni_id FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id);
        ALTER TABLE link ADD CONSTRAINT link_muni_id FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id);
        ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id);

    END IF;
END; $$;



ALTER TABLE element ALTER COLUMN sector_id set not null;
ALTER TABLE samplepoint ALTER COLUMN sector_id set not null;
ALTER TABLE om_visit ALTER COLUMN sector_id set not null;
ALTER TABLE dimensions ALTER COLUMN sector_id set not null;


DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_visit ON v_ui_doc_x_visit;
CREATE trigger gw_trg_ui_doc_x_visit instead OF
INSERT OR DELETE OR UPDATE ON v_ui_doc_x_visit FOR each row EXECUTE function gw_trg_ui_doc('doc_x_visit');

DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_arc ON v_ui_doc_x_arc;
CREATE trigger gw_trg_ui_doc_x_arc instead OF
INSERT OR DELETE OR UPDATE ON v_ui_doc_x_arc FOR each row EXECUTE function gw_trg_ui_doc('doc_x_arc');

DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_connec ON v_ui_doc_x_connec;
CREATE trigger gw_trg_ui_doc_x_connec instead OF
INSERT OR DELETE OR UPDATE ON v_ui_doc_x_connec FOR each row EXECUTE function gw_trg_ui_doc('doc_x_connec');

DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_node ON v_ui_doc_x_node;
CREATE trigger gw_trg_ui_doc_x_node instead OF
INSERT OR DELETE OR UPDATE ON v_ui_doc_x_node FOR each row EXECUTE function gw_trg_ui_doc('doc_x_node');
