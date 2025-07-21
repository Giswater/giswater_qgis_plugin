-- DROP FUNCTION cm.gw_fct_cm_lot_geom(int4, text);

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_lot_geom(p_lot_id integer, p_type text)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$

/*
SELECT cm.gw_fct_cm_lot_geom(1, 'LOT');
*/

DECLARE 
    
collect_aux public.geometry;
v_projecttype text;


BEGIN 

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


	RETURN 0;
END;
$function$
;
