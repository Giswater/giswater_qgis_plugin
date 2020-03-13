/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/03/13
UPDATE audit_cat_param_user SET layoutname = 'lyt_inventory' , layout_order=9 WHERE id ='verified_vdefault';
UPDATE audit_cat_param_user SET layoutname = 'lyt_inventory' , layout_order=10 WHERE id ='cad_tools_base_layer_vdefault';
UPDATE audit_cat_param_user SET layoutname = 'lyt_inventory' , layout_order=11 WHERE id ='edit_gully_doublegeom';
UPDATE audit_cat_param_user SET layoutname = 'lyt_other' , layout_order=9 WHERE id ='edit_upsert_elevation_from_dem';
UPDATE audit_cat_param_user SET formname ='hidden_param' WHERE id IN ('audit_project_epa_result', 'audit_project_plan_result');
UPDATE audit_cat_param_user SET layoutname = 'lyt_other' , layout_order=18 WHERE id ='api_form_show_columname_on_label';

UPDATE audit_cat_param_user SET formname ='hidden_param' , project_type = 'utils' WHERE id IN ('qgis_qml_linelayer_path', 'qgis_qml_pointlayer_path', 'qgis_qml_polygonlayer_path');
