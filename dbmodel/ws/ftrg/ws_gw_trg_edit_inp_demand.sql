/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1308


-----------------------------
-- TRIGGERS EDITING VIEWS FOR NODE
-----------------------------

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_inp_demand() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 

    node_table varchar;
    man_table varchar;
    epa_type varchar;
    v_sql varchar;
    old_nodetype varchar;
    new_nodetype varchar;    


	
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

   
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
				INSERT INTO inp_demand (id, demand, pattern_id, deman_type, dscenario_id) 
				VALUES (NEW.id,NEW.demand, NEW.pattern_id, NEW.deman_type, NEW.dscenario_id);
				RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
				UPDATE inp_demand SET id=NEW.id, demand=NEW.demand, pattern_id=NEW.pattern_id, deman_type=NEW.deman_type, dscenario_id=NEW.dscenario_id
				WHERE id=OLD.id;
        
    ELSIF TG_OP = 'DELETE' THEN
				RETURN NEW;
    
    END IF;
       
END;
$$;
  