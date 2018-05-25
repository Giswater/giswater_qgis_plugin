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
INSERT INTO config_param_system VALUES (60, 'basic_search_hyd_hydro_layer_name', 'v_rtc_hydrometer', 'varchar', 'searchplus', 'layer name');
INSERT INTO config_param_system VALUES (61, 'basic_search_hyd_hydro_field_expl_name', 'expl_name', 'varchar', 'searchplus', 'field exploitation.name');
INSERT INTO config_param_system VALUES (62, 'basic_search_hyd_hydro_field_cc', 'connec_id', 'text', 'searchplus', 'field connec.code');
INSERT INTO config_param_system VALUES (63, 'basic_search_hyd_hydro_field_erhc', 'hydrometer_customer_code', 'text', 'searchplus', 'field ext_rtc_hydrometer.code');
INSERT INTO config_param_system VALUES (64, 'basic_search_hyd_hydro_field_ccc', 'connec_customer_code', 'text', 'searchplus', 'field connec.customer_code');
INSERT INTO config_param_system VALUES (66, 'basic_search_hyd_hydro_field_1', 'hydrometer_customer_code', 'text', 'searchplus', 'field ext_rtc_hydrometer.code');
INSERT INTO config_param_system VALUES (67, 'basic_search_hyd_hydro_field_2', 'connec_customer_code', 'text', 'searchplus', 'field connec.customer_code');
INSERT INTO config_param_system VALUES (68, 'basic_search_hyd_hydro_field_3', 'state', 'text', 'searchplus', 'field value_state.name');
INSERT INTO config_param_system VALUES (69, 'basic_search_workcat_filter', 'code', 'text', 'searchplus', NULL);
INSERT INTO config_param_system VALUES (70, 'om_mincut_use_pgrouting', NULL, 'boolean', 'mincut', NULL);



INSERT INTO sys_fprocess_cat VALUES (28, 'Massive downgrade features', 'Edit', 'Massive downgrade features', 'utils');





----------------------
--22/05/2018
-----------------------



/* Inserted on i18n flle: gw_74_audit_vdomain_error
INSERT INTO audit_cat_error VALUES (3002, 'The selected arc has state=0 (num. node,feature_id)=', 'Please, select another one In order to use mincut, we recommend to disable network state=0.', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (3004, 'The selected arc has state=0 (num. node,feature_id)=', 'Please, select another one In order to use mincut, we recommend to disable network state=0.', 2, true, NULL);
*/




