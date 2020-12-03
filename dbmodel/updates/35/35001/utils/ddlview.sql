/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/07/30
DROP VIEW IF EXISTS ve_config_sysfields;

CREATE OR REPLACE VIEW ve_config_sysfields AS 
 SELECT 
    row_number() OVER () AS rid,
    config_form_fields.formname,
    config_form_fields.formtype,
    config_form_fields.columnname,
    config_form_fields.label,
    config_form_fields.hidden,
    config_form_fields.layoutname,
    config_form_fields.layoutorder,
    config_form_fields.iseditable,
    config_form_fields.ismandatory,
    config_form_fields.datatype,
    config_form_fields.widgettype,
    config_form_fields.widgetdim,
    config_form_fields.tooltip,
    config_form_fields.placeholder,
    config_form_fields.stylesheet::text AS stylesheet,
    config_form_fields.isparent,
    config_form_fields.isautoupdate,
    config_form_fields.dv_querytext,
    config_form_fields.dv_orderby_id,
    config_form_fields.dv_isnullvalue,
    config_form_fields.dv_parent_id,
    config_form_fields.dv_querytext_filterc,
    config_form_fields.widgetcontrols::text AS widgetcontrols,
    config_form_fields.widgetfunction,
    config_form_fields.linkedaction,
    config_form_fields.listfilterparam::text AS listfilterparam,
    cat_feature.id AS cat_feature_id
   FROM config_form_fields
     LEFT JOIN cat_feature ON cat_feature.child_layer::text = config_form_fields.formname::text
  WHERE config_form_fields.formtype::text = 'form_feature'::text AND config_form_fields.formname::text <> 've_arc'::text 
  AND config_form_fields.formname::text <> 've_node'::text AND config_form_fields.formname::text <> 've_connec'::text 
  AND config_form_fields.formname::text <> 've_gully'::text;
           
           
CREATE TRIGGER gw_trg_edit_config_sysfields
  INSTEAD OF UPDATE
  ON ve_config_sysfields
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_config_sysfields();
  
  
DROP VIEW IF EXISTS v_plan_psector;
DROP VIEW IF EXISTS v_ui_plan_psector;
DROP VIEW IF EXISTS v_plan_psector_all;
DROP VIEW IF EXISTS v_edit_plan_psector;
DROP VIEW IF EXISTS v_plan_current_psector;

