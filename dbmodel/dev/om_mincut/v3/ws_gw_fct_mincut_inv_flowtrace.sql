/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
--FUNCTION CODE: 2320

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_mincut_inverted_flowtrace(integer);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_inverted_flowtrace(result_id_arg integer)
  RETURNS integer AS
$BODY$
DECLARE

rec_valve 	record;
rec_tank	record;
mincut_rec	record;
exists_id      	text;
arc_aux    	public.geometry;
polygon_aux2   	public.geometry;
node_aux      	public.geometry;    
rec_table      	record;
rec_result 	record;
first_row      	boolean;
inlet_path      boolean=false;
element_id_arg  varchar(16);
controlValue	smallint;
node_1_aux	varchar(16);
node_2_aux	varchar(16);
query_text	text;
v_debug		Boolean;
v_data		json;
v_macroexpl integer;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Get debug variable
    SELECT value::boolean INTO v_debug FROM config_param_system WHERE parameter='om_mincut_debug';

    -- Starting process
    SELECT * INTO mincut_rec FROM anl_mincut_result_cat WHERE id=result_id_arg;
	SELECT macroexpl_id INTO v_macroexpl FROM exploitation WHERE expl_id=mincut_rec.expl_id;
	
    -- Loop for all the proposed valves
    FOR rec_valve IN SELECT node_id FROM anl_mincut_result_valve WHERE result_id=result_id_arg AND proposed=TRUE
    LOOP
		IF v_debug THEN
			RAISE NOTICE 'Starting flow analysis process for valve: %', rec_valve.node_id;
		END IF;
		FOR rec_tank IN 
		SELECT v_edit_node.node_id, v_edit_node.the_geom FROM anl_mincut_inlet_x_exploitation
		JOIN v_edit_node ON v_edit_node.node_id=anl_mincut_inlet_x_exploitation.node_id
		JOIN value_state_type ON state_type=value_state_type.id 
		JOIN node_type ON node_type.id=nodetype_id
		JOIN exploitation ON exploitation.expl_id=anl_mincut_inlet_x_exploitation.expl_id
		WHERE (is_operative IS TRUE) AND (exploitation.macroexpl_id=v_macroexpl) 
		AND v_edit_node.the_geom IS NOT NULL AND v_edit_node.node_id NOT IN (select node_id FROM anl_mincut_result_node WHERE result_id=result_id_arg)
		ORDER BY 1
		LOOP
		
			/* 
			The aim of this query_text is to draw (if exists) routing from valve to tank defineds on the loop using the pgrouting function ''pgr_dijkstra''
			We need to create the network matrix (transfering the closed status of closed valves an proposed valves to the closests arcs) 
			In order to transfer this propierty to the arc we need to identify
				1) Arcs into the proposed sector with node1 or node2 as proposed valves
				2) Arcs out of the proposed sector with node1 or node2 as (closed valves and not proposed valves)
			*/
		
			query_text:= 'SELECT * FROM pgr_dijkstra( 
				''SELECT v_edit_arc.arc_id::int8 as id, node_1::int8 as source, node_2::int8 as target, 
				(case when closed=true then -1 else 1 end) as cost,
				(case when closed=true then -1 else 1 end) as reverse_cost
				FROM SCHEMA_NAME.v_edit_arc
				LEFT JOIN (
					SELECT arc_id, true as closed FROM SCHEMA_NAME.v_edit_arc
					WHERE 
						(node_1 IN (SELECT node_id FROM SCHEMA_NAME.anl_mincut_result_valve WHERE ((proposed=TRUE) AND result_id='||result_id_arg||'))
						AND arc_id IN(SELECT arc_id FROM SCHEMA_NAME.anl_mincut_result_arc WHERE result_id='||result_id_arg||'))
						
						OR (node_2 IN (SELECT node_id FROM SCHEMA_NAME.anl_mincut_result_valve WHERE ((proposed=TRUE) AND result_id='||result_id_arg||'))
						AND arc_id IN(SELECT arc_id FROM SCHEMA_NAME.anl_mincut_result_arc WHERE result_id='||result_id_arg||')) 
	
						OR (node_1 IN (SELECT node_id FROM SCHEMA_NAME.anl_mincut_result_valve WHERE closed=TRUE AND proposed IS NOT TRUE AND result_id='||result_id_arg||'))
						
						OR (node_2 IN (SELECT node_id FROM SCHEMA_NAME.anl_mincut_result_valve WHERE closed=TRUE AND proposed IS NOT TRUE AND result_id='||result_id_arg||'))

					)a ON a.arc_id=v_edit_arc.arc_id
				WHERE node_1 is not null and node_2 is not null'','||rec_valve.node_id||'::int8, '||rec_tank.node_id||'::int8)';

			IF query_text IS NOT NULL THEN	
				IF (select value::boolean from config_param_system where parameter='om_mincut_valve2tank_traceability') IS TRUE THEN 
					IF v_debug THEN
						RAISE NOTICE' query_text: %',query_text;
					END IF;
				END IF;

				EXECUTE query_text INTO rec_result;
	
			END IF;

			IF rec_result IS NOT NULL THEN
				inlet_path=true;
				IF v_debug THEN
					RAISE NOTICE 'valve % tank % inlet_path % ', rec_valve.node_id, rec_tank.node_id, inlet_path;
					RAISE NOTICE '-------------------------------------------------------------------------------';
				END IF;
				IF (select value::boolean from config_param_system where parameter='om_mincut_valve2tank_traceability') IS TRUE THEN 
					FOR rec_result IN EXECUTE query_text
					LOOP 
						INSERT INTO audit_log_data(fid, feature_id, log_message, user_name) VALUES (29, rec_result.edge, concat(result_id_arg, ':', rec_valve.node_id,'-',rec_tank.node_id), current_user);
					END LOOP;			
				END IF;
	
				EXIT;
			ELSE 
				inlet_path=false;
				IF v_debug THEN
					RAISE NOTICE 'valve % tank % inlet_path % ', rec_valve.node_id, rec_tank.node_id, inlet_path;
					RAISE NOTICE '-------------------------------------------------------------------------------';
				END IF;
			END IF;

		END LOOP;
	
		IF inlet_path IS FALSE THEN
			IF v_debug THEN
				RAISE NOTICE 'Finding additional affectations to valve %', rec_valve.node_id;
			END IF;
			SELECT arc_id INTO element_id_arg FROM v_edit_arc WHERE (node_1=rec_valve.node_id OR node_2=rec_valve.node_id)
			AND arc_id NOT IN (SELECT arc_id FROM anl_mincut_result_arc WHERE result_id=result_id_arg);
	
			IF element_id_arg IS NOT NULL THEN
		
				-- Select public.geometry
				SELECT the_geom INTO arc_aux FROM v_edit_arc WHERE arc_id = element_id_arg;
	
				-- Insert arc id
				IF v_debug THEN
					RAISE NOTICE 'inserting into anl_mincut_result_arc arc_id: %',element_id_arg;
				END IF;

				-- call graf analytics function (MCEXTENDED)
				v_data = concat ('{"data":{"grafClass":"MINCUT", "arc":"', element_id_arg ,'", "parameters":{"id":', result_id_arg ,', "process":"extended"}}}');
				PERFORM gw_fct_grafanalytics_mincut(v_data);			
				
				--Valve has no exit. Update proposed value
				UPDATE anl_mincut_result_valve SET proposed=FALSE WHERE result_id=result_id_arg AND node_id=rec_valve.node_id;		
			END IF;	
		END IF;

	IF v_debug THEN
		RAISE NOTICE 'End flow analisys process for valve: %',rec_valve.node_id;
	END IF;
	
	END LOOP;
	
RETURN 1;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

