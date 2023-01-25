/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2124

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_connect_to_network(character varying[], character varying);
DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_connect_to_network(json);
DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_setlinktonetwork(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setlinktonetwork(p_data json)
RETURNS json AS
$BODY$

/*

SELECT SCHEMA_NAME.gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":["3201","3200"]},"data":{"feature_type":"CONNEC", "forcedArcs":["2001","2002"]}}$$);

SELECT SCHEMA_NAME.gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":["100013"]},"data":{"feature_type":"CONNEC", "forcedArcs":["221"]}}$$);

SELECT SCHEMA_NAME.gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":["100013"]},"data":{"feature_type":"CONNEC"}}$$);
SELECT SCHEMA_NAME.gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":["100014"]},"data":{"feature_type":"GULLY"}}$$);

SELECT SCHEMA_NAME.gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1,"lang":"ES"},"feature":
{"id":"SELECT array_to_json(array_agg(connec_id::text)) FROM v_edit_connec WHERE connec_id IS NOT NULL AND state=1"},"data":{"feature_type":"CONNEC"}}$$);


*/

DECLARE

v_error_context text;
v_return json;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- trigger core function
	SELECT gw_fct_linktonetwork(p_data) INTO v_return;
	
	-- Return
	RETURN v_return;
	
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
