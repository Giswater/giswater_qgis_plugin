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
 
SELECT SCHEMA_NAME.gw_fct_graphanalytics_minsector($${"client":{"device":4, "lang":"ca_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"exploitation":"[1]", "sector":null, "usePsectors":"false", "updateFeature":"true", "updateMapZone":"3", "geomParamUpdate":"20"}}}$$);

SELECT SCHEMA_NAME.gw_fct_graphanalytics_minsector('{"data":{"parameters":{"arc":"2002", "checkQualityData": true, "usePsectors":"TRUE", "updateFeature":"TRUE", "updateMinsectorGeom":2, "geomParamUpdate":10}}}')

delete from SCHEMA_NAME.audit_log_data;

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
v_returnerror boolean = false;
v_sector json;
v_expl_query text;
v_psectors_query_arc text;
v_psectors_query_node text;
v_psectors_query_connec text;
v_psectors_query_link text;
v_loop record;
v_visible_layer text;

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
	v_sector = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'sector');

	-- select config values
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;

	-- set variables
	v_fid=134;
	v_featuretype='arc';

	--create temp table for quality check
	CREATE TEMP TABLE temp_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);

	-- data quality analysis
	IF v_checkdata THEN
		v_input = concat('{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"parameters":{"fid":',v_fid,', "selectionMode":"userSelectors"}}}')::json;
		PERFORM gw_fct_om_check_data(v_input);
		SELECT count(*) INTO v_count FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid=v_fid AND criticity=3;
	END IF;

	-- check criticity of data in order to continue or not
	IF v_count > 3 THEN
	
		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
		FROM (SELECT id, error_message as message FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by criticity desc, id asc) row;

		v_result := COALESCE(v_result, '{}'); 
		v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

		-- Control nulls
		v_result_info := COALESCE(v_result_info, '{}'); 
		
		--  Return
		RETURN ('{"status":"Accepted", "message":{"level":3, "text":"Mapzones dynamic analysis canceled. Data is not ready to work with"}, "version":"'||v_version||'"'||
		',"body":{"form":{}, "data":{ "info":'||v_result_info||'}}}')::json;	
	END IF;
 
	-- reset graph & audit_log tables
	DELETE FROM temp_audit_check_data WHERE fid=134 AND cur_user=current_user;

	CREATE TEMP TABLE temp_minsector (LIKE SCHEMA_NAME.minsector INCLUDING ALL);
	CREATE TEMP TABLE temp_t_node (LIKE SCHEMA_NAME.node INCLUDING ALL);
	CREATE TEMP TABLE temp_t_connec (LIKE SCHEMA_NAME.connec INCLUDING ALL);
	CREATE TEMP TABLE temp_t_link (LIKE SCHEMA_NAME.link INCLUDING ALL);
	CREATE TEMP TABLE temp_t_arc (LIKE SCHEMA_NAME.arc INCLUDING ALL);

	CREATE TEMP TABLE temp_anl_arc (LIKE SCHEMA_NAME.anl_arc INCLUDING ALL);
	CREATE TEMP TABLE IF NOT EXISTS temp_t_anlgraph (LIKE SCHEMA_NAME.temp_anlgraph INCLUDING ALL);

	-- create temporal view
	CREATE OR REPLACE TEMP VIEW v_temp_anlgraph AS
	 SELECT temp_t_anlgraph.arc_id,
	    temp_t_anlgraph.node_1,
	    temp_t_anlgraph.node_2,
	    temp_t_anlgraph.flag,
	    a2.flag AS flagi,
	    a2.value,
	    a2.trace
	   FROM temp_t_anlgraph
	     JOIN ( SELECT temp_t_anlgraph_1.arc_id,
		    temp_t_anlgraph_1.node_1,
		    temp_t_anlgraph_1.node_2,
		    temp_t_anlgraph_1.water,
		    temp_t_anlgraph_1.flag,
		    temp_t_anlgraph_1.checkf,
		    temp_t_anlgraph_1.value,
		    temp_t_anlgraph_1.trace
		   FROM temp_t_anlgraph temp_t_anlgraph_1
		  WHERE temp_t_anlgraph_1.water = 1) a2 ON temp_t_anlgraph.node_1::text = a2.node_2::text
		  WHERE temp_t_anlgraph.flag < 2 AND temp_t_anlgraph.water = 0 AND a2.flag < 2;

	-- Starting process
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('MINSECTOR DYNAMIC SECTORITZATION'));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('---------------------------------------------------'));

	SELECT count(*) INTO v_count FROM cat_feature_node WHERE graph_delimiter IS NULL;
	IF v_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, criticity, error_message)
		VALUES (v_fid, 3, concat('ERROR-',v_fid,': There are null values on cat_feature_node.graphdelimiter. Please fill it before continue'));
	ELSE
		-- reset exploitation
		IF v_expl IS NOT NULL THEN
			
			IF substring(v_expl::text,0,2)='[' THEN
				v_expl_query = ' a.expl_id = ANY(ARRAY'||v_expl||')';
			ELSE
				INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid,
				concat('ERROR-',v_fid,': Please insert exploitation id''s as tooltip shows, using []'));
				DELETE FROM selector_expl WHERE cur_user=current_user;  
				v_returnerror = true;
				 --dissabling all:
				v_updatemapzgeom = 0;
		
			END IF;
		END IF;
		
		IF v_usepsectors THEN
			SELECT count(*) INTO v_count FROM selector_psector WHERE cur_user = current_user;
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid,
			concat('INFO: Plan psector strategy is enabled. The number of psectors used on this analysis is ', v_count));
			v_psectors_query_arc = ' AND a.arc_id NOT IN (SELECT arc_id FROM v_plan_psector_arc WHERE plan_state = 0) OR a.arc_id IN (SELECT arc_id FROM v_plan_psector_arc WHERE plan_state = 1)';
			v_psectors_query_node = 'AND a.node_id NOT IN (SELECT node_id FROM v_plan_psector_node WHERE plan_state = 0) OR a.node_id IN (SELECT node_id FROM v_plan_psector_node WHERE plan_state = 1)';
			v_psectors_query_connec = 'AND a.connec_id NOT IN (SELECT connec_id FROM v_plan_psector_connec WHERE plan_state = 0) OR a.connec_id IN (SELECT connec_id FROM v_plan_psector_connec WHERE plan_state = 1)';
			v_psectors_query_link = 'AND a.feature_id NOT IN (SELECT connec_id FROM v_plan_psector_connec WHERE plan_state = 0) OR a.feature_id IN (SELECT connec_id FROM v_plan_psector_connec WHERE plan_state = 1)';
		ELSIF v_usepsectors IS FALSE AND v_returnerror IS FALSE THEN
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid,
			concat('INFO: All psectors have been disabled to execute this analysis'));
			v_psectors_query_arc='';
			v_psectors_query_node='';
			v_psectors_query_connec='';
			v_psectors_query_link='';
		END IF;
			raise notice 'v_psectors_query_arc,%',v_psectors_query_arc;

		EXECUTE 'INSERT INTO temp_t_arc SELECT arc.* FROM arc JOIN v_edit_arc a USING (arc_id) WHERE a.state=1 AND is_operative AND '||v_expl_query||'  '||v_psectors_query_arc||';';
		EXECUTE 'INSERT INTO temp_t_node SELECT node.* FROM node JOIN v_edit_node a USING (node_id) WHERE a.state=1 AND is_operative AND '||v_expl_query||'  '||v_psectors_query_arc||';';
		EXECUTE 'INSERT INTO temp_t_connec SELECT connec.* FROM connec JOIN v_edit_connec  a USING (connec_id) WHERE a.state=1 AND is_operative AND '||v_expl_query||'  '||v_psectors_query_connec||';';
		EXECUTE 'INSERT INTO temp_t_link SELECT * FROM link a WHERE state=1 AND is_operative AND '||v_expl_query||'  '||v_psectors_query_link||';';
			
		-- create graph
		EXECUTE 'INSERT INTO temp_t_anlgraph ( arc_id, node_1, node_2, water, flag, checkf, trace )
		SELECT  arc_id, node_1, node_2, 0, 0, 0, 0 FROM temp_t_arc a
		WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND state=1 AND '||v_expl_query||'  '||v_psectors_query_arc||'
		UNION
		SELECT  arc_id, node_2, node_1, 0, 0, 0, 0 FROM temp_t_arc a
		WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND state=1  AND '||v_expl_query||'  '||v_psectors_query_arc||';';
			
		-- set the starting element
		v_querytext = 'UPDATE temp_t_anlgraph SET flag=1, water=1, checkf=1, trace=a.arc_id::integer 
				FROM (SELECT a.arc_id FROM temp_t_arc a JOIN vu_node ON node_1 = node_id WHERE node_type IN (SELECT id FROM cat_feature_node WHERE graph_delimiter IN (''MINSECTOR''))
				UNION SELECT a.arc_id FROM temp_t_arc a JOIN vu_node ON node_2 = node_id WHERE node_type IN (SELECT id FROM cat_feature_node WHERE graph_delimiter IN (''MINSECTOR'')))a
					                                            WHERE temp_t_anlgraph.arc_id = a.arc_id';
		EXECUTE v_querytext;

		-- inundation process
		LOOP	
			v_cont1 = v_cont1+1;
			UPDATE temp_t_anlgraph n SET water= 1, flag=n.flag+1, checkf=1, trace = a.trace FROM v_temp_anlgraph a WHERE n.node_1 = a.node_1 AND n.arc_id = a.arc_id;
			GET DIAGNOSTICS v_affectedrow =row_count;
			v_row1 = v_row1 + v_affectedrow;
			raise notice 'INUNDATION --> %' , v_cont1;
			EXIT WHEN v_affectedrow = 0;
			EXIT WHEN v_cont1 = 30;
		END LOOP;

		-- fusioning parts of each temp_minsectors in one unique temp_minsector 
		create temp view v_t_process as 
		SELECT * FROM 
		(
		SELECT node_id FROM 
		(SELECT node_1 AS node_id, trace FROM temp_t_anlgraph UNION SELECT node_2, trace FROM temp_t_anlgraph ORDER BY 1)a
		JOIN vu_node USING (node_id) 
		WHERE node_type IN (SELECT id FROM cat_feature_node WHERE graph_delimiter !='MINSECTOR') group by node_id having count(*) > 1
		ORDER BY 1
		) a JOIN  
		(
		SELECT a.* FROM 
		(SELECT node_1 AS node_id, trace FROM temp_t_anlgraph UNION SELECT node_2, trace FROM temp_t_anlgraph ORDER BY 1)a
		JOIN vu_node USING (node_id) 
		WHERE node_type IN (SELECT id FROM cat_feature_node WHERE graph_delimiter !='MINSECTOR')
		ORDER BY 1
		) b USING (node_id)
		JOIN 
		(SELECT trace, count(*) FROM temp_t_anlgraph GROUP BY trace) c USING (trace)
		order by 2, 3 desc;

		v_cont1 = 0;

		LOOP
			EXIT WHEN (select count(*) from v_t_process) = 0;
				
			FOR v_loop IN select a.count, node_id, b.trace as trace_new, c.trace as trace_old from 
						(SELECT max(count) AS count, node_id FROM v_t_process GROUP BY node_id )a
						join v_t_process b USING (count, node_id) join v_t_process c USING (node_id) where b.trace::text != c.trace::text
			LOOP
				UPDATE temp_t_anlgraph SET trace = v_loop.trace_new WHERE trace = v_loop.trace_old;
				v_cont1 = v_cont1+1;
				raise notice 'FIXING MINSECTORS --> %' , v_cont1;
			END LOOP;				
		END LOOP;

		-- insert arc results into audit table
		INSERT INTO temp_anl_arc (fid, arccat_id, arc_id, the_geom, descript)
		SELECT DISTINCT ON (arc_id) 134, arccat_id, a.arc_id, the_geom, trace::text
		FROM (SELECT arc_id, max(water) as water, trace FROM temp_t_anlgraph WHERE water=1 GROUP by arc_id, trace) a JOIN arc b ON a.arc_id=b.arc_id;		

		
		-- due URN concept whe can update massively feature from anl_node without check if is arc/node/connec.....
		UPDATE temp_t_arc SET minsector_id = a.descript::integer FROM temp_anl_arc a WHERE fid=134 AND a.arc_id=temp_t_arc.arc_id;

		-- update graph nodes inside temp_minsector
		UPDATE temp_t_node SET minsector_id = a.minsector_id FROM temp_t_arc a WHERE node_id = node_1;
		UPDATE temp_t_node SET minsector_id = a.minsector_id FROM temp_t_arc a WHERE node_id = node_2;
	
		-- update graph nodes on the border of temp_minsectors
		EXECUTE 'UPDATE temp_t_node SET minsector_id = 0 FROM node a 
		JOIN cat_node ON a.nodecat_id = cat_node.id
		JOIN cat_feature_node c ON c.id=nodetype_id WHERE graph_delimiter IN (''MINSECTOR'')
		AND temp_t_node.node_id = a.node_id AND '||v_expl_query||'  '||v_psectors_query_node||';';
								
		-- used v_edit_connec to the exploitation filter. Row before is not neeeded because on table anl_* is data filtered by the process...
		EXECUTE 'UPDATE temp_t_connec c SET minsector_id = a.minsector_id FROM temp_t_arc a WHERE a.arc_id=c.arc_id AND '||v_expl_query||'  '||v_psectors_query_arc||';';
		EXECUTE 'UPDATE temp_t_link a SET minsector_id = a.minsector_id FROM temp_t_connec WHERE temp_t_connec.connec_id=a.feature_id AND '||v_expl_query||'  '||v_psectors_query_link||';';

		-- insert into temp_minsector table
		EXECUTE 'DELETE FROM temp_minsector a WHERE '||v_expl_query||' ;';
		EXECUTE 'INSERT INTO temp_minsector (minsector_id, dma_id, dqa_id, expl_id, presszone_id)
		SELECT distinct ON (minsector_id) minsector_id, dma_id, dqa_id, expl_id, presszone_id FROM temp_t_arc a 
		WHERE minsector_id is not null AND state=1 
		AND '||v_expl_query||' '||v_psectors_query_arc||'
		ON CONFLICT (minsector_id) DO NOTHING;';

		-- update temp_minsector parameters
		EXECUTE 'UPDATE temp_minsector SET num_border = a.num FROM 
		(SELECT a.minsector_id, CASE WHEN count(node_id)=1 then 2 else count(node_id) end AS num FROM temp_t_node n, temp_t_arc a 
		WHERE  (a.node_1 = n.node_id OR a.node_2 = n.node_id) AND  n.minsector_id = 0 AND '||v_expl_query||'  '||v_psectors_query_arc||'
		GROUP BY a.minsector_id)a WHERE a.minsector_id=temp_minsector.minsector_id;';

		EXECUTE 'UPDATE temp_minsector SET num_connec = b.c FROM (SELECT minsector_id, case when count(*) is not null then count(*) else 0 end as c
		FROM temp_t_connec a WHERE '||v_expl_query||'  '||v_psectors_query_connec||' GROUP by minsector_id)b WHERE b.minsector_id=temp_minsector.minsector_id;';
			
		EXECUTE 'UPDATE temp_minsector a SET num_connec = 0 where num_connec is null AND '||v_expl_query||' ;';

		EXECUTE 'UPDATE temp_minsector SET num_hydro = a.c FROM (
		select minsector_id, case when count(*) is not null then count(*) else 0 end as c FROM 
		(SELECT hydrometer_id, minsector_id 
		FROM selector_hydrometer,rtc_hydrometer
		LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
		JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
		JOIN temp_t_connec a ON a.customer_code::text = ext_rtc_hydrometer.connec_id::text
		WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text 
		AND '||v_expl_query||'  '||v_psectors_query_connec||'
		UNION SELECT hydrometer_id, minsector_id 
		FROM selector_hydrometer,rtc_hydrometer
		LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
		JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
		JOIN man_netwjoin ON man_netwjoin.customer_code::text = ext_rtc_hydrometer.connec_id::text
		JOIN temp_t_node a ON a.node_id::text = man_netwjoin.node_id::text
		WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text 
		AND '||v_expl_query||'  '||v_psectors_query_node||'
		)a GROUP by minsector_id)a WHERE a.minsector_id=temp_minsector.minsector_id;';
			
 		EXECUTE 'UPDATE temp_minsector a SET num_hydro = 0 WHERE num_hydro is null AND '||v_expl_query||';';

		EXECUTE 'UPDATE temp_minsector SET length = b.length FROM (SELECT minsector_id, sum(st_length2d(a.the_geom)::numeric(12,2)) as length 
		FROM temp_t_arc a WHERE '||v_expl_query||'  '||v_psectors_query_arc||'
		GROUP by minsector_id)b WHERE b.minsector_id=temp_minsector.minsector_id;';

		-- update geometry of mapzones
		IF v_updatemapzgeom = 0 OR v_updatemapzgeom IS NULL THEN

			EXECUTE 'UPDATE temp_minsector m SET the_geom = null FROM temp_t_arc a WHERE a.minsector_id = m.minsector_id AND '||v_expl_query||'  '||v_psectors_query_arc||';';
						
		ELSIF  v_updatemapzgeom = 1 THEN
			

			-- concave polygon
			v_querytext = 'UPDATE temp_minsector set the_geom = st_multi(b.the_geom) 
					FROM (with polygon AS (SELECT st_collect (the_geom) as g, minsector_id FROM arc a WHERE '||v_expl_query||'  '||v_psectors_query_arc||' group by minsector_id)
					SELECT minsector_id, CASE WHEN st_geometrytype(st_concavehull(g, '||v_geomparamupdate||')) = ''ST_Polygon''::text THEN st_buffer(st_concavehull(g, '||
					v_concavehull||'), 3)::geometry(Polygon,'||v_srid||')
					ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon, '||v_srid||') END AS the_geom FROM polygon
					)b WHERE b.minsector_id = temp_minsector.minsector_id';
			EXECUTE v_querytext;
					
		ELSIF  v_updatemapzgeom = 2 THEN
				
			-- pipe buffer
			v_querytext = '	UPDATE temp_minsector set the_geom = st_multi(geom) FROM
					(SELECT minsector_id, (st_buffer(st_collect(the_geom),'||v_geomparamupdate||')) as geom from temp_t_arc a where minsector_id > 0 
					AND '||v_expl_query||'  '||v_psectors_query_arc||' group by minsector_id)b 
					WHERE b.minsector_id = temp_minsector.minsector_id';			
			EXECUTE v_querytext;

		ELSIF  v_updatemapzgeom = 3 THEN

			-- use plot and pipe buffer		

	/*
			-- buffer pipe
			v_querytext = '	UPDATE temp_minsector set the_geom = geom FROM
					(SELECT minsector_id, st_multi(st_buffer(st_collect(the_geom),'||v_geomparamupdate||')) as geom from arc where minsector_id::integer > 0 
					AND arc_id NOT IN (SELECT DISTINCT arc_id FROM v_edit_connec,ext_plot WHERE st_dwithin(v_edit_connec.the_geom, ext_plot.the_geom, 0.001))
					group by minsector_id)a 
					WHERE a.minsector_id = temp_minsector.minsector_id';			
			EXECUTE v_querytext;
			-- plot
			v_querytext = '	UPDATE temp_minsector set the_geom = geom FROM
					(SELECT minsector_id, st_multi(st_buffer(st_collect(ext_plot.the_geom),0.01)) as geom FROM v_edit_connec, ext_plot
					WHERE minsector_id::integer > 0 AND st_dwithin(v_edit_connec.the_geom, ext_plot.the_geom, 0.001)
					group by minsector_id)a 
					WHERE a.minsector_id = temp_minsector.minsector_id';	
	*/
			v_querytext = ' UPDATE temp_minsector set the_geom = geom FROM
						(SELECT minsector_id, st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
						(SELECT minsector_id, st_buffer(st_collect(the_geom), '||v_geomparamupdate||') as geom from temp_t_arc a
						where minsector_id::integer > 0 AND '||v_expl_query||'  '||v_psectors_query_arc||' group by minsector_id 
						UNION
						SELECT minsector_id, st_collect(ext_plot.the_geom) as geom FROM temp_t_connec a, ext_plot
						WHERE minsector_id::integer > 0 AND '||v_expl_query||'  '||v_psectors_query_connec||' AND st_dwithin(a.the_geom, ext_plot.the_geom, 0.001) 
						group by minsector_id
						)c group by minsector_id)b 
					WHERE b.minsector_id=temp_minsector.minsector_id';

			EXECUTE v_querytext;
		END IF;
					
		IF v_updatemapzgeom > 0 THEN
			-- message
			INSERT INTO temp_audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 2, concat('WARNING-',v_fid,': Geometry of mapzone ',v_class ,' have been modified by this process'));
		END IF;

	END IF;
	
	-- message
	IF v_updatefeature IS TRUE THEN 
		INSERT INTO temp_audit_check_data (fid, error_message)
		VALUES (v_fid, concat('WARNING-',v_fid,': temp_minsector attribute (minsector_id) on arc/node/connec features have been updated by this process'));
				
	ELSIF v_updatefeature IS FALSE and v_returnerror IS FALSE THEN
		-- message
		INSERT INTO temp_audit_check_data (fid, error_message)
		VALUES (v_fid, concat('INFO: temp_minsector attribute (minsector_id) on arc/node/connec features keeps same value previous function. Nothing have been updated by this process'));
		INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('INFO: To take a look on results you can do querys like this:'));
		INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('SELECT * FROM temp_anl_arc ;'));
		
	END IF;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by id) row;
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

	IF v_updatefeature IS FALSE THEN 
		-- polygons 
		EXECUTE 'SELECT jsonb_agg(features.feature) 
		FROM ( 
	  	SELECT jsonb_build_object(
	    ''type'',       ''Feature'',
	    ''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
	    ''properties'', to_jsonb(row) - ''the_geom''
	  	) AS feature
	  	FROM (SELECT  * FROM temp_minsector) row) features'
		INTO v_result;

		v_result := COALESCE(v_result, '{}'); 
		v_result_polygon = concat ('{"geometryType":"Polygon", "features":',v_result, '}');
		v_visible_layer = 'v_edit_arc';
	ELSE 
		v_result = null;
		v_result := COALESCE(v_result, '{}'); 
		v_result_polygon = concat ('{"geometryType":"Polygon", "features":',v_result, '}');
		v_visible_layer = NULL;
	END IF;


	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	v_result_polygon := COALESCE(v_result_polygon, '{}');

	IF v_updatefeature IS TRUE THEN 
	
		-- minsector
		EXECUTE 'DELETE FROM minsector a WHERE '||v_expl_query||' ;';
		INSERT INTO minsector 
		SELECT distinct ON (minsector_id) * FROM temp_minsector	ON CONFLICT (minsector_id) DO NOTHING;
		
		-- arcs
		UPDATE arc SET minsector_id = a.minsector_id FROM temp_t_arc a WHERE a.arc_id=arc.arc_id;

		-- node
		UPDATE node SET minsector_id = n.minsector_id  FROM temp_t_node n WHERE n.node_id=node.node_id;

		-- connec
		UPDATE connec c SET minsector_id = a.minsector_id FROM temp_t_connec a WHERE a.connec_id=c.connec_id;
		UPDATE link l SET minsector_id = a.minsector_id FROM temp_t_connec a WHERE a.connec_id=l.feature_id;

		-- The expl_id of the minsector_graph is same that valve (because of that valves need to be mandatory no have some exploitation)

		-- minsector_graph
		EXECUTE 'DELETE FROM minsector_graph a WHERE '||v_expl_query||'';
		EXECUTE 'INSERT INTO minsector_graph
		select node_1, nodecat_id, a[1] m1, a[2] m2, expl_id from 
		(select node_1, array_agg(minsector_id) a, nodecat_id, expl_id FROM
		(SELECT node_1, arc.minsector_id, nodecat_id, node.expl_id FROM arc join node ON node_1 = node_id where node.minsector_id = 0
		UNION ALL
		SELECT node_2, arc.minsector_id, nodecat_id, node.expl_id FROM arc join node ON node_2 = node_id  where node.minsector_id = 0)a
		WHERE minsector_id is not null
		group by node_1, nodecat_id, expl_id) a
		WHERE '||v_expl_query||' ON CONFLICT (node_id) DO NOTHING';

		-- setting expl_id
		EXECUTE 'UPDATE minsector_graph SET expl_id = a.expl_id FROM node a WHERE '||v_expl_query||' AND minsector_graph.node_id = a.node_id';
		
	END IF;

	--drop temporal layers
	DROP VIEW IF EXISTS v_temp_anlgraph;
	DROP VIEW IF EXISTS v_t_process;
	DROP TABLE IF EXISTS temp_t_anlgraph;
	DROP TABLE IF EXISTS temp_minsector;
	DROP TABLE IF EXISTS temp_t_node;
	DROP TABLE IF EXISTS temp_t_link;
	DROP TABLE IF EXISTS temp_t_connec;
	DROP TABLE IF EXISTS temp_anl_arc;
	DROP TABLE IF EXISTS temp_audit_check_data;
	DROP TABLE IF EXISTS temp_t_arc;

	--show results on the map
	DELETE FROM selector_expl WHERE cur_user=current_user;
	INSERT INTO selector_expl (expl_id, cur_user) SELECT expl_id, current_user FROM exploitation JOIN (SELECT (json_array_elements_text(v_expl))::integer AS expl_id)a USING (expl_id);
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);


	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Mapzones dynamic analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
		       '}'||
	    '}')::json, 2706, null,  ('{"visible": ["'||v_visible_layer||'"]}')::json, null);

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
