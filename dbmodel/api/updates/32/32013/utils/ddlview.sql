/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW ve_config_addfields AS
SELECT  row_number() OVER (ORDER BY config_api_form_fields.id) AS row_id, column_id,datatype, config_api_form_fields.field_length, config_api_form_fields.num_decimals, widgettype,label,default_value,
layout_name, layout_order,orderby as addfield_order, man_addfields_parameter.active as addfield_active, isenabled,
       widgetdim, tooltip, placeholder,
       ismandatory, isparent, config_api_form_fields.iseditable,
      isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id,
      dv_querytext_filterc, widgetfunction, action_function, isreload,
      stylesheet, isnotupdate, typeahead, listfilterparam,
      editability, widgetcontrols, formname,man_addfields_parameter.id as param_id
 FROM man_addfields_parameter
 JOIN cat_feature ON cat_feature.id=man_addfields_parameter.cat_feature_id
 JOIN config_api_form_fields ON child_layer=formname and column_id = param_name;
 