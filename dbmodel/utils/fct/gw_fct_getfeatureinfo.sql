/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2558

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_get_featureinfo(character varying, character varying, integer, integer, boolean);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_get_featureinfo(character varying, character varying, integer, integer, boolean, text, text, text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getfeatureinfo(
    p_table_id character varying,
    p_id character varying,
    p_device integer,
    p_infotype integer,
    p_configtable boolean,
    p_idname text,
    p_columntype text,
    p_tgop text)
  RETURNS json AS
$BODY$

/*example
SELECT SCHEMA_NAME.gw_fct_getfeatureinfo('ve_arc_pipe', '2001', 3, 100, 'false')
SELECT SCHEMA_NAME.gw_fct_getfeatureinfo('ve_arc_conduit', '2001', 3, 100, 'true', 'arc_id', 'varchar(16)')
*/

DECLARE

fields json;
fields_array json[];
aux_json json;    
schemas_array name[];
array_index integer DEFAULT 0;
field_value character varying;
v_version json;
v_values_array json;
v_formtype text;
v_tabname text = 'data';

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
    
	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;

	--    Get schema name
	schemas_array := current_schemas(FALSE);
	
	-- getting values from feature
	EXECUTE 'SELECT (row_to_json(a)) FROM (SELECT * FROM '||quote_ident(p_table_id)||' WHERE '||quote_ident(p_idname)||' = CAST($1 AS '||(p_columntype)||'))a'
	    INTO v_values_array
	    USING p_id;

	IF  p_configtable THEN 

		raise notice 'Configuration fields are defined on config_info_layer_field, calling gw_fct_getformfields with formname: % tablename: % id %', p_table_id, p_table_id, p_id;

		-- Call the function of feature fields generation
		v_formtype = 'form_feature';
		SELECT gw_fct_getformfields( p_table_id, v_formtype, 'data', p_table_id, p_idname, p_id, null, 'SELECT',null, p_device, v_values_array) INTO fields_array;
	ELSE
		raise notice 'Configuration fields are NOT defined on config_info_layer_field. System values will be used';
		
		IF p_id IS NULL THEN
			RETURN '{}'; -- returning null for those layers are not configured and id is null (first call on load project)
			
		ELSE
			-- Get fields
			EXECUTE 'SELECT array_agg(row_to_json(a)) FROM 
				(SELECT a.attname as label, 
				concat('||quote_literal(v_tabname)||',''_'',a.attname) AS widgetname,
				(case when a.atttypid=16 then ''check'' else ''text'' end ) as widgettype, 
				(case when a.atttypid=16 then ''boolean'' else ''string'' end ) as "datatype", 
				''::TEXT AS tooltip, 
				''::TEXT as placeholder, 
				false AS iseditable,
				row_number()over() AS orderby, 
				null as stylesheet, 
				row_number()over() AS layoutorder,
				FALSE AS isparent, 
				null AS widgetfunction, 
				null AS linkedaction, 
				FALSE AS isautoupdate,
				''lyt_data_1'' AS layoutname, 
				null as widgetcontrols,
				FALSE as hidden
				FROM pg_attribute a
				JOIN pg_class t on a.attrelid = t.oid
				JOIN pg_namespace s on t.relnamespace = s.oid
				WHERE a.attnum > 0 
				AND NOT a.attisdropped
				AND t.relname = $1 
				AND s.nspname = $2
				AND a.attname !=''the_geom''
				AND a.attname !=''geom''
				ORDER BY a.attnum) a'
				INTO fields_array
				USING p_table_id, schemas_array[1]; 
		END IF;
	END IF;

	IF p_tgop !='LAYER' THEN
	
		-- Fill every value
		FOREACH aux_json IN ARRAY fields_array
		LOOP
			array_index := array_index + 1;
			field_value := (v_values_array->>(aux_json->>'columnname'));
			field_value := COALESCE(field_value, '');
		
			-- Update array
			IF (aux_json->>'widgettype')='combo' THEN
				fields_array[array_index] := gw_fct_json_object_set_key(fields_array[array_index], 'selectedId', field_value);
			ELSE
				fields_array[array_index] := gw_fct_json_object_set_key(fields_array[array_index], 'value', field_value);
			END IF;   
		END LOOP;
		
	END IF;
   
	-- Convert to json
	fields := array_to_json(fields_array);

	-- Control NULL's
	fields := COALESCE(fields, '[]');    

	-- Return
	RETURN  fields;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;