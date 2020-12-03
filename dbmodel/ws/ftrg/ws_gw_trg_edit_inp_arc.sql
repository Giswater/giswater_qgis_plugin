/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1306


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_inp_arc() 
RETURNS trigger AS 
$BODY$
DECLARE 
    v_arc_table varchar;
    v_man_table varchar;
    v_sql varchar;    

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    v_arc_table:= TG_ARGV[0];
    
    IF TG_OP = 'INSERT' THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"1026", "function":"1306","debug_msg":null}}$$);';
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

	-- State
	IF (NEW.state::text != OLD.state::text) THEN
		UPDATE arc SET state=NEW.state WHERE arc_id = OLD.arc_id;
	END IF;
			
	-- The geom
	IF st_equals(NEW.the_geom, OLD.the_geom) IS FALSE  THEN
		UPDATE arc SET the_geom=NEW.the_geom WHERE arc_id = OLD.arc_id;
	END IF;
	
	UPDATE arc 
	SET arccat_id=NEW.arccat_id, sector_id=NEW.sector_id, annotation= NEW.annotation, custom_length=NEW.custom_length, "state_type"=NEW."state_type"
	WHERE arc_id = OLD.arc_id;

        IF v_arc_table = 'inp_pipe' THEN   
            UPDATE inp_pipe SET minorloss=NEW.minorloss, status=NEW.status, custom_roughness=NEW.custom_roughness, custom_dint=NEW.custom_dint WHERE arc_id=OLD.arc_id;

        ELSIF v_arc_table = 'inp_virtualvalve' THEN   
            UPDATE inp_virtualvalve SET valv_type=NEW.valv_type, pressure=NEW.pressure, flow=NEW.flow, coef_loss=NEW.coef_loss, curve_id=NEW.curve_id,
            minorloss=NEW.minorloss, to_arc=NEW.to_arc, status=NEW.status WHERE arc_id=OLD.arc_id;
        END IF;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
    
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"1028", "function":"1306","debug_msg":null}}$$);';
        
        RETURN NEW;
    
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;