/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION "ud_sample".gw_fct_getprofilevalues(p_data json)  
RETURNS json AS 
$BODY$

/*example
SELECT ud_sample.gw_fct_pg2epa($${"client":{"device":3, "infoType":100, "lang":"ES"},
	"data":{"initNode":"", "endNode":"", "composer":"mincutA4", scale":{"eh":1000, "ev":200}, "scaleToFit":false,
		"ComposerTemplates":[{"ComposerTemplate":"mincutA4", "ComposerMap":[{"width":"179.0","height":"140.826","index":0, "name":"map0"},{"width":"77.729","height":"55.9066","index":1, "name":"map7"}]},
				     {"ComposerTemplate":"mincutA3","ComposerMap":[{"width":"53.44","height":"55.9066","index":0, "name":"map7"},{"width":"337.865","height":"275.914","index":1, "name":"map6"}]}],
		}}$$)

Criteria
- minimitzar peticions
- hi ha un nou dialeg
- cal posar els valors d'escala sota del caixeti de la guitarra
- cal posar una fila més en la llegenda longitud total (TOTAL LENGTH)


	UD
	INSERT INTO config_param_system (value, parameter_id,) VALUES (
	'{"catalog":"CATALOG", "vs":"VS", "hs":"HS", "referencePlane":"RF", "dimensions":"SLOPE/LENGTH", "ordinates": "ORDINATES", "topelev":"TOP ELEV", "ymax":"YMAX", "elev": "ELEV", "code":"CODE"}'::json,
	'profile_guitarlegend');

	INSERT INTO config_param_system (value, parameter_id,) VALUES (
	'{"ground":{"color":"black", "width":"0.2"} "infra":{color":"black", "width":"0.2"}, "guitar":{color":"black", "width":"0.2"}, "guitar":{color":"black", "width":"0.2"}'::json, 
	'profile_stylesheet');

	INSERT INTO config_param_system (value, parameter_id,) VALUES (
	'{"arc":"SELECT	concat(matcat_id,''-Ø'',(c.geom1*100)::integer) as catalog, concat((100*slope)::numeric(12,2),''%/'',gis_length::numeric(12,2),'m') as dimensions , arc_id as code FROM v_edit_arc JOIN cat_arc c ON id = arccat_id"
	"node":"SELECT sys_top_elev as top_elev, sys_elev as elev, code as code" FROM v_edit_node}',
	'profile_guitartext');

	INSERT INTO config_param_system (value, parameter_id,) VALUES (
	'{"arc":{}, "node":{}',
	'profile_vdefault');

	WS
	INSERT INTO config_param_system (value, parameter_id,) VALUES (
	'{"catalog":"CATALOG", "vs":"VS", "hs":"HS", "referencePlane":"RF", "dimensions":"SLOPE/LENGTH", "ordinates": "ORDINATES", "topelev":"ELEVATION", "ymax":"DEPTH", "elev": "ELEV", "code":"CODE"}'::json,
	'profile_guitarlegend');

	INSERT INTO config_param_system (value, parameter_id,) VALUES (
	'{"ground":{"color":"black", "width":"0.2"} "infra":{color":"black", "width":"0.2"}, "guitar":{color":"black", "width":"0.2"}, "guitar":{color":"black", "width":"0.2"}'::json, 
	'profile_stylesheet');

	INSERT INTO config_param_system (value, parameter_id,) VALUES (
	'{"arc":"SELECT	arccat_id as catalog, concat((100*slope)::numeric(12,2),''%/'',gis_length::numeric(12,2),'m') as dimensions , arc_id as code FROM v_edit_arc"
	"node":"SELECT elevation as top_elev, elev, code as code" FROM v_edit_node}',
	'profile_guitartext');

	UTILS
	INSERT INTO config_param_system (value, parameter_id,) VALUES (
	'{"arc":{"cat_geom1":"110"}, "node":{"cat_geom1":"1"}',
	'profile_vdefault');
*/

DECLARE
v_init  text;
v_end text;
v_hs integer;
v_vs integer;
v_arc json;
v_node json;
v_llegend json;
v_stylesheet json;
v_version text;
v_status text;
v_level integer;
v_message text;
v_audit_result text; 
v_guitarlegend json;
v_guitartext json;
v_vdefault json;
v_leaflet json;
v_composer text;
v_templates json;
v_json json;
v_project_type text;
v_height float;
v_index integer;
v_mapcomposer_name text;
v_width float;
v_maxlength float;
v_maxdeltaelev float;
v_scaletofit boolean;
v_array_width float[];
v_scale text;
v_extension json;
v_vstext text;
v_vhtext text;

