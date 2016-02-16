/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
 */



-- ----------------------------
-- Sequences structure
-- ----------------------------
  
CREATE SEQUENCE "wsp"."rtc_scada_x_value_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 

CREATE SEQUENCE "wsp"."rtc_hydrometer_x_value_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "wsp"."rtc_dma_parameters_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- ----------------------------
-- tables structure catalog
-- --------------------------


CREATE TABLE "wsp".cat_scada
(
id character varying(16) NOT NULL,
data_type character varying(30),
units character varying(12),
text1 character varying(100),
text2 character varying(100),
text3 character varying(100),
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_scada_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
  );


CREATE TABLE "wsp".cat_hydrometer
(
id character varying(16) NOT NULL,
text1 character varying(100),
text2 character varying(100),
text3 character varying(100),
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_hydrometer_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
  );

  

-- ----------------------------
-- tables structure
-- --------------------------


CREATE TABLE "wsp".rtc_scada_arc
(
  scada_id character varying(16) NOT NULL,
  scdcat_id character varying(16),
  arc_id character varying(16),
  CONSTRAINT rtc_scada_arc_pkey PRIMARY KEY (scada_id)
)
WITH (
  OIDS=FALSE
  );
  


CREATE TABLE "wsp".rtc_scada_node
(
  scada_id character varying(16) NOT NULL,
  scdcat_id character varying(16),
  node_id character varying(16),
  CONSTRAINT rtc_scada_node_pkey PRIMARY KEY (scada_id)
)
WITH (
  OIDS=FALSE
  );



CREATE TABLE "wsp".rtc_scada_x_value
(
  id int8 DEFAULT nextval('"wsp".rtc_scada_x_value_seq'::regclass) NOT NULL,
  scada_id character varying(16),
  value numeric (12,6),
  status varchar (3),
  date timestamp (6) without time zone,
  CONSTRAINT rtc_scada_x_value_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
  );
  


CREATE TABLE "wsp".rtc_hydrometer_x_connec
(
  hydrometer_id character varying(16) NOT NULL,
  connec_id character varying(16),
  hydrocat_id character varying(16),
  CONSTRAINT rtc_hydrometer_x_connec_pkey PRIMARY KEY (hydrometer_id)
)
WITH (
  OIDS=FALSE
  );



CREATE TABLE "wsp".rtc_hydrometer_x_value
(
  id int8 DEFAULT nextval('"wsp".rtc_hydrometer_x_value_seq'::regclass) NOT NULL,
  hydrometer_id character varying(16),
  value numeric (12,6),
  date timestamp (6) without time zone,
  CONSTRAINT rtc_hydrometer_x_value_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
  );


CREATE TABLE "wsp".rtc_period
(
  id character varying(16) NOT NULL,
  starttime timestamp (6) without time zone,
  endtime timestamp (6) without time zone,
  period character varying(16),
  comment character varying(100),
  CONSTRAINT rtc_dma_period_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
  );


CREATE TABLE "wsp".rtc_dma_parameters (
  id int8 DEFAULT nextval('"wsp".rtc_dma_parameters_seq'::regclass) NOT NULL,
  dma_id character varying(16),
  period_id character varying(16),
  scada_value numeric (12,6),
  hydrometer_value numeric (12,6),
  min_coef numeric (6,4),
  max_coef numeric (6,4),

  CONSTRAINT rtc_dma_parameters_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
  );


CREATE TABLE "wsp".rtc_inp_demand
(
  node_id varchar(16) COLLATE "default" NOT NULL,
  value numeric (12,6),
  text varchar(100) COLLATE "default",
  CONSTRAINT rtc_demand_pkey PRIMARY KEY (node_id)
)
WITH (
  OIDS=FALSE
  );





 -- ----------------------------
-- foreign keys
-- -----------------------------

ALTER TABLE "wsp"."rtc_scada_arc" ADD FOREIGN KEY ("scdcat_id") REFERENCES "wsp"."cat_scada" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "wsp"."rtc_scada_arc" ADD FOREIGN KEY ("arc_id") REFERENCES "wsp"."arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "wsp"."rtc_scada_node" ADD FOREIGN KEY ("scdcat_id") REFERENCES "wsp"."cat_scada" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "wsp"."rtc_scada_node" ADD FOREIGN KEY ("node_id") REFERENCES "wsp"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "wsp"."connec" ADD FOREIGN KEY ("link") REFERENCES "wsp"."link" ("link_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "wsp"."rtc_hydrometer_x_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "wsp"."connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "wsp"."rtc_hydrometer_x_connec" ADD FOREIGN KEY ("hydrocat_id") REFERENCES "wsp"."cat_hydrometer" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "wsp"."rtc_dma_parameters" ADD FOREIGN KEY ("dma_id") REFERENCES "wsp"."dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "wsp"."rtc_dma_parameters" ADD FOREIGN KEY ("period_id") REFERENCES "wsp"."rtc_period" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "wsp"."rtc_inp_demand" ADD FOREIGN KEY ("node_id") REFERENCES "wsp"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;


