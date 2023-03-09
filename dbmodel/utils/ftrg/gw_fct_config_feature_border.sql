/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 3204

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_config_feature_border(p_data json)
  RETURNS json AS
$BODY$
DECLARE 
v_fid integer = 487;
v_result json;
v_result_info json;
v_error_context text;
v_version text;
BEGIN

  SET search_path = "SCHEMA_NAME", public;

  -- select version
  SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

  -- Reset values
  DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
  DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid; 
  
  INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('CONFIGURATION OF BORDER NODES'));
  INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '-------------------------------------------------------------');
  INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '');

  INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('CONFIGURATION OF SECTORS'));
  INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('SECTOR_ID - NUMBER OF NODES'));


  	--sector
  	INSERT INTO audit_check_data(fid,  error_message)
  	WITH 
		arcs AS (SELECT arc_id, node_1, node_2, sector_id FROM arc WHERE state=1 )
		select v_fid, concat(sector_id, ' - ', sum(count)) from (
		SELECT a1.sector_id, COUNT(*) as count
		FROM node 
		JOIN arcs a1 ON node_id=node_1 
		where a1.sector_id != node.sector_id group by a1.sector_id
		UNION 
		SELECT  a2.sector_id, COUNT(*)
		FROM node 
		JOIN arcs a2 ON node_id=node_2 
		where a2.sector_id != node.sector_id group by a2.sector_id)a
		group by sector_id order by 1;

  	INSERT INTO node_border_sector
		WITH 
		arcs AS (SELECT arc_id, node_1, node_2, sector_id FROM arc WHERE state=1)
		SELECT node_id, a1.sector_id
		FROM node 
		JOIN arcs a1 ON node_id=node_1 
		where a1.sector_id != node.sector_id
		UNION 
		SELECT node_id, a2.sector_id
		FROM node 
		JOIN arcs a2 ON node_id=node_2 
		where a2.sector_id != node.sector_id ON CONFLICT (node_id, sector_id) DO NOTHING;	

	  INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '-------------------------------------------------------------');
	  INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '');
	  INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('CONFIGURATION OF EXPLOITATIONS'));
	  INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('EXPL_ID - NUMBER OF NODES'));

  	--exploitation
  	INSERT INTO audit_check_data(fid,  error_message)
  	WITH 
		arcs AS (SELECT arc_id, node_1, node_2, expl_id FROM arc WHERE state=1 )
		select v_fid, concat(expl_id,' - ',  sum(count)) from (
		SELECT a1.expl_id, COUNT(*) as count
		FROM node 
		JOIN arcs a1 ON node_id=node_1 
		where a1.expl_id != node.expl_id group by a1.expl_id
		UNION 
		SELECT  a2.expl_id, COUNT(*)
		FROM node 
		JOIN arcs a2 ON node_id=node_2 
		where a2.expl_id != node.expl_id group by a2.expl_id)a
		group by expl_id order by 1;


		INSERT INTO node_border_expl
		WITH 
		arcs AS (SELECT arc_id, node_1, node_2, expl_id FROM arc WHERE state=1)
		SELECT node_id, a1.expl_id
		FROM node 
		JOIN arcs a1 ON node_id=node_1 
		where a1.expl_id != node.expl_id
		UNION 
		SELECT node_id, a2.expl_id
		FROM node 
		JOIN arcs a2 ON node_id=node_2 
		where a2.expl_id != node.expl_id ON CONFLICT (node_id, expl_id) DO NOTHING;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by id) row;
	
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');


	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Configuration done successfully"}, "version":"'||v_version||'"'||
               ',"body":{"form":{}'||
  		     ',"data":{ "info":'||v_result_info||
  			'}}'||
  	    '}')::json, 3204, null, null, null);

  EXCEPTION WHEN OTHERS THEN
  GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
  RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
  	

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
