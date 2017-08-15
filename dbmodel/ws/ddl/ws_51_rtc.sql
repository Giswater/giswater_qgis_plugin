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
hydrometer_id character varying(16) NOT NULL PRIMARY KEY,
);



CREATE TABLE rtc_scada_node (
scada_id character varying(16) NOT NULL PRIMARY KEY,
node_id character varying(16)
);



CREATE TABLE rtc_scada_x_dma (
id serial PRIMARY KEY,
scada_id character varying(16) NOT NULL,
dma_id character varying(16),
flow_sign int2
);


CREATE TABLE rtc_scada_x_sector (
id serial PRIMARY KEY,
scada_id character varying(16) NOT NULL,
sector_id character varying(16),
flow_sign int2,
);



CREATE TABLE rtc_hydrometer_x_connec (
hydrometer_id character varying(16) NOT NULL PRIMARY KEY,
connec_id character varying(16)
);



-- ----------------------------
-- Value domain
-- --------------------------





