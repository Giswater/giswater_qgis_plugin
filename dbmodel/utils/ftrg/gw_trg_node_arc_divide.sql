/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1146

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_node_arc_divide()
  RETURNS trigger AS
$BODY$
DECLARE 

rec record;
arc_id_aux varchar;
node_id_aux varchar;
edit_arc_division_dsbl_aux boolean;
v_project_type varchar;
v_isarcdivide boolean;
v_node_proximity double precision;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	v_project_type = (SELECT project_type FROM sys_version LIMIT 1);

	-- get node type arc division config
	IF v_project_type = 'UD' THEN
		SELECT isarcdivide INTO v_isarcdivide FROM cat_feature_node WHERE NEW.node_type=id;   
	ELSE
		SELECT isarcdivide INTO v_isarcdivide FROM cat_node
			JOIN cat_feature_node ON cat_node.nodetype_id=cat_feature_node.id
			WHERE NEW.nodecat_id=cat_node.id;
	END IF;

	IF v_isarcdivide IS NULL THEN 
		SELECT value::boolean INTO edit_arc_division_dsbl_aux FROM config_param_user WHERE "parameter"='edit_arc_division_dsbl' AND cur_user=current_user;
	ELSIF v_isarcdivide IS TRUE THEN
		edit_arc_division_dsbl_aux = FALSE;	
	ELSIF v_isarcdivide IS FALSE THEN 
		edit_arc_division_dsbl_aux = TRUE;
	END IF;
	

	--  Only enabled on insert
	IF TG_OP = 'INSERT' AND edit_arc_division_dsbl_aux IS NOT TRUE THEN

		SELECT ((value::json)->>'value') INTO v_node_proximity FROM config_param_system WHERE parameter='edit_node_proximity';

		-- get if another node exists
		SELECT node_id INTO node_id_aux FROM node JOIN v_edit_node USING (node_id) WHERE st_dwithin((NEW.the_geom), node.the_geom, v_node_proximity) AND NEW.node_id != node_id LIMIT 1;
		
		IF node_id_aux IS NULL THEN

			SELECT arc_id INTO arc_id_aux FROM arc JOIN v_edit_arc USING (arc_id) WHERE st_dwithin((NEW.the_geom), arc.the_geom, v_node_proximity) LIMIT 1;
			IF arc_id_aux IS NOT NULL THEN
				EXECUTE 'SELECT gw_fct_setarcdivide($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":["'||NEW.node_id||'"]},"data":{}}$$)';
			END IF;	
		END IF;

   	END IF;

RETURN NEW;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

