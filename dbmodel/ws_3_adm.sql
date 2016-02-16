/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
 */

-- ----------------------------
-- Structure for log
-- ----------------------------


CREATE SEQUENCE "wsp".adm_log_node_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  CREATE SEQUENCE "wsp".adm_log_arc_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  CREATE SEQUENCE "wsp".adm_log_connec_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;




CREATE TABLE "wsp"."adm_list_user" (
"id" varchar(16) COLLATE "default" NOT NULL,
"name" varchar(40) COLLATE "default" NOT NULL,
"surname_1" varchar(40) COLLATE "default" NOT NULL,
"surname_2" varchar(40) COLLATE "default" NOT NULL,
"role" varchar(40) COLLATE "default" NOT NULL,
"descript" varchar(50) COLLATE "default",
"email" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default",
CONSTRAINT admin_list_user_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);




CREATE TABLE wsp.adm_log_node(
"id" int8 DEFAULT nextval('"wsp".adm_log_node_seq'::regclass) NOT NULL,

"node_id" varchar(16) COLLATE "default" NOT NULL,
"elevation" numeric(12,4),
"depth" numeric(12,4),
"nodecat_id" varchar(30) COLLATE "default",
"epa_type" varchar(16) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
"state" character varying(16),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"rotation" numeric (6,3),
"dma_id" varchar(30) COLLATE "default",
"soilcat_id" varchar(16) COLLATE "default",
"category_type" varchar(18) COLLATE "default",
"fluid_type" varchar(18) COLLATE "default",
"location_type" varchar(18) COLLATE "default",
"workcat_id" varchar(255) COLLATE "default",
"buildercat_id" varchar(30) COLLATE "default",
"builtdate" timestamp (6) without time zone,
"text" varchar(50) COLLATE "default",
"adress_01" varchar(50) COLLATE "default",
"adress_02" varchar(50) COLLATE "default",
"adress_03" varchar(50) COLLATE "default",
"descript" varchar(254) COLLATE "default",
"link" character varying(512),
"verified" varchar(4) COLLATE "default",
"the_geom" public.geometry (POINT, 25831),

"operation" character varying(6),
"user" varchar (20),
"date" timestamp (6) without time zone,
CONSTRAINT adm_log_node_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);
  



CREATE TABLE wsp.adm_log_arc(
"id" int8 DEFAULT nextval('"wsp".adm_log_arc_seq'::regclass) NOT NULL,

"arc_id" varchar(16) COLLATE "default" NOT NULL,
"node_1" varchar(16) COLLATE "default",
"node_2" varchar(16) COLLATE "default",
"arccat_id" varchar(30) COLLATE "default",
"epa_type" varchar(16) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
"state" character varying(16),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"rotation" numeric (6,3),
"custom_length" numeric (12,2),
"dma_id" varchar(30) COLLATE "default",
"soilcat_id" varchar(16) COLLATE "default",
"category_type" varchar(18) COLLATE "default",
"fluid_type" varchar(18) COLLATE "default",
"location_type" varchar(18) COLLATE "default",
"workcat_id" varchar(255) COLLATE "default",
"buildercat_id" varchar(30) COLLATE "default",
"builtdate" timestamp (6) without time zone,
"text" varchar(50) COLLATE "default",
"adress_01" varchar(50) COLLATE "default",
"adress_02" varchar(50) COLLATE "default",
"adress_03" varchar(50) COLLATE "default",
"descript" varchar(254) COLLATE "default",
"link" character varying(512),
"verified" varchar(4) COLLATE "default",
"the_geom" public.geometry (LINESTRING, 25831),

"operation" character varying(6),
"user" varchar (20),
"date" timestamp (6) without time zone,
CONSTRAINT adm_log_arc_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);
  
 


CREATE TABLE wsp.adm_log_connec(
"id" int8 DEFAULT nextval('"wsp".adm_log_connec_seq'::regclass) NOT NULL,

"connec_id" varchar(16) COLLATE "default" NOT NULL,
"elevation" numeric(12,4),
"depth" numeric(12,4),
"connecat_id" varchar(30) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
"state" character varying(16),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"rotation" numeric (6,3),
"dma_id" varchar(30) COLLATE "default",
"soilcat_id" varchar(16) COLLATE "default",
"category_type" varchar(18) COLLATE "default",
"fluid_type" varchar(18) COLLATE "default",
"location_type" varchar(18) COLLATE "default",
"workcat_id" varchar(255) COLLATE "default",
"buildercat_id" varchar(30) COLLATE "default",
"builtdate" timestamp (6) without time zone,
"text" varchar(50) COLLATE "default",
"adress_01" varchar(50) COLLATE "default",
"adress_02" varchar(50) COLLATE "default",
"adress_03" varchar(50) COLLATE "default",
"descript" varchar(254) COLLATE "default",
"link" character varying(512),
"verified" varchar(4) COLLATE "default",
"the_geom" public.geometry (POINT, 25831),

"operation" character varying(6),
"user" varchar (20),
"date" timestamp (6) without time zone,
CONSTRAINT adm_log_connec_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);
  


 
 