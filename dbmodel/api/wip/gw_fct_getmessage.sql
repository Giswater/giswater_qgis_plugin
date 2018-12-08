-- Function: ws_sample.gw_api_getlist(json)

CREATE OR REPLACE FUNCTION ws_sample.gw_api_getmessage(p_data json, p_message integer)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT ws_sample.gw_api_getmessage($${"featureType":"visit", "idName":"visit_id", "id":"2001"}$$, 30)
*/
DECLARE
	v_record record;
	v_message text;
		
BEGIN

-- Set search path to local schema
    SET search_path = "ws_sample", public;

    SELECT * INTO v_record FROM config_api_message WHERE id=p_message;

    IF v_record.mtype='alone' THEN
		v_message = concat('{"level":"',v_record.loglevel,'", "text":"',v_record.message,'", "hint":"',v_record.hintmessage,'"}');
    ELSIF v_record.mtype='withfeature' THEN
		v_message = concat('{"level":"',v_record.loglevel,'", "text":"',(p_data)->>'featureType',' ',(p_data)->>'id',' ',v_record.message,'", "hint":"',v_record.hintmessage,'"}');
    END IF;
    
--    Return
    RETURN v_message::json;
       
--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION ws_sample.gw_api_getlist(json)
  OWNER TO geoadmin;
