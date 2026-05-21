/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3396

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_create_full_network_dscenario(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE

-- fid: 403
SELECT SCHEMA_NAME.gw_fct_create_full_network_dscenario($${"client":{}, "form":{}, "data":{"parameters":{"name":"test222", "descript":"test"}}}$$);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3396, 'gw_fct_create_full_network_dscenario', 'ws', 'function', 'json', 'json',
'Function to create full network dscenario. With this function it is possible to create a full network scenario by copying all the network features from EPA world.',
'role_epa', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device)
VALUES(3396, 'Create full Network dscenario', '{"featureType":[]}'::json, '[
{"widgetname":"name", "label":"Name:","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name of the new dscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"descript", "label":"descript:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"descript of new scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"dwf scenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM ve_exploitation", "layoutname":"grl_option_parameters","layoutorder":3, "value":null}
]'::json, NULL, true, '{4}')
ON CONFLICT (id) DO  NOTHING;

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
v_result_id text = null;
v_name text;
v_type text;
v_descript text;
v_id text;
v_selectionmode text;
v_scenarioid integer;
v_finish boolean = false;
v_expl integer;
v_where text;
_key   text;
_value text;
v_affectrow integer;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;


	v_name :=  ((p_data ->>'data')::json->>'parameters')::json->>'name';
	v_descript :=  ((p_data ->>'data')::json->>'parameters')::json->>'descript';
	v_expl :=  ((p_data ->>'data')::json->>'parameters')::json->>'exploitation';

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	-- create log
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('CREATE FULL NETWORK DSCENARIO'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '-------------------------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, 'ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, '--------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, '---------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, '---------');

	-- inserting on catalog table
	PERFORM setval('SCHEMA_NAME.cat_dscenario_dscenario_id_seq'::regclass,(SELECT max(dscenario_id) FROM cat_dscenario) ,true);

	INSERT INTO cat_dscenario ( name, descript, dscenario_type, expl_id, log)
	VALUES ( v_name, v_descript, 'NETWORK', v_expl, concat('Insert by ',current_user,' on ', substring(now()::text,0,20))) ON CONFLICT (name) DO NOTHING
	RETURNING dscenario_id INTO v_scenarioid;

	IF v_scenarioid IS NULL THEN
		SELECT dscenario_id INTO v_scenarioid FROM cat_dscenario where name = v_name;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, null, 3, concat('ERROR: The dscenario ( ',v_scenarioid,' ) already exists with proposed name ',v_name ,'. Please try another one.'));

	ELSE

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, 'Full Network scenario created succesfully');

		INSERT INTO inp_dscenario_junction SELECT  v_scenarioid, node_id,demand, pattern_id, peak_factor, emitter_coeff, init_quality, source_type,
		source_quality, source_pattern_id FROM ve_inp_junction;
		GET DIAGNOSTICS v_affectrow = row_count;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, concat(v_affectrow, ' Junction(s)'));

		INSERT INTO inp_dscenario_pipe SELECT v_scenarioid, arc_id, minorloss, status, null, null, bulk_coeff, wall_coeff
		FROM ve_inp_pipe;
		GET DIAGNOSTICS v_affectrow = row_count;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, concat(v_affectrow, ' Pipe(s)'));

		INSERT INTO inp_dscenario_shortpipe SELECT v_scenarioid, node_id, minorloss, status, null, null, bulk_coeff, wall_coeff FROM ve_inp_shortpipe;
		GET DIAGNOSTICS v_affectrow = row_count;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, concat(v_affectrow, ' Shortpipe(s)'));

		INSERT INTO inp_dscenario_tank SELECT v_scenarioid, node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, overflow,
		mixing_model, mixing_fraction, reaction_coeff, init_quality, source_type, source_quality, source_pattern_id FROM ve_inp_tank;
		GET DIAGNOSTICS v_affectrow = row_count;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, concat(v_affectrow, ' Tank(s)'));

		INSERT INTO inp_dscenario_inlet SELECT v_scenarioid, node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, head, pattern_id, overflow,
		mixing_model, mixing_fraction, reaction_coeff, init_quality, source_type, source_quality, source_pattern_id FROM ve_inp_inlet;
		GET DIAGNOSTICS v_affectrow = row_count;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, concat(v_affectrow, ' Inlet(s)'));

		INSERT INTO inp_dscenario_reservoir SELECT v_scenarioid, node_id, pattern_id, head, init_quality, source_type, source_quality, source_pattern_id
		FROM ve_inp_reservoir;
		GET DIAGNOSTICS v_affectrow = row_count;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, concat(v_affectrow, ' Reservoir(s)'));

		INSERT INTO inp_dscenario_valve SELECT v_scenarioid, node_id, valve_type, pressure, flow, coef_loss, curve_id, minorloss, status, add_settings, init_quality
		FROM ve_inp_valve;
		GET DIAGNOSTICS v_affectrow = row_count;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, concat(v_affectrow, ' Valve(s)'));

		INSERT INTO inp_dscenario_pump SELECT v_scenarioid, node_id, power, curve_id, speed, pattern_id, status, effic_curve_id, energy_price, energy_pattern_id
		FROM ve_inp_pump;
		GET DIAGNOSTICS v_affectrow = row_count;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, concat(v_affectrow, ' Pump(s)'));

		INSERT INTO inp_dscenario_virtualvalve SELECT v_scenarioid, arc_id, valve_type, pressure, diameter, flow, coef_loss, curve_id, minorloss, status, init_quality
		FROM ve_inp_virtualvalve;
		GET DIAGNOSTICS v_affectrow = row_count;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, concat(v_affectrow, ' Virtualvalve(s)'));

		INSERT INTO inp_dscenario_virtualpump SELECT v_scenarioid, arc_id, power, curve_id, speed, pattern_id, status, null, effic_curve_id, energy_price, energy_pattern_id,
		pump_type FROM ve_inp_virtualpump;
		GET DIAGNOSTICS v_affectrow = row_count;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, concat(v_affectrow, ' Virtualpumps(s)'));

		INSERT INTO inp_dscenario_connec SELECT v_scenarioid, connec_id, demand, pattern_id, peak_factor, status, minorloss, custom_roughness, custom_length,
		custom_dint, emitter_coeff, init_quality, source_type, source_quality, source_pattern_id FROM ve_inp_connec;
		GET DIAGNOSTICS v_affectrow = row_count;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, concat(v_affectrow, ' Connec(s)'));

	END IF;

	-- insert spacers
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat(''));
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
	    '}')::json, 3308, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;