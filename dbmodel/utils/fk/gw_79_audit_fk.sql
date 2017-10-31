/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP

ALTER TABLE db_cat_table_x_column DROP CONSTRAINT IF EXISTS table_id_column_id_unique;

ALTER TABLE "config_web_fields" DROP CONSTRAINT IF EXISTS "config_web_fields_column_id_fkey";
ALTER TABLE "config_web_fields" DROP CONSTRAINT IF EXISTS "config_web_fields_origin_id_fkey";

ALTER TABLE selector_psector DROP CONSTRAINT IF EXISTS psector_id_cur_user_unique;
ALTER TABLE "selector_psector" DROP CONSTRAINT IF EXISTS "selector_psector_id_fkey";

ALTER TABLE selector_state DROP CONSTRAINT IF EXISTS state_id_cur_user_unique;
ALTER TABLE "selector_state" DROP CONSTRAINT IF EXISTS "selector_state_id_fkey";

ALTER TABLE selector_expl DROP CONSTRAINT IF EXISTS expl_id_cur_user_unique;
ALTER TABLE "selector_expl" DROP CONSTRAINT IF EXISTS "selector_expl_id_fkey";

ALTER TABLE "dimensions" DROP CONSTRAINT IF EXISTS "dimensions_feature_type_fkey";
ALTER TABLE "dimensions" DROP CONSTRAINT IF EXISTS "dimensions_state_fkey";
ALTER TABLE "dimensions" DROP CONSTRAINT IF EXISTS "dimensions_exploitation_id_fkey";

ALTER TABLE "db_cat_table_x_column" DROP CONSTRAINT IF EXISTS "db_cat_table_x_column_table_id_fkey";

ALTER TABLE "audit_function_actions"  DROP CONSTRAINT IF EXISTS "audit_function_actions_audit_cat_error_id_fkey";
ALTER TABLE "audit_function_actions"  DROP CONSTRAINT IF EXISTS "audit_function_actions_audit_cat_function_id_fkey";

ALTER TABLE "ext_streetaxis" DROP CONSTRAINT IF EXISTS "ext_streetaxis_exploitation_id_fkey";
ALTER TABLE "ext_streetaxis" DROP CONSTRAINT IF EXISTS "ext_streetaxis_muni_id_fkey";
ALTER TABLE "ext_streetaxis" DROP CONSTRAINT IF EXISTS "ext_streetaxis_type_street_fkey";

ALTER TABLE "ext_address" DROP CONSTRAINT IF EXISTS "ext_address_exploitation_id_fkey";
ALTER TABLE "ext_address" DROP CONSTRAINT IF EXISTS "ext_address_muni_id_fkey";
ALTER TABLE "ext_address" DROP CONSTRAINT IF EXISTS "ext_address_streetaxis_id_fkey";
ALTER TABLE "ext_address" DROP CONSTRAINT IF EXISTS "ext_address_plot_id_fkey";


ALTER TABLE "ext_plot" DROP CONSTRAINT IF EXISTS "ext_plot_exploitation_id_fkey";
ALTER TABLE "ext_plot" DROP CONSTRAINT IF EXISTS "ext_plot_muni_id_fkey";
ALTER TABLE "ext_plot" DROP CONSTRAINT IF EXISTS "ext_plot_streetaxis_id_fkey";


--ADD

ALTER TABLE db_cat_table_x_column ADD CONSTRAINT table_id_column_id_unique UNIQUE("table_id","column_id");

ALTER TABLE "config_web_fields" ADD CONSTRAINT "config_web_fields_column_id_fkey" FOREIGN KEY ("dv_table", "dv_key_column")  
REFERENCES "db_cat_table_x_column" ("table_id", "column_id") MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE "config_web_fields" ADD CONSTRAINT "config_web_fields_origin_id_fkey" FOREIGN KEY ("table_id","column_id")
REFERENCES "db_cat_table_x_column" ("table_id", "column_id") MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE selector_psector ADD CONSTRAINT psector_id_cur_user_unique UNIQUE(psector_id, cur_user);
ALTER TABLE "selector_psector" ADD CONSTRAINT "selector_psector_id_fkey" FOREIGN KEY ("psector_id") REFERENCES "plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE selector_state ADD CONSTRAINT state_id_cur_user_unique UNIQUE(state_id, cur_user);
ALTER TABLE "selector_state" ADD CONSTRAINT "selector_state_id_fkey" FOREIGN KEY ("state_id") REFERENCES "value_state" ("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE selector_expl ADD CONSTRAINT expl_id_cur_user_unique UNIQUE(expl_id, cur_user);
ALTER TABLE "selector_expl" ADD CONSTRAINT "selector_expl_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "dimensions" ADD CONSTRAINT "dimensions_feature_type_fkey" FOREIGN KEY ("feature_type") REFERENCES "sys_feature_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "dimensions" ADD CONSTRAINT "dimensions_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "dimensions" ADD CONSTRAINT "dimensions_exploitation_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "db_cat_table_x_column" ADD CONSTRAINT "db_cat_table_x_column_table_id_fkey" FOREIGN KEY ("table_id")  
REFERENCES "db_cat_table" ("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE "audit_function_actions" ADD CONSTRAINT "audit_function_actions_audit_cat_error_id_fkey" FOREIGN KEY ("audit_cat_error_id") REFERENCES "audit_cat_error" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "audit_function_actions"ADD CONSTRAINT "audit_function_actions_audit_cat_function_id_fkey" FOREIGN KEY ("audit_cat_function_id") REFERENCES "audit_cat_function" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "ext_streetaxis" ADD CONSTRAINT "ext_streetaxis_exploitation_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "ext_streetaxis" ADD CONSTRAINT "ext_streetaxis_muni_id_fkey" FOREIGN KEY ("muni_id") REFERENCES "ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "ext_streetaxis" ADD CONSTRAINT "ext_streetaxis_type_street_fkey" FOREIGN KEY ("type") REFERENCES "ext_type_street" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "ext_address" ADD CONSTRAINT "ext_address_exploitation_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "ext_address" ADD CONSTRAINT "ext_address_muni_id_fkey" FOREIGN KEY ("muni_id") REFERENCES "ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "ext_address" ADD CONSTRAINT "ext_address_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "ext_address" ADD CONSTRAINT "ext_address_plot_id_fkey" FOREIGN KEY ("plot_id") REFERENCES "ext_plot" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "ext_plot" ADD CONSTRAINT "ext_plot_exploitation_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "ext_plot" ADD CONSTRAINT "ext_plot_muni_id_fkey" FOREIGN KEY ("muni_id") REFERENCES "ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "ext_plot" ADD CONSTRAINT "ext_plot_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

