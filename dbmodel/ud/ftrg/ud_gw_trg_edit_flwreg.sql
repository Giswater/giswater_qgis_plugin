/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



-- FUNCTION NUMBER : 3372

-- DROP FUNCTION gw_trg_edit_flwreg();

CREATE OR REPLACE FUNCTION gw_trg_edit_flwreg()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
v_flwreg_type text;
v_curve_id text;

BEGIN
    -- Ensure the search path includes the schema
    EXECUTE 'SET search_path TO ' || quote_ident(TG_TABLE_SCHEMA) || ', public';

    v_flwreg_type := TG_ARGV[0];

    -- Insert logic
    IF TG_OP = 'INSERT' THEN
        IF v_flwreg_type =  'VFLWREG' THEN
	 			IF  NEW.flwreg_type = 'ORIFICE' THEN
					
	                -- Default values for orifice
	                IF NEW.geom1 IS NULL THEN NEW.geom1 = 1; END IF;
	                IF NEW.geom2 IS NULL THEN NEW.geom2 = 1; END IF;
	                IF NEW.geom3 IS NULL THEN NEW.geom3 = 0; END IF;
	                IF NEW.geom4 IS NULL THEN NEW.geom4 = 0; END IF;
	                IF NEW.ori_type IS NULL THEN NEW.ori_type = 'SIDE'; END IF;
	                IF NEW.shape IS NULL THEN NEW.shape = 'RECT-CLOSED'; END IF;
	
	                INSERT INTO inp_flwreg_orifice (
	                   flwreg_id, nodarc_id, node_id, order_id, to_arc, flwreg_length, ori_type, offsetval, cd, orate, 
	                    flap, shape, geom1, geom2, geom3, geom4
	                ) VALUES (
	                    NEW.flwreg_id, concat(NEW.node_id, 'OR', NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length,
	                    NEW.ori_type, NEW.offsetval, NEW.cd, NEW.orate,
	                    NEW.flap, NEW.shape, NEW.geom1, NEW.geom2, NEW.geom3, NEW.geom4
	                );
	
	            ELSIF NEW.flwreg_type = 'OUTLET' THEN
	                -- Default values for outlet
	                IF NEW.outlet_type IS NULL THEN NEW.outlet_type = 'FUNCTIONAL/DEPTH'; END IF;
	
	                INSERT INTO inp_flwreg_outlet (
	                    flwreg_id, nodarc_id, node_id, order_id, to_arc, flwreg_length, outlet_type, offsetval, curve_id, cd1, cd2
	                ) VALUES (
	                    NEW.flwreg_id, concat(NEW.node_id, 'OT', NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length,
	                    NEW.outlet_type, NEW.offsetval, NEW.curve_id, NEW.cd1, NEW.cd2
	                );
				END IF;

            ELSIF v_flwreg_type =  'pump' THEN
				 
                INSERT INTO inp_flwreg_pump (
                   flwreg_id,  nodarc_id, node_id, order_id, to_arc, flwreg_length, curve_id, status, startup, shutoff
                ) VALUES (
                   NEW.flwreg_id, concat(NEW.node_id, 'PU', NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length,
                    NEW.curve_id, NEW.status, NEW.startup, NEW.shutoff
                );

            ELSIF v_flwreg_type =  'weir' THEN
                -- Default values for weir
                IF NEW.weir_type IS NULL THEN NEW.weir_type = 'SIDEFLOW'; END IF;
                IF NEW.geom3 IS NULL THEN NEW.geom3 = 0; END IF;
                IF NEW.geom4 IS NULL THEN NEW.geom4 = 0; END IF;

                INSERT INTO inp_flwreg_weir (
                    flwreg_id, nodarc_id, node_id, order_id, to_arc, flwreg_length, weir_type, offsetval, cd, ec, cd2, flap, 
                    geom1, geom2, geom3, geom4, surcharge, road_width, road_surf, coef_curve
                ) VALUES (
                    NEW.flwreg_id, concat(NEW.node_id, 'WE', NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length,
                    NEW.weir_type, NEW.offsetval, NEW.cd, NEW.ec, NEW.cd2, NEW.flap, 
                    NEW.geom1, NEW.geom2, NEW.geom3, NEW.geom4, NEW.surcharge,
                    NEW.road_width, NEW.road_surf, NEW.coef_curve
                );
			
			ELSIF v_flwreg_type = 'parent' THEN
                IF  NEW.flwreg_type = 'ORIFICE' THEN
 				           
	                INSERT INTO inp_flwreg_orifice (
	                    flwreg_id, nodarc_id, node_id, order_id, to_arc, flwreg_length
	                ) VALUES (
	                    NEW.flwreg_id, concat(NEW.node_id, 'OR', NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length
	                );

				ELSIF NEW.flwreg_type = 'OUTLET' then 
			
	                INSERT INTO inp_flwreg_outlet (
	                    flwreg_id, nodarc_id, node_id, order_id, to_arc, flwreg_length
	                ) VALUES (
	                    NEW.flwreg_id, concat(NEW.node_id, 'OT', NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length
	                );
				END IF ;
				
				ELSIF NEW.flwreg_type = 'PUMP' THEN
				
					-- Default values for  pump
					v_curve_id = 'PUMP-01';
	                
					   INSERT INTO inp_flwreg_pump (
	                   flwreg_id, nodarc_id, node_id, order_id, to_arc, flwreg_length, curve_id
	                ) VALUES (
	                    NEW.flwreg_id, concat(NEW.node_id, 'PU', NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length, v_curve_id
	                );

				ELSIF  NEW.flwreg_type = 'WEIR' THEN
					
	                INSERT INTO inp_flwreg_weir (
	                    flwreg_id, nodarc_id, node_id, order_id, to_arc, flwreg_length
	                ) VALUES (
	                    NEW.flwreg_id, concat(NEW.node_id, 'WE', NEW.order_id), NEW.node_id, NEW.order_id, NEW.to_arc, NEW.flwreg_length              
	                );			

              	END IF;

        	END IF;

        RETURN NEW;

    -- Update logic
    ELSIF TG_OP = 'UPDATE' THEN
        IF v_flwreg_type = 'VFLWREG' THEN
           IF flwreg_type =  'ORIFICE' THEN
                UPDATE inp_flwreg_orifice
                SET
                    --nodarc_id = concat(NEW.node_id, 'OR', NEW.order_id),
					flwreg_id = NEW.flwreg_id,
                    node_id = NEW.node_id,
                    order_id = NEW.order_id,
                    to_arc = NEW.to_arc,
                    flwreg_length = NEW.flwreg_length,
                    ori_type = NEW.ori_type,
                    offsetval = NEW.offsetval,
                    cd = NEW.cd,
                    orate = NEW.orate,
                    flap = NEW.flap,
                    shape = NEW.shape,
                    geom1 = NEW.geom1,
                    geom2 = NEW.geom2,
                    geom3 = NEW.geom3,
                    geom4 = NEW.geom4
                WHERE flwreg_id = OLD.flwreg_id;

            ELSIF flwreg_type = 'OUTLET' THEN
                UPDATE inp_flwreg_outlet
                SET
                   	flwreg_id = NEW.flwreg_id,
					node_id = NEW.node_id,
                    order_id = NEW.order_id,
                    to_arc = NEW.to_arc,
                    flwreg_length = NEW.flwreg_length,
                    outlet_type = NEW.outlet_type,
                    offsetval = NEW.offsetval,
                    curve_id = NEW.curve_id,
                    cd1 = NEW.cd1,
                    cd2 = NEW.cd2
                WHERE flwreg_id = OLD.flwreg_id;
			END IF;

            ELSE IF  v_flwreg_type ='pump' THEN
                UPDATE inp_flwreg_pump
                SET
                    flwreg_id = NEW.flwreg_id,
					node_id = NEW.node_id,
                    order_id = NEW.order_id,
                    to_arc = NEW.to_arc,
                    flwreg_length = NEW.flwreg_length,
                    curve_id = NEW.curve_id,
                    status = NEW.status,
                    startup = NEW.startup,
                    shutoff = NEW.shutoff
                WHERE flwreg_id = OLD.flwreg_id;

             ELSE IF v_flwreg_type ='weir' THEN
                UPDATE inp_flwreg_weir
                SET
                    flwreg_id = NEW.flwreg_id,
					node_id = NEW.node_id,
                    order_id = NEW.order_id,
                    to_arc = NEW.to_arc,
                    flwreg_length = NEW.flwreg_length,
                    weir_type = NEW.weir_type,
                    offsetval = NEW.offsetval,
                    cd = NEW.cd,
                    ec = NEW.ec,
                    cd2 = NEW.cd2,
                    flap = NEW.flap,
                    geom1 = NEW.geom1,
                    geom2 = NEW.geom2,
                    geom3 = NEW.geom3,
                    geom4 = NEW.geom4,
                    surcharge = NEW.surcharge,
                    road_width = NEW.road_width,
                    road_surf = NEW.road_surf,
                    coef_curve = NEW.coef_curve
                WHERE flwreg_id = OLD.flwreg_id;
        END IF;

        RETURN NEW;

    -- Delete logic
    ELSIF TG_OP = 'DELETE' THEN
         IF v_flwreg_type = 'VFLWREG' THEN
           IF flwreg_type =  'ORIFICE' THEN
               DELETE FROM inp_flwreg_orifice WHERE flwreg_id = OLD.flwreg_id;

            ELSIF flwreg_type = 'OUTLET' THEN
                DELETE FROM inp_flwreg_outlet WHERE flwreg_id = OLD.flwreg_id;
			END IF;

           ELSIF v_flwreg_type = 'pump' THEN
                DELETE FROM inp_flwreg_pump WHERE flwreg_id = OLD.flwreg_id;

             ELSIF v_flwreg_type = 'weir' THEN
                DELETE FROM inp_flwreg_weir WHERE flwreg_id = OLD.flwreg_id;
        END IF;

        RETURN OLD;
    END IF;
END;
$function$
;