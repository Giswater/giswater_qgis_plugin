/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:3104

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_istram(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_import_istram($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{}}$$)
 SELECT SCHEMA_NAME.gw_fct_import_istram($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "importParam":"n1", "fid":"408"}}$$);
--fid:234

*/

DECLARE

v_units record;
v_result_id text= 'import istream data';
v_result json;
v_result_info json;
v_project_type text;
v_version text;
v_count integer;
v_label text;
v_error_context text;
v_level integer;
v_status text;
v_message text;
v_audit_result text;
v_fid integer;
v_srid integer;
v_expl_id integer;
v_dma_id integer;
v_sector_id integer;
v_action text;
v_action_params json;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT project_type, giswater, epsg INTO v_project_type, v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;


   	v_label = ((p_data ->>'data')::json->>'importParam')::text;
   	v_fid = ((p_data ->>'data')::json->>'fid')::text;

	-- manage log (fid:  234)
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user;
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('IMPORT ISTREAM DATA'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('------------------------------'));


	-- control of rows
	SELECT count(*) INTO v_count FROM temp_csv WHERE cur_user=current_user AND fid = v_fid;

	IF v_count =0 THEN
		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Nothing to import'));
	ELSE

		IF v_fid = 408 THEN
			--reset selector values
			DELETE FROM selector_expl WHERE cur_user=current_user;
			INSERT INTO selector_expl (expl_id) VALUES (0);

			--insert values into catalogs
			INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, descript)
			VALUES ('MANHOLE','MANHOLE','NODE', 've_node', 'Manhole') ON CONFLICT (id) DO NOTHING;

			INSERT INTO cat_node(id)
			VALUES ('MANHOLE') ON CONFLICT (id) DO NOTHING;

			INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Insert basic catalogs for node - type MANHOLE'));

			--insert data of nodes
			INSERT INTO ve_node (code, top_elev, ymax,  node_type, nodecat_id, matcat_id, epa_type, expl_id,
      sector_id, state, state_type, annotation, descript, dma_id, muni_id, the_geom)
      SELECT DISTINCT csv1, csv5::float,csv5::float - csv4::float, 'MANHOLE', 'MANHOLE', null, 'JUNCTION', 0,
      0, 1, 2, csv6, csv7, 0, 0, ST_SetSRID(ST_MakePoint(csv2::float, csv3::float),v_srid)
      FROM temp_csv WHERE fid=408;


      --create exploitation around nodes and set correct expl_id
      INSERT INTO macroexploitation (macroexpl_id, name) SELECT max(macroexpl_id)+1, 'IMPORT ISTREAM' FROM macroexploitation RETURNING macroexpl_id into v_expl_id;

      INSERT INTO exploitation (expl_id, name, macroexpl_id, the_geom)
      SELECT max(e.expl_id)+1, 'IMPORT ISTREAM', v_expl_id, ST_multi(ST_Buffer(ST_ConvexHull(ST_Collect(n.the_geom)),50))
      FROM exploitation e, ve_node n
      RETURNING expl_id into v_expl_id;


      INSERT INTO macrosector(name) VALUES ('IMPORT ISTREAM') RETURNING macrosector_id into v_sector_id;
      INSERT INTO sector(name, macrosector_id,the_geom)
      SELECT 'IMPORT ISTREAM', v_sector_id, e.the_geom FROM exploitation e WHERE expl_id=v_expl_id
      RETURNING sector_id into v_sector_id;


      INSERT INTO macrodma(name, expl_id) VALUES ('IMPORT ISTREAM', v_expl_id) RETURNING macrodma_id into v_dma_id;
      INSERT INTO dma(name, macrodma_id,the_geom)
      SELECT 'IMPORT ISTREAM', v_dma_id, e.the_geom FROM exploitation e WHERE expl_id=v_expl_id
			RETURNING dma_id into v_dma_id;


      UPDATE node SET expl_id=v_expl_id, dma_id=v_dma_id, sector_id=v_sector_id WHERE expl_id=0;

      INSERT INTO selector_expl (expl_id) VALUES (v_expl_id) ON CONFLICT (expl_id, cur_user) DO NOTHING;

      SELECT count(*) INTO v_count FROM ve_node WHERE expl_id=v_expl_id;
      INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Insert ',v_count, ' nodes'));

			INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Create import istream mapzones.'));

		ELSIF v_fid = 409 THEN

			SELECT count(node_id) INTO v_count FROM node WHERE code = (SELECT csv2 FROM temp_csv WHERE fid=409 LIMIT 1);

			IF v_count = 0 THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3190", "function":"3104","parameters":null, "is_process":true}}$$);'INTO v_audit_result;
			ELSE
				--insert values into catalogs
				INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, descript)
				VALUES ('CONDUIT','CONDUIT','ARC', 've_arc', 'Conduit') ON CONFLICT (id) DO NOTHING;

				INSERT INTO cat_material (id, feature_type)
				SELECT DISTINCT (csv6), '{ARC}'::text[]
				FROM temp_csv
				WHERE fid=409
				ON CONFLICT (id) DO UPDATE SET feature_type = array_append(cat_material.feature_type, 'ARC');

				INSERT INTO cat_arc(id, shape, geom1, geom2)
		  	SELECT DISTINCT CASE WHEN csv7='CIRCULAR' THEN concat(csv7,csv8::float)
				ELSE concat(csv7,csv8::float,'x',csv9::float) end as cat,csv7,
				csv8::float, CASE WHEN csv9!='''' and csv9!='' THEN csv9::numeric END AS geom2
				FROM temp_csv WHERE fid=409 ON CONFLICT (id) DO NOTHING;

				INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Insert basic catalogs for arc type CONDUIT'));

				--insert data of arcs
				INSERT INTO ve_arc (code, elev1, elev2, arc_type,
	      arccat_id, matcat_id, epa_type,  state, state_type,
	      annotation,  muni_id, descript, the_geom, expl_id)
	      SELECT csv1, csv3::float, csv5::float, 'CONDUIT',
	      CASE WHEN csv7='CIRCULAR' THEN concat(csv7,csv8::float)
				ELSE concat(csv7,csv8::float,'x',csv9::float) end as cat,
				csv6, 'CONDUIT',  1,2,
				csv10, 0, csv11,ST_MakeLine(n1.the_geom, n2.the_geom), n1.expl_id
	      FROM temp_csv
	      JOIN node n1 ON n1.code=csv2
	      JOIN node n2 ON n2.code=csv4
	      WHERE fid=409;

	      SELECT expl_id INTO v_expl_id FROM arc WHERE expl_id IS NOT NULL AND code IN (SELECT csv1 FROM temp_csv WHERE fid=409) LIMIT 1;

	      --reset selector values
	      INSERT INTO selector_expl (expl_id) VALUES (v_expl_id) ON CONFLICT (expl_id, cur_user) DO NOTHING;

	      SELECT count(*) INTO v_count FROM ve_arc WHERE expl_id=v_expl_id;

	      INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Insert ',v_count,' arcs'));

	  	END IF;
		END IF;


	END IF;

	SELECT addparam INTO v_action_params FROM config_csv WHERE fid=v_fid;

	-- get log
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid) row;

	IF v_audit_result is null THEN
        v_status = 'Accepted';
        v_level = 3;
        v_message = 'Process done successfully';
    ELSE

        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

    END IF;


	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');
	v_action = concat('[{"funcName": "add_query_layer", "params":', v_action_params, '}]');

	-- Control nulls
	v_version := COALESCE(v_version, '{}');
	v_result_info := COALESCE(v_result_info, '{}');

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
            ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}}'||
	    '}')::json, 3104, null, null, v_action::json);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
