/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
 */


-- ----------------------------
-- Sequences structure
-- ----------------------------
  

CREATE SEQUENCE "SCHEMA_NAME"."rtc_dma_parameters_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."rtc_scada_x_dma_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."rtc_scada_x_sector_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


  
-- ----------------------------
-- tables structure
-- --------------------------



CREATE TABLE "SCHEMA_NAME".rtc_scada_node (
  scada_id character varying(16) NOT NULL,
  node_id character varying(16),
  CONSTRAINT rtc_scada_node_pkey PRIMARY KEY (scada_id)
);



CREATE TABLE "SCHEMA_NAME".rtc_scada_x_dma (
  id int4 DEFAULT nextval('"SCHEMA_NAME".rtc_scada_x_dma_seq'::regclass) NOT NULL,
  scada_id character varying(16) NOT NULL,
  dma_id character varying(16),
  flow_sign int2,
  CONSTRAINT rtc_scada_dma_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME".rtc_scada_x_sector (
  id int4 DEFAULT nextval('"SCHEMA_NAME".rtc_scada_x_sector_seq'::regclass) NOT NULL,
  scada_id character varying(16) NOT NULL,
  sector_id character varying(16),
  flow_sign int2,
  CONSTRAINT rtc_scada_sector_pkey PRIMARY KEY (scada_id)
);



CREATE TABLE "SCHEMA_NAME".rtc_hydrometer_x_connec (
  hydrometer_id character varying(16) NOT NULL,
  connec_id character varying(16),
  CONSTRAINT rtc_hydrometer_x_connec_pkey PRIMARY KEY (hydrometer_id)
);



-- ----------------------------
-- Value domain
-- --------------------------

CREATE TABLE "SCHEMA_NAME".rtc_value_coefficient (
  id character varying(16) NOT NULL,
    CONSTRAINT rtc_value_coeffiecient PRIMARY KEY (id)
);


-- ----------------------------
-- Table structure for SELECTORS
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."rtc_selector_period" (
"id" varchar(16),
CONSTRAINT rtc_selector_period_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."rtc_selector_coefficient" (
"id" varchar(16),
CONSTRAINT rtc_selector_coeffiecient_pkey PRIMARY KEY (id)
);





 -- ----------------------------
-- foreign keys
-- -----------------------------

ALTER TABLE "SCHEMA_NAME"."rtc_scada_node" ADD FOREIGN KEY ("scada_id") REFERENCES "SCHEMA_NAME"."ext_rtc_scada" ("scada_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."rtc_scada_node" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rtc_scada_x_dma" ADD FOREIGN KEY ("scada_id") REFERENCES "SCHEMA_NAME"."ext_rtc_scada" ("scada_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."rtc_scada_x_dma" ADD FOREIGN KEY ("dma_id") REFERENCES "SCHEMA_NAME"."dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rtc_scada_x_sector" ADD FOREIGN KEY ("scada_id") REFERENCES "SCHEMA_NAME"."ext_rtc_scada" ("scada_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."rtc_scada_x_sector" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rtc_hydrometer_x_connec" ADD FOREIGN KEY ("hydrometer_id") REFERENCES "SCHEMA_NAME"."ext_rtc_hydrometer" ("hydrometer_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."rtc_hydrometer_x_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "SCHEMA_NAME"."connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rtc_selector_period" ADD FOREIGN KEY ("id") REFERENCES "SCHEMA_NAME"."ext_cat_period" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."rtc_selector_coefficient" ADD FOREIGN KEY ("id") REFERENCES "SCHEMA_NAME"."rtc_value_coefficient" ("id") ON DELETE CASCADE ON UPDATE CASCADE;