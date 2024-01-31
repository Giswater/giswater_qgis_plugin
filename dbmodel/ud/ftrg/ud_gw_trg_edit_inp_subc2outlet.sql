/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3300

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_inp_subc2outlet()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

DECLARE 

v_outlet_id text;
v_outlet_type text;
v_subc_id text;


BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	

	--grab closest node_id/subc_id to line endpoint
	SELECT node_id from v_edit_node n where st_dwithin (st_endpoint(new.the_geom), n.the_geom, 0.01) into v_outlet_id;
	SELECT subc_id from v_edit_inp_subcatchment s where st_dwithin (st_endpoint(new.the_geom), s.the_geom, 0.01) into v_subc_id;

	IF TG_OP = 'INSERT' THEN
		   
  			
  	   	IF v_outlet_id IS NOT NULL THEN
  	   		update v_edit_inp_subcatchment set outlet_id=v_outlet_id where subc_id=new.subc_id;
  	   	ELSE
  	   		--if there is no nearby node, use closest subcatchment
	   		IF v_subc_id is NOT null then
				update v_edit_inp_subcatchment set outlet_id=v_subc_id where subc_id=new.subc_id;
	   		ELSE
	   			execute 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},
				"feature":{},"data":{"message":"3252", "function":"3300","debug_msg":null, "variables":"value", "is_process":false}}$$);';
			END IF;		

	   	END IF; 

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' then
		IF v_outlet_id is not null then
			update v_edit_inp_subcatchment set outlet_id=v_outlet_id where subc_id=OLD.subc_id;
		else
			if v_subc_id is not null then
				update v_edit_inp_subcatchment set outlet_id=v_subc_id where subc_id=old.subc_id;
			ELSE
				execute 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},
				"feature":{},"data":{"message":"3252", "function":"3300","debug_msg":null, "variables":"value", "is_process":false}}$$);';
			END IF;
		END IF;
	
		RETURN NEW;
	
	
	ELSIF TG_OP = 'DELETE' then
		--only remove outlet_id value from subcatchment
		update v_edit_inp_subcatchment set outlet_id=NULL where subc_id=OLD.subc_id;
	
		RETURN NULL;
	
	END IF;
	

END;
$function$
; 