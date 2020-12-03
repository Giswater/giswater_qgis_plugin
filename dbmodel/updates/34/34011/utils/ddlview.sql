/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/25
CREATE OR REPLACE VIEW v_rtc_hydrometer AS 
 SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN connec.connec_id IS NULL THEN 'XXXX'::character varying
            ELSE connec.connec_id
        END AS connec_id,
        CASE
            WHEN ext_rtc_hydrometer.connec_id::text IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id::text
        END AS connec_customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
    connec.expl_id,
    exploitation.name AS expl_name,
    ext_rtc_hydrometer.plot_code,
    ext_rtc_hydrometer.priority_id,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer.category_id,
    ext_rtc_hydrometer.hydro_number,
    ext_rtc_hydrometer.hydro_man_date,
    ext_rtc_hydrometer.crm_number,
    ext_rtc_hydrometer.customer_name,
    ext_rtc_hydrometer.address1,
    ext_rtc_hydrometer.address2,
    ext_rtc_hydrometer.address3,
    ext_rtc_hydrometer.address2_1,
    ext_rtc_hydrometer.address2_2,
    ext_rtc_hydrometer.address2_3,
    ext_rtc_hydrometer.m3_volume,
    ext_rtc_hydrometer.start_date,
    ext_rtc_hydrometer.end_date,
    ext_rtc_hydrometer.update_date,
        CASE
            WHEN (( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)) IS NULL THEN rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text), rtc_hydrometer.link)
        END AS hydrometer_link
   FROM selector_hydrometer,
    selector_expl,
    rtc_hydrometer
     LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
     JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.connec_id::text
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = connec.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text 
  AND selector_expl.expl_id = connec.expl_id AND selector_expl.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS ve_config_sysfields;

CREATE OR REPLACE VIEW ve_config_sysfields AS 
 SELECT 
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
  WHERE config_form_fields.formtype::text = 'feature'::text AND config_form_fields.formname::text <> 've_arc'::text AND config_form_fields.formname::text <> 've_node'::text AND config_form_fields.formname::text <> 've_connec'::text AND config_form_fields.formname::text <> 've_gully'::text AND NOT (config_form_fields.columnname::text IN ( SELECT sys_addfields.param_name
           FROM sys_addfields));


CREATE TRIGGER gw_trg_edit_config_sysfields
  INSTEAD OF UPDATE
  ON ve_config_sysfields
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_config_sysfields();


CREATE OR REPLACE VIEW ve_config_addfields AS 
	SELECT
    sys_addfields.param_name AS columnname,
    config_form_fields.datatype,
    sys_addfields.field_length,
    sys_addfields.num_decimals,
    config_form_fields.widgettype,
    config_form_fields.widgetdim,
    config_form_fields.label,
    config_form_fields.layoutname,
    config_form_fields.layoutorder AS layout_order,
    sys_addfields.orderby AS addfield_order,
    sys_addfields.active AS addfield_active,
    config_form_fields.tooltip,
    config_form_fields.placeholder,
    config_form_fields.ismandatory,
    config_form_fields.isparent,
    config_form_fields.iseditable,
    config_form_fields.isautoupdate,
    config_form_fields.dv_querytext,
    config_form_fields.dv_orderby_id,
    config_form_fields.dv_isnullvalue,
    config_form_fields.dv_parent_id,
    config_form_fields.dv_querytext_filterc,
    config_form_fields.widgetfunction,
    config_form_fields.linkedaction,
    config_form_fields.stylesheet,
    config_form_fields.listfilterparam,
    config_form_fields.widgetcontrols,
        CASE
            WHEN sys_addfields.cat_feature_id IS NOT NULL THEN config_form_fields.formname
            ELSE NULL::character varying
        END AS formname,
    sys_addfields.id AS param_id,
    sys_addfields.cat_feature_id
   FROM sys_addfields
     LEFT JOIN cat_feature ON cat_feature.id::text = sys_addfields.cat_feature_id::text
     LEFT JOIN config_form_fields ON config_form_fields.columnname::text = sys_addfields.param_name::text;


CREATE TRIGGER gw_trg_edit_config_addfields
  INSTEAD OF UPDATE
  ON ve_config_addfields
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_config_addfields();