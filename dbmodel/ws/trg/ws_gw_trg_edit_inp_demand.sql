/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


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
       -- PERFORM audit_function(160,370); 
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

        --PERFORM audit_function(2,370); 
        RETURN NEW;
        
    ELSIF TG_OP = 'DELETE' THEN
        --PERFORM audit_function(163,370); 
        RETURN NEW;
    
    END IF;
       
END;
$$;

*/

DROP TRIGGER IF EXISTS gw_trg_edit_inp_demand ON "SCHEMA_NAME".v_edit_inp_demand;
CREATE TRIGGER gw_trg_edit_inp_demand INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_demand
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_demand();
  
  