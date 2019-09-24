/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2716
--DROP FUNCTION SCHEMA_NAME.gw_fct_admin_manage_child_views_view(json);


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_child_views_view(p_data json)
  RETURNS void AS
$BODY$


/*EXAMPLE

 SELECT SCHEMA_NAME.gw_fct_admin_manage_child_views_view 
				('ws', 'aaa_ve_acom', 'connec', 'wjoin', 'man_wjoin.top_floor, man_wjoin.cat_valve', 
				'ACOMETIDA',3,null, null, null, null);

*/

DECLARE 

	v_project_type text;
	v_schemaname text;
	v_viewname text;
	v_feature_type text;
	v_feature_system_id text;
	v_feature_cat text;
	v_man_fields text;
	v_a_param text;
	v_ct_param text;
	v_id_param text;
	v_datatype text;
	v_view_type integer;

BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;

	SELECT wsoftware INTO v_project_type FROM version LIMIT 1;

	v_schemaname = (p_data ->> 'schema');
	v_viewname = ((p_data ->> 'body')::json->>'viewname')::text;
	v_feature_type = ((p_data ->> 'body')::json->>'feature_type')::text;
	v_feature_system_id = ((p_data ->> 'body')::json->>'feature_system_id')::text;
	v_feature_cat = ((p_data ->> 'body')::json->>'featurecat')::text;
	v_man_fields = ((p_data ->> 'body')::json->>'man_fields')::text;
	v_a_param = ((p_data ->> 'body')::json->>'a_param')::text;
	v_ct_param = ((p_data ->> 'body')::json->>'ct_param')::text;
	v_id_param = ((p_data ->> 'body')::json->>'id_param')::text;
	v_datatype = ((p_data ->> 'body')::json->>'datatype')::text;
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
			'||v_a_param||'
			FROM '||v_schemaname||'.ve_'||v_feature_type||'
			JOIN '||v_schemaname||'.man_'||v_feature_system_id||' ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = ve_'||v_feature_type||'.'||v_feature_type||'_id
			LEFT JOIN (SELECT ct.feature_id, '||v_ct_param||' FROM crosstab (''SELECT feature_id, parameter_id, value_param
			FROM '||v_schemaname||'.man_addfields_value JOIN '||v_schemaname||'.man_addfields_parameter ON man_addfields_parameter.id=parameter_id
			WHERE cat_feature_id='''''||v_feature_cat||''''' OR cat_feature_id is null  ORDER BY 1,2''::text, 
			''VALUES '||v_id_param||'''::text) ct(feature_id character varying,'||v_datatype||' )) a 
			ON a.feature_id::text=ve_'||v_feature_type||'.'||v_feature_type||'_id 
			WHERE '||v_feature_type||'_type ='''||v_feature_cat||''' ;';

	ELSIF v_view_type = 5 THEN
		--view for ud connec y gully which dont have man_type table and have defined addfields
		EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
			SELECT ve_'||v_feature_type||'.*,
			'||v_a_param||'
			FROM '||v_schemaname||'.ve_'||v_feature_type||'
			LEFT JOIN (SELECT ct.feature_id, '||v_ct_param||' FROM crosstab (''SELECT feature_id, parameter_id, value_param
			FROM '||v_schemaname||'.man_addfields_value JOIN '||v_schemaname||'.man_addfields_parameter ON man_addfields_parameter.id=parameter_id
			WHERE cat_feature_id='''''||v_feature_cat||''''' OR cat_feature_id is null ORDER BY 1,2''::text, 
			''VALUES '||v_id_param||'''::text) ct(feature_id character varying,'||v_datatype||' )) a 
			ON a.feature_id::text=ve_'||v_feature_type||'.'||v_feature_type||'_id 
			WHERE '||v_feature_type||'_type ='''||v_feature_cat||''' ;';

	ELSIF v_view_type = 6 THEN
		--view for WS and UD features that have many fields in man table and have defined addfields
		EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
			SELECT ve_'||v_feature_type||'.*,
			'||v_man_fields||',
			'||v_a_param||'
			FROM '||v_schemaname||'.ve_'||v_feature_type||'
			JOIN '||v_schemaname||'.man_'||v_feature_system_id||' 
			ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = ve_'||v_feature_type||'.'||v_feature_type||'_id
			LEFT JOIN (SELECT ct.feature_id, '||v_ct_param||' FROM crosstab (''SELECT feature_id, parameter_id, value_param
			FROM '||v_schemaname||'.man_addfields_value JOIN '||v_schemaname||'.man_addfields_parameter ON man_addfields_parameter.id=parameter_id
			WHERE cat_feature_id='''''||v_feature_cat||''''' OR cat_feature_id is null  ORDER BY 1,2''::text, 
			''VALUES '||v_id_param||'''::text) ct(feature_id character varying,'||v_datatype||' )) a 
			ON a.feature_id::text=ve_'||v_feature_type||'.'||v_feature_type||'_id 
			WHERE '||v_feature_type||'_type ='''||v_feature_cat||''' ;';
	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
