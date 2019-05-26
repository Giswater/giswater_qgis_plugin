/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_addfields(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_admin_manage_addfields($${
"client":{"lang":"ES"}, 
"feature":{"catFeature":"GREEN-VALVE"},
"data":{"action":"CREATE", "field":"test", "datatype":"text", "widgettype":"combo", "label", "querytext", .........todos}}$$)

SELECT SCHEMA_NAME.gw_fct_admin_manage_addfields($${
"client":{"lang":"ES"}, 
"feature":{"catFeature":"GREEN-VALVE"},
"data":{"action":"UPDATE", "field":""}}$$)

SELECT SCHEMA_NAME.gw_fct_admin_manage_addfields($${
"client":{"lang":"ES"}, 
"feature":{"catFeature":"GREEN-VALVE"},
"data":{"action":"DELETE", "field":""}}$$)
*/


DECLARE 
	v_schemaname text;
	v_feature text;
	v_viewname text;
	v_definition text;

	
	
	/*
	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- get input parameters
	v_schemaname = "SCHEMA_NAME";
	v_feature = ((p_data ->>'feature')::json->>'catFeature')::text;
	v_id = (sequence man_addfields_parameter)
	v_idval = ((p_data ->>'data')::json->>'field')::text;
	v_label = ((p_data ->>'data')::json->>'label')::text;

	-- get view definition
	v_viewname = (SELECT child_layer FROM cat_feature WHERE id=v_feature);
	v_definition = (SELECT pg_get_viewdef(v_schemaname||'.'||v_viewname, true));
	
	
	--AN EXAMPLE OF V_DEFITION IS LIKE THIS:
	CREATE OR REPLACE VIEW SCHEMA_NAME.ve_node_outfallvalve AS 
	SELECT v_node.*
    man_valve.*,
    a.outfallvalve_param_1,
    a.outfallvalve_param_2
	FROM SCHEMA_NAME.v_node
    JOIN SCHEMA_NAME.man_valve ON man_valve.node_id::text = v_node.node_id::text
    LEFT JOIN ( SELECT ct.feature_id,
            ct.outfallvalve_param_1,
            ct.outfallvalve_param_2
           FROM crosstab('SELECT feature_id, parameter_id, value_param
                FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''OUTFALL-VALVE''
                ORDER  BY 1,2'::text, ' VALUES (''26''),(''27'')'::text) ct(feature_id character varying, outfallvalve_param_1 text, outfallvalve_param_2 text)) a ON a.feature_id::text = v_node.node_id::text
				WHERE v_node.nodetype_id::text = 'OUTFALL-VALVE'::text;

	
	-- 1st (SELECT FROM man_addfields OLD)	
	LOOP (id, idval, datatype)
		v_old1 = 'a.idval_1, a.idval_2, a.idval3'
		v_old2 = 'rpt.idval_1, rpt.idval_2, rpt.idval3'
		v_old3 = ' (''id_1''),(''id_2''), (''id_3'')'
		v_old4 = ' idval_1 dataype_1, idval_2 dataype_2, idval3 datatype_3'
	ENDLOOP;
	
	
	-- 2nd INSERT (OR UPDATE OR DELETE ) INTO man_addfields NEW FIELD
	
	
	-- 3rd (SELECT FROM man_addfields NEW)
	LOOP (id, idval, datatype)
		v_new1 = 'a.idval_1, a.idval_2, a.idval3, a.idval4'
		v_new2 = 'rpt.idval_1, rpt.idval_2, rpt.idval3, rpt.idval4'
		v_new3 = ' (''id_1''),(''id_2''), (''id_3''), (''id_4'')'
		v_new4 = ' idval_1 dataype_1, idval_2 dataype_2, idval3 datatype_3', idval3 datatype_4'
	ENDLOOP;
	
	
	-- 4th replace query text into v_definition
		replace (v_old1, v_new1)
		replace (v_old2, v_new2)
		replace (v_old3, v_new3)
		replace (v_old4, v_new4)

	-- 5th execute v_definition
	EXECUTE v_definition

	
	-- 6th INSERT INTO form_fields table VALUES FROM input JSON
	
	

	--    Control NULL's
	v_message := COALESCE(v_message, '');
	
	*/
	
	-- Return
	RETURN ('{"message":{"priority":"'||v_priority||'", "text":"'||v_message||'"}}');	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
