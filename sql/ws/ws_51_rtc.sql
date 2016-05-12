/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
 */


-- ----------------------------
-- Sequences structure
-- ----------------------------
  
CREATE SEQUENCE "SCHEMA_NAME"."rtc_scada_x_value_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 
CREATE SEQUENCE "SCHEMA_NAME"."rtc_hydrometer_x_value_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."rtc_dma_parameters_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- ----------------------------
-- tables structure catalog
-- --------------------------

CREATE TABLE "SCHEMA_NAME".cat_scada(
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
CONSTRAINT cat_scada_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME".cat_hydrometer(
id character varying(16) NOT NULL,
text1 character varying(100),
text2 character varying(100),
text3 character varying(100),
"link" varchar(512)  ,
"url" varchar(512)  ,
"picture" varchar(512)  ,
"svg" varchar(50)  ,
CONSTRAINT cat_hydrometer_pkey PRIMARY KEY (id)
);

  
-- ----------------------------
-- tables structure
-- --------------------------

CREATE TABLE "SCHEMA_NAME".rtc_scada_node (
  scada_id character varying(16) NOT NULL,
  scdcat_id character varying(16),
  node_id character varying(16),
  CONSTRAINT rtc_scada_node_pkey PRIMARY KEY (scada_id)
);


CREATE TABLE "SCHEMA_NAME".rtc_scada_x_value (
  id int8 DEFAULT nextval('"SCHEMA_NAME".rtc_scada_x_value_seq'::regclass) NOT NULL,
  scada_id character varying(16),
  value numeric (12,6),
  status varchar (3),
  date timestamp (6) without time zone,
  CONSTRAINT rtc_scada_x_value_pkey PRIMARY KEY (id)
);
  

CREATE TABLE "SCHEMA_NAME".rtc_hydrometer_x_connec (
  hydrometer_id character varying(16) NOT NULL,
  connec_id character varying(16),
  hydrocat_id character varying(16),
  CONSTRAINT rtc_hydrometer_x_connec_pkey PRIMARY KEY (hydrometer_id)
);


CREATE TABLE "SCHEMA_NAME".rtc_hydrometer_x_value (
  id int8 DEFAULT nextval('"SCHEMA_NAME".rtc_hydrometer_x_value_seq'::regclass) NOT NULL,
  hydrometer_id character varying(16),
  value numeric (12,6),
  date timestamp (6) without time zone,
  CONSTRAINT rtc_hydrometer_x_value_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME".rtc_cat_period (
  id character varying(16) NOT NULL,
  starttime timestamp (6) without time zone,
  endtime timestamp (6) without time zone,
  period character varying(16),
  comment character varying(100),
  CONSTRAINT rtc_cat_period_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME".rtc_dma_parameters (
  id int8 DEFAULT nextval('"SCHEMA_NAME".rtc_dma_parameters_seq'::regclass) NOT NULL,
  dma_id character varying(16),
  periodcat_id character varying(16),
  scada_value numeric (12,6),
  hydrometer_value numeric (12,6),
  min_coef numeric (6,4),
  max_coef numeric (6,4),
  CONSTRAINT rtc_dma_parameters_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME".rtc_inp_demand (
  node_id varchar(16)   NOT NULL,
  value numeric (12,6),
  text varchar(100)  ,
  CONSTRAINT rtc_demand_pkey PRIMARY KEY (node_id)
);



 -- ----------------------------
-- foreign keys
-- -----------------------------

ALTER TABLE "SCHEMA_NAME"."rtc_scada_node" ADD FOREIGN KEY ("scdcat_id") REFERENCES "SCHEMA_NAME"."cat_scada" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."rtc_scada_node" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rtc_hydrometer_x_connec" ADD FOREIGN KEY ("hydrocat_id") REFERENCES "SCHEMA_NAME"."cat_hydrometer" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."rtc_hydrometer_x_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "SCHEMA_NAME"."connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rtc_dma_parameters" ADD FOREIGN KEY ("dma_id") REFERENCES "SCHEMA_NAME"."dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."rtc_dma_parameters" ADD FOREIGN KEY ("periodcat_id") REFERENCES "SCHEMA_NAME"."rtc_cat_period" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rtc_inp_demand" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

