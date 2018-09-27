/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-----------------------
-- doc_x_psector table
-----------------------

CREATE TABLE doc_x_psector(
id serial NOT NULL PRIMARY KEY,
doc_id character varying(30),
psector_id integer 
);

ALTER TABLE doc_x_psector DROP CONSTRAINT IF EXISTS doc_x_psector_doc_id_fkey;
ALTER TABLE doc_x_psector DROP CONSTRAINT IF EXISTS doc_x_psector_psector_id_fkey;

ALTER TABLE doc_x_psector ADD CONSTRAINT doc_x_psector_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE doc_x_psector ADD CONSTRAINT doc_x_psector_psector_id_fkey FOREIGN KEY (psector_id) REFERENCES plan_psector (psector_id) ON DELETE CASCADE ON UPDATE CASCADE;


INSERT INTO audit_cat_table VALUES ('doc_x_psector', 'doc', 'Doc psector', 'role_basic', 0, NULL, NULL, 0, NULL,'doc_x_psector_id_seq', 'id');



-----------------------
--ext_rtc_hydrometer table
-----------------------

ALTER TABLE ext_rtc_hydrometer ADD COLUMN state int2;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN expl_id integer;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN connec_customer_code varchar (30);
ALTER TABLE ext_rtc_hydrometer ADD COLUMN hydrometer_customer_code varchar (30);



-----------------------
--ext_rtc_hydrometer_state table
-----------------------

CREATE TABLE ext_rtc_hydrometer_state
(
  id serial PRIMARY KEY,
  name text NOT NULL,
  observ text
);


INSERT INTO audit_cat_table VALUES ('ext_rtc_hydrometer_state', 'ext', 'hydrometers state catalog', 'role_basic', 0, NULL, NULL, 0, NULL,'ext_rtc_hydrometer_state_id_seq', 'id');


INSERT INTO ext_rtc_hydrometer_state VALUES (0, 'STATE0');
INSERT INTO ext_rtc_hydrometer_state VALUES (1, 'STATE1');
INSERT INTO ext_rtc_hydrometer_state VALUES (2, 'STATE2');
INSERT INTO ext_rtc_hydrometer_state VALUES (3, 'STATE3');
INSERT INTO ext_rtc_hydrometer_state VALUES (4, 'STATE4');


-----------------------
--selector_hydrometer table
-----------------------

CREATE TABLE selector_hydrometer
(
  id serial NOT NULL,
  state_id integer NOT NULL,
  cur_user text NOT NULL,
  CONSTRAINT selector_hydrometer_pkey PRIMARY KEY (id),
  CONSTRAINT selector_hydrometer_state_id_cur_user_unique UNIQUE (state_id, cur_user)
);

INSERT INTO audit_cat_table VALUES ('selector_hydrometer', 'System', 'Selector of hydrometers', 'role_basic', 0, NULL, NULL, 0, NULL,'selector_hydrometer_id_seq', 'id');



-----------------------
--system tables
-----------------------
INSERT INTO config_param_system VALUES (160, 'basic_search_hyd_hydro_layer_name', 'v_rtc_hydrometer', 'varchar', 'searchplus', 'layer name');
INSERT INTO config_param_system VALUES (161, 'basic_search_hyd_hydro_field_expl_name', 'expl_name', 'varchar', 'searchplus', 'field exploitation.name');
INSERT INTO config_param_system VALUES (162, 'basic_search_hyd_hydro_field_cc', 'connec_id', 'text', 'searchplus', 'field connec.code');
INSERT INTO config_param_system VALUES (163, 'basic_search_hyd_hydro_field_erhc', 'hydrometer_customer_code', 'text', 'searchplus', 'field ext_rtc_hydrometer.code');
INSERT INTO config_param_system VALUES (164, 'basic_search_hyd_hydro_field_ccc', 'connec_customer_code', 'text', 'searchplus', 'field connec.customer_code');
INSERT INTO config_param_system VALUES (166, 'basic_search_hyd_hydro_field_1', 'hydrometer_customer_code', 'text', 'searchplus', 'field ext_rtc_hydrometer.code');
INSERT INTO config_param_system VALUES (167, 'basic_search_hyd_hydro_field_2', 'connec_customer_code', 'text', 'searchplus', 'field connec.customer_code');
INSERT INTO config_param_system VALUES (168, 'basic_search_hyd_hydro_field_3', 'state', 'text', 'searchplus', 'field value_state.name');
INSERT INTO config_param_system VALUES (169, 'basic_search_workcat_filter', 'code', 'text', 'searchplus', NULL);
INSERT INTO config_param_system VALUES (170, 'om_mincut_use_pgrouting', 'TRUE', 'boolean', 'mincut', NULL);




