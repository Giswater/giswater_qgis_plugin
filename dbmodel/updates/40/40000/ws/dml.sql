/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- drop gw_trg_presszone_check_datatype
DELETE FROM sys_function WHERE id=3306;

-- insert data to new dma table
INSERT INTO dma (dma_id, "name", dma_type, muni_id, expl_id, sector_id, macrodma_id, descript, undelete, the_geom, minc, maxc, effc, pattern_id, link, graphconfig, stylesheet, active, avg_press, tstamp, insert_user, lastupdate, lastupdate_user)
SELECT dma_id, "name", dma_type, NULL::int4[], ARRAY[expl_id], NULL::int4[], macrodma_id, descript, undelete, the_geom, minc, maxc, effc, pattern_id, link, graphconfig, stylesheet, active, avg_press, tstamp, insert_user, lastupdate, lastupdate_user
FROM _dma;

INSERT INTO presszone (presszone_id, "name", presszone_type, muni_id, expl_id, sector_id, link, the_geom, graphconfig, stylesheet, head, active, descript, tstamp, insert_user, lastupdate, lastupdate_user, avg_press)
SELECT presszone_id, "name", presszone_type, NULL::int4[], ARRAY[expl_id], NULL::int4[], link, the_geom, graphconfig, stylesheet, head, active, descript, tstamp, insert_user, lastupdate, lastupdate_user, avg_press
FROM _presszone;

INSERT INTO dqa (dqa_id, "name", dqa_type, muni_id, expl_id, sector_id, macrodqa_id, descript, undelete, the_geom, pattern_id, link, graphconfig, stylesheet, active, tstamp, insert_user, lastupdate, lastupdate_user, avg_press)
SELECT dqa_id, "name", dqa_type, NULL::int4[], ARRAY[expl_id], NULL::int4[], macrodqa_id, descript, undelete, the_geom, pattern_id, link, graphconfig, stylesheet, active, tstamp, insert_user, lastupdate, lastupdate_user, avg_press
FROM _dqa;

INSERT INTO sector (sector_id, "name", sector_type, muni_id, expl_id, macrosector_id, descript, undelete, the_geom, graphconfig, stylesheet, active, parent_id, pattern_id, tstamp, insert_user, lastupdate, lastupdate_user, avg_press, link)
SELECT sector_id, "name", sector_type, NULL::int4[], NULL::int4[], macrosector_id, descript, undelete, the_geom, graphconfig, stylesheet, active, parent_id, pattern_id, tstamp, insert_user, lastupdate, lastupdate_user, avg_press, link
FROM _sector;

-- 04/10/2024
UPDATE inp_typevalue
SET idval='VIRTUALPUMP', id='VIRTUALPUMP'
WHERE typevalue='inp_typevalue_dscenario' AND id='VITUALPUMP';

UPDATE config_form_fields
	SET layoutname='lyt_buttons'
	WHERE formname='mincut_manager' AND formtype='form_mincut' AND columnname='cancel' AND tabname='tab_none';
UPDATE config_form_fields
	SET layoutname='lyt_buttons'
	WHERE formname='mincut_manager' AND formtype='form_mincut' AND columnname='hspacer_lyt_bot_3' AND tabname='tab_none';


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_dma', 'form_generic', 'tab_none', 'muni_id', 'lyt_data_1', 'string', 'text', 'Muni_id', 'Muni_id', false, false, true, false, false);
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_dma', 'form_generic', 'tab_none', 'sector_id', 'lyt_data_1', 'string', 'text', 'Sector_id', 'Sector_id', false, false, true, false, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_presszone', 'form_generic', 'tab_none', 'muni_id', 'lyt_data_1', 'string', 'text', 'Muni_id', 'Muni_id', false, false, true, false, false);
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_presszone', 'form_generic', 'tab_none', 'sector_id', 'lyt_data_1', 'string', 'text', 'Sector_id', 'Sector_id', false, false, true, false, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_dqa', 'form_generic', 'tab_none', 'muni_id', 'lyt_data_1', 'string', 'text', 'Muni_id', 'Muni_id', false, false, true, false, false);
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_dqa', 'form_generic', 'tab_none', 'sector_id', 'lyt_data_1', 'string', 'text', 'Sector_id', 'Sector_id', false, false, true, false, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_sector', 'form_generic', 'tab_none', 'muni_id', 'lyt_data_1', 'string', 'text', 'Muni_id', 'Muni_id', false, false, true, false, false);
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_sector', 'form_generic', 'tab_none', 'expl_id', 'lyt_data_1', 'string', 'text', 'Expl_id', 'Expl_id', false, false, true, false, false);

-- 11/10/24
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('ve_node_shutoff_valve', 'tab_data', 'Data', 'Data', 'role_basic', NULL, '[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json, 0, '{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_check_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_pr_reduc_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('ve_node_pr_green_valve', 'tab_data', 'Data', 'Data', 'role_basic', NULL, '[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json, 0, '{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_pr_break_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_outfall_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_pr_susta_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_air_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_fl_contr_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_gen_purp_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_throttle_valve','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_pump','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_node_flowmeter','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json,0,'{4,5}');


INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('ve_node_pressure_meter', 'tab_data', 'Data', 'Data', 'role_basic', NULL, '[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json, 0, '{4,5}');

-- 14/10/24
INSERT INTO sys_message (id,error_message,hint_message,log_level,show_user,project_type,"source")
	VALUES (3270,'The selected arc is not directly connected to the specified node. Please ensure the arc is directly linked to the node and select one that meets this requirement.','Select one arc that is connected to the selected node',2,true,'utils','core');


UPDATE config_form_fields SET columnname='arc_type', "label"='arc_type', tooltip='arc_type' WHERE formname='cat_arc' AND formtype='form_feature' AND columnname='arctype_id' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='cat_arc_type', "label"='arc_type', tooltip='cat_arc_type' WHERE formname='v_edit_arc' AND formtype='form_feature' AND columnname='cat_arctype_id' AND tabname='tab_data';

UPDATE config_form_fields SET columnname='node_type', "label"='node_type', tooltip='node_type' WHERE formname='cat_node' AND formtype='form_feature' AND columnname='nodetype_id' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='cat_node_type', "label"='node_type', tooltip='node_type' WHERE formname='v_edit_node' AND formtype='form_feature' AND columnname='nodetype_id' AND tabname='tab_data';

UPDATE config_form_fields SET columnname='connec_type', "label"='connec_type', tooltip='connec_type' WHERE formname='cat_connec' AND formtype='form_feature' AND columnname='connectype_id' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='cat_connec_type', "label"='connec_type', tooltip='connec_type' WHERE formname='v_edit_connec' AND formtype='form_feature' AND columnname='connectype_id' AND tabname='tab_data';

