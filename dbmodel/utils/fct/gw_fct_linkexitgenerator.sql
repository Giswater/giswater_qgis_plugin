/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2994

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_vnode_repair();
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_vnode_repair(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_linkexitgenerator(p_input integer)
RETURNS integer AS
$BODY$

/*EXAMPLE

SELECT  gw_fct_linkexitgenerator(1);

p_input = 1 go2epa
p_input = 2 profiletool


*/

DECLARE

	v_link record;
	v_id integer;
	v_version text;
	v_project_type text;
	v_tolerance double precision = 0.02;
	v_links record;
	v_links_2 record;
	v_geom public.geometry;
	v_loop record;
	v_node record;
	v_end_point public.geometry;

BEGIN

	SET search_path= 'SCHEMA_NAME','public';

	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- insert features temp_link
	INSERT INTO temp_link (link_id, vnode_id, vnode_type, feature_id, feature_type, exit_id, exit_type, state, expl_id,
	sector_id, exit_topelev, exit_elev, the_geom, the_geom_endpoint, flag) 
	SELECT link_id, link_id, exit_type, feature_id, feature_type, exit_id, exit_type, state, expl_id,
	sector_id, top_elev2, elevation2, the_geom, st_endpoint(the_geom), false FROM ve_link where exit_type = 'ARC' AND state > 0;

	IF v_project_type = 'WS' THEN
		UPDATE temp_link SET omzone_id=l.omzone_id, dma_id = l.dma_id, supplyzone_id = l.supplyzone_id FROM ve_link l WHERE temp_link.link_id = l.link_id AND l.exit_type = 'ARC';
	END IF;

	INSERT INTO temp_link (link_id, vnode_id, vnode_type, feature_id, feature_type, exit_id, exit_type, state, expl_id,
	sector_id, exit_topelev, exit_elev, the_geom, the_geom_endpoint, flag) 
	SELECT link_id, exit_id, exit_type, feature_id, feature_type, exit_id, exit_type, state, expl_id,
	sector_id, top_elev2, elevation2, the_geom, st_endpoint(the_geom), false FROM ve_link where exit_type IN ('NODE', 'CONNEC');

	IF v_project_type = 'WS' THEN
		UPDATE temp_link SET omzone_id=l.omzone_id, dma_id = l.dma_id, supplyzone_id = l.supplyzone_id FROM ve_link l WHERE temp_link.link_id = l.link_id AND l.exit_type IN ('NODE', 'CONNEC');
	END IF;

	-- insert duplicated features on temp_vnode
	IF p_input = 1 THEN -- the whole ve_link
		INSERT INTO temp_vnode (l1,v1,l2,v2)
		SELECT n1.link_id AS l1, n1.vnode_id AS v1, n2.link_id AS l2, n2.vnode_id AS v2 FROM temp_link n1, temp_link n2
		WHERE st_dwithin(n1.the_geom_endpoint, n2.the_geom_endpoint, 0.02)
		AND n1.link_id < n2.link_id AND n1.exit_id = n2.exit_id ORDER BY 1;
	ELSIF p_input = 2 THEN -- only those links wich are on arcs present on temp_anl_arc and nodes present temp_anl_node
		INSERT INTO temp_vnode (l1,v1,l2,v2)
		SELECT n1.link_id AS l1, n1.vnode_id AS v1, n2.link_id AS l2, n2.vnode_id AS v2 FROM temp_link n1, temp_link n2
		WHERE st_dwithin(n1.the_geom_endpoint, n2.the_geom_endpoint, 0.02)
		AND n1.link_id < n2.link_id
		AND n1.feature_id IN (SELECT arc_id FROM temp_anl_arc UNION SELECT node_id FROM temp_anl_node)
		AND n1.exit_id = n2.exit_id ORDER BY 1;
	END IF;

	-- harmonize those links with same endpoint
	UPDATE temp_link a 
	SET vnode_id = t.vnode_id, flag=true
	FROM temp_vnode v
	JOIN temp_link t ON t.link_id = v.l2
	WHERE a.link_id = v.l1; 

	truncate temp_vnode;
	INSERT INTO temp_vnode (l1,v1,l2,v2)
	SELECT n1.link_id, n1.vnode_id, n2.node_id::integer, n2.node_id::integer FROM temp_link n1, temp_node n2 JOIN arc ON node_id::integer = node_1::integer
	WHERE st_dwithin(n1.the_geom_endpoint, n2.the_geom, 0.01) AND arc_id::integer = exit_id::integer AND exit_type = 'ARC' ORDER BY 3;

	INSERT INTO temp_vnode (l1,v1,l2,v2)
	SELECT n1.link_id, n1.vnode_id, n2.node_id::integer, n2.node_id::integer FROM temp_link n1, temp_node n2 JOIN arc ON node_id::integer = node_2::integer
	WHERE st_dwithin(n1.the_geom_endpoint, n2.the_geom, 0.01) AND arc_id::integer = exit_id::integer AND exit_type = 'ARC' ORDER BY 3;


	-- harmonize those links with same endpoint whith node
	UPDATE temp_link a 
	SET vnode_id = v.v2, vnode_type = 'NODE'
	FROM temp_vnode v
	WHERE a.link_id = v.l1;

	--  Return
	RETURN 0;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
