/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_ws_migrate_30to32(p_source_schema varchar,p_target_schema varchar)
  RETURNS numeric AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_ws_migrate_30to32('source','target');
*/

DECLARE

rec record;

BEGIN
    -- Search path
    SET search_path = SCHEMA_NAME, public;

	ALTER TABLE arc DISABLE TRIGGER gw_trg_topocontrol_arc;
	ALTER TABLE node DISABLE TRIGGER gw_trg_topocontrol_node;
	ALTER TABLE node DISABLE TRIGGER gw_trg_node_update;
	

	--truncate admin tables that may be customized
	TRUNCATE cat_feature;
	TRUNCATE arc_type;
	TRUNCATE node_type;
	TRUNCATE connec_type;
	TRUNCATE value_state;
	TRUNCATE value_state_type;
	TRUNCATE doc_type;
	TRUNCATE element_type;
	TRUNCATE man_addfields_parameter;
	TRUNCATE config_visit_parameter;
		
	TRUNCATE cat_mat_roughness;
	TRUNCATE inp_report;
	TRUNCATE inp_times;
	
	EXECUTE 'INSERT INTO cat_feature SELECT * FROM '||p_source_schema||'.cat_feature;';
	EXECUTE 'INSERT INTO arc_type SELECT * FROM '||p_source_schema||'.arc_type;';
	EXECUTE 'INSERT INTO node_type SELECT * FROM '||p_source_schema||'.node_type;';
	EXECUTE 'INSERT INTO connec_type SELECT * FROM '||p_source_schema||'.connec_type;';
	EXECUTE 'INSERT INTO value_state SELECT * FROM '||p_source_schema||'.value_state;';
	EXECUTE 'INSERT INTO value_state_type SELECT * FROM '||p_source_schema||'.value_state_type;';
	EXECUTE 'INSERT INTO doc_type SELECT * FROM '||p_source_schema||'.doc_type;';
	EXECUTE 'INSERT INTO element_type SELECT * FROM '||p_source_schema||'.element_type;';
	EXECUTE 'INSERT INTO man_addfields_parameter SELECT * FROM '||p_source_schema||'.man_addfields_parameter;';
	EXECUTE 'INSERT INTO config_visit_parameter SELECT * FROM '||p_source_schema||'.config_visit_parameter;';
	
	--loop over tables that are not assigned to role_admin
    FOR rec IN EXECUTE 
    'SELECT id FROM '||p_source_schema||'.audit_cat_table WHERE sys_role!=''role_admin''
    and (id not ilike ''v_%'' and id not ilike ''%selector%'' and id  not ilike ''config%'' and id not ilike ''ext_rtc_hydrometer_state'') order by id' 
    LOOP
		--direct insert from one schema to another. Special ELSIF for the tables which need transformation
		IF rec.id!='ext_streetaxis' AND rec.id!='cat_mat_roughness'  AND rec.id!='inp_pump' AND rec.id!='inp_pipe' AND rec.id!='inp_shortpipe'
		AND rec.id!='inp_valve' AND rec.id!='plan_psector_x_node' AND rec.id!='plan_psector_x_arc' AND rec.id!='plan_arc_x_pavement' THEN
			
		EXECUTE 'INSERT INTO '||rec.id||' SELECT * FROM '||p_source_schema||'.'||rec.id||';';

		ELSIF rec.id='ext_streetaxis' THEN
			EXECUTE 'INSERT INTO ext_streetaxis 
			SELECT id, code, type, name, text, ST_Multi(the_geom), expl_id, muni_id FROM '||p_source_schema||'.'||rec.id||';';

		ELSIF rec.id='plan_psector_x_node' THEN
			EXECUTE 'INSERT INTO plan_psector_x_node (node_id, psector_id, state, doable, descript) 
			SELECT node_id, psector_id, state, doable, descript FROM '||p_source_schema||'.plan_psector_x_node;';
			
		ELSIF rec.id='plan_psector_x_arc' THEN
			EXECUTE 'INSERT INTO plan_psector_x_arc (arc_id, psector_id, state, doable, descript) 
			SELECT arc_id, psector_id, state, doable, descript FROM '||p_source_schema||'.plan_psector_x_arc;';
			
		ELSIF rec.id='inp_pump' THEN
			EXECUTE 'INSERT INTO inp_pump (node_id, power, curve_id, speed, pattern, status, to_arc) 
			SELECT node_id, power, curve_id, speed, pattern, inp_typevalue.id, to_arc 
			FROM '||p_source_schema||'.'||rec.id||' LEFT JOIN '||p_target_schema||'.inp_typevalue on status=idval AND typevalue=''inp_value_status_pump'';';

		ELSIF rec.id='inp_pipe' THEN
			EXECUTE 'INSERT INTO inp_pipe (arc_id, minorloss, status, custom_roughness, custom_dint) 
			SELECT arc_id, minorloss, inp_typevalue.id, custom_roughness, custom_dint 
			FROM '||p_source_schema||'.'||rec.id||' LEFT JOIN '||p_target_schema||'.inp_typevalue on status=idval AND typevalue=''inp_value_status_pipe'';';
		
		ELSIF rec.id='inp_shortpipe' THEN
			EXECUTE 'INSERT INTO inp_shortpipe (node_id, minorloss, to_arc, status) 
			SELECT node_id, minorloss, to_arc, inp_typevalue.id 
			FROM '||p_source_schema||'.'||rec.id||' LEFT JOIN '||p_target_schema||'.inp_typevalue on status=idval AND typevalue=''inp_value_status_shortpipe'';';

		ELSIF rec.id='inp_valve' THEN
			EXECUTE 'INSERT INTO inp_valve (node_id, valv_type, pressure, diameter, flow, coef_loss, curve_id,minorloss, status, to_arc) 
			SELECT node_id, valv_type, pressure, diameter, flow, coef_loss, curve_id, minorloss, inp_typevalue.id, to_arc
			FROM '||p_source_schema||'.'||rec.id||' LEFT JOIN '||p_target_schema||'.inp_typevalue on status=idval AND typevalue=''inp_value_status_valve'';';

		END IF;
    END LOOP;

	ALTER TABLE arc ENABLE TRIGGER gw_trg_topocontrol_arc;
	ALTER TABLE node ENABLE TRIGGER gw_trg_topocontrol_node;
	ALTER TABLE node ENABLE TRIGGER gw_trg_node_update;

    return 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


