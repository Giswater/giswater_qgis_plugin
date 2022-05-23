/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3036

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_inp_dwf()  RETURNS trigger AS
$BODY$

DECLARE 
v_table text;
v_id integer;
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
		
		v_table = TG_ARGV[0];

    IF TG_OP = 'INSERT' THEN

    	IF v_table = 'cat_dwf_scenario' THEN
				INSERT INTO cat_dwf_scenario(id, idval, startdate, enddate, observ, active, expl_id, log)
	  	  VALUES (NEW.id, NEW.idval, NEW.startdate, NEW.enddate, NEW.observ, NEW.active, NEW.expl_id, NEW.log) RETURNING id INTO v_id;

  	  	UPDATE config_param_user SET value=v_id WHERE parameter='inp_options_dwfscenario' AND cur_user=current_user;
  	ELSE
			INSERT INTO inp_dwf (node_id, value, pat1, pat2, pat3, pat4, dwfscenario_id)
			VALUES (NEW.node_id, NEW.value, NEW.pat1, NEW.pat2, NEW.pat3, NEW.pat4, NEW.dwfscenario_id);
		END IF;

		RETURN NEW;
		
    ELSIF TG_OP = 'UPDATE' THEN
   		IF v_table = 'cat_dwf_scenario' THEN
   			UPDATE cat_dwf_scenario SET id=NEW.id, idval=NEW.idval, startdate=NEW.startdate, enddate=NEW.enddate, observ=NEW.observ, active=NEW.active, expl_id=NEW.expl_id, log=NEW.log 
				WHERE id=OLD.id;
   		ELSE
				UPDATE inp_dwf 
				SET node_id=NEW.node_id, value=NEW.value, pat1=NEW.pat1, pat2=NEW.pat2, pat3=NEW.pat3, pat4=NEW.pat4, dwfscenario_id = NEW.dwfscenario_id
				WHERE node_id=OLD.node_id AND dwfscenario_id = OLD.dwfscenario_id;
			END IF;
		RETURN NEW;
		
    ELSIF TG_OP = 'DELETE' THEN  
			IF v_table = 'cat_dwf_scenario' THEN
				DELETE FROM cat_dwf_scenario WHERE id=OLD.id;
   		ELSE
				DELETE FROM inp_dwf
				WHERE node_id=OLD.node_id AND dwfscenario_id = OLD.dwfscenario_id;
			END IF;
		RETURN NULL;
     
	END IF;

END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


