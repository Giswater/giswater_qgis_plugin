/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1312


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_macrodma()
  RETURNS trigger AS
$BODY$
DECLARE 

   
	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	
	
    IF TG_OP = 'INSERT' THEN
        				
	--Exploitation ID
	IF NEW.expl_id IS NULL THEN 
            IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
                EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
       			"data":{"message":"1110", "function":"1312","debug_msg":null}}$$);';
				RETURN NULL;				
            END IF;
            NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom, 0.001) LIMIT 1);
            IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_exploitation_vdefault' AND "cur_user"="current_user"());
            END IF;
       END IF;
        
        -- FEATURE INSERT
	INSERT INTO macrodma (macrodma_id, name, descript, the_geom, undelete, expl_id)
	VALUES (NEW.macrodma_id, NEW.name, NEW.descript, NEW.the_geom, NEW.undelete, NEW.expl_id);
				
	RETURN NEW;
		
          
    ELSIF TG_OP = 'UPDATE' THEN

	UPDATE macrodma 
	SET macrodma_id=NEW.macrodma_id, name=NEW.name, descript=NEW.descript, the_geom=NEW.the_geom, undelete=NEW.undelete,expl_id=NEW.expl_id
	WHERE macrodma_id=NEW.macrodma_id;
		
        RETURN NEW;

     ELSIF TG_OP = 'DELETE' THEN  		
			
	DELETE FROM macrodma WHERE macrodma_id=OLD.macrodma_id;
	
        RETURN NULL;
     
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

