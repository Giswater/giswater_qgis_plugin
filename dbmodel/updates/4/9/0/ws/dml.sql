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
    "dvQueryText": "SELECT expl_id AS id, name as idval FROM ve_exploitation",
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
    "dvQueryText": "SELECT expl_id AS id, name as idval FROM ve_exploitation",
    "isMandatory": true,
    "layoutorder": 6
  }
]'::json
	WHERE id=3134;

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
