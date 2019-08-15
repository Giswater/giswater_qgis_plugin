/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE audit_cat_function SET isdeprecated=TRUE where id=1248;

UPDATE audit_cat_param_user SET vdefault='NO' WHERE id='inp_report_input';
UPDATE audit_cat_param_user SET vdefault='NONE' WHERE id='inp_report_nodes';
UPDATE audit_cat_param_user SET vdefault='NONE' WHERE id='inp_report_subcatchments';
UPDATE audit_cat_param_user SET vdefault='NONE' WHERE id='inp_report_links';

UPDATE inp_timser_id SET idval = id;

UPDATE audit_cat_param_user SET dv_querytext='SELECT id, idval FROM inp_timser_id WHERE timser_type=''Rainfall''',vdefault=null, 
dv_isnullvalue=true, layout_id=2, layout_order=14, layoutname='grl_general_2' WHERE id='inp_options_setallraingages';

UPDATE audit_cat_param_user SET layoutname='grl_general_1', layout_id=1, layout_order=68, vdefault=null, dv_isnullvalue=true WHERE id='inp_options_dwfscenario';

UPDATE audit_cat_param_user SET layout_order=2 WHERE id='inp_options_rtc_period_id';

