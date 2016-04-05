/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
-- COMMON SQL  (ARC & NODE) 
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------

-- ----------------------------
-- Sequence structure
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."plan_other_x_psector_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "SCHEMA_NAME"."plan_arc_x_ps_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "SCHEMA_NAME"."plan_node_x_ps_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "SCHEMA_NAME"."plan_psector_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
  
  
CREATE SEQUENCE "SCHEMA_NAME".plan_arc_x_pavement_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
  
  
CREATE SEQUENCE "SCHEMA_NAME"."price_unitary_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

  
CREATE SEQUENCE "SCHEMA_NAME"."price_simple_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE "SCHEMA_NAME"."price_compost_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE "SCHEMA_NAME".price_simple_value_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "SCHEMA_NAME".price_compost_value_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
  
-- ----------------------------
-- ALTER TABLES
-- ----------------------------

ALTER TABLE "SCHEMA_NAME".cat_arc ADD COLUMN z1 numeric (12,2);
ALTER TABLE "SCHEMA_NAME".cat_arc ADD COLUMN z2 numeric (12,2);
ALTER TABLE "SCHEMA_NAME".cat_arc ADD COLUMN width numeric (12,2);	
ALTER TABLE "SCHEMA_NAME".cat_arc ADD COLUMN area numeric (12,4);	
ALTER TABLE "SCHEMA_NAME".cat_arc ADD COLUMN estimated_depth numeric (12,2);
ALTER TABLE "SCHEMA_NAME".cat_arc ADD COLUMN 'bulk' numeric (12,2);
ALTER TABLE "SCHEMA_NAME".cat_arc ADD COLUMN cost_unit varchar (3);
ALTER TABLE "SCHEMA_NAME".cat_arc ADD COLUMN cost varchar (16);
ALTER TABLE "SCHEMA_NAME".cat_arc ADD COLUMN m2bottom_cost varchar (16);
ALTER TABLE "SCHEMA_NAME".cat_arc ADD COLUMN m3protec_cost varchar (16);

ALTER TABLE "SCHEMA_NAME".cat_node ADD COLUMN estimated_y numeric (12,2);
ALTER TABLE "SCHEMA_NAME".cat_node ADD COLUMN cost_unit varchar (3);
ALTER TABLE "SCHEMA_NAME".cat_node ADD COLUMN cost varchar (16);

ALTER TABLE "SCHEMA_NAME".cat_soil
"y_param" numeric(5,2),
"b" numeric(5,2),
"estimated_y" numeric(5,2),
"trenchlining" numeric(3,2),
"m3exc_cost" varchar (16),
"m3fill_cost" varchar (16),
"m3excess_cost" varchar (16),
"m2trenchl_cost" varchar (16),


ALTER TABLE "SCHEMA_NAME".cat_pavement
"thickness" numeric(12,2) DEFAULT 0.00,
"m2_cost" varchar (16)


----------------------------------------------
-- TABLE STRUCTURE FOR PLAN
---------------------------------------------a
CREATE TABLE "SCHEMA_NAME"."plan_arc_x_psector" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".plan_arc_x_ps_seq'::regclass) NOT NULL,
"arc_id" varchar(16) COLLATE "default",
"psector_id" varchar(16) COLLATE "default",
"atlas_id" varchar(16) COLLATE "default",
"descript" varchar(254) COLLATE "default" ,
 CONSTRAINT plan_arc_x_psector_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."plan_node_x_psector" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".plan_node_x_ps_seq'::regclass) NOT NULL,
"node_id" varchar(16) COLLATE "default",
"psector_id" varchar(16) COLLATE "default",
"atlas_id" varchar(16) COLLATE "default",
"descript" varchar(254) COLLATE "default" ,
 CONSTRAINT plan_node_x_psector_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."plan_other_x_psector" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".plan_other_x_psector_seq'::regclass) NOT NULL,
