/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- FUNCTION NUMBER : 3122

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_inp_inflows()
  RETURNS trigger AS
$BODY$
DECLARE 

v_table text;


BEGIN

	--Get schema name
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	--Get table
	v_table = TG_ARGV[0];
	
	IF TG_OP = 'INSERT' THEN
		
		IF v_table = 'INFLOWS' THEN
			INSERT INTO inp_inflows (node_id, order_id, timser_id, format_type, mfactor, sfactor, base, pattern_id)
			VALUES(NEW.NEW.node_id, NEW.order_id, NEW.timser_id, NEW.format_type, NEW.mfactor, NEW.sfactor, NEW.base, NEW.pattern_id);
			
	 	ELSIF v_table = 'INFLOWS-POLL' THEN
			INSERT INTO inp_inflows_poll (poll_id,  node_id, timser_id, form_type, mfactor, factor, base, pattern_id)
			VALUES (NEW.NEW.poll_id,  NEW.node_id, NEW.timser_id, NEW.form_type, NEW.mfactor, NEW.factor, NEW.base, NEW.pattern_id);

		END IF;
	
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		IF v_table = 'INFLOWS' THEN
			UPDATE inp_inflows SET dscenario_id=NEW.node_id=NEW.node_id, order_id=NEW.order_id, timser_id=NEW.timser_id, 
			format_type=NEW.format_type, mfactor=NEW.mfactor, sfactor=NEW.sfactor, base=NEW.base, pattern_id=NEW.pattern_id		
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id AND order_id = OLD.order_id;
			
	 	ELSIF v_table = 'INFLOWS-POLL' THEN
			UPDATE inp_inflows_poll SET dscenario_id=NEW.poll_id=NEW.poll_id,  node_id=NEW.node_id, timser_id=NEW.timser_id,
			form_type=NEW.form_type, mfactor=NEW.mfactor, factor=NEW.factor, base=NEW.base, pattern_id=NEW.pattern_id
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id AND poll_id = OLD.poll_id;
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		IF  v_table = 'INFLOWS' THEN
			DELETE FROM inp_inflows WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id AND order_id = OLD.order_id;
			
	 	ELSIF v_table = 'INFLOWS-POLL' THEN
			DELETE FROM inp_inflows_poll WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id AND poll_id = OLD.poll_id;
		END IF;

		RETURN OLD;
  END IF;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
