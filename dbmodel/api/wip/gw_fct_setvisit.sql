-- Function: ws_sample.gw_api_setvisit(json)

-- DROP FUNCTION ws_sample.gw_api_setvisit(json);

CREATE OR REPLACE FUNCTION ws_sample.gw_api_setvisit(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
--INSERT
SELECT ws_sample.gw_api_setvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"arc", "tableName":"ve_visit_multievent_x_arc", "id":null, "idname": "visit_id"},
"data":{"fields":{"class_id":6, "arc_id":"2001", "visitcat_id":1, "ext_code":"testcode", "sediments_arc":10, "desperfectes_arc":1, "neteja_arc":3},
	"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}
	}$$)

--UPDATE
SELECT ws_sample.gw_api_setvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"arc", "tableName":"ve_visit_multievent_x_arc", "id":1135,"idname": "visit_id"},
"data":{"fields":{"class_id":6, "arc_id":"2001", "visitcat_id":1, "ext_code":"testcode", "sediments_arc":101121200, "desperfectes_arc":1, "neteja_arc":3},"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}
	}$$)
*/

DECLARE
	v_tablename text;
	v_apiversion text;
	v_visit integer;
	v_outputparameter json;
	v_insertresult json;

BEGIN

-- Set search path to local schema
    SET search_path = "ws_sample", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO v_apiversion;

--  get input values
    v_visit = ((p_data ->>'feature')::json->>'id')::integer;

-- set output parameter
	v_outputparameter := concat('{"client":',((p_data)->>'client'),', "feature":',((p_data)->>'feature'),', "data":',((p_data)->>'data'),'}')::json;
	
	--upsert visit
	IF v_visit IS NULL THEN
		SELECT gw_api_setfeatureinsert (v_outputparameter) INTO v_insertresult;
		v_visit=(((v_insertresult->>'body')::json->>'feature')::json->>'id')::integer;
		UPDATE om_visit SET startdate=now(), enddate=now() WHERE id=v_visit;
		
	ELSE 
		PERFORM gw_api_setfields (v_outputparameter);
		UPDATE om_visit SET enddate=now() WHERE id=v_visit;
	END IF;

	raise notice 'x %', (((p_data ->>'data')::json->>'deviceTrace')::json->>'xcoord');

	-- update 
	UPDATE om_visit_event SET xcoord=(((p_data ->>'data')::json->>'deviceTrace')::json->>'xcoord')::float,
				  ycoord=(((p_data ->>'data')::json->>'deviceTrace')::json->>'ycoord')::float,
				  compass=(((p_data ->>'data')::json->>'deviceTrace')::json->>'compass')::float
				  WHERE visit_id=v_visit;
				  
--    Return
    RETURN ('{"status":"Accepted", "visit_id":"'||v_visit||'", "message":{"priority":1, "text":"Visita upserteada"}, "apiVersion":'|| v_apiversion ||'}')::json;    

--    Exception handling
   -- EXCEPTION WHEN OTHERS THEN 
    --    RETURN ('{"status":"Failed","message":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    

      

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION ws_sample.gw_api_setvisit(json)
  OWNER TO geoadmin;
