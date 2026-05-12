/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: 3468

-- DROP FUNCTION cm.gw_fct_cm_polygon_geom(json);
CREATE OR REPLACE FUNCTION cm.gw_fct_cm_polygon_geom(p_params json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
SELECT cm.gw_fct_cm_polygon_geom('{"id":1, "name":"lot"}');
*/

DECLARE 
    p_campaign_lot_id integer;
    p_type text;
    collect_aux public.geometry;
    v_projecttype text;
    v_ret json;
    v_error_context text;
    v_version text;
    v_message text;
    v_target_srid integer;
    v_sql text;
    v_prev_search_path text;

BEGIN 
    -- Get params
    p_campaign_lot_id := p_params->>'id';
    p_type := p_params->>'name';

    -- Get version
    SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

    v_prev_search_path := current_setting('search_path');
    PERFORM set_config('search_path', 'cm,public', true);


	IF lower(p_type) = 'lot' then
		
        -- Dynamically get the SRID of the target geometry column
        SELECT Find_SRID('cm', 'om_campaign_lot', 'the_geom') INTO v_target_srid;

		v_sql := 'WITH polygon AS (SELECT st_collect(f.the_geom) g FROM (' ||
            'SELECT c.the_geom FROM cm.om_campaign_x_arc c JOIN cm.om_campaign_lot_x_arc l ON c.arc_id = l.arc_id 
			WHERE l.lot_id=' ||p_campaign_lot_id||
            ' UNION ' ||
            'SELECT c.the_geom FROM cm.om_campaign_x_node c JOIN cm.om_campaign_lot_x_node l ON c.node_id = l.node_id
			WHERE l.lot_id=' ||p_campaign_lot_id||
            ' UNION ' ||
            'SELECT c.the_geom FROM cm.om_campaign_x_connec c JOIN cm.om_campaign_lot_x_connec l ON c.connec_id = l.connec_id
			WHERE l.lot_id=' ||p_campaign_lot_id||
            ' UNION ' ||
            'SELECT c.the_geom FROM cm.om_campaign_x_link c JOIN cm.om_campaign_lot_x_link l ON c.link_id = l.link_id
			WHERE l.lot_id=' ||p_campaign_lot_id||'';

        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'cm' AND table_name = 'om_campaign_lot_x_gully') THEN
            v_sql := v_sql || ' UNION ' ||
                'SELECT c.the_geom FROM cm.om_campaign_x_gully c JOIN cm.om_campaign_lot_x_gully l ON c.gully_id = l.gully_id
				WHERE l.lot_id=' ||p_campaign_lot_id||'';
        END IF;

        v_sql := v_sql || ') f) ' ||
            'SELECT CASE ' ||
            'WHEN st_geometrytype(st_concavehull(g, 0.85)) = ''ST_Polygon''::text ' ||
            'THEN ST_Transform(st_buffer(st_concavehull(g, 0.85), 3), ' || v_target_srid || ') ' ||
            'ELSE ST_Transform(st_expand(st_buffer(g, 3::double precision), 1::double precision), ' || v_target_srid || ') ' ||
            'END AS the_geom FROM polygon';

        EXECUTE 'SELECT st_multi(the_geom) FROM (' || v_sql || ') a' INTO collect_aux;
	
			-- Update geometry field
			UPDATE cm.om_campaign_lot SET the_geom=collect_aux WHERE lot_id=p_campaign_lot_id;

	ELSIF lower(p_type) = 'campaign' then
		
        -- Dynamically get the SRID of the target geometry column
        SELECT Find_SRID('cm', 'om_campaign', 'the_geom') INTO v_target_srid;

		v_sql := 'WITH polygon AS (SELECT st_collect(f.the_geom) g FROM (' ||
            'select the_geom from om_campaign_x_arc where campaign_id = ' || p_campaign_lot_id ||
            ' UNION ' ||
            'select the_geom from om_campaign_x_node where campaign_id = ' || p_campaign_lot_id ||
            ' UNION ' ||
            'select the_geom from om_campaign_x_connec where campaign_id = ' || p_campaign_lot_id ||
            ' UNION ' ||
            'select the_geom from om_campaign_x_link where campaign_id = ' || p_campaign_lot_id;

        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'cm' AND table_name = 'om_campaign_x_gully') THEN
            v_sql := v_sql || ' UNION ' ||
                'select the_geom from om_campaign_x_gully where campaign_id = ' || p_campaign_lot_id;
        END IF;

        v_sql := v_sql || ') f) ' ||
            'SELECT CASE ' ||
            'WHEN st_geometrytype(st_concavehull(g, 0.85)) = ''ST_Polygon''::text ' ||
            'THEN ST_Transform(st_buffer(st_concavehull(g, 0.85), 3), ' || v_target_srid || ') ' ||
            'ELSE ST_Transform(st_expand(st_buffer(g, 3::double precision), 1::double precision), ' || v_target_srid || ') ' ||
            'END AS the_geom FROM polygon';
        
        EXECUTE 'SELECT st_multi(the_geom) FROM (' || v_sql || ') a' INTO collect_aux;
	
			-- Update geometry field
			UPDATE om_campaign SET the_geom=collect_aux WHERE campaign_id=p_campaign_lot_id;

	END IF;
    -- Return
    v_message := format('Geometry for %s %s updated successfully', p_type, p_campaign_lot_id);

    v_ret := json_build_object(
        'status', 'Accepted',
        'message', v_message,
        'version', v_version,
        'body', json_build_object(
            'feature', json_build_object('id', p_campaign_lot_id),
            'data', json_build_object('info', 'lot/campaign geom updated')
        )
    );
    PERFORM set_config('search_path', v_prev_search_path, true);
    RETURN v_ret;

EXCEPTION WHEN OTHERS THEN
    PERFORM set_config('search_path', v_prev_search_path, true);
    RETURN json_build_object('status','Failed','message',SQLERRM,'SQLSTATE',SQLSTATE);
END;
$function$
;
