/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2542


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_arc_vnodelink_update()
  RETURNS trigger AS
$BODY$
DECLARE 
v_link record;
v_closest_point PUBLIC.geometry;

BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- only if the geometry has changed (not reversed) because reverse may not affect links....
    IF st_orderingequals(OLD.the_geom, NEW.the_geom) IS FALSE THEN
	
		-- check if there are not-selected psector affected
		IF (SELECT count (*) FROM plan_psector_x_connec WHERE arc_id = NEW.arc_id AND state_id = 1 AND psector_id NOT IN (SELECT psector_id FROM selector_psector)) > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3180", "function":"2542","debug_msg":null}}$$);';
		END IF;
		
		-- Redraw link and vnode
		FOR v_link IN SELECT v_edit_link.* FROM v_edit_connec JOIN v_edit_link ON v_edit_link.feature_id=connec_id 
		WHERE v_edit_link.feature_type='CONNEC' AND exit_type='VNODE' AND arc_id=NEW.arc_id
		LOOP
			SELECT St_closestpoint(a.the_geom, St_endpoint(v_link.the_geom)) INTO v_closest_point FROM arc a WHERE arc_id = NEW.arc_id AND a.state > 0;
			EXECUTE 'UPDATE v_edit_link SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE link_id = ' || quote_literal(v_link."link_id")
			USING v_link.the_geom, v_closest_point;

			EXECUTE 'UPDATE vnode SET the_geom = $1 WHERE vnode_id = ' || quote_literal(v_link."exit_id")
			USING v_closest_point;
			
		END LOOP;

		IF (select project_type FROM sys_version LIMIT 1)='UD' THEN
		
			-- check if there are not-selected psector affected
			IF (SELECT count (*) FROM plan_psector_x_gully WHERE arc_id = NEW.arc_id AND state_id = 1 AND psector_id NOT IN (SELECT psector_id FROM selector_psector)) > 0 THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3180", "function":"2542","debug_msg":null}}$$);' INTO v_audit_result;

			END IF;

			FOR v_link IN SELECT v_edit_link.* FROM v_edit_gully JOIN v_edit_link ON v_edit_link.feature_id=gully_id 
			WHERE v_edit_link.feature_type='GULLY' AND exit_type='VNODE' AND arc_id=NEW.arc_id
			LOOP
				SELECT St_closestpoint(a.the_geom, St_endpoint(v_link.the_geom)) INTO v_closest_point FROM arc a WHERE arc_id = NEW.arc_id AND a.state > 0;
				EXECUTE 'UPDATE v_edit_link SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE link_id = ' || quote_literal(v_link."link_id")
				USING v_link.the_geom, v_closest_point;
				
				EXECUTE 'UPDATE vnode SET the_geom = $1 WHERE vnode_id = ' || quote_literal(v_link."exit_id")
				USING v_closest_point;
			END LOOP;

		END IF;
    END IF;

    RETURN NEW;

    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
 