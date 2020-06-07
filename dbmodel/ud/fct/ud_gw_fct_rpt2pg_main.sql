/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2726

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_rpt2pg_main(character varying );
DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_rpt2pg(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_rpt2pg_main(p_data json)  
RETURNS json AS $BODY$

/*EXAMPLE
SELECT gw_fct_rpt2pg_main('{"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "iterative":"disabled", "resultId":"a0", "file":[{"source": "null", "csv40": "null", "csv1":"Page", "csv2":"1", "csv3":"Tue", "csv4":"Jun", "csv5":"02", "csv6":"22:20:38", "csv7":"2020"}, {"source": "null", "csv40": "null", "csv1":"*", "csv2":"E", "csv3":"P", "csv4":"A", "csv5":"N", "csv6":"E", "csv7":"T", "csv8":"*"}, {"source": "null", "csv40": "null", "csv1":"*", "csv2":"Hydraulic", "csv3":"and", "csv4":"Water", "csv5":"Quality", "csv6":"*"}, {"source": "null", "csv40": "null", "csv1":"*", "csv2":"Analysis", "csv3":"for", "csv4":"Pipe", "csv5":"Networks", "csv6":"*"}, {"source": "null", "csv40": "null", "csv1":"*", "csv2":"Version", "csv3":"*"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Input", "csv2":"Data", "csv3":"File", "csv4":"...................", "csv5":"C:/Temp/a20.inp"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Number", "csv2":"of", "csv3":"Junctions................", "csv4":"232"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Number", "csv2":"of", "csv3":"Reservoirs...............", "csv4":"5"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Number", "csv2":"of", "csv3":"Tanks", "csv4":"...................", "csv5":"0"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Number", "csv2":"of", "csv3":"Pipes", "csv4":"...................", "csv5":"261"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Number", "csv2":"of", "csv3":"Pumps", "csv4":"...................", "csv5":"3"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Number", "csv2":"of", "csv3":"Valves", "csv4":"..................", "csv5":"2"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Headloss", "csv2":"Formula", "csv3":"..................", "csv4":"Darcy-Weisbach"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Hydraulic", "csv2":"Timestep", "csv3":"................", "csv4":"0.50", "csv5":"hrs"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Hydraulic", "csv2":"Accuracy", "csv3":"................", "csv4":"0.001000"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Status", "csv2":"Check", "csv3":"Frequency", "csv4":"............", "csv5":"2"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Maximum", "csv2":"Trials", "csv3":"Checked", "csv4":"............", "csv5":"10"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Damping", "csv2":"Limit", "csv3":"Threshold", "csv4":"...........", "csv5":"0.000000"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Maximum", "csv2":"Trials", "csv3":"....................", "csv4":"40"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Quality", "csv2":"Analysis", "csv3":"..................", "csv4":"None"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Specific", "csv2":"Gravity", "csv3":"..................", "csv4":"1.00"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Relative", "csv2":"Kinematic", "csv3":"Viscosity", "csv4":"......", "csv5":"1.00"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Relative", "csv2":"Chemical", "csv3":"Diffusivity", "csv4":".....", "csv5":"1.00"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Demand", "csv2":"Multiplier", "csv3":".................", "csv4":"1.00"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Total", "csv2":"Duration", "csv3":"....................", "csv4":"20.00", "csv5":"hrs"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Reporting", "csv2":"Criteria:"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"All", "csv2":"Nodes"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"All", "csv2":"Links"}, {"source": "rpt_cat_result", "csv40": "null", "csv1":"Analysis", "csv2":"begun", "csv3":"Tue", "csv4":"Jun", "csv5":"02", "csv6":"22:20:38", "csv7":"2020"}, {"source": "rpt_hydraulic_status", "csv40": "null", "csv1":"Hydraulic", "csv2":"Status:"}, {"source": "rpt_hydraulic_status", "csv40": "null", "csv1":"0:00:00:", "csv2":"Balanced", "csv3":"after", "csv4":"10", "csv5":"trials"}, {"source": "rpt_hydraulic_status", "csv40": "null", "csv1":"0:00:00:", "csv2":"Reservoir", "csv3":"113766", "csv4":"is", "csv5":"filling"}, {"source": "rpt_hydraulic_status", "csv40": "null", "csv1":"0:00:00:", "csv2":"Reservoir", "csv3":"113952", "csv4":"is", "csv5":"filling"}, {"source": "rpt_hydraulic_status", "csv40": "null", "csv1":"0:00:00:", "csv2":"Reservoir", "csv3":"1101", "csv4":"is", "csv5":"closed"}, {"source": "rpt_hydraulic_status", "csv40": "null", "csv1":"0:00:00:", "csv2":"Reservoir", "csv3":"1097", "csv4":"is", "csv5":"emptying"}, {"source": "rpt_hydraulic_status", "csv40": "null", "csv1":"0:00:00:", "csv2":"Reservoir", "csv3":"111111", "csv4":"is", "csv5":"emptying"}, {"source": "rpt_hydraulic_status", "csv40": "null", "csv1":"0:30:00:", "csv2":"Balanced", "csv3":"after", "csv4":"1", "csv5":"trials"}, {"source": "rpt_hydraulic_status", "csv40": "null", "csv1":"1:00:00:", "csv2":"Balanced", "csv3":"after", "csv4":"1", "csv5":"trials"}, {"source": "rpt_hydraulic_status", "csv40": "null", "csv1":"1:30:00:", "csv2":"Balanced", "csv3":"after", "csv4":"1", "csv5":"trials"}, {"source": "rpt_hydraulic_status", "csv40": "null", "csv1":"2:00:00:", "csv2":"Balanced", "csv3":"after", "csv4":"1", "csv5":"trials"}, {"source": "rpt_hydraulic_status", "csv40": "null", "csv1":"2:30:00:", "csv2":"Balanced", "csv3":"after", "csv4":"1", "csv5":"trials"}, {"source": "rpt_hydraulic_status", "csv40": "null", "csv1":"3:00:00:", "csv2":"Balanced", "csv3":"after", "csv4":"1", "csv5":"trials"}, {"source": "rpt_hydraulic_status", "csv40": "null", "csv1":"3:30:00:", "csv2":"Balanced", "csv3":"after", "csv4":"1", "csv5":"trials"}, {"source": "rpt_hydraulic_status", "csv40": "null", "csv1":"4:00:00:", "csv2":"Balanced", "csv3":"after", "csv4":"1", "csv5":"trials"}]}}'::json);
*/

DECLARE
rec_table record;

v_result text;
v_val integer;
v_file json;
  
BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get parameters
	v_result  = (p_data ->>'data')::json->>'resultId';
	v_file  = (p_data ->>'data')::json->>'file';

	RAISE NOTICE 'Starting rpt2pg process.';
	
	DELETE FROM temp_csv WHERE fid = 140 AND cur_user = current_user;

	-- inserting file into temp table
	INSERT INTO temp_csv (fid, cur_user, source, csv1, csv2, csv3, csv4, csv5, csv6, csv7, csv8, csv9, csv10, csv11, csv12, csv13, csv14, csv15, csv16, csv17, csv18, csv19, csv20)
	SELECT 140 , current_user, a::json->>'source', a::json->>'csv1', a::json->>'csv2',a::json->>'csv3',a::json->>'csv4',a::json->>'csv5',a::json->>'csv6',a::json->>'csv7',a::json->>'csv8',
	a::json->>'csv9',a::json->>'csv10',	a::json->>'csv11',a::json->>'csv12',a::json->>'csv13',a::json->>'csv14',a::json->>'csv15',a::json->>'csv16',a::json->>'csv17',a::json->>'csv18'
	,a::json->>'csv19',a::json->>'csv20'
	FROM json_array_elements(v_file) AS a;

	-- call import epa function
	PERFORM gw_fct_rpt2pg_import_rpt(p_data);
	
	-- Reset sequences of rpt_* tables
	--FOR rec_table IN SELECT * FROM sys_table WHERE sys_sequence IS NOT NULL
	--LOOP
		-- EXECUTE 'SELECT max(id) FROM '||quote_ident(rec_table.id) INTO v_val;
		-- EXECUTE 'SELECT setval(SCHEMA_NAME.'||rec_table.sys_sequence||', '||v_val||', true);';
	--END LOOP;
		
	-- set result on result selector: In spite of there are two selectors tables () only it's setted one
	DELETE FROM selector_rpt_main WHERE cur_user=current_user;
	INSERT INTO selector_rpt_main (result_id, cur_user) VALUES (v_result, current_user);

	-- create log
	RETURN gw_fct_rpt2pg_log (v_result);
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;