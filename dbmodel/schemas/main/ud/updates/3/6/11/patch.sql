/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"expl_id2", "dataType":"integer"}}$$);

CREATE OR REPLACE VIEW v_edit_dma
AS SELECT dma.dma_id,
    dma.name,
    dma.macrodma_id,
    dma.descript,
    dma.the_geom,
    dma.undelete,
    dma.expl_id,
    dma.pattern_id,
    dma.link,
    dma.minc,
    dma.maxc,
    dma.effc,
    dma.active,
    dma.stylesheet,
    dma.expl_id2
   FROM selector_expl,
    dma
  WHERE (dma.expl_id = selector_expl.expl_id OR dma.expl_id2 = selector_expl.expl_id) AND selector_expl.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_parent_arc;
DELETE FROM sys_table WHERE id = 'vi_parent_arc';

DROP VIEW IF EXISTS v_anl_flow_arc;
DROP VIEW IF EXISTS v_anl_flow_node;
DROP VIEW IF EXISTS v_anl_flow_connec;
DROP VIEW IF EXISTS v_anl_flow_gully;
DELETE FROM sys_table WHERE id IN ('v_anl_flow_arc','v_anl_flow_node','v_anl_flow_connec','v_anl_flow_gully');

UPDATE config_param_system set 
value = '{"arc": "SELECT arc_id AS arc_id, concat(v_edit_arc.matcat_id,''-Ø'',(c.geom1*100)::integer) as catalog, (case when slope is not null then concat((100*slope)::numeric(12,2),'' % / '',gis_length::numeric(12,2),''m'') else concat(''None / '',gis_length::numeric(12,2),''m'') end) as dimensions , arc_id as code FROM v_edit_arc JOIN cat_arc c ON id = arccat_id", "node": "SELECT node_id AS node_id, code AS code FROM v_edit_node"}'
where parameter = 'om_profile_guitartext';


UPDATE sys_table SET addparam='{"pkey":"hydrology_id"}'::json WHERE id='v_edit_cat_hydrology';


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_connec_connec', 'form_feature', 'tab_data', 'plot_code', 'lyt_data_2', 44, 'string', 'text', 'plot_code', 'plot_code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_connec_vconnec', 'form_feature', 'tab_data', 'plot_code', 'lyt_data_2', 44, 'string', 'text', 'plot_code', 'plot_code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


UPDATE sys_param_user SET "label"='End date' WHERE id='inp_options_end_date';

DROP TRIGGER gw_trg_link_data ON connec;
CREATE TRIGGER gw_trg_link_data
AFTER UPDATE OF state_type, expl_id2, connecat_id, fluid_type
ON connec FOR EACH ROW  EXECUTE PROCEDURE gw_trg_link_data('connec');

DROP TRIGGER gw_trg_link_data ON gully;
CREATE TRIGGER gw_trg_link_data
AFTER UPDATE OF epa_type, state_type, expl_id2, connec_arccat_id, fluid_type
ON gully  FOR EACH ROW  EXECUTE PROCEDURE gw_trg_link_data('gully');
