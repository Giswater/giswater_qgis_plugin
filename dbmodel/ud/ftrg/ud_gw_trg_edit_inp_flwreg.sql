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

v_table text;

BEGIN

	--Get schema name
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	--Get view name
	v_table = TG_ARGV[0];
	
	IF TG_OP = 'INSERT' THEN
		
		IF v_table = 'FLWREG-ORIFICE' THEN

			-- default values
			IF NEW.geom1 IS NULL THEN NEW.geom1 = 1;END IF;
			IF NEW.geom2 IS NULL THEN NEW.geom2 = 1; END IF;
			IF NEW.geom3 IS NULL THEN NEW.geom3 = 0; END IF;
			IF NEW.geom4 IS NULL THEN NEW.geom4 = 0; END IF;
			IF NEW.ori_type IS NULL THEN NEW.ori_type = 'SIDE'; END IF;
			IF NEW.shape IS NULL THEN NEW.shape = 'RECT-CLOSED';END IF;
			
			INSERT INTO inp_flwreg_orifice (nodarc_id, node_id, order_id, to_arc, flwreg_length, ori_type, offsetval, cd, orate,
			flap, shape, geom1, geom2, geom3, geom4, close_time)
			VALUES (concat(NEW.node_id,'OR',NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length, NEW.ori_type, NEW.offsetval, NEW.cd, NEW.orate, 
			NEW.flap, NEW.shape, NEW.geom1, NEW.geom2, NEW.geom3, NEW.geom4, NEW.close_time);
			
	 	ELSIF v_table = 'FLWREG-OUTLET' THEN

			-- default values
			IF NEW.outlet_type IS NULL THEN NEW.outlet_type = 'FUNCTIONAL/DEPTH'; END IF;
			
			INSERT INTO inp_flwreg_outlet (nodarc_id, node_id, order_id, to_arc, flwreg_length, outlet_type, offsetval, curve_id, cd1, cd2)
			VALUES (concat(NEW.node_id,'OT',NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length, NEW.outlet_type, NEW.offsetval, NEW.curve_id, NEW.cd1, NEW.cd2);

	 	ELSIF v_table = 'FLWREG-PUMP' THEN
	 	
			INSERT INTO inp_flwreg_pump (nodarc_id, node_id, order_id, to_arc, flwreg_length, curve_id, status, startup, shutoff)
			VALUES (concat(NEW.node_id,'PU',NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length, NEW.curve_id, NEW.status, NEW.startup, NEW.shutoff);	

	 	ELSIF v_table = 'FLWREG-WEIR' THEN

			-- default values
			IF NEW.weir_type IS NULL THEN NEW.weir_type = 'SIDEFLOW'; END IF;
			IF NEW.geom3 IS NULL THEN NEW.geom3 = 0; END IF;
			IF NEW.geom4 IS NULL THEN NEW.geom4 = 0; END IF;
	 		
			INSERT INTO inp_flwreg_weir (nodarc_id, node_id, order_id, to_arc, flwreg_length, weir_type, offsetval, cd, ec, 
			cd2, flap, geom1, geom2, geom3, geom4, surcharge, road_width, road_surf, coef_curve)
			VALUES (concat(NEW.node_id,'WE',NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length, NEW.weir_type, NEW.offsetval, NEW.cd, NEW.ec, 
			NEW.cd2, NEW.flap, NEW.geom1, NEW.geom2, NEW.geom3, NEW.geom4, NEW.surcharge, NEW.road_width, NEW.road_surf, NEW.coef_curve);
		
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		IF v_table = 'FLWREG-ORIFICE' THEN
		
			UPDATE inp_flwreg_orifice SET nodarc_id=concat(NEW.node_id,'OR',NEW.order_id), node_id=NEW.node_id, order_id=NEW.order_id, to_arc=NEW.to_arc, 
			flwreg_length= NEW.flwreg_length, ori_type=NEW.ori_type, offsetval=NEW.offsetval, cd=NEW.cd, orate=NEW.orate, flap=NEW.flap, shape=NEW.shape, 
			geom1=NEW.geom1, geom2=NEW.geom2, geom3=NEW.geom3, geom4=NEW.geom4, close_time=NEW.close_time
			WHERE nodarc_id=OLD.nodarc_id;
			
	 	ELSIF v_table = 'FLWREG-OUTLET' THEN
	 	
			UPDATE inp_flwreg_outlet SET nodarc_id=concat(NEW.node_id,'OT',NEW.order_id), node_id=NEW.node_id, order_id=NEW.order_id, to_arc=NEW.to_arc, 
			flwreg_length= NEW.flwreg_length, outlet_type=NEW.outlet_type, offsetval=NEW.offsetval, curve_id=NEW.curve_id, cd1=NEW.cd1, cd2=NEW.cd2
			WHERE nodarc_id=OLD.nodarc_id;

	 	ELSIF v_table = 'FLWREG-PUMP' THEN
	 	
			UPDATE inp_flwreg_pump SET nodarc_id=concat(NEW.node_id,'PU',NEW.order_id), node_id=NEW.node_id, order_id=NEW.order_id, to_arc=NEW.to_arc, 
			flwreg_length= NEW.flwreg_length, curve_id=NEW.curve_id, status=NEW.status, startup=NEW.startup, shutoff=NEW.shutoff
			WHERE nodarc_id=OLD.nodarc_id;

	 	ELSIF v_table = 'FLWREG-WEIR' THEN
	 	
			UPDATE inp_flwreg_weir SET nodarc_id=concat(NEW.node_id,'WE',NEW.order_id), node_id=NEW.node_id, order_id=NEW.order_id, to_arc=NEW.to_arc, flwreg_length= NEW.flwreg_length, 
			weir_type=NEW.weir_type, offsetval=NEW.offsetval, cd=NEW.cd, ec=NEW.ec, cd2=NEW.cd2, flap=NEW.flap, geom1=NEW.geom1, geom2=NEW.geom2, geom3=NEW.geom3, 
			geom4=NEW.geom4, surcharge=NEW.surcharge, road_width=NEW.road_width, road_surf=NEW.road_surf, coef_curve=NEW.coef_curve
			WHERE nodarc_id=OLD.nodarc_id;
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		IF v_table = 'FLWREG-ORIFICE' THEN
			DELETE FROM inp_flwreg_orifice WHERE nodarc_id=OLD.nodarc_id;
			
	 	ELSIF v_table = 'FLWREG-OUTLET' THEN
			DELETE FROM inp_flwreg_outlet WHERE nodarc_id=OLD.nodarc_id;

	 	ELSIF v_table = 'FLWREG-PUMP' THEN
			DELETE FROM inp_flwreg_pump WHERE nodarc_id=OLD.nodarc_id;

	 	ELSIF v_table = 'FLWREG-WEIR' THEN
			DELETE FROM inp_flwreg_weir WHERE nodarc_id=OLD.nodarc_id;
		END IF;

		RETURN OLD;
  END IF;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
