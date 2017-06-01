/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



-------------
-- ALTER TABLES
-------------

-- ELEV STRATEGY
ALTER TABLE arc ADD COLUMN elev1 numeric(12,3);
ALTER TABLE arc ADD COLUMN elev2 numeric(12,3);
ALTER TABLE arc ADD COLUMN est_elev1 numeric(12,3);
ALTER TABLE arc ADD COLUMN est_elev2 numeric(12,3);

ALTER TABLE node ADD COLUMN elev numeric(12,3);
ALTER TABLE node ADD COLUMN est_elev numeric(12,3);


-- REPLACEMENT VALUE
ALTER TABLE gully ADD COLUMN connec_length numeric(12,3);
ALTER TABLE gully ADD COLUMN connec_depth numeric(12,3);


-- REHAB COST
ALTER TABLE om_visit_parameter_type ADD COLUMN context varchar (30);
ALTER TABLE om_visit_parameter_type ADD COLUMN une_code varchar (30);
ALTER TABLE om_visit_parameter_type ADD COLUMN criticity int2;

 CREATE TABLE "om_visit_value_context"(
id character varying(16),
obs text,
CONSTRAINT om_visit_value_context_pkey PRIMARY KEY (id)
);

 CREATE TABLE "om_visit_value_criticity"(
id int2,
obs text,
CONSTRAINT om_visit_value_criticity_pkey PRIMARY KEY (id)
);




ALTER TABLE om_visit_event ADD COLUMN geom1 float;
ALTER TABLE om_visit_event ADD COLUMN geom2 float;
ALTER TABLE om_visit_event ADD COLUMN geom3 float;
ALTER TABLE om_visit_event ADD COLUMN geom3 float;
ALTER TABLE om_visit_event ADD COLUMN value2 text;
ALTER TABLE om_visit_event ADD COLUMN position_value text;


-- INP FLOW REGULATOR
CREATE TABLE "inp_flow_regulator_type"(
id character varying(16),
table_id character varying(50),
CONSTRAINT inp_flow_regulator_type_pkey PRIMARY KEY (id)
);

INSERT INTO inp_flow_regulator_type VALUES ('WEIR', 'inp_n2a_weir');
INSERT INTO inp_flow_regulator_type VALUES ('ORIFICE', 'inp_n2a_orifice');
INSERT INTO inp_flow_regulator_type VALUES ('OUTLET', 'inp_n2a_outlet');
INSERT INTO inp_flow_regulator_type VALUES ('PUMP', 'inp_n2a_pump');
INSERT INTO inp_flow_regulator_type VALUES ('ORI-WEIR', 'inp_n2a_ori_weir');



CREATE TABLE "inp_n2a_orifice" (
"node_id" varchar(16)   NOT NULL,
"arc_id" varchar(16)  ,
"ori_type" varchar(18)  ,
"offset" numeric(12,4),
"cd" numeric(12,4),
"orate" numeric(12,4),
"flap" varchar(3)  ,
"shape" varchar(18)  ,
"to_arc" varchar(16)  ,
"geom1" numeric(12,4),
"geom2" numeric(12,4) DEFAULT 0.00,
"geom3" numeric(12,4) DEFAULT 0.00,
"geom4" numeric(12,4) DEFAULT 0.00,
  CONSTRAINT inp_n2a_orifice_pkey PRIMARY KEY (node_id,arc_id)
);



CREATE TABLE "inp_n2a_outlet" (
"node_id" varchar(16)   NOT NULL,
"arc_id" varchar(16)  ,
"outlet_type" varchar(16)  ,
"offset" numeric(12,4),
"curve_id" varchar(16)  ,
"cd1" numeric(12,4),
"cd2" numeric(12,4),
"flap" varchar(3)  ,
  CONSTRAINT inp_n2a_outlet_pkey PRIMARY KEY (node_id,arc_id)
);


CREATE TABLE "inp_n2a_pump" (
"node_id" varchar(16)   NOT NULL,
"arc_id" varchar(16)  ,
"curve_id" varchar(16)  ,
"to_arc" varchar(16)  ,
"status" varchar(3)  ,
"startup" numeric(12,4),
"shutoff" numeric(12,4),
  CONSTRAINT inp_n2a_pump_pkey PRIMARY KEY (node_id,arc_id)
);


CREATE TABLE "inp_n2a_weir" (
"node_id" varchar(16)   NOT NULL,
"arc_id" varchar(16)  ,
"weir_type" varchar(18)  ,
"offset" numeric(12,4),
"cd" numeric(12,4),
"ec" numeric(12,4),
"cd2" numeric(12,4),
"flap" varchar(3)  ,
"to_arc" varchar(16)  ,
"geom1" numeric(12,4),
"geom2" numeric(12,4) DEFAULT 0.00,
"geom3" numeric(12,4) DEFAULT 0.00,
"geom4" numeric(12,4) DEFAULT 0.00,
"surcharge" varchar (3),
  CONSTRAINT inp_n2a_weir_pkey PRIMARY KEY (node_id,arc_id)
);



