/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- FUNCTION NUMBER : 3120

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_inp_flwreg()
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
		
		IF v_dscenario = 'FLWREG-ORIFICE' THEN
			INSERT INTO inp_dscenario_flwreg_orifice (dscenario_id, node_id, order_id, ori_type, "offset", cd, orate,
			flap, shape, geom1, geom2, geom3, geom4, close_time)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.order_id, NEW.ori_type, NEW."offset", NEW.cd, NEW.orate, 
			NEW.flap, NEW.shape, NEW.geom1, NEW.geom2, NEW.geom3, NEW.geom4, NEW.close_time);
			
	 	ELSIF v_dscenario = 'FLWREG-OUTLET' THEN
			INSERT INTO inp_dscenario_flwreg_outlet (dscenario_id, node_id, order_id, outlet_type, "offset", curve_id, cd1, cd2)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.order_id, NEW.outlet_type, NEW."offset", NEW.curve_id, NEW.cd1, NEW.cd2);

	 	ELSIF v_dscenario = 'FLWREG-PUMP' THEN
			INSERT INTO inp_dscenario_flwreg_pump (dscenario_id, node_id, order_id, curve_id, status, startup, shutoff)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.order_id, NEW.curve_id, NEW.status, NEW.startup, NEW.shutoff);	

	 	ELSIF v_dscenario = 'FLWREG-WEIR' THEN
			INSERT INTO inp_dscenario_flwreg_weir (dscenario_id, node_id, order_id, weir_type, "offset", cd, ec, 
			cd2, flap, geom1, geom2, geom3, geom4, surcharge, road_width, road_surf, coef_curve)
			VALUES (NEW.dscenario_id, NEW.node_id, NEW.order_id, NEW.weir_type, NEW."offset", NEW.cd, NEW.ec, 
			NEW.cd2, NEW.flap, NEW.geom1, NEW.geom2, NEW.geom3, NEW.geom4, NEW.surcharge, NEW.road_width, NEW.road_surf, NEW.coef_curve);
		
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		IF v_dscenario = 'FLWREG-ORIFICE' THEN
			UPDATE inp_dscenario_flwreg_orifice SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, order_id=NEW.order_id, to_arc=NEW.to_arc, 
			ori_type=NEW.ori_type, "offset"=NEW."offset", cd=NEW.cd, orate=NEW.orate, flap=NEW.flap, shape=NEW.shape, 
			geom1=NEW.geom1, geom2=NEW.geom2, geom3=NEW.geom3, geom4=NEW.geom4, close_time=NEW.close_time
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id AND order_id=NEW.order_id;
			
	 	ELSIF v_dscenario = 'FLWREG-OUTLET' THEN
			UPDATE inp_dscenario_flwreg_outlet SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, order_id=NEW.order_id, to_arc=NEW.to_arc, 
			outlet_type=NEW.outlet_type, "offset"=NEW."offset", curve_id=NEW.curve_id, cd1=NEW.cd1, cd2=NEW.cd2
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id AND order_id=NEW.order_id;

	 	ELSIF v_dscenario = 'FLWREG-PUMP' THEN
			UPDATE inp_dscenario_flwreg_pump SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, order_id=NEW.order_id, to_arc=NEW.to_arc, 
			curve_id=NEW.curve_id, status=NEW.status, startup=NEW.startup, shutoff=NEW.shutoff
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id AND order_id=NEW.order_id;

	 	ELSIF v_dscenario = 'FLWREG-WEIR' THEN
			UPDATE inp_dscenario_inflows SET dscenario_id=NEW.dscenario_id, node_id=NEW.node_id, order_id=NEW.order_id, to_arc=NEW.to_arc,
			weir_type=NEW.weir_type, "offset"=NEW."offset", cd=NEW.cd, ec=NEW.ec, cd2=NEW.cd2, flap=NEW.flap, geom1=NEW.geom1, geom2=NEW.geom2, geom3=NEW.geom3, 
			geom4=NEW.geom4, surcharge=NEW.surcharge, road_width=NEW.road_width, road_surf=NEW.road_surf, coef_curve=NEW.coef_curve
			WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id AND order_id=NEW.order_id;
		
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		IF v_dscenario = 'FLWREG-ORIFICE' THEN
			DELETE FROM inp_dscenario_orifice WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id AND order_id=OLD.order_id;
			
	 	ELSIF v_dscenario = 'FLWREG-OUTLET' THEN
			DELETE FROM inp_dscenario_flowreg_outlet WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id AND order_id=OLD.order_id;

	 	ELSIF v_dscenario = 'FLWREG-PUMP' THEN
			DELETE FROM inp_dscenario_flowreg_pump WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id AND order_id=OLD.order_id;

	 	ELSIF v_dscenario = 'FLWREG-WEIR' THEN
			DELETE FROM inp_dscenario_flowreg_weir WHERE dscenario_id=OLD.dscenario_id AND node_id=OLD.node_id AND order_id=OLD.order_id;
		END IF;

		RETURN OLD;
  END IF;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
