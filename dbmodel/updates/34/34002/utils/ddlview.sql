/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_ui_doc_x_workcat AS
 SELECT doc_x_workcat.id,
    doc_x_workcat.workcat_id,
    doc_x_workcat.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_workcat
   JOIN doc ON doc.id::text = doc_x_workcat.doc_id::text;
   

CREATE OR REPLACE VIEW v_anl_graf AS 
 SELECT anl_graf.arc_id,
    anl_graf.node_1,
    anl_graf.node_2,
    anl_graf.flag,
    a.flag AS flagi,
    a.value
   FROM temp_anlgraf anl_graf
     JOIN ( SELECT anl_graf_1.arc_id,
            anl_graf_1.node_1,
            anl_graf_1.node_2,
            anl_graf_1.water,
            anl_graf_1.flag,
            anl_graf_1.checkf,
            anl_graf_1.value
           FROM temp_anlgraf anl_graf_1
          WHERE anl_graf_1.water = 1) a ON anl_graf.node_1 = a.node_2
  WHERE anl_graf.flag < 2 AND anl_graf.water = 0 AND a.flag < 2;
  
  

-- 2020/02/27
DROP VIEW IF EXISTS ve_config_sys_fields;
DROP VIEW IF EXISTS ve_config_sysfields;
CREATE OR REPLACE VIEW ve_config_sysfields AS 
 SELECT config_api_form_fields.id,
    config_api_form_fields.formname,
    config_api_form_fields.formtype,
    config_api_form_fields.column_id,
    config_api_form_fields.label,
    config_api_form_fields.hidden,
    config_api_form_fields.layoutname,
    config_api_form_fields.layout_order,
    config_api_form_fields.iseditable,
    config_api_form_fields.ismandatory,
    config_api_form_fields.datatype,
    config_api_form_fields.widgettype,
    config_api_form_fields.widgetdim,
    config_api_form_fields.tooltip,
    config_api_form_fields.placeholder,
    config_api_form_fields.stylesheet::text,
    config_api_form_fields.isparent,
    config_api_form_fields.isautoupdate,
    config_api_form_fields.dv_querytext,
    config_api_form_fields.dv_orderby_id,
    config_api_form_fields.dv_isnullvalue,
    config_api_form_fields.dv_parent_id,
    config_api_form_fields.dv_querytext_filterc,
    config_api_form_fields.widgetcontrols::text,
    config_api_form_fields.widgetfunction,
    config_api_form_fields.linkedaction,
    config_api_form_fields.listfilterparam::text,
    cat_feature.id AS cat_feature_id
   FROM config_api_form_fields
    LEFT JOIN cat_feature ON cat_feature.child_layer::text = config_api_form_fields.formname::text
  WHERE config_api_form_fields.formtype::text = 'feature'::text AND config_api_form_fields.formname::text <> 've_arc'::text AND config_api_form_fields.formname::text <> 've_node'::text AND config_api_form_fields.formname::text <> 've_connec'::text AND config_api_form_fields.formname::text <> 've_gully'::text AND NOT (config_api_form_fields.column_id::text IN ( SELECT man_addfields_parameter.param_name FROM man_addfields_parameter));
  



DROP VIEW IF EXISTS ve_config_addfields;
CREATE OR REPLACE VIEW ve_config_addfields AS 
 SELECT DISTINCT ON (man_addfields_parameter.id) row_number() OVER (ORDER BY config_api_form_fields.id) AS row_id,
    man_addfields_parameter.param_name AS column_id,
    config_api_form_fields.datatype,
    man_addfields_parameter.field_length,
    man_addfields_parameter.num_decimals,
    config_api_form_fields.widgettype,
    config_api_form_fields.widgetdim,
    config_api_form_fields.label,
    config_api_form_fields.layoutname,
    config_api_form_fields.layout_order,
    man_addfields_parameter.orderby AS addfield_order,
    man_addfields_parameter.active AS addfield_active,
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
    config_api_form_fields.linkedaction,
    config_api_form_fields.stylesheet,
    config_api_form_fields.listfilterparam,
    config_api_form_fields.widgetcontrols,
        CASE
            WHEN man_addfields_parameter.cat_feature_id IS NOT NULL THEN config_api_form_fields.formname
            ELSE NULL::character varying
        END AS formname,
    man_addfields_parameter.id AS param_id,
    man_addfields_parameter.cat_feature_id
   FROM SCHEMA_NAME.man_addfields_parameter
     LEFT JOIN SCHEMA_NAME.cat_feature ON cat_feature.id::text = man_addfields_parameter.cat_feature_id::text
     LEFT JOIN SCHEMA_NAME.config_api_form_fields ON config_api_form_fields.column_id::text = man_addfields_parameter.param_name::text;


