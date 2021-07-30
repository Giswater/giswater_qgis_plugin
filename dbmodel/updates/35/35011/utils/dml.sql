/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/07/24
INSERT INTO sys_fprocess VALUES (393, 'Check gully duplicated','ud')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess VALUES (394, 'Check topocontrol for link', 'utils')
ON CONFLICT (fid) DO NOTHING;

--2021/07/277
UPDATE config_form_fields SET dv_querytext='SELECT id AS id, a.descript AS idval FROM v_ext_streetaxis a JOIN ext_municipality m USING (muni_id) WHERE id IS NOT NULL' WHERE formtype='form_feature' AND columnname like 'streetname%';

INSERT INTO config_form_list(listname, alias, query_text, device, listtype, listclass, vdefault, filterparam)
VALUES ('arc_length_x_arccat', 'Arc length grouped by catalog','SELECT sum(gis_length), arccat_id FROM v_edit_arc GROUP BY arccat_id', 3 ,'report',
'list','{"orderBy":"1", "orderType": "DESC"}',
'[{"columnname":"arccat_id", "label":"Arc catalog:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select id as id, id as idval FROM cat_arc WHERE id IS NOT NULL"},{"columnname":"expl_id", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL"}]');

INSERT INTO config_form_list(listname, alias, query_text, device, listtype, listclass, vdefault, filterparam)
VALUES ('connec_x_expl', 'Connecs by exploitation','SELECT connec_id, code, customer_code FROM v_edit_connec ', 3 ,'report','list','{"orderBy":"1", "orderType": "DESC"}',
'[{"columnname":"expl_id", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL"}]');