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
v_minlength float;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	flw_type_aux= TG_ARGV[0];

	v_minlength := (SELECT value FROM config_param_user WHERE parameter = 'inp_options_minlength' AND cur_user = current_user);
	
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
	
	IF (NEW.flwreg_length + v_minlength) >= (SELECT st_length(v_edit_arc.the_geom) FROM v_edit_arc WHERE arc_id=NEW.to_arc) THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3048", "function":"2420","debug_msg":null}}$$);';
	END IF;
	
	-- flowreg_id
	IF NEW.flwreg_id IS NULL THEN
		EXECUTE 'SELECT COUNT(*) FROM inp_flwreg_'||flw_type_aux||' WHERE to_arc='||quote_literal(NEW.to_arc)||' AND node_id='||quote_literal(NEW.node_id) INTO  NEW.flwreg_id;
		NEW.flwreg_id=NEW.flwreg_id+1;
	END IF;

	-- specific flow regulators
	IF flw_type_aux  = 'orifice' THEN
		IF NEW.ori_type IS NULL THEN
			NEW.ori_type = (SELECT ((value::json->>'parameters')::json->>'orifice')::json->>'oriType' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
		END IF;
		IF NEW.shape IS NULL  THEN
			NEW.shape = (SELECT ((value::json->>'parameters')::json->>'orifice')::json->>'shape' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
		END IF;
		IF NEW.cd IS NULL  THEN
			NEW.cd = (SELECT ((value::json->>'parameters')::json->>'orifice')::json->>'cd' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
		END IF;
		IF NEW.flap IS NULL  THEN
			NEW.flap = (SELECT ((value::json->>'parameters')::json->>'orifice')::json->>'flap' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
		END IF;
		IF NEW.geom1 IS NULL THEN
			NEW.geom1 = (SELECT ((value::json->>'parameters')::json->>'orifice')::json->>'geom1' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
		END IF;
		
	ELSIF flw_type_aux  = 'weir' THEN
		IF NEW.weir_type IS NULL THEN
			NEW.weir_type = (SELECT ((value::json->>'parameters')::json->>'weir')::json->>'weirType' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
		END IF;
		IF NEW.cd IS NULL THEN
			NEW.cd = (SELECT ((value::json->>'parameters')::json->>'weir')::json->>'cd' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
		END IF;
		IF NEW.ec IS NULL  THEN
			NEW.ec = (SELECT ((value::json->>'parameters')::json->>'weir')::json->>'ec' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
		END IF;
		IF NEW.cd2 IS NULL  THEN
			NEW.cd2 = (SELECT ((value::json->>'parameters')::json->>'weir')::json->>'cd2' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
		END IF;
		IF NEW.flap IS NULL  THEN
			NEW.flap = (SELECT ((value::json->>'parameters')::json->>'weir')::json->>'flap' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
		END IF;
		IF NEW.geom1 IS NULL THEN
			NEW.geom1 = (SELECT ((value::json->>'parameters')::json->>'weir')::json->>'geom1' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
		END IF;
		IF NEW.geom2 IS NULL THEN
			NEW.geom2 = (SELECT ((value::json->>'parameters')::json->>'weir')::json->>'geom2' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
		END IF;
	
	ELSIF flw_type_aux  = 'outlet' THEN
		IF NEW.outlet_type IS NULL THEN
			NEW.outlet_type = (SELECT ((value::json->>'parameters')::json->>'outlet')::json->>'outletType' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
		END IF;
		IF NEW.cd1 IS NULL THEN
			NEW.cd1 = (SELECT ((value::json->>'parameters')::json->>'outlet')::json->>'cd1' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
		END IF;
		IF NEW.cd2 IS NULL  THEN
			NEW.cd2 = (SELECT ((value::json->>'parameters')::json->>'outlet')::json->>'cd2' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
		END IF;
		IF NEW.flap IS NULL  THEN
			NEW.flap = (SELECT ((value::json->>'parameters')::json->>'outlet')::json->>'flap' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user = current_user);
		END IF;

	ELSIF flw_type_aux  = 'pump' THEN
	
	END IF;

	RETURN NEW;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
