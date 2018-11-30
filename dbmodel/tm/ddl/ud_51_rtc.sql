/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
 */
SET search_path = "SCHEMA_NAME", public, pg_catalog;


  
-- ----------------------------
-- tables structure
-- --------------------------

CREATE TABLE "rtc_hydrometer" (
hydrometer_id character varying(16) NOT NULL,
link text,
CONSTRAINT rtc_hydrometer_pkey PRIMARY KEY (hydrometer_id)
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
  scada_id character varying(16),
  dma_id character varying(16),
  flow_sign int2,
  CONSTRAINT rtc_scada_dma_pkey PRIMARY KEY (id)
);


CREATE TABLE rtc_scada_x_sector (
  id serial NOT NULL,
  scada_id character varying(16),
  sector_id character varying(16),
  flow_sign int2,
  CONSTRAINT rtc_scada_sector_pkey PRIMARY KEY (scada_id)
);

