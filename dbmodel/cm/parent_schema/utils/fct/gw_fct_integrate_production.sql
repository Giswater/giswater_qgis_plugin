/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3426

CREATE OR REPLACE FUNCTION ws_cm.gw_fct_cm_integrate_production(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT ws_cm.gw_fct_cm_integrate_production($${"data":{"parameters":{"campaignId":3}}}$$)


*/

DECLARE

v_campaign integer;
v_result json;
v_result_info json;
v_result_point json;
v_error_context text;
v_version text;
v_msgerr json;

BEGIN

  	-- Search path
  	SET search_path = "ws_cm", public;

  	-- select version
  	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

  	-- getting input data
  	v_campaign :=  (((p_data ->>'data')::json->>'parameters')::json->>'campaignId')::boolean;
	
	-- managing results
  	v_result := COALESCE(v_result, '{}');

/*
	LOOP cat_feature WHERE id IN (campaign) ORDER BY node, connec, arc, link

		-- INSERT (action = 1);
		INSERT INTO ws.ve_node_shutoff_valve
		select v.* from cm.ws_cm_shutoff_valve v join cm.om_campaign_lot using (lot_id) where lot_id in (select lot_id from cm.om_campaign_lot where campaign_id = 9) AND action = 1;
	
		-- UPDATE (action = 2)
		UPDATE ws.ve_node_shutoff_valve 
		FROM cm.ws_cm_shutoff_valve v join cm.om_campaign_lot using (lot_id) where lot_id in (select lot_id from cm.om_campaign_lot where campaign_id = 9) AND action = 2;
		
		-- DELETE (action = 3)
		DELETE FROM ws.ve_node_shutoff_valve 
		FROM cm.ws_cm_shutoff_valve v join cm.om_campaign_lot using (lot_id) where lot_id in (select lot_id from cm.om_campaign_lot where campaign_id = 9) AND action = 3; 

	END LOOP;

*/

	
  	-- Control nulls
  	v_result_info := COALESCE(v_result_info, '{}');
  	v_result_point := COALESCE(v_result_point, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
               ',"body":{"form":{}'||
  		     ',"data":{ "info":'||v_result_info||','||
  				'"point":'||v_result_point||
  			'}}'||
  	    '}')::json, 3426, null, null, null);


  	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;
	RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE, 'MSGERR', (v_msgerr::json ->> 'MSGERR'))::json;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

