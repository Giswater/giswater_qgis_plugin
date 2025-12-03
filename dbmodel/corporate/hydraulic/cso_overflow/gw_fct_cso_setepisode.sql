/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

CREATE OR REPLACE FUNCTION gw_fct_cso_setepisode(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*

SELECT gw_fct_cso_setepisode($${"data":{"parameters":{"episode":"1"}}}$$);

*/

DECLARE
v_episode integer;

BEGIN
	
	SET search_path = "SCHEMA_NAME", public;

	-- input params
	v_episode := (((p_data ->>'data')::json->>'parameters')::json->>'episode')::integer;

	UPDATE inp_dscenario_inflows SET active= FALSE;
	UPDATE inp_dscenario_inflows SET active= TRUE WHERE order_id = v_episode;

	-- return
	return '{"status": "Accepted", "message":{"level":1, "text":"done succesfully"}, "episode":"'||v_episode||'"}';

END;
$function$
;