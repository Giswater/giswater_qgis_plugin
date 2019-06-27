/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2126


--DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_feature_replace(json);


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_feature_replace(p_data json)
RETURNS json AS

/*
SELECT SCHEMA_NAME.gw_fct_feature_replace($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"type":"NODE"},
"data":{"old_feature_id":"129","workcat_id_end":"work1", "enddate":"2019-05-17","keep_elements":true }}$$)
*/
 

$BODY$
DECLARE

	the_geom_aux public.geometry;
	query_string_select text;
	query_string_insert text;
	query_string_update text;
	column_aux varchar;
	value_aux text;
	state_aux integer;
	state_type_aux integer;
	epa_type_aux text;
	rec_arc record;	
	v_old_featuretype varchar;
	v_old_featurecat varchar;
	sector_id_aux integer;
	dma_id_aux integer;
	expl_id_aux integer;
	man_table_aux varchar;
	epa_table_aux varchar;
	v_code_autofill boolean;
	v_code	int8;
	v_id int8;
	v_old_feature_id varchar;
	v_workcat_id_end varchar;
	v_enddate date;
	v_keep_elements boolean;
	v_feature_type text;
	v_feature_layer text;
	v_id_column text;
	v_feature_type_table text;
	v_type_column text;
	v_cat_column text;
	v_sql text;
	v_element_table text;
	verified_id_aux text;
	inventory_aux boolean;
	v_connec_proximity_value text;
	v_connec_proximity_activ text;
	v_result_id text= 'replace feature';
	v_project_type text;
	v_version text;
	v_result text;
	v_result_info text;

