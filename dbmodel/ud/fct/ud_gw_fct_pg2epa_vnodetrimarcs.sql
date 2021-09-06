/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3070


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_vnodetrimarcs(result_id_var character varying)  RETURNS json AS 
$BODY$

--SELECT link_id, vnode_id FROM SCHEMA_NAME.link, SCHEMA_NAME.vnode where st_dwithin(st_endpoint(link.the_geom), vnode.the_geom, 0.01) and vnode.state = 0 and link.state > 0

/*
SELECT SCHEMA_NAME.gw_fct_pg2epa_vnodetrimarcs('r1')
*/

DECLARE
v_arc record;
v_arc2 record;
v_count integer = 0;
v_result integer = 0;
v_record record;
v_count2 integer = 0;
v_minlength float = 0;
v_keepnode text;
v_delnode text;
v_pointgeom public.geometry;
      
BEGIN
	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get parameters
	v_minlength := (SELECT value FROM config_param_user WHERE parameter = 'inp_options_minlength' AND cur_user = current_user);

	RAISE NOTICE 'Starting pg2epa vnode trim arcs ';
	TRUNCATE temp_go2epa;

	RAISE NOTICE '1 - arrange vnode';
	EXECUTE 'SELECT gw_fct_setvnoderepair($${
	"client":{"device":4, "infoType":1, "lang":"ES"},
	"feature":{},"data":{"parameters":{"fid":227}}}$$)';

	RAISE NOTICE '2 - insert data on temp_go2epa';
	INSERT INTO temp_go2epa (arc_id, vnode_id, locate, top_elev, ymax)
	SELECT  arc.arc_id, vnode_id, locate,
	(n1.sys_top_elev - locate*(n1.sys_top_elev-n2.sys_top_elev))::numeric(12,3),
	(CASE WHEN (n1.sys_ymax - locate*(n1.sys_ymax-n2.sys_ymax)) IS NULL THEN 0 ELSE (n1.sys_ymax - locate*(n1.sys_ymax-n2.sys_ymax)) END)::numeric (12,3) as depth
	FROM (
		SELECT  vnode_id, arc_id, locate
			FROM (
			SELECT node_1 as vnode_id, arc_id,  0 as locate FROM temp_arc
			)z
		UNION	
			-- real vnode coming from link
			SELECT distinct on (vnode_id) concat('VN',vnode_id) as vnode_id, 
			t.arc_id, 
			case 	
				when st_linelocatepoint (t.the_geom , vnode.the_geom) > 0.9999 then 0.9999
				when st_linelocatepoint (t.the_geom , vnode.the_geom) < 0.0001 then 0.0001
				else (st_linelocatepoint (t.the_geom , vnode.the_geom))::numeric(12,4) end as locate
			FROM temp_arc t, v_vnode AS vnode
			JOIN link a ON vnode_id=exit_id::integer
			JOIN gully ON gully_id = feature_id
			WHERE st_dwithin ( t.the_geom, vnode.the_geom, 0.01) AND vnode.state > 0 AND a.state > 0			
		UNION
			SELECT  vnode_id, arc_id, locate
			FROM (
			SELECT node_2 as vnode_id, arc_id,  1 as locate FROM temp_arc
			)z
		) a
	JOIN vu_arc arc USING (arc_id)
	JOIN vu_node n1 ON node_1 = node_id
	JOIN vu_node n2 ON node_2 = n2.node_id
	ORDER BY arc_id, locate;

	RAISE NOTICE 'new nodes on temp_node table ';
	INSERT INTO temp_node (node_id, top_elev, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, the_geom, addparam)
	SELECT 
		vnode_id as node_id, 
		CASE 
			WHEN g.top_elev IS NULL THEN t.top_elev::numeric(12,3) -- top_elev it's interpolated top_elev againts node1 and node2 of pipe
			ELSE g.top_elev END as top_elev,
		CASE	WHEN g.top_elev IS NULL THEN t.top_elev::numeric(12,3) - t.ymax::numeric(12,3)-- elev it's interpolated using top_elev-depth againts node1 and node2 of pipe
			ELSE g.top_elev - g.ymax END as elev,
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
		JOIN temp_arc a USING (arc_id)
		JOIN v_gully g ON concat('VN',pjoint_id)=vnode_id
		WHERE vnode_id ilike 'VN%';

	RAISE NOTICE '3 - update temp_table to work with next process';
	UPDATE temp_go2epa SET idmin = c.idmin FROM
	(SELECT min(id) as idmin, arc_id FROM (
		SELECT  a.id, a.arc_id as arc_id, a.vnode_id as node_1, (a.locate)::numeric(12,4) as locate_1 ,
			b.vnode_id as node_2, (b.locate)::numeric(12,4) as locate_2
			FROM temp_go2epa a
			JOIN temp_go2epa b ON a.id=b.id-1 WHERE a.arc_id=b.arc_id 
			ORDER by arc_id)
			a group by arc_id) c
		WHERE temp_go2epa.arc_id = c.arc_id;

		
	RAISE NOTICE '4 - new arcs on temp_arc table';
	INSERT INTO temp_arc (arc_id, flw_code, node_1, node_2, elevmax1, elevmax2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, n, length,
	the_geom, expl_id, minorloss, addparam, arcparent, q0, qmax, barrels, slope)

	WITH a AS (SELECT  a.idmin, a.id, a.arc_id as arc_id, a.vnode_id as node_1, (a.locate)::numeric(12,4) as locate_1 ,
			b.vnode_id as node_2, (b.locate)::numeric(12,4) as locate_2
			FROM temp_go2epa a
			LEFT JOIN temp_go2epa b ON a.id=b.id-1 WHERE a.arc_id=b.arc_id 
			ORDER by arc_id)
	SELECT
		concat(arc_id,'P',a.id-a.idmin) as arc_id, 
		temp_arc.flw_code,
		a.node_1,
		a.node_2,
		temp_arc.elevmax1,
		temp_arc.elevmax2,
		temp_arc.arc_type,
		temp_arc.arccat_id,
		temp_arc.epa_type,
		temp_arc.sector_id,
		temp_arc.state,
		temp_arc.state_type,
		temp_arc.annotation,
		temp_arc.n,
		st_length(ST_LineSubstring(the_geom, locate_1, locate_2)),
		CASE 
			WHEN st_geometrytype(ST_LineSubstring(the_geom, locate_1, locate_2))='ST_LineString' THEN ST_LineSubstring(the_geom, locate_1, locate_2)
			ELSE null END AS the_geom,
		expl_id,
		minorloss,
		addparam,
		arc_id,
		q0,
		qmax,
		barrels,
		slope
		FROM a
		JOIN temp_arc USING (arc_id)
		WHERE (a.node_1 ilike 'VN%' OR a.node_2 ilike 'VN%')
		ORDER BY temp_arc.arc_id, a.id;


	RAISE NOTICE '5 - delete only trimmed arc on temp_arc table';
	-- step 1
	UPDATE temp_arc SET epa_type ='TODELETE' 
		FROM (SELECT DISTINCT arcparent AS arc_id FROM temp_arc WHERE arcparent !='') a
		WHERE a.arc_id = temp_arc.arc_id;
	-- step 2
	DELETE FROM temp_arc WHERE epa_type ='TODELETE';

	RAISE NOTICE '6 - delete those repeated vnodes when more than one link is sharing same vnode';
	-- step 1
	UPDATE temp_node SET epa_type ='TODELETE' FROM (SELECT a.id FROM temp_node a, temp_node b WHERE a.id < b.id AND a.node_id = b.node_id)a WHERE temp_node.id = a.id;
	-- step 2
	DELETE FROM temp_node WHERE epa_type ='TODELETE';

	RAISE NOTICE '7 - set minimum value of arcs';
	IF v_minlength > 0 THEN	
	
		FOR v_arc IN SELECT arc_id, node_1, node_2 FROM temp_arc where length < v_minlength
		LOOP
			-- get nodes to be fusioned
			IF v_arc.node_1 LIKE 'VN%' THEN
				v_delnode = v_arc.node_1;
				v_keepnode = v_arc.node_2;
				
			ELSIF v_arc.node_2 LIKE 'VN%' THEN
				v_delnode = v_arc.node_2;
				v_keepnode = v_arc.node_1;
			ELSE
				v_delnode = null;
				v_keepnode = null;
			END IF;
	
			-- fusion process
			IF v_keepnode IS NOT NULL THEN

				-- keep traceability on temp node;
				UPDATE temp_node SET fusioned_node = v_delnode WHERE node_id = v_keepnode;
				
				UPDATE temp_arc SET node_1 = v_keepnode WHERE node_1 = v_delnode;
				UPDATE temp_arc SET node_2 = v_keepnode WHERE node_2 = v_delnode;

				-- get value of keeped node geometry
				SELECT the_geom INTO v_pointgeom FROM temp_node WHERE node_id = v_keepnode;

				-- enlarge arcs
				FOR v_arc2 IN SELECT arc_id, node_1, node_2 FROM temp_arc WHERE (node_1 = v_keepnode OR node_2 = v_keepnode)
				LOOP
					UPDATE temp_arc SET the_geom=ST_SetPoint(the_geom,0, v_pointgeom) WHERE arc_id = v_arc2.arc_id AND node_1 = v_keepnode;
					UPDATE temp_arc SET the_geom=ST_SetPoint(the_geom, ST_NumPoints(the_geom)-1, v_pointgeom) WHERE arc_id = v_arc2.arc_id AND node_2 = v_keepnode;
				END LOOP;
	
				-- delete features
				DELETE FROM temp_node WHERE node_id = v_delnode;
				DELETE FROM temp_arc WHERE arc_id = v_arc.arc_id;
	
				UPDATE temp_gully SET pjoint_id = v_keepnode WHERE pjoint_id = v_delnode;
			END IF;		
		END LOOP;
	END IF;

RETURN v_result;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;