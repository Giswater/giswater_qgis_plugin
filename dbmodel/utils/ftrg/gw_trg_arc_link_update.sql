/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2542

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_trg_arc_vnodelink_update() CASCADE;
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_arc_link_update()
  RETURNS trigger AS
$BODY$

/*
This function redraws links when arc geometry is updated
It works over ve_link, wich means that is mandatory to activate psectors in order to do not disconnect planned links
*/

DECLARE
v_link record;
v_closest_point PUBLIC.geometry;
v_debugmsg text;
v_projecttype text;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- select config values
	SELECT upper(project_type)  INTO v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

    -- only if the geometry has changed (not reversed) because reverse may not affect links....
    IF st_orderingequals(OLD.the_geom, NEW.the_geom) IS FALSE THEN

		-- check if there are not-selected psector affected
		IF (SELECT count (*) FROM plan_psector_x_connec JOIN plan_psector USING (psector_id)
		WHERE arc_id = NEW.arc_id AND state = 1 AND status IN (1,2) AND psector_id NOT IN (SELECT psector_id FROM selector_psector WHERE cur_user=current_user)) > 0 THEN

			SELECT concat('Psector: ',string_agg(distinct name::text, ', ')) into v_debugmsg FROM plan_psector_x_connec JOIN plan_psector USING (psector_id)
			WHERE arc_id = NEW.arc_id AND state = 1 AND status IN (1,2) AND psector_id NOT IN (SELECT psector_id FROM selector_psector WHERE cur_user=current_user);

			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3180", "function":"2542","parameters":{"debugmsg":"'||v_debugmsg||'"}}}$$);';
		END IF;

		-- Redraw endpoint of link
		FOR v_link IN SELECT link.* FROM connec JOIN link ON link.feature_id=connec_id
		WHERE exit_type='ARC' AND arc_id=NEW.arc_id
		LOOP
			SELECT St_closestpoint(a.the_geom, St_endpoint(v_link.the_geom)) INTO v_closest_point FROM arc a WHERE arc_id = NEW.arc_id AND a.state > 0;
			EXECUTE 'UPDATE link SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE link_id = ' || quote_literal(v_link."link_id")
			USING v_link.the_geom, v_closest_point;
		END LOOP;

		IF v_projecttype = 'UD' THEN
			FOR v_link IN SELECT link.* FROM gully JOIN link ON link.feature_id=gully_id
			WHERE exit_type='ARC' AND arc_id=NEW.arc_id
			LOOP
				SELECT St_closestpoint(a.the_geom, St_endpoint(v_link.the_geom)) INTO v_closest_point FROM arc a WHERE arc_id = NEW.arc_id AND a.state > 0;
				EXECUTE 'UPDATE link SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE link_id = ' || quote_literal(v_link."link_id")
				USING v_link.the_geom, v_closest_point;
			END LOOP;
		END IF;
    END IF;

    RETURN NEW;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
