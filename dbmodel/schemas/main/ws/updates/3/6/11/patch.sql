/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_cat_feature_node ON cat_feature_node;

CREATE TABLE _inp_shortpipe_ AS SELECT * FROM inp_shortpipe;

INSERT INTO config_graph_checkvalve SELECT node_id, to_arc 
FROM inp_shortpipe WHERE to_arc IS NOT NULL
ON CONFLICT (node_id) DO NOTHING;

ALTER TABLE IF EXISTS config_graph_inlet RENAME TO config_graph_mincut;

ALTER TABLE config_graph_mincut DROP CONSTRAINT config_graph_inlet_pkey;
ALTER TABLE config_graph_mincut ADD CONSTRAINT config_graph_mincut_pkey PRIMARY KEY (node_id);
ALTER TABLE config_graph_mincut DROP CONSTRAINT config_graph_inlet_expl_id_fkey;
ALTER TABLE config_graph_mincut DROP COLUMN expl_id;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dqa", "column":"avg_press", "dataType":"float"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"presszone", "column":"presszone_type", "dataType":"text"}}$$);
ALTER TABLE presszone ADD CONSTRAINT presszone_presszone_type_check CHECK (presszone_type::text=ANY 
(ARRAY['BUSTER','TANK','PRV','PSV','PUMP','UNDEFINED']));

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_presszone", "column":"presszone_type", "dataType":"text"}}$$);
ALTER TABLE plan_netscenario_presszone ADD CONSTRAINT plan_netscenario_presszone_presszone_type_check CHECK (presszone_type::text=ANY 
(ARRAY['BUSTER','TANK','PRV','PSV','PUMP','UNDEFINED']));

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_dma", "column":"stylesheet", "dataType":"json"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_presszone", "column":"stylesheet", "dataType":"json"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"expl_id2", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dqa", "column":"expl_id2", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"presszone", "column":"expl_id2", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_dma", "column":"expl_id2", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_presszone", "column":"expl_id2", "dataType":"integer"}}$$);

alter table rtc_hydrometer_x_connec add constraint rtc_hydrometer_x_connec_unique unique (connec_id, hydrometer_id);

-- deprecate config_graph_valve;
UPDATE cat_feature_node SET graph_delimiter = 'MINSECTOR' where id IN (SELECT id from config_graph_valve where active is true);
alter table config_graph_valve rename to _config_graph_valve_ ;
drop view v_om_mincut_selected_valve;

-- harmonize check_valve
UPDATE cat_feature_node SET graph_delimiter = 'MINSECTOR' WHERE id IN (SELECT f.id FROM node n JOIN cat_node c ON nodecat_id = id JOIN cat_feature_node f ON f.id = c.nodetype_id JOIN config_graph_checkvalve USING (node_id));

-- SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"systemId":"METER"},
--  "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-UPDATE", "newColumn":"meter_code" }}$$);


CREATE OR REPLACE VIEW v_edit_inp_shortpipe AS
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    concat(n.node_id, '_n2a') AS nodarc_id,
    inp_shortpipe.minorloss,
    c.to_arc,
    CASE WHEN c.node_id is not null THEN 'CV'::varchar(12) when v.closed is true THEN 'CLOSED'::varchar(12)
	when v.closed is false THEN 'OPEN'::varchar(12) ELSE NULL::varchar(12) END status,
    inp_shortpipe.bulk_coeff,
    inp_shortpipe.wall_coeff,
    n.the_geom
   FROM selector_sector,
    v_node n
     JOIN inp_shortpipe USING (node_id)
     LEFT JOIN config_graph_checkvalve c ON c.node_id = n.node_id
     LEFT JOIN man_valve v ON v.node_id = n.node_id
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND n.is_operative IS TRUE;


CREATE OR REPLACE VIEW ve_epa_shortpipe AS
 SELECT inp_shortpipe.node_id,
    inp_shortpipe.minorloss,
    c.to_arc,
        CASE
            WHEN c.node_id IS NOT NULL THEN 'CV'::character varying(12)
            WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
            WHEN v.closed IS FALSE THEN 'OPEN'::character varying(12)
            ELSE NULL::character varying(12)
        END AS status,
    inp_shortpipe.bulk_coeff,
    inp_shortpipe.wall_coeff,
    concat(inp_shortpipe.node_id, '_n2a') AS nodarc_id,
    v_rpt_arc.result_id,
    v_rpt_arc.flow_max AS flowmax,
    v_rpt_arc.flow_min AS flowmin,
    v_rpt_arc.flow_avg AS flowavg,
    v_rpt_arc.vel_max AS velmax,
    v_rpt_arc.vel_min AS velmin,
    v_rpt_arc.vel_avg AS velavg,
    v_rpt_arc.headloss_max,
    v_rpt_arc.headloss_min,
    v_rpt_arc.setting_max,
    v_rpt_arc.setting_min,
    v_rpt_arc.reaction_max,
    v_rpt_arc.reaction_min,
    v_rpt_arc.ffactor_max,
    v_rpt_arc.ffactor_min
   FROM inp_shortpipe
     LEFT JOIN v_rpt_arc ON concat(inp_shortpipe.node_id, '_n2a') = v_rpt_arc.arc_id::text
     LEFT JOIN config_graph_checkvalve c ON c.node_id::text = inp_shortpipe.node_id::text
     LEFT JOIN man_valve v ON v.node_id::text = inp_shortpipe.node_id::text;


