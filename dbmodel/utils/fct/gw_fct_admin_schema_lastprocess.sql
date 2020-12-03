/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2650

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_schema_lastprocess(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_admin_schema_lastprocess($${
"client":{"lang":"ES"}, 
"data":{"isNewProject":"TRUE", "gwVersion":"3.1.105", "projectType":"WS", "isSample":true, "epsg":"25831", "title":"test project", "author":"test", "date":"01/01/2000", "superUsers":["postgres", "giswater"]}}$$)

SELECT SCHEMA_NAME.gw_fct_admin_schema_lastprocess($${
"client":{"lang":"ES"},
"data":{"isNewProject":"FALSE", "gwVersion":"3.3.031", "projectType":"UD", "epsg":25831}}$$)

-- fid: 133

*/

DECLARE 

v_dbnname varchar;
v_projecttype text;
v_priority integer = 0;
v_message text;
v_version record;
v_gwversion text;
v_language text;
v_epsg integer;
v_isnew boolean;
v_descript text;
v_name text;
v_author text;
v_date text;
v_schema_info json;
v_superusers text;
v_tablename record;
v_schemaname text;
v_oldversion text;
v_issample boolean = FALSE;
v_sample_exist text = '';
	
BEGIN 
	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	-- get input parameters
	v_gwversion := (p_data ->> 'data')::json->> 'gwVersion';
	v_language := (p_data ->> 'client')::json->> 'lang';
	v_projecttype := (p_data ->> 'data')::json->> 'projectType';
	v_epsg := (p_data ->> 'data')::json->> 'epsg';
	v_isnew := (p_data ->> 'data')::json->> 'isNewProject';
	v_issample := (p_data ->> 'data')::json->> 'isSample';
	v_descript := (p_data ->> 'data')::json->> 'descript';
    v_name := (p_data ->> 'data')::json->> 'name';
	v_author := (p_data ->> 'data')::json->> 'author';
	v_date := (p_data ->> 'data')::json->> 'date';
	v_superusers := (p_data ->> 'data')::json->> 'superUsers';
	
	-- enable triggers on typevalue tables
	ALTER TABLE om_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;
	ALTER TABLE edit_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;
	ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;
	ALTER TABLE plan_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;
	ALTER TABLE sys_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;
	ALTER TABLE config_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;
	
	-- create triggers for the oposite tables againts typevalues
	PERFORM gw_fct_admin_manage_triggers('fk','ALL');
	
	-- create notifications triggers
	PERFORM gw_fct_admin_manage_triggers('notify',null);
	
	-- update cat feature triggering default values and others
	UPDATE cat_feature SET id=id;
	
	-- last proccess
	IF v_isnew IS TRUE THEN
			
		INSERT INTO config_param_system (parameter, value, datatype, descript, project_type, label)
		VALUES ('admin_superusers', v_superusers ,'json', 'Basic information about superusers for this schema','utils', 'Schema manager:')
		ON CONFLICT (parameter) DO NOTHING;
			
		-- inserting version table
		INSERT INTO sys_version (giswater, project_type, postgres, postgis, language, epsg, sample) VALUES (v_gwversion, upper(v_projecttype), (select version()),
		(select postgis_version()), v_language, v_epsg, v_issample);
		
		v_message='Project sucessfully created';
		
		-- create json info_schema
		v_descript := COALESCE(v_descript, '');
        v_name := COALESCE(v_name, '');
		v_author := COALESCE(v_author, '');
		v_date := COALESCE(v_date, '');

		v_schema_info = '{"name":"'||v_name||'","descript":"'||v_descript||'","author":"'||v_author||'","date":"'||v_date||'"}';
		
		-- drop deprecated tables
		FOR v_tablename IN SELECT table_name FROM information_schema.tables WHERE table_schema=v_schemaname and substring(table_name,1 , 1) = '_' 
		LOOP
			EXECUTE 'DROP TABLE IF EXISTS '||v_tablename.table_name||' CASCADE';
		END LOOP;
		
		-- drop deprecated views
		IF v_projecttype = 'WS' THEN 
			DROP VIEW IF EXISTS v_edit_man_varc;
			DROP VIEW IF EXISTS v_edit_man_pipe;
			DROP VIEW IF EXISTS v_edit_man_expansiontank;
			DROP VIEW IF EXISTS v_edit_man_filter;
			DROP VIEW IF EXISTS v_edit_man_flexunion;
			DROP VIEW IF EXISTS v_edit_man_hydrant;
			DROP VIEW IF EXISTS v_edit_man_junction;
			DROP VIEW IF EXISTS v_edit_man_meter;
			DROP VIEW IF EXISTS v_edit_man_netelement;
			DROP VIEW IF EXISTS v_edit_man_netsamplepoint;
			DROP VIEW IF EXISTS v_edit_man_netwjoin;
			DROP VIEW IF EXISTS v_edit_man_pump;
			DROP VIEW IF EXISTS v_edit_man_reduction;
			DROP VIEW IF EXISTS v_edit_man_register;
			DROP VIEW IF EXISTS v_edit_man_source;
			DROP VIEW IF EXISTS v_edit_man_tank;
			DROP VIEW IF EXISTS v_edit_man_valve;
			DROP VIEW IF EXISTS v_edit_man_waterwell;
			DROP VIEW IF EXISTS v_edit_man_manhole;
			DROP VIEW IF EXISTS v_edit_man_wtp;
			DROP VIEW IF EXISTS v_edit_man_fountain;
			DROP VIEW IF EXISTS v_edit_man_tap;
			DROP VIEW IF EXISTS v_edit_man_greentap;
			DROP VIEW IF EXISTS v_edit_man_wjoin;
			DROP VIEW IF EXISTS v_edit_man_fountain_pol;
			DROP VIEW IF EXISTS v_edit_man_register_pol;
			DROP VIEW IF EXISTS v_edit_man_tank_pol;
			DROP VIEW IF EXISTS v_anl_mincut_planified_arc;	
			DROP VIEW IF EXISTS v_anl_mincut_planified_valve;
			DROP VIEW IF EXISTS v_anl_mincut_result_arc;
			DROP VIEW IF EXISTS v_anl_mincut_result_audit;			
			DROP VIEW IF EXISTS v_anl_mincut_result_conflict_arc;
			DROP VIEW IF EXISTS v_anl_mincut_result_conflict_valve;
			DROP VIEW IF EXISTS v_anl_mincut_result_connec;
			DROP VIEW IF EXISTS v_anl_mincut_result_hydrometer;
			DROP VIEW IF EXISTS v_anl_mincut_result_node;
			DROP VIEW IF EXISTS v_anl_mincut_result_polygon;
			DROP VIEW IF EXISTS v_anl_mincut_result_valve;
			
		
		ELSIF v_projecttype = 'UD' THEN
		
			DROP VIEW IF EXISTS v_edit_man_chamber;
			DROP VIEW IF EXISTS v_edit_man_chamber_pol;
			DROP VIEW IF EXISTS v_edit_man_conduit;
			DROP VIEW IF EXISTS v_edit_man_connec;
			DROP VIEW IF EXISTS v_edit_man_gully;
			DROP VIEW IF EXISTS v_edit_man_gully_pol;
			DROP VIEW IF EXISTS v_edit_man_junction;
			DROP VIEW IF EXISTS v_edit_man_manhole;
			DROP VIEW IF EXISTS v_edit_man_netgully;
			DROP VIEW IF EXISTS v_edit_man_netgully_pol;
			DROP VIEW IF EXISTS v_edit_man_netinit;
			DROP VIEW IF EXISTS v_edit_man_outfall;
			DROP VIEW IF EXISTS v_edit_man_siphon;
			DROP VIEW IF EXISTS v_edit_man_storage;
			DROP VIEW IF EXISTS v_edit_man_storage_pol;
			DROP VIEW IF EXISTS v_edit_man_valve;
			DROP VIEW IF EXISTS v_edit_man_varc;
			DROP VIEW IF EXISTS v_edit_man_waccel;
			DROP VIEW IF EXISTS v_edit_man_wjump;
			DROP VIEW IF EXISTS v_edit_man_wwtp;
			DROP VIEW IF EXISTS v_edit_man_wwtp_pol;
		
		END IF;
		
		-- drop deprecated columns
		IF v_projecttype = 'WS' THEN 
			ALTER TABLE inp_pattern_value DROP COLUMN if exists _factor_19;
			ALTER TABLE inp_pattern_value DROP COLUMN if exists _factor_20;
			ALTER TABLE inp_pattern_value DROP COLUMN if exists _factor_21;
			ALTER TABLE inp_pattern_value DROP COLUMN if exists _factor_22;
			ALTER TABLE inp_pattern_value DROP COLUMN if exists _factor_23;
			ALTER TABLE inp_pattern_value DROP COLUMN if exists _factor_24;	
			ALTER TABLE config_mincut_inlet DROP COLUMN if exists _to_arc;	
			
		END IF;

		ALTER TABLE sys_addfields DROP COLUMN if exists _default_value_;
		ALTER TABLE sys_addfields DROP COLUMN if exists _form_label_;
		ALTER TABLE sys_addfields DROP COLUMN if exists _widgettype_id_;
		ALTER TABLE sys_addfields DROP COLUMN if exists _dv_table_;
		ALTER TABLE sys_addfields DROP COLUMN if exists _dv_key_column_;
		ALTER TABLE sys_addfields DROP COLUMN if exists _sql_text_;
		
		-- inserting on config_param_system table
		INSERT INTO config_param_system (parameter, value, datatype, descript, project_type, label)
		VALUES ('admin_schema_info', v_schema_info,'json', 'Basic information about schema','utils', 'Schema manager:') ON CONFLICT (parameter) DO NOTHING;

		-- fk from utils schema
		IF (SELECT value FROM config_param_system WHERE parameter='admin_utils_schema') IS NOT NULL THEN
			PERFORM gw_fct_admin_schema_utils_fk();  -- this is the position to use it because we need values on version table to work with
		END IF;
		
		-- generate child views 
		PERFORM gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
		"data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-DELETE" }}$$);
		
		PERFORM  gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
		"data":{"filterFields":{}, "pageInfo":{}, "multi_create":true}}$$)::text;
		
		--change widgettype for matcat_id when new empty data project (UD)
		IF v_projecttype = 'UD' THEN 
			UPDATE config_form_fields SET iseditable=TRUE, widgettype='combo', dv_isnullvalue=TRUE, dv_querytext='SELECT id, id AS idval FROM cat_mat_node' 
			WHERE columnname='matcat_id' AND formname LIKE 've_node%';

			UPDATE config_form_fields SET iseditable=TRUE, widgettype='combo', dv_isnullvalue=TRUE, dv_querytext='SELECT id, id AS idval FROM cat_mat_arc' 
			WHERE columnname='matcat_id' AND formname LIKE 've_connec%';

			UPDATE config_form_fields SET iseditable=TRUE, widgettype='combo', dv_isnullvalue=TRUE, dv_querytext='SELECT id, id AS idval FROM cat_mat_arc' 
			WHERE columnname='matcat_id' AND formname LIKE 've_arc%';
		END IF;
		
	ELSIF v_isnew IS FALSE THEN
		
		v_oldversion = (SELECT giswater FROM sys_version ORDER BY id DESC LIMIT 1);
        

		-- create child views for users from 3.2 to 3.3 updates
		IF v_oldversion < '3.3.000' AND v_gwversion > '3.3.000' THEN
			PERFORM gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "multi_create":true}}$$)::text;
		END IF;
	
		-- check project consistency
		IF v_projecttype = 'WS' THEN
			
		ELSIF v_projecttype = 'UD' THEN

		END IF;
		-- inserting version table
		SELECT * INTO v_version FROM sys_version LIMIT 1;
		INSERT INTO sys_version (giswater, project_type, postgres, postgis, language, epsg, sample)
		VALUES (v_gwversion, v_version.project_type, (select version()), (select postgis_version()), v_version.language, v_version.epsg, v_version.sample);

		-- get return message
		IF v_priority=0 THEN
			v_message='Project sucessfully updated';
		ELSIF v_priority=1 THEN
			v_message=concat($$'Project updated but there are some warnings. Take a look on audit_log_project table: SELECT (log_message::json->>'message') 
			FROM audit_log_project WHERE fid = 133 and (log_message::json->>'version')='$$, v_gwversion, '''');
		ELSIF v_priority=2 THEN
			v_message='Project is not updated. There are one or more errors';
		END IF;
		
	END IF;
	
	UPDATE config_param_system SET value = v_gwversion WHERE parameter = 'admin_version';
	
	-- update permissions	
	PERFORM gw_fct_admin_role_permissions();


	--    Control NULL's
	v_message := COALESCE(v_message, '');
	
	-- Return
	RETURN ('{"message":{"level":"'||v_priority||'", "text":"'||v_message||'"}}');	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
