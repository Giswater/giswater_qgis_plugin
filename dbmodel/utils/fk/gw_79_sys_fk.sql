/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP



ALTER TABLE "selector_psector" DROP CONSTRAINT IF EXISTS psector_id_cur_user_unique;
ALTER TABLE "selector_psector" DROP CONSTRAINT IF EXISTS "selector_psector_id_fkey";

ALTER TABLE "selector_state" DROP CONSTRAINT IF EXISTS state_id_cur_user_unique;
ALTER TABLE "selector_state" DROP CONSTRAINT IF EXISTS "selector_state_id_fkey";

ALTER TABLE "selector_expl" DROP CONSTRAINT IF EXISTS expl_id_cur_user_unique;
ALTER TABLE "selector_expl" DROP CONSTRAINT IF EXISTS "selector_expl_id_fkey";

ALTER TABLE "selector_audit" DROP CONSTRAINT IF EXISTS selector_audit_fprocesscat_id_cur_user_unique;
ALTER TABLE "selector_audit" DROP CONSTRAINT IF EXISTS "selector_audit_fprocesscat_id_fkey";

ALTER TABLE "selector_workcat" DROP CONSTRAINT IF EXISTS selector_workcat_workcat_cur_user_unique;
ALTER TABLE "selector_workcat" DROP CONSTRAINT IF EXISTS "selector_workcat_workcat_id_fkey";

ALTER TABLE "dimensions" DROP CONSTRAINT IF EXISTS "dimensions_feature_type_fkey";
ALTER TABLE "dimensions" DROP CONSTRAINT IF EXISTS "dimensions_state_fkey";
ALTER TABLE "dimensions" DROP CONSTRAINT IF EXISTS "dimensions_exploitation_id_fkey";


ALTER TABLE "audit_cat_table" DROP CONSTRAINT IF EXISTS "audit_cat_table_sys_role_id_fkey" ;
ALTER TABLE "audit_cat_table" DROP CONSTRAINT IF EXISTS "audit_cat_table_qgis_role_id_fkey";

ALTER TABLE "audit_cat_function" DROP CONSTRAINT IF EXISTS "audit_cat_function_sys_role_id_fkey" ;

ALTER TABLE "audit_check_project" DROP CONSTRAINT IF EXISTS "audit_check_project_fprocesscat_id_fkey";

ALTER TABLE "sys_csv2pg_cat" DROP CONSTRAINT IF EXISTS "sys_csv2pg_cat_sys_role_fkey";

ALTER TABLE "temp_csv2pg" DROP CONSTRAINT IF EXISTS "temp_csv2pg_csv2pgcat_id_fkey";




--ADD

ALTER TABLE "selector_psector" ADD CONSTRAINT "psector_id_cur_user_unique" UNIQUE(psector_id, cur_user);
ALTER TABLE "selector_psector" ADD CONSTRAINT "selector_psector_id_fkey" FOREIGN KEY ("psector_id") REFERENCES "plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "selector_state" ADD CONSTRAINT "state_id_cur_user_unique" UNIQUE(state_id, cur_user);
ALTER TABLE "selector_state" ADD CONSTRAINT "selector_state_id_fkey" FOREIGN KEY ("state_id") REFERENCES "value_state" ("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "selector_expl" ADD CONSTRAINT "expl_id_cur_user_unique" UNIQUE(expl_id, cur_user);
ALTER TABLE "selector_expl" ADD CONSTRAINT "selector_expl_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "selector_audit" ADD CONSTRAINT selector_audit_fprocesscat_id_cur_user_unique UNIQUE(fprocesscat_id, cur_user);
ALTER TABLE "selector_audit" ADD CONSTRAINT "selector_audit_fprocesscat_id_fkey" FOREIGN KEY ("fprocesscat_id") REFERENCES "sys_fprocess_cat" ("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "selector_workcat" ADD CONSTRAINT selector_workcat_workcat_cur_user_unique UNIQUE(workcat_id, cur_user);
ALTER TABLE "selector_workcat" ADD CONSTRAINT "selector_workcat_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "dimensions" ADD CONSTRAINT "dimensions_feature_type_fkey" FOREIGN KEY ("feature_type") REFERENCES "sys_feature_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "dimensions" ADD CONSTRAINT "dimensions_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "dimensions" ADD CONSTRAINT "dimensions_exploitation_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "audit_cat_table" ADD CONSTRAINT "audit_cat_table_sys_role_id_fkey" FOREIGN KEY ("sys_role_id")  REFERENCES "sys_role" ("id") ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE "audit_cat_table" ADD CONSTRAINT "audit_cat_table_qgis_role_id_fkey" FOREIGN KEY ("qgis_role_id")  REFERENCES "sys_role" ("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE "audit_cat_function" ADD CONSTRAINT "audit_cat_function_sys_role_id_fkey" FOREIGN KEY ("sys_role_id")  REFERENCES "sys_role" ("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE "audit_check_project" ADD CONSTRAINT "audit_check_project_fprocesscat_id_fkey" FOREIGN KEY ("fprocesscat_id")  REFERENCES "sys_fprocess_cat" ("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE "sys_csv2pg_cat" ADD CONSTRAINT "sys_csv2pg_cat_sys_role_fkey" FOREIGN KEY ("sys_role") REFERENCES "sys_role" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "temp_csv2pg" ADD CONSTRAINT "temp_csv2pg_csv2pgcat_id_fkey" FOREIGN KEY ("csv2pgcat_id") REFERENCES "sys_csv2pg_cat" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