"price_id" varchar(16) COLLATE "default",
"measurement" numeric (12,2),
"psector_id" varchar(16) COLLATE "default",
"atlas_id" varchar(16) COLLATE "default",
"descript" varchar(254) COLLATE "default" ,
 CONSTRAINT plan_other_x_psector_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."plan_psector" (
"psector_id" varchar DEFAULT nextval('"SCHEMA_NAME".plan_psector_seq'::regclass) NOT NULL,
"descript" varchar(254) COLLATE "default",
"priority" varchar(16) COLLATE "default",
"text1" varchar(254) COLLATE "default",
"text2" varchar(254) COLLATE "default",
"observ" varchar(254) COLLATE "default",
"rotation" numeric (8,4),
"scale" numeric (8,2),
"sector_id" varchar(30) COLLATE "default",
"gexpenses" numeric (4,2),
"vat" numeric (4,2),
"other" numeric (4,2),
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE),
 CONSTRAINT plan_psector_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."plan_value_ps_priority" (
"id" varchar(16) COLLATE "default" NOT NULL,
"observ" varchar(254) COLLATE "default",
 CONSTRAINT plan_value_ps_priority_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


-- Used to show economic data
CREATE TABLE "SCHEMA_NAME".plan_economic_selection  
(
  id character varying(16) NOT NULL,
  observ character varying(254),
  CONSTRAINT plan_economic_selection_pkey PRIMARY KEY (id),
  CONSTRAINT plan_economic_selection_id_fkey FOREIGN KEY (id)
      REFERENCES "SCHEMA_NAME".plan_value_state (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);


-- Used to show a defined range of psector features on map composer
DROP TABLE IF EXISTS "SCHEMA_NAME"."plan_psector_selection";   
CREATE TABLE "SCHEMA_NAME".plan_psector_selection
(
  id character varying(16) NOT NULL,
  observ character varying(254),
  CONSTRAINT plan_psector_selection_pkey PRIMARY KEY (id),
  CONSTRAINT plan_psector_selection_id_fkey FOREIGN KEY (id)
      REFERENCES "SCHEMA_NAME".plan_psector (psector_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);


CREATE TABLE "SCHEMA_NAME".plan_arc_x_pavement
(
  "id" int4 DEFAULT nextval('"SCHEMA_NAME".plan_arc_x_pavement_seq'::regclass) NOT NULL,
  arc_id character varying(16),
  pavcat_id character varying(16),
  percent numeric (3,2),
  CONSTRAINT plan_arc_x_pavement_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
  );



----------------------------------------------
-- TABLE SCTRUCTURE FOR PRICE
---------------------------------------------

CREATE TABLE "SCHEMA_NAME"."cat_madeby" (
"id" varchar(16) COLLATE "default" NOT NULL,
"type" varchar(16) COLLATE "default",
"descript" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default",
CONSTRAINT cat_madeby_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."price_unitary_material" (
"id" varchar(30) COLLATE "default" NOT NULL,
"type" varchar(16) COLLATE "default",
"descript" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default",
"madeby_id" varchar(50) COLLATE "default",
CONSTRAINT cat_model_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;

ALTER TABLE "SCHEMA_NAME"."cat_model" ADD FOREIGN KEY ("madeby_id") REFERENCES "SCHEMA_NAME"."cat_madeby" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


-- ----------------------------
-- Table structure for cat_price_unitary_human
-- ----------------------------

-- ----------------------------
-- Table structure for cat_price_unitary_machine
-- ----------------------------

CREATE TABLE "SCHEMA_NAME".price_simple
(
  id character varying(16) NOT NULL,
  unit character varying(5),
  descript character varying(100),
  text character varying(1500),
  price numeric(12,4),
  obs character varying(16) NOT NULL,
  CONSTRAINT price_simple_id_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);


CREATE TABLE "SCHEMA_NAME".price_simple_value
(
  "id" int4 DEFAULT nextval('"SCHEMA_NAME".price_simple_value_seq'::regclass) NOT NULL,
  simple_id character varying(16),
  unitary_id character varying(16),
  value numeric (16,4),
  CONSTRAINT price_simple_value_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);


CREATE TABLE "SCHEMA_NAME".price_compost
(
  id character varying(16) NOT NULL,
  unit character varying(5),
  descript character varying(100),
  text character varying(1500),
  price numeric(12,4),
  CONSTRAINT price_compost_id_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);


CREATE TABLE "SCHEMA_NAME".price_compost_value
(
  "id" int4 DEFAULT nextval('"SCHEMA_NAME".price_compost_value_seq'::regclass) NOT NULL,
  compost_id character varying(16),
  simple_id character varying(16),
  value numeric (16,4),
  CONSTRAINT price_compost_value_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);


-- FOREIGN KEYS
ALTER TABLE "SCHEMA_NAME"."plan_arc_x_psector" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."plan_arc_x_psector" ADD FOREIGN KEY ("psector_id") REFERENCES "SCHEMA_NAME"."plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."plan_node_x_psector" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."plan_node_x_psector" ADD FOREIGN KEY ("psector_id") REFERENCES "SCHEMA_NAME"."plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."plan_other_x_psector" ADD FOREIGN KEY ("price_id") REFERENCES "SCHEMA_NAME"."price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."plan_other_x_psector" ADD FOREIGN KEY ("psector_id") REFERENCES "SCHEMA_NAME"."plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."plan_psector_selection" ADD FOREIGN KEY ("id") REFERENCES "SCHEMA_NAME"."plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."plan_economic_selection" ADD FOREIGN KEY ("id") REFERENCES "SCHEMA_NAME"."plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."plan_psector" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."plan_selection" ADD FOREIGN KEY ("id") REFERENCES "SCHEMA_NAME"."plan_value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "SCHEMA_NAME"."plan_arc_x_pavement" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."plan_arc_x_pavement" ADD FOREIGN KEY ("pavcat_id") REFERENCES "SCHEMA_NAME"."cat_pavement" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."price_simple_value" ADD FOREIGN KEY ("unitary_id") REFERENCES "SCHEMA_NAME"."price_unitary" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."price_simple_value" ADD FOREIGN KEY ("simple_id") REFERENCES "SCHEMA_NAME"."price_simple" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."price_compost_value" ADD FOREIGN KEY ("compost_id") REFERENCES "SCHEMA_NAME"."price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."price_compost_value" ADD FOREIGN KEY ("simple_id") REFERENCES "SCHEMA_NAME"."price_simple" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;



----------------------------------------------
-- VIEWS PRICE
---------------------------------------------
DROP VIEW IF EXISTS "SCHEMA_NAME"."v_price_compost" CASCADE; 
CREATE VIEW "SCHEMA_NAME"."v_price_compost" AS 
SELECT
  price_compost.id,
  price_compost.unit,
  price_compost.descript,
  (CASE WHEN (price_compost.price IS  NOT NULL) THEN price_compost.price::numeric(14,2) 
  ELSE (sum(price_simple.price*price_compost_value.value))::numeric(14,2) END) AS price 
FROM ("SCHEMA_NAME".price_compost
JOIN "SCHEMA_NAME".price_compost_value ON (((price_compost.id)::text = (price_compost_value.compost_id)::text))
JOIN "SCHEMA_NAME".price_simple ON (((price_simple.id)::text = (price_compost_value.simple_id)::text)))
GROUP BY price_compost.id, price_compost.unit, price_compost.descript;


CREATE VIEW "SCHEMA_NAME"."v_price_x_catsoil1" AS 
SELECT
  cat_soil.id,
  cat_soil.y_param,
  cat_soil.b,
  cat_soil.trenchlining,
  v_price_compost.price AS m3exc_cost
FROM ("SCHEMA_NAME".cat_soil
JOIN "SCHEMA_NAME".v_price_compost ON (((cat_soil."m3exc_cost")::text = (v_price_compost.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_price_x_catsoil2" AS
SELECT
  cat_soil.id,
  v_price_compost.price AS m3fill_cost
FROM ("SCHEMA_NAME".cat_soil
JOIN "SCHEMA_NAME".v_price_compost ON (((cat_soil."m3fill_cost")::text = (v_price_compost.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_price_x_catsoil3" AS
SELECT
  cat_soil.id,
  v_price_compost.price AS m3excess_cost
FROM ("SCHEMA_NAME".cat_soil
JOIN "SCHEMA_NAME".v_price_compost ON (((cat_soil."m3excess_cost")::text = (v_price_compost.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_price_x_catsoil4" AS
SELECT
  cat_soil.id,
   v_price_compost.price AS m2trenchl_cost
FROM ("SCHEMA_NAME".cat_soil
JOIN "SCHEMA_NAME".v_price_compost ON (((cat_soil."m2trenchl_cost")::text = (v_price_compost.id)::text)))
WHERE (((cat_soil.m2trenchl_cost)::text = (v_price_compost.id)::text)  OR  (cat_soil.m2trenchl_cost)::text = null);


CREATE VIEW "SCHEMA_NAME"."v_price_x_catsoil" AS
SELECT
  v_price_x_catsoil1.id,
  v_price_x_catsoil1.y_param,
  v_price_x_catsoil1.b,
  v_price_x_catsoil1.trenchlining,
  v_price_x_catsoil1.m3exc_cost,
  v_price_x_catsoil2.m3fill_cost,
  v_price_x_catsoil3.m3excess_cost,
  v_price_x_catsoil4.m2trenchl_cost
FROM ("SCHEMA_NAME".v_price_x_catsoil1
JOIN "SCHEMA_NAME".v_price_x_catsoil2 ON ((("SCHEMA_NAME".v_price_x_catsoil2.id)::text = ("SCHEMA_NAME".v_price_x_catsoil1.id)::text))
JOIN "SCHEMA_NAME".v_price_x_catsoil3 ON ((("SCHEMA_NAME".v_price_x_catsoil3.id)::text = ("SCHEMA_NAME".v_price_x_catsoil1.id)::text))
JOIN "SCHEMA_NAME".v_price_x_catsoil4 ON ((("SCHEMA_NAME".v_price_x_catsoil4.id)::text = ("SCHEMA_NAME".v_price_x_catsoil1.id)::text))
);


CREATE VIEW "SCHEMA_NAME"."v_price_x_catarc1" AS 
SELECT
	cat_arc.id,
	cat_arc.dint,
	cat_arc.z1,
	cat_arc.z2,
	cat_arc.width,
	cat_arc.area,
	cat_arc.bulk,
	cat_arc.estimated_depth,
	cat_arc.cost_unit,
	v_price_compost.price AS cost
FROM ("SCHEMA_NAME".cat_arc
JOIN "SCHEMA_NAME".v_price_compost ON (((cat_arc."cost")::text = (v_price_compost.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_price_x_catarc2" AS 
SELECT
	cat_arc.id,
	v_price_compost.price AS m2bottom_cost
FROM ("SCHEMA_NAME".cat_arc
JOIN "SCHEMA_NAME".v_price_compost ON (((cat_arc."m2bottom_cost")::text = (v_price_compost.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_price_x_catarc3" AS 
SELECT
	cat_arc.id,
	v_price_compost.price AS m3protec_cost
FROM ("SCHEMA_NAME".cat_arc
JOIN "SCHEMA_NAME".v_price_compost ON (((cat_arc."m3protec_cost")::text = (v_price_compost.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_price_x_catarc" AS 
SELECT
	v_price_x_catarc1.id,
	v_price_x_catarc1.dint,
	v_price_x_catarc1.z1,
	v_price_x_catarc1.z2,
	v_price_x_catarc1.width,
	v_price_x_catarc1.area,
	v_price_x_catarc1.bulk,
	v_price_x_catarc1.estimated_depth,
	v_price_x_catarc1.cost_unit,
	v_price_x_catarc1.cost,
	v_price_x_catarc2.m2bottom_cost,
	v_price_x_catarc3.m3protec_cost
FROM ("SCHEMA_NAME".v_price_x_catarc1
JOIN "SCHEMA_NAME".v_price_x_catarc2 ON ((("SCHEMA_NAME".v_price_x_catarc2.id)::text = ("SCHEMA_NAME".v_price_x_catarc1.id)::text))
JOIN "SCHEMA_NAME".v_price_x_catarc3 ON ((("SCHEMA_NAME".v_price_x_catarc3.id)::text = ("SCHEMA_NAME".v_price_x_catarc1.id)::text))
);


CREATE VIEW "SCHEMA_NAME"."v_price_x_catpavement" AS 
SELECT
	cat_pavement.id AS pavcat_id,
	cat_pavement.thickness,
	v_price_compost.price AS m2pav_cost
FROM ("SCHEMA_NAME".cat_pavement
JOIN "SCHEMA_NAME".v_price_compost ON (((cat_pavement."m2_cost")::text = (v_price_compost.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_price_x_catnode" AS 
SELECT
	cat_node.id,
	cat_node.estimated_depth,
	cat_node.cost_unit,
	v_price_compost.price AS cost
FROM ("SCHEMA_NAME".cat_node
JOIN "SCHEMA_NAME".v_price_compost ON (((cat_node."cost")::text = (v_price_compost.id)::text)));



---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
-- SPECIFIC SQL (UD)
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------

-- ----------------------------
-- View structure for v_plan_ml_arc
-- ----------------------------

CREATE VIEW "sanejament"."v_plan_ml_arc" AS 
SELECT 
arc.arc_id,
arc.y1,
arc.y2,
(CASE WHEN (v_inp_arc_x_node.y1*v_inp_arc_x_node.y2 =0::numeric) THEN v_price_x_catarc.estimated_y::numeric(12,2) ELSE ((v_inp_arc_x_node.y1+v_inp_arc_x_node.y2)/2)::numeric(12,2) END) AS mean_y,
arc.arccat_id,
v_price_x_catarc.geom1,
v_price_x_catarc.z1,
v_price_x_catarc.z2,
v_price_x_catarc.area,
v_price_x_catarc.width,
v_price_x_catarc.bulk,
v_price_x_catarc.cost_unit,
(v_price_x_catarc.cost)::numeric(12,2) AS arc_cost,
(v_price_x_catarc.m2bottom_cost)::numeric(12,2) AS m2bottom_cost,
(v_price_x_catarc.m3protec_cost)::numeric(12,2) AS m3protec_cost,
v_price_x_catsoil.id AS soilcat_id,
v_price_x_catsoil.y_param,
v_price_x_catsoil.b,
v_price_x_catsoil.trenchlining,
(v_price_x_catsoil.m3exc_cost)::numeric(12,2) AS m3exc_cost,
(v_price_x_catsoil.m3fill_cost)::numeric(12,2) AS m3fill_cost,
(v_price_x_catsoil.m3excess_cost)::numeric(12,2)AS m3excess_cost,
(v_price_x_catsoil.m2trenchl_cost)::numeric(12,2) AS m2trenchl_cost,
sum (v_price_x_catpavement.thickness*plan_arc_x_pavement.value)::numeric(12,2) AS thickness,
sum (v_price_x_catpavement.m2pav_cost::numeric(12,2)*plan_arc_x_pavement.value) AS m2pav_cost,
arc.state,
arc.the_geom

FROM "sanejament".arc
	JOIN sanejament.v_inp_arc_x_node ON ((((arc.arc_id)::text = (v_inp_arc_x_node.arc_id)::text)))
	JOIN sanejament.v_price_x_catarc ON ((((arc.arccat_id)::text = (v_price_x_catarc.id)::text)))
	JOIN sanejament.arc_dat ON ((((arc.arc_id)::text = (arc_dat.arc_id)::text)))
	JOIN sanejament.v_price_x_catsoil ON ((((arc_dat.soilcat_id)::text = (v_price_x_catsoil.id)::text)))
	JOIN sanejament.plan_arc_x_pavement ON ((((plan_arc_x_pavement.arc_id)::text = (arc.arc_id)::text)))
	JOIN sanejament.v_price_x_catpavement ON ((((v_price_x_catpavement.pavcat_id)::text = (plan_arc_x_pavement.pavcat_id)::text)))

	GROUP BY arc.arc_id, v_inp_arc_x_node.y1, v_inp_arc_x_node.y2, mean_y,arc.arccat_id, v_price_x_catarc.geom1,v_price_x_catarc.z1,v_price_x_catarc.z2,v_price_x_catarc.area,v_price_x_catarc.width,v_price_x_catarc.bulk, cost_unit, arc_cost, m2bottom_cost, m3protec_cost, v_price_x_catsoil.id, y_param, b, trenchlining, m3exc_cost, m3fill_cost, m3excess_cost, m2trenchl_cost,arc.state, arc.the_geom;
	

-- ----------------------------
-- View structure for v_plan_mlcost_arc
-- ----------------------------

CREATE OR REPLACE VIEW "sanejament"."v_plan_mlcost_arc" AS 

SELECT
v_plan_ml_arc.arc_id,
v_plan_ml_arc.arccat_id,
v_plan_ml_arc.cost_unit,
v_plan_ml_arc.arc_cost,
v_plan_ml_arc.m2bottom_cost,
v_plan_ml_arc.soilcat_id,
v_plan_ml_arc.m3exc_cost,
v_plan_ml_arc.m3fill_cost,
v_plan_ml_arc.m3excess_cost,
v_plan_ml_arc.m3protec_cost,
v_plan_ml_arc.m2trenchl_cost,
v_plan_ml_arc.m2pav_cost,

(2*((v_plan_ml_arc.mean_y+v_plan_ml_arc.z1+v_plan_ml_arc.bulk)/v_plan_ml_arc.y_param)+(v_plan_ml_arc.width)+v_plan_ml_arc.b*2)::numeric(12,3)							AS m2mlpavement,

((2*v_plan_ml_arc.b)+(v_plan_ml_arc.width))::numeric(12,3)  																												AS m2mlbase,

(v_plan_ml_arc.mean_y+v_plan_ml_arc.z1+v_plan_ml_arc.bulk-v_plan_ml_arc.thickness)::numeric(12,3)																		AS calculed_y,

((v_plan_ml_arc.trenchlining)*2*(v_plan_ml_arc.mean_y+v_plan_ml_arc.z1+v_plan_ml_arc.bulk-v_plan_ml_arc.thickness))::numeric(12,3)										AS m2mltrenchl,

((v_plan_ml_arc.mean_y+v_plan_ml_arc.z1+v_plan_ml_arc.bulk-v_plan_ml_arc.thickness)																																								
*((2*((v_plan_ml_arc.mean_y+v_plan_ml_arc.z1+v_plan_ml_arc.bulk-v_plan_ml_arc.thickness)/v_plan_ml_arc.y_param)+(v_plan_ml_arc.width)+v_plan_ml_arc.b*2)+									
v_plan_ml_arc.b*2+(v_plan_ml_arc.width))/2)::numeric(12,3)																													AS m3mlexc,

((v_plan_ml_arc.z1+v_plan_ml_arc.geom1+v_plan_ml_arc.bulk*2+v_plan_ml_arc.z2)																	
*(((2*((v_plan_ml_arc.z1+v_plan_ml_arc.geom1+v_plan_ml_arc.bulk*2+v_plan_ml_arc.z2)/v_plan_ml_arc.y_param)
+(v_plan_ml_arc.width)+v_plan_ml_arc.b*2)+(v_plan_ml_arc.b*2+(v_plan_ml_arc.width)))/2)
- v_plan_ml_arc.area)::numeric(12,3)																																		AS m3mlprotec,

(((v_plan_ml_arc.mean_y+v_plan_ml_arc.z1+v_plan_ml_arc.bulk-v_plan_ml_arc.thickness)																																								
*((2*((v_plan_ml_arc.mean_y+v_plan_ml_arc.z1+v_plan_ml_arc.bulk-v_plan_ml_arc.thickness)/v_plan_ml_arc.y_param)+(v_plan_ml_arc.width)+v_plan_ml_arc.b*2)+								
v_plan_ml_arc.b*2+(v_plan_ml_arc.width))/2)
-((v_plan_ml_arc.z1+v_plan_ml_arc.geom1+v_plan_ml_arc.bulk*2+v_plan_ml_arc.z2)																	
*(((2*((v_plan_ml_arc.z1+v_plan_ml_arc.geom1+v_plan_ml_arc.bulk*2+v_plan_ml_arc.z2)/v_plan_ml_arc.y_param)		
+(v_plan_ml_arc.width)+v_plan_ml_arc.b*2)+(v_plan_ml_arc.b*2+(v_plan_ml_arc.width)))/2)))::numeric(12,3)																	AS m3mlfill,

((v_plan_ml_arc.z1+v_plan_ml_arc.geom1+v_plan_ml_arc.bulk*2+v_plan_ml_arc.z2)																	
*(((2*((v_plan_ml_arc.z1+v_plan_ml_arc.geom1+v_plan_ml_arc.bulk*2+v_plan_ml_arc.z2)/v_plan_ml_arc.y_param)
+(v_plan_ml_arc.width)+v_plan_ml_arc.b*2)+(v_plan_ml_arc.b*2+(v_plan_ml_arc.width)))/2))::numeric(12,3)																		AS m3mlexcess

FROM "sanejament".v_plan_ml_arc;


-- ----------------------------
-- View structure for v_plan_cost_arc
-- ----------------------------

CREATE VIEW "sanejament"."v_plan_cost_arc" AS 
SELECT
v_plan_ml_arc.arc_id,
v_plan_ml_arc.arccat_id,
v_plan_ml_arc.soilcat_id,
v_plan_ml_arc.y1,
v_plan_ml_arc.y2,
v_plan_ml_arc.mean_y,
v_plan_ml_arc.z1,
v_plan_ml_arc.z2,
v_plan_ml_arc.thickness,
v_plan_ml_arc.width,
v_plan_ml_arc.b,
v_plan_ml_arc.bulk,
v_plan_ml_arc.geom1,
v_plan_ml_arc.area,
v_plan_ml_arc.y_param,

v_plan_mlcost_arc.calculed_y,
v_plan_mlcost_arc.m3mlexc,
v_plan_mlcost_arc.m2mltrenchl,
v_plan_mlcost_arc.m2mlbase AS m2mlbottom,
v_plan_mlcost_arc.m2mlpavement AS m2mlpav,
v_plan_mlcost_arc.m3mlprotec,
v_plan_mlcost_arc.m3mlfill,
v_plan_mlcost_arc.m3mlexcess,

v_plan_mlcost_arc.m3exc_cost,
v_plan_mlcost_arc.m2trenchl_cost,
v_plan_mlcost_arc.m2bottom_cost,
v_plan_mlcost_arc.m2pav_cost,
v_plan_mlcost_arc.m3protec_cost,
v_plan_mlcost_arc.m3fill_cost,
v_plan_mlcost_arc.m3excess_cost,
v_plan_ml_arc.cost_unit,

(CASE WHEN (v_plan_ml_arc.cost_unit='ut'::text) THEN NULL ELSE
(v_plan_mlcost_arc.m2mlpavement*v_plan_mlcost_arc.m2pav_cost) END)::numeric(12,3) 	AS pav_cost,
(CASE WHEN (v_plan_ml_arc.cost_unit='ut'::text) THEN NULL ELSE
(v_plan_mlcost_arc.m3mlexc*v_plan_mlcost_arc.m3exc_cost) END)::numeric(12,3) 		AS exc_cost,
(CASE WHEN (v_plan_ml_arc.cost_unit='ut'::text) THEN NULL ELSE
(v_plan_mlcost_arc.m2mltrenchl*v_plan_mlcost_arc.m2trenchl_cost) END)::numeric(12,3)	AS trenchl_cost,
(CASE WHEN (v_plan_ml_arc.cost_unit='ut'::text) THEN NULL ELSE
(v_plan_mlcost_arc.m2mlbase*v_plan_mlcost_arc.m2bottom_cost)END)::numeric(12,3) 		AS base_cost,
(CASE WHEN (v_plan_ml_arc.cost_unit='ut'::text) THEN NULL ELSE
(v_plan_mlcost_arc.m3mlprotec*v_plan_mlcost_arc.m3protec_cost) END)::numeric(12,3) 	AS protec_cost,
(CASE WHEN (v_plan_ml_arc.cost_unit='ut'::text) THEN NULL ELSE
(v_plan_mlcost_arc.m3mlfill*v_plan_mlcost_arc.m3fill_cost) END)::numeric(12,3) 		AS fill_cost,
(CASE WHEN (v_plan_ml_arc.cost_unit='ut'::text) THEN NULL ELSE
(v_plan_mlcost_arc.m3mlexcess*v_plan_mlcost_arc.m3excess_cost) END)::numeric(12,3) 	AS excess_cost,
(v_plan_mlcost_arc.arc_cost)::numeric(12,3)									AS arc_cost,
(CASE WHEN (v_plan_ml_arc.cost_unit='ut'::text) THEN v_plan_ml_arc.arc_cost ELSE
(v_plan_mlcost_arc.m3mlexc*v_plan_mlcost_arc.m3exc_cost
+ v_plan_mlcost_arc.m2mlbase*v_plan_mlcost_arc.m2bottom_cost
+ v_plan_mlcost_arc.m2mltrenchl*v_plan_mlcost_arc.m2trenchl_cost
+ v_plan_mlcost_arc.m3mlprotec*v_plan_mlcost_arc.m3protec_cost
+ v_plan_mlcost_arc.m3mlfill*v_plan_mlcost_arc.m3fill_cost
+ v_plan_mlcost_arc.m3mlexcess*v_plan_mlcost_arc.m3excess_cost
+ v_plan_mlcost_arc.m2mlpavement*v_plan_mlcost_arc.m2pav_cost
+ v_plan_mlcost_arc.arc_cost) END)::numeric(12,2)							AS cost

FROM "sanejament".v_plan_ml_arc
	JOIN sanejament.v_plan_mlcost_arc ON ((((v_plan_ml_arc.arc_id)::text = (v_plan_mlcost_arc.arc_id)::text)))
	JOIN sanejament.plan_economic_selection ON (((v_plan_ml_arc."state")::text = (plan_economic_selection.id)::text));



-- ----------------------------
-- View structure for v_plan_arc
-- ----------------------------
CREATE VIEW "sanejament"."v_plan_arc" AS 
SELECT
v_plan_ml_arc.arc_id,
v_plan_ml_arc.arccat_id,
v_plan_ml_arc.cost_unit,
(CASE WHEN (v_plan_ml_arc.cost_unit='ut'::text) THEN v_plan_ml_arc.arc_cost ELSE
(v_plan_mlcost_arc.m3mlexc*v_plan_mlcost_arc.m3exc_cost
+ v_plan_mlcost_arc.m2mlbase*v_plan_mlcost_arc.m2bottom_cost
+ v_plan_mlcost_arc.m2mltrenchl*v_plan_mlcost_arc.m2trenchl_cost
+ v_plan_mlcost_arc.m3mlprotec*v_plan_mlcost_arc.m3protec_cost
+ v_plan_mlcost_arc.m3mlfill*v_plan_mlcost_arc.m3fill_cost
+ v_plan_mlcost_arc.m3mlexcess*v_plan_mlcost_arc.m3excess_cost
+ v_plan_mlcost_arc.m2mlpavement*v_plan_mlcost_arc.m2pav_cost
+ v_plan_mlcost_arc.arc_cost) END)::numeric(12,2)							AS cost,
(CASE WHEN (v_plan_ml_arc.cost_unit='ut'::text) THEN NULL ELSE (st_length2d(v_plan_ml_arc.the_geom)) END)::numeric(12,2)							AS length,
(CASE WHEN (v_plan_ml_arc.cost_unit='ut'::text) THEN v_plan_ml_arc.arc_cost ELSE((st_length2d(v_plan_ml_arc.the_geom))::numeric(12,2)*
(v_plan_mlcost_arc.m3mlexc*v_plan_mlcost_arc.m3exc_cost
+ v_plan_mlcost_arc.m2mlbase*v_plan_mlcost_arc.m2bottom_cost
+ v_plan_mlcost_arc.m2mltrenchl*v_plan_mlcost_arc.m2trenchl_cost
+ v_plan_mlcost_arc.m3mlprotec*v_plan_mlcost_arc.m3protec_cost
+ v_plan_mlcost_arc.m3mlfill*v_plan_mlcost_arc.m3fill_cost
+ v_plan_mlcost_arc.m3mlexcess*v_plan_mlcost_arc.m3excess_cost
+ v_plan_mlcost_arc.m2mlpavement*v_plan_mlcost_arc.m2pav_cost
+ v_plan_mlcost_arc.arc_cost)::numeric(14,2)) END)::numeric (14,2)						AS budget,
v_plan_ml_arc."state",
v_plan_ml_arc.the_geom

FROM "sanejament".v_plan_ml_arc
	JOIN sanejament.v_plan_mlcost_arc ON ((((v_plan_ml_arc.arc_id)::text = (v_plan_mlcost_arc.arc_id)::text)))
	JOIN sanejament.plan_economic_selection ON (((v_plan_ml_arc."state")::text = (plan_economic_selection.id)::text));



-- ----------------------------
-- View structure for v_plan_node
-- ----------------------------
CREATE VIEW "aigua_potable"."v_plan_node" AS 
SELECT

node.node_id,
node.node_type,
node.ymax,
v_price_x_catnode.cost_unit,
(CASE WHEN (v_price_x_catnode.cost_unit='ut'::text) THEN NULL ELSE ((CASE WHEN (node.ymax*1=0::numeric) THEN v_price_x_catnode.estimated_y::numeric(12,2) ELSE ((node.ymax)/2)END)) END)::numeric(12,2) AS calculated_depth,
v_price_x_catnode.cost,
(CASE WHEN (v_price_x_catnode.cost_unit='ut'::text) THEN v_price_x_catnode.cost ELSE ((CASE WHEN (node.ymax*1=0::numeric) THEN v_price_x_catnode.estimated_y::numeric(12,2) ELSE ((node.ymax)/2)::numeric(12,2) END)*v_price_x_catnode.cost) END)::numeric(12,2) AS budget,
node."state",
node.the_geom

FROM (aigua_potable.node
JOIN aigua_potable.v_price_x_catnode ON ((((node.node_type)::text = (v_price_x_catnode.id)::text))))
JOIN aigua_potable.plan_economic_selection ON (((node."state")::text = (plan_economic_selection.id)::text));



-- ----------------------------
-- View structure for v_plan_arc_x_psector
-- ----------------------------
CREATE VIEW "aigua_potable"."v_plan_arc_x_psector" AS 
SELECT

arc.arc_id,
arc.arccat_id,
v_plan_arc.cost_unit,
(v_plan_arc.cost)::numeric (14,2) AS cost,
v_plan_arc.length,
v_plan_arc.budget,
plan_arc_x_psector.psector_id,
arc."state",
plan_arc_x_psector.atlas_id,
arc.the_geom

FROM (((aigua_potable.arc 
JOIN aigua_potable.cat_arc ON ((((arc.arccat_id)::text = (cat_arc.id)::text))))
JOIN aigua_potable.plan_arc_x_psector ON ((((plan_arc_x_psector.arc_id)::text = (arc.arc_id)::text))))
JOIN aigua_potable.v_plan_arc ON ((((arc.arc_id)::text = (v_plan_arc.arc_id)::text))))
ORDER BY arccat_id;


-- ----------------------------
-- View structure for v_plan_node_x_psector
-- ----------------------------
CREATE VIEW "aigua_potable"."v_plan_node_x_psector" AS 
SELECT

node.node_id,
node.node_type,
plan_node_x_psector.descript,
(v_price_x_catnode.cost)::numeric(12,2) AS budget,
plan_node_x_psector.psector_id,
node."state",
plan_node_x_psector.atlas_id,
node.the_geom

FROM ((aigua_potable.node 
JOIN aigua_potable.v_price_x_catnode ON ((((node.node_type)::text = (v_price_x_catnode.id)::text))))
JOIN aigua_potable.plan_node_x_psector ON ((((plan_node_x_psector.node_id)::text = (node.node_id)::text))))
ORDER BY node_type;


-- ----------------------------
-- View structure for v_plan_psector_arc
-- ----------------------------
DROP VIEW IF EXISTS "aigua_potable"."v_plan_psector_arc" CASCADE;

CREATE VIEW "aigua_potable"."v_plan_psector_arc" AS 
SELECT 
plan_psector.psector_id,
plan_psector.descript,
plan_psector.priority,
plan_psector.text1, 
plan_psector.text2,
plan_psector.observ,
plan_psector.rotation,
plan_psector.scale,
plan_psector.sector_id,
sum(v_plan_arc.budget::numeric(14,2)) AS pem,
plan_psector.gexpenses,
(((100+plan_psector.gexpenses)/100)*(sum(v_plan_arc.budget)))::numeric(14,2) AS pec,
plan_psector.vat,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*(sum(v_plan_arc.budget)))::numeric(14,2) AS pec_vat,
plan_psector.other,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*((100+plan_psector.other)/100)*(sum(v_plan_arc.budget)))::numeric(14,2) AS pca,
plan_psector.the_geom

FROM (((((aigua_potable.plan_psector
JOIN aigua_potable.plan_arc_x_psector ON (plan_arc_x_psector.psector_id)::text = (plan_psector.psector_id)::text))
JOIN aigua_potable.v_plan_arc ON ((v_plan_arc.arc_id)::text) = ((plan_arc_x_psector.arc_id)::text))
JOIN aigua_potable.arc ON ((arc.arc_id)::text) = ((plan_arc_x_psector.arc_id)::text)))

GROUP BY
plan_psector.psector_id,
plan_psector.descript,
plan_psector.priority,
plan_psector.text1, 
plan_psector.text2,
plan_psector.observ,
plan_psector.rotation,
plan_psector.scale,
plan_psector.sector_id,
plan_psector.the_geom,
plan_psector.gexpenses,
plan_psector.vat,
plan_psector.other;



-- ----------------------------
-- View structure for v_plan_psector_node
-- ----------------------------
DROP VIEW IF EXISTS "aigua_potable"."v_plan_psector_node" CASCADE;
CREATE VIEW "aigua_potable"."v_plan_psector_node" AS 
SELECT 
plan_psector.psector_id,
plan_psector.descript,
plan_psector.priority,
plan_psector.text1, 
plan_psector.text2,
plan_psector.observ,
plan_psector.rotation,
plan_psector.scale,
plan_psector.sector_id,
sum(v_plan_node.budget::numeric(14,2)) AS pem,
plan_psector.gexpenses,
(((100+plan_psector.gexpenses)/100)*(sum(v_plan_node.budget)))::numeric(14,2) AS pec,
plan_psector.vat,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*(sum(v_plan_node.budget)))::numeric(14,2) AS pec_vat,
plan_psector.other,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*((100+plan_psector.other)/100)*(sum(v_plan_node.budget)))::numeric(14,2) AS pca,
plan_psector.the_geom

FROM (((((aigua_potable.plan_psector
JOIN aigua_potable.plan_node_x_psector ON (plan_node_x_psector.psector_id)::text = (plan_psector.psector_id)::text))
JOIN aigua_potable.v_plan_node ON ((v_plan_node.node_id)::text) = ((plan_node_x_psector.node_id)::text))
JOIN aigua_potable.node ON ((node.node_id)::text) = ((plan_node_x_psector.node_id)::text)))

GROUP BY
plan_psector.psector_id,
plan_psector.descript,
plan_psector.priority,
plan_psector.text1, 
plan_psector.text2,
plan_psector.observ,
plan_psector.rotation,
plan_psector.scale,
plan_psector.sector_id,
plan_psector.the_geom,
plan_psector.gexpenses,
plan_psector.vat,
plan_psector.other;



DROP VIEW IF EXISTS "aigua_potable"."v_plan_other_x_psector";

CREATE VIEW "aigua_potable"."v_plan_other_x_psector" AS 
SELECT
plan_other_x_psector.id,
plan_other_x_psector.psector_id,
v_price_compost.id AS price_id,
v_price_compost.descript,
v_price_compost.price,
plan_other_x_psector.measurement,
(plan_other_x_psector.measurement*v_price_compost.price)::numeric(14,2) AS budget

FROM (aigua_potable.plan_other_x_psector 
JOIN aigua_potable.v_price_compost ON ((((v_price_compost.id)::text = (plan_other_x_psector.price_id)::text))))
ORDER BY psector_id;


DROP VIEW IF EXISTS  "aigua_potable"."v_plan_psector_other";

CREATE VIEW "aigua_potable"."v_plan_psector_other" AS 
SELECT 
plan_psector.psector_id,
plan_psector.descript,
plan_psector.priority,
plan_psector.text1, 
plan_psector.text2,
plan_psector.observ,
plan_psector.rotation,
plan_psector.scale,
plan_psector.sector_id,
sum(v_plan_other_x_psector.budget::numeric(14,2)) AS pem,
plan_psector.gexpenses,
(((100+plan_psector.gexpenses)/100)*(sum(v_plan_other_x_psector.budget)))::numeric(14,2) AS pec,
plan_psector.vat,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*(sum(v_plan_other_x_psector.budget)))::numeric(14,2) AS pec_vat,
plan_psector.other,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*((100+plan_psector.other)/100)*(sum(v_plan_other_x_psector.budget)))::numeric(14,2) AS pca,
plan_psector.the_geom

FROM (((aigua_potable.plan_psector
JOIN aigua_potable.v_plan_other_x_psector  ON (v_plan_other_x_psector.psector_id)::text = (plan_psector.psector_id)::text)))

GROUP BY
plan_psector.psector_id,
plan_psector.descript,
plan_psector.priority,
plan_psector.text1, 
plan_psector.text2,
plan_psector.observ,
plan_psector.rotation,
plan_psector.scale,
plan_psector.sector_id,
plan_psector.the_geom,
plan_psector.gexpenses,
plan_psector.vat,
plan_psector.other;


 CREATE OR REPLACE VIEW aigua_potable.v_plan_psector AS 
 SELECT wtotal.psector_id,
	sum(wtotal.pem::numeric(12,2)) AS pem,
    sum(wtotal.pec::numeric(12,2)) AS pec,
	sum(wtotal.pec_vat::numeric(12,2)) AS pec_vat,
    sum(wtotal.pca::numeric(12,2)) AS pca,
    wtotal.the_geom
   FROM (         SELECT v_plan_psector_arc.psector_id,
					v_plan_psector_arc.pem,
                    v_plan_psector_arc.pec,
					v_plan_psector_arc.pec_vat,
                    v_plan_psector_arc.pca,
                    v_plan_psector_arc.the_geom
                   FROM aigua_potable.v_plan_psector_arc
        UNION
                 SELECT v_plan_psector_node.psector_id,
					v_plan_psector_node.pem,
                    v_plan_psector_node.pec,
					v_plan_psector_node.pec_vat,
                    v_plan_psector_node.pca,
                    v_plan_psector_node.the_geom
                   FROM aigua_potable.v_plan_psector_node
		UNION
                 SELECT v_plan_psector_other.psector_id,
					v_plan_psector_other.pem,
                    v_plan_psector_other.pec,
					v_plan_psector_other.pec_vat,
                    v_plan_psector_other.pca,
                    v_plan_psector_other.the_geom
                   FROM aigua_potable.v_plan_psector_other) wtotal	  
				   
				GROUP BY wtotal.psector_id, wtotal.the_geom;


				
				
 CREATE OR REPLACE VIEW "aigua_potable".v_plan_psector_filtered AS 
 SELECT wtotal.psector_id,
	sum(wtotal.pem::numeric(12,2)) AS pem,
    sum(wtotal.pec::numeric(12,2)) AS pec,
	sum(wtotal.pec_vat::numeric(12,2)) AS pec_vat,
    sum(wtotal.pca::numeric(12,2)) AS pca,
    wtotal.the_geom
   FROM (         SELECT v_plan_psector_arc.psector_id,
					v_plan_psector_arc.pem,
                    v_plan_psector_arc.pec,
					v_plan_psector_arc.pec_vat,
                    v_plan_psector_arc.pca,
                    v_plan_psector_arc.the_geom
                   FROM "aigua_potable".v_plan_psector_arc
				   JOIN "aigua_potable".plan_psector_selection  ON (plan_psector_selection.id)::text = (v_plan_psector_arc.psector_id)::text
        UNION
                 SELECT v_plan_psector_node.psector_id,
					v_plan_psector_node.pem,
                    v_plan_psector_node.pec,
					v_plan_psector_node.pec_vat,
                    v_plan_psector_node.pca,
                    v_plan_psector_node.the_geom
                   FROM "aigua_potable".v_plan_psector_node
				   JOIN "aigua_potable".plan_psector_selection  ON (plan_psector_selection.id)::text = (v_plan_psector_node.psector_id)::text
		UNION
                 SELECT v_plan_psector_other.psector_id,
					v_plan_psector_other.pem,
                    v_plan_psector_other.pec,
					v_plan_psector_other.pec_vat,
                    v_plan_psector_other.pca,
                    v_plan_psector_other.the_geom
                   FROM "aigua_potable".v_plan_psector_other
                   JOIN "aigua_potable".plan_psector_selection  ON (plan_psector_selection.id)::text = (v_plan_psector_other.psector_id)::text) wtotal
				   
				   
				GROUP BY wtotal.psector_id, wtotal.the_geom;
  


-- ----------------------------
-- Records of plan_economic_selection
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."plan_economic_selection" VALUES ('ON_SERVICE');
INSERT INTO "SCHEMA_NAME"."plan_economic_selection" VALUES ('RECONSTRUCT');
INSERT INTO "SCHEMA_NAME"."plan_economic_selection" VALUES ('REPLACE');
INSERT INTO "SCHEMA_NAME"."plan_economic_selection" VALUES ('PLANIFIED');

