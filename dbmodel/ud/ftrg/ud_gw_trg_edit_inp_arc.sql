/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1208
   
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_inp_arc() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    v_arc_table varchar;
    v_man_table varchar;
    v_epa_type varchar;
    v_sql varchar;
    v_old_arctype varchar;
    v_new_arctype varchar;  

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    v_arc_table:= TG_ARGV[0];
    v_epa_type:= TG_ARGV[1];
    
    IF TG_OP = 'INSERT' THEN
 		RETURN gw_fct_audit_function(1026,1208, NULL);

    ELSIF TG_OP = 'UPDATE' THEN
	
		-- State
		IF (NEW.state != OLD.state) THEN
			UPDATE arc SET state=NEW.state WHERE arc_id = OLD.arc_id;
		END IF;
			
		-- The geom
		IF st_equals(NEW.the_geom, OLD.the_geom) IS FALSE  THEN
			UPDATE arc SET the_geom=NEW.the_geom WHERE arc_id = OLD.arc_id;
		END IF;
		
	
		IF (v_epa_type != 'VIRTUAL') THEN 
			-- depth fields
			IF (NEW.y1 <> OLD.y1) OR (NEW.y2 <> OLD.y2) THEN
				UPDATE arc SET y1=NEW.y1, y2=NEW.y2 WHERE arc_id=NEW.arc_id;
			END IF;
		
			IF (NEW.elev1 <> OLD.elev1) OR (NEW.elev2 <> OLD.elev2) THEN
				UPDATE arc SET elev1=NEW.elev1, elev2=NEW.elev2 WHERE arc_id=NEW.arc_id;
			END IF;

			IF (NEW.custom_y1 <> OLD.custom_y1) OR (NEW.custom_y2 <> OLD.custom_y2) THEN
				UPDATE arc SET custom_y1=NEW.custom_y1, custom_y2=NEW.custom_y2 WHERE arc_id=NEW.arc_id;
			END IF;	
		
			UPDATE arc SET 	arccat_id=NEW.arccat_id, sector_id=NEW.sector_id, annotation= NEW.annotation, 
			custom_length=NEW.custom_length, inverted_slope=NEW.inverted_slope
			WHERE arc_id = OLD.arc_id;
		END IF;

        IF (v_epa_type = 'CONDUIT') THEN 
            UPDATE inp_conduit 
			SET barrels=NEW.barrels,culvert=NEW.culvert,kentry=NEW.kentry,kexit=NEW.kexit,kavg=NEW.kavg,flap=NEW.flap,q0=NEW.q0,qmax=NEW.qmax, seepage=NEW.seepage, custom_n=NEW.custom_n 
			WHERE arc_id=OLD.arc_id;
			
        ELSIF (v_epa_type = 'PUMP') THEN 
            UPDATE inp_pump 
			SET curve_id=NEW.curve_id,status=NEW.status,startup=NEW.startup,shutoff=NEW.shutoff 
			WHERE arc_id=OLD.arc_id;
			
        ELSIF (v_epa_type = 'ORIFICE') THEN 
            UPDATE inp_orifice 
			SET ori_type=NEW.ori_type,"offset"=NEW."offset",cd=NEW.cd,orate=NEW.orate,flap=NEW.flap,shape=NEW.shape,geom1=NEW.geom1,geom2=NEW.geom2,geom3=NEW.geom3,geom4=NEW.geom4 
			WHERE arc_id=OLD.arc_id;
			
        ELSIF (v_epa_type = 'WEIR') THEN 
            UPDATE inp_weir 
			SET weir_type=NEW.weir_type,"offset"=NEW."offset",cd=NEW.cd,ec=NEW.ec,cd2=NEW.cd2,flap=NEW.flap,geom1=NEW.geom1,geom2=NEW.geom2,geom3=NEW.geom3,geom4=NEW.geom4,surcharge=NEW.surcharge 
			WHERE arc_id=OLD.arc_id;
			
        ELSIF (v_epa_type = 'OUTLET') THEN 
            UPDATE inp_outlet 
			SET  outlet_type=NEW.outlet_type, "offset"=NEW."offset", curve_id=NEW.curve_id, cd1=NEW.cd1,cd2=NEW.cd2,flap=NEW.flap 
			WHERE arc_id=OLD.arc_id;
			
      	ELSIF (v_epa_type = 'VIRTUAL') THEN 
		
			IF NEW.add_length IS NULL THEN
				NEW.add_length = FALSE;
			END IF;
			
			IF NEW.fusion_node IS NULL THEN
				NEW.fusion_node = (SELECT node_id FROM v_edit_node, v_edit_arc WHERE arc_id=OLD.arc_id 
				AND (node_id=NEW.node_1 OR node_id=NEW.node_2) AND v_epa_type='JUNCTION');
			END IF;
		
            UPDATE inp_virtual 
			SET  to_arc=NEW.to_arc, fusion_node=NEW.fusion_node, add_length=NEW.add_length
			WHERE arc_id=OLD.arc_id;
        END IF;
		
        RETURN NEW;


    ELSIF TG_OP = 'DELETE' THEN
    	RETURN gw_fct_audit_function(1028,1208, NULL);

    END IF;
    
END;
$$;
   
   