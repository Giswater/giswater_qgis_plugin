/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'v_ext_municipality', 've_municipality') WHERE dv_querytext LIKE '%v_ext_municipality%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'v_ext_streetaxis', 've_streetaxis') WHERE dv_querytext LIKE '%v_ext_streetaxis%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_municipality', 'v_municipality') WHERE dv_querytext LIKE '%ext_municipality%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_streetaxis', 'v_streetaxis') WHERE dv_querytext LIKE '%ext_streetaxis%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_address', 'v_address') WHERE dv_querytext LIKE '%ext_address%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_region', 'v_region') WHERE dv_querytext LIKE '%ext_region%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_province', 'v_province') WHERE dv_querytext LIKE '%ext_province%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_district', 'v_district') WHERE dv_querytext LIKE '%ext_district%';

UPDATE config_form_fields SET iseditable = false where formname ilike 've_node_%' and columnname = 'state';
UPDATE config_form_fields SET iseditable = false where formname ilike 've_arc_%' and columnname = 'state';
UPDATE config_form_fields SET iseditable = false where formname ilike 've_connec_%' and columnname = 'state';
UPDATE config_form_fields SET iseditable = false where formname ilike 've_link_%' and columnname = 'state';

UPDATE config_form_fields SET hidden = TRUE WHERE formname = 've_node_pump' AND columnname = 'expl_visibility';

UPDATE config_form_fields SET layoutorder = 14 WHERE formname = 've_element' AND columnname = 'rotation';
UPDATE config_form_fields SET layoutorder = 15 WHERE formname = 've_element' AND columnname = 'model_id';

UPDATE config_form_fields SET dv_querytext='SELECT function_type AS id, function_type AS idval FROM man_type_function WHERE active AND (featurecat_id IS NULL AND ''ELEMENT''=ANY(feature_type))' WHERE formname='ve_element' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT function_type AS id, function_type AS idval FROM man_type_function WHERE active AND (featurecat_id IS NULL AND ''CONNEC''=ANY(feature_type))' WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT function_type AS id, function_type AS idval FROM man_type_function WHERE active AND (featurecat_id IS NULL AND ''NODE''=ANY(feature_type))' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT function_type AS id, function_type AS idval FROM man_type_function WHERE active AND (featurecat_id IS NULL AND ''ARC''=ANY(feature_type))' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';

UPDATE config_form_fields SET dv_querytext='SELECT category_type AS id, category_type AS idval FROM man_type_category WHERE active AND (featurecat_id IS NULL AND ''ARC''=ANY(feature_type))' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT category_type AS id, category_type AS idval FROM man_type_category WHERE active AND (featurecat_id IS NULL AND ''CONNEC''=ANY(feature_type))' WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT category_type AS id, category_type AS idval FROM man_type_category WHERE active AND (featurecat_id IS NULL AND ''ELEMENT''=ANY(feature_type))' WHERE formname='ve_element' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT category_type AS id, category_type AS idval FROM man_type_category WHERE active AND (featurecat_id IS NULL AND ''NODE''=ANY(feature_type))' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';

UPDATE config_form_fields SET dv_querytext='SELECT location_type AS id, location_type AS idval FROM man_type_location WHERE active AND (featurecat_id IS NULL AND ''ARC''=ANY(feature_type))' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT location_type AS id, location_type AS idval FROM man_type_location WHERE active AND (featurecat_id IS NULL AND ''CONNEC''=ANY(feature_type))' WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT location_type AS id, location_type AS idval FROM man_type_location WHERE active AND (featurecat_id IS NULL AND ''ELEMENT''=ANY(feature_type))' WHERE formname='ve_element' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT location_type AS id, location_type AS idval FROM man_type_location WHERE active AND (featurecat_id IS NULL AND ''NODE''=ANY(feature_type))' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';

UPDATE config_form_fields SET dv_querytext='SELECT fluid_type AS id, fluid_type AS idval FROM man_type_fluid WHERE active AND (featurecat_id IS NULL AND ''ARC''=ANY(feature_type))' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT fluid_type AS id, fluid_type AS idval FROM man_type_fluid WHERE active AND (featurecat_id IS NULL AND ''CONNEC''=ANY(feature_type))' WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT fluid_type AS id, fluid_type AS idval FROM man_type_fluid WHERE active AND (featurecat_id IS NULL AND ''ELEMENT''=ANY(feature_type))' WHERE formname='ve_element' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT fluid_type AS id, fluid_type AS idval FROM man_type_fluid WHERE active AND (featurecat_id IS NULL AND ''NODE''=ANY(feature_type))' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
