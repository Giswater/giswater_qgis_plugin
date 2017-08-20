/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;


ALTER TABLE "audit_function_actions" DROP CONSTRAINT IF EXISTS "audit_function_actions_audit_cat_error_id_fkey";
ALTER TABLE "audit_function_actions" DROP CONSTRAINT IF EXISTS "audit_function_actions_audit_cat_function_id_fkey";


ALTER TABLE config_client_dvalue ADD CONSTRAINT config_client_value_column_id_fkey FOREIGN KEY (dv_table, dv_key_column)  
REFERENCES db_cat_table_x_column (table_id, column_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE config_client_dvalue ADD CONSTRAINT config_client_value_origin_id_fkey FOREIGN KEY (table_id, column_id)
REFERENCES db_cat_table_x_column (table_id, column_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE audit_function_actions ADD CONSTRAINT "audit_function_actions_audit_cat_error_id_fkey" FOREIGN KEY ("audit_cat_error_id") 
REFERENCES audit_cat_error ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE audit_function_actions ADD CONSTRAINT "audit_function_actions_audit_cat_function_id_fkey" FOREIGN KEY ("audit_cat_function_id") 
REFERENCES audit_cat_function ("id") ON DELETE CASCADE ON UPDATE CASCADE;

