/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



-----------------------
-- create om tables
-----------------------

CREATE TABLE audit_cat_column
( column_id text NOT NULL,
  descript text);


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

ALTER TABLE om_visit_class ADD COLUMN param_options json;

ALTER TABLE om_visit ADD COLUMN visit_type integer;

ALTER TABLE cat_feature ADD COLUMN type character varying(30);
ALTER TABLE cat_feature ADD COLUMN shortcut_key character varying(100);
ALTER TABLE cat_feature ADD COLUMN parent_layer character varying(100);
ALTER TABLE cat_feature ADD COLUMN child_layer character varying(100);
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


--21/05/2019
ALTER TABLE sys_csv2pg_cat ADD COLUMN  isheader boolean NOT NULL DEFAULT false;

--24/05/2019
ALTER TABLE man_addfields_parameter ADD COLUMN  orderby integer;
ALTER TABLE man_addfields_parameter ADD COLUMN  active boolean;

ALTER TABLE ext_municipality ADD COLUMN active boolean;