/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2316


DROP FUNCTION IF EXISTS "ws".gw_fct_pg2epa_nod2arc(varchar);
CREATE OR REPLACE FUNCTION ws.gw_fct_pg2epa_nod2arc(result_id_var varchar, p_only_mandatory_nodarc boolean)  RETURNS integer 
AS $BODY$

/*example
select ws.gw_fct_pg2epa_nod2arc ('testbgeo3', true)
*/

DECLARE
v_nod2arc float;
v_querytext text;
v_arcsearchnodes float;
v_nodarc_min float;
v_buildupmode int2 = 2;
v_query_number text;
v_nodarc1 boolean = false;

BEGIN

	--  Search path
	SET search_path = "ws", public;

	-- get condig values
	SELECT value INTO v_buildupmode FROM config_param_user WHERE parameter = 'inp_options_buildup_mode' AND cur_user=current_user;

	--  Looking for nodarc values
	SELECT min(st_length(the_geom)) FROM rpt_inp_arc JOIN inp_selector_sector ON inp_selector_sector.sector_id=rpt_inp_arc.sector_id WHERE result_id=result_id_var
		INTO v_nodarc_min;

	v_nod2arc := (SELECT value::float FROM config_param_user WHERE parameter = 'inp_options_nodarc_length' and cur_user=current_user limit 1)::float;
	IF v_nod2arc is null then 
		v_nod2arc = 0.3;
	END IF;
	
	IF v_nod2arc > v_nodarc_min-0.01 THEN
		v_nod2arc = v_nodarc_min-0.01;
	END IF;
								
	-- check number of times each node appears in terms of identify nodearcs <> 2
	v_query_number = 'SELECT count(*)as numarcs, node_id FROM node n JOIN (SELECT node_1 as node_id FROM v_edit_inp_pipe 
							UNION ALL SELECT node_2 FROM v_edit_inp_pipe 
							UNION ALL SELECT node_1 FROM v_edit_inp_virtualvalve
							UNION ALL SELECT node_2 FROM v_edit_inp_virtualvalve) a using (node_id) group by n.node_id';

	-- query text to make easy later sql senteces (in fucntion of all nod2arcs have been choosed or not
	v_querytext = 'SELECT a.*, inp_valve.to_arc FROM rpt_inp_node a JOIN inp_valve ON a.node_id=inp_valve.node_id WHERE result_id='||quote_literal(result_id_var)||' 
				UNION  
				SELECT a.*, inp_pump.to_arc FROM rpt_inp_node a JOIN inp_pump ON a.node_id=inp_pump.node_id WHERE result_id='||quote_literal(result_id_var);
				
	IF p_only_mandatory_nodarc IS FALSE THEN
		v_querytext = concat(v_querytext , ' UNION SELECT a.*, inp_shortpipe.to_arc FROM rpt_inp_node a JOIN inp_shortpipe ON a.node_id=inp_shortpipe.node_id WHERE result_id ='||quote_literal(result_id_var));
	END IF;

	v_querytext = concat ('SELECT c.numarcs, b.* FROM ( ',v_querytext, ' ) b JOIN ( ',v_query_number,' ) c USING (node_id)');
		
	RAISE NOTICE ' reverse geometries when node acts as node1 from arc but must be node2';
	EXECUTE 'UPDATE rpt_inp_arc SET the_geom = st_reverse(the_geom) , node_1 = node_2 , node_2 = node_1 WHERE arc_id IN (SELECT arc_id FROM (
		SELECT c.arc_id, n.node_id as node_1, n.to_arc
		FROM rpt_inp_arc c JOIN ('||v_querytext||') n ON node_1 = node_id
		WHERE arc_id != to_arc AND to_arc IS NOT NULL )b )';

	RAISE NOTICE ' reverse geometries when node acts as node2 from arc but must be node1';
	EXECUTE 'UPDATE rpt_inp_arc SET the_geom = st_reverse(the_geom) , node_1 = node_2 , node_2 = node_1 WHERE arc_id IN (SELECT arc_id FROM (
		SELECT c.arc_id, n.node_id as node_1, n.to_arc
		FROM rpt_inp_arc c JOIN ('||v_querytext||') n ON node_2 = node_id
		WHERE arc_id = to_arc AND to_arc IS NOT NULL )b )';


	IF v_nodarc1 THEN
	
		RAISE NOTICE 'new nodes when numarcs = 1';
		EXECUTE 'INSERT INTO rpt_inp_node (result_id, node_id, elevation, elev, node_type, 
				nodecat_id, epa_type, sector_id, state, state_type, annotation, demand, 
				the_geom, addparam) 
				SELECT n.result_id, concat(n.node_id, ''_n2a_1'') as node_id, elevation, elev, ''NODE2ARC'',
				nodecat_id, ''JUNCTION'', n.sector_id, n.state, n.state_type, n.annotation, demand,
				ST_LineInterpolatePoint (c.the_geom, ('||0.5*v_nod2arc||'/length)) AS the_geom,
				(concat(''{"nodeParent":"'', n.node_id ,''","arcPosition":"1-2"}''))
				FROM rpt_inp_arc c JOIN ('||v_querytext||') n ON node_1 = node_id
				WHERE n.numarcs = 1 AND c.result_id = '||quote_literal(result_id_var)||'
			UNION
				SELECT 	n.result_id, concat(n.node_id, ''_n2a_2'') as node_id, elevation, elev, ''NODE2ARC'', 
				nodecat_id, ''JUNCTION'', n.sector_id, n.state, n.state_type, n.annotation, demand,
				ST_LineInterpolatePoint (c.the_geom, (1 - '||0.5*v_nod2arc||'/length)) AS the_geom,
				(concat(''{"nodeParent":"'', n.node_id ,''","arcPosition":"1-2"}''))
				FROM rpt_inp_arc c JOIN ('||v_querytext||') n ON node_2 = node_id
				WHERE n.numarcs = 1 AND c.result_id = '||quote_literal(result_id_var)||'
			UNION
				SELECT 	n.result_id, concat(n.node_id, ''_n2a_2'') as node_id, elevation, elev, ''NODE2ARC'', 
				nodecat_id, ''JUNCTION'', n.sector_id, n.state, n.state_type, n.annotation, demand,
				ST_startpoint(c.the_geom) AS the_geom,
				(concat(''{"nodeParent":"'', n.node_id ,''","arcPosition":"1-2"}''))
				FROM rpt_inp_arc c JOIN ('||v_querytext||') n ON node_1 = node_id
				WHERE n.numarcs = 1 AND c.result_id = '||quote_literal(result_id_var)||'
			UNION
				SELECT 	n.result_id, concat(n.node_id, ''_n2a_1'') as node_id, elevation, elev, ''NODE2ARC'', 
				nodecat_id, ''JUNCTION'', n.sector_id, n.state, n.state_type, n.annotation, demand,
				ST_endpoint(c.the_geom) AS the_geom,
				(concat(''{"nodeParent":"'', n.node_id ,''","arcPosition":"1-2"}''))
				FROM rpt_inp_arc c JOIN ('||v_querytext||') n ON node_2 = node_id
				WHERE n.numarcs = 1 AND c.result_id = '||quote_literal(result_id_var);


		RAISE NOTICE ' new nodes when numarcs = 2';
		EXECUTE 'INSERT INTO rpt_inp_node (result_id, node_id, elevation, elev, node_type, 
				nodecat_id, epa_type, sector_id, state, state_type, annotation, demand, 
				the_geom, addparam) 
				SELECT  n.result_id, concat(n.node_id, ''_n2a_1'') as node_id, elevation, elev, ''NODE2ARC'',
				nodecat_id, ''JUNCTION'', n.sector_id, n.state, n.state_type, n.annotation, demand,
				ST_LineInterpolatePoint (c.the_geom, ('||0.5*v_nod2arc||'/length)) AS the_geom,
				(concat(''{"nodeParent":"'', n.node_id ,''","arcPosition":"1"}''))
				FROM rpt_inp_arc c JOIN ('||v_querytext||') n ON node_1 = node_id
				WHERE n.numarcs = 2 AND c.result_id = '||quote_literal(result_id_var)||'
			UNION
				SELECT 	n.result_id, concat(n.node_id, ''_n2a_2'') as node_id, elevation, elev, ''NODE2ARC'', 
				nodecat_id, ''JUNCTION'', n.sector_id, n.state, n.state_type, n.annotation, demand,
				ST_LineInterpolatePoint (c.the_geom, (1 - '||0.5*v_nod2arc||'/length)) AS the_geom,
				(concat(''{"nodeParent":"'', n.node_id ,''","arcPosition":"2"}''))
				FROM rpt_inp_arc c JOIN ('||v_querytext||') n ON node_2 = node_id
				WHERE n.numarcs = 2 AND c.result_id = '||quote_literal(result_id_var);
	END IF;
	
	RAISE NOTICE 'new arcs when numarcs = 2';
	EXECUTE 'INSERT INTO rpt_inp_arc (result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, expl_id, state, state_type, diameter, roughness, annotation, length, status, the_geom, minorloss, addparam)
			SELECT DISTINCT ON (a.addparam::json->>''nodeParent'')
			a.result_id,
			concat (a.addparam::json->>''nodeParent'', ''_n2a'') as arc_id,
			a.node_id,
			b.node_id,
			''NODE2ARC'', 
			a.nodecat_id as arccat_id, 
			n.epa_type,
			n.sector_id, 
			n.expl_id,
			a.state,
			a.state_type,
			case when (n.addparam::json->>''diameter'')::text !='''' then  (n.addparam::json->>''diameter'')::numeric else 0 end as diameter,
			case when (n.addparam::json->>''roughness'')::text !='''' then  (n.addparam::json->>''roughness'')::numeric else 0 end as roughness,
			a.annotation,
			st_length2d(st_makeline(a.the_geom, b.the_geom)) as length,
			n.addparam::json->>''status'' status,
			st_makeline(a.the_geom, b.the_geom) AS the_geom,
			case when (n.addparam::json->>''minorloss'')::text !='''' then  (n.addparam::json->>''minorloss'')::numeric else 0 end as minorloss,
			n.addparam
			FROM 	(SELECT * FROM rpt_inp_node WHERE result_id = '||quote_literal(result_id_var)||' AND node_type = ''NODE2ARC'' AND addparam::json->>''arcPosition''=''1'') a,
				(SELECT * FROM rpt_inp_node WHERE result_id = '||quote_literal(result_id_var)||' AND node_type = ''NODE2ARC'' AND addparam::json->>''arcPosition''=''2'') b
				JOIN rpt_inp_node n ON n.node_id = b.addparam::json->>''nodeParent''
				WHERE a.addparam::json->>''nodeParent'' = b.addparam::json->>''nodeParent''
				AND n.result_id = '||quote_literal(result_id_var);

	RAISE NOTICE ' update geometries and node_1';
	EXECUTE 'UPDATE rpt_inp_arc SET the_geom = ST_linesubstring(rpt_inp_arc.the_geom, ('||0.5*v_nod2arc||' / length) , 1), node_1 = concat(node_1, ''_n2a_1'') 
			FROM ('||v_querytext||') n WHERE n.node_id = node_1 
			AND rpt_inp_arc.result_id = '||quote_literal(result_id_var);

	RAISE NOTICE ' update geometries and node_2';
	EXECUTE 'UPDATE rpt_inp_arc SET the_geom = ST_linesubstring(rpt_inp_arc.the_geom, 0, ( 1 - '||0.5*v_nod2arc||' / length)), node_2 = concat(node_2, ''_n2a_2'') 
			FROM ('||v_querytext||') n WHERE n.node_id = node_2 
			AND rpt_inp_arc.result_id = '||quote_literal(result_id_var);

	RAISE NOTICE ' Deleting old node from node table';
	EXECUTE ' DELETE FROM rpt_inp_node WHERE node_id IN (SELECT node_id FROM  ('||v_querytext||')a) AND result_id = '||quote_literal(result_id_var);

	RETURN 1;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
