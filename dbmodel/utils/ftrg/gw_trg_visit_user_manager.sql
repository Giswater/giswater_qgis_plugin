	/*
	This file is part of Giswater 3
	The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
	This version of Giswater is provided by Giswater Association
	*/


	--FUNCTION CODE: 2644

	--DROP FUNCTION IF EXISTS "ws_sample".gw_trg_visit_user_manager();
	CREATE OR REPLACE FUNCTION gw_trg_visit_user_manager() RETURNS pg_catalog.trigger AS $BODY$
	DECLARE 
	rec record;
	lot_x_team_new record;

	BEGIN

	    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF TG_OP = 'UPDATE' THEN 
		
		UPDATE om_visit_team_x_user SET team_id= NEW.team_id, starttime = NEW.starttime, endtime=NEW.endtime WHERE user_id=NEW.user_id;

		UPDATE om_visit_user_x_vehicle SET vehicle_id= NEW.vehicle_id, starttime = NEW.starttime, endtime=NEW.endtime WHERE user_id=NEW.user_id;
		
		DELETE FROM selector_lot WHERE cur_user=NEW.user_id AND lot_id IN (SELECT id FROM om_visit_lot WHERE team_id=OLD.team_id);
		DELETE FROM selector_lot WHERE cur_user=NEW.user_id AND lot_id IN (SELECT id FROM om_visit_lot WHERE team_id=NEW.team_id);

		FOR rec IN (SELECT id FROM om_visit_lot WHERE team_id=NEW.team_id) LOOP
			INSERT INTO selector_lot (lot_id, cur_user) VALUES (rec.id, NEW.user_id);
		END LOOP;

		RETURN NEW;
	END IF;

	END;
	$BODY$
	  LANGUAGE plpgsql VOLATILE
	  COST 100;
