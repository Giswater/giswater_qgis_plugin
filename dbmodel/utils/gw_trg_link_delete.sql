/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_link_delete() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 

    
BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    -- Delete vnodes
    
            DELETE FROM vnode WHERE vnode_id = OLD.vnode_id;
    
    RETURN OLD;

END;
$$;


CREATE TRIGGER gw_trg_link_delete AFTER DELETE ON "SCHEMA_NAME"."link" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_link_delete"();

