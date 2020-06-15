/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/06/05

INSERT INTO config_form_fields(formname, formtype, columnname, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, 
dv_querytext, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, layoutname, tooltip, hidden)
VALUES ('ve_gully','form_feature', 'district_id', 'integer', 'combo', 'district',false, false, true, false, 
'SELECT a.district_id AS id, a.name AS idval FROM ext_district a JOIN ext_municipality m USING (muni_id) WHERE district_id IS NOT NULL ', true, 'muni_id', 'AND m.muni_id',
'lyt_data_3','district_id - Identificador del barrio con el que se vincula el elemento. A escoger entre los disponibles en el desplegable (se filtra en función del municipio seleccionado)',
true) ON CONFLICT (formname, formtype, columnname) DO NOTHING;