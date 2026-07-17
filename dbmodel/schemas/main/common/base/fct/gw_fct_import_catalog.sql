/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:3150


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_catalog(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_import_catalog($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{}}$$)

--fid:v_fid

*/

DECLARE


v_result_id text= 'import catalogs';
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
v_shortcut text;
BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;


   	v_fid = ((p_data ->>'data')::json->>'fid')::text;


	-- manage log (fid:  v_fid)
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user;
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3150", "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "is_process":true, "is_header":"true"}}$$)';



	-- control of rows
	SELECT count(*) INTO v_count FROM temp_csv WHERE cur_user=current_user AND fid = v_fid;

	IF v_count =0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4136", "function":"3150", "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "is_process":true}}$$)';
	ELSE
		--check if shortcut_key is duplicated with excisting data
		IF v_fid !=445 THEN
			SELECT csv5 FROM temp_csv INTO v_shortcut WHERE cur_user=current_user AND fid=v_fid
			AND csv5 IN (SELECT shortcut_key FROM cat_feature) AND  csv1 NOT IN (SELECT id FROM cat_feature) LIMIT 1;
		ELSE
			IF v_project_type = 'WS' THEN
				SELECT csv10 FROM temp_csv INTO v_shortcut WHERE cur_user=current_user AND fid=v_fid
				AND csv10 IN (SELECT shortcut_key FROM cat_feature) AND csv1 NOT IN (SELECT id FROM cat_feature) LIMIT 1;
			ELSIF v_project_type = 'UD' THEN
				SELECT csv8 FROM temp_csv INTO v_shortcut WHERE cur_user=current_user AND fid=v_fid
				AND csv8 IN (SELECT shortcut_key FROM cat_feature) AND csv1 NOT IN (SELECT id FROM cat_feature) LIMIT 1;
			END IF;
		END IF;

		IF v_shortcut IS NOT NULL THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3196", "function":"3148","parameters":{"shortcut":"'||v_shortcut||'"}, "is_process":true}}$$);'INTO v_audit_result;
		END IF;

		--insert configuration
		IF v_fid = 450 THEN
			--arc
			IF v_project_type = 'WS' THEN
				INSERT INTO cat_material (id, descript, feature_type)
				SELECT DISTINCT (csv3, csv3), '{ARC}'::text[]
				FROM temp_csv
				WHERE cur_user = current_user
				AND fid=v_fid
				AND csv3 IS NOT NULL
				ON CONFLICT (id) DO UPDATE SET feature_type = array_append(cat_material.feature_type, 'ARC');

				INSERT INTO cat_brand(id)
				SELECT csv10 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv10 IS NOT NULL ON CONFLICT (id) DO NOTHING;

				INSERT INTO cat_brand_model(id,catbrand_id)
				SELECT csv11, csv10 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv11 IS NOT NULL ON CONFLICT (id) DO NOTHING;

				INSERT INTO plan_price(id, unit, descript)
				SELECT csv20 ,csv19, csv20 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv20 IS NOT NULL ON CONFLICT (id) DO NOTHING;

				INSERT INTO plan_price(id, unit, descript)
				SELECT csv21, 'u', csv21 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv21 IS NOT NULL ON CONFLICT (id) DO NOTHING;

				INSERT INTO plan_price(id, unit, descript)
				SELECT csv22, 'u', csv22 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv22 IS NOT NULL  ON CONFLICT (id) DO NOTHING;

				INSERT INTO cat_arc(id, arc_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1, z2, width, area, estimated_depth,
				bulk, cost_unit, cost, m2bottom_cost, m3protec_cost, active, label, shape, acoeff, connect_cost)
				SELECT csv1, csv2, csv3, csv4, csv5, csv6::numeric, csv7::numeric, csv8, csv9, csv10, csv11, csv12, csv13::numeric, csv14::numeric, csv15::numeric, csv16::numeric, csv17::numeric,
	      		csv18::numeric, csv19, csv20, csv21, csv22, csv23::boolean, csv24, csv25, csv26::numeric, csv27
				FROM temp_csv WHERE cur_user=current_user AND fid=v_fid ON CONFLICT (id) DO NOTHING;

			ELSIF v_project_type = 'UD' THEN

				INSERT INTO cat_material (id, descript, feature_type)
				SELECT DISTINCT (csv2, csv2), '{ARC}'::text[]
				FROM temp_csv
				WHERE cur_user = current_user
				AND fid=v_fid
				AND csv2 IS NOT NULL
				ON CONFLICT (id) DO UPDATE SET feature_type = array_append(cat_material.feature_type, 'ARC');

				INSERT INTO cat_brand(id)
				SELECT csv15 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv15 IS NOT NULL ON CONFLICT (id) DO NOTHING;

				INSERT INTO cat_brand_model(id,catbrand_id)
				SELECT csv16, csv15 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv16 IS NOT NULL ON CONFLICT (id) DO NOTHING;

				INSERT INTO plan_price(id, unit, descript)
				SELECT csv25, csv24, csv25 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv25 IS NOT NULL ON CONFLICT (id) DO NOTHING;

				INSERT INTO plan_price(id, unit, descript)
				SELECT csv26, 'u', csv26 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv26 IS NOT NULL ON CONFLICT (id) DO NOTHING;

				INSERT INTO plan_price(id, unit, descript)
				SELECT csv27, 'u', csv27 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv27 IS NOT NULL  ON CONFLICT (id) DO NOTHING;

				INSERT INTO cat_arc(id, matcat_id, shape, geom1, geom2, geom3, geom4, geom5, geom6,
				geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1, z2, width,
				area, estimated_depth, bulk, cost_unit, cost, m2bottom_cost,
				m3protec_cost, active, label, tsect_id, curve_id, arc_type, acoeff, connect_cost)
				SELECT csv1, csv2, csv3, csv4::numeric, csv5::numeric, csv6::numeric, csv7::numeric, csv8::numeric, csv9::numeric,
				csv10::numeric, csv11::numeric, csv12, csv13, csv14, csv15, csv16, csv17, csv18::numeric, csv19::numeric, csv20::numeric,
				csv21::numeric, csv22::numeric, csv23::numeric, csv24, csv25, csv26,
				csv27, csv28::boolean, csv29, csv30, csv31, csv32, csv33::numeric, csv34
				FROM temp_csv WHERE cur_user=current_user AND fid=v_fid ON CONFLICT (id) DO NOTHING;

			END IF;

		ELSIF v_fid=448 THEN
			--node
			IF v_project_type = 'WS' THEN
				INSERT INTO cat_material (id, descript, feature_type)
				SELECT csv3, csv3, '{NODE}'::text[] FROM temp_csv
				WHERE cur_user=current_user AND fid=v_fid AND csv3 IS NOT NULL ON CONFLICT (id) DO NOTHING;

				INSERT INTO cat_brand(id)
				SELECT csv11 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv11 IS NOT NULL ON CONFLICT (id) DO NOTHING;

				INSERT INTO cat_brand_model(id, catbrand_id)
				SELECT csv12, csv11 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv12 IS NOT NULL ON CONFLICT (id) DO NOTHING;

				INSERT INTO plan_price(id, unit, descript)
				SELECT csv16, CASE WHEN csv15 IS NULL THEN 'u' ELSE csv15 END , csv16 FROM temp_csv
				WHERE cur_user=current_user AND csv16 IS NOT NULL AND fid=v_fid ON CONFLICT (id) DO NOTHING;

				INSERT INTO cat_node(id, node_type, matcat_id, pnom, dnom, dint, dext, shape, descript,
				link, brand_id, model_id, svg, estimated_depth, cost_unit, cost, active,
				label, ischange, acoeff)
				SELECT csv1, csv2, csv3, csv4, csv5, csv6::numeric, csv7::numeric, csv8, csv9,
				csv10, csv11, csv12, csv13, csv14::numeric, csv15, csv16, csv17::boolean,
				csv18, csv19::integer,csv20::numeric
		   		FROM temp_csv WHERE cur_user=current_user AND fid=v_fid ON CONFLICT (id) DO NOTHING;


			ELSIF v_project_type = 'UD' THEN
				INSERT INTO cat_material (id, descript, feature_type)
				SELECT csv2, csv2, '{NODE}'::text[] FROM temp_csv
				WHERE cur_user=current_user AND fid=v_fid AND csv2 IS NOT NULL ON CONFLICT (id) DO NOTHING;

				INSERT INTO cat_node_shape(id)
				SELECT csv3 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv3 IS NOT NULL ON CONFLICT (id) DO NOTHING;

				INSERT INTO cat_brand(id)
				SELECT csv9 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv9 IS NOT NULL ON CONFLICT (id) DO NOTHING;

				INSERT INTO cat_brand_model(id, catbrand_id)
				SELECT csv10, csv9 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv10 IS NOT NULL  ON CONFLICT (id) DO NOTHING;

				INSERT INTO plan_price(id, unit, descript)
				SELECT csv14, CASE WHEN csv13 IS NULL THEN 'u' ELSE csv13 END , csv14 FROM temp_csv
				WHERE cur_user=current_user AND csv14 IS NOT NULL AND fid=v_fid ON CONFLICT (id) DO NOTHING;

				INSERT INTO cat_node(id, matcat_id, shape, geom1, geom2, geom3, descript, link, brand_id,
				model_id, svg, estimated_y, cost_unit, cost, active, label, node_type, acoeff)
				SELECT csv1, csv2, csv3, csv4::numeric, csv5::numeric, csv6::numeric, csv7, csv8, csv9,
				csv10, csv11, csv12::numeric, csv13, csv14, csv15::boolean, csv16, csv17, csv18::numeric
				FROM temp_csv WHERE cur_user=current_user AND fid=v_fid ON CONFLICT (id) DO NOTHING;

			END IF;

		ELSIF v_fid=449 THEN
		--connec
		IF v_project_type = 'WS' THEN

		ELSIF v_project_type = 'UD' THEN

			INSERT INTO cat_material (id, descript, feature_type)
			SELECT DISTINCT (csv2, csv2), '{ARC}'::text[]
			FROM temp_csv
			WHERE cur_user = current_user
			AND fid=v_fid
			AND csv2 IS NOT NULL
			ON CONFLICT (id) DO UPDATE SET feature_type = array_append(cat_material.feature_type, 'ARC');

			INSERT INTO cat_brand(id)
			SELECT csv11 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv11 IS NOT NULL ON CONFLICT (id) DO NOTHING;

			INSERT INTO cat_brand_model(id, catbrand_id)
			SELECT csv12, csv11 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv12 IS NOT NULL ON CONFLICT (id) DO NOTHING;

			INSERT INTO cat_connec (id, matcat_id, shape, geom1, geom2, geom3, geom4, geom_r, descript,
      		link, brand_id, model_id, svg, active, label, connec_type)
			SELECT csv1, csv2, csv3, csv4::numeric, csv5::numeric, csv6::numeric, csv7::numeric, csv8::numeric, csv9,
			csv10, csv11, csv12, csv13, csv14::boolean, csv15, csv16
			FROM temp_csv WHERE cur_user=current_user AND fid=v_fid ON CONFLICT (id) DO NOTHING;
		END IF;

		ELSIF v_fid=451 THEN
			--gully
			INSERT INTO cat_material (id, descript, feature_type)
			SELECT DISTINCT (csv2, csv2), '{GULLY}'::text[]
			FROM temp_csv
			WHERE cur_user = current_user
			AND fid=v_fid
			AND csv2 IS NOT NULL
			ON CONFLICT (id) DO UPDATE SET feature_type = array_append(cat_material.feature_type, 'GULLY');

			INSERT INTO cat_brand(id)
			SELECT csv14 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv14 IS NOT NULL ON CONFLICT (id) DO NOTHING;

			INSERT INTO cat_brand_model(id, catbrand_id)
			SELECT csv15, csv14 FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv15 IS NOT NULL ON CONFLICT (id) DO NOTHING;

			INSERT INTO cat_gully(id, matcat_id, length, width, total_area, effective_area, n_barr_l,
      		n_barr_w, n_barr_diag, a_param, b_param, descript, link, brand_id, model_id, svg, active, label, gully_type)
			SELECT csv1, csv2, csv3::numeric, csv4::numeric, csv5::numeric, csv6::numeric, csv7::numeric,
			csv8::numeric, csv9::numeric, csv10::numeric, csv11::numeric, csv12, csv13, csv14, csv15, csv16, csv17::boolean, csv18, csv19
			FROM temp_csv WHERE cur_user=current_user AND fid=v_fid ON CONFLICT (id) DO NOTHING;
		END IF;

		-- manage log (fid: v_fid)
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3908", "function":"3150", "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "is_process":true}}$$)';
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3946", "function":"3150", "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "is_process":true}}$$)';
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3948", "function":"3150", "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "is_process":true}}$$)';

	END IF;

	-- get log (fid: v_fid)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid) row;

	IF v_audit_result is null THEN
        v_status = 'Accepted';
        v_level = 3;
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3700", "function":"3150", "is_process":true}}$$)::JSON->>''text''' INTO v_message;

    ELSE

        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

    END IF;


	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	-- Control nulls
	v_version := COALESCE(v_version, '');
	v_result_info := COALESCE(v_result_info, '{}');

	-- Return
	RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
            ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}}'||
	    '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
