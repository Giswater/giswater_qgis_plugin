/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3118

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_create_dscenario_from_toc(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE

-- fid: 403
SELECT SCHEMA_NAME.gw_fct_create_dscenario_from_toc($${"client":{"device":4, "lang":"ca_ES", "infoType":1, "epsg":SRID_VALUE}, "form":{},
"feature":{"tableName":"ve_arc", "featureType":"ARC", "id":[]},
"data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"name":"test", "type":"CONDUIT"}}}$$);

SELECT SCHEMA_NAME.gw_fct_create_dscenario_from_toc($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":SRID_VALUE}, "form":{},
"feature":{"tableName":"ve_inp_storage", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
"selectionMode":"wholeSelection","parameters":{"name":"storage", "type":"STORAGE", "exploitation":"1", "descript":"test"}, "aux_params":null}}$$);

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
v_fid integer = 403;
v_action text;
v_querytext text;
v_result_id text = null;
v_name text;
v_type text;
v_descript text;
v_id text;
v_selectionmode text;
v_scenarioid integer;
v_sourcetable text;
v_featuretype text;
v_targettable text;
v_columns text;
v_finish boolean = false;
v_expl integer;
v_where text;
_key   text;
_value text;
v_lidco text;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get user parameters
	v_lidco :=  (SELECT value FROM config_param_user WHERE parameter = 'epa_lidco_vdefault' AND cur_user = current_user);

	-- get input parameters
	v_name :=  ((p_data ->>'data')::json->>'parameters')::json->>'name';
	v_descript :=  ((p_data ->>'data')::json->>'parameters')::json->>'descript';
	v_type :=  ((p_data ->>'data')::json->>'parameters')::json->>'type';
	v_expl :=  ((p_data ->>'data')::json->>'parameters')::json->>'exploitation';

	v_id :=  ((p_data ->>'feature')::json->>'id');
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_sourcetable :=  ((p_data ->>'feature')::json->>'tableName')::text;
	v_featuretype :=  ((p_data ->>'feature')::json->>'featureType')::text;
	v_targettable = replace(v_sourcetable,'ve_inp','inp_dscenario'); -- for all in exception of ve_raingage
	v_targettable = replace(v_targettable,'v_edit','inp_dscenario'); -- for ve_raingage

	IF v_selectionmode = 'wholeSelection' THEN v_id= replace(replace(replace(v_id::text,'[','('),']',')'),'"','');END IF;

	-- subcatchment <-> lids
	IF v_targettable = 'inp_dscenario_subcatchment' THEN v_targettable  = 'inp_dscenario_lids';END IF;

	IF v_id IS NULL THEN v_id = '()';END IF;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	-- create log

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3118", "fid":"'||v_fid||'", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3118", "fid":"'||v_fid||'", "criticity":"3", "is_process":true, "is_header":"true", "label_id":"1004", "separator_id":"2008"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3118", "fid":"'||v_fid||'", "criticity":"2", "is_process":true, "is_header":"true", "label_id":"3002", "separator_id":"2009"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3118", "fid":"'||v_fid||'", "criticity":"1", "is_process":true, "is_header":"true", "label_id":"3001", "separator_id":"2009"}}$$)';

	-- inserting on catalog table
	PERFORM setval('SCHEMA_NAME.cat_dscenario_dscenario_id_seq'::regclass,(SELECT max(dscenario_id) FROM cat_dscenario) ,true);

	INSERT INTO cat_dscenario ( name, descript, dscenario_type, expl_id, log)
	VALUES ( v_name, v_descript, v_type, v_expl, concat('Insert by ',current_user,' on ', substring(now()::text,0,20))) ON CONFLICT (name) DO NOTHING
	RETURNING dscenario_id INTO v_scenarioid;

	IF v_scenarioid IS NULL THEN
		SELECT dscenario_id INTO v_scenarioid FROM cat_dscenario where name = v_name;

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3696", "function":"3118", "parameters":{"v_name":"'||v_name||'", "v_scenarioid":"'||v_scenarioid||'"}, "fid":"'||v_fid||'", "criticity":"3", "is_process":true}}$$)';
	ELSE
		-- getting columns
		IF v_targettable = 'inp_dscenario_conduit' THEN
			v_columns = v_scenarioid||', arc_id, arccat_id, matcat_id, custom_n, barrels, culvert, kentry, kexit,kavg, flap, q0, qmax, seepage';

		ELSIF v_targettable = 'inp_dscenario_divider' THEN
			v_columns = v_scenarioid||', node_id, elev, ymax, divider_type, arc_id, curve_id, qmin, ht, cd, y0, ysur, apond';

		ELSIF v_targettable = 'inp_dscenario_frorifice' THEN
			v_columns = v_scenarioid||', node_id, order_id, to_arc, flwreg_length,  ori_type, offsetval, cd, orate, flap, shape,
			geom1, geom2, geom3, geom4';

	 	ELSIF v_targettable = 'inp_dscenario_froutlet' THEN
			v_columns = v_scenarioid||', node_id, order_id, to_arc, flwreg_length, outlet_type, offsetval, curve_id, cd1, cd2';

	 	ELSIF v_targettable = 'inp_dscenario_frpump' THEN
			v_columns = v_scenarioid||', node_id, order_id, to_arc, flwreg_length, curve_id, status, startup, shutoff';

	 	ELSIF v_targettable = 'inp_dscenario_frweir' THEN
			v_columns = v_scenarioid||', node_id, order_id, to_arc, flwreg_length, weir_type, offsetval, cd, ec, 
			cd2, flap, geom1, geom2, geom3, geom4, surcharge, road_width, road_surf, coef_curve';

		ELSIF v_targettable = 'inp_dscenario_inflows' THEN
			v_columns = v_scenarioid||', node_id, order_id, timser_id, format_type, mfactor, sfactor, base, pattern_id';

	 	ELSIF v_targettable = 'inp_dscenario_inflows_poll' THEN
			v_columns = v_scenarioid||', poll_id,  node_id, timser_id, form_type, mfactor, factor, base, pattern_id';

	 	ELSIF v_targettable = 'inp_dscenario_junction' THEN
			v_columns = v_scenarioid||', node_id, y0, ysur, apond, outfallparam::json';

		ELSIF v_targettable = 'inp_dscenario_lids' THEN
			v_columns = v_scenarioid||', subc_id, null, null, area, width, null, null, null, null, descript';

 		ELSIF v_targettable = 'inp_dscenario_outfall' THEN
			v_columns = v_scenarioid||', node_id, outfall_type, stage, curve_id, timser_id, gate';

		ELSIF v_targettable = 'inp_dscenario_raingage' THEN
			v_columns = v_scenarioid||', rg_id, form_type, intvl, scf, rgage_type, timser_id, fname, sta, units';

		ELSIF v_targettable = 'inp_dscenario_storage' THEN
			v_columns = v_scenarioid||', node_id, elev, ymax, storage_type, curve_id, a1, a2, a0, fevap, sh, hc, imd, y0, ysur';

	 	ELSIF v_targettable = 'inp_dscenario_treatment' THEN
			v_columns = v_scenarioid||', node_id, poll_id, function';

		ELSE
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3698", "function":"3118", "fid":"'||v_fid||'", "criticity":"3", "is_process":true, "prefix_id":"1003"}}$$)';
			v_finish = true;

			DELETE FROM cat_dscenario WHERE dscenario_id = v_scenarioid;
		END IF;

		IF v_finish IS NOT TRUE THEN

			-- log
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3700", "function":"3118", "fid":"'||v_fid||'", "criticity":"1", "is_process":true}}$$)';

			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3702", "function":"3118", "parameters":{"v_name":"'||v_name||'", "v_scenarioid":"'||v_scenarioid||'", "v_type":"'||v_type||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '');

			-- inserting values on tables
			v_count = 0;
			IF v_selectionmode = 'wholeSelection' THEN
				v_querytext = 'INSERT INTO '||quote_ident(v_targettable)||' SELECT '||v_columns||' FROM '||quote_ident(v_sourcetable);
				EXECUTE v_querytext;
				GET DIAGNOSTICS v_count = row_count;
			ELSIF  v_selectionmode = 'previousSelection' AND v_id NOT IN ('', '()', '[]') THEN
				v_where = ' WHERE ';
				-- Layer has multiple pks so v_id is json
				IF to_tsvector(v_id) @@ to_tsquery('{ & }') THEN
					FOR _key, _value IN
					SELECT * FROM jsonb_each(v_id)
					LOOP
						_value = replace(replace(replace(_value, '"', ''''), '[', ''), ']', '');
						v_where = concat(v_where, _key, ' IN (', _value, ') AND ');
					END LOOP;
					v_where = substr(v_where, 1, length(v_where) - 5);
				-- Layer has one pk so v_id is normal list
				ELSE
					v_id = replace(replace(replace(v_id,'[','('),']',')'),'"','');
					v_where = concat(v_where, lower(v_featuretype), '_id::integer IN ', v_id);
				END IF;
				v_querytext = 'INSERT INTO '||quote_ident(v_targettable)||' SELECT '||v_columns||' FROM '||quote_ident(v_sourcetable)|| v_where;
				EXECUTE v_querytext;
				GET DIAGNOSTICS v_count = row_count;
			END IF;
			
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3704", "function":"3118", "parameters":{"v_count":"'||v_count||'", "v_targettable":"'||v_targettable||'"}, "fid":"'||v_fid||'", "criticity":"1", "is_process":true}}$$)';

			-- set selector
			DELETE FROM selector_inp_dscenario WHERE cur_user = current_user;
			INSERT INTO selector_inp_dscenario (dscenario_id,cur_user) VALUES (v_scenarioid, current_user) ON CONFLICT (dscenario_id,cur_user) DO NOTHING ;
		END IF;
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

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}');

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 3042, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;