CREATE TABLE "inp_n2a_ori_weir" (
"node_id" varchar(16)   NOT NULL,
"arc_id" varchar(16)  ,
"to_arc" varchar(16) ,
"ori_type" varchar(18)  ,
"o_offset" numeric(12,4),
"o_cd" numeric(12,4),
"o_p_orate" numeric(12,4),
"o_flap" varchar(3)  ,
"o_shape" varchar(18)  ,
"o_geom1" numeric(12,4),
"o_geom2" numeric(12,4) DEFAULT 0.00,
"o_geom3" numeric(12,4) DEFAULT 0.00,
"o_geom4" numeric(12,4) DEFAULT 0.00,
"weir_type" varchar(18)  ,
"w_offset" numeric(12,4),
"w_cd" numeric(12,4),
"w_ec" numeric(12,4),
"w_cd2" numeric(12,4),
"w_flap" varchar(3)  ,
"w_geom1" numeric(12,4),
"w_geom2" numeric(12,4) DEFAULT 0.00,
"w_geom3" numeric(12,4) DEFAULT 0.00,
"w_geom4" numeric(12,4) DEFAULT 0.00,
"surcharge" varchar (3),
  CONSTRAINT inp_n2a_ori_weir_pkey PRIMARY KEY (node_id,arc_id)
);





-- MORE TOPOLOGY FUNCTIONS
 
 CREATE TABLE "anl_arc_intersection"(
arc_id character varying(16),
the_geom geometry(LINESTRING,25829),
CONSTRAINT anl_arc_intersection_pkey PRIMARY KEY (arc_id)
);

CREATE TABLE anl_node_flowregulator
(
  node_id character varying(16) NOT NULL,
  the_geom geometry(Point,25829),
  CONSTRAINT anl_node_floregulator_pkey PRIMARY KEY (node_id)
);


  
  -- DWF ANALISYS
  
  CREATE SEQUENCE connec_x_uses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

  
CREATE TABLE anl_dwf_cat_scenario(
  scenario_id character varying(30) NOT NULL,
  descript text,
  text text,
  tstamp timestamp with time zone DEFAULT now(),
  CONSTRAINT anl_dwf_cat_scenario_pkey PRIMARY KEY (scenario_id));

  

CREATE TABLE anl_dwf_type_catastro_uses(
  id character varying(16) NOT NULL,
  descript text,
  water_generator boolean,
  value double precision,
  type_value character varying,
  CONSTRAINT ext_catastro_type_use2_pkey PRIMARY KEY (id));

  
