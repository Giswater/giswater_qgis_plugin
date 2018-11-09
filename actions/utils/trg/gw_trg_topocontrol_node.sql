/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 1136


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_topocontrol_node() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
 -- State control (permissions to work with state=2 and possibility to downgrade feature to state=0)
    PERFORM gw_fct_state_control('NODE', NEW.node_id, NEW.state, TG_OP);

RETURN NEW;
    
END; 
$$;


DROP TRIGGER IF EXISTS gw_trg_topocontrol_node ON "SCHEMA_NAME"."node";
CREATE TRIGGER gw_trg_topocontrol_node BEFORE INSERT OR UPDATE OF the_geom, "state" ON "SCHEMA_NAME"."node" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_topocontrol_node"();

