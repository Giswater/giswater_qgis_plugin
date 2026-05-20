/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--14/05/2026
INSERT INTO config_param_system
("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('basic_search_v2_tab_visit', '{"sys_pk":"id","sys_tablename":"v_ui_om_visit","sys_search_name":"concat(id,'' '',ext_code,'' '',visit_catalog)","sys_display_name":"concat(id,'' - '',visit_catalog,'' ('',COALESCE(startdate::date::text,''-''),'')'')","sys_fct":"gw_fct_getvisit","sys_fct_tablename":"om_visit","sys_filter":"","sys_geom":"the_geom"}', 'Search configuration parameteres', 'Visit:', NULL, NULL, true, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

UPDATE sys_param_user
	SET vdefault='TRUE',descript='If true, the elevation will be showed from the DEM raster when inserting a new feature (only if admin_raster_dem is enabled)'
	WHERE id='edit_insert_show_elevation_from_dem';
