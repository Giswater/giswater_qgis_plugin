/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)

--FUNCTION CODE: 2706

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_minsector(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_minsector(p_data json)
RETURNS json AS
$BODY$

/*
TO EXECUTE

SELECT SCHEMA_NAME.gw_fct_graphanalytics_minsector('{"data":{"parameters":{"exploitation":"[1,2]", "MaxMinsectors":0, "checkData": false, "usePsectors":"TRUE", "updateFeature":"TRUE", "updateMinsectorGeom":2 ,"geomParamUpdate":10}}}');

select distinct(sector_id) from SCHEMA_NAME.arc where expl_id=1

select * from exploitation order by 1


 SELECT gw_fct_graphanalytics_minsector($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"exploitation":"[1]", "usePsectors":"false", "updateFeature":"false", "updateMinsectorGeom":"2", "geomParamUpdate":"10"}}}$$);

SELECT SCHEMA_NAME.gw_fct_graphanalytics_minsector('{"data":{"parameters":{"arc":"2002", "checkQualityData": true, "usePsectors":"TRUE", "updateFeature":"TRUE", "updateMinsectorGeom":2, "geomParamUpdate":10}}}')

delete from SCHEMA_NAME.audit_log_data;
delete from SCHEMA_NAME.temp_anlgraph

SELECT * FROM SCHEMA_NAME.anl_arc WHERE fid=134 AND cur_user=current_user
SELECT * FROM SCHEMA_NAME.anl_node WHERE fid=134 AND cur_user=current_user
SELECT * FROM SCHEMA_NAME.audit_log_data WHERE fid=134 AND cur_user=current_user

SELECT distinct(minsector_id) FROM SCHEMA_NAME.v_edit_arc

--fid: 125,134


MAIN
----
This functions works with state_type isoperative (true and false)




*/

DECLARE

v_affectedrow numeric;
v_cont1 integer default 0;
v_row1 numeric default 0;
v_total numeric default 0;
v_cont2 integer default 0;
v_class text = 'MINSECTOR';
v_feature record;
v_expl json;
v_data json;
v_fid integer;
v_addparam record;
v_attribute text;
v_arcid text;
v_featuretype text;
v_featureid integer;
v_querytext text;
v_updatefeature boolean;
v_arc text;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_result text;
v_count integer = 0;
v_version text;
v_updatemapzgeom integer;
v_geomparamupdate float;
v_srid integer;
v_input json;
v_usepsectors boolean;
v_concavehull float = 0.85;
v_error_context text;
v_checkdata boolean;
v_maxmsector integer = 0;
v_returnerror boolean = false;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

	-- get variables
	v_arcid = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'arc');
	v_updatefeature = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateFeature');
	v_expl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');
	v_updatemapzgeom = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateMapZone');
	v_geomparamupdate = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'geomParamUpdate');
	v_usepsectors = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'usePsectors');
	v_checkdata = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'checkData');
	v_maxmsector = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'MaxMinsectors');
	
	-- select config values
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;

	-- set variables
	v_fid=134;
	v_featuretype='arc';


	-- data quality analysis
	IF v_checkdata THEN
		v_input = '{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"parameters":{"selectionMode":"userSelectors"}}}'::json;
		PERFORM gw_fct_om_check_data(v_input);
		SELECT count(*) INTO v_count FROM audit_check_data WHERE cur_user="current_user"() AND fid=125 AND criticity=3;
	END IF;

	-- check criticity of data in order to continue or not
	IF v_count > 3 THEN
	
		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
		FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=125 order by criticity desc, id asc) row;

		v_result := COALESCE(v_result, '{}'); 
		v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

		-- Control nulls
		v_result_info := COALESCE(v_result_info, '{}'); 
		
		--  Return
		RETURN ('{"status":"Accepted", "message":{"level":3, "text":"Mapzones dynamic analysis canceled. Data is not ready to work with"}, "version":"'||v_version||'"'||
		',"body":{"form":{}, "data":{ "info":'||v_result_info||'}}}')::json;	
	END IF;
 
	-- reset graph & audit_log tables
	DELETE FROM temp_anlgraph;
	DELETE FROM audit_log_data WHERE fid=v_fid AND cur_user=current_user;
	DELETE FROM anl_node WHERE fid=134 AND cur_user=current_user;
	DELETE FROM anl_arc WHERE fid=134 AND cur_user=current_user;
	DELETE FROM audit_check_data WHERE fid=134 AND cur_user=current_user;

	-- Starting process
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('MINSECTOR DYNAMIC SECTORITZATION'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('---------------------------------------------------'));

	SELECT count(*) INTO v_count FROM cat_feature_node WHERE graph_delimiter IS NULL;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (v_fid, 3, concat('ERROR-',v_fid,': There are null values on cat_feature_node.graphdelimiter. Please fill it before continue'));
	ELSE
	
		-- use masterplan
		IF v_usepsectors IS NOT TRUE THEN
			DELETE FROM selector_psector WHERE cur_user=current_user;
		END IF;

		-- reset exploitation
		IF v_expl IS NOT NULL THEN
			
			IF substring(v_expl::text,0,2)='[' THEN
				DELETE FROM selector_expl WHERE cur_user=current_user;
				INSERT INTO selector_expl (expl_id, cur_user) SELECT expl_id, current_user FROM exploitation JOIN (SELECT (json_array_elements_text(v_expl))::integer AS expl_id)a USING (expl_id) ;
			ELSE
				INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid,
				concat('ERROR-',v_fid,': Please insert exploitation id''s as tooltip shows using []'));
				DELETE FROM selector_expl WHERE cur_user=current_user;  
				v_returnerror = true;
				 --dissabling all:
				v_updatemapzgeom = 0;
		
			END IF;
		END IF;

		IF v_usepsectors THEN
			SELECT count(*) INTO v_count FROM selector_psector WHERE cur_user = current_user;
			INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid,
			concat('INFO: Plan psector strategy is enabled. The number of psectors used on this analysis is ', v_count));
		ELSIF v_usepsectors IS FALSE AND v_returnerror IS FALSE THEN
			INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid,
			concat('INFO: All psectors have been disabled to execute this analysis'));
		END IF;
			
		-- reset selectors
		DELETE FROM selector_state WHERE cur_user=current_user;
		INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);

		-- create graph
		IF v_maxmsector > 0 THEN
			INSERT INTO temp_anlgraph ( arc_id, node_1, node_2, water, flag, checkf )
			SELECT  arc_id, node_1, node_2, 0, 0, 0 FROM v_edit_arc
			WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND minsector_id < 1 or minsector_id is null
			UNION
			SELECT  arc_id, node_2, node_1, 0, 0, 0 FROM v_edit_arc
			WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND minsector_id < 1 or minsector_id is null;
		ELSE
			INSERT INTO temp_anlgraph ( arc_id, node_1, node_2, water, flag, checkf )
			SELECT  arc_id, node_1, node_2, 0, 0, 0 FROM v_edit_arc
			WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL
			UNION
			SELECT  arc_id, node_2, node_1, 0, 0, 0 FROM v_edit_arc
			WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL;	
		END IF;

		SELECT count(*)/2 INTO v_total FROM temp_anlgraph;
		
		-- set boundary conditions of graph table	
		UPDATE temp_anlgraph SET flag=2 FROM cat_feature_node a JOIN cat_node b ON a.id=nodetype_id JOIN node c ON nodecat_id=b.id 
		WHERE c.node_id=temp_anlgraph.node_1 AND graph_delimiter !='NONE' ;

		raise notice 'Starting process - Number of arcs: %', v_total;

		LOOP
			-- reset water flag
			UPDATE temp_anlgraph SET water=0;
			
			v_cont2 = v_cont2 +1;

			IF v_maxmsector > 0 THEN
				EXIT WHEN v_cont2 = v_maxmsector + 1;
			END IF;

			------------------
			-- starting engine
			SELECT a.arc_id INTO v_arc FROM (SELECT arc_id, max(checkf) as checkf FROM temp_anlgraph GROUP by arc_id) a WHERE checkf=0 LIMIT 1;

			EXIT WHEN v_arc IS NULL;
					
			-- set the starting element
			v_querytext = 'UPDATE temp_anlgraph SET flag=1, water=1, checkf=1 WHERE arc_id='||quote_literal(v_arc)||'';
			EXECUTE v_querytext;

			-- init variable
			v_cont1 = 0;

			raise notice 'counter %', v_cont2;

			-- inundation process
			LOOP	
				--raise notice 'v_cont1 %', v_cont1;

				v_cont1 = v_cont1+1;
				UPDATE temp_anlgraph n SET water= 1, flag=n.flag+1, checkf=1 FROM v_anl_graph a WHERE n.node_1 = a.node_1 AND n.arc_id = a.arc_id;
				GET DIAGNOSTICS v_affectedrow =row_count;
				v_row1 = v_row1 + v_affectedrow;
				EXIT WHEN v_affectedrow = 0;
				EXIT WHEN v_cont1 = 200;
				
			END LOOP;

			-- finish engine
			----------------
			-- insert arc results into audit table
			INSERT INTO anl_arc (fid, arccat_id, arc_id, the_geom, descript)
			SELECT DISTINCT ON (arc_id) 134, arccat_id, a.arc_id, the_geom, v_arc::text
			FROM (SELECT arc_id, max(water) as water FROM temp_anlgraph WHERE water=1 GROUP by arc_id) a JOIN arc b ON a.arc_id=b.arc_id;
			GET DIAGNOSTICS v_affectedrow =row_count;

		END LOOP;

		IF v_updatefeature THEN 
		
			-- due URN concept whe can update massively feature from anl_node without check if is arc/node/connec.....
			UPDATE arc SET minsector_id = a.descript::integer FROM anl_arc a WHERE fid=134 AND a.arc_id=arc.arc_id AND cur_user=current_user;

			-- update graph nodes inside minsector
			UPDATE node SET minsector_id = a.minsector_id FROM arc a WHERE node_id = node_1;
			UPDATE node SET minsector_id = a.minsector_id FROM arc a WHERE node_id = node_2;
	
			-- update graph nodes on the border of minsectors
			UPDATE node SET minsector_id = 0 FROM v_edit_node n JOIN cat_feature_node c ON c.id=node_type WHERE graph_delimiter!='NONE' AND node.node_id = n.node_id;
								
			-- used v_edit_connec to the exploitation filter. Row before is not neeeded because on table anl_* is data filtered by the process...
			UPDATE v_edit_connec c SET minsector_id = a.minsector_id FROM arc a WHERE a.arc_id=c.arc_id;
			UPDATE link SET minsector_id = a.minsector_id FROM v_edit_connec a WHERE a.connec_id=link.feature_id;

			-- insert into minsector table
			DELETE FROM minsector WHERE expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user);
			INSERT INTO minsector (minsector_id, dma_id, dqa_id, sector_id, expl_id, presszone_id)
			SELECT distinct ON (minsector_id) minsector_id, dma_id, dqa_id, sector_id, expl_id, presszone_id FROM v_edit_arc WHERE minsector_id is not null
			ON CONFLICT (minsector_id) DO NOTHING;

			-- update minsector parameters
			UPDATE minsector SET num_border = a.num FROM 
			(SELECT a.minsector_id,   CASE WHEN count(node_id)=1 then 2 else count(node_id) end AS num FROM node n, v_edit_arc a 
			WHERE  (a.node_1 = n.node_id OR a.node_2 = n.node_id) AND  n.minsector_id = 0
			GROUP BY a.minsector_id)a WHERE a.minsector_id=minsector.minsector_id;

			UPDATE minsector SET num_connec = a.c FROM (SELECT minsector_id, case when count(*) is not null then count(*) else 0 end as c
			FROM v_edit_connec GROUP by minsector_id)a WHERE a.minsector_id=minsector.minsector_id;
			UPDATE minsector SET num_connec = 0 where num_connec is null and expl_id in (SELECT expl_id FROM selector_expl WHERE cur_user = current_user);

			UPDATE minsector SET num_hydro = a.c FROM (
			select minsector_id, case when count(*) is not null then count(*) else 0 end as c FROM 
			(SELECT hydrometer_id, minsector_id FROM v_rtc_hydrometer_x_connec JOIN connec USING (connec_id) 
			UNION SELECT hydrometer_id, minsector_id FROM v_rtc_hydrometer_x_node JOIN node USING (node_id) 
			)a GROUP by minsector_id)a WHERE a.minsector_id=minsector.minsector_id;
			
 			UPDATE minsector SET num_hydro = 0 where num_hydro is null and expl_id in (SELECT expl_id FROM selector_expl WHERE cur_user = current_user);

			UPDATE minsector SET length = a.length FROM (SELECT minsector_id, sum(gis_length) as length FROM v_edit_arc GROUP by minsector_id)a WHERE a.minsector_id=minsector.minsector_id;

			-- message
			INSERT INTO audit_check_data (fid, error_message)
			VALUES (v_fid, concat('WARNING-',v_fid,': Minsector attribute (minsector_id) on arc/node/connec features have been updated by this process'));
			
		ELSIF v_updatefeature IS FALSE and v_returnerror IS FALSE THEN
			-- message
			INSERT INTO audit_check_data (fid, error_message)
			VALUES (v_fid, concat('INFO: Minsector attribute (minsector_id) on arc/node/connec features keeps same value previous function. Nothing have been updated by this process'));
			INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('INFO: To take a look on results you can do querys like this:'));
			INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('SELECT * FROM anl_arc WHERE fid = 134  AND cur_user=current_user;'));
			INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('SELECT * FROM anl_node WHERE fid = 134  AND cur_user=current_user;'));
		
		END IF;

		-- update geometry of mapzones
		IF v_updatemapzgeom = 0 OR v_updatemapzgeom IS NULL THEN

			UPDATE minsector m SET the_geom = null FROM v_edit_arc a WHERE a.minsector_id = m.minsector_id;
						
		ELSIF  v_updatemapzgeom = 1 THEN
			
			-- concave polygon
			v_querytext = 'UPDATE minsector set the_geom = st_multi(a.the_geom) 
					FROM (with polygon AS (SELECT st_collect (the_geom) as g, minsector_id FROM arc group by minsector_id)
					SELECT minsector_id, CASE WHEN st_geometrytype(st_concavehull(g, '||v_geomparamupdate||')) = ''ST_Polygon''::text THEN st_buffer(st_concavehull(g, '||
					v_concavehull||'), 3)::geometry(Polygon,'||v_srid||')
					ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon, '||v_srid||') END AS the_geom FROM polygon
					)a WHERE a.minsector_id = minsector.minsector_id';
			EXECUTE v_querytext;
					
		ELSIF  v_updatemapzgeom = 2 THEN
				
			-- pipe buffer
			v_querytext = '	UPDATE minsector set the_geom = st_multi(geom) FROM
					(SELECT minsector_id, (st_buffer(st_collect(the_geom),'||v_geomparamupdate||')) as geom from arc where minsector_id > 0 group by minsector_id)a 
					WHERE a.minsector_id = minsector.minsector_id';			
			EXECUTE v_querytext;

		ELSIF  v_updatemapzgeom = 3 THEN

			-- use plot and pipe buffer		

	/*
			-- buffer pipe
			v_querytext = '	UPDATE minsector set the_geom = geom FROM
					(SELECT minsector_id, st_multi(st_buffer(st_collect(the_geom),'||v_geomparamupdate||')) as geom from arc where minsector_id::integer > 0 
					AND arc_id NOT IN (SELECT DISTINCT arc_id FROM v_edit_connec,ext_plot WHERE st_dwithin(v_edit_connec.the_geom, ext_plot.the_geom, 0.001))
					group by minsector_id)a 
					WHERE a.minsector_id = minsector.minsector_id';			
			EXECUTE v_querytext;
			-- plot
			v_querytext = '	UPDATE minsector set the_geom = geom FROM
					(SELECT minsector_id, st_multi(st_buffer(st_collect(ext_plot.the_geom),0.01)) as geom FROM v_edit_connec, ext_plot
					WHERE minsector_id::integer > 0 AND st_dwithin(v_edit_connec.the_geom, ext_plot.the_geom, 0.001)
					group by minsector_id)a 
					WHERE a.minsector_id = minsector.minsector_id';	
	*/
			v_querytext = ' UPDATE minsector set the_geom = geom FROM
						(SELECT minsector_id, st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
						(SELECT minsector_id, st_buffer(st_collect(the_geom), '||v_geomparamupdate||') as geom from arc 
						where minsector_id::integer > 0  group by minsector_id
						UNION
						SELECT minsector_id, st_collect(ext_plot.the_geom) as geom FROM v_edit_connec, ext_plot
						WHERE minsector_id::integer > 0 AND st_dwithin(v_edit_connec.the_geom, ext_plot.the_geom, 0.001)
						group by minsector_id
						)a group by minsector_id)b 
					WHERE b.minsector_id=minsector.minsector_id';

			EXECUTE v_querytext;
		END IF;
					
		IF v_updatemapzgeom > 0 THEN
			-- message
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 2, concat('WARNING-',v_fid,': Geometry of mapzone ',v_class ,' have been modified by this process'));
		END IF;

	END IF;
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by id) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	--points
	v_result = null;
	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}');

	--lines
	v_result = null;
	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "features":',v_result, '}');

	--polygons
	v_result = null;
	v_result := COALESCE(v_result, '{}'); 
	v_result_polygon = concat ('{"geometryType":"Polygon", "features":',v_result, '}');
	
	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	v_result_polygon := COALESCE(v_result_polygon, '{}');
	
	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Mapzones dynamic analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
		       '}'||
	    '}')::json, 2706, null, null, null);

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
