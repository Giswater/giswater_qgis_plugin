/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--DROP VIEW IF EXISTS v_ext_streetaxis;

CREATE OR REPLACE VIEW v_ext_streetaxis AS 
SELECT ext_streetaxis.id,
ext_streetaxis.code,
ext_streetaxis.type,
ext_streetaxis.name,
ext_streetaxis.text,
ext_streetaxis.the_geom::geometry(MultiLinestring,SRID_VALUE),
ext_streetaxis.expl_id,
ext_streetaxis.muni_id,
CASE
WHEN ext_streetaxis.type IS NULL THEN ext_streetaxis.name::text
WHEN ext_streetaxis.text IS NULL THEN ((ext_streetaxis.name::text || ', '::text) || ext_streetaxis.type::text) || '.'::text
WHEN ext_streetaxis.type IS NULL AND ext_streetaxis.text IS NULL THEN ext_streetaxis.name::text
ELSE (((ext_streetaxis.name::text || ', '::text) || ext_streetaxis.type::text) || '. '::text) || ext_streetaxis.text
END AS descript
FROM selector_expl, ext_streetaxis
WHERE ext_streetaxis.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


--2020/01/07
CREATE OR REPLACE VIEW ve_config_addfields AS 
 SELECT DISTINCT ON (man_addfields_parameter.id) row_number() OVER (ORDER BY config_api_form_fields.id) AS row_id,
    man_addfields_parameter.param_name AS column_id,
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
    config_api_form_fields.reload_field,
    config_api_form_fields.stylesheet,
    config_api_form_fields.isnotupdate,
    config_api_form_fields.typeahead,
    config_api_form_fields.listfilterparam,
    config_api_form_fields.editability,
    config_api_form_fields.widgetcontrols,
        CASE
            WHEN man_addfields_parameter.cat_feature_id IS NOT NULL THEN config_api_form_fields.formname
            ELSE NULL::character varying
        END AS formname,
    man_addfields_parameter.id AS param_id,
    man_addfields_parameter.cat_feature_id
   FROM man_addfields_parameter
     LEFT JOIN cat_feature ON cat_feature.id::text = man_addfields_parameter.cat_feature_id::text
     LEFT JOIN config_api_form_fields ON config_api_form_fields.column_id::text = man_addfields_parameter.param_name::text;
