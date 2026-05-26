/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 9/1/2024;

/*
reserve for ddss plugin
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) 
VALUES(527, 'Consumptions analysis', 'ws', NULL, 'ddss plugin', NULL, 'Function process', NULL);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) 
VALUES(528, 'Hydro without census', 'ws', NULL, 'ddss plugin', NULL, 'Function process', NULL);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) 
VALUES(529, 'Census whitout hydro', 'ws', NULL, 'ddss plugin' , NULL, 'Function process', NULL);
*/

INSERT INTO config_param_system SELECT 'utils_graphanalytics_style', style::text, 'There are 3 "mode" to symbolize mapzones when the project is loaded or mapzones are recalculated: 
- Disabled: do nothing with the style
- Random: use "column" data to categorize and set random colors to every mapzone
- Stylesheet: use "column" data to categorize and set the configured color to every mapzone from mapzone table stylesheet column',
'Mapzones style config:', NULL, NULL, true, 26, 'utils', null, null, 'json', 'linetext', true, true, null, null, null, null, null, null, 'lyt_admin_om'
FROM config_function WHERE id=2928;

UPDATE config_param_system SET value = (replace(value, 'minsector_id', 'name'))::json WHERE parameter='utils_graphanalytics_style';
UPDATE config_param_system SET value = (replace(value, 'presszone_id', 'name'))::json WHERE parameter='utils_graphanalytics_style';
UPDATE config_param_system SET value = (replace(value, 'dqa_id', 'name'))::json WHERE parameter='utils_graphanalytics_style';
UPDATE config_param_system SET value = (replace(value, 'sector_id', 'name'))::json WHERE parameter='utils_graphanalytics_style';

DELETE FROM config_function WHERE id=2928;

UPDATE connec SET epa_type='UNDEFINED' where epa_type is null;

ALTER TABLE connec ALTER COLUMN epa_type SET NOT NULL;

DELETE FROM sys_foreignkey WHERE target_table='inp_dscenario_demand' AND active IS TRUE;