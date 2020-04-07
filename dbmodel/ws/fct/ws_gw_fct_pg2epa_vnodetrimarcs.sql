/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2728


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_vnodetrimarcs(result_id_var character varying)  RETURNS json AS 
$BODY$

--SELECT link_id, vnode_id FROM SCHEMA_NAME.link, SCHEMA_NAME.vnode where st_dwithin(st_endpoint(link.the_geom), vnode.the_geom, 0.01) and vnode.state = 0 and link.state > 0

/*
SELECT SCHEMA_NAME.gw_fct_pg2epa_vnodetrimarcs('t1')
*/

DECLARE

	v_count integer = 0;
	v_result integer = 0;
	v_record record;
      
BEGIN
	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting pg2epa vnode trim arcs';
	DELETE FROM temp_go2epa;

	RAISE NOTICE 'insert data on temp_table new nodarcs';
	INSERT INTO temp_go2epa (arc_id, vnode_id, locate, elevation, depth)
	SELECT  arc.arc_id, vnode_id, locate,
	(n1.elevation - locate*(n1.elevation-n2.elevation))::numeric(12,3),
	(CASE WHEN (n1.depth - locate*(n1.depth-n1.depth)) IS NULL THEN 0 ELSE (n1.depth - locate*(n1.depth-n1.depth)) END)::numeric (12,3) as depth
	FROM (
		SELECT  vnode_id, arc_id, locate
		FROM (
			SELECT node_1 as vnode_id, arc_id,  0 as locate FROM rpt_inp_arc WHERE result_id = result_id_var AND arc_type != 'NODE2ARC'
			)z
		UNION	
		SELECT distinct on (vnode_id) concat('VN',vnode_id) as vnode_id, 
		arc_id, 
		case 	
			when st_linelocatepoint (rpt_inp_arc.the_geom , vnode.the_geom) > 0.99 then 0.99 
			when st_linelocatepoint (rpt_inp_arc.the_geom , vnode.the_geom) < 0.1 then 0.1
			else (st_linelocatepoint (rpt_inp_arc.the_geom , vnode.the_geom))::numeric(12,4) end as locate
		FROM rpt_inp_arc , vnode
		JOIN link a ON vnode_id=exit_id::integer
		WHERE st_dwithin ( rpt_inp_arc.the_geom, vnode.the_geom, 0.001) AND vnode.state > 0 AND rpt_inp_arc.arc_type != 'NODE2ARC' AND result_id = result_id_var and a.state > 0
		union
		SELECT  vnode_id, arc_id, locate
		FROM (
			SELECT node_2 as vnode_id, arc_id,  1 as locate FROM rpt_inp_arc WHERE result_id = result_id_var AND arc_type != 'NODE2ARC'
			)z
		) a
	JOIN arc USING (arc_id)
	JOIN node n1 ON node_1 = node_id
	JOIN node n2 ON node_2 = n2.node_id
	ORDER BY arc_id, locate;


	RAISE NOTICE 'new nodes on rpt_inp_node table ';
	INSERT INTO rpt_inp_node (result_id, node_id, elevation, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, the_geom, addparam)
	SELECT 
		result_id_var,
		vnode_id as node_id, 
		CASE 
			WHEN connec.elevation IS NULL THEN t.elevation::numeric(12,3) -- elevation it's interpolated elevation againts node1 and node2 of pipe
			ELSE connec.elevation END as elevation,
		CASE	WHEN connec.elevation IS NULL THEN t.elevation::numeric(12,3) - t.depth::numeric(12,3)-- elev it's interpolated using elevation-depth againts node1 and node2 of pipe
			ELSE connec.elevation - connec.depth END as elev,
		'VNODE',
		'VNODE',
		'JUNCTION',
		a.sector_id,
		a.state,
		a.state_type,
		null,
		ST_LineInterpolatePoint (a.the_geom, locate::numeric(12,4)) as the_geom,
		addparam
		FROM temp_go2epa t
		JOIN rpt_inp_arc a USING (arc_id)
		LEFT JOIN connec ON concat('VN',pjoint_id)=vnode_id
		WHERE vnode_id ilike 'VN%'
		AND result_id=result_id_var;

	RAISE NOTICE 'update temp_table to work with next process';
	UPDATE temp_go2epa SET idmin = c.idmin FROM
	(SELECT min(id) as idmin, arc_id FROM (
		SELECT  a.id, a.arc_id as arc_id, a.vnode_id as node_1, (a.locate)::numeric(12,4) as locate_1 ,
			b.vnode_id as node_2, (b.locate)::numeric(12,4) as locate_2
			FROM temp_go2epa a
			JOIN temp_go2epa b ON a.id=b.id-1 WHERE a.arc_id=b.arc_id 
			ORDER by arc_id)
			a group by arc_id) c
		WHERE temp_go2epa.arc_id = c.arc_id;

		
	RAISE NOTICE 'new arcs on rpt_inp_arc table';
	INSERT INTO rpt_inp_arc (result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, diameter, roughness, length, status, 
	the_geom, flw_code, minorloss, addparam, arcparent)

	WITH a AS (SELECT  a.idmin, a.id, a.arc_id as arc_id, a.vnode_id as node_1, (a.locate)::numeric(12,4) as locate_1 ,
			b.vnode_id as node_2, (b.locate)::numeric(12,4) as locate_2
			FROM temp_go2epa a
			LEFT JOIN temp_go2epa b ON a.id=b.id-1 WHERE a.arc_id=b.arc_id 
			ORDER by arc_id)
	SELECT
		result_id_var,
		concat(arc_id,'P',a.id-a.idmin) as arc_id, 
		a.node_1,
		a.node_2,
		rpt_inp_arc.arc_type,
		rpt_inp_arc.arccat_id,
		rpt_inp_arc.epa_type,
		rpt_inp_arc.sector_id,
		rpt_inp_arc.state,
		rpt_inp_arc.state_type,
		rpt_inp_arc.annotation,
		rpt_inp_arc.diameter,
		rpt_inp_arc.roughness,
		st_length(ST_LineSubstring(the_geom, locate_1, locate_2)),
		rpt_inp_arc.status,		
		CASE 
			WHEN st_geometrytype(ST_LineSubstring(the_geom, locate_1, locate_2))='ST_LineString' THEN ST_LineSubstring(the_geom, locate_1, locate_2)
			ELSE null END AS the_geom,
		rpt_inp_arc.flw_code,
		rpt_inp_arc.minorloss,
		rpt_inp_arc.addparam,
		a.arc_id
		FROM a
		JOIN rpt_inp_arc USING (arc_id)
		WHERE result_id=result_id_var AND (a.node_1 ilike 'VN%' OR a.node_2 ilike 'VN%')
		ORDER BY rpt_inp_arc.arc_id, a.id;

	
	RAISE NOTICE 'delete only trimmed arc on rpt_inp_arc table  - step 1';
	UPDATE rpt_inp_arc SET epa_type ='PIPENOTUSED' 
		FROM (SELECT DISTINCT arcparent AS arc_id FROM rpt_inp_arc WHERE arcparent !='' AND result_id=result_id_var) a
		WHERE a.arc_id = rpt_inp_arc.arc_id AND result_id=result_id_var;

	RAISE NOTICE 'delete only trimmed arc on rpt_inp_arc table - step 2';
	DELETE FROM rpt_inp_arc WHERE epa_type ='PIPENOTUSED' and result_id=result_id_var;

	RAISE NOTICE 'set minimum value of arcs';
	UPDATE rpt_inp_arc SET length=0.01 WHERE length < 0.01 AND result_id=result_id_var;

	RAISE NOTICE 'delete those repeated vnodes when more than one link is sharing same vnode';
	DELETE FROM rpt_inp_node a USING rpt_inp_node b WHERE a.id < b.id AND a.node_id = b.node_id AND a.result_id=result_id_var;
 
RETURN v_result;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;