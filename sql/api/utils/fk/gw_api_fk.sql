
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


--DROP CONSTRAINTS
ALTER TABLE "config_web_fields" DROP CONSTRAINT IF EXISTS "config_web_fields_column_id_fkey";
ALTER TABLE "config_web_fields" DROP CONSTRAINT IF EXISTS "config_web_fields_origin_id_fkey";
ALTER TABLE "config_web_fields" DROP CONSTRAINT IF EXISTS "config_web_fields_datatype_fkey";
ALTER TABLE "config_web_fields" DROP CONSTRAINT IF EXISTS "config_web_fields_type_fkey";

ALTER TABLE "config_web_layer_cat_form" DROP CONSTRAINT IF EXISTS "config_web_layer_cat_form_name_unique" CASCADE ;

ALTER TABLE "config_web_tabs" DROP CONSTRAINT IF EXISTS "config_web_layer_formtab_fkey";
ALTER TABLE "config_web_tabs" DROP CONSTRAINT IF EXISTS "config_web_layer_formid_fkey";
ALTER TABLE "config_web_tabs" DROP CONSTRAINT IF EXISTS "config_web_layer_formname_fkey";




--ADD CONSTRAINTS
--ALTER TABLE "config_web_fields" ADD CONSTRAINT "config_web_fields_column_id_fkey" FOREIGN KEY ("dv_table", "dv_key_column")  REFERENCES "audit_cat_table_x_column" ("table_id", "column_id") MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
--ALTER TABLE "config_web_fields" ADD CONSTRAINT "config_web_fields_origin_id_fkey" FOREIGN KEY ("table_id","column_id") REFERENCES "audit_cat_table_x_column" ("table_id", "column_id") MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE "config_web_fields" ADD CONSTRAINT "config_web_fields_datatype_fkey" FOREIGN KEY ("dataType") REFERENCES "config_web_fields_cat_datatype" ("id") MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE "config_web_fields" ADD CONSTRAINT "config_web_fields_type_fkey" FOREIGN KEY ("type") REFERENCES "config_web_fields_cat_type" ("id") MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE "config_web_layer_cat_form" ADD CONSTRAINT "config_web_layer_cat_form_name_unique" UNIQUE  ("name");

ALTER TABLE "config_web_tabs" ADD CONSTRAINT "config_web_layer_formtab_fkey" FOREIGN KEY ("formtab") REFERENCES "config_web_layer_cat_formtab" ("id") MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
