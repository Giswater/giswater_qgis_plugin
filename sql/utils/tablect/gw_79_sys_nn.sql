/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP

ALTER TABLE version ALTER COLUMN "giswater" DROP NOT NULL;
ALTER TABLE version ALTER COLUMN "wsoftware" DROP NOT NULL;
ALTER TABLE version ALTER COLUMN "postgres" DROP NOT NULL;
ALTER TABLE version ALTER COLUMN "postgis" DROP NOT NULL;
ALTER TABLE version ALTER COLUMN "date" DROP NOT NULL;
ALTER TABLE version ALTER COLUMN "language" DROP NOT NULL;
ALTER TABLE version ALTER COLUMN "epsg" DROP NOT NULL;


ALTER TABLE config_client_forms ALTER COLUMN "table_id" DROP NOT NULL;
ALTER TABLE config_client_forms ALTER COLUMN "status" DROP NOT NULL;
ALTER TABLE config_client_forms ALTER COLUMN "width" DROP NOT NULL;
ALTER TABLE config_client_forms ALTER COLUMN "column_index" DROP NOT NULL;


ALTER TABLE config_param_system ALTER COLUMN "parameter" DROP NOT NULL;

ALTER TABLE config_param_user ALTER COLUMN "parameter" DROP NOT NULL;
ALTER TABLE config_param_user ALTER COLUMN cur_user DROP NOT NULL;


ALTER TABLE selector_expl ALTER COLUMN expl_id DROP NOT NULL;
ALTER TABLE selector_expl ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE selector_psector ALTER COLUMN psector_id DROP NOT NULL;
ALTER TABLE selector_psector ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE selector_state ALTER COLUMN state_id DROP NOT NULL;
ALTER TABLE selector_state ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE audit_log_arc_traceability ALTER COLUMN "type" DROP NOT NULL;
ALTER TABLE audit_log_arc_traceability ALTER COLUMN arc_id DROP NOT NULL;
ALTER TABLE audit_log_arc_traceability ALTER COLUMN arc_id1 DROP NOT NULL;
ALTER TABLE audit_log_arc_traceability ALTER COLUMN arc_id2 DROP NOT NULL;
ALTER TABLE audit_log_arc_traceability ALTER COLUMN node_id DROP NOT NULL;

ALTER TABLE dimensions ALTER COLUMN "state" DROP NOT NULL;
ALTER TABLE dimensions ALTER COLUMN expl_id DROP NOT NULL;

ALTER TABLE audit_cat_function ALTER COLUMN function_name DROP NOT NULL;




--SET

ALTER TABLE version ALTER COLUMN "giswater" SET NOT NULL;
ALTER TABLE version ALTER COLUMN "wsoftware" SET NOT NULL;
ALTER TABLE version ALTER COLUMN "postgres" SET NOT NULL;
ALTER TABLE version ALTER COLUMN "postgis" SET NOT NULL;
ALTER TABLE version ALTER COLUMN "date" SET NOT NULL;
ALTER TABLE version ALTER COLUMN "language" SET NOT NULL;
ALTER TABLE version ALTER COLUMN "epsg" SET NOT NULL;


ALTER TABLE config_client_forms ALTER COLUMN "table_id" SET NOT NULL;
--ALTER TABLE config_client_forms ALTER COLUMN "status" SET NOT NULL;
--ALTER TABLE config_client_forms ALTER COLUMN "width" SET NOT NULL;
--ALTER TABLE config_client_forms ALTER COLUMN "column_index" SET NOT NULL;


ALTER TABLE config_param_system ALTER COLUMN "parameter" SET NOT NULL;


ALTER TABLE config_param_user ALTER COLUMN "parameter" SET NOT NULL;
ALTER TABLE config_param_user ALTER COLUMN cur_user SET NOT NULL;


ALTER TABLE selector_expl ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE selector_expl ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE selector_psector ALTER COLUMN psector_id SET NOT NULL;
ALTER TABLE selector_psector ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE selector_state ALTER COLUMN state_id SET NOT NULL;
ALTER TABLE selector_state ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE audit_log_arc_traceability ALTER COLUMN "type" SET NOT NULL;
ALTER TABLE audit_log_arc_traceability ALTER COLUMN arc_id SET NOT NULL;
ALTER TABLE audit_log_arc_traceability ALTER COLUMN arc_id1 SET NOT NULL;
ALTER TABLE audit_log_arc_traceability ALTER COLUMN arc_id2 SET NOT NULL;
ALTER TABLE audit_log_arc_traceability ALTER COLUMN node_id SET NOT NULL;

ALTER TABLE dimensions ALTER COLUMN "state" SET NOT NULL;
ALTER TABLE dimensions ALTER COLUMN expl_id SET NOT NULL;

ALTER TABLE audit_cat_function ALTER COLUMN function_name SET NOT NULL;



