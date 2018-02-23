/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2442

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_node_arc_divide()
  RETURNS trigger AS
$BODY$
DECLARE 

rec record;
arc_id_aux varchar;
arcdivide_auto_control_aux boolean;
arcdivide_tolerance_aux float;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	

--  Only enabled on insert
	IF TG_OP = 'INSERT' THEN

		SELECT value INTO arcdivide_auto_control_aux FROM config_param_system WHERE parameter='edit_arc_divide_automatic_control';
		SELECT node_proximity INTO arcdivide_tolerance_aux FROM config;

	
		SELECT arc_id INTO arc_id_aux FROM v_edit_arc WHERE ST_DWithin(NEW.the_geom, v_edit_arc.the_geom, arcdivide_tolerance_aux) AND NEW.state>0 LIMIT 1;
		IF arc_id_aux IS NOT NULL AND (arcdivide_auto_control_aux IS TRUE OR arcdivide_auto_control_aux IS FALSE) THEN
			PERFORM gw_fct_arc_divide(NEW.node_id);	

		END IF;	

   	END IF;

RETURN NEW;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_trg_node_arc_divide()
  OWNER TO postgres;



drop trigger IF EXISTS gw_trg_node_arc_divide ON SCHEMA_NAME.node;
  CREATE TRIGGER gw_trg_node_arc_divide   AFTER INSERT  ON SCHEMA_NAME.node
    FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_node_arc_divide();
    