BEGIN

	-- Search path
	SET search_path = 'SCHEMA_NAME', public;

	SELECT wsoftware, giswater  INTO v_project_type, v_version FROM version order by 1 desc limit 1;
	
		-- manage log (fprocesscat = 43)
	DELETE FROM audit_check_data WHERE fprocesscat_id=43 AND user_name=current_user;
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (43, v_result_id, concat('REPLACE FEATURE'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (43, v_result_id, concat('------------------------------'));

	-- get input parameters
	
	v_feature_type = lower(((p_data ->>'feature')::json->>'type'))::text;
	v_old_feature_id = ((p_data ->>'data')::json->>'old_feature_id')::text;
	v_workcat_id_end = ((p_data ->>'data')::json->>'workcat_id_end')::text;
	v_enddate = ((p_data ->>'data')::json->>'enddate')::text;
	v_keep_elements = ((p_data ->>'data')::json->>'keep_elements')::text;

	--deactivate connec proximity control
	IF v_feature_type='connec' THEN
		SELECT  value::json->>'value' as value INTO v_connec_proximity_value FROM config_param_system where parameter = 'connec_proximity';
		SELECT  value::json->>'activated' INTO v_connec_proximity_activ FROM config_param_system where parameter = 'connec_proximity';
		UPDATE config_param_system SET value ='{"activated":false,"value":0.1}' WHERE parameter='connec_proximity';
	END IF;


	--define columns used for feature_cat
	v_feature_layer = concat('v_edit_',v_feature_type);
	v_feature_type_table = concat(v_feature_type,'_type');
	v_id_column:=concat(v_feature_type,'_id');
	
	IF v_project_type='WS' THEN
		v_type_column=concat(v_feature_type,'type_id');
	ELSE 
		v_type_column=concat(v_feature_type,'_type');
	END IF;
	
	IF v_feature_type='connec' THEN
		v_cat_column='connecat_id';
	ELSIF  v_feature_type='gully' THEN
		v_cat_column = 'gratecat_id';
	ELSIF  v_feature_type='node' THEN
		v_cat_column='nodecat_id';
	END IF;
	

	--capture old feature type and old feature catalog
	EXECUTE 'SELECT '||v_type_column||'  FROM '|| v_feature_layer  ||' WHERE '||v_id_column||'='''||v_old_feature_id||''';'
	INTO  v_old_featuretype;

	EXECUTE 'SELECT  '|| v_cat_column||' FROM '|| v_feature_layer  ||'  WHERE '||v_id_column||'='''||v_old_feature_id||''';'
	INTO v_old_featurecat;


	--capture old feature values for basic attributes
	IF v_feature_type='node' THEN
		EXECUTE 'SELECT epa_type FROM '||v_feature_layer||' WHERE '||v_id_column||'='''||v_old_feature_id||''' '
		INTO epa_type_aux;
	END IF;
	
	EXECUTE 'SELECT sector_id FROM '||v_feature_layer||' WHERE '||v_id_column||'='''||v_old_feature_id||''';'
	INTO sector_id_aux;
	EXECUTE 'SELECT state_type FROM '||v_feature_layer||' WHERE '||v_id_column||'='''||v_old_feature_id||''';'
	INTO state_type_aux;
	EXECUTE 'SELECT state FROM '||v_feature_layer||' WHERE '||v_id_column||'='''||v_old_feature_id||''';'
	INTO state_aux;
	EXECUTE 'SELECT dma_id FROM '||v_feature_layer||' WHERE '||v_id_column||'='''||v_old_feature_id||''';'
	INTO dma_id_aux;
	EXECUTE 'SELECT the_geom FROM '||v_feature_layer||' WHERE '||v_id_column||'='''||v_old_feature_id||''';'
	INTO the_geom_aux;
	EXECUTE 'SELECT expl_id FROM '||v_feature_layer||' WHERE '||v_id_column||'='''||v_old_feature_id||''';'
	INTO expl_id_aux;
	EXECUTE 'SELECT verified FROM '||v_feature_layer||' WHERE '||v_id_column||'='''||v_old_feature_id||''';'
	INTO verified_id_aux;
	EXECUTE 'SELECT inventory FROM '||v_feature_layer||' WHERE '||v_id_column||'='''||v_old_feature_id||''';'
	INTO inventory_aux;
	


	-- Control of state(1)
	IF (state_aux=0 OR state_aux=2 OR state_aux IS NULL) THEN
		PERFORM audit_function(1070,2126,state_aux::text);
	ELSE

		-- new feature_id
		v_id := (SELECT nextval('SCHEMA_NAME.urn_id_seq'));

		-- code
		EXECUTE 'SELECT code_autofill  FROM '|| v_feature_type_table ||' WHERE id='''||v_old_featuretype||''';'
		INTO v_code_autofill;
		
		IF v_code_autofill IS TRUE THEN
			v_code = v_id;
		END IF;

		-- inserting new feature on parent tables
		IF v_feature_type='node' THEN
			IF v_project_type='WS' then
				INSERT INTO node (node_id, code, nodecat_id, epa_type, sector_id, dma_id, expl_id, state, state_type, the_geom) 
				VALUES (v_id, v_code, v_old_featurecat, epa_type_aux, sector_id_aux, dma_id_aux, expl_id_aux,  
				0, state_type_aux, the_geom_aux);
			ELSE 
				INSERT INTO node (node_id, code, node_type, nodecat_id, epa_type, sector_id, dma_id, expl_id, state, state_type, the_geom) 
				VALUES (v_id, v_code, v_old_featuretype, v_old_featurecat, epa_type_aux, sector_id_aux, dma_id_aux, expl_id_aux, 
				0, state_type_aux, the_geom_aux);
			END IF;

		ELSIF v_feature_type ='connec' THEN

			IF v_project_type='WS' then
				INSERT INTO connec (connec_id, code, connecat_id, sector_id, dma_id, expl_id, state, 
				state_type, the_geom, workcat_id, verified, inventory) 
				VALUES (v_id, v_code, v_old_featurecat, sector_id_aux, dma_id_aux,expl_id_aux, 0, 
				state_type_aux, the_geom_aux, v_workcat_id_end, verified_id_aux, inventory_aux);
			ELSE 
				INSERT INTO connec (connec_id, code, connec_type, connecat_id,  sector_id, dma_id, expl_id, state, 
				state_type, the_geom, workcat_id, verified, inventory) 
				VALUES (v_id, v_code, v_old_featuretype, v_old_featurecat, sector_id_aux, dma_id_aux, expl_id_aux,0, 
				state_type_aux, the_geom_aux,v_workcat_id_end, verified_id_aux, inventory_aux);
			END IF;	

		ELSIF v_feature_type = 'gully' THEN
			INSERT INTO gully (gully_id, code, gully_type,gratecat_id, sector_id, dma_id, expl_id, state, state_type, the_geom,workcat_id, verified, inventory) 
			VALUES (v_id, v_code, v_old_featuretype, v_old_featurecat, sector_id_aux, dma_id_aux,expl_id_aux, 0, state_type_aux, the_geom_aux, v_workcat_id_end, verified_id_aux, inventory_aux);
		END IF;

		-- inserting new feature on table man_table
		IF v_feature_type='node' or (v_feature_type='connec' AND v_project_type='WS') THEN
			EXECUTE 'SELECT man_table FROM '||v_feature_type_table||' WHERE id='''||v_old_featuretype||''';'
			INTO man_table_aux;

			query_string_insert='INSERT INTO '||man_table_aux||' VALUES ('||v_id||');';
			execute query_string_insert;

		END IF;
		
		-- inserting new feature on table epa_table
		IF v_feature_type='node' THEN
			SELECT epa_table INTO epa_table_aux FROM node_type WHERE id=v_old_featuretype;		
			query_string_insert='INSERT INTO '||epa_table_aux||' VALUES ('||v_id||');';
			execute query_string_insert;
		END IF;
		
		-- updating values on feature parent table from values of old feature

		v_sql:='select column_name    FROM information_schema.columns 
							where (table_schema=''SCHEMA_NAME'' and udt_name <> ''inet'' and 
							table_name='''||v_feature_type||''') and column_name!='''||v_id_column||''' and column_name!=''the_geom'' and column_name!=''state''
							and column_name!=''code'' and column_name!=''epa_type'' and column_name!=''state_type'' and column_name!='''||v_cat_column||'''
							and column_name!=''sector_id'' and column_name!=''dma_id'' and column_name!=''expl_id'';';
				
		FOR column_aux IN EXECUTE v_sql
		LOOP
			query_string_select= 'SELECT '||column_aux||' FROM '||v_feature_type||' where '||v_id_column||'='||quote_literal(v_old_feature_id)||';';
			IF query_string_select IS NOT NULL THEN
				EXECUTE query_string_select INTO value_aux;	
			END IF;
			
			query_string_update= 'UPDATE '||v_feature_type||' set '||column_aux||'='||quote_literal(value_aux)||' where '||v_id_column||'='||quote_literal(v_id)||';';
			IF query_string_update IS NOT NULL THEN
				EXECUTE query_string_update; 
				raise notice 'query_string_update--> parent,%',query_string_update;
			END IF;
		END LOOP;


		-- updating values on table man_table from values of old feature
		IF v_feature_type='node' or (v_feature_type='connec' AND v_project_type='WS') THEN
			v_sql:='select column_name    FROM information_schema.columns 
								where (table_schema=''SCHEMA_NAME'' and udt_name <> ''inet'' and 
								table_name='''||man_table_aux||''') and column_name!='''||v_id_column||''';';
			FOR column_aux IN EXECUTE v_sql
			LOOP
				query_string_select= 'SELECT '||column_aux||' FROM '||man_table_aux||' where '||v_id_column||'='||quote_literal(v_old_feature_id)||';';
				IF query_string_select IS NOT NULL THEN
					EXECUTE query_string_select INTO value_aux;	
				END IF;
				
				query_string_update= 'UPDATE '||man_table_aux||' set '||column_aux||'='||quote_literal(value_aux)||' where node_id='||quote_literal(v_id)||';';
				IF query_string_update IS NOT NULL THEN
					EXECUTE query_string_update; 
					raise notice 'query_string_update --> man_table,%',query_string_update;
				END IF;
			END LOOP;
		END IF;
		
		-- updating values on table epa_table from values of old feature
		IF v_feature_type='node' THEN
			v_sql:='select column_name  FROM information_schema.columns 
								where (table_schema=''SCHEMA_NAME'' and udt_name <> ''inet'' and 
								table_name='''||epa_table_aux||''') and column_name!='''||v_id_column||''';';
			
			FOR column_aux IN EXECUTE v_sql LOOP
				query_string_select= 'SELECT '||column_aux||' FROM '||epa_table_aux||' where node_id='||quote_literal(v_old_feature_id)||';';
				IF query_string_select IS NOT NULL THEN
					EXECUTE query_string_select INTO value_aux;	
				END IF;
				
				query_string_update= 'UPDATE '||epa_table_aux||' set '||column_aux||'='||quote_literal(value_aux)||' where '||v_id_column||'='||quote_literal(v_id)||';';
				IF query_string_update IS NOT NULL THEN
					EXECUTE query_string_update; 
					raise notice 'query_string_update --> epa,%',query_string_update;
				END IF;
			END LOOP;
		END IF;
	
		-- taking values from old feature (from man_addfields table)
		INSERT INTO man_addfields_value (feature_id, parameter_id, value_param)
		SELECT 
		v_id,
		parameter_id,
		value_param
		FROM man_addfields_value WHERE feature_id=v_old_feature_id;


		--Moving elements from old feature to new feature
		IF v_keep_elements IS TRUE THEN
			v_element_table:=concat('element_x_',v_feature_type);
			EXECUTE 'UPDATE '||v_element_table||' SET '||v_id_column||'='''||v_id||''' WHERE '||v_id_column||'='''||v_old_feature_id||''';';		
		END IF;
	
	
		-- reconnecting arcs 
		-- Dissable config parameter arc_searchnodes
		IF v_feature_type='node' THEN
			UPDATE config SET arc_searchnodes_control=FALSE;
				
			FOR rec_arc IN SELECT arc_id FROM arc WHERE node_1=v_old_feature_id
			LOOP
				UPDATE arc SET node_1=v_id where arc_id=rec_arc.arc_id;
			END LOOP;
		
			FOR rec_arc IN SELECT arc_id FROM arc WHERE node_2=v_old_feature_id
			LOOP
				UPDATE arc SET node_2=v_id where arc_id=rec_arc.arc_id;
			END LOOP;
		END IF;
		
		-- upgrading and downgrading features
		state_type_aux = (SELECT id FROM value_state_type WHERE state=0 LIMIT 1);
		
		EXECUTE 'UPDATE '||v_feature_type||' SET state=0, workcat_id_end='''||v_workcat_id_end||''', enddate='''||v_enddate||''', state_type='||state_type_aux||'
		WHERE '||v_id_column||'='''||v_old_feature_id||''';';

		
		EXECUTE 'UPDATE '||v_feature_type||' SET state=1, workcat_id='''||v_workcat_id_end||''', builtdate='''||v_enddate||''', enddate=NULL WHERE '||v_id_column||'='''||v_id||''';';
	
		-- enable config parameter arc_searchnodes AND connec proximity
		UPDATE config SET arc_searchnodes_control=TRUE;
		UPDATE config SET connec_proximity_control=TRUE;
		IF v_feature_type='connec' THEN
			UPDATE config_param_system SET value =concat('{"activated":',v_connec_proximity_activ,', "value":',v_connec_proximity_value,'}') WHERE parameter='connec_proximity';
		END IF;

	END IF;
	-- manage log (fprocesscat 43)
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (43, v_result_id, concat('Insert new feature into parent table -> Done'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (43, v_result_id, concat('Copy parent, man_table and epa information -> Done'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (43, v_result_id, concat('Manage feature addfields -> Done'));
	IF v_keep_elements IS TRUE THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (43, v_result_id, concat('Assign elements to the new feature -> Done'));
	END IF;
	IF v_feature_type = 'node' THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (43, v_result_id, concat('Reconnect arcs -> Done'));
	END IF;
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (43, v_result_id, concat('Process finished'));

-- get log (fprocesscat 43)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=43) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
			
	-- Control nulls
	v_version := COALESCE(v_version, '{}'); 
	v_result_info := COALESCE(v_result_info, '{}'); 
	
 
	-- Return
	RETURN ('{"status":"Accepted", "message":{"priority":0, "text":"Process executed"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}}'||
	    '}')::json;
	    
	--    Exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN ('{"status":"Failed","message":{"priority":2, "text":' || to_json(SQLERRM) || '}, "version":"'|| v_version ||'","SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
