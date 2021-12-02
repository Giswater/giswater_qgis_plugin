/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2542


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_arc_vnodelink_update()
  RETURNS trigger AS
$BODY$

/*
This function redraws links when arc geometry is updated
It works over v_edit_link, wich means that is mandatory to activate psectors in order to do not disconnect planned links
*/

DECLARE 
v_link record;
v_closest_point PUBLIC.geometry;
v_debugmsg text;

BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- only if the geometry has changed (not reversed) because reverse may not affect links....
    IF st_orderingequals(OLD.the_geom, NEW.the_geom) IS FALSE THEN
	
		-- check if there are not-selected psector affected
		IF (SELECT count (*) FROM plan_psector_x_connec JOIN plan_psector USING (psector_id) 
		WHERE arc_id = NEW.arc_id AND state = 1 AND status IN (1,2) AND psector_id NOT IN (SELECT psector_id FROM selector_psector)) > 0 THEN
			
			SELECT concat('Psector: ',string_agg(distinct name::text, ', ')) into v_debugmsg FROM plan_psector_x_connec JOIN plan_psector USING (psector_id) 
			WHERE arc_id = NEW.arc_id AND state = 1 AND status IN (1,2) AND psector_id NOT IN (SELECT psector_id FROM selector_psector);

			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3180", "function":"2542","debug_msg":"'||v_debugmsg||'"}}$$);';								
		END IF;
		
		-- Redraw link and vnode
		FOR v_link IN SELECT link.* FROM v_edit_connec JOIN link ON link.feature_id=connec_id 
		WHERE link.feature_type='CONNEC' AND exit_type='VNODE' AND arc_id=NEW.arc_id
		LOOP
			SELECT St_closestpoint(a.the_geom, St_endpoint(v_link.the_geom)) INTO v_closest_point FROM arc a WHERE arc_id = NEW.arc_id AND a.state > 0;
			EXECUTE 'UPDATE v_edit_link SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE link_id = ' || quote_literal(v_link."link_id")
			USING v_link.the_geom, v_closest_point;

			EXECUTE 'UPDATE vnode SET the_geom = $1 WHERE vnode_id = ' || quote_literal(v_link."exit_id")
			USING v_closest_point;
			
		END LOOP;

		IF (select project_type FROM sys_version ORDER BY id DESC LIMIT 1)='UD' THEN
		
			-- check if there are not-selected psector affected
			IF (SELECT count (*) FROM plan_psector_x_gully JOIN plan_psector USING (psector_id) 
			WHERE arc_id = NEW.arc_id AND state = 1 AND status IN (1,2) AND psector_id NOT IN (SELECT psector_id FROM selector_psector)) > 0 THEN

				SELECT concat('Psector: ',string_agg(distinct name::text, ', ')) into v_debugmsg FROM plan_psector_x_gully JOIN plan_psector USING (psector_id) 
				WHERE arc_id = NEW.arc_id AND state = 1 AND status IN (1,2) AND psector_id NOT IN (SELECT psector_id FROM selector_psector);

				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3180", "function":"2542","debug_msg":"'||v_debugmsg||'"}}$$);';								
			END IF;

			FOR v_link IN SELECT link.* FROM v_edit_gully JOIN link ON link.feature_id=gully_id 
			WHERE link.feature_type='GULLY' AND exit_type='VNODE' AND arc_id=NEW.arc_id
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
 