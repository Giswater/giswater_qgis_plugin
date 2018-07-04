/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1346

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_node_rotation_update()
  RETURNS trigger AS
$BODY$
DECLARE 
    rec_arc Record; 
    rec_node Record; 
    hemisphere_rotation_bool boolean;
    hemisphere_rotation_aux float;
    ang_aux float;
    count int2;
    azm_aux float;
    rec_config record;
    connec_id_aux text;
    array_agg text[];
        
BEGIN 

-- The goal of this function is to update automatic rotation node values using the hemisphere values when the variable
-- edit_noderotation_update_dissbl is TRUE

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	IF (SELECT value::boolean FROM config_param_user WHERE parameter='edit_noderotation_update_dissbl' AND cur_user=current_user) IS TRUE THEN 

    		UPDATE node SET rotation=NEW.hemisphere WHERE node_id=NEW.node_id;
					
	END IF;

	RETURN NEW;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  


DROP TRIGGER IF EXISTS gw_trg_node_rotation_update ON "SCHEMA_NAME".node;
CREATE TRIGGER gw_trg_node_rotation_update  AFTER INSERT OR UPDATE OF hemisphere ON "SCHEMA_NAME".node
FOR EACH ROW  EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_node_rotation_update();
