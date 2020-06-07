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
SELECT gw_fct_rpt2pg_main('{"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "iterative":"disabled", "resultId":"a0", "file":[{"target": "null", "col40": "null", "col1":"Page", "col2":"1", "col3":"Tue", "col4":"Jun", "col5":"02", "col6":"22:20:38", "col7":"2020"}, {"source": "null", "col40": "null", "col1":"*", "col2":"E", "col3":"P", "col4":"A", "col5":"N", "col6":"E", "col7":"T", "col8":"*"}, {"source": "null", "col40": "null", "col1":"*", "col2":"Hydraulic", "col3":"and", "col4":"Water", "col5":"Quality", "col6":"*"}, {"source": "null", "col40": "null", "col1":"*", "col2":"Analysis", "col3":"for", "col4":"Pipe", "col5":"Networks", "col6":"*"}, {"source": "null", "col40": "null", "col1":"*", "col2":"Version", "col3":"*"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Input", "col2":"Data", "col3":"File", "col4":"...................", "col5":"C:/Temp/a20.inp"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Number", "col2":"of", "col3":"Junctions................", "col4":"232"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Number", "col2":"of", "col3":"Reservoirs...............", "col4":"5"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Number", "col2":"of", "col3":"Tanks", "col4":"...................", "col5":"0"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Number", "col2":"of", "col3":"Pipes", "col4":"...................", "col5":"261"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Number", "col2":"of", "col3":"Pumps", "col4":"...................", "col5":"3"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Number", "col2":"of", "col3":"Valves", "col4":"..................", "col5":"2"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Headloss", "col2":"Formula", "col3":"..................", "col4":"Darcy-Weisbach"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Hydraulic", "col2":"Timestep", "col3":"................", "col4":"0.50", "col5":"hrs"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Hydraulic", "col2":"Accuracy", "col3":"................", "col4":"0.001000"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Status", "col2":"Check", "col3":"Frequency", "col4":"............", "col5":"2"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Maximum", "col2":"Trials", "col3":"Checked", "col4":"............", "col5":"10"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Damping", "col2":"Limit", "col3":"Threshold", "col4":"...........", "col5":"0.000000"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Maximum", "col2":"Trials", "col3":"....................", "col4":"40"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Quality", "col2":"Analysis", "col3":"..................", "col4":"None"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Specific", "col2":"Gravity", "col3":"..................", "col4":"1.00"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Relative", "col2":"Kinematic", "col3":"Viscosity", "col4":"......", "col5":"1.00"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Relative", "col2":"Chemical", "col3":"Diffusivity", "col4":".....", "col5":"1.00"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Demand", "col2":"Multiplier", "col3":".................", "col4":"1.00"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Total", "col2":"Duration", "col3":"....................", "col4":"20.00", "col5":"hrs"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Reporting", "col2":"Criteria:"}, {"source": "rpt_cat_result", "col40": "null", "col1":"All", "col2":"Nodes"}, {"source": "rpt_cat_result", "col40": "null", "col1":"All", "col2":"Links"}, {"source": "rpt_cat_result", "col40": "null", "col1":"Analysis", "col2":"begun", "col3":"Tue", "col4":"Jun", "col5":"02", "col6":"22:20:38", "col7":"2020"}, {"source": "rpt_hydraulic_status", "col40": "null", "col1":"Hydraulic", "col2":"Status:"}, {"source": "rpt_hydraulic_status", "col40": "null", "col1":"0:00:00:", "col2":"Balanced", "col3":"after", "col4":"10", "col5":"trials"}, {"source": "rpt_hydraulic_status", "col40": "null", "col1":"0:00:00:", "col2":"Reservoir", "col3":"113766", "col4":"is", "col5":"filling"}, {"source": "rpt_hydraulic_status", "col40": "null", "col1":"0:00:00:", "col2":"Reservoir", "col3":"113952", "col4":"is", "col5":"filling"}, {"source": "rpt_hydraulic_status", "col40": "null", "col1":"0:00:00:", "col2":"Reservoir", "col3":"1101", "col4":"is", "col5":"closed"}, {"source": "rpt_hydraulic_status", "col40": "null", "col1":"0:00:00:", "col2":"Reservoir", "col3":"1097", "col4":"is", "col5":"emptying"}, {"source": "rpt_hydraulic_status", "col40": "null", "col1":"0:00:00:", "col2":"Reservoir", "col3":"111111", "col4":"is", "col5":"emptying"}, {"source": "rpt_hydraulic_status", "col40": "null", "col1":"0:30:00:", "col2":"Balanced", "col3":"after", "col4":"1", "col5":"trials"}, {"source": "rpt_hydraulic_status", "col40": "null", "col1":"1:00:00:", "col2":"Balanced", "col3":"after", "col4":"1", "col5":"trials"}, {"source": "rpt_hydraulic_status", "col40": "null", "col1":"1:30:00:", "col2":"Balanced", "col3":"after", "col4":"1", "col5":"trials"}, {"source": "rpt_hydraulic_status", "col40": "null", "col1":"2:00:00:", "col2":"Balanced", "col3":"after", "col4":"1", "col5":"trials"}, {"source": "rpt_hydraulic_status", "col40": "null", "col1":"2:30:00:", "col2":"Balanced", "col3":"after", "col4":"1", "col5":"trials"}, {"source": "rpt_hydraulic_status", "col40": "null", "col1":"3:00:00:", "col2":"Balanced", "col3":"after", "col4":"1", "col5":"trials"}, {"source": "rpt_hydraulic_status", "col40": "null", "col1":"3:30:00:", "col2":"Balanced", "col3":"after", "col4":"1", "col5":"trials"}, {"source": "rpt_hydraulic_status", "col40": "null", "col1":"4:00:00:", "col2":"Balanced", "col3":"after", "col4":"1", "col5":"trials"}]}}'::json);
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
	
	DELETE FROM temp_col WHERE fid = 140 AND cur_user = current_user;

	-- inserting file into temp table
	INSERT INTO temp_col (fid, cur_user, source, col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, col18, col19, col20)
	SELECT 140 , current_user, a::json->>'target', a::json->>'col1', a::json->>'col2',a::json->>'col3',a::json->>'col4',a::json->>'col5',a::json->>'col6',a::json->>'col7',a::json->>'col8',
	a::json->>'col9',a::json->>'col10',	a::json->>'col11',a::json->>'col12',a::json->>'col13',a::json->>'col14',a::json->>'col15',a::json->>'col16',a::json->>'col17',a::json->>'col18'
	,a::json->>'col19',a::json->>'col20'
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