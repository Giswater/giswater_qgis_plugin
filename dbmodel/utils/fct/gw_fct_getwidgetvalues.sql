/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2788

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getwidgetvalues(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getwidgetvalues(p_data json)
  RETURNS text AS
$BODY$

/*EXAMPLE
SELECT gw_fct_getwidgetvalues
*/

DECLARE

schemas_array text[];
v_project_type text;
v_noderecord1 record;
v_noderecord2 record;
v_return json;
v_version text;
v_min double precision = 0;
v_max double precision = 999;
v_min1 double precision = 0;
v_max1 double precision = 0;
v_min2 double precision = 0;
v_max2 double precision = 0;
v_id text;
v_node_1 text;
v_node_2 text;
v_json json;
v_tgop text;
v_featuretype text;
v_text text;

BEGIN

	--  set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  get schema name
	schemas_array := current_schemas(FALSE);

	--  get project type
	SELECT project_type INTO v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	--  get parameters from input
	v_id = ((p_data ->>'feature')::json->>'id')::text;
	v_featuretype = ((p_data ->>'feature')::json->>'featureType')::text;
	v_node_1 = ((p_data ->>'data')::json->>'node1')::text;
	v_node_2 = ((p_data ->>'data')::json->>'node2')::text;
	v_tgop = ((p_data ->>'data')::json->>'tgOp');

	IF v_featuretype ='NODE' THEN

		v_min = (SELECT max(y) FROM (SELECT sys_y1 as y FROM ve_arc WHERE node_1=v_id::integer UNION SELECT sys_y2 FROM ve_arc WHERE node_2=v_id::integer)a);
		IF v_min IS NULL THEN v_min = 0; END IF;

	ELSIF v_featuretype ='ARC' THEN

		SELECT * INTO v_noderecord1 FROM ve_node WHERE node_id=v_node_1::integer;
		v_max1 = v_noderecord1.sys_ymax;
		IF v_max1 IS NULL THEN v_max1 = 999; END IF;


		SELECT * INTO v_noderecord2 FROM ve_node WHERE node_id=v_node_2::integer;
		v_max2 = v_noderecord2.sys_ymax;
		IF v_max2 IS NULL THEN v_max2 = 999; END IF;

	END IF;

	-- Return
	RETURN ('{"ymax":{"min":'||v_min||',"max":'||v_max||'},'||
			   '"y1":{"min":'||v_min1||',"max":'||v_max1||'},'||
			   '"y2":{"min":'||v_min2||',"max":'||v_max2||'}}');
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
