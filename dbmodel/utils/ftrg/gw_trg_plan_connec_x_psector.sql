/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2936

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_plan_psector_x_connec()
  RETURNS trigger AS
$BODY$
DECLARE 
    v_stateaux smallint;	
    v_arcaux text;	


BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- control if connect has link
	IF TG_OP = 'INSERT' AND (SELECT link_id FROM link WHERE feature_id = NEW.connec_id) IS NULL THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
         "data":{"message":"3138", "function":"2936","debug_msg":null}}$$);';
	END IF;

	IF TG_OP = 'INSERT' OR  TG_OP = 'UPDATE' THEN
		SELECT connec.state, connec.arc_id INTO v_stateaux, v_arcaux FROM connec WHERE connec_id=NEW.connec_id;
			
		IF NEW.state IS NULL THEN
			NEW.state=0;
		END IF;
		
		IF NEW.state = 1 AND v_stateaux = 1 THEN
			NEW.doable=false;
			-- looking for arc_id state=2 closest
		
		ELSIF NEW.state = 0 AND v_stateaux=1 THEN
			NEW.doable=false;
			NEW.arc_id=v_arcaux;
			
		ELSIF v_stateaux=2 THEN
			NEW.state=1;
			NEW.doable=true;
			-- looking for arc_id state=2 closest
		END IF;

		RETURN NEW;
	ELSIF TG_OP = 'DELETE' THEN
		IF (SELECT count(psector_id) FROM plan_psector_x_connec JOIN connec USING (connec_id) WHERE connec.state = 2 AND connec_id = OLD.connec_id) = 1 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
	         "data":{"message":"3160", "function":"2936","debug_msg":'||OLD.psector_id||'}}$$);';
	    END IF;

	    RETURN OLD;
	END IF;

END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
