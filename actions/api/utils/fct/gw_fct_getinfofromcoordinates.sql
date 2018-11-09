/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getinfofromcoordinates"(p_x float8, p_y float8, p_epsg int4, p_active_layer text, p_visible_layer text, p_editable_layer text, p_istilemap bool, p_zoom_ratio float8, p_device int4, p_info_type int4, p_lang varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    v_point geometry;
    v_sensibility float;
    v_sensibility_f float;
    v_id varchar;
    v_layer text;
    v_alias text;
    v_sql text;
    v_iseditable boolean;
    v_return json;
    v_idname text;
    schemas_array text[];
    v_count int2=0;
    v_geometrytype text;
    api_version text;
    v_the_geom text;
    v_tiled_layer text[];
    
BEGIN

--  Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    schemas_array := current_schemas(FALSE);

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

-- Sensibility factor
    IF p_device=1 OR p_device=2 THEN
        EXECUTE 'SELECT value::float FROM config_param_system WHERE parameter=''api_sensibility_factor_mobile'''
            INTO v_sensibility_f;
    ELSE 
        EXECUTE 'SELECT value::float FROM config_param_system WHERE parameter=''api_sensibility_factor_web'''
            INTO v_sensibility_f;
    END IF;

    -- 10 pixels of base sensibility
    v_sensibility = (p_zoom_ratio * 10 * v_sensibility_f);
         
--   Make point
     SELECT ST_SetSRID(ST_MakePoint(p_x,p_y),p_epsg) INTO v_point;

--  Get layer and element
    IF p_istilemap IS TRUE THEN
    v_sql := 'SELECT layer_id, 0 as orderby FROM config_web_layer WHERE layer_id= '||quote_literal(p_active_layer)||' UNION 
          SELECT layer_id, orderby FROM config_web_layer WHERE is_tiled IS TRUE UNION
          SELECT layer_id, orderby FROM config_web_layer WHERE layer_id = any('''||p_visible_layer||'''::text[]) ORDER BY orderby';
    ELSE

    v_sql := 'SELECT layer_id, 0 as orderby FROM config_web_layer WHERE layer_id= '||quote_literal(p_active_layer)||' UNION 
          SELECT layer_id, orderby FROM config_web_layer WHERE layer_id = any('''||p_visible_layer||'''::text[]) ORDER BY orderby';
    END IF;

    FOR v_layer IN EXECUTE v_sql 
    LOOP

        RAISE NOTICE 'v_layer %', v_layer;
        
        v_count=v_count+1;
            --    Get id column
        EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
            INTO v_idname
            USING v_layer;
        
        --    For views it suposse pk is the first column
        IF v_idname ISNULL THEN
            EXECUTE '
            SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
            AND t.relname = $1 
            AND s.nspname = $2
            ORDER BY a.attnum LIMIT 1'
                INTO v_idname
                USING v_layer, schemas_array[1];
        END IF;

        --     Get geometry_column
        EXECUTE 'SELECT attname FROM pg_attribute a        
            JOIN pg_class t on a.attrelid = t.oid
            JOIN pg_namespace s on t.relnamespace = s.oid
            WHERE a.attnum > 0 
            AND NOT a.attisdropped
            AND t.relname = $1
            AND s.nspname = $2
            AND left (pg_catalog.format_type(a.atttypid, a.atttypmod), 8)=''geometry''
            ORDER BY a.attnum' 
            INTO v_the_geom
            USING v_layer, schemas_array[1];


        --  Indentify geometry type
        EXECUTE 'SELECT st_geometrytype ('||v_the_geom||') FROM '||v_layer||';' 
        INTO v_geometrytype;

        IF v_geometrytype = 'ST_Polygon'::text OR v_geometrytype= 'ST_Multipolygon'::text THEN

            --  Get element from active layer, using the area of the elements to order possible multiselection (minor as first)
            EXECUTE 'SELECT "'||v_idname||'" FROM "'||v_layer||'" WHERE st_dwithin ($1, '||v_layer||'.'||v_the_geom||', $2) 
            ORDER BY  ST_area('||v_layer||'.'||v_the_geom||') asc LIMIT 1'
                INTO v_id
                USING v_point, v_sensibility;
        ELSE
            --  Get element from active layer, using the distance from the clicked point to order possible multiselection (minor as first)
            EXECUTE 'SELECT "'||v_idname||'" FROM "'||v_layer||'" WHERE st_dwithin ($1, '||v_layer||'.'||v_the_geom||', $2) 
            ORDER BY  ST_Distance('||v_layer||'.'||v_the_geom||', $1) asc LIMIT 1'
                INTO v_id
                USING v_point, v_sensibility;
        END IF;

        IF v_id IS NOT NULL THEN 
	    RAISE NOTICE 'Founded (loop number: %):  Layer: % ,idname: %, id: %', v_count, v_layer, v_idname, v_id;    
            exit;
        ELSE 
            RAISE NOTICE 'Searching for layer....loop number: % layer: % ,idname: %, id: %', v_count, v_layer, v_idname, v_id;    
        END IF;

    END LOOP;

    --    Control NULL's
    IF v_id IS NULL THEN
     RETURN ('{"status":"Accepted", "apiVersion":'|| api_version || ', "results":0' ||', "formTabs":[] , "tableName":"", "idName": "", "geometry":"", "linkPath":"", "editData":[] }')::json;

    END IF;

--   Get editability of layer
    EXECUTE 'SELECT (CASE WHEN is_editable=TRUE AND layer_id='||quote_literal(p_active_layer)||' AND layer_id = any('''||p_editable_layer||'''::text[]) THEN TRUE ELSE FALSE END) 
            FROM config_web_layer WHERE layer_id='||quote_literal(v_layer)||';'
        INTO v_iseditable;

----------------------------------------------
-- IMPROVE THE EDITABILITY OF THE LAYER......
----------------------------------------------
-- TODO
    
--   Call getinfofromid
    SELECT gw_fct_getinfofromid(v_alias, v_layer, v_id, v_iseditable, p_device, p_info_type, p_lang) INTO v_return;

--    Return
      RETURN v_return;

--    Exception handling
 --     RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

