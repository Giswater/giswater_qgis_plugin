/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- FUNCTION: SCHEMA_NAME.gw_fct_getepacalfile(json)

-- DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getepacalfile(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getepacalfile(
	p_data json)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE 
AS $BODY$
/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_getepacalfile($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831},
"data":{"type":"pressure", "resultType":"dint", "resultValue":0.22, "inputFile":"file_name", "outputFile":"out_file_name", "dscenarioId":"2", "resultId":"test1", "nodeId":"1001", "pressure":"34", "duration":"3600", "Accuaracy":"1", "trials":"30"}}$$)
--fid:474/475/476
*/
DECLARE
rec_table record;
column_number integer;
id_last integer;
num_col_rec record;
num_column text;
v_fid integer;
v_return json;
v_client_epsg integer;
v_type text;
v_result varchar;
v_period varchar;
v_dscenario text;
v_inputfile text;
v_outputfile text;
v_result_type text;
v_result_value float;
v_node text;
v_pressure text;
v_duration text;
v_accuaracy text;
v_trials text;
v_selector_result record;
v_sel_dsc_updated boolean = FALSE;
v_sel_res_updated boolean = FALSE;
v_fields_keys text[];
dma_id text;
v_ife text;
BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;
	-- get Generic input parameters
	v_type = (p_data->>'data')::json->>'type';
	v_client_epsg = (p_data->>'client')::json->>'epsg';
	
	-- Get Pressure input parameters
	v_result_type = (p_data->>'data')::json->>'resultType';
	v_result_value = (p_data->>'data')::json->>'resultValue';
	v_inputfile = (p_data->>'data')::json->>'inputFile';
	v_outputfile = (p_data->>'data')::json->>'outputFile';
	v_dscenario = (p_data->>'data')::json->>'dscenarioId';
	v_result = (p_data->>'data')::json->>'resultId';
	v_period = (p_data->>'data')::json->>'periodId';
	v_node = (p_data->>'data')::json->>'nodeId';
	v_pressure = (p_data->>'data')::json->>'pressure';
	v_duration = (p_data->>'data')::json->>'duration';
	v_accuaracy = (p_data->>'data')::json->>'accuaracy';
	v_trials = (p_data->>'data')::json->>'trials';
	v_ife =  (p_data->>'data')::json->>'resultIfe';
	-- Get Volume input parameters
	
	-- WIP Send this v_fid as parameter function? - Edgar
	IF v_type = 'pressure' THEN
		v_fid = 474;
	ELSIF v_type = 'volume' THEN
		IF v_result_type = 'log' THEN
			v_fid = 476;
		ELSE 
			v_fid = 475;
		END IF;
		
	END IF;
	-- Manage user selectors
	EXECUTE 'SELECT * FROM selector_inp_result WHERE cur_user = current_user' INTO v_selector_result;
	IF v_selector_result.result_id != v_result THEN
		DELETE FROM selector_inp_result WHERE cur_user = current_user;
		INSERT INTO selector_inp_result (result_id, cur_user) VALUES (v_result, current_user);
		v_sel_res_updated = TRUE;
	END IF;
	-- Manage resultType and resultValue
	IF v_result_type in ('dint','minorloss') AND v_result_value IS NOT NULL THEN
		EXECUTE 'UPDATE inp_dscenario_pipe SET '||v_result_type||' = '||v_result_value::float||' WHERE dscenario_id = '||v_dscenario::integer||'';
	ELSIF v_result_type = 'coeff' AND v_result_value IS NOT NULL THEN
		
	END IF;
	
	
	--Delete previous
	TRUNCATE temp_csv;
	
	-- build header of inp file
	INSERT INTO temp_csv (source, csv1,fid) VALUES ('header','[TITLE]',v_fid);
	INSERT INTO temp_csv (source, csv1,fid) VALUES ('header',concat(';Created by Giswater'),v_fid);
	INSERT INTO temp_csv (source, csv16,fid) VALUES ('header',';Pressure calibration input file', v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('header',';Giswater version: ',(SELECT giswater FROM sys_version ORDER BY id DESC LIMIT 1), v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('header',';Original name: ',v_inputfile, v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('header',';Result name: ',v_result, v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('header',';Date: ',left((date_trunc('second'::text, now()))::text, 19),v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('header',';User: ',current_user, v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('header',';connec_num: ',(SELECT network_stats->>'connec_num' FROM rpt_cat_result WHERE result_id = v_result), v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('header',';connec_meters: ',(SELECT network_stats->>'connec_meters' FROM rpt_cat_result WHERE result_id = v_result), v_fid);
	--
	FOR rec_table IN SELECT * FROM config_fprocess WHERE fid=v_fid order by orderby
	LOOP
		
		-- insert header
		INSERT INTO temp_csv (csv1,fid) VALUES (NULL,v_fid);
		EXECUTE 'INSERT INTO temp_csv(fid,csv1) VALUES ('||v_fid||','''|| rec_table.target||''');';
		INSERT INTO temp_csv (fid,csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12,csv13,csv14,csv15,csv16,csv17,csv18,csv19,csv20,csv21,csv22,csv23,csv24,csv25,csv26, csv27, csv28, csv29, csv30)
		SELECT v_fid,rpad(concat(';;',c1),20),rpad(c2,20),rpad(c3,20),rpad(c4,20),rpad(c5,20),rpad(c6,20),rpad(c7,20),rpad(c8,20),rpad(c9,20),rpad(c10,20),rpad(c11,20),rpad(c12,20)
		,rpad(c13,20),rpad(c14,20),rpad(c15,20),rpad(c16,20),rpad(c17,20),rpad(c18,20),rpad(c19,20),rpad(c20,20),rpad(c21,20),rpad(c22,20),rpad(c23,20),rpad(c24,20),rpad(c25,20),rpad(c26,20)
		,rpad(c27,20),rpad(c28,20),rpad(c29,20),rpad(c30,20)
		FROM crosstab('SELECT '''||rec_table.tablename||'''::text as table_name,  data_type::text, column_name::text
				FROM information_schema.columns
				WHERE table_schema =''SCHEMA_NAME'' AND table_name = '''||rec_table.tablename||'''')
		AS rpt(table_name text, c1 text, c2 text, c3 text, c4 text, c5 text, c6 text, c7 text, c8 text, c9 text, c10 text, c11 text, c12 text, c13 text, c14 text, c15 text,
		c16 text, c17 text, c18 text, c19 text, c20 text, c21 text, c22 text, c23 text, c24 text, c25 text, c26 text, c27 text, c28 text, c29 text, c30 text);
		
		INSERT INTO temp_csv (fid) VALUES (v_fid) RETURNING id INTO id_last;
	
		SELECT count(*)::text INTO num_column from information_schema.columns where table_name=rec_table.tablename AND table_schema='SCHEMA_NAME';
		
		--add underlines
		FOR num_col_rec IN 1..num_column
		LOOP
			IF num_col_rec=1 then
				EXECUTE 'UPDATE temp_csv set csv1=rpad('';;----------'',20) WHERE id='||id_last||';';
			ELSE
				EXECUTE 'UPDATE temp_csv SET csv'||num_col_rec||'=rpad(''----------'',20) WHERE id='||id_last||';';
			END IF;
		END LOOP;
		
		-- insert values	
		IF rec_table.tablename = 'vcv_emitters' and v_result_value is not null	THEN
			EXECUTE 'SELECT array_agg(a) FROM json_object_keys('''||v_result_value||''')a' INTO v_fields_keys;
			FOREACH dma_id IN ARRAY v_fields_keys
			LOOP
				IF dma_id = 'all_network' THEN
				
				ELSIF dma_id = '0' THEN
					EXECUTE 'INSERT INTO temp_csv SELECT nextval(''temp_csv_id_seq''::regclass),'||v_fid||',current_user,'''||rec_table.tablename::text||''',
					ve.node_id, ROUND((coef*'||((v_result_value->>dma_id::text)::json->>'coeff')::float||'), 8) AS coeff FROM vcv_emitters ve JOIN vcv_junction vj USING (node_id)
					WHERE vj.dma_id IS NULL;';
				ELSE
					EXECUTE 'INSERT INTO temp_csv SELECT nextval(''temp_csv_id_seq''::regclass),'||v_fid||',current_user,'''||rec_table.tablename::text||''',
					ve.node_id, ROUND((coef*'||((v_result_value->>dma_id::text)::json->>'coeff')::float||'), 8)AS coeff FROM vcv_emitters ve JOIN vcv_junction vj USING (node_id)
					WHERE vj.dma_id = '||dma_id||';';
				END IF;
			END LOOP;

		ELSIF rec_table.tablename = 'vcv_dma' THEN
			EXECUTE 'INSERT INTO temp_csv SELECT nextval(''temp_csv_id_seq''::regclass),'||v_fid||',current_user,'''||rec_table.tablename::text||''',
			* FROM '||rec_table.tablename||' WHERE period_id = '''||v_period||''';';

		ELSIF rec_table.tablename = 'vcv_dma_log' THEN
			EXECUTE 'SELECT array_agg(a) FROM json_object_keys('''||v_result_value||''')a' INTO v_fields_keys;
			FOREACH dma_id IN ARRAY v_fields_keys
			LOOP
				IF dma_id = 'all_network' THEN
				
				ELSE
					EXECUTE 'INSERT INTO temp_csv SELECT nextval(''temp_csv_id_seq''::regclass),'||v_fid||',current_user,'''||rec_table.tablename::text||''',
					vel.dma_id, ROUND('||((v_result_value->>dma_id::text)::json->>'coeff')::float||', 5)
					FROM vcv_dma_log vel WHERE dma_id = '||dma_id||'' ;
				END IF;
			END LOOP;
			
		ELSIF rec_table.tablename = 'vcv_emitters_log' THEN
			EXECUTE 'SELECT array_agg(a) FROM json_object_keys('''||v_result_value||''')a' INTO v_fields_keys;
			FOREACH dma_id IN ARRAY v_fields_keys
			LOOP
				IF dma_id = 'all_network' THEN
				
				ELSIF dma_id = '0' THEN
					EXECUTE 'INSERT INTO temp_csv SELECT nextval(''temp_csv_id_seq''::regclass),'||v_fid||',current_user,'''||rec_table.tablename::text||''',
					vel.node_id,vel.dma_id,  ROUND(c0_default::float, 8), ROUND((c0_default*'||((v_result_value->>dma_id::text)::json->>'coeff')::float||'), 8)
					FROM vcv_emitters_log vel WHERE vel.dma_id IS NULL;';
				ELSE
					EXECUTE 'INSERT INTO temp_csv SELECT nextval(''temp_csv_id_seq''::regclass),'||v_fid||',current_user,'''||rec_table.tablename::text||''',
					vel.node_id, vel.dma_id, ROUND(c0_default, 8), ROUND((c0_default*'||((v_result_value->>dma_id::text)::json->>'coeff')::float||'), 8)
					FROM vcv_emitters_log vel WHERE vel.dma_id = '||dma_id||';';
				END IF;
			END LOOP;
		
		ELSE
			EXECUTE 'INSERT INTO temp_csv SELECT nextval(''temp_csv_id_seq''::regclass),'||v_fid||',current_user,'''||rec_table.tablename::text||''',
			* FROM '||rec_table.tablename||';';
		END IF;
		
		
	END LOOP;
	-- build section OPTIONS
	INSERT INTO temp_csv (source, csv1,fid) VALUES ('options','[OPTIONS]',v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('options',';Type: ',v_type, v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('options',';Result type: ',v_result_type, v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('options',';Input result name: ',v_inputfile, v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('options',';Output result name: ',v_outputfile, v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('options',';Dscenario name: ',v_dscenario, v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('options',';Result: ',v_result, v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('options',';Node id: ',v_node, v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('options',';Pressure: ',v_pressure, v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('options',';Duration: ',v_duration, v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('options',';Accuaracy: ',v_accuaracy, v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('options',';Trials: ',v_trials, v_fid);
	INSERT INTO temp_csv (source, csv1,csv2,fid) VALUES ('options',';IFE result: ',v_ife, v_fid);
	
	
	-- build return
	select (array_to_json(array_agg(row_to_json(row))))::json
	into v_return
		from ( select text from (
		select id, concat(rpad(csv1,20), ' ', rpad(csv2,20), ' ', rpad(csv3,20), ' ', rpad(csv4,20), ' ', rpad(csv5,20), ' ', rpad(csv6,20), ' ', rpad(csv7,20), ' ', rpad(csv8,20), ' ', rpad(csv9,20), ' ', rpad(csv10,20),
		' ', rpad(csv11,20), ' ', rpad(csv12,20), ' ', rpad(csv13,20), ' ', rpad(csv14,20), ' ', rpad(csv15,20), ' ', rpad(csv16,20), ' ', rpad(csv17,20), ' ', rpad(csv18,20), ' ', rpad(csv19,20), ' ', rpad(csv20,20),
		' ', rpad(csv21,20), ' ', rpad(csv22,20), ' ', rpad(csv23,20), ' ', rpad(csv24,20), ' ', rpad(csv25,20), ' ', rpad(csv26,20), ' ', rpad(csv27,20), ' ', rpad(csv28,20), ' ', rpad(csv29,20), ' ', rpad(csv30,20)) as text
			from temp_csv where fid = v_fid and cur_user = current_user and source is null
		union
		select id, concat(rpad(csv1,21),rpad(coalesce(csv2,''),20),' ', rpad(coalesce(csv3,''),20),' ',rpad(coalesce(csv4,''),20),' ',rpad(coalesce(csv5,''),20),
			' ',rpad(coalesce(csv6,''),20),' ', rpad(coalesce(csv7,''),20),' ',rpad(coalesce(csv8,''),500))
			from temp_csv where fid  = v_fid and cur_user = current_user and source NOT IN ('header', 'options')
		union
		select id, concat(rpad(csv1,22), ' ', csv2)as text from temp_csv where fid  = v_fid and cur_user = current_user and source in ('header')
		union
		select id, concat(rpad(csv1,22), ' ', csv2)as text from temp_csv where fid  = v_fid and cur_user = current_user and source in ('options')
	
		order by id
		)a )row;
	-- Manage selectors
	
	-- Return
	RETURN ('{"status":"Accepted", "version":""'||
		 ',"body":{"file":'||v_return||'}}')::json;
		
END;
$BODY$;