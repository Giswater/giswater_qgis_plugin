/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 28/10/2025
UPDATE config_toolbox SET inputparams='[
{"label": "Create mapzones for netscenario:", "value": null, "tooltip": "Create mapzone for a selected netscenario", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "netscenario", "widgettype": "combo", "dvQueryText": "select netscenario_id as id, name as idval from plan_netscenario  order by name", "isNullValue": "true", "layoutorder": 1},
{"label": "Exploitation:", "value": null, "tooltip": "Choose exploitation to work with", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "exploitation", "widgettype": "combo", "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC", "layoutorder": 2},
{"label": "Force open nodes: (*)", "value": null, "tooltip": "Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "forceOpen", "widgettype": "linetext", "isMandatory": false, "layoutorder": 5, "placeholder": "1015,2231,3123"},
{"label": "Force closed nodes: (*)", "value": null, "tooltip": "Optative node id(s) to temporary close open node(s) to force algorithm to stop there", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "forceClosed", "widgettype": "text", "isMandatory": false, "layoutorder": 6, "placeholder": "1015,2231,3123"},
{"label": "Use selected psectors:", "value": null, "tooltip": "If true, use selected psectors. If false ignore selected psectors and only works with on-service network", "datatype": "boolean", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "usePlanPsector", "widgettype": "check", "layoutorder": 8},
{"label": "Mapzone constructor method:", "value": null, "comboIds": [0, 1, 2, 3, 4], "datatype": "integer", "comboNames": ["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER", "LINK & PIPE BUFFER"], "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "updateMapZone", "widgettype": "combo", "layoutorder": 9},
{"label": "Pipe buffer", "value": null, "tooltip": "Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.", "datatype": "float", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "geomParamUpdate", "widgettype": "text", "isMandatory": false, "layoutorder": 10, "placeholder": "5-30"},
{"label": "Commit changes:", "value": null, "tooltip": "If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables", "datatype": "boolean", "layoutname": "grl_option_parameters", "widgetname": "commitChanges", "widgettype": "check", "layoutorder": 11},
{"label": "Mapzones from zero:", "value": null, "tooltip": "If true, mapzones are calculated automatically from zero", "datatype": "boolean", "layoutname": "grl_option_parameters", "widgetname": "fromZero", "widgettype": "check", "layoutorder": 12}
]'::json WHERE id=3256;
