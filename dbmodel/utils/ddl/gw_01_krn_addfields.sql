/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;




CREATE TABLE man_addfields_parameter (
id serial PRIMARY KEY,
param_name varchar(50),
cat_feature_id varchar (30),
is_mandatory boolean,
datatype_id text,
field_length integer,
num_decimals integer,
default_value text,
form_label text,
widgettype_id text,
dv_table text,
dv_key_column text,
dv_value_column text,
sql_text text
);
--unique:  	name,featurecat_id
--fk: 		featurecat_id, data_type, for_widget, dv_table, dv_key_column, dv_value_column


CREATE TABLE man_addfields_value (
id bigserial PRIMARY KEY,
feature_id varchar(16),
parameter_id integer,
value_param text
);
--unique:  	feature_id,parameter_id
--fk: 		parameter_id


CREATE TABLE man_addfields_cat_datatype (
id varchar(30) PRIMARY KEY,
descript text
);


CREATE TABLE man_addfields_cat_widgettype (
id varchar(30) PRIMARY KEY,
descript text
);


CREATE TABLE man_addfields_cat_combo (
parameter_id integer NOT NULL,
value text NOT NULL,
descript text,
CONSTRAINT man_addfields_cat_combo_pkey PRIMARY KEY (value, parameter_id)
);



CREATE INDEX man_addfields_value_feature_id_index ON man_addfields_value USING btree (feature_id);
CREATE INDEX man_addfields_value_parameter_id_index ON man_addfields_value USING btree (parameter_id);