INSERT INTO sys_fprocess_cat VALUES (28, 'Massive downgrade features', 'Edit', 'Massive downgrade features', 'utils');
INSERT INTO sys_fprocess_cat VALUES (29, 'Audit mincut data', 'OM', 'Audit mincut data', 'ws');



----------------------
--22/05/2018
-----------------------
--Inserted on i18n file: gw_74_audit_vdomain_error
--INSERT INTO audit_cat_error VALUES (3002, 'The selected arc has state=0 (num. node,feature_id)=', 'Please, select another one In order to use mincut, we recommend to disable network state=0.', 2, true, NULL);
--INSERT INTO audit_cat_error VALUES (3004, 'The selected arc has state=0 (num. node,feature_id)=', 'Please, select another one In order to use mincut, we recommend to disable network state=0.', 2, true, NULL);



----------------------
--28/05/2018
-----------------------


INSERT INTO config_param_system VALUES (184, 'ymax_vd', '1', 'decimal', 'draw_profile', 'For Node. Only for UD');
INSERT INTO config_param_system VALUES (183, 'top_elev_vd', '1', 'decimal', 'draw_profile', 'For Node. Only for UD');
INSERT INTO config_param_system VALUES (185, 'sys_elev_vd', '1', 'decimal', 'draw_profile', 'For Node. Only for UD');
INSERT INTO config_param_system VALUES (186, 'geom1_vd', '0.4', 'decimal', 'draw_profile', 'For Arc Catalog. Only for UD');
INSERT INTO config_param_system VALUES (187, 'z1_vd', '0.1', 'decimal', 'draw_profile', 'For Arc Catalog. Only for UD');
INSERT INTO config_param_system VALUES (188, 'z2_vd', '0.1', 'decimal', 'draw_profile', 'For Arc Catalog. Only for UD');
INSERT INTO config_param_system VALUES (189, 'cat_geom1_vd', '1', 'decimal', 'draw_profile', 'For Node Catalog. Only for UD');
INSERT INTO config_param_system VALUES (190, 'sys_elev1_vd', '1', 'decimal', 'draw_profile', 'For Arc. Only for UD');
INSERT INTO config_param_system VALUES (191, 'sys_elev2_vd', '1', 'decimal', 'draw_profile', 'For Arc. Only for UD');
INSERT INTO config_param_system VALUES (192, 'y1_vd', '1', 'decimal', 'draw_profile', 'For Arc. Only for UD');
INSERT INTO config_param_system VALUES (193, 'y2_vd', '1', 'decimal', 'draw_profile', 'For Arc. Only for UD');
INSERT INTO config_param_system VALUES (194, 'slope_vd', '1', 'decimal', 'draw_profile', 'For Arc. Only for UD');


----------------------
--29/05/2018
-----------------------

INSERT INTO config_param_system VALUES (195, 'om_mincut_disable_check_temporary_overlap', 'FALSE', 'Boolean', 'Mincut', 'Only for WS');
INSERT INTO config_param_system VALUES (196, 'om_mincut_valve2tank_traceability', 'FALSE', 'Boolean', 'Mincut', 'Only for WS');

