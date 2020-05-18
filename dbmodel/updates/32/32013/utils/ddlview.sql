/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

 CREATE OR REPLACE VIEW ve_config_addfields AS 
 SELECT  DISTINCT on (man_addfields_parameter.id) row_number() OVER (ORDER BY config_api_form_fields.id) AS row_id,
    man_addfields_parameter.param_name as column_id,
    config_api_form_fields.datatype,
    config_api_form_fields.field_length,
    config_api_form_fields.num_decimals,
    config_api_form_fields.widgettype,
    config_api_form_fields.label,
    config_api_form_fields.layout_name,
    config_api_form_fields.layout_order,
    man_addfields_parameter.orderby AS addfield_order,
    man_addfields_parameter.active AS addfield_active,
    config_api_form_fields.isenabled,
    config_api_form_fields.widgetdim,
    config_api_form_fields.tooltip,
    config_api_form_fields.placeholder,
    config_api_form_fields.ismandatory,
    config_api_form_fields.isparent,
    config_api_form_fields.iseditable,
    config_api_form_fields.isautoupdate,
    config_api_form_fields.dv_querytext,
    config_api_form_fields.dv_orderby_id,
    config_api_form_fields.dv_isnullvalue,
    config_api_form_fields.dv_parent_id,
    config_api_form_fields.dv_querytext_filterc,
    config_api_form_fields.widgetfunction,
    config_api_form_fields.action_function,
    config_api_form_fields.isreload,
    config_api_form_fields.stylesheet,
    config_api_form_fields.isnotupdate,
    config_api_form_fields.typeahead,
    config_api_form_fields.listfilterparam,
    config_api_form_fields.editability,
    config_api_form_fields.widgetcontrols,
    CASE WHEN man_addfields_parameter.cat_feature_id is not null then config_api_form_fields.formname
    else null end as formname,
    man_addfields_parameter.id AS param_id,
    man_addfields_parameter.cat_feature_id
   FROM man_addfields_parameter
     LEFT JOIN cat_feature ON cat_feature.id::text = man_addfields_parameter.cat_feature_id::text
     LEFT JOIN config_api_form_fields ON config_api_form_fields.column_id::text = man_addfields_parameter.param_name::text;


    CREATE OR REPLACE VIEW ve_config_sys_fields as
    SELECT config_api_form_fields.id, 
    formname, 
    column_id,
    label, 
    layout_name, 
    layout_order, 
    isenabled, 
    iseditable,
    ismandatory, 
    widgetdim,
    widgetcontrols,
    tooltip, 
    placeholder, 
    editability,
    stylesheet,
    hidden,
    cat_feature.id as cat_feature_id
      FROM config_api_form_fields
      LEFT JOIN cat_feature ON cat_feature.child_layer::text = config_api_form_fields.formname::text
      WHERE formtype='feature' and (formname!='ve_arc' and formname!='ve_node' and formname!='ve_connec'and formname!='ve_gully')
      AND column_id NOT IN (SELECT param_name FROM man_addfields_parameter);
