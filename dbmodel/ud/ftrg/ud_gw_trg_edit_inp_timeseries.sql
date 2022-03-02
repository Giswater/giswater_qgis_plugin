/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3132


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_inp_timeseries() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
v_table text;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
   
   v_table = TG_ARGV[0];

	-- Control insertions ID
	IF TG_OP = 'INSERT' THEN
		
		IF v_table = 'inp_timeseries' THEN
			INSERT INTO inp_timeseries (id, timser_type, times_type, idval,descript, fname, expl_id, log) 
			VALUES (NEW.id, NEW.timser_type, NEW.times_type, NEW.idval, NEW.descript, NEW.fname, NEW.expl_id, NEW.log);
		
		ELSIF v_table = 'inp_timeseries_value' THEN
			IF NEW.id IS NULL THEN
				PERFORM setval('inp_timeseries_value_id_seq', (SELECT max(id) FROM inp_timeseries_value), true);
				NEW.id = (SELECT nextval('inp_timeseries_value_id_seq'));
			END IF;
			INSERT INTO inp_timeseries_value (id, timser_id, date, hour, "time", value) 
			VALUES (NEW.id, NEW.timser_id, NEW.date, NEW.hour, NEW."time", NEW.value);
			
		END IF;
		
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN
		
		IF v_table = 'inp_timeseries' THEN
			UPDATE inp_timeseries SET id=NEW.id, timser_type=NEW.timser_type, times_type=NEW.times_type, idval=NEW.idval, 
			descript=NEW.descript, fname=NEW.fname, expl_id=NEW.expl_id, log=NEW.log
			WHERE id=OLD.id;
		END IF;

		IF v_table = 'inp_timeseries_value' THEN
			UPDATE inp_timeseries_value SET 
			timser_id=NEW.timser_id, date=NEW.date, hour=NEW.hour, "time"=NEW."time", value=NEW.value
			WHERE id=OLD.id;
		END IF;

		RETURN NEW;
        
	ELSIF TG_OP = 'DELETE' THEN
		IF v_table = 'inp_timeseries' THEN
			DELETE FROM inp_timeseries WHERE id=OLD.id;

		ELSIF v_table = 'inp_timeseries_value' THEN
			DELETE FROM inp_timeseries_value WHERE id=OLD.id;
		END IF;

		RETURN OLD;
   
	END IF;
       
END;
$$;
  