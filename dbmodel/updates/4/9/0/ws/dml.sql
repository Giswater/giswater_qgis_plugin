/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 20/03/2026
UPDATE config_toolbox
	SET inputparams='[
  {
    "label": "Copy from:",
    "value": null,
    "signal": "manage_duplicate_dscenario_copyfrom",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "copyFrom",
    "widgettype": "combo",
    "dvQueryText": "SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE active IS TRUE",
    "layoutorder": 1
  },
  {
    "label": "Name: (*)",
    "value": null,
    "tooltip": "Name for dscenario (mandatory)",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "name",
    "widgettype": "linetext",
    "isMandatory": true,
    "layoutorder": 2,
    "placeholder": null
  },
  {
    "label": "Descript:",
    "value": null,
    "tooltip": "Descript for dscenario",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "descript",
    "widgettype": "linetext",
    "isMandatory": false,
    "layoutorder": 3,
    "placeholder": null
  },
  {
    "label": "Type:",
    "value": null,
    "tooltip": "Dscenario type",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "type",
    "widgettype": "combo",
    "dvQueryText": "SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_dscenario''",
    "isMandatory": true,
    "layoutorder": 5
  },
  {
    "label": "Active:",
    "value": null,
    "tooltip": "If true, active",
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "active",
    "widgettype": "check",
    "layoutorder": 6
  },
  {
    "label": "Exploitation:",
    "value": null,
    "tooltip": "Dscenario type",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "expl",
    "widgettype": "combo",
    "dvQueryText": "SELECT expl_id AS id, name as idval FROM ve_exploitation WHERE expl_id > 0",
    "isNullValue": "true",
    "isMandatory": true,
    "layoutorder": 7
  }
]'::json
	WHERE id=3156;
UPDATE config_toolbox
	SET inputparams='[
  {
    "label": "Name: (*)",
    "value": null,
    "tooltip": "Name for dscenario (mandatory)",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "name",
    "widgettype": "linetext",
    "isMandatory": true,
    "layoutorder": 1,
    "placeholder": ""
  },
  {
    "label": "Descript:",
    "value": null,
    "tooltip": "Descript for dscenario",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "descript",
    "widgettype": "linetext",
    "isMandatory": false,
    "layoutorder": 2,
    "placeholder": ""
  },
  {
    "label": "Parent:",
    "value": null,
    "tooltip": "Parent for dscenario",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "parent",
    "widgettype": "combo",
    "dvQueryText": "SELECT dscenario_id as id,name as idval FROM cat_dscenario WHERE dscenario_id IS NOT NULL AND active IS TRUE",
    "isNullValue": "true",
    "isMandatory": false,
    "layoutorder": 3,
    "placeholder": ""
  },
  {
    "label": "Type:",
    "value": null,
    "tooltip": "Dscenario type",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "type",
    "widgettype": "combo",
    "dvQueryText": "SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_dscenario''",
    "isMandatory": true,
    "layoutorder": 4
  },
  {
    "label": "Active:",
    "value": null,
    "tooltip": "If true, active",
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "active",
    "widgettype": "check",
    "layoutorder": 5
  },
  {
    "label": "Exploitation:",
    "value": null,
    "tooltip": "Dscenario type",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "expl",
    "widgettype": "combo",
    "dvQueryText": "SELECT expl_id AS id, name as idval FROM ve_exploitation WHERE expl_id > 0",
    "isNullValue": "true",
    "isMandatory": true,
    "layoutorder": 6
  }
]'::json
	WHERE id=3134;

INSERT INTO inp_dscenario_demand (id, dscenario_id, feature_id, feature_type, demand, pattern_id, demand_type, source)
SELECT id, dscenario_id, feature_id, feature_type, demand, pattern_id, demand_type, source
FROM _inp_dscenario_demand_;


