/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2924

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_dqa()  RETURNS trigger AS
$BODY$

DECLARE 
	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
    IF TG_OP = 'INSERT' THEN
		
		--Exploitation ID
        IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
            -- PERFORM gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        	 -- "data":{"message":"1012", "function":"1112","debug_msg":null, "variables":null}}$$); 
			RETURN NULL;				
            END IF;
            expl_id_int := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
            IF (expl_id_int IS NULL) THEN
                 -- PERFORM gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        	 -- "data":{"message":"1014", "function":"1112","debug_msg":null, "variables":null}}$$); 
				RETURN NULL; 
            END IF;
			
		INSERT INTO dqa (dqa_id, name, expl_id, macrodqa_id, descript, undelete, the_geom, pattern_id, dqa_type, link, grafconfig, stylesheet)
		VALUES (NEW.dqa_id, NEW.name, expl_id_int, NEW.macrodqa_id, NEW.descript, NEW.undelete, NEW.the_geom, NEW.pattern_id, NEW.dqa_type, 
		NEW.link, NEW.grafconfig::json, NEW.stylesheet::json);

		RETURN NEW;
		
    ELSIF TG_OP = 'UPDATE' THEN
   	
		UPDATE dqa 
		SET dqa_id=NEW.dqa_id, name=NEW.name, expl_id=NEW.expl_id, macrodqa_id=NEW.macrodqa_id, descript=NEW.descript, undelete=NEW.undelete, 
		the_geom=NEW.the_geom, pattern_id=NEW.pattern_id, dqa_type=NEW.dqa_type, link=NEW.link, grafconfig=NEW.grafconfig::json, stylesheet = NEW.stylesheet::json
		WHERE dqa_id=NEW.dqa_id;
		
		RETURN NEW;
		
    ELSIF TG_OP = 'DELETE' THEN  
	 
		DELETE FROM dqa WHERE dqa_id = OLD.dqa_id;		
		RETURN NULL;
     
	END IF;

END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


