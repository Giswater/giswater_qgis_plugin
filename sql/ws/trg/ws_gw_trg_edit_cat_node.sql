/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2458


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_cat_node()  RETURNS trigger AS
$BODY$
DECLARE 
	
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	IF NEW.nodetype_id='TANK' THEN 	
		NEW.cost_unit='m3';
	END IF;

RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
    
DROP TRIGGER IF EXISTS gw_trg_edit_cat_node ON "SCHEMA_NAME".cat_node;
CREATE TRIGGER gw_trg_edit_cat_node BEFORE INSERT OR UPDATE ON 
"SCHEMA_NAME".cat_node FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_cat_node();

