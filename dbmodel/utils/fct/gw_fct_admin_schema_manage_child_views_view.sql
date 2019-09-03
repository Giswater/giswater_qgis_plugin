/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2716
--DROP FUNCTION SCHEMA_NAME.gw_fct_admin_manage_child_views_view(text, text, text, text, text, text, integer, text, text, text, text);


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_child_views_view(p_schemaname text,p_viewname text, p_feature_type text,
p_feature_system_id text,p_man_fields text, p_feature_cat text, p_type integer, p_a_param text, p_ct_param text,p_id_param text, 
p_datatype text )
  RETURNS void AS
$BODY$


/*EXAMPLE

 SELECT SCHEMA_NAME.gw_fct_admin_manage_child_views_view 
				('ws', 'aaa_ve_acom', 'connec', 'wjoin', 'man_wjoin.top_floor, man_wjoin.cat_valve', 
				'ACOMETIDA',3,null, null, null, null);

*/


DECLARE 

	v_project_type text;


BEGIN

	
	-- search path
	SET search_path = "SCHEMA_NAME", public;

	SELECT wsoftware INTO v_project_type FROM version LIMIT 1;


	IF p_type = 1 THEN
		--view for WS and UD features that only have feature_id in man table
		EXECUTE 'CREATE OR REPLACE VIEW '||p_schemaname||'.'||p_viewname||' AS
			SELECT ve_'||p_feature_type||'.*
			FROM '||p_schemaname||'.ve_'||p_feature_type||'
			JOIN '||p_schemaname||'.man_'||p_feature_system_id||' 
			ON man_'||p_feature_system_id||'.'||p_feature_type||'_id = ve_'||p_feature_type||'.'||p_feature_type||'_id 
			WHERE '||p_feature_type||'_type ='''||p_feature_cat||''' ;';
	
	ELSIF p_type = 2 THEN
		--view for ud connec y gully which dont have man_type table
		EXECUTE 'CREATE OR REPLACE VIEW '||p_schemaname||'.'||p_viewname||' AS
			SELECT ve_'||p_feature_type||'.*
			FROM '||p_schemaname||'.ve_'||p_feature_type||'
			WHERE '||p_feature_type||'_type ='''||p_feature_cat||''' ;';	
	
	ELSIF p_type = 3 THEN
		--view for WS and UD features that have many fields in man table
		EXECUTE 'CREATE OR REPLACE VIEW '||p_schemaname||'.'||p_viewname||' AS
			SELECT ve_'||p_feature_type||'.*,
			'||p_man_fields||'
			FROM '||p_schemaname||'.ve_'||p_feature_type||'
			JOIN '||p_schemaname||'.man_'||p_feature_system_id||' 
			ON man_'||p_feature_system_id||'.'||p_feature_type||'_id = ve_'||p_feature_type||'.'||p_feature_type||'_id 
			WHERE '||p_feature_type||'_type ='''||p_feature_cat||''' ;';

	ELSIF p_type = 4 THEN
		--view for WS and UD features that only have feature_id in man table and have defined addfields
		EXECUTE 'CREATE OR REPLACE VIEW '||p_schemaname||'.'||p_viewname||' AS
			SELECT ve_'||p_feature_type||'.*,
			'||p_a_param||'
			FROM '||p_schemaname||'.ve_'||p_feature_type||'
			JOIN '||p_schemaname||'.man_'||p_feature_system_id||' ON man_'||p_feature_system_id||'.'||p_feature_type||'_id = ve_'||p_feature_type||'.'||p_feature_type||'_id
			LEFT JOIN (SELECT ct.feature_id, '||p_ct_param||' FROM crosstab (''SELECT feature_id, parameter_id, value_param
			FROM '||p_schemaname||'.man_addfields_value JOIN '||p_schemaname||'.man_addfields_parameter ON man_addfields_parameter.id=parameter_id
			WHERE cat_feature_id='''''||p_feature_cat||''''' OR cat_feature_id is null  ORDER BY 1,2''::text, 
			''VALUES '||p_id_param||'''::text) ct(feature_id character varying,'||p_datatype||' )) a 
			ON a.feature_id::text=ve_'||p_feature_type||'.'||p_feature_type||'_id 
			WHERE '||p_feature_type||'_type ='''||p_feature_cat||''' ;';

	ELSIF p_type = 5 THEN
		--view for ud connec y gully which dont have man_type table and have defined addfields
		EXECUTE 'CREATE OR REPLACE VIEW '||p_schemaname||'.'||p_viewname||' AS
			SELECT ve_'||p_feature_type||'.*,
			'||p_a_param||'
			FROM '||p_schemaname||'.ve_'||p_feature_type||'
			LEFT JOIN (SELECT ct.feature_id, '||p_ct_param||' FROM crosstab (''SELECT feature_id, parameter_id, value_param
			FROM '||p_schemaname||'.man_addfields_value JOIN '||p_schemaname||'.man_addfields_parameter ON man_addfields_parameter.id=parameter_id
			WHERE cat_feature_id='''''||p_feature_cat||''''' OR cat_feature_id is null ORDER BY 1,2''::text, 
			''VALUES '||p_id_param||'''::text) ct(feature_id character varying,'||p_datatype||' )) a 
			ON a.feature_id::text=ve_'||p_feature_type||'.'||p_feature_type||'_id 
			WHERE '||p_feature_type||'_type ='''||p_feature_cat||''' ;';

	ELSIF p_type = 6 THEN
		--view for WS and UD features that have many fields in man table and have defined addfields
		EXECUTE 'CREATE OR REPLACE VIEW '||p_schemaname||'.'||p_viewname||' AS
			SELECT ve_'||p_feature_type||'.*,
			'||p_man_fields||',
			'||p_a_param||'
			FROM '||p_schemaname||'.ve_'||p_feature_type||'
			JOIN '||p_schemaname||'.man_'||p_feature_system_id||' 
			ON man_'||p_feature_system_id||'.'||p_feature_type||'_id = ve_'||p_feature_type||'.'||p_feature_type||'_id
			LEFT JOIN (SELECT ct.feature_id, '||p_ct_param||' FROM crosstab (''SELECT feature_id, parameter_id, value_param
			FROM '||p_schemaname||'.man_addfields_value JOIN '||p_schemaname||'.man_addfields_parameter ON man_addfields_parameter.id=parameter_id
			WHERE cat_feature_id='''''||p_feature_cat||''''' OR cat_feature_id is null  ORDER BY 1,2''::text, 
			''VALUES '||p_id_param||'''::text) ct(feature_id character varying,'||p_datatype||' )) a 
			ON a.feature_id::text=ve_'||p_feature_type||'.'||p_feature_type||'_id 
			WHERE '||p_feature_type||'_type ='''||p_feature_cat||''' ;';
	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
