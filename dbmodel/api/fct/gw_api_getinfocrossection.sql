/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2578

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getinfocrossection(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_api_getinfocrossection($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"id":"2001"}}$$)
*/

DECLARE

--    Variables
    v_id character varying;
    v_apiversion json;
    v_fields json;
    v_currency_symbol varchar;
    v_shape varchar;
    v_record record;
    v_array json[];

BEGIN
	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
	INTO v_apiversion;

	-- getting input data 
	v_id :=  ((p_data ->>'feature')::json->>'id')::text;
	
	--  get system currency
	v_currency_symbol :=((SELECT value FROM config_param_system WHERE parameter='sys_currency')::json->>'symbol');

	-- get image
   	SELECT image FROM cat_arc_shape JOIN cat_arc ON cat_arc.shape=cat_arc_shape.id	JOIN arc ON cat_arc.id=arccat_id WHERE arc_id=v_id
		INTO v_shape;

	-- get values from arc
        SELECT * INTO v_record FROM v_plan_arc WHERE arc_id = v_id;

	-- building the widgets array
    	v_array[0] := json_build_object('label', 'm2mlpav', 'column_id', 'm2mlpav', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.m2mlpav);
    	v_array[1] := json_build_object('label', 'thickness', 'column_id', 'thickness', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.thickness);
    	v_array[2] := json_build_object('label', 'bulk', 'column_id', 'bulk', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.bulk);
	v_array[3] := json_build_object('label', 'y_param', 'column_id', 'y_param', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.y_param);
	v_array[4] := json_build_object('label', 'Crossection area:', 'column_id', 'area', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.area);
	v_array[5] := json_build_object('label', 'm3/ml Excav', 'column_id', 'm3mlexc', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.m3mlexc);
	v_array[6] := json_build_object('label', 'm3/ml Filling', 'column_id', 'm3mlfill', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.m3mlfill);
	v_array[7] := json_build_object('label', 'm3/ml Excess', 'column_id', 'm3mlexcess', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.m3mlexcess);
	v_array[8] := json_build_object('label', '% Trenchlining', 'column_id', 'm2mltrenchl', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.m2mltrenchl);
	v_array[9] := json_build_object('column_id', 'b2', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.b);
	v_array[10] := json_build_object('column_id', 'm2mlbottom', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.m2mlbottom);
	v_array[11] := json_build_object('column_id', 'width', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.width);
	v_array[12] := json_build_object('column_id', 'b1', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.b);
	v_array[13] := json_build_object('column_id', 'm2mlpav', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.m2mlpav);
	v_array[14] := json_build_object('column_id', 'z1', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.z1);
	v_array[15] := json_build_object('column_id', 'geom1', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.geom1);
	v_array[16] := json_build_object('column_id', 'z2', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.z2);
	v_array[17] := json_build_object('column_id', 'total_y', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.total_y);
	v_array[18] := json_build_object('column_id', 'rec_y', 'widgettype', 'text', 'datatype', 'string', 'iseditable', FALSE, 'layout_order', 1, 'value', v_record.rec_y);

	v_fields = array_to_json(v_array[0:18]);
      
	-- Check null
       v_shape := COALESCE(v_shape, '[]'); 
       v_fields := COALESCE(v_fields, '[]'); 

	-- Return
	RETURN ('{"status":"Accepted", "message":{}, "apiVersion":'||v_apiversion||
             ',"body":{"form":{}'||
		     ',"feature":{}'||
		     ',"data":{"shapepng":"' || v_shape ||'"'||
			     ',"fields":' || v_fields || '}}'||
	    '}')::json;

--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;