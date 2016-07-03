/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



-- ----------------------------
-- Base map
-- ----------------------------


-- Streeter

CREATE TABLE "SCHEMA_NAME"."ext_type_street" (
"id" varchar(20)   NOT NULL,
"observ" varchar(50)  ,
CONSTRAINT ext_type_street_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."ext_streetaxis" (
"id" varchar (16) NOT NULL,
"type" varchar(18),
"name" varchar(100),
"text" text,
"the_geom" public.geometry (LINESTRING, SRID_VALUE),
CONSTRAINT ext_streetaxis_pkey PRIMARY KEY (id)
);



-- Urban_structure


CREATE TABLE "SCHEMA_NAME"."ext_urban_propierties" (
"id" varchar (16) NOT NULL,
"dae_vod" varchar(30),
"streetaxis" varchar(16),
"postnumber" varchar(16),
"complement" varchar(16),
"placement" varchar(16),
"square" varchar(16),
"prdistrict" varchar(16),
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE),
CONSTRAINT ext_urban_propierties_pkey PRIMARY KEY (id)
);






-- ----------------------------
-- Time Period for CRM & SCADA integrated with math model
-- ----------------------------

CREATE TABLE "SCHEMA_NAME".ext_cat_period (
  id character varying(16) NOT NULL,
  starttime timestamp (6) without time zone,
  endtime timestamp (6) without time zone,
  period_seconds integer,
  comment character varying(100),
  CONSTRAINT ext_cat_period_pkey PRIMARY KEY (id)
);



-- ----------------------------
-- SCADA
-- ----------------------------

CREATE SEQUENCE "SCHEMA_NAME"."ext_rtc_scada_x_value_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE "SCHEMA_NAME"."ext_rtc_scada_x_data_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE SEQUENCE "SCHEMA_NAME"."ext_rtc_scada_dma_period_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE "SCHEMA_NAME".ext_cat_scada(
id character varying(16) NOT NULL,
data_type character varying(30),
units character varying(12),
text1 character varying(100),
text2 character varying(100),
text3 character varying(100),
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
"svg" varchar(50)  ,
CONSTRAINT ext_cat_scada_pkey PRIMARY KEY (id)
);




CREATE TABLE "SCHEMA_NAME".ext_rtc_scada(
  scada_id character varying(16) NOT NULL,
  cat_scada_id character varying(16),
  text text,
  CONSTRAINT ext_rtc_scada_pkey PRIMARY KEY (scada_id)
);



CREATE TABLE "SCHEMA_NAME".ext_rtc_scada_x_value (
  id int8 DEFAULT nextval('"SCHEMA_NAME".ext_rtc_scada_x_value_seq'::regclass) NOT NULL,
  scada_id character varying(16),
  value float, 
  status varchar (3),
  timestamp timestamp (6) without time zone,
  interval_seconds int4,  -- seconds
  CONSTRAINT ext_rtc_scada_x_value_pkey PRIMARY KEY (id)
);



CREATE TABLE "SCHEMA_NAME".ext_rtc_scada_x_data (
  id int8 DEFAULT nextval('"SCHEMA_NAME".ext_rtc_scada_x_data_seq'::regclass) NOT NULL,
  scada_id character varying(16),
  min float,  -- l/s or mca
  max float,  -- l/s or mca
  avg float,  -- l/s or mca
  sum float,  
  cat_period_id varchar (16),
  CONSTRAINT ext_rtc_scada_x_data_pkey PRIMARY KEY (id)
);



CREATE TABLE "SCHEMA_NAME".ext_rtc_scada_dma_period (
  id int8 DEFAULT nextval('"SCHEMA_NAME".ext_rtc_scada_dma_period_seq'::regclass) NOT NULL,
  dma_id character varying(16),
  m3_min float, 
  m3_max float,
  m3_avg float,
  m3_total_period float,  
  cat_period_id varchar (16),

  CONSTRAINT ext_rtc_scada_dma_period_pkey PRIMARY KEY (id)
);




-- ----------------------------
-- CRM (Hydrometer)
-- ----------------------------

 
CREATE SEQUENCE "SCHEMA_NAME"."ext_rtc_hydrometer_x_value_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."ext_rtc_hydrometer_x_data_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE "SCHEMA_NAME".ext_cat_hydrometer(
id character varying(16) NOT NULL,
text1 character varying(100),
text2 character varying(100),
text3 character varying(100),
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
"svg" varchar(50)  ,
CONSTRAINT ext_cat_hydrometer_pkey PRIMARY KEY (id)
);



CREATE TABLE "SCHEMA_NAME".ext_rtc_hydrometer(
  hydrometer_id character varying(16) NOT NULL,
  cat_hydrometer_id character varying(16),
  text text,
  CONSTRAINT ext_rtc_hydrometer_id_pkey PRIMARY KEY (hydrometer_id)
);


CREATE TABLE "SCHEMA_NAME".ext_rtc_hydrometer_x_value (
  id int8 DEFAULT nextval('"SCHEMA_NAME".ext_rtc_hydrometer_x_value_seq'::regclass) NOT NULL,
  hydrometer_id character varying(16),
  value float, 
  status varchar (3),
  timestamp timestamp (6) without time zone,
  interval_seconds int4,
  CONSTRAINT ext_rtc_hydrometer_x_value_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME".ext_rtc_hydrometer_x_data (
  id int8 DEFAULT nextval('"SCHEMA_NAME".ext_rtc_hydrometer_x_data_seq'::regclass) NOT NULL,
  hydrometer_id character varying(16),
  min float,  -- l/s or mca
  max float,  -- l/s or mca
  avg float,  -- l/s or mca
  sum float,  
  cat_period_id varchar (16),
  CONSTRAINT ext_rtc_hydrometer_x_data_pkey PRIMARY KEY (id)
);


