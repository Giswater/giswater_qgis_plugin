/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3072

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_setfeaturereplaceplan(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setfeaturereplaceplan(p_data json)
RETURNS json AS
$BODY$

/*

SELECT SCHEMA_NAME.gw_fct_setfeaturereplaceplan($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"featureType":"ARC", "ids":["2100","2101","2102"]}, "data":{"catalog":"PVC110-PN16"}}$$);
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
v_project_type text;
v_arc_type text;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- input values
	v_feature = (p_data->>'feature')::json->>'featureType';
	v_feature_text = (p_data->>'feature')::json->>'ids';
	v_catalog = (p_data->>'data')::json->>'catalog';

	-- select config values
	SELECT giswater, upper(project_type) INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

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
					rec.state_type = (SELECT id FROM value_state_type WHERE state = 2 LIMIT 1);
				END IF;
				IF v_project_type ='WS' THEN
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

				ELSIF v_project_type ='UD' THEN

					SELECT arc_type INTO v_arc_type FROM cat_arc WHERE id=v_catalog;

					IF v_arc_type IS NULL THEN
						v_arc_type=rec.arc_type;
					END IF;

					 INSERT INTO v_edit_arc
					(arccat_id, arc_type, epa_type, expl_id, sector_id, state, state_type,  dma_id, soilcat_id,
					function_type, category_type, fluid_type, location_type, workcat_id_plan, ownercat_id, the_geom,
					muni_id, postcode, district_id, postnumber, postcomplement, postnumber2, postcomplement2,
					label_x,label_y,label_rotation, inventory, y1, y2, custom_y1, custom_y2, elev1, elev2, custom_elev1, custom_elev2,
					matcat_id, inverted_slope)
					VALUES
					(v_catalog, v_arc_type, rec.epa_type, rec.expl_id, rec.sector_id, 2, rec.state_type, rec.dma_id, rec.soilcat_id,
					rec.function_type, rec.category_type, rec.fluid_type, rec.location_type, rec.workcat_id_plan, rec.ownercat_id, rec.the_geom,
					rec.muni_id, rec.postcode, rec.district_id, rec.postnumber, rec.postcomplement, rec.postnumber2, rec.postcomplement2,
					rec.label_x, rec.label_y, rec.label_rotation, false, rec.y1, rec.y2, rec.custom_y1, rec.custom_y2,
					rec.elev1, rec.elev2, rec.custom_elev1, rec.custom_elev2, rec.matcat_id, rec.inverted_slope)
					RETURNING arc_id INTO v_arc;
				END IF;
	
				INSERT INTO plan_psector_x_connec (psector_id, connec_id, arc_id, state, doable)
				SELECT v_currentpsector, connec_id, v_arc, 1,false FROM connec WHERE arc_id = v_id AND state=1
				ON CONFLICT (connec_id, psector_id) DO NOTHING;

				SELECT count(*) INTO v_count FROM connec WHERE arc_id = v_id AND state=1;

				INSERT INTO audit_check_data (fid, error_message) 
				VALUES (v_fid, concat('Arc (',v_id,') have been downgraded, new planned arc have been created (',v_arc,')'));
				INSERT INTO audit_check_data (fid, error_message) 
				VALUES (v_fid, concat(v_count,' connec(s) have been reconnected.'));

				IF v_project_type ='UD' THEN
					INSERT INTO plan_psector_x_gully (psector_id, gully_id, arc_id, state, doable)
					SELECT v_currentpsector, gully_id, v_arc, 1,false FROM gully WHERE arc_id = v_id AND state=1
					ON CONFLICT (gully_id, psector_id) DO NOTHING;

					SELECT count(*) INTO v_count FROM gully WHERE arc_id = v_id AND state=1;

					INSERT INTO audit_check_data (fid, error_message) 
					VALUES (v_fid, concat(v_count,' gully(s) have been reconnected.')); 
				END IF;

				UPDATE arc SET streetaxis_id = rec.streetaxis_id WHERE arc_id = v_arc;
				UPDATE arc SET streetaxis2_id = rec.streetaxis_id WHERE arc_id = v_arc;
				
			END IF;
		END LOOP;

		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('Using current (',v_currentpsector,') psector, ',i,' succesfully replacements have been executed'));
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('Arc catalog used for new arc(s): ',v_catalog));
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('Copied columns from old arc(s): Mapzones, *_type, soil, address and label values'));
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('NOT copied columns from old arc(s): Free text and addfield values'));
		v_message = 'Arc replacement done succesfully';
		
	ELSE
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('Replacement on planned mode is only available for arcs'));
		v_message = 'Replacement on planned mode is only available for arcs';
	
	END IF;

	-- get info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data 
	WHERE cur_user="current_user"() AND fid=143 ORDER BY criticity desc, id asc) row;

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

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
