/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2788

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_get_widgetvalues(p_data json)
  RETURNS float AS
$BODY$

/*EXAMPLE
*/

DECLARE

schemas_array text[];
v_project_type text;
v_noderecord1 record;
v_noderecord2 record;
v_return json;
v_apiversion json;
v_min double precision;
v_max double precision;
v_id text;
v_node_1 text;
v_node_2 text;
v_json json;
v_tgop text;
v_key text;

BEGIN

	--  set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  get schema name
	schemas_array := current_schemas(FALSE);

	--  get project type
	SELECT wsoftware INTO v_project_type FROM version LIMIT 1;

	--  get parameters from input
	v_id = ((p_data ->>'feature')::json->>'id')::text;
	v_node_1 = ((p_data ->>'data')::json->>'node1');
	v_node_2 = ((p_data ->>'data')::json->>'node2');
	v_json = ((p_data ->>'data')::json->>'json');
	v_tgop = ((p_data ->>'data')::json->>'tgOp');
	v_key = ((p_data ->>'data')::json->>'key');

	IF v_project_type = 'UD' THEN

		IF v_tgop = 'SELECT' THEN 
			SELECT node_1 INTO v_node_1 FROM arc WHERE arc_id = v_id;
			SELECT node_2 INTO v_node_2 FROM arc WHERE arc_id = v_id;
		END IF;

		SELECT * INTO v_noderecord1 FROM v_edit_node WHERE node_id=v_node_1;
		SELECT * INTO v_noderecord2 FROM v_edit_node WHERE node_id=v_node_2;
 
		IF (v_json->>'column_id') = 'y1' OR (v_json->>'column_id') = 'custom_y1' THEN
			v_min = 0;
			v_max = v_noderecord1.sys_ymax;
			
		ELSIF (v_json->>'column_id') = 'y2'  OR (v_json->>'column_id') = 'custom_y2' THEN
			v_min = 0;
			v_max = v_noderecord2.sys_ymax;
				
		ELSIF (v_json->>'column_id') = 'ymax'  OR (v_json->>'column_id') = 'custom_ymax' THEN
			v_min = (SELECT max(y) FROM (SELECT y1 as y FROM arc WHERE node_1=v_id UNION SELECT y2 FROM arc WHERE node_2=v_id)a);
			v_max = 999;
		END IF;

		IF v_key = 'minValue' THEN
			v_return = v_min;
		ELSIF v_key = 'minValue' THEN
			v_return = v_max;
		END IF;
		
	END IF;	
         
--    Return
      RETURN v_return;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
