/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2316


DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_nod2arc(varchar);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_nod2arc(result_id_var varchar, p_only_mandatory_nodarc boolean)  RETURNS integer 
AS $BODY$

/*example
SELECT SCHEMA_NAME.gw_fct_pg2epa($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},"data":{"geometryLog":false, "resultId":"t1","saveOnDatabase":true, "useNetworkGeom":"false", "useNetworkDemand":"false", "export":"false"}}$$)

*/

DECLARE
v_nod2arc float;
v_querytext text;
v_arcsearchnodes float;
v_nodarc_min float;
v_nodarc1 boolean;
v_query_number text;
v_node record;

BEGIN

--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get condig values
	v_nodarc1 = true;

	
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

	delete from anl_node  WHERE fprocesscat_id  = 124 and cur_user = current_user;
					
	-- check number of times each node appears in terms of identify nodearcs <> 2
	v_query_number = 'SELECT count(*)as numarcs, node_id FROM node n JOIN 
						      (SELECT node_1 as node_id FROM v_edit_arc 
							UNION ALL SELECT node_2 FROM v_edit_arc) a using (node_id) group by n.node_id';

	-- query text to make easy later sql senteces (in function of all nod2arcs have been choosed or not)
	v_querytext = 'SELECT a.*, inp_valve.to_arc FROM rpt_inp_node a JOIN inp_valve ON a.node_id=inp_valve.node_id WHERE result_id='||quote_literal(result_id_var)||' 
				UNION  
				SELECT a.*, inp_pump.to_arc FROM rpt_inp_node a JOIN inp_pump ON a.node_id=inp_pump.node_id WHERE result_id='||quote_literal(result_id_var);
				
	IF p_only_mandatory_nodarc IS FALSE THEN
		v_querytext = concat(v_querytext , ' UNION SELECT a.*, inp_shortpipe.to_arc FROM rpt_inp_node a JOIN inp_shortpipe ON a.node_id=inp_shortpipe.node_id
		WHERE result_id ='||quote_literal(result_id_var));
	END IF;

	v_querytext = concat (' INSERT INTO anl_node (num_arcs, arc_id, node_id, elevation, elev, nodecat_id, sector_id, state, state_type, descript, arc_distance, the_geom, fprocesscat_id, cur_user)
				SELECT c.numarcs, to_arc, b.node_id, elevation, elev, nodecat_id, sector_id, state, state_type, annotation, demand, the_geom, 124, current_user 
				FROM ( ',v_querytext, ' ) b JOIN ( ',v_query_number,' ) c USING (node_id)');
	EXECUTE v_querytext; 

	RAISE NOTICE ' reverse geometries when node acts as node1 from arc but must be node2';
	EXECUTE 'UPDATE rpt_inp_arc SET the_geom = st_reverse(the_geom) , node_1 = node_2 , node_2 = node_1 WHERE arc_id IN (SELECT arc_id FROM (
		SELECT c.arc_id, n.node_id as node_1, n.arc_id as to_arc
		FROM rpt_inp_arc c JOIN anl_node n ON node_1 = node_id
		WHERE c.arc_id != n.arc_id AND n.arc_id IS NOT NULL
		AND fprocesscat_id  = 124 AND cur_user = current_user)b )';

	RAISE NOTICE ' reverse geometries when node acts as node2 from arc but must be node1';
	EXECUTE 'UPDATE rpt_inp_arc SET the_geom = st_reverse(the_geom) , node_1 = node_2 , node_2 = node_1 WHERE arc_id IN (SELECT arc_id FROM (
		SELECT c.arc_id, n.node_id as node_1, n.arc_id as to_arc
		FROM rpt_inp_arc c JOIN anl_node n ON node_2 = node_id
		WHERE c.arc_id != n.arc_id AND n.arc_id IS NOT NULL
		AND fprocesscat_id  = 124 AND cur_user = current_user )b )';

	IF v_nodarc1 THEN 

		RAISE NOTICE 'new nodes when numarcs = 1';
		EXECUTE 'INSERT INTO rpt_inp_node (result_id, node_id, elevation, elev, node_type, 
				nodecat_id, epa_type, sector_id, state, state_type, annotation, demand, 
				the_geom, nodeparent, arcposition) 
				WITH querytext AS (SELECT node_id, num_arcs, elevation, elev, nodecat_id,state, state_type, descript, 
				arc_distance, the_geom FROM anl_node WHERE fprocesscat_id = 124 AND cur_user = current_user)
				SELECT c.result_id, concat(n.node_id, ''_n2a_1'') as node_id, elevation, elev, ''NODE2ARC'',
				nodecat_id, ''JUNCTION'', c.sector_id, n.state, n.state_type, n.descript as annotation, arc_distance as demand,
				ST_LineInterpolatePoint (c.the_geom, ('||0.5*v_nod2arc||'/length)) AS the_geom,
				n.node_id,
				3
				FROM rpt_inp_arc c JOIN querytext n ON node_1 = node_id
				WHERE n.num_arcs = 1 AND c.result_id = '||quote_literal(result_id_var)||'
			UNION
				SELECT c.result_id, concat(n.node_id, ''_n2a_2'') as node_id, elevation, elev, ''NODE2ARC'', 
				nodecat_id, ''JUNCTION'', c.sector_id, n.state, n.state_type, n.descript as annotation, arc_distance as demand,
				ST_LineInterpolatePoint (c.the_geom, (1 - '||0.5*v_nod2arc||'/length)) AS the_geom,
				n.node_id,
				4
				FROM rpt_inp_arc c JOIN querytext n ON node_2 = node_id
				WHERE n.num_arcs = 1 AND c.result_id = '||quote_literal(result_id_var)||'
			UNION
				SELECT c.result_id, concat(n.node_id, ''_n2a_2'') as node_id, elevation, elev, ''NODE2ARC'', 
				nodecat_id, ''JUNCTION'', c.sector_id, n.state, n.state_type, n.descript as annotation, arc_distance as demand,
				ST_startpoint(c.the_geom) AS the_geom,
				n.node_id,
				4
				FROM rpt_inp_arc c JOIN querytext n ON node_1 = node_id
				WHERE n.num_arcs = 1 AND c.result_id = '||quote_literal(result_id_var)||'
			UNION
				SELECT c.result_id, concat(n.node_id, ''_n2a_1'') as node_id, elevation, elev, ''NODE2ARC'', 
				nodecat_id, ''JUNCTION'', c.sector_id, n.state, n.state_type, n.descript as annotation, arc_distance as demand,
				ST_endpoint(c.the_geom) AS the_geom,
				n.node_id,
				3
				FROM rpt_inp_arc c JOIN querytext n ON node_2 = node_id
				WHERE n.num_arcs = 1 AND c.result_id = '||quote_literal(result_id_var);
	END IF;

	RAISE NOTICE 'new nodes when numarcs = 2';
	
	EXECUTE 'INSERT INTO rpt_inp_node (result_id, node_id, elevation, elev, node_type, 
		nodecat_id, epa_type, sector_id, state, state_type, annotation, demand, 
		the_geom, nodeparent, arcposition) 
		WITH querytext AS (SELECT node_id, num_arcs, elevation, elev, nodecat_id,state, state_type, descript, 
		arc_distance, the_geom FROM anl_node WHERE fprocesscat_id = 124 AND cur_user = current_user)
		
		SELECT c.result_id, concat(n.node_id, ''_n2a_1'') as node_id, elevation, elev, ''NODE2ARC'',
		nodecat_id, ''JUNCTION'', c.sector_id, n.state, n.state_type, n.descript as annotation, arc_distance as demand,
		ST_LineInterpolatePoint (c.the_geom, ('||0.5*v_nod2arc||'/length)) AS the_geom,
		n.node_id,
		1
		FROM rpt_inp_arc c JOIN querytext n ON node_1 = node_id
		WHERE n.num_arcs = 2 AND c.result_id = '||quote_literal(result_id_var)||'
		UNION
		SELECT c.result_id, concat(n.node_id, ''_n2a_2'') as node_id, elevation, elev, ''NODE2ARC'', 
		nodecat_id, ''JUNCTION'', c.sector_id, n.state, n.state_type, n.descript as annotation, arc_distance as demand,
		ST_LineInterpolatePoint (c.the_geom, (1 - '||0.5*v_nod2arc||'/length)) AS the_geom,
		n.node_id,
		2
		FROM rpt_inp_arc c JOIN querytext n ON node_2 = node_id
		WHERE n.num_arcs = 2 AND c.result_id = '||quote_literal(result_id_var);


	RAISE NOTICE ' Fix all that nodarcs without to_arc informed, because extremal nodes may appear two times as node_1';
	FOR v_node IN SELECT count(*), node_id FROM rpt_inp_node where result_id = result_id_var AND substring(reverse(node_id),0,2) = '1' group by node_id having count(*) > 1 order by 1 desc
	LOOP
		UPDATE rpt_inp_node SET node_id = concat(reverse(substring(reverse(v_node.node_id),2,99)),'2'), arcposition = 2
		WHERE id IN (SELECT id FROM rpt_inp_node WHERE node_id = v_node.node_id AND result_id = result_id_var LIMIT 1);
	END LOOP;

	RAISE NOTICE ' Fix all that nodarcs without to_arc informed, because extremal nodes may appear two times as node_2';
	FOR v_node IN SELECT count(*), node_id FROM rpt_inp_node where result_id = result_id_var AND substring(reverse(node_id),0,2) = '2' group by node_id having count(*) > 1 order by 1 desc
	LOOP
		UPDATE rpt_inp_node SET node_id = concat(reverse(substring(reverse(v_node.node_id),2,99)),'1'), arcposition = 1
		WHERE id IN (SELECT id FROM rpt_inp_node WHERE node_id = v_node.node_id AND result_id = result_id_var LIMIT 1);
	END LOOP;

	IF v_nodarc1 THEN 
	
		RAISE NOTICE 'new arcs when numarcs = 1';
		EXECUTE 'INSERT INTO rpt_inp_arc (result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, expl_id, state, state_type, diameter, roughness, annotation, length,
			status, the_geom, minorloss, addparam)
				WITH result AS (SELECT * FROM rpt_inp_node WHERE result_id = '||quote_literal(result_id_var)||')
				SELECT DISTINCT ON (a.nodeparent)
				a.result_id,
				concat (a.nodeparent, ''_n2a'') as arc_id,
				a.node_id,
				b.node_id,
				''NODE2ARC'', 
				a.nodecat_id as arccat_id, 
				c.epa_type,
				a.sector_id, 
				a.expl_id,
				a.state,
				a.state_type,
				case when (c.addparam::json->>''diameter'')::text !='''' then  (c.addparam::json->>''diameter'')::numeric else 0 end as diameter,
				case when (c.addparam::json->>''roughness'')::text !='''' then  (c.addparam::json->>''roughness'')::numeric else 0 end as roughness,
				c.annotation,
				st_length2d(st_makeline(a.the_geom, b.the_geom)) as length,
				c.addparam::json->>''status'' status,
				st_makeline(a.the_geom, b.the_geom) AS the_geom,
				case when (c.addparam::json->>''minorloss'')::text !='''' then  (c.addparam::json->>''minorloss'')::numeric else 0 end as minorloss,
				c.addparam
				FROM 	result a,
					result b
					JOIN result c ON c.node_id = b.nodeparent
					WHERE a.nodeparent = b.nodeparent AND a.arcposition = 3 AND b.arcposition = 4';
					
	END IF;
	
	RAISE NOTICE 'new arcs when numarcs = 2';
	EXECUTE 'INSERT INTO rpt_inp_arc (result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, expl_id, state, state_type, diameter, roughness, annotation, length, 
			status, the_geom, minorloss, addparam)

			WITH result AS (SELECT * FROM rpt_inp_node WHERE result_id = '||quote_literal(result_id_var)||')
			SELECT DISTINCT ON (a.nodeparent)
			a.result_id,
			concat (a.nodeparent, ''_n2a'') as arc_id,
			a.node_id,
			b.node_id,
			''NODE2ARC'', 
			a.nodecat_id as arccat_id, 
			c.epa_type,
			c.sector_id, 
			c.expl_id,
			a.state,
			a.state_type,
			case when (c.addparam::json->>''diameter'')::text !='''' then  (c.addparam::json->>''diameter'')::numeric else 0 end as diameter,
			case when (c.addparam::json->>''roughness'')::text !='''' then  (c.addparam::json->>''roughness'')::numeric else 0 end as roughness,
			c.annotation,
			st_length2d(st_makeline(a.the_geom, b.the_geom)) as length,
			c.addparam::json->>''status'' status,
			st_makeline(a.the_geom, b.the_geom) AS the_geom,
			case when (c.addparam::json->>''minorloss'')::text !='''' then  (c.addparam::json->>''minorloss'')::numeric else 0 end as minorloss,
			c.addparam
			FROM 	result a,
				result b
				JOIN result c ON c.node_id = b.nodeparent
				WHERE a.nodeparent = b.nodeparent AND a.arcposition = 1 AND b.arcposition = 2';


	RAISE NOTICE ' update geometries and node_1';
	EXECUTE 'UPDATE rpt_inp_arc SET the_geom = ST_linesubstring(rpt_inp_arc.the_geom, ('||0.5*v_nod2arc||' / length) , 1), node_1 = concat(node_1, ''_n2a_1'') 
			FROM anl_node n WHERE n.node_id = node_1 AND fprocesscat_id  = 124 and cur_user = current_user
			AND rpt_inp_arc.result_id = '||quote_literal(result_id_var);

	RAISE NOTICE ' update geometries and node_2';
	EXECUTE 'UPDATE rpt_inp_arc SET the_geom = ST_linesubstring(rpt_inp_arc.the_geom, 0, ( 1 - '||0.5*v_nod2arc||' / length)), node_2 = concat(node_2, ''_n2a_2'') 
			FROM anl_node n WHERE n.node_id = node_2 AND fprocesscat_id  = 124 and cur_user = current_user
			AND rpt_inp_arc.result_id = '||quote_literal(result_id_var);

	RAISE NOTICE ' Deleting old node from node table';
	EXECUTE ' UPDATE rpt_inp_node SET epa_type =''NODE2DELETE'' FROM (SELECT node_id FROM  anl_node a WHERE fprocesscat_id  = 124 and cur_user = current_user ) b
					WHERE rpt_inp_node.node_id = b.node_id AND result_id = '||quote_literal(result_id_var);

	EXECUTE ' DELETE FROM rpt_inp_node WHERE epa_type =''NODE2DELETE'' AND result_id = '||quote_literal(result_id_var);

	RETURN 1;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
