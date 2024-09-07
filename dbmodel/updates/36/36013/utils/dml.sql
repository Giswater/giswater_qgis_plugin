/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

DELETE FROM config_form_fields WHERE formname='visit_arc_leak' AND formtype='form_visit' AND columnname='visit_id' AND tabname='tab_data';
DELETE FROM config_form_fields WHERE formname='visit_node_insp' AND formtype='form_visit' AND columnname='visit_id' AND tabname='tab_data';
DELETE FROM config_form_fields WHERE formname='incident_node' AND formtype='form_visit' AND columnname='visit_id' AND tabname='tab_data';

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
    VALUES('generic', 'form_visit', 'tab_data', 'visit_id', 'lyt_data_1', NULL, 'double', 'text', 'Visit id:', NULL, NULL, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);

UPDATE config_form_fields SET web_layoutorder=2 WHERE formname='visit_connec_leak' AND formtype='form_visit' AND columnname='class_id' AND tabname='tab_data';
UPDATE config_form_fields SET web_layoutorder=2 WHERE formname='incident_node' AND formtype='form_visit' AND columnname='class_id' AND tabname='tab_data';
UPDATE config_form_fields SET web_layoutorder=2 WHERE formname='visit_arc_leak' AND formtype='form_visit' AND columnname='class_id' AND tabname='tab_data';
UPDATE config_form_fields SET web_layoutorder=2 WHERE formname='visit_node_insp' AND formtype='form_visit' AND columnname='class_id' AND tabname='tab_data';
