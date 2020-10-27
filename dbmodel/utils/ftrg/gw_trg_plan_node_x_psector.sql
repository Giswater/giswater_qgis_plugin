/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1132

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_plan_psector_x_node()
  RETURNS trigger AS
$BODY$
DECLARE 


    v_stateaux smallint;

BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    IF TG_OP = 'INSERT' OR  TG_OP = 'UPDATE ' THEN
		SELECT node.state INTO v_stateaux FROM node WHERE node_id=NEW.node_id;
			IF v_stateaux=1	THEN 
				NEW.state=0;
				NEW.doable=false;
			ELSIF v_stateaux=2 THEN
				NEW.state=1;
				NEW.doable=true;
			END IF;

		RETURN NEW;
		
	ELSIF TG_OP = 'DELETE' THEN
		IF (SELECT count(psector_id) FROM plan_psector_x_node JOIN node USING (node_id) WHERE node.state = 2 AND node_id = OLD.node_id) = 1 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
	         "data":{"message":"3160", "function":"1130","debug_msg":'||OLD.psector_id||'}}$$);';
	    END IF;

	    RETURN OLD;
	END IF;

END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;