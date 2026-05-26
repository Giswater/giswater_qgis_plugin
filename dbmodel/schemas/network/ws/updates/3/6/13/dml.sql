/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_fields set columnname = 'cat_matcat_id', label = 'Material:', tooltip = 'Material' 
WHERE formname in ('ve_epa_pipe', 'v_edit_inp_pipe') and columnname = 'cat_roughness';

INSERT INTO config_form_fields ( formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, hidden)
SELECT formname, formtype, tabname, 'builtdate', layoutname, 18, datatype, widgettype, 'Builtdate', 'Builtdate', 'Builtdate', ismandatory, isparent, iseditable, isautoupdate, hidden FROM config_form_fields where formname in('v_edit_inp_pipe') and columnname = 'cat_matcat_id';

UPDATE config_form_fields SET layoutorder = layoutorder+3 WHERE layoutorder > 3 AND formname = 've_epa_pipe';

INSERT INTO config_form_fields ( formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, hidden)
SELECT formname, formtype, tabname, 'builtdate', layoutname, 4, datatype, widgettype, 'Builtdate', 'Builtdate', 'Builtdate', ismandatory, isparent, iseditable, isautoupdate, hidden FROM config_form_fields where formname in('ve_epa_pipe')
 and columnname = 'cat_matcat_id';

INSERT INTO config_form_fields ( formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, hidden)
SELECT formname, formtype, tabname, 'cat_roughness', layoutname, 5, datatype, widgettype, 'Cat roughness', 'Cat roughness', 'Cat roughness', ismandatory, isparent, iseditable, isautoupdate, hidden FROM config_form_fields where formname in('ve_epa_pipe')
 and columnname = 'cat_matcat_id';