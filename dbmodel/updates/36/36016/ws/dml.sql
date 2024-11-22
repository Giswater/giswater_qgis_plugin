/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE config_form_fields SET widgettype  ='text', dv_querytext = null WHERE columnname = 'status' 
AND formname IN ('v_edit_inp_valve','ve_epa_valve','ve_epa_shortpipe','v_edit_inp_shortpipe');

UPDATE config_form_fields SET widgettype  ='text', dv_querytext = null WHERE columnname = 'status' 
AND formname IN ('v_edit_inp_valve','ve_epa_valve','ve_epa_shortpipe','v_edit_inp_shortpipe');

update rpt_cat_result r set sector_id = a.sector_id from
(select array_agg(distinct a.sector_id) as sector_id, a.result_id from rpt_inp_arc a group by result_id) a
where a.result_id = r.result_id and r.sector_id is null;

update rpt_cat_result r set expl_id = a.expl_id from
(select array_agg(distinct a.expl_id) as expl_id, r.result_id from arc a join rpt_cat_result r on a.sector_id=any(r.sector_id) group by  result_id) a
where a.result_id = r.result_id and r.expl_id is null;

update rpt_cat_result set network_type = 1 where network_type is null;

ALTER TABLE macroexploitation ADD the_geom public.geometry(multipolygon, SRID_VALUE) NULL;

INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('v_om_mincut_current_arc', 'View for current mincuts', 'role_basic', 'core') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('v_om_mincut_current_node', 'View for current mincuts', 'role_basic', 'core') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('v_om_mincut_current_connec', 'View for current mincuts', 'role_basic', 'core') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('v_om_mincut_current_hydrometer', 'View for current mincuts', 'role_basic', 'core') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('v_om_mincut_current_initpoint', 'View for current mincuts', 'role_basic', 'core') 
ON CONFLICT (id) DO NOTHING;