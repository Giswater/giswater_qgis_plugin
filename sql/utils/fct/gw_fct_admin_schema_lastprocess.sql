-- Function: aa1.gw_fct_admin_schema_lastprocess(json)

-- DROP FUNCTION aa1.gw_fct_admin_schema_lastprocess(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_schema_lastprocess(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_admin_schema_lastprocess($${
"client":{"lang":"ES"}, 
"data":{"isNewProject":"TRUE", "gwVersion":"3.1.105", "projectType":"WS", 
		"epsg":"25831", "title":"test project", "author":"test", "date":"01/01/2000"}}$$)

SELECT SCHEMA_NAME.gw_fct_admin_schema_lastprocess($${
"client":{"lang":"ES"},
"data":{"isNewProject":"FALSE", "gwVersion":"3.1.105", "projectType":"WS", "epsg":25831}}$$)
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
	v_title text;
	v_author text;
	v_date text;

BEGIN 
	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- get input parameters
	v_gwversion := (p_data ->> 'data')::json->> 'gwVersion';
	v_language := (p_data ->> 'client')::json->> 'lang';
	v_projecttype := (p_data ->> 'data')::json->> 'projectType';
	v_epsg := (p_data ->> 'data')::json->> 'epsg';
	v_isnew := (p_data ->> 'data')::json->> 'isNewProject';
	v_title := (p_data ->> 'data')::json->> 'title';
	v_author := (p_data ->> 'data')::json->> 'author';
	v_date := (p_data ->> 'data')::json->> 'date';


	-- last proccess
	IF v_isnew IS TRUE THEN
	
		-- clean schema of all tables/views/triggers not used in this version
		IF v_gwversion > '3.2' THEN
			PERFORM gw_fct_admin_schema_dropdeprecated_rel();	
		END IF;	

		-- inserting version table
		INSERT INTO version (giswater, wsoftware, postgres, postgis, language, epsg) VALUES (v_gwversion, upper(v_projecttype), (select version()),(select postgis_version()), v_language, v_epsg);	
		v_message='Project sucessfully created';
		
		-- inserting on inp_project table
		INSERT INTO inp_project_id VALUES (v_title, v_author, v_date);
		
		-- fk from utils schema
		PERFORM gw_fct_admin_schema_utils_fk();  -- this is the posiition to use it because of we need values on version table to workwith
		
	ELSIF v_isnew IS FALSE THEN
		-- check project consistency
		IF v_projecttype = 'WS' THEN
	
			-- look for inp_pattern_value bug (+18 values are not possible)
			IF 	(SELECT id FROM SCHEMA_NAME.inp_pattern_value where 
				(factor_19 is not null or factor_20 is not null or factor_21 is not null or factor_22 is not null or factor_23 is not null or factor_24 is not null) LIMIT 1) THEN
					INSERT INTO audit_log_project (fprocesscat_id, table_id, log_message) 
					VALUES (33, 'inp_pattern_value', '{"version":"'||v_gwversion||'", "message":"There are some values on columns form 19 to 24. It must be deleted because it causes a bug on EPANET"}');
					v_priority=1;
			END IF;
			
		ELSIF v_projecttype = 'UD' THEN

		END IF;
		-- inserting version table
		SELECT * INTO v_version FROM version LIMIT 1;	
		INSERT INTO version (giswater, wsoftware, postgres, postgis, language, epsg) 
		VALUES (v_gwversion, v_version.wsoftware, (select version()), (select postgis_version()), v_version.language, v_version.epsg);

		-- get return message
		IF v_priority=0 THEN
			v_message='Project sucessfully updated';
		ELSIF v_priority=1 THEN
			v_message=concat($$'Project updated but there are some warnings. Take a look on audit_log_project table: SELECT (log_message::json->>'message') FROM audit_log_project WHERE fprocesscat_id=33 and (log_message::json->>'version')='$$, v_gwversion, '''');
		ELSIF v_priority=2 THEN
			v_message='Project is not updated. There are one or more errors';
		END IF;
		
	END IF;
	
	-- update permissions	
	PERFORM gw_fct_admin_role_permissions();


	--    Control NULL's
	v_message := COALESCE(v_message, '');
	
	-- Return
	RETURN ('{"message":{"priority":"'||v_priority||'", "text":"'||v_message||'"}}');	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_fct_admin_schema_lastprocess(json)
  OWNER TO postgres;
