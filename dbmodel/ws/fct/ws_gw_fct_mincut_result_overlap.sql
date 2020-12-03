/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2244

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_mincut_result_overlap(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_result_overlap(p_data json)
  RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_mincut_result_overlap($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},"data":{"status":"check", "mincutId":5}}$$)

SELECT SCHEMA_NAME.gw_fct_mincut_result_overlap($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{}, "data":{"status":"continue", "mincutId":333}}$$)

-- fid: 131,216

*/


DECLARE
v_mincutrec record;
v_rec record;
v_conflict_id integer = -2;
v_overlap_macroexpl integer;
v_overlaps boolean = false;
v_overlap_comp boolean;
v_conflictmsg text;
v_count	integer;
v_count2 integer;
v_message text = null;
v_conflictarray integer[];
v_id integer;
v_querytext text;
v_addaffconnecs integer;
v_status text;
v_mincutid integer;
v_result json;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_pol json;
v_error_context text;
v_signal text;
v_geometry text;
v_mincutdetails text;
v_numarcs int4;
v_length  float;
v_volume float;
v_numconnecs int4;
v_numhydrometer int4;
v_priority json;
v_output json;
v_version record;


BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get input data 
	v_status :=  ((p_data ->>'data')::json->>'status')::text;
	v_mincutid :=  ((p_data ->>'data')::json->>'mincutId')::integer;

	-- Reset temporal tables
	DELETE FROM audit_check_data WHERE fid = 216 and cur_user=current_user;

	DELETE FROM om_mincut WHERE id=-2;

	DELETE FROM anl_arc WHERE fid=216 and cur_user=current_user;
	DELETE FROM anl_connec WHERE fid=216 and cur_user=current_user;
	DELETE FROM anl_node WHERE fid=216 and cur_user=current_user;
	DELETE FROM anl_polygon WHERE fid=216 and cur_user=current_user;
	DELETE FROM selector_audit WHERE cur_user = current_user;

	SELECT * INTO v_version FROM sys_version LIMIT 1;
	
	-- Starting process
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('MINCUT ANALYSIS'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('--------------------------------------'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Minimun cut have been checked looking for overlaps againts other mincuts'));

	SELECT * INTO v_mincutrec FROM om_mincut WHERE id = v_mincutid;

	IF v_status  = 'check' THEN

		-- it's not possible to up this deletion because this values are used in case of ste = 'continue'
		DELETE FROM anl_arc WHERE fid=131 and cur_user=current_user;
		DELETE FROM anl_connec WHERE fid=131 and cur_user=current_user;
		DELETE FROM anl_node WHERE fid=131 and cur_user=current_user;

		SELECT count(*) INTO v_count FROM om_mincut_arc WHERE result_id = v_mincutid;
	    
		-- timedate overlap control
		FOR v_rec IN SELECT * FROM om_mincut WHERE mincut_class=1 AND v_count>0
		AND (forecast_start, forecast_end) OVERLAPS (v_mincutrec.forecast_start, v_mincutrec.forecast_end) AND id::text != v_mincutid::text
		LOOP
			-- if exist timedate overlap
			IF v_rec.id IS NOT NULL THEN
				
				-- macroexploitation overlap control
				SELECT macroexpl_id INTO v_overlap_macroexpl FROM exploitation WHERE expl_id=v_rec.expl_id;

				-- if exists macroexpl overlap		
				IF v_overlap_macroexpl=v_mincutrec.macroexpl_id THEN

					-- if it's first time - Inserting mincut values
					IF v_overlaps IS FALSE THEN

						-- create temp result for joined analysis
						INSERT INTO om_mincut (id, work_order, mincut_state, mincut_class, expl_id, macroexpl_id) 
						VALUES (-2, 'Conflict Mincut (system)', 2, 1, v_mincutrec.expl_id, v_mincutrec.macroexpl_id);

						-- copying proposed valves and afected arcs from original mincut result to temp result into om_mincut_valve 
						v_querytext:='INSERT INTO om_mincut_valve (result_id, node_id,  closed,  broken, unaccess, proposed, the_geom)
							     SELECT '||v_conflict_id||', node_id,  closed,  broken, unaccess, proposed, the_geom 
							     FROM om_mincut_valve WHERE result_id='||v_mincutid||' AND proposed=TRUE';
						EXECUTE v_querytext;

						v_querytext:='INSERT INTO om_mincut_arc ( result_id, arc_id, the_geom)
							     SELECT '||v_conflict_id||', arc_id, the_geom 
							     FROM om_mincut_arc WHERE result_id='||v_mincutid;
						EXECUTE v_querytext;	

						--identifing overlap
						v_overlaps:= TRUE;
					END IF;

					-- copying proposed valves and afected arcs from overlaped mincut result 
					v_querytext:='INSERT INTO om_mincut_valve ( result_id, node_id,  closed,  broken, unaccess, proposed, the_geom)
						     SELECT '||v_conflict_id||', node_id,  closed,  broken, unaccess, proposed, the_geom 
						     FROM om_mincut_valve WHERE result_id='||v_rec.id||' AND proposed=TRUE
						     ON conflict (result_id, node_id) DO NOTHING';     
					EXECUTE v_querytext;

					v_querytext:='INSERT INTO om_mincut_arc ( result_id, arc_id, the_geom)
						     SELECT '||v_conflict_id||', arc_id, the_geom 
						     FROM om_mincut_arc WHERE result_id='||v_rec.id||'
						     ON conflict (result_id, arc_id) DO NOTHING';     
					EXECUTE v_querytext;	

					-- count arc_id afected on the overlaped mincut result
					v_count:=v_count+(SELECT count(*) FROM om_mincut_arc WHERE result_id=v_rec.id);

					-- Storing information about possible conflict
					IF v_conflictmsg IS NULL THEN
						v_conflictarray = array_append(v_conflictarray::integer[], v_rec.id::integer);
						v_conflictmsg:=concat('Mincut id-', v_rec.id, ' at ',left(v_rec.forecast_start::time::text, 5),'H-',left(v_rec.forecast_end::time::text, 5),'H with ', 
						(v_rec.output->>'connecs')::json->>'number', ' affected connecs.');
					ELSE
						v_conflictarray = array_append(v_conflictarray, v_rec.id);
						v_conflictmsg:=concat(v_conflictmsg,' Mincut id-', v_rec.id, ' at ',left(v_rec.forecast_start::time::text, 5),'H-',left(v_rec.forecast_end::time::text, 5),'H with ',
						(v_rec.output->>'connecs')::json->>'number', ' affected connecs.');
					END IF;
					
				END IF;
			END IF;
		END LOOP;

		IF v_overlaps THEN

			-- call mincut_flowtrace function
			raise notice 'Execute mincut again mixing overlaped valves';
			PERFORM gw_fct_mincut_inverted_flowtrace (v_conflict_id);

			v_count2:=(SELECT count(*) FROM om_mincut_arc WHERE result_id=v_conflict_id) ;
			
			IF v_count < v_count2 THEN -- check for overlaps with additional affectations

				v_signal ='Conflict';

				v_querytext = replace(replace(v_conflictarray::text,'{',''),'}','');
				
				-- insert conflict mincuts (result_id = all mincuts intersected with current mincut)
				EXECUTE 'INSERT INTO anl_arc (arc_id, fid, expl_id, cur_user, the_geom, result_id, descript)
					SELECT DISTINCT ON (arc_id) arc_id, 131, expl_id, current_user, a.the_geom, result_id, ''Opposite mincuts'' 
					FROM om_mincut_arc JOIN arc a USING (arc_id) WHERE result_id IN ('||v_querytext||')';

				-- insert current mincut (result_id = current mincut)
				INSERT INTO anl_arc (arc_id, fid, expl_id, cur_user, the_geom, result_id, descript)
					SELECT DISTINCT ON (arc_id) arc_id, 131, expl_id, current_user, a.the_geom, result_id, 'Current mincut' 
					FROM om_mincut_arc JOIN arc a USING (arc_id) WHERE result_id = v_mincutid;

				-- insert additional affectations (result_id =-2)
				EXECUTE 'INSERT INTO anl_arc (arc_id, fid, expl_id, cur_user, the_geom, result_id, descript)
					SELECT DISTINCT ON (arc_id) arc_id, 131, expl_id, current_user, a.the_geom, result_id, ''Additional affectation''
					FROM om_mincut_arc JOIN arc a USING (arc_id)  WHERE result_id::integer = '||v_conflict_id||' AND a.arc_id NOT IN 
					(SELECT arc_id FROM om_mincut_arc WHERE result_id IN ('||v_querytext||') UNION SELECT arc_id FROM om_mincut_arc WHERE result_id = '||v_mincutid||')';

				-- getting the number of connecs with additional affectation
				EXECUTE 'SELECT count(*) FROM v_edit_connec JOIN anl_arc USING (arc_id) WHERE fid = 131 AND result_id::integer = '||v_conflict_id
					INTO v_addaffconnecs;

				IF v_addaffconnecs > 0 THEN -- there is a overlap (temporal & spatial intersection) with additional connecs affected

					v_message = concat ('"level":2, "Text":"Mincut ', v_mincutid,
					' overlaps with other mincuts and has conflicts at least with one. Additional pipes are involved but and there are more connecs affected'
					,v_conflictmsg,'"');	
								
					-- insert additional connecs
					EXECUTE 'INSERT INTO anl_connec (connec_id, fid, expl_id, cur_user, the_geom, result_id, descript)
						SELECT DISTINCT ON (connec_id) connec_id, 131, expl_id, current_user, a.the_geom, result_id, '||quote_literal(v_message)||'
						FROM om_mincut_arc JOIN connec a USING (arc_id)  WHERE result_id = '||v_conflict_id||' AND a.arc_id NOT IN 
						(SELECT arc_id FROM om_mincut_arc WHERE result_id IN ('||v_querytext||') UNION SELECT arc_id FROM om_mincut_arc WHERE result_id = '||v_mincutid||')';

					-- info
					INSERT INTO audit_check_data (fid, error_message)
					VALUES (216, concat ('WARNING: There is a temporal overlap with spatial intersection on the same macroexploitation with:',v_conflictmsg));
					INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat ('WARNING: additional pipes are involved and more connecs are affected ( ',v_addaffconnecs,' units. )'));
												
					-- point: connecs affected
					INSERT INTO anl_connec (fid, connec_id, descript, the_geom)
					SELECT 216, connec_id, concat('Additional affected connecs for mincut ',v_mincutid, ' when has conflict againts other mincuts'), 
					the_geom FROM anl_connec WHERE fid = 131 AND result_id::integer = -2 AND cur_user = current_user;
					
				ELSE -- there is a overlap (temporal & spatial intersection) with additional network but without connecs affected

					v_message = concat ('"level":2, "Text":"Mincut ', v_mincutid,
					' overlaps with other mincuts and has conflicts at least with one. Additional pipes are involved but no more connecs affected'
					,v_conflictmsg,'"');		

					-- info
					INSERT INTO audit_check_data (fid, error_message)
					VALUES (216, concat ('WARNING: There is a temporal overlap with spatial intersection on the same macroexploitation wit:',v_conflictmsg));
					INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat ('WARNING: additional pipes are involved'));
					INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat ('INFO: No more connecs are affected'));
					
				END IF;
				
				-- line: the opposite mincuts 
				INSERT INTO anl_arc (fid, arc_id, descript, the_geom)
				SELECT 216, arc_id, concat('Arcs from other mincut(s) with conflict for current mincut ',v_mincutid), 
				the_geom FROM anl_arc WHERE fid = 131 AND cur_user=current_user AND result_id NOT IN (v_mincutid::text, '-2');

				-- polygon: buffer over affected pipes
				INSERT INTO anl_polygon (fid, pol_id, descript, the_geom)
				SELECT 216, v_mincutid,  concat('Additional network area affected for current mincut ',v_mincutid,' when when has conflict againts other mincuts.'), 
				st_multi(st_buffer(st_collect(the_geom),5)) FROM anl_arc WHERE result_id = '-2' AND fid = 131 AND cur_user = current_user;


			ELSE  -- when the number of affected arcs is the same, may exists a real overlap (intersect one againts other) without additional network affectations

				FOREACH v_id IN ARRAY v_conflictarray
				LOOP
					-- insert conflict arcs
					v_querytext =  'INSERT INTO anl_arc (arc_id, fid, expl_id, cur_user, the_geom, result_id)
						SELECT DISTINCT ON (arc_id) arc_id, 131, expl_id, current_user, a.the_geom, '||v_id||' 
						FROM om_mincut_arc JOIN arc a USING (arc_id)  WHERE result_id = '||v_mincutid||' AND a.arc_id IN 
						(SELECT arc_id FROM om_mincut_arc WHERE result_id = '||v_id||')';

					EXECUTE v_querytext;
				END LOOP;

				SELECT count(*) INTO v_count FROM anl_arc WHERE fid=131 AND cur_user=current_user;
				
				IF v_count = 0 THEN  -- There is a temporal overlap without spatial intersection on the same macroexploitation

					v_signal = 'Ok';
					
					--info
					INSERT INTO audit_check_data (fid, error_message)
					VALUES (216, concat ('INFO: There is a temporal overlap without spatial intersection on the same macroexploitation with:',v_conflictmsg));
					INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat ('INFO: No additional pipes are involved and no more connecs are affected'));
					
				ELSE -- There is a temporal overlap with spatial intersection on the same macroexploitation without additional network affected

					v_signal ='Conflict';
					
					v_message = concat ('"level":2, "Text":"Mincut ', v_mincutid,
					' overlaps with other mincuts and has conflicts at least with one but no additional pipes are involved and no more connecs are affected.'
					,v_conflictmsg,'"');
					
					--info
					INSERT INTO audit_check_data (fid, error_message)
					VALUES (216, concat ('WARNING: There is a temporal overlap with spatial intersection on the same macroexploitation with:',v_conflictmsg));
					INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat ('INFO: No additional pipes are involved and no more connecs are affected'));
					
					-- line: the oposite mincuts 
					INSERT INTO anl_arc (fid, arc_id, descript, the_geom)
					SELECT 216, arc_id, descript, the_geom FROM anl_arc WHERE fid = 131 AND cur_user=current_user AND result_id NOT IN (v_mincutid::text, '-2');
				END IF;			
			END IF;

			DELETE FROM  om_mincut WHERE id=v_conflict_id;
			PERFORM setval('SCHEMA_NAME.om_mincut_seq', (select max(id) from om_mincut) , true);  

		ELSE -- There is no temporal overlap on same exploitaiton

			v_signal = 'Ok';

			-- info
			INSERT INTO audit_check_data (fid, error_message) VALUES (216,
			'INFO: There are no more mincuts on the same macroexploitation on planned on the same date-time');
		END IF;

		-- mincut details
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, '');
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, 'Mincut stats');
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, '-----------------');
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Number of arcs: ', (v_mincutrec.output->>'arcs')::json->>'number'));
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Length of affected network: ', (v_mincutrec.output->>'arcs')::json->>'length', ' mts'));
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Total water volume: ', (v_mincutrec.output->>'arcs')::json->>'volume', ' m3'));
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Number of connecs affected: ', (v_mincutrec.output->>'connecs')::json->>'number'));
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Total of hydrometers affected: ', ((v_mincutrec.output->>'connecs')::json->>'hydrometers')::json->>'total'));
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Hydrometers classification: ', ((v_mincutrec.output->>'connecs')::json->>'hydrometers')::json->>'classified'));
	  
		-- get results
		-- info
		v_result = null;
		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
		FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=216 order by id) row;
		v_result := COALESCE(v_result, '{}'); 
		v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

		-- points
		v_result = null;
		SELECT jsonb_agg(features.feature) INTO v_result
		FROM (
		SELECT jsonb_build_object(
		'type',       'Feature',
		'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		'properties', to_jsonb(row) - 'the_geom'
		) AS feature
		FROM (SELECT connec_id, descript, the_geom
		FROM  anl_connec WHERE cur_user="current_user"() AND fid=216) row) features;
		v_result := COALESCE(v_result, '{}'); 
		v_result_point = concat ('{"geometryType":"Point", "layerName":"Overlap affected connecs", "features":',v_result, '}');
	
		-- lines
		v_result = null;
		SELECT jsonb_agg(features.feature) INTO v_result
		FROM (
		SELECT jsonb_build_object(
		'type',       'Feature',
		'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		'properties', to_jsonb(row) - 'the_geom'
		) AS feature
		FROM (SELECT arc_id, descript, the_geom
		FROM  anl_arc WHERE cur_user="current_user"() AND fid=216) row) features;
		v_result := COALESCE(v_result, '{}'); 
		v_result_line = concat ('{"geometryType":"LineString", "layerName":"Overlap affected arcs", "features":',v_result, '}'); 

		-- polygon
		SELECT jsonb_agg(features.feature) INTO v_result
		FROM (
		SELECT jsonb_build_object(
		'type',       'Feature',
		'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		'properties', to_jsonb(row) - 'the_geom'
		) AS feature
		FROM (SELECT pol_id, descript, the_geom
		FROM  anl_polygon WHERE cur_user="current_user"() AND fid=216) row) features;
		v_result := COALESCE(v_result, '{}'); 
		v_result_pol = concat ('{"geometryType":"MultiPolygon", "layerName":"Other mincuts which overlaps", "features":',v_result, '}'); 

		-- geometry (the boundary of mincut using arcs and valves)
		EXECUTE ' SELECT st_astext(st_envelope(st_extent(st_buffer(the_geom,20)))) FROM (SELECT the_geom FROM om_mincut_arc WHERE result_id='||v_mincutid||
		' UNION SELECT the_geom FROM om_mincut_valve WHERE result_id='||v_mincutid||') a'    
	        INTO v_geometry;
		
		-- Control nulls
		v_result_info := COALESCE(v_result_info, '{}'); 
		v_result_point := COALESCE(v_result_point, '{}'); 
		v_result_line := COALESCE(v_result_line, '{}'); 
		v_result_pol := COALESCE(v_result_pol, '{}'); 
		v_geometry := COALESCE(v_geometry, '{}'); 
		v_message := COALESCE(v_message, ''); 

		--  Return
		RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{'||v_message||'}, "version":"'||v_version.giswater||'"'||
			',"body":{"form":{}'||
			',"data":{ "info":'||v_result_info||','||
				'"geometry":"'||v_geometry||'",'|| 			
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_pol||'}'||
			', "actions":{"overlap":"' || v_signal || '"}}}')::json, 2244);
		
	ELSIF v_status  = 'continue' THEN

		-- update mincut details
		INSERT INTO om_mincut_arc (arc_id, result_id, the_geom)	
		SELECT arc_id, v_mincutid, the_geom FROM anl_arc WHERE fid = 131 AND cur_user = current_user AND result_id = '-2'
		ON CONFLICT (arc_id, result_id) DO NOTHING;

		INSERT INTO om_mincut_connec (connec_id, result_id, the_geom)
		SELECT connec_id, v_mincutid, the_geom FROM anl_connec WHERE fid = 131 AND cur_user = current_user AND result_id = '-2'
		ON CONFLICT (connec_id, result_id) DO NOTHING;

		INSERT INTO om_mincut_hydrometer (result_id, hydrometer_id)
		SELECT v_mincutid,rtc_hydrometer_x_connec.hydrometer_id FROM rtc_hydrometer_x_connec 
		JOIN om_mincut_connec ON rtc_hydrometer_x_connec.connec_id=om_mincut_connec.connec_id 
		LEFT JOIN v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id=rtc_hydrometer_x_connec.hydrometer_id
		WHERE result_id=v_mincutid
		ON CONFLICT (hydrometer_id, result_id) DO NOTHING;

		-- count arcs
		SELECT count(arc_id), sum(st_length(arc.the_geom))::numeric(12,2) INTO v_numarcs, v_length FROM om_mincut_arc JOIN arc USING (arc_id) WHERE result_id=v_mincutid group by result_id;
		SELECT sum(area*st_length(arc.the_geom))::numeric(12,2) INTO v_volume FROM om_mincut_arc JOIN arc USING (arc_id) JOIN cat_arc ON arccat_id=cat_arc.id WHERE result_id=v_mincutid group by result_id, arccat_id;

		-- count connec
		SELECT count(connec_id) INTO v_numconnecs FROM connec JOIN om_mincut_arc ON connec.arc_id=om_mincut_arc.arc_id WHERE result_id=v_mincutid AND state=1;

		-- count hydrometers
		SELECT count (rtc_hydrometer_x_connec.hydrometer_id) INTO v_numhydrometer FROM rtc_hydrometer_x_connec JOIN om_mincut_connec ON rtc_hydrometer_x_connec.connec_id=om_mincut_connec.connec_id 
		JOIN v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id=rtc_hydrometer_x_connec.hydrometer_id
		JOIN connec ON connec.connec_id=v_rtc_hydrometer.connec_id WHERE result_id=v_mincutid;

		-- priority hydrometers
		v_priority = 	(SELECT (array_to_json(array_agg((b)))) FROM (SELECT concat('{"category":"',category_id,'","number":"', count(rtc_hydrometer_x_connec.hydrometer_id), '"}')::json as b FROM rtc_hydrometer_x_connec 
				JOIN om_mincut_connec ON rtc_hydrometer_x_connec.connec_id=om_mincut_connec.connec_id 
				JOIN v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id=rtc_hydrometer_x_connec.hydrometer_id
				JOIN connec ON connec.connec_id=v_rtc_hydrometer.connec_id WHERE result_id=v_mincutid GROUP BY category_id ORDER BY category_id)a);
				
		IF v_priority IS NULL THEN v_priority='{}'; END IF;
	
		v_mincutdetails = (concat('"arcs":{"number":"',v_numarcs,'", "length":"',v_length,'", "volume":"', 
		v_volume, '"}, "connecs":{"number":"',v_numconnecs,'","hydrometers":{"total":"',v_numhydrometer,'","classified":',v_priority,'}}'));

		v_output = concat ('{', v_mincutdetails , '}');
			
		--update output results and gettin it
		UPDATE om_mincut SET output = v_output WHERE id = v_mincutid;
		SELECT * INTO v_mincutrec FROM om_mincut WHERE id=v_mincutid;

		-- creating log
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, 'WARNING: Mincut have been executed with conflicts. All additional affetations have been joined to present mincut');
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, '');
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, 'Mincut stats (with additional affectations)');
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, '----------------------------------------------------------');
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Number of arcs: ', (v_mincutrec.output->>'arcs')::json->>'number'));
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Length of affected network: ', (v_mincutrec.output->>'arcs')::json->>'length', ' mts'));
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Total water volume: ', (v_mincutrec.output->>'arcs')::json->>'volume', ' m3'));
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Number of connecs affected: ', (v_mincutrec.output->>'connecs')::json->>'number'));
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Total of hydrometers affected: ', ((v_mincutrec.output->>'connecs')::json->>'hydrometers')::json->>'total'));
		INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Hydrometers classification: ', ((v_mincutrec.output->>'connecs')::json->>'hydrometers')::json->>'classified'));
	  
		-- get results
		-- info
		v_result = null;
		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
		FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=216 order by id) row;
		v_result := COALESCE(v_result, '{}'); 
		v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

		-- geometry (the boundary of mincut using arcs and valves)
		EXECUTE ' SELECT st_astext(st_envelope(st_extent(st_buffer(the_geom,20)))) FROM (SELECT the_geom FROM om_mincut_arc WHERE result_id='||v_mincutid||
		' UNION SELECT the_geom FROM om_mincut_valve WHERE result_id='||v_mincutid||') a'    
	        INTO v_geometry;

		-- Control nulls
		v_result_info := COALESCE(v_result_info, '{}'); 
		v_geometry := COALESCE(v_geometry, '{}'); 
	
		-- return
		RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version.giswater||'"'||
			',"body":{"form":{}'||
			',"data":{ "info":'||v_result_info||','||
				  '"geometry":"'||v_geometry||'"'|| 
			'}}'||
			'}')::json, 2244);
	END IF;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;