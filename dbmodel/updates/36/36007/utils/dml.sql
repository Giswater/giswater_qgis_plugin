/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 19/12/2023
UPDATE config_form_list SET listname='tbl_inp_dscenario_virtualvalve' WHERE listname='tbl_inp_virtualvalve' AND device=4;
UPDATE config_form_list SET listname='tbl_inp_dscenario_connec' WHERE listname='tbl_inp_connec' AND device=4;
UPDATE config_form_list SET listname='tbl_inp_dscenario_inlet' WHERE listname='tbl_inp_inlet' AND device=4;
UPDATE config_form_list SET listname='tbl_inp_dscenario_junction' WHERE listname='tbl_inp_junction' AND device=4;
UPDATE config_form_list SET listname='tbl_inp_dscenario_pipe' WHERE listname='tbl_inp_pipe' AND device=4;
UPDATE config_form_list SET listname='tbl_inp_dscenario_pump' WHERE listname='tbl_inp_pump' AND device=4;
UPDATE config_form_list SET listname='tbl_inp_dscenario_reservoir' WHERE listname='tbl_inp_reservoir' AND device=4;
UPDATE config_form_list SET listname='tbl_inp_dscenario_shortpipe' WHERE listname='tbl_inp_shortpipe' AND device=4;
UPDATE config_form_list SET listname='tbl_inp_dscenario_tank' WHERE listname='tbl_inp_tank' AND device=4;
UPDATE config_form_list SET listname='tbl_inp_dscenario_valve' WHERE listname='tbl_inp_valve' AND device=4;
UPDATE config_form_list SET listname='tbl_inp_dscenario_virtualpump' WHERE listname='tbl_inp_virtualpump' AND device=4;

UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_connec' WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_inlet' WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_connec' WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_junction' WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_pipe' WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_pump' WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_reservoir' WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_shortpipe' WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_inlet' WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_junction' WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_pipe' WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_pump' WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_tank' WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_valve' WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_virtualpump' WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_virtualvalve' WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_tank' WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_valve' WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_virtualpump' WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_junction' WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='tbl_inp_junction' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_pipe' WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='tbl_inp_pipe' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_pump' WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='tbl_inp_pump' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_shortpipe' WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='tbl_inp_shortpipe' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_tank' WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='tbl_inp_tank' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_reservoir' WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='tbl_inp_reservoir' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_valve' WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='tbl_inp_valve' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_virtualvalve' WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='tbl_inp_virtualvalve' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_connec' WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='tbl_inp_connec' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_pump' WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='tbl_inp_pump' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_inlet' WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='tbl_inp_inlet' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_inlet' WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_reservoir' WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_shortpipe' WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_virtualvalve' WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_pump' WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_connec' WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_junction' WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_pipe' WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_reservoir' WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_shortpipe' WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_tank' WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_valve' WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_virtualpump' WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_inp_dscenario_virtualvalve' WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';

-- 20/12/2023
UPDATE om_visit_cat set alias = name;
