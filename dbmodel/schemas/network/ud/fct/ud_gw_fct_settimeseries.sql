/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3234
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_settimeseries(v_timser character varying)
 RETURNS json
AS $BODY$

/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_settimeseries('P2009_E06');

select * from inp_timeseries
select * from raingage
select * from config_param_user where (parameter like 'inp_options_start%' or parameter like 'inp_options_end%') and cur_user = current_user;

*/

DECLARE 

v_project_type text;
v_timeseries record;

v_return_level integer=1;
v_return_status text='Accepted';
v_return_msg text;
v_error_context text;
v_version text;
v_querytext text;

BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- get project type
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- set start-end date-times for options 
	select * into v_timeseries from inp_timeseries it where id = v_timser;

	-- update raingage
	update raingage set timser_id = v_timser, form_type = json_extract_path_text(v_timeseries.addparam,'type') ;

	-- set active only form current timeseries
	update inp_timeseries set active = false;
	update inp_timeseries set active = true where id=v_timser;

	-- disable setallraingages
	update config_param_user set value = null 
	where cur_user = current_user and parameter = 'inp_options_setallraingages';

	update config_param_user set value = json_extract_path_text(v_timeseries.addparam,'start_date') 
	where cur_user = current_user and parameter = 'inp_options_start_date';
	update config_param_user set value = json_extract_path_text(v_timeseries.addparam,'start_time')
	where cur_user = current_user and parameter = 'inp_options_start_time';
	update config_param_user set value = json_extract_path_text(v_timeseries.addparam,'end_date')
	where cur_user = current_user and parameter = 'inp_options_end_date';
	update config_param_user set value = json_extract_path_text(v_timeseries.addparam,'end_time')
	where cur_user = current_user and parameter = 'inp_options_end_time';
	update config_param_user set value = json_extract_path_text(v_timeseries.addparam,'start_date')
	where cur_user = current_user and parameter = 'inp_options_report_start_date';
	update config_param_user set value = json_extract_path_text(v_timeseries.addparam,'start_time')
	where cur_user = current_user and parameter = 'inp_options_report_start_time';

	-- Control nulls
	v_version := COALESCE(v_version, ''); 

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"'||v_return_status||'", "message":{"level":'||v_return_level||', "text":"'||v_return_msg||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{}'||
	    '}}')::json, 3192, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

