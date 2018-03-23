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
edit_arc_division_dsbl_aux boolean;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	SELECT value::boolean INTO edit_arc_division_dsbl_aux FROM config_param_user WHERE "parameter"='edit_arc_division_dsbl' AND cur_user=current_user;


--  Only enabled on insert
	IF TG_OP = 'INSERT' AND edit_arc_division_dsbl_aux IS NOT TRUE THEN

		SELECT * INTO rec FROM config;
	
		SELECT arc_id INTO arc_id_aux FROM v_edit_arc WHERE ST_intersects((NEW.the_geom), St_buffer(v_edit_arc.the_geom,rec.node_proximity)) AND NEW.state>0 LIMIT 1;
		IF arc_id_aux IS NOT NULL THEN
			PERFORM gw_fct_arc_divide(NEW.node_id);	
		END IF;	

   	END IF;

RETURN NEW;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  
DROP TRIGGER IF EXISTS gw_trg_node_arc_divide ON "SCHEMA_NAME".node;
CREATE TRIGGER gw_trg_node_arc_divide AFTER INSERT ON "SCHEMA_NAME".node FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_node_arc_divide();

