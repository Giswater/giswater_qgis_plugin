/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "crm", public, pg_catalog;


-- ----------------------------
-- CRM TABLES
-- ----------------------------

CREATE TABLE hydrometer(
  id bigint PRIMARY KEY,
  code text,
  connec_id integer,
  muni_id integer,
  plot_code integer,
  priority_id integer,
  catalog_id integer,
  category_id integer,
  state_id integer,
  hydro_number text,
  hydro_man_date date,
  crm_number text,
  customer_name text,
  address1 text,
  address2 text,
  address3 text,
  address2_1 text,
  address2_2 text,
  address2_3 text,
  m3_volume integer,
  start_date date,
  end_date date,
  update_date date);



CREATE TABLE hydrometer_x_data (
"id" bigserial PRIMARY KEY,
"hydrometer_id" bigserial NOT NULL,
"m3value" float,
"value_date" date,
"period_id" integer);


CREATE TABLE hydro_cat_catalog(
"id" int8 PRIMARY KEY,
"code" character varying(16),
"hydro_type" character varying(100),
"madeby" character varying(100),
"class" character varying(100),
"flow" character varying(100),
"dnom" character varying(100),
"observ" text);


CREATE TABLE hydro_cat_type(
"id" integer PRIMARY KEY,
"code" character varying(16) NOT NULL,
"observ" character varying(100)
);


CREATE TABLE hydro_cat_category(
"id" integer PRIMARY KEY,
"code" character varying(16) NOT NULL,
"observ" character varying(100)
);


CREATE TABLE hydro_val_state(
"id" integer PRIMARY KEY,
"code" character varying(16) NOT NULL,
"observ" character varying(100)
);


CREATE TABLE hydro_cat_period(
"id" integer PRIMARY KEY,
"code" character varying(16) NOT NULL,
"observ" character varying(100));



CREATE TABLE hydro_cat_priority(
"id" integer PRIMARY KEY,
"code" character varying(16) NOT NULL,
"observ" character varying(100));


-- ----------------------------
-- CRM FUNCTIONS
-- ----------------------------


-- FUNCTION TO UPDATE VALUES FROM CRM TO GIS
CREATE OR REPLACE FUNCTION crm.gw_fct_crm2gis()   RETURNS void AS
$BODY$DECLARE


BEGIN

    -- Search path
    SET search_path = "ws", public;

    --Delete previous

    RETURN;
        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


  
  -- ----------------------------
-- CRM MANAGEMENT
-- ----------------------------
 
--ROLE CREATION
CREATE ROLE role_crm NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
GRANT ALL ON DATABASE "gis" TO "role_crm" ;
GRANT ALL ON SCHEMA "crm" TO "role_crm";


-- ROLE PERMISSIONS
GRANT ALL ON ALL TABLES IN SCHEMA "crm" TO "role_crm";
GRANT ALL ON ALL SEQUENCES IN SCHEMA "crm" TO "role_crm";
GRANT ALL ON ALL FUNCTIONS IN SCHEMA "crm" TO "role_crm";


  



