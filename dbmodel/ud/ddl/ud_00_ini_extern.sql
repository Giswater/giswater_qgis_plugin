/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;




-- ----------------------------
-- SCADA
-- ----------------------------

CREATE SEQUENCE "ext_rtc_scada_x_value_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE "ext_rtc_scada_x_data_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




CREATE TABLE ext_cat_scada(
"id" character varying(16) NOT NULL,
"data_type" character varying(30),
"units" character varying(12),
"text1" character varying(100),
"text2" character varying(100),
"text3" character varying(100),
"link" varchar(512),
"url" varchar(512),
"picture" varchar(512),
"svg" varchar(50),
CONSTRAINT ext_cat_scada_pkey PRIMARY KEY (id)
);



CREATE TABLE ext_rtc_scada(
  "scada_id" character varying(16) NOT NULL,
  "cat_scada_id" character varying(16),
  "text" text,
  CONSTRAINT ext_rtc_scada_pkey PRIMARY KEY (scada_id)
);



CREATE TABLE ext_rtc_scada_x_value (
  "id" serial NOT NULL,
  "scada_id" character varying(16),
  "value" float, 
  "status" varchar (3),
  "timestamp" timestamp (6) without time zone,
  "interval_seconds" int4,  -- seconds
  CONSTRAINT ext_rtc_scada_x_value_pkey PRIMARY KEY (id)
);



CREATE TABLE ext_rtc_scada_x_data (
  "id" serial NOT NULL,
  "scada_id" character varying(16),
  "min" float,  -- l/s or mca
  "max" float,  -- l/s or mca
  "avg" float,  -- l/s or mca
  "sum" float,  
  "cat_period_id" varchar (16),
  CONSTRAINT ext_rtc_scada_x_data_pkey PRIMARY KEY (id)
);




