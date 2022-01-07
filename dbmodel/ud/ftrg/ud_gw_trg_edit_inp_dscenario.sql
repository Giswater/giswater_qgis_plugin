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
		 		
	 	IF v_dscenario = 'CONDUIT' THEN
			INSERT INTO inp_dscenario_conduit (dscenario_id, arc_id, arccat_id, matcat_id, y1, y2, custom_n, barrels, culvert, kentry, kexit,
			kavg, flap, q0, qmax, seepage)
	 		VALUES (NEW.dscenario_id, NEW.arc_id, NEW.arccat_id, NEW.matcat_id, NEW.y1, NEW.y2, NEW.custom_n, NEW.barrels, NEW.culvert, NEW.kentry, NEW.kexit,
	 		NEW.kavg, NEW.flap, NEW.q0, NEW.qmax, NEW.seepage);

		ELSIF v_dscenario = 'DIVIDER' THEN
			INSERT INTO inp_dscenario_divider (dscenario_id, node_id, elev, ymax, divider_type, arc_id, curve_id, qmin, ht, cd, y0, ysur, apond)
	 		VALUES (NEW.dscenario_id, NEW.node_id, NEW.divider_type, NEW.arc_id, NEW.curve_id, NEW.qmin, NEW.ht, NEW.cd, NEW.y0, NEW.ysur, NEW.apond );

		ELSIF v_dscenario = 'FLWREG-ORIFICE' THEN
			INSERT INTO inp_dscenario_flwreg_orifice (dscenario_id, node_id, order_id, to_arc, flwreg_length,  ori_type, "offset", cd, orate,
			flap, shape, geom1, geom2, geom3, geom4, close_time)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length, NEW.ori_type, NEW."offset", NEW.cd, NEW.orate, 
			NEW.flap, NEW.shape, NEW.geom1, NEW.geom2, NEW.geom3, NEW.geom4, NEW.close_time);
			
	 	ELSIF v_dscenario = 'FLWREG-OUTLET' THEN
			INSERT INTO inp_dscenario_flwreg_outlet (dscenario_id, node_id, order_id, to_arc, flwreg_length, outlet_type, "offset", curve_id, cd1, cd2)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length, NEW.outlet_type, NEW."offset", NEW.curve_id, NEW.cd1, NEW.cd2);

	 	ELSIF v_dscenario = 'FLWREG-PUMP' THEN
			INSERT INTO inp_dscenario_flwreg_pump (dscenario_id, node_id, order_id, to_arc, flwreg_length, curve_id, status, startup, shutoff)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length, NEW.curve_id, NEW.status, NEW.startup, NEW.shutoff);	

	 	ELSIF v_dscenario = 'FLWREG-WEIR' THEN
			INSERT INTO inp_dscenario_flwreg_weir (dscenario_id, node_id, order_id, to_arc, flwreg_length, weir_type, "offset", cd, ec, 
			cd2, flap, geom1, geom2, geom3, geom4, surcharge, road_width, road_surf, coef_curve)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length, NEW.weir_type, NEW."offset", NEW.cd, NEW.ec, 
			NEW.cd2, NEW.flap, NEW.geom1, NEW.geom2, NEW.geom3, NEW.geom4, NEW.surcharge, NEW.road_width, NEW.road_surf, NEW.coef_curve);

		ELSIF v_dscenario = 'INFLOWS' THEN
			INSERT INTO inp_dscenario_inflows (dscenario_id, node_id, order_id, timser_id, format_type, mfactor, sfactor, base, pattern_id)
			VALUES(NEW.dscenario_id, NEW.node_id, NEW.order_id, NEW.timser_id, NEW.format_type, NEW.mfactor, NEW.sfactor, NEW.base, NEW.pattern_id);
			
	 	ELSIF v_dscenario = 'INFLOWS-POLL' THEN
			INSERT INTO inp_dscenario_inflows_poll (dscenario_id, poll_id,  node_id, timser_id, form_type, mfactor, factor, base, pattern_id)
			VALUES (NEW.dscenario_id, NEW.poll_id,  NEW.node_id, NEW.timser_id, NEW.form_type, NEW.mfactor, NEW.factor, NEW.base, NEW.pattern_id);
						
	 	ELSIF v_dscenario = 'JUNCTION' THEN
			INSERT INTO inp_dscenario_junction (dscenario_id, node_id, elev, ymax, y0, ysur, apond, outfallparam)
	 		VALUES (NEW.dscenario_id, NEW.node_id, NEW.elev, NEW.ymax, NEW.y0, NEW.ysur, NEW.apond, NEW.outfallparam);

 		ELSIF v_dscenario = 'OUTFALL' THEN
			INSERT INTO inp_dscenario_outfall(dscenario_id, node_id, outfall_type, stage, curve_id, timser_id, gate)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.outfall_type, NEW.stage, NEW.curve_id, NEW.timser_id, NEW.gate);
			
		ELSIF v_dscenario = 'RAINGAGE' THEN
			INSERT INTO inp_dscenario_raingage (dscenario_id, rg_id, form_type, intvl, scf, rgage_type, timser_id, fname, sta, units)
	 		VALUES (NEW.dscenario_id, NEW.rg_id, NEW.form_type, NEW.intvl, NEW.scf, NEW.rgage_type, NEW.timser_id, NEW.fname, NEW.sta, NEW.units);

		ELSIF v_dscenario = 'STORAGE' THEN
			INSERT INTO inp_dscenario_storage (dscenario_id, node_id, storage_type, curve_id, a1, a2, a0, fevap, sh, hc, imd, y0, ysur, apond)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.storage_type, NEW.curve_id, NEW.a1, NEW.a2, NEW.a0, NEW.fevap, NEW.sh, NEW.hc, NEW.imd, NEW.y0, NEW.ysur, NEW.apond);
			
	 	ELSIF v_dscenario = 'TREATMENT' THEN
			INSERT INTO inp_dscenario_treatment (dscenario_id, node_id, poll_id, function)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.poll_id, NEW.function);
		END IF;
	
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		IF v_dscenario = 'CONDUIT' THEN
			UPDATE inp_dscenario_conduit SET dscenario_id=NEW.dscenario_id, arc_id=NEW.arc_id, arccat_id=NEW.arccat_id, 
			matcat_id=NEW.matcat_id, y1=NEW.y1, y2=NEW.y2, custom_n=NEW.custom_n, barrels=NEW.barrels, culvert=NEW.culvert, kentry=NEW.kentry, kexit=NEW.kexit,
			kavg=NEW.kavg, flap=NEW.flap, q0=NEW.q0, qmax=NEW.qmax, seepage=NEW.seepage 
			WHERE dscenario_id=OLD.dscenario_id AND arc_id=OLD.arc_id;

		ELSIF v_dscenario = 'DIVIDER' THEN
			UPDATE inp_dscenario_raingage SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, elev=NEW.elev, ymax=NEW.ymax, divider_type=NEW.divider_type, 
			arc_id=NEW.arc_id, curve_id=NEW.curve_id, qmin=NEW.qmin, qmin=NEW.ht, qmin=NEW.cd, qmin=NEW.y0, qmin=NEW.ysur, qmin=NEW.apond
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario = 'FLWREG-ORIFICE' THEN
			UPDATE inp_dscenario_flwreg_orifice SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, order_id=NEW.order_id, to_arc=NEW.to_arc, 
			flwreg_length=NEW.flwreg_length, ori_type=NEW.ori_type, "offset"=NEW."offset", cd=NEW.cd, orate=NEW.orate, flap=NEW.flap, shape=NEW.shape, 
			geom1=NEW.geom1, geom2=NEW.geom2, geom3=NEW.geom3, geom4=NEW.geom4, close_time=NEW.close_time
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
			
	 	ELSIF v_dscenario = 'FLWREG-OUTLET' THEN
			UPDATE inp_dscenario_flwreg_outlet SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, order_id=NEW.order_id, to_arc=NEW.to_arc, 
			flwreg_length=NEW.flwreg_length, outlet_type=NEW.outlet_type, "offset"=NEW."offset", curve_id=NEW.curve_id, cd1=NEW.cd1, cd2=NEW.cd2
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

	 	ELSIF v_dscenario = 'FLWREG-PUMP' THEN
			UPDATE inp_dscenario_flwreg_pump SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, order_id=NEW.order_id, to_arc=NEW.to_arc, 
			flwreg_length=NEW.flwreg_length, curve_id=NEW.curve_id, status=NEW.status, startup=NEW.startup, shutoff=NEW.shutoff
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

	 	ELSIF v_dscenario = 'FLWREG-WEIR' THEN
			UPDATE inp_dscenario_inflows SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, order_id=NEW.order_id, to_arc=NEW.to_arc, flwreg_length=NEW.flwreg_length, 
			weir_type=NEW.weir_type, "offset"=NEW."offset", cd=NEW.cd, ec=NEW.ec, cd2=NEW.cd2, flap=NEW.flap, geom1=NEW.geom1, geom2=NEW.geom2, geom3=NEW.geom3, 
			geom4=NEW.geom4, surcharge=NEW.surcharge, road_width=NEW.road_width, road_surf=NEW.road_surf, coef_curve=NEW.coef_curve
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario = 'INFLOWS' THEN
			UPDATE inp_dscenario_inflows SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, order_id=NEW.order_id, timser_id=NEW.timser_id, 
			format_type=NEW.format_type, mfactor=NEW.mfactor, sfactor=NEW.sfactor, base=NEW.base, pattern_id=NEW.pattern_id		
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
			
	 	ELSIF v_dscenario = 'INFLOWS-POLL' THEN
			UPDATE inp_dscenario_inflows_poll SET dscenario_id=NEW.dscenario_id, poll_id=NEW.poll_id,  node_id=NEW.node_id, timser_id=NEW.timser_id,
			form_type=NEW.form_type, mfactor=NEW.mfactor, factor=NEW.factor, base=NEW.base, pattern_id=NEW.pattern_id
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
	 	
		ELSIF v_dscenario = 'JUNCTION' THEN
		 	UPDATE inp_dscenario_junction SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, elev=NEW.elev, ymax=NEW.ymax, 
		 	y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond, outfallparam=NEW.outfallparam 
		 	WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario = 'OUTFALL' THEN
			UPDATE inp_dscenario_outfall SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, outfall_type=NEW.outfall_type, stage=NEW.stage, 
			curve_id=NEW.curve_id, timser_id=NEW.timser_id, gate=NEW.gate 
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
			
		ELSIF v_dscenario = 'RAINGAGE' THEN
			UPDATE inp_dscenario_raingage SET dscenario_id=NEW.dscenario_id, rg_id=NEW.rg_id, form_type=NEW.form_type, intvl=NEW.intvl, 
			scf=NEW.scf, rgage_type=NEW.rgage_type, timser_id=NEW.timser_id, fname=NEW.fname, sta=NEW.sta, units=NEW.units 
			WHERE dscenario_id=OLD.dscenario_id AND rg_id=OLD.rg_id;
			
		ELSIF v_dscenario = 'STORAGE' THEN
			UPDATE inp_dscenario_storage SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, storage_type=NEW.storage_type, curve_id=NEW.curve_id, 
			a1=NEW.a1, a2=NEW.a2, a0=NEW.a0, fevap=NEW.fevap, sh=NEW.sh, hc=NEW.hc, imd=NEW.imd, y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
			
	 	ELSIF v_dscenario = 'TREATMENT' THEN
			UPDATE inp_dscenario_treatment SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, poll_id=NEW.poll_id, function=NEW.function 
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		IF v_dscenario = 'CONDUIT' THEN
			DELETE FROM inp_dscenario_conduit WHERE dscenario_id=OLD.dscenario_id AND arc_id=OLD.arc_id;
	
		ELSIF v_dscenario = 'DIVIDER' THEN
			DELETE FROM inp_dscenario_divider WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario = 'FLWREG-ORIFICE' THEN
			DELETE FROM inp_dscenario_orifice WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
			
	 	ELSIF v_dscenario = 'FLWREG-OUTLET' THEN
			DELETE FROM inp_dscenario_flowreg_outlet WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

	 	ELSIF v_dscenario = 'FLWREG-PUMP' THEN
			DELETE FROM inp_dscenario_flowreg_pump WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

	 	ELSIF v_dscenario = 'FLWREG-WEIR' THEN
			DELETE FROM inp_dscenario_flowreg_weir WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario = 'INFLOWS' THEN
			DELETE FROM inp_dscenario_inflows WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
			
	 	ELSIF v_dscenario = 'INFLOWS-POLL' THEN
			DELETE FROM inp_dscenario_inflows_poll WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
			
		ELSIF v_dscenario = 'JUNCTION' THEN
			DELETE FROM inp_dscenario_junction WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario = 'OUTFALL' THEN
			DELETE FROM inp_dscenario_outfall WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;

		ELSIF v_dscenario = 'RAINGAGE' THEN
			DELETE FROM inp_dscenario_raingage WHERE dscenario_id=OLD.dscenario_id AND rg_id=OLD.rg_id;

		ELSIF v_dscenario = 'STORAGE' THEN
			DELETE FROM inp_dscenario_storage WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
			
	 	ELSIF v_dscenario = 'TREATMENT' THEN
			DELETE FROM inp_dscenario_treatment WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id;
		END IF;

		RETURN OLD;
  END IF;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