CREATE TABLE anl_dwf_connec_x_uses(
  id integer NOT NULL DEFAULT nextval('connec_x_uses_id_seq'::regclass),
  connec_id character varying(30),
  type_use character varying(30),
  m2 double precision,
  CONSTRAINT connec_x_uses_pkey PRIMARY KEY (id),
  CONSTRAINT anl_dwf_connec_x_uses_connec_id_pkey FOREIGN KEY (connec_id)
      REFERENCES connec (connec_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT anl_dwf_connec_x_uses_type_use_fkey FOREIGN KEY (type_use)
      REFERENCES anl_dwf_type_catastro_uses (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE);


CREATE TABLE anl_dwf_connec_x_uses_value(
  id serial NOT NULL,
  scenario_id character varying(30),
  connec_id character varying(30),
  m3dia double precision,
  CONSTRAINT anl_dwf_connec_x_uses_value_pkey PRIMARY KEY (id),
  CONSTRAINT anl_dwf_connec_x_uses_value_connec_id_fkey FOREIGN KEY (connec_id)
      REFERENCES connec (connec_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT anl_dwf_connec_x_uses_value_scenario_id_pkey FOREIGN KEY (scenario_id)
      REFERENCES anl_dwf_cat_scenario (scenario_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE);


CREATE TABLE anl_dwf_selector_scenario(
  scenario_id character varying(16) NOT NULL,
  CONSTRAINT anl_dwf_selector_scenario_pkey PRIMARY KEY (scenario_id));

  
CREATE TABLE anl_dwf_config_float(
  id serial NOT NULL,
  parameter text,
  value double precision,
  context text,
  descript text,
  CONSTRAINT anl_dwf_config_float_pkey PRIMARY KEY (id));
  
  
  CREATE TABLE anl_dwf_cat_result(
  result_id character varying(30) NOT NULL,
  scenario_id character varying(30),
  result_type character varying(30),
  descript text,
  text text,
  tstamp timestamp with time zone DEFAULT now(),
  CONSTRAINT anl_dwf_cat_result_pkey PRIMARY KEY (result_id));
  
  
  CREATE TABLE anl_dwf_rpt_arc(
  id bigserial NOT NULL,
  result_id character varying(16),
  arc_id character varying(50),
  r1 double precision,
  r2 double precision,
  r3 double precision,
  r4 double precision,
  r5 double precision,
  r6 double precision,
  CONSTRAINT anl_dwf_rpt_arc_pkey PRIMARY KEY (id),
  CONSTRAINT anl_dwf_rpt_arc_result_id_fkey FOREIGN KEY (result_id)
      REFERENCES anl_dwf_cat_result (result_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE);



CREATE TABLE anl_dwf_rpt_node(
  id bigserial NOT NULL,
  result_id character varying(16),
  node_id character varying(50),
  r1 double precision,
  r2 double precision,
  r3 double precision,
  r4 double precision,
  r5 double precision,
  r6 double precision,
  CONSTRAINT anl_dwf_rpt_node_pkey PRIMARY KEY (id),
  CONSTRAINT anl_dwf_rpt_node_result_id_fkey FOREIGN KEY (result_id)
      REFERENCES anl_dwf_cat_result (result_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE);
	  
	  
----
-- FK
----

ALTER TABLE "om_visit_parameter_type" DROP CONSTRAINT IF EXISTS "om_visit_parameter_type_criticity_fkey";
ALTER TABLE "om_visit_parameter_type" ADD CONSTRAINT "om_visit_parameter_type_criticity_fkey" FOREIGN KEY ("criticity") REFERENCES "om_visit_value_criticity" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "om_visit_parameter_type" DROP CONSTRAINT IF EXISTS "om_visit_parameter_type_context_fkey";
ALTER TABLE "om_visit_parameter_type" ADD CONSTRAINT "om_visit_parameter_type_context_fkey" FOREIGN KEY ("context") REFERENCES "om_visit_value_context" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_n2a_orifice" DROP CONSTRAINT IF EXISTS "inp_n2a_orifice_fkey";
ALTER TABLE "inp_n2a_orifice" ADD CONSTRAINT "inp_n2a_orifice_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_n2a_outlet" DROP CONSTRAINT IF EXISTS "inp_n2a_outlet_fkey";
ALTER TABLE "inp_n2a_outlet" ADD CONSTRAINT "inp_n2a_outlet_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_n2a_pump" DROP CONSTRAINT IF EXISTS "inp_n2a_pump_fkey";
ALTER TABLE "inp_n2a_pump" ADD CONSTRAINT "inp_n2a_pump_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_n2a_weir" DROP CONSTRAINT IF EXISTS "inp_n2a_weir_fkey";
ALTER TABLE "inp_n2a_weir" ADD CONSTRAINT "inp_n2a_weir_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_n2a_ori_weir" DROP CONSTRAINT IF EXISTS "inp_n2a_ori_weir_fkey";
ALTER TABLE "inp_n2a_ori_weir" ADD CONSTRAINT "inp_n2a_ori_weir_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;




	  
ALTER TABLE "anl_dwf_connec_x_uses" DROP CONSTRAINT IF EXISTS "anl_dwf_connec_x_uses_connec_id_pkey";
ALTER TABLE "anl_dwf_connec_x_uses" ADD CONSTRAINT "anl_dwf_connec_x_uses_connec_id_pkey" FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_dwf_connec_x_uses" DROP CONSTRAINT IF EXISTS "anl_dwf_connec_x_uses_type_use_fkey";
ALTER TABLE "anl_dwf_connec_x_uses" ADD CONSTRAINT "anl_dwf_connec_x_uses_type_use_fkey" FOREIGN KEY ("type_use") REFERENCES "anl_dwf_type_catastro_uses" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "anl_dwf_connec_x_uses_value" DROP CONSTRAINT IF EXISTS "anl_dwf_connec_x_uses_value_scenario_id_pkey";
ALTER TABLE "anl_dwf_connec_x_uses_value" ADD CONSTRAINT "anl_dwf_connec_x_uses_value_scenario_id_pkey" FOREIGN KEY ("scenario_id") REFERENCES "anl_dwf_cat_scenario" ("scenario_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_dwf_connec_x_uses_value" DROP CONSTRAINT IF EXISTS "anl_dwf_connec_x_uses_value_connec_id_fkey";
ALTER TABLE "anl_dwf_connec_x_uses_value" ADD CONSTRAINT "anl_dwf_connec_x_uses_value_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;




-------------
-- INDEX
-------------

CREATE INDEX anl_arc_intersection_index   ON anl_arc_intersection   USING gist   (the_geom);
CREATE INDEX anl_node_flowregulator_index   ON anl_node_flowregulator  USING gist  (the_geom);


-------------
-- UPDATE DATA
-------------

UPDATE inp_options SET link_offsets='ELEVATION';