INSERT INTO config_graph_checkvalve SELECT node_id, to_arc, true FROM inp_shortpipe WHERE status = 'CV'
ON CONFLICT (node_id) DO NOTHING;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_shortpipe", "column":"status"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_shortpipe", "column":"to_arc"}}$$);

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
    dma.graphconfig::text AS graphconfig,
    dma.stylesheet::text AS stylesheet,
    dma.active,
    dma.avg_press,
    dma.expl_id2
   FROM selector_expl,
    dma
  WHERE (dma.expl_id = selector_expl.expl_id OR dma.expl_id2 = selector_expl.expl_id) AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_dqa
AS SELECT dqa.dqa_id,
    dqa.name,
    dqa.expl_id,
    dqa.macrodqa_id,
    dqa.descript,
    dqa.undelete,
    dqa.the_geom,
    dqa.pattern_id,
    dqa.dqa_type,
    dqa.link,
    dqa.graphconfig::text AS graphconfig,
    dqa.stylesheet::text AS stylesheet,
    dqa.active,
    dqa.avg_press,
    dqa.expl_id2
   FROM selector_expl,
    dqa
  WHERE (dqa.expl_id = selector_expl.expl_id OR dqa.expl_id2 = selector_expl.expl_id) AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_presszone
AS SELECT presszone.presszone_id,
    presszone.name,
    presszone.expl_id,
    presszone.the_geom,
    presszone.graphconfig::text AS graphconfig,
    presszone.head,
    presszone.stylesheet::text AS stylesheet,
    presszone.active,
    presszone.descript,
    presszone.avg_press,
    presszone.presszone_type,
    presszone.expl_id2
   FROM selector_expl,
    presszone
  WHERE (presszone.expl_id = selector_expl.expl_id OR presszone.expl_id2 = selector_expl.expl_id) AND selector_expl.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_edit_plan_netscenario_dma
AS SELECT n.netscenario_id,
    p.name AS netscenario_name,
    n.dma_id,
    n.dma_name AS name,
    n.pattern_id,
    n.graphconfig,
    n.the_geom,
    n.active,
    n.stylesheet::text AS stylesheet,
    n.expl_id2
   FROM selector_netscenario,
    plan_netscenario_dma n
     JOIN plan_netscenario p USING (netscenario_id)
  WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_plan_netscenario_presszone
AS SELECT n.netscenario_id,
    p.name AS netscenario_name,
    n.presszone_id,
    n.presszone_name AS name,
    n.head,
    n.graphconfig,
    n.the_geom,
    n.active,
    n.presszone_type,
    n.stylesheet::text AS stylesheet,
    n.expl_id2
   FROM selector_netscenario,
    plan_netscenario_presszone n
     JOIN plan_netscenario p USING (netscenario_id)
  WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_netscenario_connec
AS
SELECT n.netscenario_id,
    n.connec_id,
    n.presszone_id,
    n.staticpressure,
    n.dma_id,
    n.pattern_id,
    n.the_geom,
    c.connecat_id,
    cc.connectype_id as connec_type,
	c.epa_type,
	c.state,
	c.state_type
   FROM selector_netscenario,
    plan_netscenario_connec n
   left JOIN connec c using (connec_id)
   left JOIN cat_connec cc on cc.id = c.connecat_id
  WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_netscenario_node
AS
SELECT n.netscenario_id,
    n.node_id,
    n.presszone_id,
    n.staticpressure,
    n.dma_id,
    n.pattern_id,
    n.the_geom,
    nd.nodecat_id,
    cn.nodetype_id as node_type,
    nd.epa_type,
    nd.state,
    nd.state_type
   FROM selector_netscenario,
    plan_netscenario_node n
   LEFT JOIN node nd using (node_id)
   LEFT JOIN cat_node cn on nd.nodecat_id = cn.id
  WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_netscenario_arc
AS
SELECT n.netscenario_id,
    n.arc_id,
    n.presszone_id,
    n.dma_id,
    n.the_geom,
    a.arccat_id,
	a.epa_type,
	a.state,
	a.state_type
   FROM selector_netscenario,
    plan_netscenario_arc n
   LEFT JOIN arc a using (arc_id)
  WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3308, 'gw_fct_create_full_network_dscenario', 'ws', 'function', 'json', 'json', 'Function to create full network dscenario', 'role_epa', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device)
