/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 3376

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getwidgets_checkproject(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_getrolewidgets($${"client":{"device":4, "infoType":1, "lang":"ES"},"data":{}}$$);

*/

DECLARE
v_version TEXT;
v_role TEXT;
v_widget_verified TEXT;
v_widget_om TEXT;
v_widget_epa TEXT;
v_widget_plan TEXT;
v_widget_admin TEXT;

-- return
v_return_widgets TEXT;
v_return JSON;


BEGIN

	-- set search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system data
	SELECT giswater  INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get role of current user
	SELECT role.rolname AS rol_asignado INTO v_role
	FROM pg_auth_members m
	JOIN pg_roles grantee ON m.member = grantee.oid
	JOIN pg_roles role ON m.roleid = role.oid
	WHERE grantee.rolname = current_user;

	-- check project
	v_widget_verified = '{"widgetname":"verifiedExceptions", "label":"Take into account verified values:", "widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":"1", "value":""}';
	v_widget_om = '{"widgetname":"omCheck", "label":"Check o%m data:", "widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":"2", "value":""}';
	v_widget_epa = '{"widgetname":"epaCheck", "label":"Check EPA data:", "widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":"3", "value":""}';
	v_widget_plan = '{"widgetname":"planCheck", "label":"Check plan data:", "widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":"4", "value":""}';
	v_widget_admin = '{"widgetname":"adminCheck", "label":"Check admin data:", "widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":"5", "value":""}';

	IF v_role in ('role_basic', 'role_edit', 'role_om') THEN

		v_return_widgets = concat(v_widget_om);

	ELSIF v_role = 'role_epa' THEN

		v_return_widgets = concat(v_widget_om, ',', v_widget_epa);

	ELSIF v_role = 'role_plan' THEN

		v_return_widgets = concat(v_widget_om, ',', v_widget_epa, ',', v_widget_plan);

	ELSIF v_role = 'role_admin' THEN

		v_return_widgets = concat(v_widget_om, ',', v_widget_epa, ',', v_widget_plan, ',', v_widget_admin);

	END IF;

	--  Return
	v_return = '{"status":"Accepted", "message":{"level":1, "text":"Widgets for check data sent correctly"}, "version":"'||v_version||'",
	"body":{"form":{},"data":{"parameters":['||v_return_widgets||']}}}';

	RETURN v_return;

END;
$function$
;