UPDATE config_toolbox
	SET inputparams='[
  {
    "label": "Graph class:",
    "tooltip": "Graphanalytics method used",
    "comboIds": [
      "MACROSECTOR",
      "MACROOMZONE"
    ],
    "datatype": "text",
    "comboNames": [
      "MACROSECTOR",
      "MACROOMZONE"
    ],
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "graphClass",
    "widgettype": "combo",
    "layoutorder": 1
  },
  {
    "label": "Exploitation:",
    "tooltip": "Choose exploitation to work with",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "exploitation",
    "widgettype": "combo",
    "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC",
    "layoutorder": 2
  },
  {
    "label": "Commit changes:",
    "value": null,
    "tooltip": "If true, changes will be applied to DB. If false, algorithm results will be showed in a temporal layer",
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "widgetname": "commitChanges",
    "widgettype": "check",
    "layoutorder": 8
  },
  {
    "label": "Mapzone constructor method:",
    "comboIds": [
      0,
      1,
      2,
      3,
      4
    ],
    "datatype": "integer",
    "comboNames": [
      "NONE",
      "CONCAVE POLYGON",
      "PIPE BUFFER",
      "PLOT & PIPE BUFFER",
      "LINK & PIPE BUFFER"
    ],
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "updateMapZone",
    "widgettype": "combo",
    "layoutorder": 10
  },
  {
    "label": "Pipe buffer",
    "value": null,
    "tooltip": "Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.",
    "datatype": "float",
    "layoutname": "grl_option_parameters",
    "widgetname": "geomParamUpdate",
    "widgettype": "text",
    "isMandatory": false,
    "layoutorder": 11,
    "placeholder": "5-30"
  }
]'::json
	WHERE id=3482;


-- 26/03/2026
UPDATE sys_fprocess
SET query_text='SELECT node_id, nodecat_id, n.the_geom, n.expl_id FROM man_valve mv JOIN t_node n USING (node_id) JOIN t_arc v ON v.arc_id = mv.to_arc WHERE node_id NOT IN (node_1, node_2)'
WHERE fid=170;
UPDATE sys_fprocess
SET query_text='SELECT node_id, nodecat_id, n.the_geom, n.expl_id FROM man_pump mp JOIN t_node n USING (node_id) JOIN t_arc v ON v.arc_id = mp.to_arc WHERE node_id NOT IN (node_1, node_2)'
WHERE fid=171;

-- 31/03/2026
UPDATE config_form_fields
SET dv_querytext='SELECT expl_id as id, name as idval FROM ve_exploitation WHERE expl_id > 0'
WHERE formname='ve_cat_dscenario' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_none';

-- 02/04/2026
UPDATE config_form_fields SET columnname='name' WHERE formname='plan_netscenario_presszone' AND formtype='form_feature' AND columnname='presszone_name' AND tabname='tab_none';

DELETE FROM config_form_fields WHERE formname='plan_netscenario_presszone' AND formtype='form_feature' AND columnname='lastupdate' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='plan_netscenario_presszone' AND formtype='form_feature' AND columnname='lastupdate_user' AND tabname='tab_none';

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,isparent,iseditable,isautoupdate,isfilter,hidden)
VALUES ('plan_netscenario_presszone','form_feature','tab_none','code','lyt_data_1',3,'string','text','Code:','Code:',false,true,false,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,isparent,iseditable,isautoupdate,isfilter,hidden)
VALUES ('plan_netscenario_presszone','form_feature','tab_none','descript','lyt_data_1',5,'string','text','Descript','Descript',false,true,false,false,false);

UPDATE config_form_fields SET layoutorder=2,ismandatory=true WHERE formname='plan_netscenario_presszone' AND formtype='form_feature' AND columnname='presszone_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=6 WHERE formname='plan_netscenario_presszone' AND formtype='form_feature' AND columnname='head' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=7 WHERE formname='plan_netscenario_presszone' AND formtype='form_feature' AND columnname='graphconfig' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=8 WHERE formname='plan_netscenario_presszone' AND formtype='form_feature' AND columnname='active' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=9 WHERE formname='plan_netscenario_presszone' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=10 WHERE formname='plan_netscenario_presszone' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=11 WHERE formname='plan_netscenario_presszone' AND formtype='form_feature' AND columnname='muni_id' AND tabname='tab_none';

UPDATE config_form_fields SET columnname='name' WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='dma_name' AND tabname='tab_none';

DELETE FROM config_form_fields WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='lastupdate' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='lastupdate_user' AND tabname='tab_none';

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,isparent,iseditable,isautoupdate,isfilter,hidden)
VALUES ('plan_netscenario_dma','form_feature','tab_none','code','lyt_data_1',3,'string','text','Code:','Code:',false,true,false,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,isparent,iseditable,isautoupdate,isfilter,hidden)
VALUES ('plan_netscenario_dma','form_feature','tab_none','descript','lyt_data_1',5,'string','text','Descript','Descript',false,true,false,false,false);

