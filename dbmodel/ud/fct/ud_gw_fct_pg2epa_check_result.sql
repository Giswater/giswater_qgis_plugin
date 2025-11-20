/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:2858

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_check_result(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_result($${"data":{"parameters":{"resultId":"gw_check_project","fid":227, "dumpSubcatch":true}}}$$)-- when is called from go2epa_main from toolbox
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_result($${"data":{"parameters":{"resultId":"gw_check_project"}}}$$) -- when is called from toolbox

SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES"}, "data":{"resultId":"test1", "useNetworkGeom":"false", "dumpSubcatch":"true"}}$$)

SELECT * FROM SCHEMA_NAME.audit_check_data where fid::text  = 227::text

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid = 114 AND cur_user=current_user;
	DELETE FROM audit_check_data WHERE id < 0;
	DELETE FROM anl_node WHERE fid IN (159) AND cur_user=current_user;
	DELETE FROM anl_arc WHERE fid IN (103) AND cur_user=current_user;

-- fid: 369,370,396,401,402,455,456,457,458

*/

DECLARE

i integer = 0;
v_fid integer;
v_record record;
v_project_type text;
v_count	integer;
v_count_2 integer;
v_infiltration text;
v_min_node2arc float;
v_saveondatabase boolean;
v_result text;
v_version text;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_querytext text;
v_nodearc_real float;
v_nodearc_user float;
v_result_id text;
v_min numeric (12,4);
v_max numeric (12,4);
v_hydrologyscenario text;
v_qualitymode text;
v_qualmodeval text;
v_buildupmode int2;
v_buildmodeval text;
v_usenetworkgeom boolean;
v_usenetworkdemand boolean;
v_defaultdemand	float;
v_doublen2a integer;
v_curvedefault text;
v_options json;
v_error_context text;

v_dumpsubc boolean;
v_hydroscenarioval text;

v_checkresult boolean;

v_debug boolean;
v_debugval text;
v_advanced boolean;
v_advancedval text;
v_default boolean;
v_defaultval text;
v_dwfscenarioval text;
v_exportmodeval text;
v_networkmode integer;
v_setallraingages text;

object_rec record;

v_graphiclog boolean;
v_workspace text;
v_dscenarioused integer;
v_psectorused integer;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data
	v_result_id := ((p_data ->>'data')::json->>'parameters')::json->>'resultId'::text;
	v_fid := ((p_data ->>'data')::json->>'parameters')::json->>'fid';
	v_dumpsubc := ((p_data ->>'data')::json->>'parameters')::json->>'dumpSubcatch';

	-- get system values
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get user values
	v_checkresult = (SELECT value::json->>'checkResult' FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;
	v_graphiclog = (SELECT (value::json->>'graphicLog') FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;
	v_networkmode = (SELECT (value) FROM config_param_user WHERE parameter='inp_options_networkmode' AND cur_user=current_user)::integer;
	v_setallraingages = (SELECT (value) FROM config_param_user WHERE parameter='inp_options_setallraingages' AND cur_user=current_user);


	-- manage no found results
	IF (SELECT result_id FROM rpt_cat_result WHERE result_id=v_result_id) IS NULL THEN
		v_result  = (SELECT array_to_json(array_agg(row_to_json(row))) FROM (SELECT 1::integer as id, 'No result found whith this name....' as  message)row);
		v_result_info = concat ('{"values":',v_result, '}');
		RETURN ('{"status":"Accepted", "message":{"level":1, "text":"No result found"}, "version":"'||v_version||'"'||
			',"body":{"form":{}, "data":{"info":'||v_result_info||'}}}')::json;
	END IF;

	-- init variables
	v_count=0;
	IF v_fid is null THEN
		v_fid = 114;
	END IF;

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid = 114 AND cur_user=current_user;
	DELETE FROM audit_check_data WHERE id < 0;

	-- get user parameters
	v_hydroscenarioval = (SELECT name FROM config_param_user JOIN cat_hydrology c ON value = hydrology_id::text WHERE parameter = 'inp_options_hydrology_current' AND cur_user = current_user);
	v_dwfscenarioval = (SELECT idval FROM config_param_user JOIN cat_dwf c ON value = c.id::text WHERE parameter = 'inp_options_dwfscenario_current' AND cur_user = current_user);
	IF v_dwfscenarioval IS NULL THEN
		v_dwfscenarioval = 'No dwf scenario chosen';
	END IF;

	-- get settings values
	v_default = (SELECT value::json->>'status' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user=current_user);
	v_defaultval = (SELECT value::json->>'parameters' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user=current_user);

	v_advanced = (SELECT value::json->>'status' FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user);
	v_advancedval = (SELECT value::json->>'parameters' FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user);

	v_debug = (SELECT value::json->>'showLog' FROM config_param_user WHERE parameter = 'inp_options_debug' AND cur_user=current_user);
	v_debugval = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_debug' AND cur_user=current_user);

	v_exportmodeval = (SELECT idval FROM config_param_user, inp_typevalue WHERE id = value AND typevalue = 'inp_options_networkmode' and cur_user = current_user and parameter = 'inp_options_networkmode');
	SELECT name INTO v_workspace FROM config_param_user c JOIN cat_workspace ON value = id::text WHERE parameter = 'utils_workspace_current' AND c.cur_user=current_user;

	v_dscenarioused = (SELECT count(dscenario_id) FROM selector_inp_dscenario WHERE cur_user = current_user);
	v_psectorused = (SELECT count(psector_id) FROM selector_psector WHERE cur_user = current_user);

	-- Header
	INSERT INTO t_audit_check_data (id, fid, result_id, criticity, error_message) VALUES (-10, v_fid, v_result_id, 4,
	concat('CHECK RESULT WITH CURRENT USER-OPTIONS ACORDING EPA RULES'));
	INSERT INTO t_audit_check_data (id, fid, result_id, criticity, error_message)
	VALUES (-9, v_fid, v_result_id, 4, '--------------------------------------------------------------------------------------');

	INSERT INTO t_audit_check_data (id, fid, result_id, criticity, error_message) VALUES (-8, v_fid, v_result_id, 3, 'CRITICAL ERRORS');
	INSERT INTO t_audit_check_data (id, fid, result_id, criticity, error_message) VALUES (-7, v_fid, v_result_id, 3, '----------------------');

	INSERT INTO t_audit_check_data (id, fid, result_id, criticity, error_message) VALUES (-6, v_fid, v_result_id, 2, 'WARNINGS');
	INSERT INTO t_audit_check_data (id, fid, result_id, criticity, error_message) VALUES (-5, v_fid, v_result_id, 2, '--------------');

	INSERT INTO t_audit_check_data (id, fid, result_id, criticity, error_message) VALUES (-4, v_fid, v_result_id, 1, 'INFO');
	INSERT INTO t_audit_check_data (id, fid, result_id, criticity, error_message) VALUES (-3, v_fid, v_result_id, 1, '-------');

	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Result id: ', v_result_id));
	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Created by: ', current_user, ', on ', to_char(now(),'YYYY-MM-DD HH-MM-SS')));
	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Export mode: ',v_exportmodeval));
	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Hidrology scenario: ', v_hydroscenarioval));
	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('DWF scenario: ',v_dwfscenarioval));
	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Dump subcatchments: ',v_dumpsubc::text));
	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Active Workspace: ', v_workspace));
	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Number of dscenarios used: ', v_dscenarioused));
	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Number of psectors used: ', v_psectorused));

	UPDATE rpt_cat_result SET
	export_options = concat('{"Hydrology scenario": "', v_hydroscenarioval,'", "DWF scenario":"',v_dwfscenarioval,'"}')::json
	WHERE result_id = v_result_id;

	IF v_checkresult THEN

		IF v_default::boolean THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Default values: ', v_defaultval));
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Default values: No default values used'));
		END IF;

		IF v_advanced::boolean THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Advanced settings: ', v_advancedval));
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Advanced settings: No advanced settings used'));
		END IF;

		IF v_debug::boolean THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Debug: ', v_defaultval));
		END IF;

		IF v_setallraingages IS NOT NULL THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Enabled set all raingages with ONLY ONE timeseries: ', v_setallraingages));
		END IF;


		RAISE NOTICE '1- Check subcatchments';
		SELECT count(*) INTO v_count FROM ve_inp_subcatchment WHERE outlet_id is null;
		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-369: There is/are ',v_count,' subcatchment(s) with null values on mandatory column outlet_id column.'));
			v_count=0;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: Column oulet_id on subcatchment table have been checked without any values missed.'));
		END IF;

		-- check area
		SELECT (sum(st_area(the_geom)/10000))::integer, (sum(area))::integer  INTO v_count, v_count_2 FROM ve_inp_subcatchment WHERE area IS NOT NULL;
		IF v_count > v_count_2*2 AND v_count < v_count_2*10 OR (v_count_2 > v_count*2 AND v_count_2 < v_count*10) THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 2, concat('WARNING-369: Total area informed (',v_count_2,' ha.) has important difference from total shape area (',v_count,' ha.).'));
			v_count=0;
		ELSIF v_count > v_count_2*10 OR v_count_2 > v_count*10 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-369: Total area informed (',v_count_2,' ha.) has big difference from total shape area (',v_count,' ha.).'));
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: Total area informed (',v_count_2,' ha.) is similar than total shape area (',v_count,' ha.).'));
		END IF;

		SELECT count(*) INTO v_count FROM ve_inp_subcatchment where rg_id is null;
		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-369: There is/are ',v_count,' inp_subcatchment(s) with null values on mandatory column rg_id column.'));
			v_count=0;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: Column rg_id on scenario subcatchments have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM ve_inp_subcatchment where area is null;
		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-369: There is/are ',v_count,' subcatchment(s) with null values on mandatory column area column.'));
			v_count=0;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: Column area on scenario subcatchments have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM ve_inp_subcatchment where width is null;
		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-369: There is/are ',v_count,' subcatchment(s) with null values on mandatory column width column.'));
			v_count=0;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: Column width on scenario subcatchments have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM ve_inp_subcatchment where slope is null;
		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-369: There is/are ',v_count,' subcatchment(s) with null values on mandatory column slope column.'));
			v_count=0;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: Column slope on scenario subcatchments have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM ve_inp_subcatchment where clength is null;
		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-369: There is/are ',v_count,' subcatchment(s) with null values on mandatory column clength column.'));
			v_count=0;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: Column clength on scenario subcatchments have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM ve_inp_subcatchment where nimp is null;
		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-369: There is/are ',v_count,' subcatchment(s) with null values on mandatory column nimp column.'));
			v_count=0;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: Column nimp on scenario subcatchments have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM ve_inp_subcatchment where nperv is null;
		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-369: There is/are ',v_count,' subcatchment(s) with null values on mandatory column nperv column.'));
			v_count=0;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: Column nperv on scenario subcatchments have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM ve_inp_subcatchment where simp is null;
		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-369: There is/are ',v_count,' subcatchment(s) with null values on mandatory column simp column.'));
			v_count=0;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: Column simp on scenario subcatchments have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM ve_inp_subcatchment where sperv is null;
		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-369: There is/are ',v_count,' subcatchment(s) with null values on mandatory column sperv column.'));
			v_count=0;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: Column sperv on scenario subcatchments have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM ve_inp_subcatchment where zero is null;
		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-369: There is/are ',v_count,' subcatchment(s) with null values on mandatory column zero column.'));
			v_count=0;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: Column zero on scenario subcatchments have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM ve_inp_subcatchment where routeto is null;
		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-369: There is/are ',v_count,' subcatchment(s) with null values on mandatory column routeto column.'));
			v_count=0;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: Column routeto on scenario subcatchments have been checked without any values missed.'));
		END IF;


		SELECT count(*) INTO v_count FROM ve_inp_subcatchment where rted is null;
		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-369: There is/are ',v_count,' subcatchment(s) with null values on mandatory column rted column.'));
			v_count=0;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: Column rted on scenario subcatchments have been checked without any values missed.'));
		END IF;

		SELECT infiltration INTO v_infiltration FROM cat_hydrology JOIN config_param_user ON hydrology_id=value::integer WHERE cur_user=current_user AND parameter = 'inp_options_hydrology_current';

		IF v_infiltration='CURVE_NUMBER' THEN

			SELECT count(*) INTO v_count FROM ve_inp_subcatchment where (curveno is null)
			OR (conduct_2 is null) OR (drytime_2 is null);

			IF v_count > 0 THEN
				INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 3,
				concat('ERROR-369: There is/are ',v_count, ' subcatchment(s) with null values on mandatory columns of curve number infiltartion method (curveno, conduct_2, drytime_2).',
				'Acording EPA SWMM user''s manual, conduct_2 is deprecated, but is mandatory to fill it. Any value is valid because it will be ignored by SWMM.'));
				v_count=0;
			ELSE
				INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 1,
				concat('INFO: Mandatory columns for ''CURVE_NUMBER'' infitration method (curveno, drytime_2) have been checked without any values missed.'));
			END IF;

		ELSIF v_infiltration='GREEN_AMPT' THEN

			SELECT count(*) INTO v_count FROM ve_inp_subcatchment where (suction is null)
			OR (conduct_2 is null) OR (initdef is null);

			IF v_count > 0 THEN
				INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 3, concat('ERROR-369: There is/are ',
				v_count,' subcatchment(s) with null values on mandatory columns of Green-Apt infiltartion method (suction, conduct, initdef).'));
				v_count=0;
			ELSE
				INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 1,
				concat('INFO: Mandatory columns for ''GREEN_AMPT'' infitration method (suction, conduct, initdef) have been checked without any values missed.'));
			END IF;


		ELSIF v_infiltration='HORTON' OR v_infiltration='MODIFIED_HORTON' THEN

			SELECT count(*) INTO v_count FROM ve_inp_subcatchment where (maxrate is null)
			OR (minrate is null) OR (decay is null) OR (drytime is null) OR (maxinfil is null);

			IF v_count > 0 THEN
				INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 3, concat('ERROR-369: There is/are ',v_count,
				' subcatchment(s) with null values on mandatory columns of Horton/Horton modified infiltartion method (maxrate, minrate, decay, drytime, maxinfil).'));
				v_count=0;
			ELSE
				INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 1,
				concat('INFO: Mandatory columns for ''MODIFIED_HORTON'' infitration method (maxrate, minrate, decay, drytime, maxinfil) have been checked without any values missed.'));
			END IF;
		END IF;
	END IF;

	RAISE NOTICE '2 - Check if there are features with sector_id = 0';

	v_querytext = 'SELECT a.feature , count(*)  FROM  (
				SELECT arc_id, ''ARC'' as feature FROM ve_arc WHERE sector_id = 0 UNION
				SELECT node_id, ''NODE'' FROM ve_node WHERE sector_id = 0 )a GROUP BY feature ';

	EXECUTE 'SELECT count(*) FROM ('||v_querytext||')b'
	INTO v_count;

		IF v_count > 0 THEN
			EXECUTE 'SELECT count FROM ('||v_querytext||')b WHERE feature = ''ARC'';'
			INTO v_count;
			IF v_count > 0 THEN
				INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 3, concat('ERROR-370: There is/are ', v_count, ' arcs with sector_id = 0 that didn''t take part in the simulation'));
			END IF;

			EXECUTE 'SELECT count FROM ('||v_querytext||')b WHERE feature = ''NODE'';'
			INTO v_count;
			IF v_count > 0 THEN
				INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 3, concat('ERROR-370: There is/are ', v_count, ' nodes with sector_id = 0 that didn''t take part in the simulation'));
			END IF;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 1, concat('INFO: All features have sector_id different than 0.'));
			v_count=0;
		END IF;

	RAISE NOTICE '3 - Check if there are conflicts with dscenarios (396)';
	IF (SELECT count(*) FROM selector_inp_dscenario WHERE cur_user = current_user) > 0 THEN

		FOR object_rec IN SELECT
		json_array_elements_text('["junction", "conduit", "raingage", "frorifice", "frweir", "froutlet", "froutlet", "storage",  "outfall",  "treatment", "lids" ]'::json) as tabname,
		json_array_elements_text('["node_id" , "arc_id",  "rg_id",    "element_id",      "element_id",   "element_id",     "element_id",     "node_id",  "node_id",  "node_id",   "subc_id, lidco_id"]'::json) as colname,
 		json_array_elements_text('["anl_node" ,"anl_arc", "",        "anl_nodarc",     "anl_nodarc",  "anl_nodarc",    "anl_nodarc",    "anl_node", "anl_node", "anl_node",  "anl_polygon"]'::json) as tablename
		LOOP

			EXECUTE 'SELECT count(*) FROM (SELECT count(*) FROM ve_inp_dscenario_'||object_rec.tabname||' GROUP BY '||object_rec.colname||' HAVING count(*) > 1) a' INTO v_count;
			IF v_count > 0 THEN

				IF object_rec.tablename IN ('anl_arc', 'anl_node') THEN

					EXECUTE 'INSERT INTO '||object_rec.tablename||' ('||object_rec.colname||', fid, descript, the_geom) 
					SELECT '||object_rec.colname||', 396, concat(''Present on '',count(*),'' enabled dscenarios''), the_geom FROM ve_inp_dscenario_'||object_rec.tabname||
					' GROUP BY '||object_rec.colname||', the_geom  having count(*) > 1';

					INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 3, concat('ERROR-396 (',object_rec.tablename,'): There is/are ', v_count, ' ',
					object_rec.colname,'(s) for ',upper(object_rec.tabname),' used on more than one enabled dscenarios.'));

				ELSIF object_rec.tablename = 'anl_nodarc' THEN

					EXECUTE 'INSERT INTO anl_arc (arc_id, fid, descript, the_geom)
					SELECT '||object_rec.colname||', 396, concat(''Present on '',count(*),'' enabled dscenarios''), the_geom FROM ve_inp_dscenario_'||object_rec.tabname||
					' GROUP BY '||object_rec.colname||', the_geom  having count(*) > 1';

					INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 3, concat('ERROR-396 (anl_arc): There is/are ', v_count, ' ',
					object_rec.colname,'(s) for ',upper(object_rec.tabname),' used on more than one enabled dscenarios.'));

				ELSIF object_rec.tablename = 'anl_polygon' THEN

					EXECUTE 'INSERT INTO anl_polygon (pol_id, pol_type, fid, descript, the_geom)
					SELECT '||object_rec.colname||', 396, concat(''Present on '',count(*),'' enabled dscenarios''), the_geom FROM ve_inp_dscenario_'||object_rec.tabname||
					' GROUP BY '||object_rec.colname||', the_geom  having count(*) > 1';

					INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 3, concat('ERROR-396 (',object_rec.tablename,'): There is/are ', v_count, ' ',
					object_rec.colname,'(s) for ',upper(object_rec.tabname),' used on more than one enabled dscenarios.'));

				ELSE
					INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 3, concat('ERROR-396: There is/are ', v_count, ' ',
					object_rec.colname,'(s) for ',upper(object_rec.tabname),' used on more than one enabled dscenarios.'));
				END IF;
			ELSE
				INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 1, concat('INFO: There is not confict on enabled dscenarios for ',upper(object_rec.tabname),'.'));
			END IF;
		END LOOP;
	ELSE
		INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('INFO: There are not dscenarios selected.'));
	END IF;


	RAISE NOTICE '4 - Check if y0 is higger than ymax on nodes (401)';
	v_count = (SELECT count(*) FROM temp_t_node WHERE y0 > ymax);
	IF v_count > 0 THEN
		INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 3, concat('ERROR-401: There is/are ', v_count, ' nodes with y0 higger then ymax.'));
	ELSE
		INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('INFO: All nodes has y0 lower than ymax.'));
	END IF;


	RAISE NOTICE '5 - Check if node_id and arc_id defined on CONTROLS exists (402)';
	-- nodes
	FOR object_rec IN SELECT json_array_elements_text('["NODE"]'::json) as tabname
	LOOP
		v_querytext = '(SELECT a.id, a.node_id as controls, b.node_id as templayer FROM 
		(SELECT substring(split_part(text,'||quote_literal(object_rec.tabname)||', 2) FROM ''[^ ]+''::text) node_id, id, sector_id FROM inp_controls WHERE active is true)a
		LEFT JOIN temp_t_node b USING (node_id)
		WHERE b.node_id IS NULL AND a.node_id IS NOT NULL 
		AND a.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) AND a.sector_id IS NOT NULL
		OR a.sector_id::text != b.sector_id::text) a';

		EXECUTE concat ('SELECT count(*) FROM ',v_querytext) INTO v_count;
		IF v_count > 0 THEN
			i = i+1;
			EXECUTE concat ('SELECT array_agg(id) FROM ',v_querytext) INTO v_querytext;
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-402: There is/are ', v_count, ' CONTROLS with ',lower(object_rec.tabname),' not present on this result. Controls id''s:',v_querytext));
		END IF;
	END LOOP;

	IF v_count = 0 AND i = 0 THEN
		INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('INFO: All CONTROLS has correct node id values.'));
	END IF;

	-- links
	FOR object_rec IN SELECT json_array_elements_text('["LINK", "PUMP", "ORIFICE", "WEIR"]'::json) as tabname
	LOOP
		v_querytext = '(SELECT a.id, a.arc_id as controls, b.arc_id as templayer FROM 
		(SELECT substring(split_part(text,'||quote_literal(object_rec.tabname)||', 2) FROM ''[^ ]+''::text) arc_id, id, sector_id FROM inp_controls WHERE active is true)a
		LEFT JOIN temp_t_arc b USING (arc_id)
		WHERE b.arc_id IS NULL AND a.arc_id IS NOT NULL  
		AND a.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) AND a.sector_id IS NOT NULL
		OR a.sector_id::text != b.sector_id::text) a';

		EXECUTE concat ('SELECT count(*) FROM ',v_querytext) INTO v_count;
		IF v_count > 0 THEN
			i = i+1;
			EXECUTE concat ('SELECT array_agg(id) FROM ',v_querytext) INTO v_querytext;
			INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-402: There is/are ', v_count, ' CONTROLS with ',lower(object_rec.tabname),' not present on this result. Controls id''s:',v_querytext));
		END IF;
	END LOOP;

	IF v_count = 0 AND i = 0 THEN
		INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('INFO: All CONTROLS has correct arc id values.'));
	END IF;

	IF v_networkmode = 2 or v_networkmode = 3 THEN

		RAISE NOTICE '6 - Check arc_id null for gully (455)';
		SELECT count(*) INTO v_count FROM (SELECT * FROM ve_gully g,  selector_sector s
		WHERE g.sector_id = s.sector_id AND cur_user=current_user AND arc_id IS NULL) a1;

		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
			VALUES (v_fid, v_result_id, 3, '455',concat(
			'ERROR-455: There is/are ',v_count,' gullies with missed information on arc_id (outlet) values.'),v_count);
			v_count=0;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
			VALUES (v_fid, v_result_id , 1,  '455','INFO: No gullies found without arc_id (outlet) values.', v_count);
		END IF;

		RAISE NOTICE '7 - Check gullies with null values on (custom_)top_elev (456)';
		SELECT count(*) INTO v_count FROM (SELECT * FROM temp_t_gully WHERE top_elev IS NULL) a1;

		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
			VALUES (v_fid, v_result_id, 3, '456',concat(
			'ERROR-456: There is/are ',v_count,' gullies with null values on top_elev/custom_top_elev columns.'),v_count);
			v_count=0;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
			VALUES (v_fid, v_result_id , 1,  '456','INFO: No gullies found with null values on top_elev.', v_count);
		END IF;

		RAISE NOTICE '8 - Check gullies with null values on (custom)width (457)';
		SELECT count(*) INTO v_count FROM (SELECT * FROM temp_t_gully WHERE width IS NULL) a1;

		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
			VALUES (v_fid, v_result_id, 3, '457',concat(
			'ERROR-457: There is/are ',v_count,' gullies with null values on width/custom_width columns.'),v_count);
			v_count=0;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
			VALUES (v_fid, v_result_id , 1,  '457','INFO: No gullies found with null values on width.', v_count);
		END IF;

		RAISE NOTICE '9 - Check gullies with null values on (custom)length (458)';
		SELECT count(*) INTO v_count FROM (SELECT * FROM temp_t_gully WHERE length IS NULL) a1;

		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
			VALUES (v_fid, v_result_id, 3, '458',concat(
			'ERROR-458: There is/are ',v_count,' gullies with null values on length/custom_length columns.'),v_count);
			v_count=0;
		ELSE
			INSERT INTO t_audit_check_data (fid, result_id, criticity, table_id, error_message, fcount)
			VALUES (v_fid, v_result_id , 1,  '458','INFO: No gullies found with null values on length.', v_count);
		END IF;
	END IF;

	-- insert spacers for log
	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, '');
	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 3, '');
	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 2, '');
	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 1, '');

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT error_message as message FROM t_audit_check_data WHERE cur_user="current_user"() AND fid = v_fid
	order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	IF v_graphiclog THEN

		--points
		v_result = null;
		SELECT jsonb_build_object(
			'type', 'FeatureCollection',
			'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
		) INTO v_result
		FROM (
			SELECT jsonb_build_object(
				'type',       'Feature',
				'geometry',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
				'properties', to_jsonb(row) - 'the_geom'
			) AS feature FROM
			(SELECT node_id as id, 228 as fid, 'ERROR-228: Orphan node' as descript, ST_Transform(the_geom, 4326) as the_geom FROM t_anl_node WHERE cur_user="current_user"() AND fid IN (228,107)
			UNION
			SELECT node_id as id, 396 as fid, 'ERROR-396: Node used on more than one scenario' as descript, ST_Transform(the_geom, 4326) as the_geom FROM t_anl_node WHERE cur_user="current_user"() AND fid = 396)
		row) features;

		v_result := COALESCE(v_result, '{}');
		v_result_point = v_result::text;

		-- arcs
		v_result = null;
		SELECT jsonb_build_object(
			'type', 'FeatureCollection',
			'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
		) INTO v_result
		FROM (
			SELECT jsonb_build_object(
				'type',       'Feature',
				'geometry',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
				'properties', to_jsonb(row) - 'the_geom'
			) AS feature
			FROM  (SELECT arc_id as id, fid, 'ERROR: Disconnected arc'::text as descript, ST_Transform(the_geom, 4326) as the_geom FROM t_anl_arc WHERE cur_user="current_user"() AND fid = 139
					UNION
				SELECT arc_id as id, fid, 'ERROR-427: Flow regulator length do not fits with target arc', ST_Transform(the_geom, 4326) as the_geom FROM t_anl_arc WHERE cur_user="current_user"() AND fid = 427
					UNION
				SELECT arc_id as id, fid, 'ERROR-396: Arc used on more than one scenario', ST_Transform(the_geom, 4326) as the_geom FROM t_anl_arc WHERE cur_user="current_user"() AND fid = 396
			) row) features;

		v_result := COALESCE(v_result, '{}');
		v_result_line = v_result::text;

	END IF;

	-- control nulls
	v_options := COALESCE(v_options, '{}');
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_point := COALESCE(v_result_point, '{}');
	v_result_line := COALESCE(v_result_line, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
		',"body":{"form":{}'||
			',"data":{"options":'||v_options||','||
				'"info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||'}'||
			'}'||
		'}')::json, 2858, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;