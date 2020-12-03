/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2994

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_vnode_repair() 
RETURNS integer AS
$BODY$

/*
SELECT  SCHEMA_NAME.gw_fct_vnode_repair()

select * from SCHEMA_NAME.connec
select * from SCHEMA_NAME.link
select * from SCHEMA_NAME.vnode
*/


DECLARE 

v_project_type text;
v_link record;
v_id integer;

BEGIN 

	SET search_path=SCHEMA_NAME, public;

	v_project_type = (SELECT project_type FROM sys_version LIMIT 1);

	
	-- create vnode
	FOR v_link IN SELECT l.* FROM v_edit_link l LEFT JOIN vnode v ON vnode_id = exit_id::integer where l.exit_type ='VNODE' AND vnode_id IS NULL
	LOOP 
		INSERT INTO vnode (state, the_geom) VALUES (v_link.state, st_endpoint(v_link.the_geom)) RETURNING vnode_id INTO v_id;
		UPDATE link SET exit_id = v_id WHERE link_id = v_link.link_id;
		UPDATE connec SET pjoint_id = v_id, pjoint_type = 'VNODE' WHERE connec_id = v_link.feature_id AND feature_type = 'CONNEC';
		IF v_project_type = 'UD' THEN
			UPDATE gully SET pjoint_id = v_id, pjoint_type = 'VNODE' WHERE gully_id = v_link.feature_id AND feature_type = 'GULLY';
		END IF;
	END LOOP;
	
RETURN 0;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
