/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3490

CREATE OR REPLACE FUNCTION cm.gw_trg_cm_feature_geom()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_feature TEXT := TG_ARGV[0];
	v_campaign integer;
	id_value bigint;

BEGIN
	SELECT campaign_id INTO v_campaign FROM om_campaign_lot WHERE lot_id = NEW.lot_id;
	
	-- perform only when insert or the geometry is different
	IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND NOT ST_Equals(NEW.the_geom, OLD.the_geom)) THEN

	    IF v_feature = 'node' THEN
	        id_value := NEW.node_id;
	    ELSIF v_feature = 'arc' THEN
	        id_value := NEW.arc_id;
	    ELSIF v_feature = 'connec' THEN
	        id_value := NEW.connec_id;
	    END IF;
		
		-- update feature geometry on campaign_x_* table
	    EXECUTE format('UPDATE om_campaign_x_%I SET the_geom = $1 
	                    WHERE campaign_id = $2 AND %I = $3', 
	                    v_feature, v_feature || '_id')
	    USING NEW.the_geom, v_campaign, id_value;
		
		-- perform lot polygon geometry update
		EXECUTE format('SELECT gw_fct_cm_polygon_geom(''{"id":%s, "name":"lot"}'')', NEW.lot_id);

	END IF;

    RETURN NEW;
END;
$function$
; 