/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

CREATE TABLE (man_adfields_parameter
id serial PRIMARY KEY,
name varchar(50),
featurecat_id varchar (30),
nul boolean,
data_type text,
field_length integer,
decimals integer,
units varchar(10),
default_value text,
form_label text,
mandatory boolean,
unique_value boolean, 
dv_table text,
dv_key_column text,
dv_value_column text,
sql_text text
)
--unique:  	name,featurecat_id
--fk: 		featurecat_id, data_type, units, dv_table, dv_key_column, dv_value_column


CREATE TABLE (man_adfields_value
id bigserial PRIMARY KEY,
feature_id varchar(16),
parameter_id integer,
value text
)
--unique:  	feature_id,parameter_id
--fk: 		parameter_id


CREATE TABLE (man_adfields_cat_datatype
id varchar(30) PRIMARY KEY,
descript text
)


CREATE TABLE (man_adfields_cat_units
id varchar(30) PRIMARY KEY,
descript text
)


