/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3184

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_connect_link_refactor() RETURNS json AS 
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_connect_link_refactor();
*/

DECLARE

v_version text;
v_project_type text;
v_result_info text;
v_result text;

rec record;
v_new_link_id integer;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- get input parameters
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
	INTO v_version;

	-- new connecs with new link
	FOR rec IN EXECUTE 'SELECT * FROM plan_psector_x_connec WHERE state=1' LOOP
		INSERT INTO link (feature_id, feature_type, exit_id, exit_type, state, expl_id, the_geom) 
		SELECT rec.connec_id, 'CONNEC', rec.arc_id, 'ARC', 2, c.expl_id, rec._link_geom_
		FROM connec c WHERE connec_id=rec.connec_id RETURNING link_id INTO v_new_link_id;
	
		UPDATE plan_psector_x_connec SET link_id=v_new_link_id WHERE connec_id=rec.connec_id;
	END LOOP;

	--old connecs with old link (obsolete)
	FOR rec IN EXECUTE 'SELECT * FROM plan_psector_x_connec WHERE state=0' LOOP
		SELECT link_id FROM link WHERE feature_id=rec.connec_id AND link.state=1 INTO v_new_link_id;
	
		UPDATE plan_psector_x_connec SET link_id=v_new_link_id WHERE connec_id=rec.connec_id;
	END LOOP;

	-- old connecs with new link
	FOR rec IN EXECUTE 'SELECT * FROM plan_psector_x_connec pg JOIN connec g USING (connec_id) WHERE pg.state=1 AND g.state=1' LOOP
		INSERT INTO link (feature_id, feature_type, exit_id, exit_type, state, expl_id, the_geom) 
		SELECT rec.connec_id, 'CONNEC', rec.arc_id, 'ARC', 2, c.expl_id, rec._link_geom_
		FROM connec c WHERE connec_id=rec.connec_id RETURNING link_id INTO v_new_link_id;
	
		UPDATE plan_psector_x_connec SET link_id=v_new_link_id WHERE connec_id=rec.connec_id;
		
		INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, link_id, active)
		SELECT rec.connec_id, connec.arc_id, rec.psector_id, 0, link_id, true
		FROM link 
        JOIN connec ON link.feature_id=connec_id
        WHERE feature_id=rec.connec_id AND link.state=1;
	END LOOP;

	IF v_project_type='UD' THEN
		
		-- new gullies with new link
		FOR rec IN EXECUTE 'SELECT * FROM plan_psector_x_gully pg JOIN gully g USING (gully_id) WHERE pg.state=1 AND g.state=2' LOOP
			INSERT INTO link (feature_id, feature_type, exit_id, exit_type, state, expl_id, the_geom) 
			SELECT rec.gully_id, 'GULLY', rec.arc_id, 'ARC', 2, c.expl_id, rec._link_geom_
			FROM gully c WHERE gully_id=rec.gully_id RETURNING link_id INTO v_new_link_id;
		
			UPDATE plan_psector_x_gully SET link_id=v_new_link_id WHERE gully_id=rec.gully_id;
		END LOOP;
	
		-- old gullies with old link (obsolete)
		FOR rec IN EXECUTE 'SELECT * FROM plan_psector_x_gully WHERE state=0' LOOP
			SELECT link_id FROM link WHERE feature_id=rec.gully_id AND link.state=1 INTO v_new_link_id;
		
			UPDATE plan_psector_x_gully SET link_id=v_new_link_id WHERE gully_id=rec.gully_id;
		END LOOP;
	
		-- old gullies with new link
		FOR rec IN EXECUTE 'SELECT * FROM plan_psector_x_gully pg JOIN gully g USING (gully_id) WHERE pg.state=1 AND g.state=1' LOOP
			INSERT INTO link (feature_id, feature_type, exit_id, exit_type, state, expl_id, the_geom) 
			SELECT rec.gully_id, 'GULLY', rec.arc_id, 'ARC', 2, c.expl_id, rec._link_geom_
			FROM gully c WHERE gully_id=rec.gully_id RETURNING link_id INTO v_new_link_id;
		
			UPDATE plan_psector_x_gully SET link_id=v_new_link_id WHERE gully_id=rec.gully_id;
			
			INSERT INTO plan_psector_x_gully (gully_id, arc_id, psector_id, state, link_id, active)
			SELECT rec.gully_id, gully.arc_id, rec.psector_id, 0, link_id, true
			FROM link 
			JOIN gully ON link.feature_id = gully.gully_id
			WHERE feature_id=rec.gully_id AND link.state=1;
		END LOOP;
	END IF;

	-- Control nulls
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"values":',v_result, '}');
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_version := COALESCE(v_version, '[]');

	-- return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "version":'||v_version||
            ',"message":{"level":1, "text":""},"body":{"data": {"info":'||v_result_info||'}}}')::json, 3184, null, null, null);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
