/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/10/26
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_rtc_hydrometer_x_connec","v_ui_hydrometer","vi_parent_hydrometer","v_rtc_hydrometer"], 
"action":"SAVE-VIEW","hasChilds":"False"}}$$);

ALTER TABLE ext_rtc_hydrometer ALTER COLUMN plot_code TYPE character varying(30) USING plot_code::character varying(30);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_rtc_hydrometer", "vi_parent_hydrometer", "v_rtc_hydrometer_x_connec","v_ui_hydrometer"], 
"action":"RESTORE-VIEW","hasChilds":"False"}}$$);
