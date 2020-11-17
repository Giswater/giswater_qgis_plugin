/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3012

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_mincut_connec(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_connec(p_data json)
RETURNS json AS
$BODY$

/*

SELECT gw_fct_setmincut('{"data":{"mincutClass":3, "mincutId":"3"}}');

fid = 216

*/

DECLARE

v_id integer;
v_mincut integer;
v_numconnecs integer;
v_numhydrometer integer;
v_priority json;
v_mincutdetails json;
v_mincut_class integer;
v_version text;
v_error_context text;
v_expl integer;
v_macroexpl integer;
v_mincutrec record;
v_result json;
v_result_info json;


BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;
	
	SELECT giswater INTO v_version FROM sys_version order by id desc limit 1;

	-- delete previous
	DELETE FROM audit_check_data WHERE fid = 216 and cur_user=current_user;

	-- get input parameters
	v_mincut := ((p_data ->>'data')::json->>'mincutId')::integer;	
	v_mincut_class := ((p_data ->>'data')::json->>'mincutClass')::integer;	
	
	-- get connecs when mincut class = 3
	IF v_mincut_class=3 THEN
		INSERT INTO om_mincut_connec (result_id, connec_id) 
		SELECT DISTINCT ON (connec_id) result_id, connec_id FROM rtc_hydrometer_x_connec JOIN om_mincut_hydrometer USING (hydrometer_id) 
		WHERE result_id = v_mincut;
	END IF;

	-- update om_mincut table
	v_expl = (SELECT expl_id FROM om_mincut_connec JOIN connec USING (connec_id) WHERE result_id=v_mincut LIMIT 1);
	
	v_macroexpl = (SELECT macroexpl_id FROM exploitation WHERE expl_id=v_expl);
			
	UPDATE om_mincut SET expl_id=v_expl, macroexpl_id=v_macroexpl, anl_user=current_user WHERE om_mincut.id=v_mincut;
			  
	-- count connec
	SELECT count(connec_id) INTO v_numconnecs FROM om_mincut_connec WHERE result_id=v_mincut;

	-- count hydrometers
	SELECT count (*) INTO v_numhydrometer FROM om_mincut_hydrometer WHERE result_id=v_mincut;

	-- count priority hydrometers
	v_priority = (SELECT (array_to_json(array_agg((b)))) FROM 
	(SELECT concat('{"category":"',observ,'","number":"', count(om_mincut_hydrometer.hydrometer_id), '"}')::json as b FROM om_mincut_hydrometer 
			JOIN v_rtc_hydrometer USING (hydrometer_id)
			LEFT JOIN ext_hydrometer_category ON ext_hydrometer_category.id::text=v_rtc_hydrometer.category_id::text
			WHERE result_id=v_mincut
			GROUP BY observ ORDER BY observ)a);

	-- profilactic control of priority
	IF v_priority IS NULL THEN v_priority='{}'; END IF;

	v_mincutdetails = (concat('{"connecs":{"number":"',v_numconnecs,'","hydrometers":{"total":"',v_numhydrometer,'","classified":',v_priority,'}}}'));
				
	--update output results
	UPDATE om_mincut SET output = v_mincutdetails WHERE id = v_mincut;	
	
	-- mincut details
	SELECT * INTO v_mincutrec FROM om_mincut WHERE id = v_mincut;
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, '');
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, 'Mincut stats');
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, '-----------------');
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Number of arcs: 0'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Length of affected network: 0 mts'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Total network water volume: 0 m3'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Number of connecs affected: ', (v_mincutrec.output->>'connecs')::json->>'number'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Total of hydrometers affected: ', ((v_mincutrec.output->>'connecs')::json->>'hydrometers')::json->>'total'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Hydrometers classification: ', ((v_mincutrec.output->>'connecs')::json->>'hydrometers')::json->>'classified'));

	-- info
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=216 order by id) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	v_result_info := COALESCE(v_result_info, '{}'); 

	RETURN ('{"status":"Accepted", "version":"'||v_version||'","body":{"form":{}'||
			',"data":{ "info":'||v_result_info||'}'||
			'}}')::json;

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;  
	RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ',"SQLCONTEXT":' || to_json(v_error_context) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;