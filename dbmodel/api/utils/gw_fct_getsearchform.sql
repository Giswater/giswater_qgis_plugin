
CREATE OR REPLACE FUNCTION ws_sample.gw_fct_getformsearch(
    tab_id_arg integer,
    filterval_arg character varying)
  RETURNS json AS
$BODY$
DECLARE

--    Variables
	combo_rows json[];
	combo_json json;
	fields_array json[];
	aux_json json;    
	query_result character varying;
	fields json;
	formToDisplayId character varying;
	formToDisplayName character varying;
	position json;
	schemas_array name[];
	arclayer character varying;
	nodelayer character varying;
	conneclayer character varying;
	gullylayer character varying;
	elementlayer character varying;
	explayer character varying ;
	hydrolayer character varying;
	workcatlayer character varying;
	psectorlayer character varying;
	query_text text;


BEGIN


--  Set search path to local schema
    SET search_path = "ws_sample", public;

--  Get schema name
    schemas_array := current_schemas(FALSE);

    formToDisplayId='F58';

    arclayer := 'v_edit_arc';  -- SELECT layer_id from ?? where class_id='arc' LIMIT 1;
    nodelayer := 'v_edit_node'; -- SELECT layer_id from ?? where class_id='node'  LIMIT 1;
    conneclayer := 'v_edit_connec'; -- SELECT layer_id from ?? where class_id='connec' LIMIT 1;
    gullylayer := 'v_edit_gully'; -- SELECT layer_id from ?? where class_id='gully' LIMIT 1;
    elementlayer := 'v_edit_element'; -- SELECT layer_id from ?? where class_id='element' LIMIT 1;
    explayer  := 'exploitation'; -- SELECT layer_id from ?? where class_id='exploitation' LIMIT 1;
    hydrolayer := 'hydrometer'; -- SELECT layer_id from ?? where class_id='hydrometer' LIMIT 1;
    workcatlayer := 'v_workcat'; -- SELECT layer_id from ?? where class_id='workcat' LIMIT 1;
    psectorlayer := 'v_edit_psector'; -- SELECT layer_id from ?? where class_id='psector' LIMIT 1;

/*TO DO:
 Connectar els fields amb els comborows
    Get form combos
    EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT label, name, type, "dataType", placeholder FROM config_web_fields WHERE table_id = $1) a'
        INTO fields_array
        USING formToDisplayId;  
    
*/

--  1st combo values
	IF tab_id_arg = 1 THEN
	-- tab_id_arg1=(arc/node/connec/gully/element)
		query_text := array_agg('node','arc','connec','element');

	ELSIF tab_id_arg = 2 THEN
	-- tab_id_arg2=list of exploitation
		query_text := (SELECT expl_id as id, name as name FROM explayer);


	ELSIF tab_id_arg= 3 THEN
	-- tab_id_arg3=(workcat/psector)
		query_text := array_agg('workcat', 'psector');

	END IF;
	
    	-- id
	EXECUTE 'SELECT array_to_json(array_agg(SELECT id from '||query_text||'))'
			INTO combo_json;
			fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'comboIds', COALESCE(combo_json, '[]'));
			fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'selectedId', combo_json->0);

        -- name
	EXECUTE 'SELECT array_to_json(array_agg(SELECT name from '||query_text||'))'
			INTO combo_json;
			fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'comboNames', combo_json);


-- 2nd combo values (filtered by first combo values (or not)
	IF tab_id_arg = 1 THEN
	-- tab_id_arg1=list of arc/node/connec/gully/element    
		query_text :=  'SELECT *  FROM (
				SELECT arc_id as id, code as name, arc_id as sys_id, ''arc''::text as sys_class, '||arclayer||' as sys_layer FROM '||arclayer||' UNION 
				SELECT node_id as id, code as name, node_id as sys_id, ''node''::text as sys_class, '||nodelayer||' as sys_layer  FROM '||nodelayer||' UNION 
				SELECT connec_id as id, code as name, connec_id as sys_id, ''connec''::text as sys_class, '||conneclayer||' as sys_layer  FROM '||conneclayer||' UNION 
				SELECT element_id as id, code as name, element_id as sys_id, ''element''::text as sys_class, '||elementlayer||' as sys_layer  FROM '||elementlayer||')';
				
		IF filterval_arg IS NOT NULL THEN
			query_text :=   concat (query_text, 'WHERE sys_class=',filterval_arg);
		END IF;
		
	ELSIF tab_id_arg = 2 THEN
	-- tab_id_arg2=list of hydrometers
		query_text :=   'SELECT hydro_id as id, code as name, connec_id as sys_id, ''hydrometer''::text as sys_class, FROM '||hydrometer;

		IF filterval_arg IS NOT NULL THEN
			query_text :=   concat (query_text, 'WHERE expl_id=',filterval_arg);
		END IF;
		
	ELSIF tab_id_arg= 3 THEN
	-- tab_id_arg3=list of workcat / psector
		query_text :=  'SELECT * FROM (
				SELECT workcat_id as id, name as name, workcat_id as sys_id, ''workcat''::text as sys_class, '||workcatlayer||' as sys_layer FROM '||workcatlayer||' UNION 
				SELECT psector_id as id, name as name, psector_id as sys_id, ''psector''::text as sys_class, '||psectorlayer||' as sys_layer FROM '||psectorlayer||')';

		IF filterval_arg IS NOT NULL THEN
			query_text :=   concat (query_text, 'WHERE sys_class=',filterval_arg);
		END IF;	
	END IF;

	-- id
	EXECUTE 'SELECT array_to_json(array_agg(SELECT id from '||query_text||'))'
		INTO combo_json;
		fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'comboIds', COALESCE(combo_json, '[]'));
		fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'selectedId', combo_json->0);

        -- name
	EXECUTE 'SELECT array_to_json(array_agg(SELECT name from '||query_text||'))'
		INTO combo_json;
		fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'comboNames', combo_json);

	-- sys_id
	EXECUTE 'SELECT array_to_json(array_agg(SELECT sys_id from '||query_text||'))'
		INTO combo_json;
		fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'comboSysIds', combo_json);

	-- sys_class
	EXECUTE 'SELECT array_to_json(array_agg(SELECT sys_class from '||query_text||'))'
		INTO combo_json;
		fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'comboSysClass', combo_json);

	-- sys_layer
	EXECUTE 'SELECT array_to_json(array_agg(SELECT sys_layer from '||query_text||'))'
		INTO combo_json;
		fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'comboSysLayer', combo_json);

--    	Convert to json
	fields := array_to_json(fields_array);

--    	Control NULL's
	formToDisplayId := COALESCE(formToDisplayId, '');
	fields := COALESCE(fields, '[]');    
	position := COALESCE(position, '[]');

--    	Return
	RETURN ('{"status":"Accepted"' ||
		', "formToDisplay":"' || formToDisplayId || '"' ||
		', "fields":' || fields ||
		'}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

