/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 2684

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_getprint(p_data json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_setprint"(p_data json) 
RETURNS pg_catalog.json AS 
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_setprint($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},
"feature":{},
"data":{"composer":"mincutA4","scale":"10000","rotation":"10",
		"ComposerTemplates":[{"ComposerTemplate":"mincutA4", "ComposerMap":[{"width":"179.0","height":"140.826","index":0, "name":"map0"},{"width":"77.729","height":"55.9066","index":1, "name":"map7"}]},
                             {"ComposerTemplate":"mincutA3","ComposerMap":[{"width":"53.44","height":"55.9066","index":0, "name":"map7"},{"width":"337.865","height":"275.914","index":1, "name":"map6"}]}],
		"extent":{"p1":{"xcoord":418284.06010078074,"ycoord":4576197.139572782},"p2":{"xcoord":419429.332014571, "ycoord":4576756.056126544}}}}$$)
*/

DECLARE

p21x float; 
p02x float;
p21y float; 
p02y float;
p22x float;
p22y float;
p01x float;
p01y float;
dx float;
dy float;
v_version text;
v_text text[];
json_field json;
text text;
v_field text;
v_value text;
i integer=1;
sql_query text;
v_publish_user text;
v_composer text;
v_width float;
v_height float;
v_scale integer;
v_x float;
v_x1 float;
v_x2 float;
v_y1 float;
v_y2 float;
v_y float;
v_json1 json;
v_json2 json;
v_json3 json;
v_extent json;
v_geometry text;
v_array_width float[];
v_mapcomposer_name text;
v_rotation float;
v_xmin float;
v_ymin float;
v_xmax float;
v_ymax float;
v_index integer;

BEGIN

    -- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
	
	-- fix client null mistakes
	p_data = REPLACE (p_data::text, '"NULL"', 'null');
	p_data = REPLACE (p_data::text, '"null"', 'null');
	p_data = REPLACE (p_data::text, '""', 'null');
    p_data = REPLACE (p_data::text, '''''', 'null');
	
    --  get api version
    SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

    -- get data from input
    v_composer := (p_data ->> 'data')::json->> 'composer';
    v_scale := (p_data ->> 'data')::json->> 'scale';
    v_rotation := ((p_data ->> 'data')::json->> 'rotation')::float*((2*pi())/360);
    v_json1 := (p_data ->> 'data')::json->> 'ComposerTemplates';
    v_x1 := ((((p_data ->> 'data')::json->>'extent')::json->>'p1')::json->>'xcoord')::float;
    v_y1 := ((((p_data ->> 'data')::json->>'extent')::json->>'p1')::json->>'ycoord')::float;
    v_x2 := ((((p_data ->> 'data')::json->>'extent')::json->>'p2')::json->>'xcoord')::float;
    v_y2 := ((((p_data ->> 'data')::json->>'extent')::json->>'p2')::json->>'ycoord')::float;
	
	IF v_scale IS NULL THEN
			v_scale = 1000;
	END IF;
	
	IF v_rotation IS NULL THEN
		v_rotation = 0;
	END IF;
	
    SELECT * INTO v_json2 FROM json_array_elements(v_json1) AS a WHERE a->>'ComposerTemplate' = v_composer;

    -- Get maps from composer
    v_json3 := v_json2->'ComposerMap';

    raise notice 'v_json3 %', v_json3;

    -- select map with maximum width
    SELECT array_agg(a->>'width') INTO v_array_width FROM json_array_elements(v_json3) AS a;
    SELECT max (a) INTO v_width FROM unnest(v_array_width) AS a;
    SELECT a->>'name' INTO v_mapcomposer_name FROM json_array_elements(v_json3) AS a WHERE (a->>'width')::float = v_width::float;
    SELECT a->>'height' INTO v_height FROM json_array_elements(v_json3) AS a WHERE a->>'name' = v_mapcomposer_name;  
    SELECT a->>'index' INTO v_index FROM json_array_elements(v_json3) AS a WHERE a->>'name' = v_mapcomposer_name;  
    

	raise notice 'v_rotation %', v_rotation;

	v_width = v_width - 0.05;  -- reduce width in 0.05mm (let say nothing) to prevent possible rounds to better approach to scale

    -- calculate center coordinates
    v_x = (v_x1+v_x2)/2;
    v_y = (v_y1+v_y2)/2;
    
    -- calculate dx & dy to fix extend from center
    dx = v_scale*v_width/(1000*2);
    dy = v_scale*v_height/(1000*2);

   -- calculate the extend polygon
   p01x = v_x - dx*cos(v_rotation)-dy*sin(v_rotation);
   p01y = v_y - dx*sin(v_rotation)+dy*cos(v_rotation);

   p02x = v_x + dx*cos(v_rotation)-dy*sin(v_rotation);
   p02y = v_y + dx*sin(v_rotation)+dy*cos(v_rotation);

   p21x = v_x - dx*cos(v_rotation)+dy*sin(v_rotation);
   p21y = v_y - dx*sin(v_rotation)-dy*cos(v_rotation); 

   p22x = v_x + dx*cos(v_rotation)+dy*sin(v_rotation);
   p22y = v_y + dx*sin(v_rotation)-dy*cos(v_rotation);

    v_xmin =  (SELECT min(a) FROM (SELECT p01x AS a UNION SELECT p02x UNION SELECT p21x UNION SELECT p22x)b);
    v_ymin =  (SELECT min(a) FROM (SELECT p01y AS a UNION SELECT p02y UNION SELECT p21y UNION SELECT p22y)b);
    v_xmax =  (SELECT max(a) FROM (SELECT p01x AS a UNION SELECT p02x UNION SELECT p21x UNION SELECT p22x)b);
    v_ymax =  (SELECT max(a) FROM (SELECT p01y AS a UNION SELECT p02y UNION SELECT p21y UNION SELECT p22y)b);
 
   -- generating the geometry
   v_geometry = '{"st_astext":"POLYGON('  || p21x ||' '|| p21y || ',' || p22x ||' '|| p22y || ',' || p02x || ' ' || p02y || ','|| p01x ||' '|| p01y || ',' || p21x ||' '|| p21y || ')"}';
   v_extent = '"[' || v_xmin || ',' || v_ymin || ',' || v_xmax || ',' || v_ymax || ']"';

	-- Control NULL's
    v_version := COALESCE(v_version, '');
    v_geometry := COALESCE(v_geometry, '{}');
    v_mapcomposer_name := COALESCE(v_mapcomposer_name, '{}');
    v_extent := COALESCE(v_extent, '{}');
    
	--Return
    RETURN ('{"status":"Accepted",'||
     '"version":"'|| v_version ||'"'||
     ',"data":{'||
         '"geometry":'|| v_geometry ||
        ',"map":"' || v_mapcomposer_name || '"'
        ',"mapIndex":' || v_index || 
        ',"extent":'||v_extent ||'}}')::json;

	-- Exception handling
    EXCEPTION WHEN OTHERS THEN 
    RETURN json_build_objects('status', 'Failed', 'NOSQLERR', SQLERRM, 'version', v_version, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM))::json;

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

