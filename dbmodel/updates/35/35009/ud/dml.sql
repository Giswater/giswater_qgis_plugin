/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/06/21
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_arc','form_feature', 'main', 'geom_r',null,null,'string', 'text','geom_r',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_arc','form_feature', 'main', 'arc_type',null,null,'string', 'combo','arc_type',null, false,
false, true, false,false, 'SELECT id, id AS idval FROM cat_feature_arc WHERE id IS NOT NULL ', true, true,null, null, null, null,null, null, false) 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields set widgettype='text', datatype='double', iseditable=true WHERE formname='cat_arc', label=columnname 
WHERE columnname in ('geom1','geom2','geom3','geom4','geom5','geom6','geom7','geom8'); 