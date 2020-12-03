/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 17/10/2019
UPDATE audit_cat_param_user SET description = 'If true, link will be automatically generated when inserting a new gully with state=1. For planified gullys, link will always be automatically generated'
WHERE id = 'edit_gully_force_automatic_connect2network';


UPDATE config_api_form_fields SET dv_querytext=concat('SELECT function_type as id, function_type as idval FROM man_type_function WHERE (featurecat_id is null AND feature_type=''GULLY'') OR featurecat_id =',quote_literal(cat_feature.id)),
dv_querytext_filterc=NULL, dv_parent_id=null
FROM cat_feature WHERE child_layer = formname AND column_id ='function_type' AND cat_feature.feature_type='GULLY';

UPDATE config_api_form_fields SET dv_querytext=concat('SELECT category_type as id, category_type as idval FROM man_type_category WHERE (featurecat_id is null AND feature_type=''GULLY'') OR featurecat_id =',quote_literal(cat_feature.id)),
dv_querytext_filterc=NULL, dv_parent_id=null
FROM cat_feature WHERE child_layer = formname AND column_id ='category_type' AND cat_feature.feature_type='GULLY';

UPDATE config_api_form_fields SET dv_querytext=concat('SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE (featurecat_id is null AND feature_type=''GULLY'') OR featurecat_id =',quote_literal(cat_feature.id)),
dv_querytext_filterc=NULL, dv_parent_id=null
FROM cat_feature WHERE child_layer = formname AND column_id ='fluid_type' AND cat_feature.feature_type='GULLY';

UPDATE config_api_form_fields SET dv_querytext=concat('SELECT location_type as id, location_type as idval FROM man_type_location WHERE (featurecat_id is null AND feature_type=''GULLY'') OR featurecat_id =',quote_literal(cat_feature.id)),
dv_querytext_filterc=NULL, dv_parent_id=null
FROM cat_feature WHERE child_layer = formname AND column_id ='location_type' AND cat_feature.feature_type='GULLY';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE (featurecat_id is null AND feature_type=''GULLY'') ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 've_gully' and column_id = 'location_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type=''GULLY'' ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 'v_edit_gully' and column_id = 'location_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE (featurecat_id is null AND feature_type=''GULLY'') ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 've_gully' and column_id = 'fluid_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE feature_type=''GULLY'' ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 'v_edit_gully' and column_id = 'fluid_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE (featurecat_id is null AND feature_type=''GULLY'') ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 've_gully' and column_id = 'function_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type=''GULLY'' ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 'v_edit_gully' and column_id = 'function_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE (featurecat_id is null AND feature_type=''GULLY'') ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 've_gully' and column_id = 'location_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type=''GULLY'' ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 'v_edit_gully' and column_id = 'location_type';