/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 01/09/2025
UPDATE sys_table SET descript='ve_inp_frorifice',alias='Inp flwreg orifice' WHERE id='ve_inp_frorifice';
UPDATE sys_table SET descript='ve_inp_frpump',alias='Inp flwreg pump' WHERE id='ve_inp_frpump';
UPDATE sys_table SET descript='ve_inp_froutlet',alias='Inp flwreg outlet' WHERE id='ve_inp_froutlet';
UPDATE sys_table SET descript='ve_inp_frweir',alias='Inp flwreg weir' WHERE id='ve_inp_frweir';

-- 02/09/2025
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'id', 0, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'gully_id', 1, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'arc_id', 2, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'psector_id', 3, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'state', 4, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'doable', 5, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'descript', 6, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', '_link_geom_', 7, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', '_userdefined_geom_', 8, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'link_id', 9, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'insert_tstamp', 10, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'insert_user', 11, false, NULL, NULL, NULL);


UPDATE sys_table SET context = '{"levels": ["EPA", "HYDROLOGY"]}' WHERE id = 've_raingage';

UPDATE sys_param_user SET id='inp_options_hydrology_current' WHERE id='inp_options_hydrology_scenario';

UPDATE config_toolbox SET inputparams = replace(inputparams::text, '''ALL VISIBLE SECTORS''', '''ALL VISIBLE SECTORS''')::json WHERE id = '3102' or id = '3100';

UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND  typevalue = ''inp_typevalue_orifice'''
WHERE formname='ve_epa_frorifice' AND formtype='form_feature' AND columnname='orifice_type' AND tabname='tab_epa';

UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND  typevalue = ''inp_typevalue_weir'''
WHERE formname='ve_epa_frweir' AND formtype='form_feature' AND columnname='weir_type' AND tabname='tab_epa';

-- 09/09/2025
UPDATE sys_param_user SET id='inp_options_dwfscenario_current' WHERE id='inp_options_dwfscenario';

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
    "widgettype": "linetext",
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
    "label": "Name: (*)",
    "value": null,
    "tooltip": "Name for hydrology scenario (mandatory)",
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
    "label": "Infiltration:",
    "value": null,
    "tooltip": "Infiltration",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "infiltration",
    "widgettype": "combo",
    "dvQueryText": "SELECT id, idval FROM inp_typevalue WHERE typevalue =''inp_value_options_in''",
    "isMandatory": true,
    "layoutorder": 2
  },
  {
    "label": "Text:",
    "value": null,
    "tooltip": "Text of hydrology scenario",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "text",
    "widgettype": "linetext",
    "isMandatory": false,
    "layoutorder": 3,
    "placeholder": ""
  },
  {
    "label": "Exploitation:",
    "value": null,
    "tooltip": "hydrology scenario type",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "expl",
    "widgettype": "combo",
    "dvQueryText": "SELECT expl_id AS id, name as idval FROM ve_exploitation",
    "isMandatory": true,
    "layoutorder": 4
  }
]'::json
	WHERE id=3290;
UPDATE config_toolbox
	SET inputparams='[
  {
    "label": "Name: (*)",
    "value": null,
    "tooltip": "Name for dwf scenario (mandatory)",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "idval",
    "widgettype": "linetext",
    "isMandatory": true,
    "layoutorder": 1,
    "placeholder": ""
  },
  {
    "label": "Startdate:",
    "value": null,
    "tooltip": "Start date for dwf scenario",
    "datatype": "date",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "startdate",
    "widgettype": "datetime",
    "isMandatory": false,
    "layoutorder": 2,
    "placeholder": ""
  },
  {
    "label": "Enddate:",
    "value": null,
    "tooltip": "End date",
    "datatype": "date",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "enddate",
    "widgettype": "datetime",
    "isMandatory": false,
    "layoutorder": 3,
    "placeholder": "End date for dwf scenario"
  },
  {
    "label": "Observ:",
    "value": null,
    "tooltip": "Observations of dwf scenario",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "observ",
    "widgettype": "linetext",
    "isMandatory": false,
    "layoutorder": 4,
    "placeholder": ""
  },
  {
    "label": "Exploitation:",
    "value": null,
    "tooltip": "dwf scenario type",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "expl",
    "widgettype": "combo",
    "dvQueryText": "SELECT expl_id AS id, name as idval FROM ve_exploitation",
    "isMandatory": true,
    "layoutorder": 5
  }
]'::json
	WHERE id=3292;

UPDATE sys_table SET context='{"levels": ["EPA", "DSCENARIO"]}', alias = 'Lid Dscenario' WHERE id='ve_inp_dscenario_lids';

-- 10/09/2025
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
    "widgettype": "linetext",
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
    "dvQueryText": "SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_dscenario'' ORDER BY id",
    "isMandatory": true,
    "layoutorder": 4
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
    "label": "Scenario name:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "name",
    "widgettype": "text",
    "layoutorder": 1
  },
  {
    "label": "Scenario type:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "type",
    "widgettype": "combo",
    "dvQueryText": "SELECT id, idval FROM inp_typevalue where typevalue = ''inp_typevalue_dscenario'' ORDER BY id",
    "layoutorder": 2
  },
  {
    "label": "Exploitation:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "exploitation",
    "widgettype": "combo",
    "dvQueryText": "SELECT expl_id as id, name as idval FROM ve_exploitation",
    "layoutorder": 4
  },
  {
    "label": "Descript:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "descript",
    "widgettype": "text",
    "layoutorder": 5
  }
]'::json
	WHERE id=3118;

INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_typevalue_dscenario', 'POLL', 'POLL', NULL, NULL);

UPDATE inp_typevalue SET idval='FRWEIR',id='FRWEIR' WHERE typevalue='inp_typevalue_dscenario' AND id='WEIR';
UPDATE inp_typevalue SET idval='FRPUMP',id='FRPUMP' WHERE typevalue='inp_typevalue_dscenario' AND id='PUMP';
UPDATE inp_typevalue SET idval='FRORIFICE',id='FRORIFICE' WHERE typevalue='inp_typevalue_dscenario' AND id='ORIFICE';
UPDATE inp_typevalue SET idval='FROUTLET',id='FROUTLET' WHERE typevalue='inp_typevalue_dscenario' AND id='OUTLET';

UPDATE config_form_fields
	SET dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND  typevalue = ''inp_typevalue_orifice'''
	WHERE formname='inp_dscenario_frorifice' AND formtype='form_feature' AND columnname='orifice_type' AND tabname='tab_none';
UPDATE config_form_fields
	SET dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_yesno'' '
	WHERE formname='inp_dscenario_frorifice' AND formtype='form_feature' AND columnname='flap' AND tabname='tab_none';
UPDATE config_form_fields
	SET dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_orifice'''
	WHERE formname='inp_dscenario_frorifice' AND formtype='form_feature' AND columnname='shape' AND tabname='tab_none';
