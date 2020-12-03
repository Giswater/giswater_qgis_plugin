/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


SELECT setval('SCHEMA_NAME.config_form_fields_id_seq', (SELECT max(id) FROM config_form_fields), true);

--VISIT_CLASS_0
INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_class_0', 'visit', 'class_id', 1, 'integer', 'text', 'Visit type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM config_visit_class WHERE feature_type IS NULL AND active IS TRUE AND id > 0 AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_class_0', 'visit', 'visit_id', 2, 'integer', 'text', 'Visit id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_class_0', 'visit', 'visitcat_id', 3, 'integer', 'combo', 'Visit catalog:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT DISTINCT id AS id, name AS idval FROM om_visit_cat WHERE active IS TRUE',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_class_0', 'visit', 'ext_code', 4, 'string', 'text', 'Code:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_class_0', 'visit', 'startdate', 5, 'date', 'datetime', 'Start date:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_class_0', 'visit', 'enddate', 6, 'date', 'datetime', 'End date:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_class_0', 'visit', 'acceptbutton', 1, NULL, 'button', 'Accept',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'gwSetVisit' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_class_0', 'visit', 'cancelbutton', 2, NULL, 'button', 'Cancel',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'backButtonClicked' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);








--UNEXPECTED_NOINFRA
INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'class_id', 1, 'integer', 'combo', 'Visit type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM config_visit_class WHERE feature_type IS NULL AND active IS TRUE AND id > 0 AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
'gwGetVisit' ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'visit_id', 2, 'integer', 'text', 'Visit id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'incident_type', 3, 'integer', 'combo', 'Incident type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''incident_type''',
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'ext_code', 4, 'string', 'text', 'Code:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'startdate', 5, 'date', 'datetime', 'Start date:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'enddate', 6, 'date', 'datetime', 'End date:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'incident_comment', 7, 'string', 'text', 'Comment:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'status', 8, 'integer', 'combo', 'Status:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT DISTINCT (id) AS id,  idval  AS idval FROM om_typevalue WHERE id IS NOT NULL AND typevalue=''visit_cat_status'' ',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'acceptbutton', 1, NULL, 'button', 'Accept',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'gwSetVisit' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'cancelbutton', 2, NULL, 'button', 'Cancel',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'backButtonClicked' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);




--VISIT_ARC_INSP
INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'class_id', 1, 'integer', 'combo', 'Visit type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM config_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
'gwGetVisit',NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'image1', 2, 'bytea', 'image', NULL,
NULL, NULL, NULL, false, false, true, NULL, 'SELECT row_to_json(res) FROM (SELECT encode(image, ''base64'') AS image FROM config_api_images WHERE id=1) res;',
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'visit_id', 3, 'double', 'text', 'Visit id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'arc_id', 4, 'double', 'text', 'Arc_id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'lot_id', 5, 'integer', 'combo', 'Lot id:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id , id as idval FROM om_visit_lot WHERE active IS TRUE',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'ext_code', 6, 'string', 'text', 'Code:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'sediments_arc', 7, 'double', 'text', 'Sediments:',
NULL, NULL, 'Ex.: 10 (en cmts.)', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'defect_arc', 8, 'integer', 'combo', 'Defects:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_defect''',
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'clean_arc', 9, 'integer', 'combo', 'Cleaned:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_cleaned''',
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'startdate', 10, 'date', 'datetime', 'Start date:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'enddate', 11, 'date', 'datetime', 'End date:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'status', 12, 'integer', 'combo', 'Status:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT DISTINCT (id) AS id,  idval  AS idval FROM om_typevalue WHERE id IS NOT NULL AND typevalue=''visit_cat_status'' ',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'divider', 13, NULL, 'formDivider', NULL,
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'acceptbutton', 1, NULL, 'button', 'Accept',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'gwSetVisit' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'backbutton', 2, NULL, 'button', 'Back',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM config_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
'backButtonClicked',NULL, NULL, NULL, 'data_9', NULL, FALSE);




--VISIT_CONNEC_INSP
INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'class_id', 1, 'integer', 'combo', 'Visit type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM config_visit_class WHERE feature_type=''CONNEC'' AND  active IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
'gwGetVisit' ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'image1', 2, 'bytea', 'image', NULL,
NULL, NULL, NULL, false, false, true, NULL, 'SELECT row_to_json(res) FROM (SELECT encode(image, ''base64'') AS image FROM config_api_images WHERE id=1) res;',
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'visit_id', 3, 'double', 'text', 'Visit id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'connec_id', 4, 'string', 'text', 'Connec id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'visitcat_id', 5, 'integer', 'combo', 'Visit catalog:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT DISTINCT id AS id, name AS idval FROM om_visit_cat WHERE active IS TRUE',
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'visit_code', 6, 'string', 'text', 'Visit code:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'defect_connec', 7, 'integer', 'combo', 'Defects:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_defect'' ',
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'clean_connec', 8, 'integer', 'combo', 'Cleaned:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_cleaned''',
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'acceptbutton', 1, NULL, 'button', 'Accept',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'gwSetVisit' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'backbutton', 2, NULL, 'button', 'Back',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'backButtonClicked' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);



