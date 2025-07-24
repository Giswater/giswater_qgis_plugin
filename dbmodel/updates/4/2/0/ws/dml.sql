/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 03/07/2025
UPDATE config_toolbox SET inputparams='[
  {
    "widgetname": "graphClass",
    "label": "Graph class:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Graphanalytics method used",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "comboIds": [
      "PRESSZONE",
      "DQA",
      "DMA",
      "SECTOR"
    ],
    "comboNames": [
      "Pressure Zonification (PRESSZONE)",
      "District Quality Areas (DQA) ",
      "District Metering Areas (DMA)",
      "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"
    ],
    "selectedId": null
  },
  {
    "widgetname": "exploitation",
    "label": "Exploitation:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Choose exploitation to work with",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC",
    "selectedId": null
  },
  {
    "widgetname": "forceOpen",
    "label": "Force open nodes: (*)",
    "widgettype": "linetext",
    "datatype": "text",
    "isMandatory": false,
    "tooltip": "Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there",
    "placeholder": "1015,2231,3123",
    "layoutname": "grl_option_parameters",
    "layoutorder": 5,
    "value": null
  },
  {
    "widgetname": "forceClosed",
    "label": "Force closed nodes: (*)",
    "widgettype": "text",
    "datatype": "text",
    "isMandatory": false,
    "tooltip": "Optative node id(s) to temporary close open node(s) to force algorithm to stop there",
    "placeholder": "1015,2231,3123",
    "layoutname": "grl_option_parameters",
    "layoutorder": 6,
    "value": null
  },
  {
    "widgetname": "usePlanPsector",
    "label": "Use selected psectors:",
    "widgettype": "check",
    "datatype": "boolean",
    "tooltip": "If true, use selected psectors. If false ignore selected psectors and only works with on-service network",
    "layoutname": "grl_option_parameters",
    "layoutorder": 7,
    "value": null
  },
  {
    "widgetname": "commitChanges",
    "label": "Commit changes:",
    "widgettype": "check",
    "datatype": "boolean",
    "tooltip": "If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables",
    "layoutname": "grl_option_parameters",
    "layoutorder": 8,
    "value": null
  },
  {
    "widgetname": "updateMapZone",
    "label": "Mapzone constructor method:",
    "widgettype": "combo",
    "datatype": "integer",
    "layoutname": "grl_option_parameters",
    "layoutorder": 10,
    "comboIds": [
      0,
      1,
      2,
      3,
      4
    ],
    "comboNames": [
      "NONE",
      "CONCAVE POLYGON",
      "PIPE BUFFER",
      "PLOT & PIPE BUFFER",
      "LINK & PIPE BUFFER"
    ],
    "selectedId": null
  },
  {
    "widgetname": "geomParamUpdate",
    "label": "Pipe buffer",
    "widgettype": "text",
    "datatype": "float",
    "tooltip": "Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.",
    "layoutname": "grl_option_parameters",
    "layoutorder": 11,
    "isMandatory": false,
    "placeholder": "5-30",
    "value": null
  },
  {
    "widgetname": "fromZero",
    "label": "Mapzones from zero:",
    "widgettype": "check",
    "datatype": "boolean",
    "tooltip": "If true, mapzones are calculated automatically from zero",
    "layoutname": "grl_option_parameters",
    "layoutorder": 12,
    "value": null
  }
]'::json WHERE id=2768;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) VALUES(3482, 'Macromapzones analysis', '{"featureType":[]}'::json, '[
  {
    "widgetname": "graphClass",
    "label": "Graph class:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Graphanalytics method used",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "comboIds": [
      "MACROSECTOR",
      "MACRODMA",
      "MACRODQA",
      "MACROOMZONE"
    ],
    "comboNames": [
      "MACROSECTOR",
      "MACRODMA",
      "MACRODQA",
      "MACROOMZONE"
    ],
    "selectedId": null
  },
  {
    "widgetname": "exploitation",
    "label": "Exploitation:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Choose exploitation to work with",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC",
    "selectedId": null
  },
  {
    "widgetname": "commitChanges",
    "label": "Commit changes:",
    "widgettype": "check",
    "datatype": "boolean",
    "tooltip": "If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables",
    "layoutname": "grl_option_parameters",
    "layoutorder": 8,
    "value": null
  },
  {
    "widgetname": "updateMapZone",
    "label": "Mapzone constructor method:",
    "widgettype": "combo",
    "datatype": "integer",
    "layoutname": "grl_option_parameters",
    "layoutorder": 10,
    "comboIds": [
      0,
      1,
      2,
      3,
      4
    ],
    "comboNames": [
      "NONE",
      "CONCAVE POLYGON",
      "PIPE BUFFER",
      "PLOT & PIPE BUFFER",
      "LINK & PIPE BUFFER"
    ],
    "selectedId": null
  },
  {
    "widgetname": "geomParamUpdate",
    "label": "Pipe buffer",
    "widgettype": "text",
    "datatype": "float",
    "tooltip": "Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.",
    "layoutname": "grl_option_parameters",
    "layoutorder": 11,
    "isMandatory": false,
    "placeholder": "5-30",
    "value": null
  }
]'::json, NULL, true, '{4}');

-- 07/07/2025
UPDATE config_param_system
	SET value='{"status":false, "values":[
{"sourceTable":"inp_tank", "query":"UPDATE man_tank t SET hmax=maxlevel FROM inp_tank s "},
{"sourceTable":"inp_valve", "query":"UPDATE man_valve t SET pressure_exit=pressure FROM inp_valve s "}]}'
	WHERE "parameter"='epa_automatic_inp2man_values';

UPDATE config_form_fields SET columnname='staticpressure1' WHERE formname ILIKE '%arc%' AND columnname='staticpress1';
UPDATE config_form_fields SET columnname='staticpressure2' WHERE formname ILIKE '%arc%' AND columnname='staticpress2';
UPDATE config_form_fields SET columnname='pressure_exit' WHERE formname ILIKE '%valve%' AND columnname='pression_exit';
UPDATE config_form_fields SET columnname='pressure_entry' WHERE formname ILIKE '%valve%' AND columnname='pression_entry';
UPDATE config_form_fields SET columnname='pressure_exit' WHERE formname ILIKE '%pump%' AND columnname='pressure';
UPDATE config_form_fields SET columnname='staticpressure1' WHERE formname ILIKE '%link%' AND columnname='staticpressure';


INSERT INTO sys_param_user (id, formname, descript, sys_role, idval, "label", dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, "source") VALUES('edit_nodetype_vdefault', 'config', 'Default type for node when parent layer (v_edit_node) is used', 'role_edit', NULL, 'Default type for node (parent layer):', 'SELECT id AS id, id AS idval FROM cat_feature_node JOIN cat_feature USING (id) WHERE id IS NOT NULL AND cat_feature.active IS TRUE', NULL, true, 1, 'ws', false, NULL, 'node_type', NULL, false, 'string', 'combo', false, NULL, NULL, 'lyt_node', true, NULL, NULL, NULL, NULL, 'core');

-- 24/07/2025
UPDATE sys_table SET alias='Catalog for elements' WHERE id='v_edit_cat_feature_element';
UPDATE sys_table SET alias='Catalog of arc shapes'  WHERE id='cat_arc_shape';
