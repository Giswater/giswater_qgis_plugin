/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3162

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_graphanalytics_hydrant_recursive(p_data json)
RETURNS json AS
$BODY$

-- fid: 463, 464

DECLARE

v_exists_id character varying;
v_node_id integer;
v_audit_result text;
v_error_context text;
v_level integer;
v_status text;
v_message text;
v_version text;

rec_table record;

v_distance numeric;
v_arclength numeric;
v_percent numeric;
v_checkstart integer;
v_currentDistance numeric;
v_target_node numeric;
v_distance_left numeric;
v_count integer;
v_query text;
v_fid integer=463;
v_fid_cross integer=464;
v_schema text;
v_hydrant integer;
BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	v_schema='SCHEMA_NAME';

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	v_node_id = json_extract_path_text(p_data, 'nodeId')::integer;
	v_hydrant = json_extract_path_text(p_data, 'hydrantId')::integer;
	v_distance=json_extract_path_text(p_data, 'data','parameters','distance')::numeric;
	v_currentDistance=json_extract_path_text(p_data, 'data','currentDistance')::numeric;
	v_distance_left=json_extract_path_text(p_data, 'data','distanceLeft')::numeric;

	IF v_currentDistance IS NULL THEN
		v_currentDistance=0;
	END IF;

	IF v_distance_left IS NULL THEN
		v_distance_left=v_distance;
	END IF;
	-- Check if the node is already computed
	SELECT node_id INTO v_exists_id FROM temp_anl_node WHERE node_id = v_node_id::text AND cur_user="current_user"() AND fid = v_fid;

	-- Compute proceed
	IF NOT FOUND THEN

		-- Update value
		INSERT INTO temp_anl_node (node_id, state, fid, the_geom)
		SELECT node_id, 1, v_fid, the_geom FROM temp_t_node WHERE node_id = v_node_id::text;

		v_query='SELECT flag, arc_id, node_1 as target_node, the_geom FROM temp_t_arc WHERE node_1 = '||quote_literal(v_node_id)||' AND (flag IS false or flag IS null) and result_id='''||v_fid||''' UNION
		SELECT flag,arc_id, node_2 as target_node, the_geom FROM temp_t_arc WHERE node_2 = '||quote_literal(v_node_id)||' AND (flag IS false or flag IS null)  and result_id='''||v_fid||'''';

		-- Loop for all the arcs
		FOR rec_table IN EXECUTE v_query LOOP

			--check if node_id is one at the street crossing - recuperate the saved distance and remove the node if all street options where used
			IF v_node_id::text in (SELECT node_id from temp_anl_node where fid=v_fid_cross) THEN

				SELECT total_distance into v_distance_left from temp_anl_node where fid=v_fid_cross AND node_id=v_node_id::text and cur_user="current_user"();

				EXECUTE 'SELECT count(distinct arc_id) FROM (
				SELECT arc_id, node_1 as target_node, the_geom FROM temp_t_arc WHERE node_1 = '||quote_literal(v_node_id)||' and result_id='''||v_fid||'''  UNION
				SELECT arc_id, node_2 as target_node, the_geom FROM temp_t_arc WHERE node_1 = '||quote_literal(v_node_id)||' and result_id='''||v_fid||''')a'
				INTO v_count;

				IF v_count = 1 THEN
					DELETE FROM temp_anl_node WHERE node_id=v_node_id::text AND fid=v_fid_cross and cur_user="current_user"();
				END IF;
			END IF;

			--check number of arcs that leave the node to save it as a road crossing if necessary
			EXECUTE 'SELECT count(distinct arc_id) FROM (
				SELECT arc_id, node_1 as target_node, the_geom FROM temp_t_arc WHERE node_1 = '||quote_literal(v_node_id)||' and result_id='''||v_fid||'''  UNION
				SELECT arc_id, node_2 as target_node, the_geom FROM temp_t_arc WHERE node_1 = '||quote_literal(v_node_id)||' and result_id='''||v_fid||''')a'
			INTO v_count;

			IF v_count  > 0 THEN
					INSERT INTO temp_anl_node (fid, node_id, total_distance)
					VALUES (v_fid_cross, v_node_id::text, v_distance_left);
				END IF;

			v_arclength = st_length(rec_table.the_geom);

			-- Insert arc into tables
			--IF rec_table.arc_id NOT IN  (SELECT arc_id FROM anl_arc WHERE fid=v_fid) THEN
					INSERT INTO temp_anl_arc (arc_id, fid, the_geom,length, descript, expl_id, node_1)
					SELECT rec_table.arc_id, v_fid, rec_table.the_geom, v_arclength, v_hydrant, expl_id, v_hydrant FROM exploitation
					WHERE ST_DWithin(rec_table.the_geom, exploitation.the_geom,0.01);
			--END IF;
			v_currentDistance=v_currentDistance+v_arclength;

			UPDATE temp_anl_node set total_distance=v_currentDistance WHERE node_id=v_node_id::text AND fid=v_fid and cur_user="current_user"();

			UPDATE temp_t_arc SET flag=true where arc_id=rec_table.arc_id;

			IF v_distance_left > v_arclength  THEN
				v_distance_left=v_distance_left-v_arclength;

				--look for the
				SELECT target_node INTO v_target_node FROM (
				SELECT arc_id, node_1 as target_node, the_geom FROM temp_t_arc WHERE arc_id = rec_table.arc_id AND result_id=v_fid::text UNION
				SELECT arc_id, node_2 as target_node, the_geom FROM temp_t_arc WHERE arc_id = rec_table.arc_id AND result_id=v_fid::text)a
				WHERE target_node!=rec_table.target_node;

				IF v_target_node IS NOT NULL THEN
					-- Call recursive function weighting with the pipe capacity
					EXECUTE 'SELECT gw_fct_graphanalytics_hydrant_recursive($${"client":{"device":4, "infoType":1, "lang":"ES"},
					"feature":{"id":["'||v_target_node||'"]},
					"data":{"parameters":{"distance":'||v_distance||'},"currentDistance":'||v_currentDistance||',"distanceLeft":'||v_distance_left||'},
					"nodeId":"'||v_target_node||'","hydrantId":"'||v_hydrant||'"}$$);';
				END IF;

	 		ELSE

	 			v_percent = v_distance_left/v_arclength;
	 			IF v_percent >1 THEN
	 				v_percent=1;
	 			END IF;
	 			--check the direction of newly created arc and reverse it if it doesnt start in the initial node
				SELECT node_id::integer INTO v_checkstart FROM temp_t_node n
				WHERE ST_DWithin(ST_startpoint(rec_table.the_geom), n.the_geom,2) AND result_id=v_fid::text
				ORDER BY ST_Distance(n.the_geom, ST_startpoint(rec_table.the_geom)) LIMIT 1;

				IF v_checkstart!=v_node_id::integer then

					rec_table.the_geom=ST_Reverse(rec_table.the_geom);
				end if;


				IF v_percent > 0.001 	THEN
					EXECUTE 'UPDATE temp_anl_arc SET the_geom=(ST_LineSubstring('''||rec_table.the_geom::text||''',0.0,'||v_percent||')), fid='||v_fid_cross||', 
					length = st_length(ST_LineSubstring('''||rec_table.the_geom::text||''',0.0,'||v_percent||')) 
					WHERE arc_id='||quote_literal(rec_table.arc_id)||' and fid='||v_fid||' and cur_user=current_user and descript='||quote_literal(v_hydrant)||';';
				END IF;

				IF v_percent < 1 THEN
					EXECUTE 'UPDATE temp_t_arc SET flag=NULL WHERE arc_id='||quote_literal(rec_table.arc_id)||';';
				END IF;

				EXECUTE 'SELECT count(distinct arc_id) FROM (
				SELECT arc_id, node_1 as target_node, the_geom FROM temp_t_arc WHERE node_1 = '||quote_literal(v_node_id)||' and result_id='''||v_fid||'''  UNION
				SELECT arc_id, node_2 as target_node, the_geom FROM temp_t_arc WHERE node_1 = '||quote_literal(v_node_id)||' and result_id='''||v_fid||''')a'
				INTO v_count;
				IF v_count = 0 THEN
					DELETE FROM temp_anl_node WHERE node_id=v_node_id::text AND fid=v_fid_cross and cur_user="current_user"();
				END IF;

				IF v_distance_left IS NULL THEN
					v_distance_left=0;
				END IF;

				EXECUTE 'SELECT gw_fct_graphanalytics_hydrant_recursive($${"client":{"device":4, "infoType":1, "lang":"ES"},
				"feature":{"id":["'||v_node_id||'"]},
				"data":{"parameters":{"distance":'||v_distance||'},"currentDistance":0,"distanceLeft":'||v_distance_left||'},
				"nodeId":"'||v_node_id||'","hydrantId":"'||v_hydrant||'"}$$);';

	 		END IF;
		END LOOP;

	END IF;

	IF v_audit_result is null THEN
		v_status = 'Accepted';
		v_level = 3;
		v_message = 'Process done successfully';
	ELSE

		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status;
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

	END IF;

	--Return
	RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;