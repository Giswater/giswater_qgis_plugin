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
select gw_fct_admin_manage_child_views_view($${
        "schema":"ws_36012_2",
        "body":{"viewname":"ve_node_adaptation",
          "feature_type":"node",
          "feature_system_id":"junction",
          "feature_cat":"ADAPTATION",
          "feature_childtable_name":"man_node_adaptation",
          "feature_childtable_fields":"null",
          "man_fields":"null",
          "view_type":"1"
          }
        }$$);
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
v_sql text;
v_node_fields text;

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

  -- list all columns from v_edit_node excluding 'broken_valve' and 'closed_valve' in order to take those from man_valve table
  EXECUTE 'select 
  replace(replace(array_agg(''v_edit_'||v_feature_type||'.'' || column_name)::text, ''{'', ''''), ''}'', '''') 
  from information_schema.columns
  where table_schema = '||quote_literal(v_schemaname)||' 
  and table_name = ''v_edit_node'' 
  and column_name not in (''closed_valve'', ''broken_valve'')'
  INTO v_node_fields;
   
  IF v_view_type = 1 THEN
    --view for WS and UD features that only have feature_id in man table
    IF v_feature_type = 'node' then
    
      EXECUTE '
      CREATE OR REPLACE VIEW '||v_viewname||' AS
      SELECT '||v_node_fields||'
      FROM v_edit_'||v_feature_type||'
      JOIN man_'||v_feature_system_id||' USING ('||v_feature_type||'_id)
      WHERE '||v_feature_type||'_type ='||quote_literal(v_feature_cat)||';';

    ELSE
      
      EXECUTE '
      CREATE OR REPLACE VIEW '||v_viewname||' AS
      SELECT *
      FROM v_edit_'||v_feature_type||'
      JOIN man_'||v_feature_system_id||' USING ('||v_feature_type||'_id)
      WHERE '||v_feature_type||'_type ='||quote_literal(v_feature_cat)||' ;';

    END IF;
     
  ELSIF v_view_type = 2 THEN
    --view for ud connec y gully which dont have man_type table
    EXECUTE '
    CREATE OR REPLACE VIEW '||v_viewname||' AS
    SELECT *
    FROM v_edit_'||v_feature_type||'
    WHERE '||v_feature_type||'_type ='||quote_literal(v_feature_cat)||' ;';

  ELSIF v_view_type = 3 THEN
    --view for WS and UD features that have many fields in man table
    IF v_feature_type = 'node' then

      EXECUTE '
      CREATE OR REPLACE VIEW '||v_viewname||' AS
      SELECT '||v_node_fields||',
      '||v_man_fields||'
      FROM v_edit_'||v_feature_type||'
      JOIN man_'||v_feature_system_id||' USING ('||v_feature_type||'_id)
      WHERE '||v_feature_type||'_type ='||quote_literal(v_feature_cat)||' ;';
    
    ELSE

      EXECUTE '
      CREATE OR REPLACE VIEW '||v_viewname||' AS
      SELECT v_edit_'||v_feature_type||'.*,
      '||v_man_fields||'
      FROM v_edit_'||v_feature_type||'
      JOIN man_'||v_feature_system_id||' USING ('||v_feature_type||'_id)
      WHERE '||v_feature_type||'_type ='||quote_literal(v_feature_cat)||' ;';

    END IF;
    
  ELSIF v_view_type = 4 THEN 
    --view for WS and UD features that only have feature_id in man table and have defined addfields
    IF v_feature_type = 'node' THEN

       EXECUTE '
       CREATE OR REPLACE VIEW '||v_viewname||' AS
       SELECT '||v_node_fields||',
       '||v_feature_childtable_fields||'
       FROM v_edit_'||v_feature_type||'
       JOIN man_'||v_feature_system_id||' USING ('||v_feature_type||'_id)
       LEFT JOIN '||v_feature_childtable_name||' USING ('||v_feature_type||'_id)
       WHERE '||v_feature_type||'_type ='||quote_literal(v_feature_cat)||' ;';
  
    ELSE
  
      EXECUTE '
      CREATE OR REPLACE VIEW '||v_viewname||' AS
      SELECT v_edit_'||v_feature_type||'.*,
      '||v_feature_childtable_fields||'
      FROM v_edit_'||v_feature_type||'
      JOIN man_'||v_feature_system_id||' USING ('||v_feature_type||'_id)
      LEFT JOIN '||v_feature_childtable_name||' USING ('||v_feature_type||'_id)
      WHERE '||v_feature_type||'_type ='||quote_literal(v_feature_cat)||' ;';
                 
    END IF;
    
  ELSIF v_view_type = 5 THEN
    --view for ud connec y gully which dont have man_type table and have defined addfields
    EXECUTE '
    CREATE OR REPLACE VIEW '||v_viewname||' AS
    SELECT v_edit_'||v_feature_type||'.*,
    '||v_feature_childtable_fields||',
    FROM v_edit_'||v_feature_type||'
    LEFT JOIN '||v_feature_childtable_name||' USING ('||v_feature_type||'_id)
    WHERE '||v_feature_type||'_type ='||quote_literal(v_feature_cat)||';';
    
  ELSIF v_view_type = 6 THEN
    --view for WS and UD features that have many fields in man table and have defined addfields
    IF v_feature_type = 'node' then 
      
      EXECUTE '
      CREATE OR REPLACE VIEW '||v_viewname||' AS
      SELECT '||v_node_fields||',
      '||v_man_fields||',
      '||v_feature_childtable_fields||'
      FROM v_edit_'||v_feature_type||'
      JOIN man_'||v_feature_system_id||' USING ('||v_feature_type||'_id)
      LEFT JOIN '||v_feature_childtable_name||' USING ('||v_feature_type||'_id)
      WHERE '||v_feature_type||'_type ='||quote_literal(v_feature_cat)||';';
    
    ELSE

      EXECUTE '
      CREATE OR REPLACE VIEW '||v_viewname||' AS
      SELECT v_edit_'||v_feature_type||'.*,
      '||v_man_fields||'
      '||v_feature_childtable_fields||'
      FROM v_edit_'||v_feature_type||'
      JOIN man_'||v_feature_system_id||' USING ('||v_feature_type||'_id)
      LEFT JOIN '||v_feature_childtable_name||' USING ('||v_feature_type||'_id)
      WHERE '||v_feature_type||'_type ='||quote_literal(v_feature_cat)||';';

    END IF;
     
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
