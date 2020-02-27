/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/02/27
DROP VIEW IF EXISTS ve_config_sys_fields;

CREATE OR REPLACE VIEW ve_config_sys_fields AS 
 SELECT config_api_form_fields.id,
    config_api_form_fields.formname,
    config_api_form_fields.formtype,
    config_api_form_fields.column_id,
    config_api_form_fields.label,
    config_api_form_fields.layout_name,
    config_api_form_fields.layout_order,
    config_api_form_fields.iseditable,
    config_api_form_fields.ismandatory,
    config_api_form_fields.widgetdim,
    config_api_form_fields.widgetcontrols,
    config_api_form_fields.tooltip,
    config_api_form_fields.placeholder,
    config_api_form_fields.stylesheet,
    config_api_form_fields.hidden,
    config_api_form_fields.datatype,
    config_api_form_fields.widgettype,
    config_api_form_fields.field_length,
    config_api_form_fields.num_decimals,
    config_api_form_fields.isparent,
    config_api_form_fields.isautoupdate,
    config_api_form_fields.dv_querytext,
    config_api_form_fields.dv_orderby_id,
    config_api_form_fields.dv_isnullvalue,
    config_api_form_fields.dv_parent_id,
    config_api_form_fields.dv_querytext_filterc,
    config_api_form_fields.widgetfunction,
    config_api_form_fields.action_function,
    config_api_form_fields.typeahead,
    config_api_form_fields.listfilterparam,
    config_api_form_fields.reload_field,
    cat_feature.id AS cat_feature_id
   FROM config_api_form_fields
    LEFT JOIN cat_feature ON cat_feature.child_layer::text = config_api_form_fields.formname::text
  WHERE config_api_form_fields.formtype::text = 'feature'::text AND config_api_form_fields.formname::text <> 've_arc'::text AND config_api_form_fields.formname::text <> 've_node'::text AND config_api_form_fields.formname::text <> 've_connec'::text AND config_api_form_fields.formname::text <> 've_gully'::text AND NOT (config_api_form_fields.column_id::text IN ( SELECT man_addfields_parameter.param_name FROM man_addfields_parameter));
  


