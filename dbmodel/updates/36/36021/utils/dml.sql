/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_toolbox
SET inputparams = (
    SELECT
        jsonb_agg(
            jsonb_set(
                jsonb_set(
                    elem,
                    '{value}',
                    'null',
                    true
                ),
                '{selectedId}',
                'null',
                true
            )
        )::json
    FROM jsonb_array_elements(inputparams::jsonb) AS elem
)
WHERE inputparams IS NOT NULL
  AND (
    inputparams::text LIKE '%"value"%'
    OR inputparams::text LIKE '%"selectedId"%'
  );

UPDATE config_toolbox SET inputparams='[{"widgetname": "nodeTolerance", "label": "Node tolerance:", "widgettype": "spinbox", "datatype": "float", "layoutname": "grl_option_parameters", "layoutorder": 1, "value": 0.01}]'::json;
UPDATE config_toolbox SET inputparams='[{"widgetname": "connecTolerance", "label": "Node tolerance:", "widgettype": "spinbox", "datatype": "float", "layoutname": "grl_option_parameters", "layoutorder": 1, "value": 0.01}]'::json;
UPDATE config_toolbox SET inputparams='[{"widgetname": "arcSearchNodes", "label": "Start/end points buffer", "widgettype": "text", "datatype": "float", "layoutname": "grl_option_parameters", "layoutorder": 1, "value": "0.5"}]'::json;

UPDATE config_param_system
SET value = REPLACE(value, 'vu_exploitation', 'exploitation')
WHERE value LIKE '%vu_exploitation%';
