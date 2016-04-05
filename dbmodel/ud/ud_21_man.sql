/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



-- ----------------------------
-- Sequences
-- --------------------------

CREATE SEQUENCE "sample_ud"."element_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE "sample_ud"."element_x_node_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "sample_ud"."element_x_connec_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE "sample_ud"."element_x_gully_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    

-----------------
-- SYSTEM TABLE
-----------------

CREATE TABLE "sample_ud"."element_type" (
"id" varchar(18) COLLATE "default" NOT NULL,
"event_table" varchar(18) COLLATE "default" NOT NULL,
CONSTRAINT element_type_pkey PRIMARY KEY (id)
);



-----------------
-- CATALOGS
-----------------

CREATE TABLE "sample_ud"."cat_mat_element" (
"id" varchar(30) COLLATE "default",
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
CONSTRAINT cat_mat_element_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."cat_element" (
"id" varchar(30) COLLATE "default" NOT NULL,
"elementtype_id" varchar(30) COLLATE "default",
"matcat_id" varchar(30) COLLATE "default",
"geometry" varchar(30) COLLATE "default",
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_element_pkey PRIMARY KEY (id)
);



CREATE TABLE "sample_ud"."cat_connec" (
"id" varchar(30) COLLATE "default" NOT NULL,
"type" varchar(16) COLLATE "default",
"matcat_id" varchar (16) COLLATE "default",
"shape" varchar(16) COLLATE "default",
"tsect_id" varchar(16) COLLATE "default",
"curve_id" varchar(16) COLLATE "default",
"geom1" numeric(12,4),
"geom2" numeric(12,4) DEFAULT 0.00,
"geom3" numeric(12,4) DEFAULT 0.00,
"geom4" numeric(12,4) DEFAULT 0.00,
"geom_r" varchar(20) COLLATE "default",
"short_des" varchar(16) COLLATE "default",
"descript" varchar(255) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_connec_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."cat_grate" (
"id" varchar(30) COLLATE "default" NOT NULL,
"type" varchar(30) COLLATE "default" NOT NULL,
"matcat_id" varchar (16) COLLATE "default",
"length" numeric(12,4),
"width" numeric(12,4) DEFAULT 0.00,
"total_area" numeric(12,4) DEFAULT 0.00,
"efective_area" numeric(12,4) DEFAULT 0.00,
"n_barr_l" numeric(12,4) DEFAULT 0.00,
"n_barr_w" numeric(12,4) DEFAULT 0.00,
"n_barr_diag" numeric(12,4) DEFAULT 0.00,
"a_param" numeric(12,4) DEFAULT 0.00,
"b_param" numeric(12,4) DEFAULT 0.00,
"descript" varchar(255) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_grate_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."cat_soil" (
"id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
CONSTRAINT cat_soil_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."cat_builder" (
"id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
CONSTRAINT cat_builder_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."cat_work" (
"id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
CONSTRAINT cat_work_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."cat_owner" (
"id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(512) COLLATE "default",
"link" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
CONSTRAINT cat_owner_pkey PRIMARY KEY (id)
);



-----------
-- TYPE
-----------

CREATE TABLE "sample_ud"."man_type_category" (
"id" varchar(20) COLLATE "default" NOT NULL,
"observ" varchar(50) COLLATE "default",
CONSTRAINT man_type_category_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."man_type_fluid" (
"id" varchar(20) COLLATE "default" NOT NULL,
"observ" varchar(50) COLLATE "default",
CONSTRAINT man_type_fluid_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."man_type_location" (
"id" varchar(20) COLLATE "default" NOT NULL,
"observ" varchar(50) COLLATE "default",
CONSTRAINT man_type_location_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."type_connec" (
"id" varchar(20) COLLATE "default" NOT NULL,
"observ" varchar(50) COLLATE "default",
CONSTRAINT type_connec_pkey PRIMARY KEY (id)
);



--------------------
-- Table structure
--------------------

CREATE TABLE "sample_ud"."dma" (
"dma_id" varchar(30) COLLATE "default" NOT NULL,
"sector_id" varchar(30) COLLATE "default",
"descript" varchar(255) COLLATE "default",
"observ" character varying(512),
"the_geom" public.geometry (MULTIPOLYGON, 25831),
CONSTRAINT dma_pkey PRIMARY KEY (dma_id)
);





CREATE TABLE "sample_ud"."connec" (
"connec_id" varchar DEFAULT nextval('"sample_ud".connec_seq'::regclass) NOT NULL,
"top_elev" numeric(12,4),
"ymax" numeric(12,4),
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
"ownercat_id" varchar(30) COLLATE "default",
"adress_01" varchar(50) COLLATE "default",
"adress_02" varchar(50) COLLATE "default",
"adress_03" varchar(50) COLLATE "default",
"descript" varchar(254) COLLATE "default",
"link" character varying(512),
"verified" varchar(4) COLLATE "default",
"the_geom" public.geometry (POINT, 25831),
CONSTRAINT connec_pkey PRIMARY KEY (connec_id)
);


CREATE TABLE "sample_ud"."link" (
link_id varchar (16) DEFAULT nextval('"sample_ud".link_seq'::regclass) NOT NULL,
connec_id varchar(16) COLLATE "default",
the_geom public.geometry (LINESTRING, 25831),
CONSTRAINT link_pkey PRIMARY KEY (link_id)
);


CREATE TABLE "sample_ud"."gully" (
"gully_id" varchar(16) COLLATE "default" NOT NULL,
"top_elev" numeric(12,4),
"ymax" numeric(12,4),
"sandbox" numeric(12,4),
"matcat_id" varchar(18) COLLATE "default",
"gratecat_id" varchar(18) COLLATE "default",
"units" int2,
"groove" varchar(3) COLLATE "default",
"arccat_id" varchar(18) COLLATE "default",
"siphon" varchar(3) COLLATE "default",
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
"ownercat_id" varchar(30) COLLATE "default",
"adress_01" varchar(50) COLLATE "default",
"adress_02" varchar(50) COLLATE "default",
"adress_03" varchar(50) COLLATE "default",
"descript" varchar(254) COLLATE "default",
"link" character varying(512),
"verified" varchar(4) COLLATE "default",
"the_geom" public.geometry (POINT, 25831),
CONSTRAINT gully_pkey PRIMARY KEY (gully_id)
);




-- ----------------------------
-- Table structure for node features
-- ----------------------------


CREATE TABLE "sample_ud"."man_junction" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_junction_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "sample_ud"."man_storage" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_storage_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "sample_ud"."man_outfall" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_outfall_pkey PRIMARY KEY (node_id)
);





-- ----------------------------
-- Table structure for arc derivades
-- ----------------------------

CREATE TABLE "sample_ud"."man_virtual" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT man_virtualarc_pkey PRIMARY KEY (arc_id)
);


CREATE TABLE "sample_ud"."man_conduit" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"add_info" varchar(255) COLLATE "default",
CONSTRAINT man_conduit_pkey PRIMARY KEY (arc_id)
);




-- ----------------------------------
-- Table structure for element
-- ----------------------------------

CREATE TABLE "sample_ud"."element" (
"element_id" varchar(16) DEFAULT nextval('"sample_ud".element_seq'::regclass) NOT NULL,
"elementcat_id" varchar(30) COLLATE "default",
"state" character varying(16) NOT NULL,
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"location_type" varchar(18) COLLATE "default",
"workcat_id" varchar(255) COLLATE "default",
"buildercat_id" varchar(30) COLLATE "default",
"builtdate" timestamp (6) without time zone,
"ownercat_id" varchar(30) COLLATE "default",
"enddate" timestamp (6) without time zone,
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT element_pkey PRIMARY KEY (element_id)
);


CREATE TABLE "sample_ud"."element_x_node" (
"id" varchar(16) DEFAULT nextval('"sample_ud".element_x_node_seq'::regclass) NOT NULL,
"element_id" varchar(16) COLLATE "default",
"node_id" varchar(16) COLLATE "default",
CONSTRAINT element_x_node_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."element_x_connec" (
"id" varchar(16) DEFAULT nextval('"sample_ud".element_x_connec_seq'::regclass) NOT NULL,
"element_id" varchar(16) COLLATE "default",
"connec_id" varchar(16) COLLATE "default",
CONSTRAINT element_x_connec_pkey PRIMARY KEY (id)
);

CREATE TABLE "sample_ud"."element_x_gully" (
"id" varchar(16) DEFAULT nextval('"sample_ud".element_x_gully_seq'::regclass) NOT NULL,
"element_id" varchar(16) COLLATE "default",
"gully_id" varchar(16) COLLATE "default",
CONSTRAINT element_x_gully_pkey PRIMARY KEY (id)
);



--------
-- FK
--------

ALTER TABLE "sample_ud"."cat_element" ADD FOREIGN KEY ("elementtype_id") REFERENCES "sample_ud"."element_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."cat_element" ADD FOREIGN KEY ("matcat_id") REFERENCES "sample_ud"."cat_mat_element" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."cat_connec" ADD FOREIGN KEY ("matcat_id") REFERENCES "sample_ud"."cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."cat_connec" ADD FOREIGN KEY ("type") REFERENCES "sample_ud"."type_connec" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."connec" ADD FOREIGN KEY ("connecat_id") REFERENCES "sample_ud"."cat_connec" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."connec" ADD FOREIGN KEY ("sector_id") REFERENCES "sample_ud"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."dma" ADD FOREIGN KEY ("sector_id") REFERENCES "sample_ud"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."link" ADD FOREIGN KEY ("connec_id") REFERENCES "sample_ud"."connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."gully" ADD FOREIGN KEY ("gratecat_id") REFERENCES "sample_ud"."cat_grate" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."gully" ADD FOREIGN KEY ("arccat_id") REFERENCES "sample_ud"."cat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."gully" ADD FOREIGN KEY ("matcat_id") REFERENCES "sample_ud"."cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."gully" ADD FOREIGN KEY ("groove") REFERENCES "sample_ud"."value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."gully" ADD FOREIGN KEY ("siphon") REFERENCES "sample_ud"."value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."node" ADD FOREIGN KEY ("dma_id") REFERENCES "sample_ud"."dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."arc" ADD FOREIGN KEY ("dma_id") REFERENCES "sample_ud"."dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."connec" ADD FOREIGN KEY ("dma_id") REFERENCES "sample_ud"."dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."gully" ADD FOREIGN KEY ("dma_id") REFERENCES "sample_ud"."dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."node" ADD FOREIGN KEY ("soilcat_id") REFERENCES "sample_ud"."cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."arc" ADD FOREIGN KEY ("soilcat_id") REFERENCES "sample_ud"."cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."connec" ADD FOREIGN KEY ("soilcat_id") REFERENCES "sample_ud"."cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."gully" ADD FOREIGN KEY ("soilcat_id") REFERENCES "sample_ud"."cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."node" ADD FOREIGN KEY ("category_type") REFERENCES "sample_ud"."man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."arc" ADD FOREIGN KEY ("category_type") REFERENCES "sample_ud"."man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."connec" ADD FOREIGN KEY ("category_type") REFERENCES "sample_ud"."man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."gully" ADD FOREIGN KEY ("category_type") REFERENCES "sample_ud"."man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."node" ADD FOREIGN KEY ("fluid_type") REFERENCES "sample_ud"."man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."arc" ADD FOREIGN KEY ("fluid_type") REFERENCES "sample_ud"."man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."connec" ADD FOREIGN KEY ("fluid_type") REFERENCES "sample_ud"."man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."gully" ADD FOREIGN KEY ("fluid_type") REFERENCES "sample_ud"."man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."node" ADD FOREIGN KEY ("location_type") REFERENCES "sample_ud"."man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."arc" ADD FOREIGN KEY ("location_type") REFERENCES "sample_ud"."man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."connec" ADD FOREIGN KEY ("location_type") REFERENCES "sample_ud"."man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."gully" ADD FOREIGN KEY ("location_type") REFERENCES "sample_ud"."man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."node" ADD FOREIGN KEY ("workcat_id") REFERENCES "sample_ud"."cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."arc" ADD FOREIGN KEY ("workcat_id") REFERENCES "sample_ud"."cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."connec" ADD FOREIGN KEY ("workcat_id") REFERENCES "sample_ud"."cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."gully" ADD FOREIGN KEY ("workcat_id") REFERENCES "sample_ud"."cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."node" ADD FOREIGN KEY ("buildercat_id") REFERENCES "sample_ud"."cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."arc" ADD FOREIGN KEY ("buildercat_id") REFERENCES "sample_ud"."cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."connec" ADD FOREIGN KEY ("buildercat_id") REFERENCES "sample_ud"."cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."gully" ADD FOREIGN KEY ("buildercat_id") REFERENCES "sample_ud"."cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."node" ADD FOREIGN KEY ("ownercat_id") REFERENCES "sample_ud"."cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."arc" ADD FOREIGN KEY ("ownercat_id") REFERENCES "sample_ud"."cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."connec" ADD FOREIGN KEY ("ownercat_id") REFERENCES "sample_ud"."cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."gully" ADD FOREIGN KEY ("ownercat_id") REFERENCES "sample_ud"."cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;




ALTER TABLE "sample_ud"."man_junction" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."man_storage" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."man_outfall" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."man_virtual" ADD FOREIGN KEY ("arc_id") REFERENCES "sample_ud"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."man_conduit" ADD FOREIGN KEY ("arc_id") REFERENCES "sample_ud"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."element" ADD FOREIGN KEY ("elementcat_id") REFERENCES "sample_ud"."cat_element" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."element" ADD FOREIGN KEY ("state") REFERENCES "sample_ud"."value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."element" ADD FOREIGN KEY ("location_type") REFERENCES "sample_ud"."man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."element" ADD FOREIGN KEY ("workcat_id") REFERENCES "sample_ud"."cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."element" ADD FOREIGN KEY ("buildercat_id") REFERENCES "sample_ud"."cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."element" ADD FOREIGN KEY ("ownercat_id") REFERENCES "sample_ud"."cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."element" ADD FOREIGN KEY ("verified") REFERENCES "sample_ud"."value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "sample_ud"."element_x_node" ADD FOREIGN KEY ("element_id") REFERENCES "sample_ud"."element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."element_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."element_x_connec" ADD FOREIGN KEY ("element_id") REFERENCES "sample_ud"."element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."element_x_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "sample_ud"."connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."element_x_gully" ADD FOREIGN KEY ("element_id") REFERENCES "sample_ud"."element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."element_x_gully" ADD FOREIGN KEY ("gully_id") REFERENCES "sample_ud"."gully" ("gully_id") ON DELETE CASCADE ON UPDATE CASCADE;
