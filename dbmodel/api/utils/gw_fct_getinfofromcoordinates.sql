
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getinfofromcoordinates(
    p_x double precision,
    p_y double precision,
    p_epsg integer,
    p_active_layer text,
    p_visible_layer text,
    p_editable_layer text,
    p_device integer,
    p_info_type integer,
    p_lang character varying)
  RETURNS json AS
$BODY$
DECLARE

--    Variables
	v_point geometry;
	v_sensibility float=2;
	v_id varchar;
	v_layer text;
	v_alias text;
	v_sql text;
	v_iseditable boolean;
	v_return json;
	v_pkey text;
	schemas_array text[];
	v_count int2;
	v_geometrytype text;
	api_version text;

BEGIN


--  Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    schemas_array := current_schemas(FALSE);

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;
     	
--   Make point
     SELECT ST_SetSRID(ST_MakePoint(p_x,p_y),p_epsg) INTO v_point;

--  Get element
     v_sql := 'SELECT layer_id FROM config_web_layer WHERE layer_id= '||quote_literal(p_active_layer)||' UNION 
		  (SELECT layer_id FROM config_web_layer WHERE layer_id = any('''||p_visible_layer||'''::text[]) ORDER BY orderby)';
    FOR v_layer IN EXECUTE v_sql 
    LOOP
	        --    Get id column
		EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
			INTO v_pkey
			USING v_layer;
		
		--    For views it suposse pk is the first column
		IF v_pkey ISNULL THEN
			EXECUTE '
			SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
			AND t.relname = $1 
			AND s.nspname = $2
			ORDER BY a.attnum LIMIT 1'
				INTO v_pkey
				USING v_layer, schemas_array[1];
		END IF;

		RAISE NOTICE 'v_pkey % ', v_pkey;


		--  Indentify geometry type
		EXECUTE 'SELECT st_geometrytype (the_geom) FROM '||v_layer||';' 
		INTO v_geometrytype;

		IF v_geometrytype = 'ST_Polygon'::text OR v_geometrytype= 'ST_Multipolygon'::text THEN

			--  Get element from active layer, using the area of the elements to order possible multiselection (minor as first)
			EXECUTE 'SELECT '||v_pkey||' FROM '||v_layer||' WHERE st_dwithin ($1, '||v_layer||'.the_geom, $2) 
			ORDER BY  ST_area('||v_layer||'.the_geom) asc LIMIT 1'
				INTO v_id
				USING v_point, v_sensibility;
		ELSE
			--  Get element from active layer, using the distance from the clicked point to order possible multiselection (minor as first)
			EXECUTE 'SELECT '||v_pkey||' FROM '||v_layer||' WHERE st_dwithin ($1, '||v_layer||'.the_geom, $2) 
			ORDER BY  ST_Distance('||v_layer||'.the_geom, $1) asc LIMIT 1'
				INTO v_id
				USING v_point, v_sensibility;
		END IF;

		RAISE NOTICE 'v_layer % v_id %', v_layer, v_id;

		IF v_id IS NOT NULL THEN 
			exit;
		END IF;

	END LOOP;

--    Control NULL's
    IF v_id IS NULL THEN

      RETURN ('{"status":"Accepted", "formTabs":[], "linkPath":"", "editData":[] }')::json;

    END IF;

    v_id := COALESCE(v_id, '{}');

--   Get editability of layer
	EXECUTE 'SELECT (CASE WHEN is_editable=TRUE AND layer_id = any('''||p_visible_layer||'''::text[]) THEN TRUE ELSE FALSE END) 
			FROM config_web_layer WHERE layer_id='||quote_literal(v_layer)||';'
		INTO v_iseditable;

	
--   Call getformtabs
	SELECT gw_fct_getinfofromid(v_alias, v_layer, v_id, v_iseditable, p_device, null, p_lang) INTO v_return;

--    Return
      RETURN v_return;

--    Exception handling
      RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
