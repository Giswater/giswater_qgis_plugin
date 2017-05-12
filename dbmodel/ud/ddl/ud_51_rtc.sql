/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
 */
SET search_path = "SCHEMA_NAME", public, pg_catalog;


  
-- ----------------------------
-- tables structure
-- --------------------------

CREATE TABLE "rtc_hydrometer" (
hydrometer_id character varying(16) NOT NULL,
CONSTRAINT rtc_hydrometer_pkey PRIMARY KEY (hydrometer_id)
);



CREATE TABLE "rtc_options" (
"id" varchar(16),
"rtc_status" varchar(3),
"period_id" varchar(16),
"return_coeff" float,
"peak_coeff" float,
CONSTRAINT rtc_options_pkey PRIMARY KEY (id)
);


CREATE TABLE rtc_hydrometer_x_connec (
  hydrometer_id character varying(16) NOT NULL,
  connec_id character varying(16),
  CONSTRAINT rtc_hydrometer_x_connec_pkey PRIMARY KEY (hydrometer_id)
);



CREATE TABLE rtc_scada_node (
  scada_id character varying(16) NOT NULL,
  node_id character varying(16),
  CONSTRAINT rtc_scada_node_pkey PRIMARY KEY (scada_id)
);



CREATE TABLE rtc_scada_x_dma (
  id serial NOT NULL,
  scada_id character varying(16) NOT NULL,
  dma_id character varying(16),
  flow_sign int2,
  CONSTRAINT rtc_scada_dma_pkey PRIMARY KEY (id)
);


CREATE TABLE rtc_scada_x_sector (
  id serial NOT NULL,
  scada_id character varying(16) NOT NULL,
  sector_id character varying(16),
  flow_sign int2,
  CONSTRAINT rtc_scada_sector_pkey PRIMARY KEY (scada_id)
);






-- ----------------------------
-- Value domain
-- --------------------------

CREATE TABLE rtc_value_opti_coef (
  id character varying(16) NOT NULL,
    CONSTRAINT rtc_value_opti_coef_pkey PRIMARY KEY (id)
);

CREATE TABLE rtc_value_opti_status (
  id character varying(16) NOT NULL,
    CONSTRAINT rtc_value_opti_status_pkey PRIMARY KEY (id)
);