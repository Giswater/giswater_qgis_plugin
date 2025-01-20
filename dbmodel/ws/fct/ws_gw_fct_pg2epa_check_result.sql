/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2848

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_check_result(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_result($${"data":{"parameters":{"resultId":"test1","fid":227}}}$$) --when is called from go2epa_main from toolbox
*/

DECLARE

v_rec record;
v_project_type text;
v_querytext text;
v_verified_exceptions boolean = true;
v_fid integer;
v_isembebed boolean;
v_return json;


object_rec record;
v_count integer;
i integer;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select config values
	SELECT project_type INTO v_project_type FROM sys_version order by id desc limit 1;

	-- getting input parameters
	v_fid :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'fid';

	-- getting sys_fprocess to be executed
	v_querytext = 'select * from sys_fprocess where project_type in (lower('||quote_literal(v_project_type)||'), ''utils'') 
	and addparam is null and query_text is not null and function_name ilike ''%pg2epa_check_network%'' and active order by fid asc';

	-- loop for checks
	for v_rec in execute v_querytext		
	loop
		EXECUTE 'select gw_fct_check_fprocess($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
	    "form":{},"feature":{},"data":{"parameters":{"functionFid":'||v_fid||', "checkFid":"'||v_rec.fid||'"}}}$$)';
	end loop;



-------------------- to be replaced

	RAISE NOTICE 'Check if there are conflicts with dscenarios (396)';
	IF (SELECT count(*) FROM selector_inp_dscenario WHERE cur_user = current_user) > 0 THEN

		FOR object_rec IN SELECT json_array_elements_text('["tank", "reservoir", "pipe", "pump", "valve", "virtualvalve", "connec", "inlet", "junction"]'::json) as tabname,
					 json_array_elements_text('["node", "node" , "arc" , "node" , "node", "arc", "connec", "node", "node"]'::json) as colname
		LOOP

			EXECUTE 'SELECT count(*) FROM (SELECT count(*) FROM v_edit_inp_dscenario_'||object_rec.tabname||' GROUP BY '||object_rec.colname||'_id HAVING count(*) > 1) a' INTO v_count;
			IF v_count > 0 THEN

				IF object_rec.colname IN ('arc', 'node') THEN

					EXECUTE 'INSERT INTO t_'||object_rec.colname||' ('||object_rec.colname||'_id, fid, descript, the_geom) 
					SELECT '||object_rec.colname||'_id, 396, concat(''Present on '',count(*),'' enabled dscenarios''), v_edit_inp_dscenario_'||object_rec.tabname||'.the_geom 
					FROM v_edit_inp_dscenario_'||object_rec.tabname||' JOIN '||	object_rec.colname||' USING ('||object_rec.colname||'_id) GROUP 
					BY '||object_rec.colname||'_id, v_edit_inp_dscenario_'||object_rec.tabname||'.the_geom having count(arc_id) > 1';


					INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 3, concat('ERROR-396 (anl_',object_rec.colname,'): There is/are ', v_count, ' ',
					object_rec.colname,'(s) for ',upper(object_rec.tabname),' used on more than one enabled dscenarios.'));
				ELSE
					INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 3, concat('ERROR-396: There is/are ', v_count, ' ',
					object_rec.colname,'(s) for ',upper(object_rec.tabname),' used on more than one enabled dscenarios.'));
				END IF;
			END IF;
		END LOOP;
	ELSE
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('INFO: There are not dscenarios selected.'));
	END IF;

	-- RULES nodes
	FOR object_rec IN SELECT json_array_elements_text('["NODE", "JUNCTION", "RESERVOIR", "TANK"]'::json) as tabname
	LOOP
		v_querytext = '(SELECT a.id, a.node_id as controls, b.node_id as templayer FROM 
		(SELECT substring(split_part(text,'||quote_literal(object_rec.tabname)||', 2) FROM ''[^ ]+''::text) node_id, id, sector_id FROM inp_rules WHERE active is true)a
		LEFT JOIN temp_t_node b USING (node_id)
		WHERE b.node_id IS NULL AND a.node_id IS NOT NULL 
		AND a.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) AND a.sector_id IS NOT NULL
		OR a.sector_id::text != b.sector_id::text) a';

		EXECUTE concat ('SELECT count(*) FROM ',v_querytext) INTO v_count;
		IF v_count > 0 THEN
			i = i+1;
			EXECUTE concat ('SELECT array_agg(id) FROM ',v_querytext) INTO v_querytext;
			INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-402: There is/are ', v_count, ' RULES with ',lower(object_rec.tabname),' not present on this result. Rule id''s:',v_querytext));
		END IF;
	END LOOP;

	IF v_count = 0 AND i = 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('INFO: All RULES has correct node id values.'));
	END IF;

	-- RULES arcs
	i = 0;
	FOR object_rec IN SELECT json_array_elements_text('["LINK", "PIPE", "PUMP", "VALVE"]'::json) as tabname
	LOOP
		v_querytext = '(SELECT a.id, a.arc_id as controls, b.arc_id as templayer FROM 
		(SELECT substring(split_part(text,'||quote_literal(object_rec.tabname)||', 2) FROM ''[^ ]+''::text) arc_id, id, sector_id FROM inp_rules WHERE active is true)a
		LEFT JOIN temp_t_arc b USING (arc_id)
		WHERE b.arc_id IS NULL AND a.arc_id IS NOT NULL 
		AND a.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) AND a.sector_id IS NOT NULL
		OR a.sector_id::text != b.sector_id::text) a';

		EXECUTE concat ('SELECT count(*) FROM ',v_querytext) INTO v_count;
		IF v_count > 0 THEN
			i = i+1;
			EXECUTE concat ('SELECT array_agg(id) FROM ',v_querytext) INTO v_querytext;
			INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR-402: There is/are ', v_count, ' RULES with ',lower(object_rec.tabname),' not present on this result. Rule id''s:',v_querytext));
		END IF;
	END LOOP;

	IF v_count = 0 AND i = 0 THEN
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('INFO: All RULES has correct link id values.'));
	END IF;

	------- to be replaced

	--  Return
	RETURN '{"status":"ok"}';

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;