--VISIT_NODE_INSP
INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'class_id', 1, 'integer', 'combo', 'Visit type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM config_visit_class WHERE feature_type=''NODE'' AND  active IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
'gwGetVisit', NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'image1', 2, 'bytea', 'image', NULL,
NULL, NULL, NULL, false, false, true, NULL, 'SELECT row_to_json(res) FROM (SELECT encode(image, ''base64'') AS image FROM config_api_images WHERE id=1) res;',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'visit_id', 3, 'double', 'text', 'Visit id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'node_id', 4, 'double', 'text', 'Node_id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'visitcat_id', 5, 'integer', 'combo', 'Visit catalog:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT DISTINCT id AS id, name AS idval FROM om_visit_cat WHERE active IS TRUE',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'visit_code', 6, 'string', 'text', 'Visit code:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'sediments_node', 7, 'double', 'text', 'Sediments:',
NULL, NULL, 'Ex.: 10 (en cmts.)', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'defect_node', 8, 'integer', 'combo', 'Defects:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_defect''',
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'clean_node', 9, 'integer', 'combo', 'Cleaned:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_cleaned''',
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'acceptbutton', 1, NULL, 'button', 'Accept',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'gwSetVisit' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'backbutton', 2, NULL, 'button', 'Back',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'backButtonClicked' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);




--VISIT_ARC_LEAK
INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'class_id', 1, 'integer', 'combo', 'Visit type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM config_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
'gwGetVisit' ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'event_id', 2, 'double', 'text', 'Event id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'visit_id', 3, 'double', 'text', 'Visit id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'lot_id', 4, 'integer', 'combo', 'Lot id:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id , id as idval FROM om_visit_lot WHERE active IS TRUE',
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'ext_code', 5, 'string', 'text', 'Code:',
NULL, NULL, 'Ex.: Work order code', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'parameter_id', 6, 'string', 'combo', 'Parameter:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id AS id, descript AS idval FROM config_visit_parameter WHERE feature_type=''ARC''',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'event_code', 7, 'string', 'text', 'Event code:',
NULL, NULL, 'Ex.: Parameter code', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);


INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'sediments_connec', 9, 'string', 'text', 'Sediments:',
NULL, NULL, 'Ex.: 10 (en cmts.)', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'position_value', 10, 'double', 'text', 'Position value:',
NULL, NULL, 'Ex.: 34.57', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'arc_id', 11, 'string', 'text', 'Arc id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'position_id', 8, 'string', 'combo', 'Position id:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT a.id, a.idval FROM (SELECT node_1 AS id, node_1 AS idval FROM arc UNION 
SELECT DISTINCT node_2 AS id, node_2 AS idval FROM arc) a WHERE id IS NOT NULL',
NULL, NULL, 'arc_id', ' AND arc.arc_id.arc_id=', 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'startdate', 11, 'date', 'datetime', 'Start date:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'enddate', 12, 'date', 'datetime', 'End date:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'status', 13, 'integer', 'combo', 'Status:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT DISTINCT (id) AS id,  idval  AS idval FROM om_typevalue WHERE id IS NOT NULL AND typevalue=''visit_cat_status'' ',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'acceptbutton', 1, NULL, 'button', 'Accept',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'gwSetVisit' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'backbutton', 2, NULL, 'button', 'Back',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'backButtonClicked' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);




--VISIT_CONNEC_LEAK
INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'class_id', 1, 'integer', 'combo', 'Visit type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM config_visit_class WHERE feature_type=''CONNEC'' AND  active IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
'gwGetVisit',NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'event_id', 2, 'double', 'text', 'Event id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'visit_id', 3, 'double', 'text', 'Visit id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'visitcat_id', 4, 'integer', 'combo', 'Visit catalog:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT DISTINCT id AS id, name AS idval FROM om_visit_cat WHERE active IS TRUE',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'ext_code', 5, 'string', 'text', 'Code:',
NULL, NULL, 'Ex.: Work order code', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'parameter_id', 6, 'string', 'combo', 'Parameter:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id AS id, descript AS idval FROM config_visit_parameter WHERE feature_type=''CONNEC''',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'event_code', 7, 'string', 'text', 'Event code:',
NULL, NULL, 'Ex.: Parameter code', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'connec_id', 8, 'double', 'text', 'Connec id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'acceptbutton', 1, NULL, 'button', 'Accept',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'gwSetVisit' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'backbutton', 2, NULL, 'button', 'Back',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'backButtonClicked' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);



--VISIT_NODE_LEAK
INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'class_id', 1, 'integer', 'combo', 'Visit type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM config_visit_class WHERE feature_type=''NODE'' AND  active IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
'gwGetVisit' ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'event_id', 2, 'double', 'text', 'Event id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'visit_id', 3, 'double', 'text', 'Visit id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'visitcat_id', 4, 'integer', 'combo', 'Visit catalog:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT DISTINCT id AS id, name AS idval FROM om_visit_cat WHERE active IS TRUE',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'ext_code', 5, 'string', 'text', 'Code:',
NULL, NULL, 'Ex.: Work order code', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'parameter_id', 6, 'string', 'text', 'Parameter:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id AS id, descript AS idval FROM config_visit_parameter WHERE feature_type=''NODE''',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'event_code', 7, 'string', 'text', 'Event code:',
NULL, NULL, 'Ex.: Parameter code', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'arc_id', 8, 'double', 'text', 'Node id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'acceptbutton', 1, NULL, 'button', 'Accept',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'gwSetVisit' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'backbutton', 2, NULL, 'button', 'Back',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'backButtonClicked' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);