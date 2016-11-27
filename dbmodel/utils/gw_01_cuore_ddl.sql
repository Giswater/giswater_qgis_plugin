/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE TABLE "version" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".version_seq'::regclass) NOT NULL,
"giswater" varchar(16)  ,
"wsoftware" varchar(16)  ,
"postgres" varchar(512)  ,
"postgis" varchar(512)  ,
"date" timestamp(6) DEFAULT now(),
"language" varchar (50),
"epsg" int4,
CONSTRAINT version_pkey PRIMARY KEY (id)
);


CREATE TABLE "config" (
"id" varchar(18) NOT NULL,
"node_proximity" double precision,
"arc_searchnodes" double precision,
"node2arc" double precision,
"connec_proximity" double precision,
"arc_toporepair" double precision,
"nodeinsert_arcendpoint" boolean,
"nodeinsert_catalog_vdefault" varchar (30),
"orphannode_delete" boolean,
"vnode_update_tolerance" double precision,
"nodetype_change_enabled" boolean,
"samenode_init_end_control" boolean,
"node_proximity_control" boolean,
"connec_proximity_control" boolean,
"node_duplicated_tolerance" float,
"connec_duplicated_tolerance" float,
"audit_function_control" boolean,
"arc_searchnodes_control" boolean,
CONSTRAINT "config_pkey" PRIMARY KEY ("id"),
CONSTRAINT "config_check" CHECK(id = '1')
);


CREATE TABLE "config_csv_import" (
"table_name" varchar(50) NOT NULL,
"gis_client_layer_name" varchar(50),
CONSTRAINT "config_csv_import_pkey" PRIMARY KEY ("table_name")
);


CREATE TABLE "config_search_plus" (
"id" varchar(18) NOT NULL,
"ppoint_layer" varchar (30),
"ppoint_field_zone" varchar (30),
"ppoint_field_number" varchar (30),
"urban_propierties_layer" varchar (30),
"urban_propierties_field_pzone" varchar (30),
"urban_propierties_field_block" varchar (30),
"urban_propierties_field_number" varchar (30),
"street_layer" varchar (30),
"street_field_code" varchar (30),
"street_field_name" varchar (30),
"portal_layer" varchar (30),
"portal_field_code" varchar (30),
"portal_field_number" varchar (30),
"hydrometer_urban_propierties_layer" varchar (30),
"hydrometer_urban_propierties_field_code" varchar (30),
"hydrometer_layer" varchar (30),
"hydrometer_field_code" varchar (30),
"hydrometer_field_urban_propierties_code" varchar (30),
CONSTRAINT "config_search_plus_pkey" PRIMARY KEY ("id"),
CONSTRAINT "config_search_plus_check" CHECK(id = '1')
);


CREATE TABLE "config_extract_raster_value" (
"id" varchar(18) NOT NULL,
"raster_layer" varchar (30),
"raster_band_value" varchar (30),
"vector_layer" varchar (30),
"vector_field_value" varchar (30),
CONSTRAINT "config_extract_raster_value_pkey" PRIMARY KEY ("id"),
CONSTRAINT "config_extract_raster_value_check" CHECK(id = '1')
);


CREATE TABLE "config_ui_forms" (
"id" serial NOT NULL,
"ui_form" varchar (50),
"ui_table" varchar (50),
"ui_column" varchar (50),
"status" boolean,
"width" int4,
"column_index" int2,
"alias" varchar (50),
CONSTRAINT "config_ui_forms_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "config_py_tables" (
"id" serial NOT NULL,
"table_name" varchar (50),
"context" varchar (50),
"plugin_version" varchar (20), 
"hidden" boolean,
"observ" varchar(50),
CONSTRAINT "config_py_tables_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "config_param_int" (
"id" varchar (50) NOT NULL,
"value" int4 NOT NULL,
"context" varchar (50),
"from_version" varchar (50), 
"to_version" varchar (50), 
"descript" text,
CONSTRAINT "config_param_int_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "config_param_text" (
"id" varchar (50) NOT NULL,
"value" text NOT NULL,
"context" varchar (50),
"from_version" varchar (50), 
"to_version" varchar (50), 
"descript" text,
CONSTRAINT "config_param_text_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "config_param_float" (
"id" varchar (50) NOT NULL,
"value" double precision NOT NULL,
"context" varchar (50),
"from_version" varchar (50), 
"to_version" varchar (50), 
"descript" text,
CONSTRAINT "config_param_float_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "config_param_bool" (
"id" varchar (50) NOT NULL,
"value" boolean NOT NULL,
"context" varchar (50),
"from_version" varchar (50), 
"to_version" varchar (50), 
"descript" text,
CONSTRAINT "config_param_bool_pkey" PRIMARY KEY ("id")
);


