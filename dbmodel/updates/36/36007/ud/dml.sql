/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 20/12/2023
DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON cat_arc_shape;
ALTER TABLE cat_arc_shape DROP CONSTRAINT cat_arc_shape_check;
INSERT INTO cat_arc_shape VALUES ('UNKNOWN','UNKNOWN') ON CONFLICT (id) DO NOTHING;
ALTER TABLE cat_arc_shape ADD CONSTRAINT cat_arc_shape_check CHECK (epa::text = ANY (ARRAY['VERT_ELLIPSE'::character varying::text, 'ARCH'::character varying::text, 'BASKETHANDLE'::character varying::text, 'CIRCULAR'::character varying::text, 'CUSTOM'::character varying::text, 'DUMMY'::character varying::text, 'EGG'::character varying::text, 'FILLED_CIRCULAR'::character varying::text, 'FORCE_MAIN'::character varying::text, 'HORIZ_ELLIPSE'::character varying::text, 'HORSESHOE'::character varying::text, 'IRREGULAR'::character varying::text, 'MODBASKETHANDLE'::character varying::text, 'PARABOLIC'::character varying::text, 'POWER'::character varying::text, 'RECT_CLOSED'::character varying::text, 'RECT_OPEN'::character varying::text, 'RECT_ROUND'::character varying::text, 'RECT_TRIANGULAR'::character varying::text, 'SEMICIRCULAR'::character varying::text, 'SEMIELLIPTICAL'::character varying::text, 'TRAPEZOIDAL'::character varying::text, 'TRIANGULAR'::character varying::text, 'VIRTUAL'::character varying::text, 'UNKNOWN'::character varying::text]));

UPDATE cat_arc SET shape = 'UNKNOWN' WHERE shape is null;
ALTER TABLE cat_arc ALTER COLUMN shape SET NOT NULL;

INSERT INTO inp_typevalue VALUES ('inp_options_networkmode_', '3', '1D/2D SWMM-IBER WET');

UPDATE config_toolbox set inputparams = (replace(inputparams::text, '"$userExploitation"', '""'))::json where id = 2768;

-- 15/01/2024
update config_form_fields set tabname = 'tab_epa' where formname like 've_epa%' and tabname = 'tab_none';
update config_form_fields set dv_isnullvalue = true where tabname = 'tab_epa' and formname = 've_epa_orifice' and columnname in ('ori_type', 'shape', 'flap');
update config_form_fields set dv_isnullvalue = true where tabname = 'tab_epa' and formname = 've_epa_weir' and columnname in ('weir_type', 'flap');
update config_form_fields set dv_isnullvalue = true where tabname = 'tab_epa' and formname = 've_epa_pump' and columnname in ('curve_id', 'status');
update config_form_fields set dv_isnullvalue = true where tabname = 'tab_epa' and formname = 've_epa_outlet' and columnname in ('outlet_type', 'curve_id', 'flap');


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") 
VALUES(3298, 'gw_fct_import_inp_dwf', 'ud', 'function', 'json', 'json', 'Function to import DWF values. ', 'role_epa', NULL, 'core');

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) 
VALUES(527, 'Import dwf values', 'ud', NULL, 'core' , NULL, 'Function process', NULL);

INSERT INTO config_csv (fid, alias, descript, functionname, active, orderby, addparam) 
VALUES(527, 'Import DWF', 'Function to import DWF values. The CSV file must contain the following columns in the exact same order:   dwfscenario_id, node_id, value, pat1, pat2, pat3, pat4', 'gw_fct_import_inp_dwf', true, 21, NULL);

INSERT INTO config_param_system SELECT 'utils_graphanalytics_style', style::text, 'There are 3 "mode" to symbolize mapzones when the project is loaded or mapzones are recalculated: 
- Disabled: do nothing with the style
- Random: use "column" data to categorize and set random colors to every mapzone
- Stylesheet: use "column" data to categorize and set the configured color to every mapzone from mapzone table stylesheet column',
'Mapzones style config:', NULL, NULL, true, 13, 'utils', null, null, 'json', 'linetext', true, true, null, null, null, null, null, null, 'lyt_admin_om'
FROM config_function WHERE id=2928;

UPDATE config_param_system SET value = '{"DRAINZONE":{"mode":"Disable", "column":"name"},"SECTOR":{"mode":"Disable", "column":"name"},"DMA":{"mode":"Disable", "column":"name"}}'
WHERE parameter='utils_graphanalytics_style';

DELETE FROM config_function WHERE id=2928;

UPDATE config_form_fields SET layoutname='lyt_data_1', tabname='tab_data' WHERE formname LIKE 've_gully%' AND columnname LIKE 'connec_y%' AND tabname='tab_none';

-- 22/01/2024
UPDATE config_form_fields SET widgetfunction='{"functionName": "open_selected_path", "parameters":{"targetwidget":"tab_hydrometer_tbl_hydrometer", "columnfind": "hydrometer_link"}}'::json WHERE columnname='btn_link' AND tabname='tab_hydrometer';
