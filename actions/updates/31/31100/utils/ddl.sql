/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



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


--ext_rtc_hydrometer table
-----------------------
ALTER TABLE ext_rtc_hydrometer ADD COLUMN state int2;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN expl_id integer;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN connec_customer_code varchar (30);
ALTER TABLE ext_rtc_hydrometer ADD COLUMN hydrometer_customer_code varchar (30);


--ext_rtc_hydrometer_state table
-----------------------
CREATE TABLE ext_rtc_hydrometer_state(
  id serial PRIMARY KEY,
  name text NOT NULL,
  observ text
);


--selector_hydrometer table
-----------------------
CREATE TABLE selector_hydrometer(
  id serial NOT NULL,
  state_id integer NOT NULL,
  cur_user text NOT NULL,
  CONSTRAINT selector_hydrometer_pkey PRIMARY KEY (id),
  CONSTRAINT selector_hydrometer_state_id_cur_user_unique UNIQUE (state_id, cur_user)
);


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

ALTER TABLE cat_node ADD COLUMN label varchar(255);
ALTER TABLE cat_arc ADD COLUMN label varchar(255);
ALTER TABLE cat_connec ADD COLUMN label varchar(255);


--22/06/2018
-----------------------
CREATE SEQUENCE om_psector_id_seq
  INCREMENT 1
  NO MINVALUE
  NO MAXVALUE
  START 1
  CACHE 1;
ALTER TABLE om_psector ALTER COLUMN psector_id SET DEFAULT nextval('SCHEMA_NAME.om_psector_id_seq'::regclass);

 
CREATE SEQUENCE plan_psector_id_seq
  INCREMENT 1
  NO MINVALUE
  NO MAXVALUE
  START 1
  CACHE 1;
ALTER TABLE plan_psector ALTER COLUMN psector_id SET DEFAULT nextval('SCHEMA_NAME.plan_psector_id_seq'::regclass);


--28/06/2018
-----------------------
DROP SEQUENCE IF EXISTS psector_psector_id_seq;


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