BEGIN

	--  Get input data
	v_init =  (p_data->>'data')::json->>'initNode';
	v_end =  (p_data->>'data')::json->>'endNodes';
	v_hs =  ((p_data->>'data')::json->>'scale')::json->>'eh';
	v_vs =  ((p_data->>'data')::json->>'scale')::json->>'ev';
	v_composer := (p_data ->> 'data')::json->> 'composer';
	v_scaletofit := (p_data ->> 'data')::json->> 'scaleToFit';
	v_templates := (p_data ->> 'data')::json->> 'ComposerTemplates';
	
	--  Search path
	SET search_path = "ud_sample", public;

	-- get projectytpe
	SELECT wsoftware, version FROM version LIMIT 1 INTO v_project_type, v_version;

	-- get systemvalues
	SELECT value INTO v_guitarlegend FROM config_param_system WHERE parameter = 'profile_guitarlegend';
	SELECT value INTO v_stylesheet FROM config_param_system WHERE parameter = 'profile_stylesheet';
	SELECT value INTO v_guitartext FROM config_param_system WHERE parameter = 'profile_guitartext';
	SELECT value INTO v_vdefault FROM config_param_system WHERE parameter = 'profile_vdefault';
	SELECT value::json->>'vs' INTO v_vstext FROM config_param_system WHERE parameter = 'profile_guitarlegend';
  	SELECT value::json->>'vh' INTO v_vhtext FROM config_param_system WHERE parameter = 'profile_guitarlegend';
	
	-- get shortestpath
	--todo: EXECUTE 'SELECT pg_digstra (matriu, '||v_init||', '||v_end||')'	INTO v_result;
	
	-- get arc values
	INSERT INTO temp_table
	SELECT  arc_id, code, node_1, node_2, sys_type, arccat_id, cat_geom1, gis_length, slope FROM v_edit_arc JOIN cat_arc ON arccat_id = id WHERE arc_id IN (v_result);

	-- get node values
	INSERT INTO temp_table
	SELECT node_id, code, sys_top_elev as top_elev, sys_ymax as ymax, sys_elev, sys_type, nodecat_id, cat_node.geom1 as cat_geom1 FROM v_edit_node JOIN cat_node ON nodecat_id = id WHERE node_id IN (v_result);

	-- get vnode values
	--todo: UPDATE temp_table SET vnode-connec

	-- get max length and max deltaelev
	--todo: v_maxlength = 
	--todo: v_maxdeltaelev = 

	-- get extension
	IF v_composer !='' THEN
		SELECT * INTO v_json FROM json_array_elements(v_templates) AS a WHERE a->>'ComposerTemplate' = v_composer;

		-- select map with maximum width
		SELECT array_agg(a->>'width') INTO v_array_width FROM json_array_elements( v_json ->'ComposerMap') AS a;
		SELECT max (a) INTO v_width FROM unnest(v_array_width) AS a;
		SELECT a->>'name' INTO v_mapcomposer_name FROM json_array_elements( v_json ->'ComposerMap') AS a WHERE (a->>'width')::float = v_width::float;
		SELECT a->>'height' INTO v_height FROM json_array_elements( v_json ->'ComposerMap') AS a WHERE a->>'name' = v_mapcomposer_name;  
		SELECT a->>'index' INTO v_index FROM json_array_elements( v_json ->'ComposerMap') AS a WHERE a->>'name' = v_mapcomposer_name; 

		IF v_scaletofit THEN
			--todo: v_hs = maximum value to fit composer;
			--todo: v_vs = maximum value to fit composer;
		ELSE 
			IF v_height < v_maxelev THEN
				v_level = 2;
				v_message = 'perfil demasiado alto. Modifica escala o papel';
				RETURN ('{"status":"accepted", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"}'::json);
			END IF;
			IF v_width < v_maxlength THEN
				v_level = 2;
				v_message = 'perfil demasiado largo. Modifica escala o papel';
				RETURN ('{"status":"accepted", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"}'::json);
			END IF;
		END IF;
	ELSE
		-- extension value
		v_extension = (concat('{"width":', v_maxlength + v_ytol,', "height":', v_maxelev + v_xtol,'}'))::json;
	END IF;

	-- scale text
	v_scale = concat(vs,':',v_vs,'-',hs,':',v_hs);

	-- update temporal table using scale factor
	v_hs = 200/v_hs;
	v_hs = 1000/v_vs;

	/* todo
	UPDATE temp_table SET scale factors

	-- update temporal table with total-length
	UPDATE temp_table SET total-length

	-- update temporal table setting default values
	UPDATE temp_table SET where

	-- update interpolated values when node has not values
	UPDATE temp_table SET where (node interpolate)

	-- update guitar text using config_param_system variable
	UPDATE temp_table SET where guitartext

	-- recover values form temp table into response
	SELECT * FROM temp_table INTO v_arc;
	SELECT * FROM temp_table INTO v_node;

	*/
	
	-- control null values
	IF v_guitarlegend IS NULL THEN v_llegend='{}'; END IF;
	IF v_stylesheet IS NULL THEN v_stylesheet='{}'; END IF;
	v_leaflet := COALESCE(v_leaflet, '{}'); 
	v_arc := COALESCE(v_llegend, '{}'); 
	v_node := COALESCE(v_llegend, '{}'); 

	-- default values
	v_status = 'Accepted';	
        v_level = 3;
        v_message = 'Profile done successfully';
        
	--  Return
	RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
               ',"body":{"form":{}'||
               ',"data":{"legend":",'||v_llegend||','||
				'"scale":",'"||v_scale||'",'||
                '"extension":",'||v_extension||','||
                '"stylesheet":'||v_stylesheet||','||
                '"node":'||v_node||','||
                '"arc":'||v_arc||','||
                '}'
          '}')::json;

	--EXCEPTION WHEN OTHERS THEN
	--GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	--RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;