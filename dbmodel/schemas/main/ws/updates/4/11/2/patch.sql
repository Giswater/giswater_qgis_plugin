/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_param_system
	SET value='{
  "table": "temp_t_mincut",
  "table_id": "id",
  "selector": "selector_mincut_result",
  "selector_id": "result_id",
  "label": "id, ''('', CASE WHEN work_order IS NULL THEN ''N/I'' ELSE work_order END, '') on '', forecast_start::date, '' at '', forecast_start::time, ''H-'', forecast_end::time,''H''",
  "query_filter": " AND id > 0 ",
  "manageAll": true,
  "orderBy": "id",
  "typeaheadFilter": " AND id::text"
}'
WHERE "parameter"='basic_selector_tab_mincut';

UPDATE config_form_tableview
SET columnname='exploitation'
WHERE objectname='tbl_mincut_manager' AND columnname='expl_id';

UPDATE config_form_tableview
SET columnname='municipality'
WHERE objectname='tbl_mincut_manager' AND columnname='muni_id';
