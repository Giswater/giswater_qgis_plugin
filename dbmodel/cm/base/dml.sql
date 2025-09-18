/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = cm, public, pg_catalog;
-- Seed rating config
INSERT INTO config_qindex_rating(id, minval, maxval, rating) VALUES
  (1, NULL, 0.999, 'EXCELENTE'),
  (2, 1.000, 1.999, 'BUENO'),
  (3, 2.000, 2.999, 'ACEPTABLE'),
  (4, 3.000, 3.999, 'REGULAR'),
  (5, 4.000, 999.000, 'INACEPTABLE')
ON CONFLICT (id) DO NOTHING;

INSERT INTO cat_role VALUES ('role_cm_admin');
INSERT INTO cat_role VALUES ('role_cm_org');
INSERT INTO cat_role VALUES ('role_cm_field');
INSERT INTO cat_role VALUES ('role_cm_edit');
INSERT INTO cat_role VALUES ('role_cm_manager');

-- Per-user switch to disable topocontrol in CM
INSERT INTO sys_param_user (
  id, formname, descript, sys_role, idval, "label",
  dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent,
  dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate,
  "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname,
  iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, "source"
) VALUES (
  'edit_disable_topocontrol', 'hidden', 'If true, CM topocontrol and feature proximity checks are disabled to allow data migration', 'role_cm_manager',
  NULL, NULL,
  NULL, NULL, TRUE, NULL, 'utils', NULL,
  NULL, NULL, NULL, FALSE,
  'boolean', 'check', TRUE, NULL, 'false', NULL,
  TRUE, NULL, NULL, NULL, NULL, 'core'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_param_system VALUES ('basic_selector_tab_lot',
'{"table":"temp_om_campaign_lot","selector":"selector_lot","table_id":"lot_id","selector_id":"lot_id","label":"lot_id, '' - '', name","orderBy":"lot_id","manageAll":true,"typeaheadFilter":" AND lower(concat(lot_id, '' - '', name))","query_filter":"AND active is true ","typeaheadForced":true,"selectionMode":"keepPreviousUsingShift"}',
'Variable to configura all options related to search for the specificic tab','Selector variables',null, null, true, null, 'utils', null, null, 'json','text');


INSERT INTO config_param_system VALUES ('basic_selector_tab_campaign',
'{"table":"temp_om_campaign","selector":"selector_campaign","table_id":"campaign_id","selector_id":"campaign_id","label":"campaign_id, '' - '', name","orderBy":"campaign_id","manageAll":true,"query_filter":"","typeaheadFilter":" AND lower(concat(id'' - '', name))","selectionMode":"keepPreviousUsingShift", "orderbyCheck":false}',
'Variable to configura all options related to search for the specificic tab','Selector variables',null, null, true, null, 'utils', null, null, 'json','text');

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('admin_campaign_type', '{"campaignReview":"true","campaignVisit":"false"}', 'Variable to specify wich type of campaign we whant to see when create', NULL, NULL, NULL, true, NULL, 'utils', NULL, NULL, 'json', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO config_form_tabs VALUES ('selector_campaign','tab_campaign','Campaign','Campaign','role_basic',null, null, 1, '{4}');
INSERT INTO config_form_tabs VALUES ('selector_campaign','tab_lot','Lot','Lot','role_basic', null, null, 2,'{4}');

INSERT INTO sys_typevalue (typevalue, id, idval, addparam) VALUES('layout_name_typevalue', 'lyt_buttons', 'lyt_buttons', '{"lytOrientation": "horizontal"}'::json) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_typevalue VALUES ('campaign_type', 1, 'REVIEW', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_type', 2, 'VISIT', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_type', 3, 'INVENTORY', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_typevalue VALUES ('campaign_status', 1, 'PLANIFYING', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 2, 'PLANIFIED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 3, 'ASSIGNED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 4, 'ON GOING', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 5, 'STAND-BY', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 6, 'EXECUTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 7, 'REJECTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 8, 'READY-TO-ACCEPT', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 9, 'ACCEPTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 10, 'CANCELED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_typevalue VALUES ('lot_status', 1, 'PLANIFYING', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 2, 'PLANIFIED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 3, 'ASSIGNED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 4, 'ON GOING', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 5, 'STAND-BY', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 6, 'EXECUTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 7, 'REJECTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 8, 'READY-TO-ACCEPT', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 9, 'ACCEPTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 10, 'CANCELED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_typevalue VALUES ('campaign_feature_status', 1, 'PLANIFIED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_feature_status', 2, 'NOT VISITED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_feature_status', 3, 'VISITED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_feature_status', 4, 'VISIT AGAIN', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_feature_status', 5, 'ACCEPTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_feature_status', 6, 'CANCELED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_typevalue VALUES ('lot_feature_status', 1, 'PLANIFIED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_feature_status', 2, 'NOT VISITED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_feature_status', 3, 'VISITED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_feature_status', 4, 'VISIT AGAIN', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_feature_status', 5, 'ACCEPTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_feature_status', 6, 'CANCELED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_review', 'form_feature', 'tab_data', 'campaign_id', 'lyt_data_1', 1, 'integer', 'text', 'Campaign Id:', 'Id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_review', 'form_feature', 'tab_data', 'name', 'lyt_data_1', 2, 'string', 'text', 'Name:', 'Name', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_review', 'form_feature', 'tab_data', 'startdate', 'lyt_data_1', 3, 'date', 'datetime', 'Planified start:', 'Planified start', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_review', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 4, 'date', 'datetime', 'Planified end:', 'Planified end', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_review', 'form_feature', 'tab_data', 'real_startdate', 'lyt_data_1', 5, 'date', 'datetime', 'Real start:', 'Real start', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_review', 'form_feature', 'tab_data', 'real_enddate', 'lyt_data_1', 6, 'date', 'datetime', 'Real end:', 'Real end', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_review', 'form_feature', 'tab_data', 'reviewclass_id', 'lyt_data_1', 7, 'string', 'combo', 'Reviewclass:', 'Reviewclass', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM cm.om_reviewclass WHERE active = true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_review', 'form_feature', 'tab_data', 'active', 'lyt_data_1', 8, 'boolean', 'check', 'Active:', 'Active', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"vdefault_value":"True"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_review', 'form_feature', 'tab_data', 'organization_id', 'lyt_data_1', 9, 'string', 'combo', 'Organization:', 'Organization', NULL, false, false, true, false, NULL, 'SELECT organization_id as id, orgname as idval FROM cm.cat_organization WHERE active = true', NULL, NULL, NULL, NULL, NULL, NULL, '{
  "functionName": "update_expl_sector_combos",
  "module": "campaign"
}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_review', 'form_feature', 'tab_data', 'expl_id', 'lyt_data_1', 10, 'string', 'combo', 'Expl Id:', 'Expl Id', NULL, false, false, true, false, NULL, 'Select '''' as id, '''' as idval', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_review', 'form_feature', 'tab_data', 'sector_id', 'lyt_data_1', 11, 'string', 'combo', 'Sector Id:', 'Sector Id', NULL, false, false, true, false, NULL, 'Select '''' as id, '''' as idval', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_review', 'form_feature', 'tab_data', 'status', 'lyt_data_1', 13, 'string', 'combo', 'Status:', 'Status', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM sys_typevalue WHERE typevalue=''campaign_status''', true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_review', 'form_feature', 'tab_data', 'descript', 'lyt_data_1', 14, 'string', 'textarea', 'Description:', 'Description', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_visit', 'form_feature', 'tab_data', 'campaign_id', 'lyt_data_1', 1, 'integer', 'text', 'Lot Id:', 'Id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_visit', 'form_feature', 'tab_data', 'name', 'lyt_data_1', 2, 'string', 'text', 'Name:', 'Name', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_visit', 'form_feature', 'tab_data', 'startdate', 'lyt_data_1', 3, 'date', 'datetime', 'Planified start:', 'Planified start', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_visit', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 4, 'date', 'datetime', 'Planified end:', 'Planified end', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_visit', 'form_feature', 'tab_data', 'real_startdate', 'lyt_data_1', 5, 'date', 'datetime', 'Real start:', 'Real start', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_visit', 'form_feature', 'tab_data', 'real_enddate', 'lyt_data_1', 6, 'date', 'datetime', 'Real end:', 'Real end', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_visit', 'form_feature', 'tab_data', 'visitclass_id', 'lyt_data_1', 7, 'string', 'combo', 'Visitclass:', 'Visitclass', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM cm.om_visitclass WHERE active = true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_visit', 'form_feature', 'tab_data', 'active', 'lyt_data_1', 8, 'boolean', 'check', 'Active:', 'Active', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"vdefault_value":"True"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_visit', 'form_feature', 'tab_data', 'organization_id', 'lyt_data_1', 9, 'string', 'combo', 'Organization:', 'Organization', NULL, false, false, true, false, NULL, 'SELECT organization_id as id, orgname as idval FROM cm.cat_organization WHERE active = true', NULL, NULL, NULL, NULL, NULL, NULL, '{
  "functionName": "update_expl_sector_combos",
  "module": "campaign"
}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_visit', 'form_feature', 'tab_data', 'expl_id', 'lyt_data_1', 10, 'string', 'combo', 'Expl Id:', 'Expl Id', NULL, false, false, true, false, NULL, 'Select '''' as id, '''' as idval', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_visit', 'form_feature', 'tab_data', 'sector_id', 'lyt_data_1', 11, 'string', 'combo', 'Sector Id:', 'Sector Id', NULL, false, false, true, false, NULL, 'Select '''' as id, '''' as idval', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_visit', 'form_feature', 'tab_data', 'status', 'lyt_data_1', 13, 'string', 'combo', 'Status:', 'Status', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM sys_typevalue WHERE typevalue=''campaign_status''', true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_visit', 'form_feature', 'tab_data', 'descript', 'lyt_data_1', 14, 'string', 'textarea', 'Description:', 'Description', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

INSERT INTO config_param_user ("parameter", value, cur_user) VALUES('utils_formlabel_show_columname', 'false', 'postgres');
INSERT INTO config_param_user ("parameter", value, cur_user) VALUES('edit_municipality_vdefault', NULL, 'postgres');
INSERT INTO config_param_user ("parameter", value, cur_user) VALUES('utils_debug_mode', 'false', 'postgres');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('lot', 'form_feature', 'tab_data', 'lot_id', 'lyt_data_2', 1, 'string', 'text', 'Lot ID:', 'Id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('lot', 'form_feature', 'tab_data', 'name', 'lyt_data_2', 2, 'string', 'text', 'Name:', 'Name', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('lot', 'form_feature', 'tab_data', 'startdate', 'lyt_data_2', 3, 'date', 'datetime', 'Planified start:', 'Planified start', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('lot', 'form_feature', 'tab_data', 'enddate', 'lyt_data_2', 4, 'date', 'datetime', 'Planified end:', 'Planified end', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('lot', 'form_feature', 'tab_data', 'real_startdate', 'lyt_data_2', 5, 'date', 'datetime', 'Real start:', 'Real start', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('lot', 'form_feature', 'tab_data', 'real_enddate', 'lyt_data_2', 6, 'date', 'datetime', 'Real end:', 'Real end', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('lot', 'form_feature', 'tab_data', 'campaign_id', 'lyt_data_2', 7, 'text', 'combo', 'Campaign id:', 'Campaign id', NULL, false, false, true, false, NULL, 'WITH isadmin AS (SELECT true AS val FROM pg_user u JOIN pg_auth_members m ON (m.member = u.usesysid) JOIN pg_roles r ON (r.oid = m.roleid)
WHERE u.usename = current_user AND r.rolname=''role_cm_admin'')
SELECT DISTINCT c.campaign_id AS id, c.name AS idval FROM cm.om_campaign c WHERE EXISTS (SELECT 1 FROM isadmin)
union 
SELECT distinct c.campaign_id AS id, c.name AS idval FROM cm.om_campaign c
JOIN cm.cat_team t ON t.organization_id = c.organization_id JOIN cm.cat_user u ON u.team_id = t.team_id
WHERE c.active IS true  AND u.active IS TRUE AND u.username = current_user', true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('lot', 'form_feature', 'tab_data', 'workorder_id', 'lyt_data_2', 8, 'text', 'combo', 'Workorder id:', 'Workorder id', NULL, false, false, true, false, NULL, 'SELECT workorder_id as id, workorder_name as idval FROM workorder', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('lot', 'form_feature', 'tab_data', 'active', 'lyt_data_2', 9, 'boolean', 'check', 'Active:', 'Active', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"vdefault_value":"True"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('lot', 'form_feature', 'tab_data', 'organization_assigned', 'lyt_data_2', 10, 'string', 'text', 'Organization Assigned:', 'Organization Assigned', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('lot', 'form_feature', 'tab_data', 'team_id', 'lyt_data_2', 11, 'string', 'combo', 'Team:', 'Team', NULL, false, false, true, false, NULL, 'SELECT DISTINCT(cat_team.team_id) as id, teamname as idval FROM cat_team WHERE active is TRUE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('lot', 'form_feature', 'tab_data', 'expl_id', 'lyt_data_2', 12, 'string', 'combo', 'Expl Id:', 'Expl Id', NULL, false, false, true, false, NULL, 'Select '''' as id, '''' as idval', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('lot', 'form_feature', 'tab_data', 'sector_id', 'lyt_data_2', 13, 'string', 'combo', 'Sector Id:', 'Sector Id', NULL, false, false, true, false, NULL, 'Select '''' as id, '''' as idval', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('lot', 'form_feature', 'tab_data', 'status', 'lyt_data_2', 14, 'string', 'combo', 'Status:', 'Status', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM sys_typevalue WHERE typevalue = ''lot_status''', true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('lot', 'form_feature', 'tab_data', 'descript', 'lyt_data_2', 15, 'string', 'textarea', 'Description:', 'Description', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project_cm', 'tab_log', 'txt_infolog', 'lyt_log_1', 0, NULL, 'textarea', NULL, '', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project_cm', 'tab_data', 'txt_info', 'lyt_data_1', 0, NULL, 'textarea', NULL, '', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "vdefault_value": "This text must be done in the config_form_fields widgetcontrols. ASK WHAT SHOULD GO."
}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project_cm', 'tab_data', 'campaign', 'lyt_data_2', 0, 'text', 'combo', 'Campaign:', 'Campaign', NULL, true, NULL, true, false, NULL, 'WITH user_org AS ( 
	SELECT co.orgname, co.organization_id
	FROM cm.cat_user cu
	JOIN cm.cat_team ct ON ct.team_id = cu.team_id
	JOIN cm.cat_organization co ON co.organization_id = ct.organization_id
	WHERE cu.username = current_user
)
SELECT campaign_id AS id, name AS idval
FROM cm.om_campaign c
WHERE (
	EXISTS (SELECT 1 FROM user_org WHERE orgname = ''OWNER'') OR c.organization_id IN (SELECT organization_id FROM user_org)
)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project_cm', 'tab_data', 'lot', 'lyt_data_2', 1, 'text', 'combo', 'Lot:', 'Lot', NULL, false, false, true, false, NULL, 'Select lot_id as id, name as idval from om_campaign_lot WHERE lot_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('workorder', 'form_feature', 'tab_data', 'workorder_id', 'lyt_data_1', 1, 'string', 'text', 'Workorder Id:', 'Workorder Id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('workorder', 'form_feature', 'tab_data', 'workorder_name', 'lyt_data_1', 2, 'string', 'text', 'Workorder name:', 'Workorder name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('workorder', 'form_feature', 'tab_data', 'workorder_type', 'lyt_data_1', 3, 'string', 'combo', 'Workorder type:', 'Workorder type', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('workorder', 'form_feature', 'tab_data', 'workorder_class', 'lyt_data_1', 4, 'string', 'combo', 'Workorder class:', 'Workorder class', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('workorder', 'form_feature', 'tab_data', 'serie', 'lyt_data_1', 6, 'string', 'text', 'Serie:', 'Serie', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('workorder', 'form_feature', 'tab_data', 'exercise', 'lyt_data_1', 5, 'string', 'text', 'Exercise:', 'Exercise', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('workorder', 'form_feature', 'tab_data', 'startdate', 'lyt_data_1', 7, 'date', 'datetime', 'Startdate:', 'Startdate', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('workorder', 'form_feature', 'tab_data', 'address', 'lyt_data_1', 8, 'string', 'text', 'Address:', 'Address', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('workorder', 'form_feature', 'tab_data', 'observ', 'lyt_data_1', 9, 'string', 'text', 'Observ:', 'Observ', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('workorder', 'form_feature', 'tab_data', 'cost', 'lyt_data_1', 10, 'string', 'text', 'Cost:', 'Cost', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

INSERT INTO sys_version (giswater, project_type, postgres, postgis, "language", epsg)
VALUES('', 'cm', (select version()), (select postgis_version()), 'en_US', 00000);

INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('ve_PARENT_SCHEMA_camp_arc', 've_PARENT_SCHEMA_camp_arc', 'role_basic', '{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, '{"levels": ["CM", "CAMPAIGN"]}', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('ve_PARENT_SCHEMA_camp_connec', 've_PARENT_SCHEMA_camp_connec', 'role_basic', '{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, '{"levels": ["CM", "CAMPAIGN"]}', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('ve_PARENT_SCHEMA_camp_link', 've_PARENT_SCHEMA_camp_link', 'role_basic', '{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, '{"levels": ["CM", "CAMPAIGN"]}', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('ve_PARENT_SCHEMA_camp_node', 've_PARENT_SCHEMA_camp_node', 'role_basic', '{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, '{"levels": ["CM", "CAMPAIGN"]}', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('ve_PARENT_SCHEMA_lot_arc', 've_PARENT_SCHEMA_lot_arc', 'role_basic', '{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, '{"levels": ["CM", "LOT"]}', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('ve_PARENT_SCHEMA_lot_connec', 've_PARENT_SCHEMA_lot_connec', 'role_basic', '{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, '{"levels": ["CM", "LOT"]}', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('ve_PARENT_SCHEMA_lot_link', 've_PARENT_SCHEMA_lot_link', 'role_basic', '{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, '{"levels": ["CM", "LOT"]}', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('ve_PARENT_SCHEMA_lot_node', 've_PARENT_SCHEMA_lot_node', 'role_basic', '{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, '{"levels": ["CM", "LOT"]}', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

GRANT ALL PRIVILEGES ON DATABASE BD_NAME TO role_cm_field;
GRANT ALL PRIVILEGES ON DATABASE BD_NAME TO role_cm_manager;
GRANT ALL PRIVILEGES ON DATABASE BD_NAME TO role_cm_admin;
GRANT ALL PRIVILEGES ON DATABASE BD_NAME TO role_cm_edit;

GRANT ALL ON SCHEMA cm TO role_cm_field;
GRANT ALL ON SCHEMA PARENT_SCHEMA TO role_cm_field;
GRANT ALL ON TABLE selector_lot TO role_cm_field;
GRANT ALL ON TABLE cm_audit.log TO role_cm_field;

GRANT ALL ON SCHEMA cm TO role_cm_manager;
GRANT ALL ON SCHEMA PARENT_SCHEMA TO role_cm_manager;
GRANT ALL ON SCHEMA cm TO role_cm_manager;
GRANT ALL ON ALL TABLES IN SCHEMA cm TO role_cm_manager;

GRANT ALL ON SCHEMA cm TO role_cm_admin;
GRANT ALL ON SCHEMA PARENT_SCHEMA TO role_cm_admin;
GRANT ALL ON SCHEMA cm TO role_cm_admin;
GRANT ALL ON ALL TABLES IN SCHEMA cm TO role_cm_admin;

GRANT ALL ON SCHEMA cm TO role_cm_edit;
GRANT ALL ON SCHEMA PARENT_SCHEMA TO role_cm_edit;
GRANT ALL ON ALL TABLES IN SCHEMA cm TO role_cm_edit;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA cm TO role_cm_edit;
GRANT role_edit TO role_cm_edit;

UPDATE config_form_fields SET
widgetcontrols = '{"vdefault_value": 
"Esta función tiene por objetivo pasar el control de calidad de una campaña, pudiendo escoger de forma concreta un lote especifico.<br><br>Se analizan diferentes aspectos siendo lo más destacado que se configura para que los datos esten operativos en el conjunto de una campaña para que el modelo hidraulico funcione."}'
WHERE formtype ='check_project_cm' and columnname ='txt_info';


INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(100, 'Check nulls consistence', 'cm', NULL, 'core', true, 'Check cm', NULL, 3, 'null value on the column %check_column% of %table_name%', NULL, NULL, 'SELECT * FROM %table_name% WHERE %feature_column% = ANY(ARRAY[%feature_ids%]) AND %check_column% IS NULL ', 'The %check_column% on %table_name% have correct values.', '[gw_fct_cm_check_dynamic]', true);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_inventory', 'form_feature', 'tab_data', 'campaign_id', 'lyt_data_1', 1, 'integer', 'text', 'Campaign Id:', 'Id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_inventory', 'form_feature', 'tab_data', 'name', 'lyt_data_1', 2, 'string', 'text', 'Name:', 'Name', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_inventory', 'form_feature', 'tab_data', 'startdate', 'lyt_data_1', 3, 'date', 'datetime', 'Planified start:', 'Planified start', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_inventory', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 4, 'date', 'datetime', 'Planified end:', 'Planified end', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_inventory', 'form_feature', 'tab_data', 'real_startdate', 'lyt_data_1', 5, 'date', 'datetime', 'Real start:', 'Real start', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_inventory', 'form_feature', 'tab_data', 'real_enddate', 'lyt_data_1', 6, 'date', 'datetime', 'Real end:', 'Real end', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_inventory', 'form_feature', 'tab_data', 'inventoryclass_id', 'lyt_data_1', 7, 'string', 'combo', 'Inventory Class:', 'Inventory Class', NULL, false, false, true, false, NULL, 'SELECT id as id, idval as idval FROM cm.om_inventoryclass WHERE active = true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_inventory', 'form_feature', 'tab_data', 'active', 'lyt_data_1', 8, 'boolean', 'check', 'Active:', 'Active', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"vdefault_value":"True"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_inventory', 'form_feature', 'tab_data', 'organization_id', 'lyt_data_1', 9, 'string', 'combo', 'Organization:', 'Organization', NULL, false, false, true, false, NULL, 'SELECT organization_id as id, orgname as idval FROM cm.cat_organization WHERE active = true', NULL, NULL, NULL, NULL, NULL, NULL, '{
  "functionName": "update_expl_sector_combos",
  "module": "campaign"
}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_inventory', 'form_feature', 'tab_data', 'expl_id', 'lyt_data_1', 10, 'string', 'combo', 'Expl Id:', 'Expl Id', NULL, false, false, true, false, NULL, 'Select '''' as id, '''' as idval', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_inventory', 'form_feature', 'tab_data', 'sector_id', 'lyt_data_1', 11, 'string', 'combo', 'Sector Id:', 'Sector Id', NULL, false, false, true, false, NULL, 'Select '''' as id, '''' as idval', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_inventory', 'form_feature', 'tab_data', 'status', 'lyt_data_1', 13, 'string', 'combo', 'Status:', 'Status', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM sys_typevalue WHERE typevalue=''campaign_status''', true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('campaign_inventory', 'form_feature', 'tab_data', 'descript', 'lyt_data_1', 14, 'string', 'textarea', 'Description:', 'Description', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

-- Form field configurations for team_create dialogs
-- These configurations enable dynamic dialog creation for team management

-- Create Team form configuration
INSERT INTO config_form_fields VALUES ('generic', 'team_create', 'tab_none', 'name', 'lyt_data_2', 1, 'text', 'text', 'Name:', NULL, NULL, true, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('generic', 'team_create', 'tab_none', 'code', 'lyt_data_2', 2, 'text', 'text', 'Code:', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('generic', 'team_create', 'tab_none', 'descript', 'lyt_data_2', 3, 'text', 'textarea', 'Description:', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('generic', 'team_create', 'tab_none', 'active', 'lyt_data_2', 4, 'boolean', 'check', 'Active:', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', '{"vdefault_value":"true"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

-- Fill config_form_tableview
DO $$
DECLARE
  v_location_type text;
  v_table text;
  v_column text;
  v_alias text;
  v_index int;
  v_tables text[][];
  i int;
BEGIN
  v_tables := ARRAY[['campaign_form', 'v_ui_campaign'], ['lot_form', 'v_ui_lot'], ['workorder_form', 'v_ui_workorder'], ['resources_form', 'cat_organization'], ['resources_form', 'cat_team'], ['resources_form', 'cat_user'], ['campaign_relations', 'om_campaign_x_arc'], ['campaign_relations', 'om_campaign_x_node'], ['campaign_relations', 'om_campaign_x_connec'], ['campaign_relations', 'om_campaign_x_link'], ['campaign_relations', 'om_campaign_x_gully'], ['lot_relations', 'om_campaign_lot_x_arc'], ['lot_relations', 'om_campaign_lot_x_node'], ['lot_relations', 'om_campaign_lot_x_connec'], ['lot_relations', 'om_campaign_lot_x_link'], ['lot_relations', 'om_campaign_lot_x_gully']];
  
  FOR i IN 1..array_length(v_tables, 1) LOOP
    v_location_type := v_tables[i][1];
    v_table := v_tables[i][2];
    v_index := 1;
    
    FOR v_column IN SELECT column_name FROM information_schema.columns WHERE table_schema = 'cm' AND table_name = v_table LOOP
      v_alias := upper(left(v_column, 1)) || substr(v_column, 2);
      v_alias := replace(v_alias, '_', ' ');
      INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, style, addparam) 
      VALUES (v_location_type, 'cm', v_table, v_column, v_index, true, NULL, v_alias, NULL, NULL);
      v_index := v_index + 1;
    END LOOP;
  END LOOP;
END $$;

-- Rewrite some aliases
UPDATE config_form_tableview
	SET alias='End date'
	WHERE objectname='v_ui_campaign' AND columnname='enddate';
UPDATE config_form_tableview
	SET alias='End date'
	WHERE objectname='v_ui_campaign_lot' AND columnname='enddate';
UPDATE config_form_tableview
	SET alias='Real end date'
	WHERE objectname='v_ui_campaign' AND columnname='real_enddate';
UPDATE config_form_tableview
	SET alias='Real end date'
	WHERE objectname='v_ui_campaign_lot' AND columnname='real_enddate';
UPDATE config_form_tableview
	SET alias='Real start date'
	WHERE objectname='v_ui_campaign_lot' AND columnname='real_startdate';
UPDATE config_form_tableview
	SET alias='Real start date'
	WHERE objectname='v_ui_campaign' AND columnname='real_startdate';
UPDATE config_form_tableview
	SET alias='Team name'
	WHERE objectname='cat_team' AND columnname='teamname';
UPDATE config_form_tableview
	SET alias='User name'
	WHERE objectname='cat_user' AND columnname='username';
UPDATE config_form_tableview
	SET alias='Org. name'
	WHERE objectname='cat_organization' AND columnname='orgname';

-- Insert missing aliases
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('resources_form','cm','cat_team','orgname',3,true,'Org. name');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('resources_form','cm','cat_user','code',2,true,'Code');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('resources_form','cm','cat_user','teamname',3,true,'Team name');

-- Delete extra aliases
DELETE FROM config_form_tableview
	WHERE objectname='cat_organization' AND columnname='expl_id';
DELETE FROM config_form_tableview
	WHERE objectname='cat_organization' AND columnname='sector_id';
DELETE FROM config_form_tableview
	WHERE objectname='cat_team' AND columnname='organization_id';
DELETE FROM config_form_tableview
	WHERE objectname='cat_user' AND columnname='team_id';
DELETE FROM config_form_tableview
	WHERE objectname='cat_user' AND columnname='roles';

-- Reorder columnindex
UPDATE config_form_tableview
	SET columnindex=5
	WHERE objectname='cat_user' AND columnname='username';
UPDATE config_form_tableview
	SET columnindex=6
	WHERE objectname='cat_organization' AND columnname='active';
UPDATE config_form_tableview
	SET columnindex=4
	WHERE objectname='cat_team' AND columnname='orgname';
UPDATE config_form_tableview
	SET columnindex=3
	WHERE objectname='cat_user' AND columnname='code';
UPDATE config_form_tableview
	SET columnindex=4
	WHERE objectname='cat_user' AND columnname='active';