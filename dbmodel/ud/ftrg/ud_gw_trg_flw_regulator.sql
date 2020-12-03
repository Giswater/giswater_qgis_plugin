/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2420

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_flw_regulator() 
RETURNS trigger AS 
$BODY$
DECLARE 
flw_type_aux text;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    flw_type_aux= TG_ARGV[0];
	
	-- check to_arc only to that arcs that have node_1 as the flowregulator node
	IF NEW.to_arc IS NULL THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"2070", "function":"2420","debug_msg":null}}$$);';
	END IF;

	-- flwreg_length
	IF NEW.flwreg_length IS NULL THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"2074", "function":"2420","debug_msg":null}}$$);';
	END IF;
	
	IF (NEW.flwreg_length)>(SELECT st_length(v_edit_arc.the_geom) FROM v_edit_arc WHERE arc_id=NEW.to_arc) THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3048", "function":"2420","debug_msg":null}}$$);';
	END IF;
	
	-- flowreg_id
	IF NEW.flwreg_id IS NULL THEN
		EXECUTE 'SELECT COUNT(*) FROM inp_flwreg_'||flw_type_aux||' WHERE to_arc='||quote_literal(NEW.to_arc)||' AND node_id='||quote_literal(NEW.node_id) INTO  NEW.flwreg_id;
		NEW.flwreg_id=NEW.flwreg_id+1;
	END IF;

RETURN NEW;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
