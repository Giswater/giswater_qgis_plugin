/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



-----------------------
-- create om tables
-----------------------

/*
CREATE TABLE om_visit_typevalue
( typevalue character varying(50) NOT NULL,
  id character varying(30) NOT NULL,
  idval character varying(30),
  descript text,
  CONSTRAINT om_visit_typevalue_pkey PRIMARY KEY (typevalue, id)
);


CREATE TABLE rpt_selector_hourly_compare
( id serial NOT NULL,
  "time" character varying(100) NOT NULL,
  cur_user text NOT NULL,
  CONSTRAINT rpt_selector_result_hourly_compare_pkey PRIMARY KEY (id)
);

*/
CREATE TABLE audit_cat_table_x_column
( id text,
  table_id text NOT NULL,
  column_id text NOT NULL,
  column_type text,
  ordinal_position smallint,
  description text,
  sys_role_id character varying(30),
  CONSTRAINT audit_cat_table_x_column_pkey PRIMARY KEY (table_id, column_id)
);


CREATE TABLE value_type
(  typevalue character varying(50) NOT NULL,
  id character varying(30) NOT NULL,
  idval character varying(100),
  descript text,
  CONSTRAINT value_type_pkey PRIMARY KEY (typevalue, id)
);



-----------------------
-- create new fields
----------------------


ALTER TABLE cat_arc ADD COLUMN  dn integer;
ALTER TABLE cat_arc ADD COLUMN  pn integer;

ALTER TABLE cat_connec ADD COLUMN dn integer;
ALTER TABLE cat_connec ADD COLUMN  pn integer;

ALTER TABLE cat_node ADD COLUMN dn integer;
ALTER TABLE cat_node ADD COLUMN  pn integer;

ALTER TABLE cat_feature ADD COLUMN  type character varying(30);
ALTER TABLE cat_feature ADD COLUMN shortcut_key character varying(100);
ALTER TABLE cat_feature ADD COLUMN parent_layer character varying(100);
ALTER TABLE cat_feature ADD COLUMN child_layer character varying(100);
ALTER TABLE cat_feature ADD COLUMN orderby integer;
ALTER TABLE cat_feature ADD COLUMN active boolean;
ALTER TABLE cat_feature ADD COLUMN code_autofill boolean;


--rename instead of add column?
ALTER TABLE ext_rtc_hydrometer ADD COLUMN hydrometer_id character varying(16);
ALTER TABLE ext_rtc_hydrometer ADD COLUMN client_name text;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN instalation_date date;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN hydrometer_number integer;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN state smallint;
ALTER TABLE ext_rtc_hydrometer ADD COLUMN connec_customer_code character varying(30);

ALTER TABLE om_visit_cat ADD COLUMN extusercat_id integer;
ALTER TABLE om_visit_cat ADD COLUMN duration text;

ALTER TABLE sys_feature_type ADD COLUMN  icon character varying(30);

--table v_project_type???