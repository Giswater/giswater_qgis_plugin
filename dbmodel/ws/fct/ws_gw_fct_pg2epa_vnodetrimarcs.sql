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
SELECT SCHEMA_NAME.gw_fct_pg2epa_vnodetrimarcs('r1')
*/

DECLARE

v_count integer = 0;
v_fid integer = 0;
v_record record;
v_count2 integer = 0;
     
BEGIN
	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting pg2epa vnode trim arcs ';
	TRUNCATE temp_go2epa;

	RAISE NOTICE '1 - arrange vnode';
	EXECUTE 'SELECT gw_fct_setvnoderepair($${
	"client":{"device":4, "infoType":1, "lang":"ES"},
	"feature":{},"data":{"parameters":{"fid":227}}}$$)';
	
	RAISE NOTICE '2 - insert data on temp_table';
	INSERT INTO temp_go2epa (arc_id, vnode_id, locate, elevation, depth)
	SELECT  arc.arc_id, vnode_id, locate,
	case when vnode_elevation is null then (n1.elevation - locate*(n1.elevation-n2.elevation))::numeric(12,3) ELSE vnode_elevation END as elevation,
	(CASE WHEN (n1.depth - locate*(n1.depth-n2.depth)) IS NULL THEN 0 ELSE (n1.depth - locate*(n1.depth-n2.depth)) END)::numeric (12,3) as depth
	FROM (
		SELECT  vnode_id, arc_id, locate, vnode_elevation

			-- select node_1 and node_2 (locate 0 & 1)
			FROM (
				SELECT node_1 as vnode_id, arc_id,  0 as locate, null::numeric as vnode_elevation FROM temp_arc WHERE arc_type NOT IN ('NODE2ARC', 'LINK')
				)z
		UNION
			SELECT  vnode_id, arc_id, locate, elevation
			FROM (
			SELECT node_2 as vnode_id, arc_id,  1 as locate, null::numeric as elevation FROM temp_arc WHERE arc_type NOT IN ('NODE2ARC', 'LINK') 
				)z
		UNION	
			-- real vnode coming from link
			SELECT distinct on (vnode_id) concat('VN',vnode_id) as vnode_id, 
			arc_id, 
			case 	
				when st_linelocatepoint (temp_arc.the_geom , vnode.the_geom) > 0.9999 then 0.9999
				when st_linelocatepoint (temp_arc.the_geom , vnode.the_geom) < 0.0001 then 0.0001
				else (st_linelocatepoint (temp_arc.the_geom , vnode.the_geom))::numeric(12,4) end as locate,
			a.vnode_topelev as elevation
			FROM temp_arc , v_vnode AS vnode
			JOIN link a ON vnode_id=exit_id::integer
			WHERE st_dwithin ( temp_arc.the_geom, vnode.the_geom, 0.01) AND vnode.state > 0 AND temp_arc.arc_type NOT IN ('NODE2ARC', 'LINK') AND a.state > 0
		UNION	
			-- ficticius vnode coming from temp_table (using values created by gw_fct_pg2epa_breakpipes function)
			SELECT distinct on (temp_table.id) concat('VN',temp_table.id) as vnode_id, 
			arc_id, 
			case 	
				when st_linelocatepoint (temp_arc.the_geom , geom_point) > 0.9999 then 0.9999
				when st_linelocatepoint (temp_arc.the_geom , geom_point) < 0.0001 then 0.0001
				else (st_linelocatepoint (temp_arc.the_geom , geom_point))::numeric(12,4) end as locate,
			null::numeric as elevation
			FROM temp_arc , temp_table
			WHERE st_dwithin ( temp_arc.the_geom, geom_point, 0.01) 
			AND temp_arc.arc_type NOT IN ('NODE2ARC', 'LINK') AND temp_arc.state > 0
		UNION 
			-- connec over arc
			SELECT distinct on (node_id) concat('VC',node_id) as vnode_id, 
			temp_arc.arc_id, 
			case 	
				when st_linelocatepoint (temp_arc.the_geom , vnode.the_geom) > 0.9999 then 0.9999
				when st_linelocatepoint (temp_arc.the_geom , vnode.the_geom) < 0.0001 then 0.0001
				else (st_linelocatepoint (temp_arc.the_geom , vnode.the_geom))::numeric(12,4) end as locate,
			vnode.elevation
			FROM temp_arc , temp_node AS vnode
			WHERE node_type = 'CONNEC' AND st_dwithin ( temp_arc.the_geom, vnode.the_geom, 0.01) 
			AND vnode.state > 0 AND temp_arc.arc_type NOT IN ('NODE2ARC', 'LINK')
		) a
	JOIN arc USING (arc_id)
	JOIN node n1 ON node_1 = node_id
	JOIN node n2 ON node_2 = n2.node_id
	ORDER BY arc_id, locate;


	RAISE NOTICE '3 - Delete connec over arcs ';
	UPDATE temp_node SET epa_type = 'TODELETE' FROM arc JOIN connec c USING (arc_id) 
	WHERE node_type = 'CONNEC' AND st_dwithin ( arc.the_geom, temp_node.the_geom, 0.01) AND c.connec_id = temp_node.node_id;
	DELETE FROM temp_node WHERE epa_type = 'TODELETE';

	RAISE NOTICE '4 - new nodes on temp_node table ';
	INSERT INTO temp_node (node_id, elevation, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, the_geom, addparam, dma_id, presszone_id, dqa_id, minsector_id)
	SELECT 
		vnode_id as node_id, 
		t.elevation::numeric(12,3), -- elevation it's interpolated elevation against node1 and node2 of pipe
		t.elevation::numeric(12,3) - t.depth::numeric(12,3) as elev,  -- elev it's interpolated using elevation-depth against node1 and node2 of pipe 
		'VNODE',
		'VNODE',
		'JUNCTION',
		a.sector_id,
		a.state,
		a.state_type,
		null,
		ST_LineInterpolatePoint (a.the_geom, locate::numeric(12,4)) as the_geom,
		addparam, a.dma_id, a.presszone_id, a.dqa_id, a.minsector_id
		FROM temp_go2epa t
		JOIN temp_arc a USING (arc_id)
		LEFT JOIN connec ON concat('VN',pjoint_id)=vnode_id
		WHERE vnode_id like 'VN%' AND a.arc_type !='LINK';

	INSERT INTO temp_node (node_id, elevation, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, the_geom, addparam, dma_id, presszone_id, dqa_id, minsector_id)
	SELECT 
		vnode_id as node_id, 
		t.elevation::numeric(12,3), -- elevation it's interpolated elevation against node1 and node2 of pipe
		t.elevation::numeric(12,3) - t.depth::numeric(12,3) as elev,  -- elev it's interpolated using elevation-depth against node1 and node2 of pipe 
		'VCONNEC',
		'VNODE',
		'JUNCTION',
		a.sector_id,
		a.state,
		a.state_type,
		null,
		ST_LineInterpolatePoint (a.the_geom, locate::numeric(12,4)) as the_geom,
		addparam, a.dma_id, a.presszone_id, a.dqa_id, a.minsector_id
		FROM temp_go2epa t
		JOIN temp_arc a USING (arc_id)
		LEFT JOIN connec ON concat('VC',pjoint_id)=vnode_id
		WHERE vnode_id like 'VC%' AND a.arc_type !='LINK';


	RAISE NOTICE '5 - update temp_table to work with next process';
	UPDATE temp_go2epa SET idmin = c.idmin FROM
	(SELECT min(id) as idmin, arc_id FROM (
		SELECT  a.id, a.arc_id as arc_id, a.vnode_id as node_1, (a.locate)::numeric(12,4) as locate_1 ,
			b.vnode_id as node_2, (b.locate)::numeric(12,4) as locate_2
			FROM temp_go2epa a
			JOIN temp_go2epa b ON a.id=b.id-1 WHERE a.arc_id=b.arc_id 
			ORDER by arc_id)
			a group by arc_id) c
		WHERE temp_go2epa.arc_id = c.arc_id;

		
	RAISE NOTICE '6 - new arcs on temp_arc table';
	INSERT INTO temp_arc (arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, diameter, roughness, length, status, 
	the_geom, flw_code, minorloss, addparam, arcparent, dma_id, presszone_id, dqa_id, minsector_id)

	WITH a AS (SELECT  a.idmin, a.id, a.arc_id as arc_id, a.vnode_id as node_1, (a.locate)::numeric(12,4) as locate_1 ,
			b.vnode_id as node_2, (b.locate)::numeric(12,4) as locate_2
			FROM temp_go2epa a
			LEFT JOIN temp_go2epa b ON a.id=b.id-1 WHERE a.arc_id=b.arc_id 
			ORDER by arc_id)
	SELECT
		concat(arc_id,'P',a.id-a.idmin) as arc_id, 
		a.node_1,
		a.node_2,
		temp_arc.arc_type,
		temp_arc.arccat_id,
		temp_arc.epa_type,
		temp_arc.sector_id,
		temp_arc.state,
		temp_arc.state_type,
		temp_arc.annotation,
		temp_arc.diameter,
		temp_arc.roughness,
		st_length(ST_LineSubstring(the_geom, locate_1, locate_2)),
		temp_arc.status,		
		CASE 
			WHEN st_geometrytype(ST_LineSubstring(the_geom, locate_1, locate_2))='ST_LineString' THEN ST_LineSubstring(the_geom, locate_1, locate_2)
			ELSE null END AS the_geom,
		temp_arc.flw_code,
		0,
		temp_arc.addparam,
		a.arc_id, dma_id, presszone_id, dqa_id, minsector_id
		FROM a
		JOIN temp_arc USING (arc_id)
		WHERE (a.node_1 ilike 'VN%' OR a.node_2 ilike 'VN%')
		ORDER BY temp_arc.arc_id, a.id;


	RAISE NOTICE '7 - delete only trimmed arc on temp_arc table';
	-- step 1
	UPDATE temp_arc SET epa_type ='TODELETE' 
		FROM (SELECT DISTINCT arcparent AS arc_id FROM temp_arc WHERE arcparent !='') a
		WHERE a.arc_id = temp_arc.arc_id;
	-- step 2
	DELETE FROM temp_arc WHERE epa_type ='TODELETE';

	RAISE NOTICE '8 - set minimum value of arcs';
	UPDATE temp_arc SET length=0.01 WHERE length < 0.01;

	RAISE NOTICE '9 - delete those repeated vnodes when more than one link is sharing same vnode';
	-- step 1
	UPDATE temp_node SET epa_type ='TODELETE' FROM (SELECT a.id FROM temp_node a, temp_node b WHERE a.id < b.id AND a.node_id = b.node_id)a WHERE temp_node.id = a.id;
	-- step 2
	DELETE FROM temp_node WHERE epa_type ='TODELETE';
 
RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;