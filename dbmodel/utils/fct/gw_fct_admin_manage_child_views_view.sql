/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2752

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_child_views_view(p_data json)
  RETURNS void AS
$BODY$

/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_admin_manage_child_views_view($${"schema":"'||v_schemaname ||'","body":{"viewname":"'||v_viewname||'",
"feature_type":"'||v_feature_type||'","feature_system_id":"'||v_feature_system_id||'","feature_cat":"'||v_cat_feature||'",
"feature_childtable_fields":"'||v_feature_childtable_fields||'","man_fields":"'||v_man_fields||'", "view_type":"'||v_view_type||'"}}$$);
*/

DECLARE

v_project_type text;
v_schemaname text = 'SCHEMA_NAME';
v_viewname text;
v_feature_type text;
v_feature_system_id text;
v_feature_cat text;
v_feature_childtable_name text;
v_feature_childtable_fields text;
v_man_fields text;
v_view_type integer;
v_tableversion text = 'sys_version';
v_columntype text = 'project_type';

BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- get info from version table
	IF (SELECT tablename FROM pg_tables WHERE schemaname = v_schemaname AND tablename = 'version') IS NOT NULL THEN v_tableversion = 'version'; v_columntype = 'wsoftware'; END IF;
 	EXECUTE 'SELECT '||quote_ident(v_columntype)||' FROM '||quote_ident(v_tableversion)||' LIMIT 1' INTO v_project_type;

    v_schemaname = (p_data ->> 'schema');
    v_viewname = ((p_data ->> 'body')::json->>'viewname')::text;
    v_feature_type = ((p_data ->> 'body')::json->>'feature_type')::text;
    v_feature_system_id = ((p_data ->> 'body')::json->>'feature_system_id')::text;
    v_feature_cat = ((p_data ->> 'body')::json->>'feature_cat')::text;
    v_feature_childtable_name = ((p_data ->> 'body')::json->>'feature_childtable_name')::text;
    v_feature_childtable_fields = ((p_data ->> 'body')::json->>'feature_childtable_fields')::text;
    v_man_fields = ((p_data ->> 'body')::json->>'man_fields')::text;
    v_view_type =((p_data ->> 'body')::json->>'view_type')::integer;

	IF v_view_type = 1 THEN
		--view for WS and UD features that only have feature_id in man table
		EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
			SELECT ve_'||v_feature_type||'.*
			FROM '||v_schemaname||'.ve_'||v_feature_type||'
			JOIN '||v_schemaname||'.man_'||v_feature_system_id||'
			ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = ve_'||v_feature_type||'.'||v_feature_type||'_id
			WHERE '||v_feature_type||'_type ='''||v_feature_cat||''' ;';

	ELSIF v_view_type = 2 THEN
		--view for ud connec y gully which dont have man_type table
		EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
			SELECT ve_'||v_feature_type||'.*
			FROM '||v_schemaname||'.ve_'||v_feature_type||'
			WHERE '||v_feature_type||'_type ='''||v_feature_cat||''' ;';

	ELSIF v_view_type = 3 THEN
		--view for WS and UD features that have many fields in man table
		EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
			SELECT ve_'||v_feature_type||'.*,
			'||v_man_fields||'
			FROM '||v_schemaname||'.ve_'||v_feature_type||'
			JOIN '||v_schemaname||'.man_'||v_feature_system_id||'
			ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = ve_'||v_feature_type||'.'||v_feature_type||'_id
			WHERE '||v_feature_type||'_type ='''||v_feature_cat||''' ;';

	ELSIF v_view_type = 4 THEN
		--view for WS and UD features that only have feature_id in man table and have defined addfields
        EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
            SELECT ve_'||v_feature_type||'.*,
            '||v_feature_childtable_fields||'
            FROM '||v_schemaname||'.ve_'||v_feature_type||'
            JOIN '||v_schemaname||'.man_'||v_feature_system_id||'
            ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = ve_'||v_feature_type||'.'||v_feature_type||'_id
            LEFT JOIN '||v_schemaname||'.'||v_feature_childtable_name||'
            ON '||v_feature_childtable_name||'.'||v_feature_type||'_id = ve_'||v_feature_type||'.'||v_feature_type||'_id
            WHERE '||v_feature_type||'_type ='''||v_feature_cat||''' ;';

	ELSIF v_view_type = 5 THEN
		--view for ud connec y gully which dont have man_type table and have defined addfields
		EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
            SELECT ve_'||v_feature_type||'.*,
            '||v_feature_childtable_fields||'
            FROM '||v_schemaname||'.ve_'||v_feature_type||'
            LEFT JOIN '||v_schemaname||'.'||v_feature_childtable_name||'
            ON '||v_feature_childtable_name||'.'||v_feature_type||'_id = ve_'||v_feature_type||'.'||v_feature_type||'_id
            WHERE '||v_feature_type||'_type ='''||v_feature_cat||''' ;';

	ELSIF v_view_type = 6 THEN
		--view for WS and UD features that have many fields in man table and have defined addfields
        EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
            SELECT ve_'||v_feature_type||'.*,
            '||v_man_fields||',
            '||v_feature_childtable_fields||'
            FROM '||v_schemaname||'.ve_'||v_feature_type||'
            JOIN '||v_schemaname||'.man_'||v_feature_system_id||'
            ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = ve_'||v_feature_type||'.'||v_feature_type||'_id
            LEFT JOIN '||v_schemaname||'.'||v_feature_childtable_name||'
            ON '||v_feature_childtable_name||'.'||v_feature_type||'_id = ve_'||v_feature_type||'.'||v_feature_type||'_id
            WHERE '||v_feature_type||'_type ='''||v_feature_cat||''' ;';
	END IF;
	
	RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
