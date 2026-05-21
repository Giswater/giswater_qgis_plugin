/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3139

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setunitinterval(
	p_data json)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
/*
EXAMPLE:

SELECT SCHEMA_NAME.gw_fct_setunitinterval($${
"client":{"device":3,"infoType":0,"lang":"ca"},
"feature":{"featureType":"visit","tableName":"ve_visit_tram_neteja","idName":"visit_id","id":488192},
"form":{"tabData":{"active":true},"tabFiles":{"active":false},"navigation":{"currentActiveTab":"tab_data"}},
"data":{"relatedFeature":{"type":"unit", "id":"1032", "tableName":"ve_lot_x_unit_web"},
"fields":{"class_id":"15","startdate":"2022-04-01 15:26","lot_id":"1010","unit_id":"1032","arc_id":"4736","tram_exec_visit":0,"status":"4"},"pageInfo":null}}$$) AS result

*/
DECLARE

-- gwSetVisitInterval

v_version json;
v_unit_id integer;
v_lot_id integer;
v_querystring text;
v_rec record;
v_data json;

BEGIN

--  Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;

--  get parameters from input
	v_unit_id = (((p_data ->>'data')::json->>'fields')::json->>'unit_id')::integer;
	v_lot_id = (((p_data ->>'data')::json->>'fields')::json->>'lot_id')::integer;

	-- Manage interval
	v_querystring = 'SELECT * FROM om_unit_intervals WHERE unit_id = ' || v_unit_id || ' AND lot_id = '|| v_lot_id ||' ORDER BY startdate DESC LIMIT 1';
	EXECUTE v_querystring INTO v_rec;

	IF v_rec.unit_id IS NULL OR v_rec.enddate IS NOT NULL THEN
		EXECUTE ('INSERT INTO  om_unit_intervals (unit_id, startdate, lot_id, user_name) VALUES ($1, $2, $3, current_user);')
		USING v_unit_id, now()::timestamp, v_lot_id;
		v_data = gw_fct_json_object_set_key(((p_data->>'data')::json->>'fields')::JSON,'status', 2);
		v_data = gw_fct_json_object_set_key((p_data->>'data')::json,'fields', v_data);
		p_data = gw_fct_json_object_set_key(p_data,'data', v_data);
	ELSIF v_rec.enddate IS NULL THEN
		EXECUTE ('UPDATE om_unit_intervals SET enddate = $1 WHERE unit_id = $2 AND enddate is NULL AND lot_id = $3 AND user_name = current_user;')
		USING now()::timestamp, v_unit_id, v_lot_id;
	END IF;

	-- Return Get visit setting activitat id
	RETURN gw_api_getvisit(p_data);

--    Exception handling
    EXCEPTION WHEN OTHERS THEN
    RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":"'|| v_version ||'","SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$;
  LANGUAGE plpgsql VOLATILE
  COST 100;
