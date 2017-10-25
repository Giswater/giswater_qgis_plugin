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
ALTER TABLE config_client_forms ALTER COLUMN "alias" DROP NOT NULL;

ALTER TABLE config_web_forms ALTER COLUMN "table_id" DROP NOT NULL;
ALTER TABLE config_web_forms ALTER COLUMN "query_text" DROP NOT NULL;
ALTER TABLE config_web_forms ALTER COLUMN "device" DROP NOT NULL;

ALTER TABLE config_param_system ALTER COLUMN "value" DROP NOT NULL;
ALTER TABLE config_param_system ALTER COLUMN "parameter" DROP NOT NULL;

ALTER TABLE config_param_user ALTER COLUMN "value" DROP NOT NULL;
ALTER TABLE config_param_user ALTER COLUMN "parameter" DROP NOT NULL;
ALTER TABLE config_param_user ALTER COLUMN cur_user DROP NOT NULL;


ALTER TABLE selector_expl ALTER COLUMN expl_id DROP NOT NULL;
ALTER TABLE selector_expl ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE selector_psector ALTER COLUMN expl_id DROP NOT NULL;
ALTER TABLE selector_psector ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE selector_state ALTER COLUMN expl_id DROP NOT NULL;
ALTER TABLE selector_state ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE om_traceability ALTER COLUMN "type" DROP NOT NULL;
ALTER TABLE om_traceability ALTER COLUMN arc_id DROP NOT NULL;
ALTER TABLE om_traceability ALTER COLUMN arc_id1 DROP NOT NULL;
ALTER TABLE om_traceability ALTER COLUMN arc_id2 DROP NOT NULL;
ALTER TABLE om_traceability ALTER COLUMN node_id DROP NOT NULL;

ALTER TABLE dimensions ALTER COLUMN "state" DROP NOT NULL;
ALTER TABLE dimensions ALTER COLUMN expl_id DROP NOT NULL;

ALTER TABLE db_cat_clientlayer ALTER COLUMN db_cat_table_id DROP NOT NULL;

ALTER TABLE audit_cat_function ALTER COLUMN name DROP NOT NULL;

ALTER TABLE ext_municipality ALTER COLUMN name DROP NOT NULL;

ALTER TABLE ext_streetaxis ALTER COLUMN expl_id DROP NOT NULL;
ALTER TABLE ext_streetaxis ALTER COLUMN muni_id DROP NOT NULL;
ALTER TABLE ext_streetaxis ALTER COLUMN name DROP NOT NULL;

ALTER TABLE ext_address ALTER COLUMN muni_id DROP NOT NULL;
ALTER TABLE ext_address ALTER COLUMN expl_id DROP NOT NULL;
ALTER TABLE ext_address ALTER COLUMN streetaxis_id DROP NOT NULL;
ALTER TABLE ext_address ALTER COLUMN postnumber DROP NOT NULL;

ALTER TABLE ext_plot ALTER COLUMN muni_id DROP NOT NULL;
ALTER TABLE ext_plot ALTER COLUMN expl_id DROP NOT NULL;
ALTER TABLE ext_plot ALTER COLUMN streetaxis_id DROP NOT NULL;


--SET

ALTER TABLE version ALTER COLUMN "giswater" SET NOT NULL;
ALTER TABLE version ALTER COLUMN "wsoftware" SET NOT NULL;
ALTER TABLE version ALTER COLUMN "postgres" SET NOT NULL;
ALTER TABLE version ALTER COLUMN "postgis" SET NOT NULL;
ALTER TABLE version ALTER COLUMN "date" SET NOT NULL;
ALTER TABLE version ALTER COLUMN "language" SET NOT NULL;
ALTER TABLE version ALTER COLUMN "epsg" SET NOT NULL;


ALTER TABLE config_client_forms ALTER COLUMN "table_id" SET NOT NULL;
ALTER TABLE config_client_forms ALTER COLUMN "status" SET NOT NULL;
ALTER TABLE config_client_forms ALTER COLUMN "width" SET NOT NULL;
ALTER TABLE config_client_forms ALTER COLUMN "column_index" SET NOT NULL;
ALTER TABLE config_client_forms ALTER COLUMN "alias" SET NOT NULL;

ALTER TABLE config_web_forms ALTER COLUMN "table_id" SET NOT NULL;
ALTER TABLE config_web_forms ALTER COLUMN "query_mobil" SET NOT NULL;
ALTER TABLE config_web_forms ALTER COLUMN "query_tablet" SET NOT NULL;
ALTER TABLE config_web_forms ALTER COLUMN "query_pc" SET NOT NULL;

ALTER TABLE config_param_system ALTER COLUMN "value" SET NOT NULL;
ALTER TABLE config_param_system ALTER COLUMN "parameter" SET NOT NULL;

ALTER TABLE config_param_user ALTER COLUMN "value" SET NOT NULL;
ALTER TABLE config_param_user ALTER COLUMN "parameter" SET NOT NULL;
ALTER TABLE config_param_user ALTER COLUMN cur_user SET NOT NULL;


ALTER TABLE selector_expl ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE selector_expl ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE selector_psector ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE selector_psector ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE selector_state ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE selector_state ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE om_traceability ALTER COLUMN "type" SET NOT NULL;
ALTER TABLE om_traceability ALTER COLUMN arc_id SET NOT NULL;
ALTER TABLE om_traceability ALTER COLUMN arc_id1 SET NOT NULL;
ALTER TABLE om_traceability ALTER COLUMN arc_id2 SET NOT NULL;
ALTER TABLE om_traceability ALTER COLUMN node_id SET NOT NULL;

ALTER TABLE dimensions ALTER COLUMN "state" SET NOT NULL;
ALTER TABLE dimensions ALTER COLUMN expl_id SET NOT NULL;

ALTER TABLE db_cat_clientlayer ALTER COLUMN db_cat_table_id SET NOT NULL;

ALTER TABLE audit_cat_function ALTER COLUMN name SET NOT NULL;

ALTER TABLE ext_municipality ALTER COLUMN name SET NOT NULL;

ALTER TABLE ext_streetaxis ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE ext_streetaxis ALTER COLUMN muni_id SET NOT NULL;
ALTER TABLE ext_streetaxis ALTER COLUMN name SET NOT NULL;

ALTER TABLE ext_address ALTER COLUMN muni_id SET NOT NULL;
ALTER TABLE ext_address ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE ext_address ALTER COLUMN streetaxis_id SET NOT NULL;
ALTER TABLE ext_address ALTER COLUMN postnumber SET NOT NULL;

ALTER TABLE ext_plot ALTER COLUMN muni_id SET NOT NULL;
ALTER TABLE ext_plot ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE ext_plot ALTER COLUMN streetaxis_id SET NOT NULL;

