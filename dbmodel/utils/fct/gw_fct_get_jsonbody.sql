-- Function: SCHEMA_NAME.gw_fct_get_jsonbody(json)

-- DROP FUNCTION SCHEMA_NAME.gw_fct_get_jsonbody(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_get_jsonbody(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_get_jsonbody('{"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{},"data":{"parameters":{"text":"Data quality analysis done succesfully"}}}'::json);

*/

DECLARE
v_jsonbody json;
v_text text;
v_errcontext text;
	
BEGIN
	
-- 	Get input data
	v_text = ((p_data->>'data')::json->>'parameters')::json->>'text'::text;

--	Control NULL's
	v_text := COALESCE(v_text, '');

--	Create generic json body
	v_jsonbody = '{"status":"Accepted", "message":{"level":1, "text":"'|| v_text ||'","apiVersion":""}
	, "body":{"form":{}, "feature":{}, "data":{"options":"","info":{"values":[]},"setVisibleLayers":[], "linkPath":{}, "parentFields":{}, "fields":{}}, "actions":{}}}';

	RETURN v_jsonbody;
	
--	Exception handling
	EXCEPTION WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;  
		RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ',"SQLCONTEXT":' || to_json(v_errcontext) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_fct_get_jsonbody(json)
  OWNER TO postgres;
