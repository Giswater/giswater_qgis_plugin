/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- FUNCTION NUMBER : 3074

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_inp_dscenario()
  RETURNS trigger AS
$BODY$
DECLARE 

v_dscenario text;

BEGIN

--Get schema name
EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

--Get view name
 v_dscenario = TG_ARGV[0];

    
  IF TG_OP = 'INSERT' THEN
  	IF v_dscenario = 'JUNCTION' THEN
	  	INSERT INTO inp_dscenario_junction (dscenario_id, node_id, y0, ysur, apond, outfallparam)
	 		VALUES (NEW.dscenario_id, NEW.node_id, NEW.y0, NEW.ysur, NEW.apond, NEW.outfallparam);

		ELSIF v_dscenario = 'CONDUIT' THEN
			INSERT INTO inp_dscenario_conduit (dscenario_id, arc_id, arccat_id, matcat_id, custom_n, barrels, culvert, kentry, kexit,
   		kavg, flap, q0, qmax, seepage)
	 		VALUES (NEW.dscenario_id, NEW.arc_id, NEW.arccat_id, NEW.matcat_id, NEW.custom_n, NEW.barrels, NEW.culvert, NEW.kentry, NEW.kexit,
	 		NEW.kavg, NEW.flap, NEW.q0, NEW.qmax, NEW.seepage);

		ELSIF v_dscenario = 'RAINGAGE' THEN
			INSERT INTO inp_dscenario_raingage (dscenario_id, rg_id, form_type, intvl, scf, rgage_type, timser_id, fname, sta, units)
	 		VALUES (NEW.dscenario_id, NEW.rg_id, NEW.form_type, NEW.intvl, NEW.scf, NEW.rgage_type, NEW.timser_id, NEW.fname, NEW.sta, NEW.units);
		END IF;
	
	  RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN
		IF v_dscenario = 'JUNCTION' THEN
		 	UPDATE inp_dscenario_junction SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, y0=NEW.y0, ysur=NEW.ysur, 
		 	apond=NEW.apond, outfallparam=NEW.outfallparam WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario = 'CONDUIT' THEN
			UPDATE inp_dscenario_conduit SET dscenario_id=NEW.dscenario_id, arc_id=NEW.arc_id, arccat_id=NEW.arccat_id, 
			matcat_id=NEW.matcat_id, custom_n=NEW.custom_n, barrels=NEW.barrels, culvert=NEW.culvert, kentry=NEW.kentry, kexit=NEW.kexit,
    	kavg=NEW.kavg, flap=NEW.flap, q0=NEW.q0, qmax=NEW.qmax, seepage=NEW.seepage WHERE dscenario_id=OLD.dscenario_id AND arc_id=OLD.arc_id;

		ELSIF v_dscenario = 'RAINGAGE' THEN
			UPDATE inp_dscenario_raingage SET dscenario_id=NEW.dscenario_id, rg_id=NEW.rg_id, form_type=NEW.form_type, intvl=NEW.intvl, 
			scf=NEW.scf, rgage_type=NEW.rgage_type, timser_id=NEW.timser_id, fname=NEW.fname, sta=NEW.sta, units=NEW.units 
			WHERE dscenario_id=OLD.dscenario_id AND rg_id=OLD.rg_id;
		END IF;


		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		IF v_dscenario = 'JUNCTION' THEN
			DELETE FROM inp_dscenario_junction WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario = 'CONDUIT' THEN
			DELETE FROM inp_dscenario_conduit WHERE dscenario_id=OLD.dscenario_id AND arc_id=OLD.arc_id;

		ELSIF v_dscenario = 'RAINGAGE' THEN
			DELETE FROM inp_dscenario_raingage WHERE dscenario_id=OLD.dscenario_id AND rg_id=OLD.rg_id;
		END IF;


		RETURN OLD;
  END IF;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
