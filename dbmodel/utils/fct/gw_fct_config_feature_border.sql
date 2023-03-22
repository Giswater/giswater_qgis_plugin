/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 3204

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_config_feature_border(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
 SELECT gw_fct_config_feature_border($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"configZone":"EXPL"}}}$$);
*/
DECLARE 
v_fid integer = 487;
v_result json;
v_result_info json;
v_error_context text;
v_version text;
v_zone text;
BEGIN

  SET search_path = "SCHEMA_NAME", public;

  -- select version
  SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	v_zone=json_extract_path_text(p_data, 'data','parameters','configZone')::TEXT;
  
  -- Reset values
  DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
  DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid; 
  
  INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('CONFIGURATION OF BORDER NODES'));
  INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '-------------------------------------------------------------');
  INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '');

  
  IF v_zone = 'SECTOR' OR v_zone='ALL' THEN 
  	DELETE FROM node_border_sector WHERE node_id IN (SELECT node_id FROM v_edit_node JOIN selector_sector USING (sector_id) WHERE cur_user = current_user);

  	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('CONFIGURATION OF SECTORS'));

  	--sector
  	INSERT INTO audit_check_data(fid,  error_message)
  	WITH 
		arcs AS (SELECT arc_id, node_1, node_2, sector_id FROM arc WHERE state=1 )
		select v_fid, concat('Sector ',sector_id, ' - ', sum(count), ' border nodes.') from (
		SELECT a1.sector_id, COUNT(*) as count
		FROM v_edit_node node 
		JOIN arcs a1 ON node_id=node_1 
		where a1.sector_id != node.sector_id group by a1.sector_id
		UNION 
		SELECT  a2.sector_id, COUNT(*)
		FROM v_edit_node node 
		JOIN arcs a2 ON node_id=node_2 
		where a2.sector_id != node.sector_id group by a2.sector_id)a
		group by sector_id order by 1;

  	INSERT INTO node_border_sector
		WITH 
		arcs AS (SELECT arc_id, node_1, node_2, sector_id FROM arc WHERE state=1)
		SELECT node_id, a1.sector_id
		FROM v_edit_node node 
		JOIN arcs a1 ON node_id=node_1 
		where a1.sector_id != node.sector_id
		UNION 
		SELECT node_id, a2.sector_id
		FROM v_edit_node node 
		JOIN arcs a2 ON node_id=node_2 
		where a2.sector_id != node.sector_id ON CONFLICT (node_id, sector_id) DO NOTHING;	
	END IF;

	IF v_zone = 'EXPL' OR v_zone='ALL' THEN 

		--exploitation
	  INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '-------------------------------------------------------------');
	  INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '');
	  INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('CONFIGURATION OF EXPLOITATIONS'));

    DELETE FROM node_border_expl WHERE node_id IN (SELECT node_id FROM v_edit_node JOIN selector_expl USING (expl_id) WHERE cur_user = current_user);
	  DELETE FROM arc_border_expl WHERE arc_id IN (SELECT arc_id FROM v_edit_arc JOIN selector_expl USING (expl_id) WHERE cur_user = current_user);

		INSERT INTO node_border_expl
		WITH 
		arcs AS (SELECT arc_id, node_1, node_2, expl_id FROM arc WHERE state=1)
		SELECT node_id, a1.expl_id
		FROM v_edit_node node 
		JOIN arcs a1 ON node_id=node_1 
		where a1.expl_id != node.expl_id
		UNION 
		SELECT node_id, a2.expl_id
		FROM v_edit_node node 
		JOIN arcs a2 ON node_id=node_2 
		where a2.expl_id != node.expl_id ON CONFLICT (node_id, expl_id) DO NOTHING;

		INSERT INTO node_border_expl
		WITH 
		arcs AS (SELECT arc_id, node_1, node_2, expl_id FROM v_edit_arc WHERE state=1)
		SELECT node_id, a1.expl_id
		FROM node 
		JOIN arcs a1 ON node_id=node_1 
		where a1.expl_id != node.expl_id
		UNION 
		SELECT node_id, a2.expl_id
		FROM node 
		JOIN arcs a2 ON node_id=node_2 
		where a2.expl_id != node.expl_id ON CONFLICT (node_id, expl_id) DO NOTHING;

		INSERT INTO node_border_expl
		select node_id,  expl_id from
		(SELECT a.node_id,  n.expl_id
		FROM v_edit_node a
		JOIN node_border_expl n ON n.node_id=a.parent_id::text
		WHERE a.expl_id != n.expl_id)a ON CONFLICT (node_id, expl_id) DO NOTHING;
		
		INSERT INTO arc_border_expl
		select arc_id,  expl_id from
		(SELECT a.arc_id,  n.expl_id
		FROM v_edit_arc a
		JOIN node_border_expl n ON n.node_id=a.parent_id::text
		WHERE a.expl_id != n.expl_id)a ON CONFLICT (arc_id, expl_id) DO NOTHING;
		
		INSERT INTO audit_check_data(fid,  error_message)
		select v_fid, concat('Exploítation ',a.expl_id,' - ',   COUNT(a.node_id), ' border nodes') from 
		(SELECT b.expl_id, b.node_id 
		FROM node_border_expl b
		JOIN v_edit_node USING (node_id))a
		group by expl_id;

	END IF;

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