UPDATE config_form_fields SET layoutorder=2,ismandatory=true WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='dma_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=6 WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=7 WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='graphconfig' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=8 WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='active' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=9 WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=10 WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=11 WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='muni_id' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext='SELECT fluid_type AS id, fluid_type AS idval FROM man_type_fluid WHERE active AND (featurecat_id IS NULL AND ''ARC''=ANY(feature_type))' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT fluid_type AS id, fluid_type AS idval FROM man_type_fluid WHERE active AND (featurecat_id IS NULL AND ''CONNEC''=ANY(feature_type))' WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT fluid_type AS id, fluid_type AS idval FROM man_type_fluid WHERE active AND (featurecat_id IS NULL AND ''ELEMENT''=ANY(feature_type))' WHERE formname='ve_element' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT fluid_type AS id, fluid_type AS idval FROM man_type_fluid WHERE active AND (featurecat_id IS NULL AND ''NODE''=ANY(feature_type))' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';

DELETE FROM config_param_user WHERE "parameter"='inp_options_selecteddma' AND cur_user='postgres';
DELETE FROM config_param_user WHERE "parameter"='inp_options_demand_weight_factor' AND cur_user='postgres';
DELETE FROM config_param_user WHERE "parameter"='edit_municipality_vdefault';
DELETE FROM sys_param_user WHERE id = 'inp_options_demand_weight_factor';

INSERT INTO sys_param_user (id,formname,descript,sys_role,"label",isenabled,layoutorder,project_type,isparent,isautoupdate,"datatype",widgettype,ismandatory,vdefault,layoutname,iseditable,"source")
	VALUES ('epa_dscenario_percent_hydro_threshold','epaoptions','Dscenario percent hydro threshold','role_epa','Percent hydro threshold:',true,9,'ws',false,false,'integer','text',true,'10','lyt_general_2',true,'core');

UPDATE config_form_fields
SET dv_querytext='SELECT crmzone_id AS id, name AS idval FROM crmzone WHERE crmzone_id IS NOT NULL AND active'
WHERE formname ILIKE 've_connec%' AND formtype='form_feature' AND columnname='crmzone_id' AND tabname='tab_data';

INSERT INTO sys_table (id,descript,sys_role,"source")
VALUES ('dma_graph_meter','Table to manage graph for dma','role_edit','core');
INSERT INTO sys_table (id,descript,sys_role,"source")
VALUES ('dma_graph_object','Table to manage graph for dma','role_edit','core');
INSERT INTO sys_table (id,descript,sys_role,"source")
VALUES ('presszone_graph','Table to manage graph for presszone','role_edit','core');

-- 09/04/2026
WITH connec_customer AS (
    SELECT rxc.hydrometer_id,
        MIN(c.customer_code) AS customer_code
    FROM rtc_hydrometer_x_connec rxc
    JOIN connec c ON c.connec_id = rxc.connec_id
    WHERE c.customer_code IS NOT NULL
    GROUP BY rxc.hydrometer_id
), node_customer AS (
    SELECT rxn.hydrometer_id,
        MIN(mn.customer_code) AS customer_code
    FROM rtc_hydrometer_x_node rxn
    JOIN man_netwjoin mn ON mn.node_id = rxn.node_id
    WHERE mn.customer_code IS NOT NULL
    GROUP BY rxn.hydrometer_id
)
UPDATE ext_rtc_hydrometer h
SET customer_code = COALESCE(cc.customer_code, nc.customer_code)
FROM connec_customer cc
FULL OUTER JOIN node_customer nc ON nc.hydrometer_id = cc.hydrometer_id
WHERE h.hydrometer_id = COALESCE(cc.hydrometer_id, nc.hydrometer_id);

DROP TABLE IF EXISTS rtc_hydrometer_x_node;
DROP TABLE IF EXISTS rtc_hydrometer_x_connec;


UPDATE config_form_fields SET layoutorder = layoutorder+1 WHERE layoutname = 'lyt_epa_data_2' AND formname IN ('ve_epa_valve', 've_epa_shortpipe', 've_epa_pump', 've_epa_pump_additional');

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, iseditable) VALUES('ve_epa_pump', 'form_feature', 'tab_epa', 'nodarc_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Nodarc id:', 'Nodarc id', false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, iseditable) VALUES('ve_epa_pump_additional', 'form_feature', 'tab_epa', 'nodarc_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Nodarc id:', 'Nodarc id', false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, iseditable) VALUES('ve_epa_shortpipe', 'form_feature', 'tab_epa', 'nodarc_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Nodarc id:', 'Nodarc id', false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, iseditable) VALUES('ve_epa_valve', 'form_feature', 'tab_epa', 'nodarc_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Nodarc id:', 'Nodarc id', false) ON CONFLICT DO NOTHING;
