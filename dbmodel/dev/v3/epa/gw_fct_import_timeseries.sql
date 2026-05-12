	/*
	This file is part of Giswater
	The program is free software: you can redistribute it and/or modify it under the terms of the GNU
	General Public License as published by the Free Software Foundation, either version 3 of the License,
	or (at your option) any later version.
	*/


	--FUNCTION CODE: 2738

	DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_timeseries();
	CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_timeseries(p_data json)
	  RETURNS json AS
	$BODY$


	/*INSTRUCTIONS

	TO EXECUTE:
	SELECT SCHEMA_NAME.gw_fct_import_timeseries()

	TO CHECK RESULTS:
	GENERAL
	select * from SCHEMA_NAME.ext_timeseries

	IN CASE OF EPA
	select * from SCHEMA_NAME.inp_pattern
	select * from SCHEMA_NAME.inp_pattern_value
	select * from SCHEMA_NAME.ext_rtc_scada_dma_period


	-- INSTRUCTIONS
	---------------
	code; external code or internal identifier. An example of code could be CCCCCCCC-YYYYMMDDHHMMSS-15M-0000096. CCCCCCCC it means the name of the source. 15M tstepvalue, 96 tstep number
	operator_id; to indetify different operators
	tscatalog_id; imdp, t15, t85, fireindex, sworksindex, treeindex, qualhead, pressure, flow, inflow
	tselement; {"type":"exploitation",
			 "id":[1,2,3,4]} -- expl_id, muni_id, arc_id, node_id, dma_id, sector_id, dqa_id
	param, {"isUnitary":false, it means if sumatory of all values of ts is 1 (true) or not
		"units":"BAR"  in case of no units put any value you want (adimensional, nounits...). WARNING: use CMH or LPS in case of VOLUME patterns for EPANET
	 	"epa":{"projectType":"WS", "class":"pattern", "id":"test1", "type":"UNITARY", "dmaRtcParameters":{"dmaId":"","periodId":""}
		"source":{"type":"flowmeter", "id":"V2323", "import":{"type":"file", "id":"test.csv"}},
	period; {"type":"monthly", "id":201903", "start":"2019-01-01", "end":"2019-01-02"}
	timestep; {"units":"minute", "value":"15", "number":2345}};
	val; any rows any columns with values
	descript; free text';

	--WARNINGS
	----------
	-- The codificacion of csv file must be utf-8 without boom
	-- the ';' it's forbidden to use on descriptors because is the separator of the csv
	-- If "isUnitary":"true", sumatory of values must be 1
	-- The tsparam->'timestep'->'number' must be the same of number of values. On the opposite will not be imported
	-- The number of rows and columns for val is not defined. Up to you. We an affordable number of rows/columns to make easy the visual check of timeseries
	-- If this timeseries is used for EPA, please fill this projectType and PatterType. Use ''UNITARY'', for sum of values = 1 or ''VOLUME'', when are real volume values
	-- If pattern is used on EPA and it's related to dma x rtc period please fill dmaRtcParameters parameters


	-- EXAMPLE
	----------
	code;201711150000V000
	operator;1
	catalog_id;flow
	element;{"type":"node", "id":"n4"}
	param;{"isUnitary":"true", "units":"ADMENSIONAL", "epa":{"projectType":"WS", "class":"pattern", "id":"test1", "type":"UNITARY", "dmaRtcParameters":{"dmaId":"","periodId":""}}, "source":{"import":{"type":"file", "id":"2018.csv"}}}
	period;{"type":"monthly", "id":"201905", "start":"2019-05-01", "end":"2019-05-31"}
	timestep;{"units":"minute", "value":15, "number":96}
	val;48.1176;51.8873;51.6861;48.9647;49.2083;47.2704;45.5338;45.1632;44.5172;41.8170;41.8805;41.7746;40.5251;40.5780;39.7838;39.4238
	val;37.9413;36.8400;36.3000;36.4482;38.4919;39.1379;39.8156;42.0393;45.4067;50.1083;54.3758;63.6414;73.3412;81.2831;81.5690;83.6233
	val;80.8172;81.6325;82.9350;79.3347;73.3722;75.6620;76.0308;77.7251;78.9922;79.9781;81.1031;77.3161;78.6252;74.6436;77.7675;72.3976
	val;73.3835;70.3973;75.7606;75.8932;70.4477;70.2703;72.3246;69.1332;72.7164;72.8248;72.5510;72.1340;69.3702;69.2961;67.4218;67.9724
	val;66.2146;64.2873;60.5176;60.8035;59.9881;58.6750;59.5751;58.4844;58.8974;60.8670;62.2224;66.4899;66.4687;68.7772;69.9632;71.6892
	val;73.0870;74.8448;76.0202;77.1745;71.7634;73.5953;70.3973;66.9770;64.6686;58.9292;52.8827;49.8330;46.4656;45.8620;44.8878;44.1572
	descript;sample timeseries

	-- fid: 117

	*/

	DECLARE

	v_array double precision[][];
	v_x integer;
	v_y integer;
	v_rid int8;
	v_field text;
	v_value double precision;
	v_csv record;
	v_id integer;
	v_pattern text;
	v_source  text;
	v_descript text;
	v_dma text;
	v_period text;
	v_sum float;
	v_min float;
	v_max float;
	v_patterntype text;
	v_units float;
	v_unitsvalue text;
	v_projecttype text;
	v_tsprojecttype text;
	v_querytext text;
	v_count integer = 0;
	v double precision[];

	v_result json;
	v_result_info json;
	v_version text;

	BEGIN

		--  Search path
		SET search_path = "SCHEMA_NAME", public;

		-- project type
		SELECT project_type, giswater  INTO v_projecttype, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

		-- Insert into audit table
		/*INSERT INTO audit_log_csv2pg
		(fid, cur_user,csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12,csv13,csv14,csv15,csv16,csv17,csv18,csv19,csv20)
		SELECT fid, cur_user,csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12,csv13,csv14,csv15,csv16,csv17,csv18,csv19,csv20
		FROM temp_csv WHERE fid = 117 order by id;
	*/
		-- insert into ext_timeseries table
		INSERT INTO ext_timeseries (code, operator_id, catalog_id, element, param, period, timestep, val)
		SELECT code, operator::integer, catalog_id, element::json, param::json, period::json, timestep::json, val
			FROM crosstab('SELECT fid,csv1, csv2 FROM temp_csv WHERE fid = 117'::text, ' VALUES (''code''),(''operator''),(''catalog_id''),(''element''),(''param''),(''period''),(''timestep'')'::text)
					ct(id integer, code text, operator text, catalog_id text, element text, param text, period text, timestep text)
			JOIN (select 117 as id , (array_agg(value))::float[] as val from (
				SELECT id, 2 as row, csv2 as value FROM temp_csv WHERE csv1='val' AND csv2 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 3, csv3 FROM temp_csv WHERE csv1='val' AND csv3 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 4, csv4 FROM temp_csv WHERE csv1='val' AND csv4 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 5, csv5 FROM temp_csv WHERE csv1='val' AND csv5 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 6, csv6 FROM temp_csv WHERE csv1='val' AND csv6 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 7, csv7 FROM temp_csv WHERE csv1='val' AND csv7 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 8, csv8 FROM temp_csv WHERE csv1='val' AND csv8 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 9, csv9 FROM temp_csv WHERE csv1='val' AND csv9 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 10, csv10 FROM temp_csv WHERE csv1='val' AND csv10 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 11, csv11 FROM temp_csv WHERE csv1='val' AND csv11 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 12, csv12 FROM temp_csv WHERE csv1='val' AND csv12 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 13, csv13 FROM temp_csv WHERE csv1='val' AND csv13 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 14, csv14 FROM temp_csv WHERE csv1='val' AND csv14 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 15, csv15 FROM temp_csv WHERE csv1='val' AND csv15 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 16, csv16 FROM temp_csv WHERE csv1='val' AND csv16 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 117, csv17 FROM temp_csv WHERE csv1='val' AND csv17 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 18, csv18 FROM temp_csv WHERE csv1='val' AND csv18 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 19, csv19 FROM temp_csv WHERE csv1='val' AND csv19 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 20, csv20 FROM temp_csv WHERE csv1='val' AND csv20 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 21, csv21 FROM temp_csv WHERE csv1='val' AND csv21 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 22, csv22 FROM temp_csv WHERE csv1='val' AND csv22 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 23, csv23 FROM temp_csv WHERE csv1='val' AND csv23 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 24, csv24 FROM temp_csv WHERE csv1='val' AND csv24 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 25, csv25 FROM temp_csv WHERE csv1='val' AND csv25 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 26, csv26 FROM temp_csv WHERE csv1='val' AND csv26 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 27, csv27 FROM temp_csv WHERE csv1='val' AND csv27 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 28, csv28 FROM temp_csv WHERE csv1='val' AND csv28 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 29, csv29 FROM temp_csv WHERE csv1='val' AND csv29 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 30, csv30 FROM temp_csv WHERE csv1='val' AND csv30 IS NOT NULL AND fid = 117 AND cur_user=current_user UNION
				SELECT id, 31, csv31 FROM temp_csv WHERE csv1='val' AND csv31 IS NOT NULL
				ORDER BY 1,2) a ) b USING (id)
				RETURNING id INTO v_id;


		-- insert into epanet inp_pattern tables (if it needs)
		v_tsprojecttype = (SELECT (param->>'epa')::json->>'projectType' FROM ext_timeseries WHERE id=v_id);

		IF v_tsprojecttype=v_projecttype AND v_projecttype='WS' THEN

			-- control if pattern exists
			IF (SELECT pattern_id FROM inp_pattern WHERE pattern_id=v_pattern) IS NOT NULL THEN
				SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3064", "function":"2738","parameters":null, "is_process":true}}$$);
			END IF;

			-- inserting new pattern
			v_pattern = (SELECT (param->>'epa')::json->>'id' FROM ext_timeseries WHERE id=v_id);
			v_patterntype = (SELECT (param->>'epa')::json->>'type' FROM ext_timeseries WHERE id=v_id);
			v_unitsvalue = (SELECT (param->>'units')FROM ext_timeseries WHERE id=v_id);

			INSERT INTO inp_pattern (pattern_id, pattern_type, tscode, tsparameters)
			SELECT v_pattern, v_patterntype, code, concat('{"parameters":',param,',"period":', period, ',"timestep":',timestep,'}')::json FROM ext_timeseries WHERE id=v_id;

			-- insert on inp_pattern_value

			-- coefficient from volume (m3/tsep) to flow (l/s) 1 LPS = 3.6 CMH
			IF v_unitsvalue = 'CMH' THEN
				v_units:= 1/3.6;
			END IF;

			-- create a 18 column array
			FOR v_x IN 1..100 LOOP

				-- inserting row
				SELECT array_agg(col) INTO v::float[] FROM (SELECT unnest(val::float[]) as col FROM ext_timeseries where id=v_id LIMIT 18 offset v_count)a;
				raise notice ' % ', v;

				-- inserting row
				INSERT INTO inp_pattern_value (pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6,
				factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18)
				VALUES (v_pattern, v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9], v[10], v[11], v[12], v[13], v[14], v[15], v[16], v[17], v[18]);

				v_count = v_count + 18;

				EXIT WHEN v[18] IS NULL;

			END LOOP;

			-- if it is dmaRtc pattern
			IF (SELECT (param->>'epa')::json->>'dmaRtcParameters' FROM ext_timeseries WHERE id=v_id) IS NOT NULL THEN
				v_dma = (SELECT ((param->>'epa')::json->>'dmaRtcParameters')::json->>'dmaId' FROM ext_timeseries WHERE id=v_id);
				v_period = (SELECT ((param->>'epa')::json->>'dmaRtcParameters')::json->>'periodId' FROM ext_timeseries WHERE id=v_id);

				-- control of existency of row on dmaRtc table
				IF (SELECT id FROM ext_rtc_scada_dma_period WHERE dma_id=v_dma and cat_period_id=v_period) IS NULL THEN
					SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3066", "function":"2738","parameters":null, "is_process":true}}$$);

				ELSE
					IF (SELECT pattern_id FROM ext_rtc_scada_dma_period WHERE dma_id=v_dma and cat_period_id=v_period) IS NOT NULL THEN
						SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"message":"3068", "function":"2738","parameters":null, "is_process":true}}$$);
					ELSE
						UPDATE ext_rtc_scada_dma_period SET pattern_id=v_pattern WHERE dma_id=v_dma and cat_period_id=v_period;

						-- normalize factor
						v_sum = (SELECT sum(factor_1)+sum(factor_2)+sum(factor_3)+sum(factor_4)+sum(factor_5)+sum(factor_6)+sum(factor_7)+sum(factor_8)+sum(factor_9)+sum(factor_10)+sum(factor_11)
						+sum(factor_12)+sum(factor_13)+ sum(factor_14)+sum(factor_15)+sum(factor_16)+sum(factor_17)+sum(factor_18) FROM inp_pattern_value WHERE pattern_id=v_pattern)::float;

						-- get min value from pattern
						v_min = (SELECT  min(min) FROM (SELECT min(factor_1) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_2) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_3) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_4) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_5) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_6) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_7) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_8) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_9) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_10) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_11) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_12) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_13) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_14) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_15) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_16) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_17) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_18) FROM inp_pattern_value WHERE pattern_id=v_pattern)a);

						-- get max value from pattern
						v_max = (SELECT  max(max) FROM (SELECT max(factor_1) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT max(factor_2) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT max(factor_3) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT max(factor_4) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT max(factor_5) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT max(factor_6) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT max(factor_7) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT max(factor_8) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT max(factor_9) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT max(factor_10) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT max(factor_11) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT max(factor_12) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT max(factor_13) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT max(factor_14) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT max(factor_15) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_16) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_17) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
							SELECT min(factor_18) FROM inp_pattern_value WHERE pattern_id=v_pattern)a);

						-- update ext_rtc_scada_dma_period with min and max values
						UPDATE ext_rtc_scada_dma_period SET minc=v_min, maxc=v_max WHERE dma_id=v_dma AND cat_period_id=v_period;
					END IF;
				END IF;
			END IF;
		END IF;

		-- get log (fid: 244)
		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
		FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND fid = 244) row;
		v_result := COALESCE(v_result, '{}');
		v_result_info = concat ('{"values":',v_result, '}');

		-- Control nulls
		v_version := COALESCE(v_version, '');
		v_result_info := COALESCE(v_result_info, '{}');

		-- Return
		RETURN ('{"status":"Accepted", "message":{"level":0, "text":"Process executed"}, "version":"'||v_version||'"'||
	             ',"body":{"form":{}'||
			     ',"data":{ "info":'||v_result_info||'}}'||
		    '}')::json;

		-- Exception handling
		EXCEPTION WHEN OTHERS THEN
		RETURN json_build_object('status', 'Failed', 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'version', v_version, 'SQLSTATE', SQLSTATE)::json;


	END;
	$BODY$
	  LANGUAGE plpgsql VOLATILE
	  COST 100;
