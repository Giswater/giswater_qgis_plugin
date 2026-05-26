/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3100

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_manage_hydrology_values(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_manage_hydrology_values($${"client":{}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"target":"2", "copyFrom":"1", "sector":"1", "action":"DELETE-COPY"}}}$$);
SELECT SCHEMA_NAME.gw_fct_manage_hydrology_values($${"client":{}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"target":"2", "copyFrom":"1", "sector":"1", "action":"KEEP-COPY"}}}$$);
SELECT SCHEMA_NAME.gw_fct_manage_hydrology_values($${"client":{}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"target":"2", "copyFrom":"1", "sector":"1", "action":"DELETE-ONLY"}}}$$);

-- fid: 398

*/

DECLARE

object_rec record;
v_version text;
v_result json;
v_result_info json;
v_copyfrom integer;
v_target integer;
v_error_context text;
v_count integer;
v_count2 integer;
v_projecttype text;
v_fid integer = 398;
v_source_name text;
v_target_name text;
v_action text;
v_querytext text;
v_sectors integer;
v_sector integer;
v_sector_name text;
v_sector_list text[];
rec text;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_copyfrom :=  ((p_data ->>'data')::json->>'parameters')::json->>'copyFrom';
	v_target :=  ((p_data ->>'data')::json->>'parameters')::json->>'target';
	v_sectors :=  ((p_data ->>'data')::json->>'parameters')::json->>'sector';
	v_action :=  ((p_data ->>'data')::json->>'parameters')::json->>'action';

	-- getting scenario name
	v_source_name := (SELECT name FROM cat_hydrology WHERE hydrology_id = v_copyfrom);
	v_target_name := (SELECT name FROM cat_hydrology WHERE hydrology_id = v_target);

	IF v_sectors = -999 THEN
		SELECT array_agg(sector_id) INTO v_sector_list FROM  sector JOIN selector_sector USING (sector_id) WHERE cur_user = current_user;
	ELSIF v_sectors = -998 THEN
		SELECT array_agg(sector_id) INTO v_sector_list from sector;
	ELSE
		SELECT array_agg(sector_id) INTO v_sector_list FROM  sector WHERE sector_id = v_sectors;
	END IF;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3100", "fid":"'||v_fid||'", "result_id":"-1", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3726", "function":"3100", "parameters":{"v_target_name":"'||v_target_name||'"}, "fid":"'||v_fid||'", "result_id":"-1", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3728", "function":"3100", "parameters":{"v_action":"'||v_action||'"}, "fid":"'||v_fid||'", "result_id":"-1", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4028", "function":"3100", "parameters":{"v_sector_name":"'||quote_nullable(v_sector_name)||'"}, "fid":"'||v_fid||'", "result_id":"-1", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3730", "function":"3100", "parameters":{"v_source_name":"'||v_source_name||'"}, "fid":"'||v_fid||'", "result_id":"-1", "criticity":"4", "is_process":true}}$$)';

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, -1, 4, concat(''));

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3100", "fid":"'||v_fid||'", "result_id":"-1", "criticity":"3", "is_process":true, "is_header":"true", "label_id":"3003", "separator_id":"2008"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3100", "fid":"'||v_fid||'", "result_id":"-1", "criticity":"2", "is_process":true, "is_header":"true", "label_id":"3002", "separator_id":"2009"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3100", "fid":"'||v_fid||'", "result_id":"-1", "criticity":"1", "is_process":true, "is_header":"true", "label_id":"3001", "separator_id":"2009"}}$$)';

	-- check controlmethod
	IF (SELECT infiltration FROM cat_hydrology WHERE hydrology_id = v_copyfrom) != (SELECT infiltration FROM cat_hydrology WHERE hydrology_id = v_target) THEN

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3754", "function":"3100", "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_sector)||'", "criticity":"3", "is_process":true}}$$)';

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4040", "function":"3100", "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_sector)||'", "criticity":"3", "prefix_id":"1003", "is_process":true}}$$)';

	ELSIF v_copyfrom = v_target AND v_action NOT IN ('INSERT-ONLY','DELETE-ONLY') THEN

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3754", "function":"3100", "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_sector)||'", "criticity":"3", "is_process":true}}$$)';

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3724", "function":"3100", "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_sector)||'", "criticity":"3", "prefix_id":"1003", "is_process":true}}$$)';
	ELSE
		IF v_action NOT IN ('INSERT-ONLY','DELETE-ONLY') THEN

			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4050", "function":"3100", "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_sector)||'", "criticity":"1", "prefix_id":"1001", "is_process":true}}$$)';
		END IF;

		--manage delete for copy action
		IF v_action IN ('DELETE ONLY', 'DELETE-COPY') THEN

			EXECUTE 'DELETE FROM inp_subcatchment WHERE hydrology_id = '||v_target;
			GET DIAGNOSTICS v_count = row_count;
			IF v_count > 0 THEN

				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4042", "function":"3100", "parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'", "result_id":"-1", "criticity":"2", "prefix_id":"1002", "is_process":true}}$$)';
			END IF;

			EXECUTE 'DELETE FROM inp_loadings WHERE hydrology_id = '||v_target;
			GET DIAGNOSTICS v_count = row_count;
			IF v_count > 0 THEN

				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4044", "function":"3100", "parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'", "result_id":"-1", "criticity":"2", "prefix_id":"1002", "is_process":true}}$$)';
			END IF;

			EXECUTE 'DELETE FROM inp_groundwater WHERE hydrology_id = '||v_target;
			GET DIAGNOSTICS v_count = row_count;
			IF v_count > 0 THEN

				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4046", "function":"3100", "parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'", "result_id":"-1", "criticity":"2", "prefix_id":"1002", "is_process":true}}$$)';
			END IF;

			EXECUTE 'DELETE FROM inp_coverage WHERE hydrology_id = '||v_target;
			GET DIAGNOSTICS v_count = row_count;
			IF v_count > 0 THEN

				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4048", "function":"3100", "parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'", "result_id":"-1", "criticity":"2", "prefix_id":"1002", "is_process":true}}$$)';
			END IF;
		END IF;

		FOREACH rec IN ARRAY(v_sector_list) LOOP

			v_sector = rec;
			v_sector_name := (SELECT name FROM sector WHERE sector_id = v_sector);

			FOR object_rec IN SELECT json_array_elements_text('["subcatchment", "loadings", "groundwater", "coverage"]'::json) as table,
			json_array_elements_text('["subc_id", "subc_id, poll_id", "subc_id", "subc_id, landus_id"]'::json) as pk,
			json_array_elements_text('[
			"subc_id, outlet_id, rg_id, area, imperv, width, slope, clength, snow_id, nimp, nperv, simp, sperv, zero, routeto, rted, maxrate, minrate, decay, drytime, maxinfil, suction, conduct, initdef, curveno, conduct_2, drytime_2, sector_id",
			"poll_id, subc_id, ibuildup",
			"subc_id,  aquif_id, node_id, surfel, a1, b1, a2, b2, a3, tw, h, fl_eq_lat, fl_eq_deep",
			"subc_id, landus_id, t.percent"]'::json) as column
			LOOP
				IF v_action = 'KEEP-COPY' OR  v_action = 'DELETE-COPY' THEN

					IF object_rec.table = 'subcatchment' THEN

						v_querytext = 'INSERT INTO inp_subcatchment ('||object_rec.column||', hydrology_id, the_geom, descript, nperv_pattern_id, dstore_pattern_id,
						infil_pattern_id, minelev, muni_id) SELECT '||object_rec.column||', '||v_target||',the_geom, descript, nperv_pattern_id, dstore_pattern_id,
						infil_pattern_id, minelev, muni_id FROM inp_subcatchment WHERE hydrology_id = '||v_copyfrom||' AND sector_id = '||v_sector||
						' ON CONFLICT (hydrology_id, subc_id) DO NOTHING';
						EXECUTE v_querytext;
					ELSE
						v_querytext = 'INSERT INTO inp_'||object_rec.table||' SELECT '||object_rec.column||', '||v_target||' FROM inp_'||object_rec.table||' t JOIN inp_subcatchment USING (subc_id, hydrology_id)
						WHERE hydrology_id = '||v_copyfrom||' AND sector_id = '||v_sector||
						' ON CONFLICT (hydrology_id, '||object_rec.pk||') DO NOTHING';

						EXECUTE v_querytext;
					END IF;

					-- get message
					GET DIAGNOSTICS v_count2 = row_count;
					IF v_count > 0 AND v_count2 = 0 THEN

						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4052", "function":"3100", "parameters":{"v_sector":"'||v_sector||'", "object_rec":"'||object_rec.table||'"}, "fid":"'||v_fid||'", "result_id":"'||v_sector||'", "criticity":"1", "prefix_id":"1001", "is_process":true}}$$)';

					ELSIF v_count2 > 0 THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4054", "function":"3100", "parameters":{"v_count2":"'||v_count2||'", "v_sector":"'||v_sector||'", "object_rec":"'||object_rec.table||'"}, "fid":"'||v_fid||'", "result_id":"'||v_sector||'", "criticity":"1", "prefix_id":"1001", "is_process":true}}$$)';

					END IF;
				END IF;
			END LOOP;

			-- set selector
			UPDATE config_param_user SET value = v_target WHERE parameter = 'inp_options_hydrology_current' AND cur_user = current_user;
		END LOOP;
	END IF;

	-- insert spacers
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, concat(''));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, concat(''));

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"'||v_version||'"'||
	             ',"body":{"form":{}'||
			     ',"data":{ "info":'||v_result_info||
				'}}'||
		    '}')::json, 3100, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
