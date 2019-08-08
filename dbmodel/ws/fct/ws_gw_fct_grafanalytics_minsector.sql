/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)

--FUNCTION CODE: 2706

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_minsector(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_grafanalytics_minsector(p_data json)
RETURNS json AS
$BODY$

/*
delete from anl_graf
TO EXECUTE
SELECT SCHEMA_NAME.gw_fct_grafanalytics_minsector('{"data":{"parameters":{"exploitation":"[1,2]", "updateFeature":"TRUE", "updateMinsectorGeom":"TRUE","concaveHullParam":0.85}}}');
SELECT SCHEMA_NAME.gw_fct_grafanalytics_minsector('{"data":{"parameters":{"arc":"2002", "updateFeature":"TRUE", "updateMinsectorGeom":"TRUE","concaveHullParam":0.85}}}')

delete from SCHEMA_NAME.audit_log_data;
delete from SCHEMA_NAME.anl_graf

SELECT * FROM SCHEMA_NAME.anl_arc WHERE fprocesscat_id=34 AND cur_user=current_user
SELECT * FROM SCHEMA_NAME.anl_node WHERE fprocesscat_id=34 AND cur_user=current_user
SELECT * FROM SCHEMA_NAME.audit_log_data WHERE fprocesscat_id=34 AND user_name=current_user


*/

DECLARE
affected_rows 		numeric;
cont1 				integer default 0;
v_class 			text = 'MINSECTOR';
v_feature 			record;
v_expl 				json;
v_data 				json;
v_fprocesscat_id 	integer;
v_addparam 			record;
v_attribute 		text;
v_arcid 			text;
v_featuretype		text;
v_featureid 		integer;
v_querytext 		text;
v_updatefeature 	boolean;
v_arc				text;
v_result_info 		json;
v_result_point		json;
v_result_line 		json;
v_result_polygon	json;
v_result 			text;
v_count				json;
v_version			text;
v_updatemapzgeom 	boolean;
v_concavehull		float;
v_srid				integer;



BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

	-- get variables
	v_arcid = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'arc');
	v_updatefeature = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateFeature');
	v_expl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');
	v_updatemapzgeom = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateMapZone');
	v_concavehull = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'concaveHullParam');

	-- select config values
	SELECT giswater, epsg INTO v_version, v_srid FROM version order by 1 desc limit 1;

	-- set variables
	v_fprocesscat_id=34;  
	v_featuretype='arc';

	-- Starting process
	INSERT INTO audit_check_data (fprocesscat_id, error_message) VALUES (v_fprocesscat_id, concat('MINSECTOR DYNAMIC SECTORITZATION'));
	INSERT INTO audit_check_data (fprocesscat_id, error_message) VALUES (v_fprocesscat_id, concat('---------------------------------------------------'));
		
	-- reset graf & audit_log tables
	DELETE FROM anl_graf where user_name=current_user;
	DELETE FROM audit_log_data WHERE fprocesscat_id=v_fprocesscat_id AND user_name=current_user;
	DELETE FROM anl_node WHERE fprocesscat_id=34 AND cur_user=current_user;
	DELETE FROM anl_arc WHERE fprocesscat_id=34 AND cur_user=current_user;

	-- reset selectors
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);
	DELETE FROM selector_psector WHERE cur_user=current_user;

	-- reset exploitation
	IF v_expl IS NOT NULL THEN
		DELETE FROM selector_expl WHERE cur_user=current_user;
		INSERT INTO selector_expl (expl_id, cur_user) SELECT expl_id, current_user FROM exploitation where macroexpl_id IN
		(SELECT distinct(macroexpl_id) FROM SCHEMA_NAME.exploitation JOIN (SELECT (json_array_elements_text(v_expl))::integer AS expl)a  ON expl=expl_id);
	END IF;

	-- create graf
	INSERT INTO anl_graf ( grafclass, arc_id, node_1, node_2, water, flag, checkf, user_name )
	SELECT  v_class, arc_id, node_1, node_2, 0, 0, 0, current_user FROM v_edit_arc JOIN value_state_type ON state_type=id 
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE
	UNION
	SELECT  v_class, arc_id, node_2, node_1, 0, 0, 0, current_user FROM v_edit_arc JOIN value_state_type ON state_type=id 
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE;
	
	-- set boundary conditions of graf table	
	UPDATE anl_graf SET flag=2 FROM node_type a JOIN cat_node b ON a.id=nodetype_id JOIN node c ON nodecat_id=b.id 
	WHERE c.node_id=anl_graf.node_1 AND graf_delimiter !='NONE' ;
			
	-- starting process
	LOOP
		EXIT WHEN cont1 = -1;
		cont1 = 0;

		-- reset water flag
		UPDATE anl_graf SET water=0 WHERE user_name=current_user AND grafclass=v_class;

		------------------
		-- starting engine
		-- when arc_id is provided as a parameter
		IF v_arcid IS NULL THEN
			SELECT a.arc_id INTO v_arc FROM (SELECT arc_id, max(checkf) as checkf FROM anl_graf WHERE grafclass=v_class GROUP by arc_id) a 
			JOIN v_edit_arc b ON a.arc_id=b.arc_id WHERE checkf=0 LIMIT 1;
		END IF;

		EXIT WHEN v_arc IS NULL;
				
		-- set the starting element
		v_querytext = 'UPDATE anl_graf SET flag=1, water=1, checkf=1 WHERE arc_id='||quote_literal(v_arc)||' AND anl_graf.user_name=current_user AND grafclass='||quote_literal(v_class); 		
		EXECUTE v_querytext;

		-- inundation process
		LOOP	
			cont1 = cont1+1;
			UPDATE anl_graf n SET water= 1, flag=n.flag+1, checkf=1 FROM v_anl_graf a WHERE n.node_1 = a.node_1 AND n.arc_id = a.arc_id AND n.grafclass=v_class;
			GET DIAGNOSTICS affected_rows =row_count;
			EXIT WHEN affected_rows = 0;
			EXIT WHEN cont1 = 200;
		END LOOP;
		
		-- finish engine
		----------------
		
		-- insert arc results into audit table
		EXECUTE 'INSERT INTO anl_arc (fprocesscat_id, arccat_id, arc_id, the_geom, descript) 
			SELECT DISTINCT ON (arc_id)'||v_fprocesscat_id||', arccat_id, a.arc_id, the_geom, '||(v_arc)||' 
			FROM (SELECT arc_id, max(water) as water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||' 
			AND water=1 GROUP by arc_id) a JOIN v_edit_arc b ON a.arc_id=b.arc_id';
	
		-- insert node results into audit table
		EXECUTE 'INSERT INTO anl_node (fprocesscat_id, nodecat_id, node_id, the_geom, descript) 
			SELECT DISTINCT ON (node_id) '||v_fprocesscat_id||', nodecat_id, b.node_id, the_geom, '||(v_arc)||' FROM (SELECT node_1 as node_id FROM
			(SELECT node_1,water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||' UNION SELECT node_2,water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||')a
			GROUP BY node_1, water HAVING water=1)b JOIN v_edit_node c USING(node_id)';

		-- insert node delimiters into audit table
		EXECUTE 'INSERT INTO anl_node (fprocesscat_id, nodecat_id, node_id, the_geom, descript) 
			SELECT DISTINCT ON (node_id) '||v_fprocesscat_id||', nodecat_id, b.node_id, the_geom, 0 FROM 
			(SELECT node_1 as node_id FROM (SELECT node_1,water FROM anl_graf WHERE grafclass=''MINSECTOR'' UNION ALL SELECT node_2,water FROM anl_graf WHERE grafclass=''MINSECTOR'')a
			GROUP BY node_1, water HAVING water=1 AND count(node_1)=2)b JOIN v_edit_node c USING(node_id)';
		-- NOTE: node delimiter are inserted two times in table, as node from minsector trace and as node delimiter

				
	END LOOP;
	
	IF v_updatefeature THEN 
	
		-- due URN concept whe can update massively feature from anl_node without check if is arc/node/connec.....
		UPDATE arc SET minsector_id = a.descript::integer FROM anl_arc a WHERE fprocesscat_id=34 AND a.arc_id=arc.arc_id AND cur_user=current_user;
		UPDATE node SET minsector_id = a.descript::integer FROM anl_node a WHERE fprocesscat_id=34 AND a.node_id=node.node_id AND a.descript::integer >0 AND cur_user=current_user;
		UPDATE node SET minsector_id = 0 FROM anl_node a JOIN v_edit_node USING (node_id) JOIN node_type c ON c.id=node_type 
		WHERE fprocesscat_id=34 AND a.node_id=node.node_id AND a.descript::integer =0 AND graf_delimiter!='NONE' AND cur_user=current_user;

		-- used v_edit_connec to the exploitation filter. Rows before is not neeeded because on table anl_* is data filtered by the process...
		UPDATE v_edit_connec SET minsector_id = a.minsector_id FROM arc a WHERE a.arc_id=v_edit_connec.connec_id;

		-- insert into minsector table
		DELETE FROM minsector WHERE expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user);
		INSERT INTO minsector (minsector_id, dma_id, dqa_id, presszonecat_id, sector_id, expl_id) 
		SELECT distinct ON (minsector_id) minsector_id, dma_id, dqa_id, presszonecat_id::integer, sector_id, expl_id FROM arc WHERE minsector_id is not null;

		-- update geometry of minsector table
		EXECUTE 'UPDATE minsector set the_geom = (a.the_geom) 
			FROM (with polygon AS (SELECT st_collect (the_geom) as g, minsector_id FROM arc group by minsector_id)
			SELECT minsector_id, CASE WHEN st_geometrytype(st_concavehull(g, '||v_concavehull||')) = ''ST_Polygon''::text THEN st_buffer(st_concavehull(g, '||v_concavehull||'), 3)::geometry(Polygon,'||v_srid||')
			ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon, '||v_srid||') END AS the_geom FROM polygon
			)a WHERE a.minsector_id = minsector.minsector_id';	

		-- update graf on minsector_graf
		DELETE FROM minsector_graf;
		INSERT INTO minsector_graf 
		SELECT node_id, nodecat_id, a.minsector_id as minsector_1, b.minsector_id as minsector_2 FROM node 
		join arc a on a.node_1=node_id
		join arc b on b.node_2=node_id
		WHERE node.minsector_id=0;

		-- message
		INSERT INTO audit_check_data (fprocesscat_id, error_message) 
		VALUES (v_fprocesscat_id, concat('WARNING: Minsector attribute (minsector_id) on arc/node/connec features have been updated by this process'));
		
	END IF;
	

	-- set selector
	DELETE FROM selector_audit WHERE cur_user=current_user;
	INSERT INTO selector_audit (fprocesscat_id, cur_user) VALUES (v_fprocesscat_id, current_user);

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=v_fprocesscat_id order by id) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	--points
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript, the_geom FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=v_fprocesscat_id) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "values":',v_result, '}');

	--lines
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, the_geom FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id=v_fprocesscat_id) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "values":',v_result, '}');

	--polygons
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, pol_id, pol_type, state, expl_id, descript, the_geom FROM anl_polygon WHERE cur_user="current_user"() AND fprocesscat_id=v_fprocesscat_id) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_polygon = concat ('{"geometryType":"Polygon", "values":',v_result, '}');

	
	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	v_result_polygon := COALESCE(v_result_polygon, '{}');
	

--  Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"Mapzones dynamic analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
		       '}'||
	    '}')::json;
	
RETURN cont1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
