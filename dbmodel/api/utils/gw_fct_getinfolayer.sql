


CREATE OR REPLACE FUNCTION ws_sample.gw_fct_getinfolayer(
    p_x float,
    p_y float,
    p_epsg integer,
    p_active_layer text,
    p_visible_layer text,
    p_device integer,
    p_info_type integer,
    p_lang varchar)
    
  RETURNS json AS
$BODY$
DECLARE

--    Variables
	v_point geometry;
	v_sensibility float=30;
	v_id varchar;
	v_layer text;
	v_alias text;
	v_sql text;
	v_iseditable boolean;

BEGIN


--    Set search path to local schema
    SET search_path = "ws_sample", public;

     		RAISE NOTICE 'p_visible_layer %', p_visible_layer;


--   Make point
     SELECT ST_SetSRID(ST_MakePoint(p_x,p_y),p_epsg) INTO v_point;

--   Get element from active layer
    EXECUTE 'SELECT connec_id FROM '||p_active_layer||' WHERE st_dwithin ($2, '||p_active_layer||'.the_geom, $3) 
    ORDER BY  ST_Distance('||p_active_layer||'.the_geom, $2) desc LIMIT 1'
    INTO v_id
    USING p_active_layer, v_point, v_sensibility;

    		RAISE NOTICE 'v_layer % v_id %', v_layer, v_id;


--  Get element from visible layers
    IF-- v_id IS NOT NULL AND 
    p_visible_layer IS NOT NULL THEN 

	v_sql := 'SELECT layer_id, alias_id FROM config_web_layer WHERE layer_id = any('''||p_visible_layer||'''::text[]) ORDER BY orderby';
    
	FOR v_layer, v_alias IN EXECUTE v_sql 
	LOOP
		
		EXECUTE 'SELECT '||v_alias||'_id FROM '||v_layer||' WHERE st_dwithin ($2, '||v_layer||'.the_geom, $3) 
		ORDER BY  ST_Distance('||v_layer||'.the_geom, $2) desc LIMIT 1'
		INTO v_id
		USING p_active_layer, v_point, v_sensibility;

		RAISE NOTICE 'v_layer % v_id %', v_layer, v_id;

		IF v_id IS NOT NULL THEN 
			exit;
		END IF;

	END LOOP;

    END IF;

--    Control NULL's
    v_id := COALESCE(v_id, '{}');

--   Get editability of layer
	v_iseditable := (SELECT is_editable FROM config_web_layer WHERE layer_id = v_layer);
    
--   Call getformtabs
	SELECT gw_fct_getformtabs(v_alias, v_layer, v_id, 


table_id_arg character varying,
    id character varying,
    editable boolean,
    device integer,
    user_id character varying,
    lang character varying)
     

--    Exception handling
      RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
