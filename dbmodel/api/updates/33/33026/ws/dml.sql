/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/01/28
UPDATE config_param_system SET parameter = 'api_selector_mincut', value =
'{"table":"anl_mincut_result_cat", "selector":"anl_mincut_result_selector", "label":"id, '' ('', CASE WHEN work_order IS NULL THEN ''N/I'' ELSE work_order END, '') on '', forecast_start::date, '' at '', forecast_start::time, ''H-'', forecast_end::time,''H''"}'
WHERE parameter = 'api_selector_label';
