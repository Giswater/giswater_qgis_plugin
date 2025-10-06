/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3008
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setarcreverse(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE

-- MODE 1: individual
SELECT gw_fct_setarcreverse($${"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{}, "feature":{"tableName":"ve_arc", "featureType":"ARC", "id":["331"]},
 "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"previousSelection", "parameters":{}}}$$);

-- MODE 2: massive usign pure SQL
SELECT gw_fct_setarcreverse(concat('{"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{}, "feature":{"tableName":"ve_arc", "featureType":"ARC", "id":["',arc_id,'"]},
 "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"previousSelection", "parameters":{}}}')::json) FROM anl_arc where fid = 250...

-- fid: 357
*/

DECLARE

arcrec Record;
v_count integer;
v_count_partial integer=0;
v_result text;
v_version text;
v_projecttype text;
v_saveondatabase boolean;

v_id json;
v_array text;
v_result_info json;
v_result_point json;
v_result_line json;
v_selectionmode text;
v_error_context text;
v_slopedirection boolean;

BEGIN

	SET search_path= 'SCHEMA_NAME','public';

	-- delete previous log results
	DELETE FROM anl_arc WHERE fid=357 AND cur_user=current_user;
	DELETE FROM audit_check_data WHERE fid=357 AND cur_user=current_user;

	-- select config values
	SELECT project_type, giswater  INTO v_projecttype, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_id  :=  ((p_data ->>'feature')::json->>'id')::json;
	v_selectionmode := (p_data ->>'data')::json->>'selectionMode';
	v_array :=  replace(replace(replace (v_id::text, ']', ')'),'"', ''''), '[', '(');

	-- get system values
	SELECT value INTO v_slopedirection FROM config_param_system WHERE parameter = 'edit_slope_direction';

	-- starting function
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3008", "fid":"357", "is_process":true, "is_header":"true"}}$$)';

	IF v_selectionmode = 'previousSelection' THEN

		IF v_array ='()' THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3562", "function":"3008", "fid":"357", "prefix_id":"1008", "is_process":true}}$$)';
		ELSE
			-- execute
			EXECUTE 'INSERT INTO anl_arc(fid, arc_id, the_geom, descript) 
			SELECT 357, arc_id, the_geom, ''Arc reversed before reverse'' FROM arc WHERE arc_id IN ' ||v_array || ' ORDER BY arc_id';

			-- set geometry
			EXECUTE 'UPDATE arc SET the_geom=st_reverse(the_geom) WHERE arc_id IN ' ||v_array;

			-- set inverted slope
			IF v_slopedirection THEN
				EXECUTE 'UPDATE arc SET inverted_slope = true WHERE sys_elev1 < sys_elev2 AND arc_id IN ' ||v_array;
				EXECUTE 'UPDATE arc SET inverted_slope = false WHERE sys_elev1 >= sys_elev2 AND arc_id IN ' ||v_array;
			END IF;

			SELECT count(*) INTO v_count FROM anl_arc WHERE fid=357 AND cur_user=current_user;
			--INSERT INTO audit_check_data (fid, error_message) VALUES (357, concat ('Direction of ',v_count,' arcs has been changed.'));
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3566", "function":"3008", "parameters":{"v_count":"'||v_count||'"}, "fid":"357", "is_process":true}}$$)';

			--INSERT INTO audit_check_data (fid, error_message) VALUES (357, concat ('Reversed arcs:',v_array));
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3568", "function":"3008", "parameters":{"v_array":"'||v_array||'"}, "fid":"357", "is_process":true}}$$)';
		END IF;
	ELSE
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3564", "function":"3008", "fid":"357", "is_process":true}}$$)';
	END IF;

	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT id, error_message AS message
	FROM audit_check_data WHERE cur_user="current_user"() AND ( fid=357)) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');


	-- control nulls
	v_result_info := COALESCE(v_result_info, '{}');

	-- return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"setVisibleLayers":[]'||
		       '}}'||
	'}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;