VALUES(3308, 'Create full Network dscenario', '{"featureType":[]}'::json, '[
{"widgetname":"name", "label":"Name:","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name of the new dscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"descript", "label":"descript:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"descript of new scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"dwf scenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":3, "value":null}
]'::json, NULL, true, '{4}')
ON CONFLICT (id) DO  NOTHING;

UPDATE config_form_fields SET iseditable=false, widgettype='text', dv_querytext=null where columnname = 'status' and formname IN ('v_edit_inp_shortpipe','ve_epa_shortpipe');

ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
DELETE FROM inp_typevalue WHERE typevalue in ('inp_value_status_shortpipe');
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source") VALUES(3262, 'Invalid value for a presszone_id', 'Please, use an integer as the presszone_id', 2, true, 'utils', 'core') on conflict (id) do nothing;

DELETE FROM sys_table where id IN ('config_graph_valve','v_om_mincut_selected_valve');

UPDATE config_toolbox SET inputparams =
'[{"widgetname":"exploitation", "label":"Exploitation id:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layoutorder":1, "placeholder":"1,2", "value":""}, 
{"widgetname":"usePsectors", "label":"Use masterplan psectors:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":6, "value":""}, 
{"widgetname":"commitChanges", "label":"Commit changes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":7, "value":""}, 
{"widgetname":"updateMapZone", "label":"Update mapzone geometry method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":8,"comboIds":[0,1,2,3], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER"], "selectedId":""}, 
{"widgetname":"geomParamUpdate", "label":"Geometry parameter:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layoutorder":10, "isMandatory":false, "placeholder":"5-30", "value":""}
]'
WHERE id = 2706;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_plan_netscenario_dma', 'form_feature', 'tab_none', 'stylesheet', 'lyt_data_1', 8, 'text', 'text', 'stylesheet', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_plan_netscenario_presszone', 'form_feature', 'tab_none', 'stylesheet', 'lyt_data_1', 8, 'text', 'text', 'stylesheet', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_dqa', 'form_feature', 'tab_data', 'expl_id2', 'lyt_data_1', 13, 'string', 'combo', 'expl_id2', 'expl_id2', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id is not null ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_presszone', 'form_feature', 'tab_data', 'expl_id2', 'lyt_data_1', 9, 'string', 'combo', 'expl_id2', 'expl_id2', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id is not null ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_plan_netscenario_dma', 'form_feature', 'tab_data', 'expl_id2', 'lyt_data_1', 9, 'string', 'combo', 'expl_id2', 'expl_id2', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id is not null ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_plan_netscenario_presszone', 'form_feature', 'tab_data', 'expl_id2', 'lyt_data_1', 9, 'string', 'combo', 'expl_id2', 'expl_id2', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id is not null ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_presszone', 'form_feature', 'tab_data', 'presszone_type', 'lyt_data_1', 10, 'string', 'combo', 'presszone_type', 'presszone_type', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''presszone_type'' ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_plan_netscenario_presszone', 'form_feature', 'tab_data', 'presszone_type', 'lyt_data_1', 11, 'string', 'combo', 'presszone_type', 'presszone_type', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''presszone_type'' ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_dqa', 'form_feature', 'tab_data', 'avg_press', 'lyt_data_1', 14, 'numeric', 'text', 'avg_press', 'avg_press', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_connec_fountain', 'form_feature', 'tab_data', 'plot_code', 'lyt_data_2', 58, 'string', 'text', 'plot_code', 'plot_code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_connec_tap', 'form_feature', 'tab_data', 'plot_code', 'lyt_data_2', 58, 'string', 'text', 'plot_code', 'plot_code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_connec_wjoin', 'form_feature', 'tab_data', 'plot_code', 'lyt_data_2', 58, 'string', 'text', 'plot_code', 'plot_code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_connec_greentap', 'form_feature', 'tab_data', 'plot_code', 'lyt_data_2', 58, 'string', 'text', 'plot_code', 'plot_code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_connec_vconnec', 'form_feature', 'tab_data', 'plot_code', 'lyt_data_2', 58, 'string', 'text', 'plot_code', 'plot_code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_function
	SET "style"='{"style": {"point": {"style": "categorized", "field": "descript", "transparency": 0.5, "width": 2.5, "values": [{"id": "Disconnected", "color": [255, 124, 64]}, {"id": "Conflict", "color": [14, 206, 253]}]},"line": {"style": "categorized","field": "descript","transparency": 0.5,"width": 2.5,"values": [{"id": "Disconnected","color": [255,124,64]},{"id": "Conflict","color": [14,206,253]}]},"polygon": {"style": "categorized","field": "mapzone_id","transparency": 0.5}}}'::json
	WHERE id=2710;

ALTER TABLE config_graph_checkvalve ADD CONSTRAINT config_graph_checkvalve_to_arc_fkey FOREIGN KEY (to_arc)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

DROP TRIGGER gw_trg_link_data ON connec;
CREATE TRIGGER gw_trg_link_data
AFTER UPDATE OF epa_type, state_type, expl_id2, connecat_id, fluid_type
ON connec FOR EACH ROW EXECUTE PROCEDURE gw_trg_link_data('connec');