INSERT INTO sys_fprocess_cat VALUES (30, 'Analysis mincut areas', 'OM', 'Analysis mincut areas', 'ws');


----------------------
--1/06/2018
-----------------------
INSERT INTO audit_cat_param_user VALUES ('edit_connect_force_downgrade_linkvnode', null, null, 'role_edit');
INSERT INTO audit_cat_param_user VALUES ('edit_connect_force_automatic_connect2network', null, null, 'role_edit');

INSERT INTO config_param_user VALUES (110, 'edit_connect_force_downgrade_linkvnode', 'TRUE', 'postgres');
INSERT INTO config_param_user VALUES (111, 'edit_connect_force_automatic_connect2network', 'TRUE', 'postgres');


ALTER TABLE cat_node ADD COLUMN label varchar(255);
ALTER TABLE cat_arc ADD COLUMN label varchar(255);
ALTER TABLE cat_connec ADD COLUMN label varchar(255);


----------------------
--04/06/2018
-----------------------
INSERT INTO audit_cat_param_user VALUES ('cf_keep_opened_edition', null, null, 'role_edit');
INSERT INTO config_param_user VALUES (112, 'cf_keep_opened_edition', 'TRUE', 'postgres');

INSERT INTO audit_cat_table VALUES ('v_edit_cad_auxcircle', 'CAD layer', 'Layer to store circle geometry when CAD tool is used', 'role_edit', 0, NULL, 'role_edit', 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_edit_cad_auxpoint', 'CAD layer', 'Layer to store point geometry when CAD tool is used', 'role_edit', 0, NULL, 'role_edit', 0, NULL, NULL, NULL); 


----------------------
--05/06/2018
-----------------------
INSERT INTO sys_fprocess_cat VALUES (31, 'Mincut conlfict scenario result', 'OM', 'Mincut conlfict scenario result', 'ws');

INSERT INTO audit_cat_param_user VALUES ('edit_noderotation_update_dissbl', null, null, 'role_edit');
INSERT INTO config_param_user VALUES (113, 'edit_noderotation_update_dissbl', 'FALSE', 'postgres');


----------------------
--22/06/2018
-----------------------
CREATE SEQUENCE om_psector_id_seq
  INCREMENT 1
  NO MINVALUE
  NO MAXVALUE
  START 1
  CACHE 1;
ALTER TABLE om_psector ALTER COLUMN psector_id SET DEFAULT nextval('SCHEMA_NAME.om_psector_id_seq'::regclass);
UPDATE audit_cat_table SET sys_sequence='om_psector_id_seq' WHERE id='om_psector';
  
  
CREATE SEQUENCE plan_psector_id_seq
  INCREMENT 1
  NO MINVALUE
  NO MAXVALUE
  START 1
  CACHE 1;
ALTER TABLE plan_psector ALTER COLUMN psector_id SET DEFAULT nextval('SCHEMA_NAME.plan_psector_id_seq'::regclass);
UPDATE audit_cat_table SET sys_sequence='plan_psector_id_seq' WHERE id='plan_psector';


INSERT INTO sys_fprocess_cat VALUES (32, 'Node proximity analysis', 'EDIT', 'Node proximity analysis', 'utils');



----------------------
--28/06/2018
-----------------------
DROP SEQUENCE IF EXISTS psector_psector_id_seq;

--INSERT INTO audit_cat_error values('3008','The values of addfields are different for both arcs.','Review your data to make them equal.',2,TRUE,'utils');


----------------------
--02/07/2018
-----------------------

DROP RULE IF EXISTS update_plan_psector_x_arc ON arc;
DROP RULE IF EXISTS delete_plan_psector_x_arc ON arc;

DROP RULE IF EXISTS update_plan_psector_x_node ON node;
DROP RULE IF EXISTS delete_plan_psector_x_node ON node;



-- Harmonize pivot table of ext_rtc_hydrometer
ALTER TABLE ext_rtc_hydrometer RENAME hydrometer_id TO id;
ALTER TABLE ext_rtc_hydrometer RENAME instalation_date TO start_date;
ALTER TABLE ext_rtc_hydrometer RENAME client_name TO customer_name;
ALTER TABLE ext_rtc_hydrometer RENAME connec_customer_code TO connec_id;
ALTER TABLE ext_rtc_hydrometer RENAME hydrometer_number TO hydro_number;
ALTER TABLE ext_rtc_hydrometer RENAME state TO state_id;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN plot_code integer;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN priority_id integer;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN catalog_id integer;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN category_id integer;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN crm_number integer;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN muni_id integer;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN address1 text;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN address2 text;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN address3 text;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN address2_1 text;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN address2_2 text;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN address2_3 text;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN m3_volume integer;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN hydro_man_date date;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN end_date date;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN update_date date;


ALTER TABLE plan_psector ADD COLUMN enable_all boolean NOT NULL DEFAULT FALSE;


----------------------
--25/07/2018
-----------------------
ALTER TABLE ext_cat_hydrometer ADD COLUMN code text;
ALTER TABLE ext_cat_hydrometer ADD COLUMN observ text;

ALTER TABLE ext_hydrometer_category ADD COLUMN code text;
ALTER TABLE ext_cat_period ADD COLUMN code text;


CREATE TABLE ext_cat_hydrometer_priority(
"id" integer PRIMARY KEY,
"code" character varying(16) NOT NULL,
"observ" character varying(100));


CREATE TABLE ext_cat_hydrometer_type(
"id" integer PRIMARY KEY,
"code" character varying(16) NOT NULL,
"observ" character varying(100)
);

--------------------
--23/08/2018
--------------------
INSERT INTO audit_cat_error values('3010','The minimum arc length of this exportation is: ', 'This length is less than nod2arc parameter. You need to update config.node2arc parameter to value less than it.',2,TRUE,'utils');

--------------------
--29/08/2018
--------------------
INSERT INTO config_param_system VALUES (198, 'edit_topocontrol_dsbl_error', 'FALSE', 'Boolean', 'Edit', 'Utils');
INSERT INTO config_param_system VALUES (202, 'edit_node_reduction_auto_d1d2', 'FALSE', 'Boolean', 'Edit', 'Only for WS');

--------------------
--30/08/2018
--------------------
INSERT INTO audit_cat_function VALUES (2496, 'gw_fct_arc_repair', 'edit', NULL, 'p_arc_id', 'Massive repair function. All the arcs that are not connected with extremal node will be reconected using the parameter arc_searchnodes', NULL, NULL, NULL);
INSERT INTO config_param_system VALUES (203, 'ext_utils_schema', NULL, 'Text', NULL, NULL);

--------------------
--20/09/2018
--------------------

UPDATE config_param_system SET descript = 'Folder in your computer which Giswater uses to manage Custom Options on developer toolbox' WHERE parameter = 'custom_giswater_folder';
UPDATE config_param_system SET descript = 'deprecated' WHERE parameter = 'doc_absolute_path';
UPDATE config_param_system SET descript = 'deprecated' WHERE parameter = 'om_visit_absolute_path';
UPDATE config_param_system SET descript = 'Different ways to use mincut. If true, mincut is done with pgrouting, an extension of Postgis' WHERE parameter = 'om_mincut_use_pgrouting';
UPDATE config_param_system SET descript = 'If true, the direction of the arc is fixed by the slope (UD)' WHERE parameter = 'geom_slp_direction';
UPDATE config_param_system SET descript = 'Default value used if Node ymax is NULL when drawing profile (UD)' WHERE parameter = 'ymax_vd';
UPDATE config_param_system SET descript = 'Default value used if Node system elevation is NULL when drawing profile (UD)' WHERE parameter = 'sys_elev_vd';
UPDATE config_param_system SET descript = 'Default value used if Arc catalog geom1 is NULL when drawing profile (UD)' WHERE parameter = 'geom1_vd';
UPDATE config_param_system SET descript = 'Default value used if Arc catalog z1 is NULL when drawing profile (UD)' WHERE parameter = 'z1_vd';
UPDATE config_param_system SET descript = 'Default value used if Arc catalog z2 is NULL when drawing profile (UD)' WHERE parameter = 'z2_vd';
UPDATE config_param_system SET descript = 'Default value used if Node catalog geom1 is NULL when drawing profile (UD)' WHERE parameter = 'cat_geom1_vd';
UPDATE config_param_system SET descript = 'Default value used if Arc system elevation 1 is NULL when drawing profile (UD)' WHERE parameter = 'sys_elev1_vd';
UPDATE config_param_system SET descript = 'Default value used if Node top elevation is NULL when drawing profile (UD)' WHERE parameter = 'top_elev_vd';
UPDATE config_param_system SET descript = 'Default value used if Arc system elevation 2 is NULL when drawing profile (UD)' WHERE parameter = 'sys_elev2_vd';
UPDATE config_param_system SET descript = 'Default value used if Arc y1 is NULL when drawing profile (UD)' WHERE parameter = 'y1_vd';
UPDATE config_param_system SET descript = 'Default value used if Arc y2 is NULL when drawing profile (UD)' WHERE parameter = 'y2_vd';
UPDATE config_param_system SET descript = 'Buffer to find neighbour elements' WHERE parameter = 'proximity_buffer';
UPDATE config_param_system SET descript = 'If true, Giswater save traceability from each valve to the tank which it has access (WS)' WHERE parameter = 'om_mincut_valve2tank_traceability';
UPDATE config_param_system SET descript = 'Default value used if Arc slope is NULL when drawing profile (UD)' WHERE parameter = 'slope_vd';
UPDATE config_param_system SET descript = 'To enable or disable state topology rules (WS)' WHERE parameter = 'state_topocontrol';
UPDATE config_param_system SET descript = 'If true, mincut temporary overlaps are disabled. Giswater won''t show you a message when different mincuts overlaps eachselfs (WS)' WHERE parameter = 'om_mincut_disable_check_temporary_overlap';
UPDATE config_param_system SET descript = 'If true, when inserting a new reduction, diam1 and diam2 values are capturated from dnom and dint from cat_node (WS)' WHERE parameter = 'edit_node_reduction_auto_d1d2';
UPDATE config_param_system SET descript = 'deprecated' WHERE parameter = 'module_om_rehabit';
UPDATE config_param_system SET descript = 'Inventary migration date. Used in system rapports' WHERE parameter = 'inventory_update_date';
UPDATE config_param_system SET descript = 'deprecated' WHERE parameter = 'link_search_button';
UPDATE config_param_system SET descript = 'Buffer which links use to search an arc to connect with' WHERE parameter = 'link_searchbuffer';
UPDATE config_param_system SET descript = 'deprecated' WHERE parameter = 'edit_arc_divide_automatic_control';
UPDATE config_param_system SET descript = 'If true, user can manually update node_1 and node_2. Used in migrations with trustly data for not execute arc_searchnodes trigger' WHERE parameter = 'edit_enable_arc_nodes_update';
UPDATE config_param_system SET descript = 'The hyperlink in the hydrometer info to an url or a file is made up of two parts. A common part to all hydrometers, and a specific part for each hydrometer. The common part to all is the value of this variable' WHERE parameter = 'hydrometer_link_absolute_path';
UPDATE config_param_system SET descript = 'System parameter which identifies existing schema in the database with common information for those organizations which share cartography in more than on production schema(ws/ud). In this case, information is propagated to both schemas using views' WHERE parameter = 'exit_utils_schema';


