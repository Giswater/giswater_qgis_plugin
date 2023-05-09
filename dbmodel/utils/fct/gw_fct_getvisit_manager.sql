CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getvisit_manager(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

declare
  aux_json json;   
  array_index integer DEFAULT 0;
  field_value character varying;
  v_querystring text;
  v_debug_vars json;
  v_debug json;
  v_msgerr json;
  v_querytext text;
  v_selected_id text;
  v_selected_idval text;
  v_current_id text;
  v_new_id text; 
  v_widgetcontrols json;
  v_values_array json;
  v_widgetvalues json;
 
  v_fields_array json[];
  v_fieldsjson jsonb := '[]';
  v_version json;
  v_response json;

BEGIN
  -- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	  -- Get api version
  v_version := row_to_json(row) FROM (
    SELECT value FROM config_param_system WHERE parameter='admin_version'
  ) row;
 
  SELECT gw_fct_getformfields(
    'visit_manager',
    'form_visit',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
  ) INTO v_fields_array;
  
 
  v_fieldsjson := to_json(v_fields_array);

  v_response := '{
    "status": "Accepted",
    "version": '|| v_version ||',
    "body": {
      "data": {
        "fields": '|| v_fieldsjson ||'
      },
	  "feature": {
		"idName": "",
		"id": ""
      }
    }
  }';
  RETURN v_response;
  -- RETURN v_fields_array;
END;
$function$
;
