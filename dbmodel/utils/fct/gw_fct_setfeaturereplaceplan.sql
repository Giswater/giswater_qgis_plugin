/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3072

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_setreplacefeatureplan(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setreplacefeatureplan(p_data json)
RETURNS json AS
$BODY$

/*

SELECT SCHEMA_NAME.gw_fct_setreplacefeatureplan($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"featureType":"ARC", "ids":["2100","2101","2102"]}, "data":{"catalog":"PVC110-PN16"}}$$);
*/


DECLARE
v_version text;
v_feature text;
v_id text;
v_catalog text;
v_arc text;

rec record;

v_level integer;
v_status text;
v_message text;
v_error_context text;
v_currentpsector integer;
v_fid integer = 143;
v_count integer ;
v_result text;
v_result_info text;
v_feature_text text;
v_feature_array text[];
i integer = 0;


BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- input values
	v_feature = (p_data->>'feature')::json->>'featureType';
	v_feature_text = (p_data->>'feature')::json->>'ids';
	v_catalog = (p_data->>'data')::json->>'catalog';

	-- select config values
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get user values
	v_currentpsector  = (SELECT value FROM config_param_user WHERE parameter = 'plan_psector_vdefault' AND cur_user=current_user);

	-- manage log (fid: 143)
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user;
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('REPLACE FEATURE ON PSECTOR'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('--------------------------------------'));

	-- get values from feature array 
	IF v_feature_text ILIKE '[%]' THEN
		v_feature_array = ARRAY(SELECT json_array_elements_text(v_feature_text::json)); 		
	ELSE 
		EXECUTE v_feature_text INTO v_feature_text;
		v_feature_array = ARRAY(SELECT json_array_elements_text(v_feature_text::json)); 
	END IF;


	RAISE NOTICE ' %',v_feature_array;


	-- starting process
	IF v_feature = 'ARC' THEN

		FOREACH v_id IN ARRAY v_feature_array
		LOOP

			--getting values from existing arc
			SELECT * INTO rec FROM arc WHERE state = 1 AND arc_id = v_id;

			IF rec.arc_id IS NOT NULL THEN 

				-- counter
				i = i+1;

				-- downgrade existing arc on this psector
				INSERT INTO plan_psector_x_arc (arc_id, state, psector_id)
				VALUES (rec.arc_id, 0, v_currentpsector);

				-- setting values of new arc
				rec.state_type = (SELECT value FROM config_param_user WHERE parameter = 'edit_statetype_2_vdefault' AND cur_user=current_user);	
				rec.workcat_id_plan = (SELECT workcat_id FROM plan_psector WHERE psector_id = v_currentpsector);

				-- profilactic controls	
				IF rec.state_type IS NULL THEN
					rec.state_type = (SELECT id FROM value_state_type WHERE state_id = 1 LIMIT 1);
				END IF;
				
				-- insert new arc (also insert on psector table) 
				INSERT INTO v_edit_arc
				(arccat_id, epa_type, expl_id, sector_id, state, state_type, minsector_id, dma_id, presszone_id, dqa_id, soilcat_id,
				function_type, category_type, fluid_type, location_type, workcat_id_plan, ownercat_id, the_geom,
				muni_id, postcode, district_id, postnumber, postcomplement, postnumber2, postcomplement2,
				label_x,label_y,label_rotation,inventory)
				VALUES
				(v_catalog, rec.epa_type, rec.expl_id, rec.sector_id, 2, rec.state_type, rec.minsector_id, rec.dma_id, rec.presszone_id, rec.dqa_id, rec.soilcat_id,
				rec.function_type, rec.category_type, rec.fluid_type, rec.location_type, rec.workcat_id_plan, rec.ownercat_id, rec.the_geom,
				rec.muni_id, rec.postcode, rec.district_id, rec.postnumber, rec.postcomplement, rec.postnumber2, rec.postcomplement2,
				rec.label_x, rec.label_y, rec.label_rotation, false)
				RETURNING arc_id INTO v_arc;

				UPDATE connec SET arc_id = v_arc WHERE arc_id = v_id;
				GET DIAGNOSTICS v_count = row_count;
				INSERT INTO audit_check_data (fid, error_message) 
				VALUES (v_fid, concat('Arc (',v_id,') have been downgraded, new planned arc have been created (',v_arc,') and ',v_count,' connec(s) have been reconnected.'));

				UPDATE arc SET streetaxis_id = rec.streetaxis_id WHERE arc_id = v_arc;
				UPDATE arc SET streetaxis2_id = rec.streetaxis_id WHERE arc_id = v_arc;
			END IF;
		END LOOP;

		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('Using current (',v_currentpsector,') psector, ',i,' succesfully replacements have been executed'));
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('Arc catalog used for new arc(s): ',v_catalog));
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('Copied columns from old arc(s): Mapzones, *_type, soil, address and label values'));
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('NOT copied columns from old arc(s): Free text and addfield values'));
		v_message = 'Arc(s) replacement done succesfully';
		
	ELSE
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('Replacement on planned mode is only available for arcs'));
		v_message = 'Replacement on planned mode is only available for arcs';
	
	END IF;

	-- get info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data 
	WHERE cur_user="current_user"() AND fid=214 ORDER BY criticity desc, id asc) row;

	v_result_info := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');

	-- set return values
	v_level = 1;
	v_status = 'Accepted';

	--  Return
	RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
             ',"data":{ "info":'||v_result_info||''||
			'}}'||
	    '}')::json;

	--EXCEPTION WHEN OTHERS THEN
	--GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	--RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;