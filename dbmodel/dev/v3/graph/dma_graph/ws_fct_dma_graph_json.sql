/*
This file IS part of Giswater 3
The program IS free software: you can redistribute it and/or modify it under the terms of the GNU General Public License AS published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater IS provided by Giswater Association
*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_dma_graph_json(p_data json)
	RETURNS json
	LANGUAGE plpgsql
AS $function$

/*

SELECT SCHEMA_NAME.gw_fct_dma_graph_json($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},
"data":{"parameters":{"explId":513, "entityName":"test"}}}$$);

*/


DECLARE
v_schema_date date;
v_json_result_header json;
v_json_result_nodes json;
v_json_result_links json;
v_json_result_return json;
v_expl_id integer;
v_entity text;

BEGIN

	-- Input params
	SELECT "date" INTO v_schema_date FROM sys_version ORDER BY giswater DESC LIMIT 1;
	v_expl_id = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'explId')::integer;
	v_entity = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'entityName')::text;


	
	-- Build Network info:
	
	SELECT json_build_object(
		'name', concat(v_expl_id, ' - ', e.name), 
		'description', concat('DMA graph de ', e.name),
		'macroExpl', concat(n.macroexpl_id, ' - ', f.name),
		'generatedDate', now(),
		'schemaDate', v_schema_date
	) INTO v_json_result_header
	FROM vu_node n 
	JOIN exploitation e USING (expl_id) 
	JOIN macroexploitation f ON e.macroexpl_id = f.macroexpl_id
	WHERE e.expl_id = v_expl_id
	LIMIT 1;

	
	-- Build key "nodes" (table dma_graph_object)
	SELECT 
	json_agg(
		json_build_object(
		'id', object_id,
		'type', object_type,
		'label', object_label,
		'attributes', attrib::json,
		'orderId', order_id,
		'fromMeter', meter_1,
		'toMeter', meter_2,
		'coordPosition', json_build_object('x', round(ST_X(the_geom)::numeric, 3), 'y', round(st_y(the_geom)::numeric, 3))
		)
	) INTO v_json_result_nodes
	FROM dma_graph_object
	WHERE expl_id = v_expl_id;
	
	
	-- Build key "links" (table dma_graph_meter)
	SELECT 
	json_agg(
		json_build_object(
		'id', meter_id,
		'type', 'METER',
		'fromNode', object_1,
		'toNode', object_2,
		'orderId', order_id,
		'attributes', attrib::json
		) 
	) INTO v_json_result_links 
	FROM dma_graph_meter a
	WHERE expl_id = v_expl_id;



	v_json_result_return = json_build_object(
		'networkInfo', v_json_result_header, 
		'nodes' ,v_json_result_nodes, 
		'links', v_json_result_links
	);
	

	INSERT INTO dma_graph_json (expl_id, dma_graph_json, insert_tstamp)
	VALUES (v_expl_id, v_json_result_return, now()) ON CONFLICT (expl_id) DO NOTHING; 

	UPDATE dma_graph_json SET dma_graph_json = v_json_result_return, update_tstamp = now() WHERE expl_id = v_expl_id;


	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"DMA JSON graph successfully created"}, "version":""'||
				',"body":{"form":{}'||
				',"data":{ "result":'||v_json_result_return||'}}'||
			'}')::json, 3326, null, null, null);

	
END;

$function$
;
