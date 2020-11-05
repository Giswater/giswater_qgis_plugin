/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2980

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_setmincut(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setmincut(p_data json)
RETURNS json AS
$BODY$

/*
-- Button networkMincut on mincut dialog
SELECT gw_fct_setmincut('{"data":{"action":"mincutNetwork", "arcId":"2001", "mincutId":"3"}}');

-- Button valveUnaccess on mincut dialog
SELECT gw_fct_setmincut('{"data":{"action":"mincutValveUnaccess", "nodeId":1001, "mincutId":"3"}}');

-- Button Accept on mincut dialog
SELECT gw_fct_setmincut('{"data":{"action":"mincutAccept", "mincutId":"3", "status":"check"}}');

-- Button Accept on mincut conflict dialog
SELECT gw_fct_setmincut('{"data":{"action":"mincutAccept", "mincutId":"3", "status":"continue"}}');

-- Button networkConnec on mincut dialog
SELECT gw_fct_setmincut('{"data":{"action":"mincutConnec", "mincutId":"3"}}');

-- Button networkHydrometer on mincut dialog
SELECT gw_fct_setmincut('{"data":{"action":"mincutHydrometer", "mincutId":"3"}}');

*/

DECLARE

v_arc integer;
v_id integer;
v_node integer;
v_mincut integer;
v_status boolean;
v_valveunaccess json;
v_action text;
v_numconnecs integer;
v_numhydrometer integer;
v_priority json;
v_count int2;
v_mincutdetails text;
v_output json;
v_element_id integer;
v_mincut_class integer;


BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;
	
	-- get input parameters
	v_action := (p_data ->>'data')::json->>'action';
	v_mincut := ((p_data ->>'data')::json->>'mincutId')::integer;	
	v_node := ((p_data ->>'data')::json->>'nodeId')::integer;
	v_arc := ((p_data ->>'data')::json->>'arcId')::integer;
	
	IF v_action = 'mincutNetwork' THEN

		RETURN gw_fct_json_create_return(gw_fct_mincut(v_arc::text, 'arc'::text, v_mincut), 2980);

	ELSIF v_action = 'mincutConnec' OR  v_action = 'mincutHydrometer' THEN

		-- TODO: use json to get feature's list using input parameters (connecs or hydro)
	
		-- count connec
		SELECT count(connec_id) INTO v_numconnecs FROM om_mincut_connec WHERE result_id=result_id_arg AND state=1;

		-- count hydrometers
		SELECT count (rtc_hydrometer_x_connec.hydrometer_id) INTO v_numhydrometer 
		FROM rtc_hydrometer_x_connec JOIN om_mincut_connec ON rtc_hydrometer_x_connec.connec_id=om_mincut_connec.connec_id 
		JOIN v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id=rtc_hydrometer_x_connec.hydrometer_id
		JOIN connec ON connec.connec_id=v_rtc_hydrometer.connec_id WHERE result_id=result_id_arg;

		-- count priority hydrometers
		v_priority = 	(SELECT (array_to_json(array_agg((b)))) FROM 
		(SELECT concat('{"category":"',category_id,'","number":"', count(rtc_hydrometer_x_connec.hydrometer_id), '"}')::json as b FROM rtc_hydrometer_x_connec 
			JOIN om_mincut_connec ON rtc_hydrometer_x_connec.connec_id=om_mincut_connec.connec_id 
			JOIN v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id=rtc_hydrometer_x_connec.hydrometer_id
			JOIN connec ON connec.connec_id=v_rtc_hydrometer.connec_id WHERE result_id=result_id_arg 
			GROUP BY category_id ORDER BY category_id)a);

		-- profilactic control of priority
		IF v_priority IS NULL THEN v_priority='{}'; END IF;

		IF  v_action = 'mincutConnec'  THEN
			v_output = (concat('{"connecs":{"number":"',v_numconnecs,'","hydrometers":{"total":"',v_numhydrometer,'","classified":',v_priority,'}}}'));
			
		ELSIF  v_action = 'mincutHydrometer' THEN
			v_output = (concat('{"hydrometers":{"total":"',v_numhydrometer,'","classified":',v_priority,'}}}'));
			
		END IF;
				
		--update output results
		UPDATE om_mincut SET output = v_output WHERE id = result_id_arg;

		RETURN gw_fct_json_create_return(('{"status":"Accepted", "version":"'||v_version||'","body":{"form":{}, "data":{}}')::json, 2980);
		
	ELSIF v_action = 'mincutValveUnaccess' THEN

		RETURN gw_fct_json_create_return(gw_fct_mincut_valve_unaccess(p_data), 2980);

	ELSIF v_action = 'mincutAccept' THEN

		PERFORM gw_fct_json_create_return(gw_fct_setmincutoverlap(p_data), 2980);
		
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;