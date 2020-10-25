/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2316

DROP FUNCTION IF EXISTS "ws".ws_gw_fct_grafanalytics_toarc(varchar);
CREATE OR REPLACE FUNCTION ws.ws_gw_fct_grafanalytics_toarc(p_node_id varchar)  RETURNS integer 
AS $BODY$

/*example
select ws.ws_gw_fct_grafanalytics_toarc ('1001')
*/

DECLARE
	v_node text;
	v_arcs record;
	v_inlet text;
	v_inletpath boolean;
	v_querytext text;
	v_queryresult record;
	v_count int2 = 0;
	v_countg integer = 0;
	v_total integer = 0;
	v_searchnode integer;
	
BEGIN

	--  Search path
	SET search_path = "ws", public;

	-- graf table
	
	-- close all valves
	
	-- close p_node_id as graf delimiter
	
	-- look for connection to inlet
	FOR v_arcs IN SELECT arc_id, node_1, node_2, expl_id FROM arc WHERE node_1=v_node UNION SELECT arc_id, node_1, node_2, expl_id FROM arc WHERE node_2=v_node -- for each arc
	LOOP
		-- identify the opposite node
		IF v_node = v_arcs.node_1 THEN
			v_searchnode = v_arcs.node_2::integer;
		ELSE
			v_searchnode = v_arcs.node_1::integer;
		END IF;
						
		FOR v_inlet IN SELECT node_id FROM rpt_inp_node WHERE result_id=p_result_id AND epa_type IN ('RESERVOIR') AND expl_id = v_arcs.expl_id -- for each inlet
		LOOP			
			v_querytext:= 'SELECT * FROM pgr_dijkstra(''
					SELECT arc_id::int8 as id, node_1::int8 as source, node_2::int8 as target,
					(case when status=''''CLOSED'''' then -1 else 1 end) as cost,
					(case when status=''''CLOSED'''' then -1 else 1 end) as reverse_cost
					FROM rpt_inp_arc 
					WHERE result_id = '''||quote_literal(p_result_id)||'''''
					,'||v_searchnode||'::int8, '||v_inlet||'::int8)';

					IF v_querytext IS NOT NULL THEN	
				EXECUTE v_querytext INTO v_queryresult;
			END IF;

				IF v_queryresult IS NOT NULL THEN -- it means there there is path from arc to that reservoir
				v_count = v_count + 1;
			END IF;
		END LOOP;
		
		IF v_count = 0 THEN -- it means there is no path to any reservoir for this arc
			RAISE NOTICE 'v_node % has setted to_arc with %', v_node, v_arcs.arc_id;
			INSERT INTO temp_table (fid, text_column) VALUES (100, concat('{"expl_id":"',v_arcs.expl_id,'", "node_id":"',v_node,'", "to_arc":"',v_arcs.arc_id,'"}'));
			EXIT;
		END IF;
		v_count = 0;
	END LOOP;
			

	RETURN 1;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
