/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3380

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getlayerstofilter(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getlayerstofilter(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
SELECT SCHEMA_NAME.gw_fct_getselectorsfiltered($${"client":{"device": 5, "lang": "es_ES", "cur_user": "bgeo", "tiled": "False", "infoType": 1}, "form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "filter": ["muni_id", "sector_id"],"layers": ["Node","Connec"]}}$$);
*/

DECLARE

v_layer text;
v_msgerr json;
v_version text;
v_errcontext text;
v_device integer;
v_layers jsonb;
v_cur_user text;
v_layersFiltered text[] := ARRAY[]::text[];
v_columns jsonb;
v_schemaname text = 'SCHEMA_NAME';
v_filter jsonb;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  get api version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get input parameters:
	v_cur_user := (p_data ->> 'client')::json->> 'cur_user';
	v_device := (p_data ->> 'client')::json->> 'device';
	v_filter := (p_data ->> 'data')::jsonb->> 'filter';
	v_layers := (p_data ->> 'data')::jsonb->> 'layers';

	FOR v_layer IN SELECT jsonb_array_elements_text(v_layers)
	LOOP
		SELECT json_agg(column_name) INTO v_columns FROM information_schema.columns WHERE table_schema = v_schemaname AND table_name = lower(v_layer);
		-- Check if v_columns contain the columns filter
		IF v_columns @> v_filter THEN
			v_layersFiltered := array_append(v_layersFiltered,v_layer);
		END IF;
	END LOOP;

	RETURN gw_fct_json_create_return(json_build_object(
	    'status', 'Accepted',
	    'version', v_version,
		'body', json_build_object('layers', v_layersFiltered)
	),3380, null, null, NULL);

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;
	RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE, 'MSGERR', (v_msgerr::json ->> 'MSGERR'))::json;

END;
$function$
;
