/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1130

 
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_plan_arc_x_psector()
  RETURNS trigger AS
$BODY$
DECLARE 
    featurecat_aux text;
    psector_vdefault_var integer;
    insert_into_psector_aux integer;
    node_1_aux varchar;
    node_2_aux varchar;
    arc_geom_aux public.geometry;

BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	SELECT the_geom INTO arc_geom_aux FROM v_edit_arc WHERE arc_id=NEW.arc_id;
	
	-- Lookig for extremal nodes
	SELECT gw_fct_state_searchnodes(NEW.arc_id, 2, 'StartPoint'::varchar, arc_geom_aux, 'UPDATE') INTO node_1_aux;
	SELECT gw_fct_state_searchnodes(NEW.arc_id, 2, 'EndPoint'::varchar, arc_geom_aux, 'UPDATE') INTO node_2_aux;
	
	IF (node_1_aux IS NULL or node_2_aux IS NULL) THEN 
		PERFORM audit_function(2018,1130);
	ELSE 
		--PERFORM audit_function(2018,1130);
	END IF;

RETURN NEW;

END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

DROP TRIGGER IF EXISTS gw_trg_plan_arc_x_psector ON "SCHEMA_NAME"."plan_arc_x_psector";
CREATE TRIGGER gw_trg_plan_arc_x_psector AFTER UPDATE OF psector_id ON "SCHEMA_NAME"."plan_arc_x_psector" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_plan_arc_x_psector"();


