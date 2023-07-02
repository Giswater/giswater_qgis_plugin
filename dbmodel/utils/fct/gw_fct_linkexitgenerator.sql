/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2994

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_vnode_repair();
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_vnode_repair(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_linkexitgenerator(p_input integer)
RETURNS integer AS
$BODY$

/*EXAMPLE

SELECT  gw_fct_linkexitgenerator(1);

*/

DECLARE

v_link record;
v_id integer;
v_version text;
v_projecttype text;
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
	SELECT project_type, giswater  INTO v_projecttype, v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	
	-- insert features temp_link
	INSERT INTO temp_link SELECT link_id, link_id, exit_type, feature_id, feature_type, exit_id, exit_type, state, expl_id, sector_id, dma_id, exit_topelev, exit_elev, the_geom, st_endpoint(the_geom), false
	FROM v_edit_link;

	-- insert duplicated features on temp_vnode
	INSERT INTO temp_vnode (l1,v1,l2,v2)
	SELECT n1.link_id as l1, n1.vnode_id as v1, n2.link_id as l2, n2.vnode_id as v2 FROM temp_link n1, temp_link n2 WHERE st_dwithin(n1.the_geom_endpoint, n2.the_geom_endpoint, 0.02)
	AND n1.link_id != n2.link_id  ORDER BY 1; 
	
	-- harmonize those links with same endpoint
	FOR v_links IN SELECT * FROM temp_vnode order by 1
	LOOP	
		raise notice ' % ', v_links;
		UPDATE temp_link a SET vnode_id = t.vnode_id, flag=true FROM temp_link t WHERE a.link_id = v_links.l1 AND t.link_id = v_links.l2 AND a.flag is false;					
	END LOOP;
	
	DELETE FROM temp_vnode;
	INSERT INTO temp_vnode (l1,v1,l2,v2)
	SELECT n1.link_id , n1.vnode_id , n2.node_id::integer, n2.node_id::integer FROM temp_link n1, temp_node n2 WHERE st_dwithin(n1.the_geom_endpoint, n2.the_geom, 0.01) 
	AND concat('VN',vnode_id) != node_id ORDER BY 3; 

	-- harmonize those links with same endpoint whith node
	FOR v_links IN SELECT l1,v1, v2 FROM temp_vnode order by 1
	LOOP	
		raise notice ' ----------% ', v_links;
		UPDATE temp_link a SET vnode_id = v_links.v2, vnode_type = 'NODE' WHERE link_id = v_links.l1;
	END LOOP;

	--  Return
	RETURN 0;
    
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
