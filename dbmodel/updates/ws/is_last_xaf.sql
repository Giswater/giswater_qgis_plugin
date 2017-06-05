/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

--manca per aclarar amb la Silvia Burdons aquestes taules:
-- tipus operatiu
-- estat_subsistema
-- estat valvula xaf

-- Cal fer la vista v_ui_node_node_parent
-- node_id
-- node_type
-- catnode_id
-- parent_node_id
-- parent_node_type
-- catnode_id


CREATE TABLE limnometer(
"limno_id" serial NOT NULL,
"short_descript" character varying(30),
"elevation" numeric(12,4),
"depth" numeric(12,4),
"sector_id" varchar(30)  ,
"state" character varying(16),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"dma_id" varchar(30)  ,
"soilcat_id" varchar(16)  ,
"category_type" varchar(50)  ,
"fluid_type" varchar(50)  ,
"location_type" varchar(50)  ,
"workcat_id" varchar(255)  ,
"buildercat_id" varchar(30)  ,
"builtdate" date,
"ownercat_id" varchar(30)  ,
"adress_01" varchar(50)  ,
"adress_02" varchar(50)  ,
"adress_03" varchar(50)  ,
"descript" varchar(254)  ,
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(20)  ,
"the_geom" public.geometry (POINT, SRID_VALUE),
"undelete" boolean,
"workcat_id_end" character varying(255),
"parent_node_id" varchar(16),
"explot_id" integer,
CONSTRAINT limnometer_pkey PRIMARY KEY (limno_id)
);


CREATE TABLE piezometer(
"piezo_id" serial NOT NULL,
"short_descript" character varying(30),
"elevation" numeric(12,4),
"zmin" numeric(12,4),
"zmax" numeric(12,4),
"elev" numeric(12,4),
"sector_id" varchar(30)  ,
"state" character varying(16),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"dma_id" varchar(30)  ,
"soilcat_id" varchar(16)  ,
"category_type" varchar(50)  ,
"fluid_type" varchar(50)  ,
"location_type" varchar(50)  ,
"workcat_id" varchar(255)  ,
"buildercat_id" varchar(30)  ,
"builtdate" date,
"ownercat_id" varchar(30)  ,
"adress_01" varchar(50)  ,
"adress_02" varchar(50)  ,
"adress_03" varchar(50)  ,
"descript" varchar(254)  ,
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(20)  ,
"the_geom" public.geometry (POINT, SRID_VALUE),
"undelete" boolean,
"workcat_id_end" character varying(255),
"parent_node_id" varchar(16),
"explot_id" integer,
CONSTRAINT piezometer_pkey PRIMARY KEY (piezo_id)
);


CREATE TABLE "man_type_operation" (
"id" serial,
"short_descript" varchar(30)
"observ" text,
CONSTRAINT man_type_operation_pkey PRIMARY KEY (id)
);


-- node topologic features

CREATE TABLE "man_register" (
"node_id" varchar(16) NOT NULL,
"pol_id" varchar(16) NOT NULL,
"add_info" varchar(255),
CONSTRAINT man_register_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_netwjoin" (
"node_id" varchar(16) NOT NULL,
"add_info" varchar(255),
CONSTRAINT man_netwjoin_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_expansiontank" (
"node_id" varchar(16) NOT NULL,
"add_info" varchar(255),
CONSTRAINT man_expansiontank_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_flexunion" (
"node_id" varchar(16) NOT NULL,
"add_info" varchar(255),
CONSTRAINT man_dilator_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "man_netsamplepoint"(
"node_id" varchar(16) NOT NULL,
 code_lab character varying(30),
"add_info" varchar(255)
); 


CREATE TABLE "man_netelement"(
"node_id" varchar(16) NOT NULL,
"add_info" varchar(255)
); 

-- arc topologic features


CREATE TABLE "man_varc" (
"arc_id" varchar(16) NOT NULL,
"add_info" varchar(255),
CONSTRAINT man_varc_pkey PRIMARY KEY (arc_d)
);



-- value state

CREATE TABLE "man_value_state" (
"id" serial,
"short_descript" varchar(30)
"observ" text,
CONSTRAINT man_value_state PRIMARY KEY (id)
);



--THE PARENT NODE STRATEGY IT NOT MUST BE APPLIED TO TANKS AND TO REGISTERS...

ALTER TABLE node ADD COLUMN parent_node_id character varying(16);
ALTER TABLE node ADD CONSTRAINT node_parent_node_fkey FOREIGN KEY (parent_node_id) REFERENCES ws_sample_dev.node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
  

ALTER TABLE man_junction ADD CONSTRAINT limnometer_fkey FOREIGN KEY (parent_node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_hydrant ADD CONSTRAINT limnometer_fkey FOREIGN KEY (parent_node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_pump ADD CONSTRAINT limnometer_fkey FOREIGN KEY (parent_node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_filter ADD CONSTRAINT limnometer_fkey FOREIGN KEY (parent_node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_meter ADD CONSTRAINT limnometer_fkey FOREIGN KEY (parent_node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_manhole ADD CONSTRAINT limnometer_fkey FOREIGN KEY (parent_node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_reduction ADD CONSTRAINT limnometer_fkey FOREIGN KEY (parent_node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_source ADD CONSTRAINT limnometer_fkey FOREIGN KEY (parent_node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_waterwell ADD CONSTRAINT limnometer_fkey FOREIGN KEY (parent_node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE limnometer ADD CONSTRAINT limnometer_fkey FOREIGN KEY (parent_node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE piezometer ADD CONSTRAINT piezometer_fkey FOREIGN KEY (parent_node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE man_register ADD CONSTRAINT man_register_fkey FOREIGN KEY (node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_netwjoin ADD CONSTRAINT man_netwjoin_fkey FOREIGN KEY (node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_pressdevice ADD CONSTRAINT man_pressdevice_fkey FOREIGN KEY (node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_dilator ADD CONSTRAINT man_dilator_fkey FOREIGN KEY (node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE man_varc ADD CONSTRAINT man_varc_fkey FOREIGN KEY (arc_id) REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
  