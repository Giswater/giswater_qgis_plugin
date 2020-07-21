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
SELECT gw_fct_setmincut('{"data":{"valveUnaccess":{"status":false}, "mincutId":"3", "arcId":"2001"}}');

SELECT gw_fct_setmincut('{"data":{"valveUnaccess":{"status":true, "nodeId":1001}, "mincutId":"3"}}');


*/

DECLARE

v_arc integer;
v_id integer;
v_node integer;
v_mincut integer;
v_status boolean;
v_valveunaccess json;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;
	-- get input parameters
	v_mincut :=	 ((p_data ->>'data')::json->>'mincutId')::integer;	
	v_arc :=	 ((p_data ->>'data')::json->>'arcId')::integer;
	v_valveunaccess := ((p_data ->>'data')::json->>'valveUnaccess')::json;
	v_status := v_valveunaccess->>'status';
	v_node := v_valveunaccess->>'nodeId';

	-- execute process
	IF v_status THEN
		RETURN gw_fct_json_create_return(gw_fct_mincut_valve_unaccess(v_node::text, v_mincut, current_user), 2980);
	ELSE	
		RETURN gw_fct_json_create_return(gw_fct_mincut(v_arc::text, 'arc'::text, v_mincut), 2980);
	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;