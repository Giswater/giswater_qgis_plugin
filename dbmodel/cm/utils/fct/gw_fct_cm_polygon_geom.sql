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
    p_lot_id integer;
    p_type text;
    collect_aux public.geometry;
    v_projecttype text;
    v_ret json;
    v_error_context text;
    v_version text;
    v_message text;


BEGIN 
    -- Get params
    p_lot_id := p_params->>'id';
    p_type := p_params->>'name';

    -- Get version
    SELECT giswater INTO v_version FROM public.sys_version ORDER BY id DESC LIMIT 1;

    --EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    SET search_path = "cm", public;


	IF lower(p_type) = 'lot' then
		
		SELECT st_multi(the_geom) INTO collect_aux FROM 
		(WITH polygon AS (SELECT st_collect(f.the_geom) g
			FROM ( select the_geom from om_campaign_lot_x_arc where lot_id=p_lot_id
			UNION
			select the_geom from om_campaign_lot_x_node where lot_id=p_lot_id
			UNION
			select the_geom from om_campaign_lot_x_connec where lot_id=p_lot_id) f)
			SELECT CASE 
			WHEN st_geometrytype(st_concavehull(g, 0.85)) = 'ST_Polygon'::text 
			THEN st_buffer(st_concavehull(g, 0.85), 3)::geometry(Polygon,8908)
			ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,8908) 
			END AS the_geom FROM polygon) a;
	
			-- Update geometry field
			UPDATE om_campaign_lot SET the_geom=collect_aux WHERE lot_id=p_lot_id;

	ELSIF lower(p_type) = 'campaign' then
		
		SELECT st_multi(the_geom) INTO collect_aux FROM 
		(WITH polygon AS (SELECT st_collect(f.the_geom) g
			FROM ( select the_geom from om_campaign_x_arc where campaign_id=p_lot_id
			UNION
			select the_geom from om_campaign_x_node where campaign_id=p_lot_id
			UNION
			select the_geom from om_campaign_x_connec where campaign_id=p_lot_id) f)
			SELECT CASE 
			WHEN st_geometrytype(st_concavehull(g, 0.85)) = 'ST_Polygon'::text 
			THEN st_buffer(st_concavehull(g, 0.85), 3)::geometry(Polygon,8908)
			ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,8908) 
			END AS the_geom FROM polygon) a;
	
			-- Update geometry field
			UPDATE om_campaign SET the_geom=collect_aux WHERE campaign_id=p_lot_id;

	END IF;
    -- Return
    v_message := format('Geometry for %s %s updated successfully', p_type, p_lot_id);

    v_ret := json_build_object(
        'status', 'Accepted',
        'message', v_message,
        'version', v_version,
        'body', json_build_object(
            'feature', json_build_object('id', p_lot_id),
            'data', json_build_object('info', 'lot/campaign geom updated')
        )
    );
    RETURN v_ret;

END;
$function$
;
