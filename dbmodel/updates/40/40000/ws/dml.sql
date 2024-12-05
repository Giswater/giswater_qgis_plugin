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
	VALUES (3272,'The selected arc is not directly connected to the specified node. Please ensure the arc is directly linked to the node and select one that meets this requirement.','Select one arc that is connected to the selected node',2,true,'utils','core');


UPDATE config_form_fields SET columnname='arc_type', "label"='arc_type', tooltip='arc_type' WHERE formname='cat_arc' AND formtype='form_feature' AND columnname='arctype_id' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='cat_arc_type', "label"='arc_type', tooltip='cat_arc_type' WHERE formname='v_edit_arc' AND formtype='form_feature' AND columnname='cat_arctype_id' AND tabname='tab_data';

UPDATE config_form_fields SET columnname='node_type', "label"='node_type', tooltip='node_type' WHERE formname='cat_node' AND formtype='form_feature' AND columnname='nodetype_id' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='cat_node_type', "label"='node_type', tooltip='node_type' WHERE formname='v_edit_node' AND formtype='form_feature' AND columnname='nodetype_id' AND tabname='tab_data';

UPDATE config_form_fields SET columnname='connec_type', "label"='connec_type', tooltip='connec_type' WHERE formname='cat_connec' AND formtype='form_feature' AND columnname='connectype_id' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='cat_connec_type', "label"='connec_type', tooltip='connec_type' WHERE formname='v_edit_connec' AND formtype='form_feature' AND columnname='connectype_id' AND tabname='tab_data';

-- 30/10/2024

INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcp_pipes', 'View pipes for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);
INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcv_junction', 'View junction for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);
INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcv_demands', 'View demands for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);
INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcv_patterns', 'View patterns for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);
INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcv_emitters_log', 'View emiters log for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);
INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcv_dma_log', 'View dma for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);

-- 08/11/24
INSERT INTO inp_typevalue (typevalue,id,idval) VALUES ('inp_value_status_valve','CLOSED','CLOSED');
INSERT INTO inp_typevalue (typevalue,id,idval) VALUES ('inp_value_status_valve','OPEN','OPEN');

-- 12/11/24
INSERT INTO sys_param_user (id,formname,descript,sys_role,idval,"label",dv_querytext,isenabled,layoutorder,project_type,isparent,isautoupdate,"datatype",widgettype,ismandatory,vdefault,layoutname,iseditable,"source")
	VALUES ('inp_report_headloss','epaoptions','If true, value of headloss will be reported','role_epa','HEADLOSS','Headloss','SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''',true,11,'ws',false,false,'string','combo',true,'YES','lyt_reports_1',false,'core');

DELETE FROM config_form_fields WHERE columnname = 'energyvalue';

-- 20/11/2024
UPDATE config_form_fields SET dv_querytext_filterc = ' AND arc_type'
WHERE dv_querytext_filterc ilike '%arctype_id%';
UPDATE config_form_fields SET dv_querytext_filterc = ' AND node_type'
WHERE dv_querytext_filterc ilike '%nodetype_id%';
UPDATE config_form_fields SET dv_querytext_filterc = ' AND connec_type'
WHERE dv_querytext_filterc ilike '%connectype_id%';

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('epa_selector', 'tab_time', 'Time', 'Time', 'role_baisc', NULL, NULL, 1, '{5}');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_result', 'result_name_compare', 'lyt_result_1', 1, 'string', 'combo', 'Result name (to compare):', 'Result name (to compare)', NULL, false, false, true, false, false, 'SELECT result_id AS id, result_id AS idval FROM v_ui_rpt_cat_result WHERE status = ''COMPLETED''', NULL, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_result', 'result_name_show', 'lyt_result_1', 0, 'string', 'combo', 'Result name (to show):', 'Result name', NULL, false, false, true, false, false, 'SELECT result_id AS id, result_id AS idval FROM v_ui_rpt_cat_result WHERE status = ''COMPLETED''', NULL, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_none', 'tab_main', 'lyt_epa_select_1', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"tabs":["tab_result", "tab_time"]}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_time', 'time_compare', 'lyt_time_1', 3, 'string', 'combo', 'Time (to compare):', 'Time (to compare)', NULL, false, false, true, false, false, 'SELECT DISTINCT time as id, time as idval FROM rpt_arc WHERE result_id is not null', NULL, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_time', 'time_show', 'lyt_time_1', 2, 'string', 'combo', 'Time (to show):', 'Time show', NULL, false, false, true, false, false, 'SELECT DISTINCT time as id, time as idval FROM rpt_arc WHERE result_id is not null', NULL, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('epa_selector_tab_time', '{"layouts":["lyt_time_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- 28/11/2024

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('epa_results', 'SELECT result_id AS id, expl_id::text, sector_id::text, network_type, status, iscorporate::text, descript, cur_user, exec_date, rpt_stats::text, addparam, export_options, network_stats, inp_options FROM v_ui_rpt_cat_result', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": true,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "id",
        "desc": true
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [
    {
      "name": "btn_edit",
      "widgetfunction": {
        "functionName": "edit",
        "params": {}
      },
      "color": "default",
      "text": "Edit",
      "disableOnSelect": true,
      "moreThanOneDisable": true
    },
    {
      "name": "btn_show_inp_data",
      "widgetfunction": {
        "functionName": "showInpData",
        "params": {}
      },
      "color": "default",
      "text": "Show inp data",
      "disableOnSelect": true,
      "moreThanOneDisable": false
    },
    {
      "name": "btn_toggle_archive",
      "widgetfunction": {
        "functionName": "toggleArchive",
        "params": {}
      },
      "color": "default",
      "text": "Toggle archive",
      "disableOnSelect": true,
      "moreThanOneDisable": true
    },
    {
      "name": "btn_toggle_corporate",
      "widgetfunction": {
        "functionName": "toggleCorporate",
        "params": {}
      },
      "color": "default",
      "text": "Toggle corporate",
      "disableOnSelect": true,
      "moreThanOneDisable": true
    },
    {
      "name": "btn_delete",
      "widgetfunction": {
        "functionName": "delete",
        "params": {}
      },
      "color": "error",
      "text": "Delete",
      "disableOnSelect": true,
      "moreThanOneDisable": false
    }
  ],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);

-- 02/12/24

INSERT INTO connec_add (connec_id, demand_base, press_max, press_min, press_avg, quality_max, quality_min, quality_avg, result_id)
SELECT connec_id, demand, press_max, press_min, press_avg, quality_max, quality_min, quality_avg, result_id from _connec_add_;

-- 03/12/24

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_mng_1', 'lyt_nvo_mng_1', 'layoutNonVisualObjectsManager1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_mng_2', 'lyt_nvo_mng_2', 'layoutNonVisualObjectsManager1', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_mng_3', 'lyt_nvo_mng_1', 'layoutNonVisualObjectsManager1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_roughness_1', 'lyt_roughness_1', 'layoutRoughness1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_curves_1', 'lyt_curves_1', 'layoutCurves1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_patterns_1', 'lyt_patterns_1', 'layoutPatterns1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_controls_1', 'lyt_controls_1', 'layoutControls1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_rules_1', 'lyt_rules_1', 'layoutRules1', NULL);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_roughness', 'tab_roughness', 'tabRoughness', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_curves', 'tab_curves', 'tabCurves', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_patterns', 'tab_patterns', 'tabPatterns', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_controls', 'tab_controls', 'tabControls', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_rules', 'tab_rules', 'tabRules', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_manager', 'nvo_manager', 'nonVisualObjectsManager', NULL);


INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_roughness', 'Roughness', 'Roughness', 'role_baisc', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_curves', 'Curves', 'Curves', 'role_baisc', NULL, NULL, 1, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_patterns', 'Patterns', 'Patterns', 'role_baisc', NULL, NULL, 2, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_controls', 'Controls', 'Controls', 'role_baisc', NULL, NULL, 3, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_rules', 'Rules', 'Rules', 'role_baisc', NULL, NULL, 4, '{5}');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_patterns', 'tab_patterns', 'lyt_patterns_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_patterns', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_controls', 'tab_controls', 'lyt_controls_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_controls', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_rules', 'tab_rules', 'lyt_rules_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_rules', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_roughness', 'tab_roughness', 'lyt_roughness_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_roughness', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_none', 'tab_main', 'lyt_nvo_mng_1', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_roughness",
    "tab_curves",
    "tab_patterns",
    "tab_controls",
    "tab_rules"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_none', 'btn_cancel', 'lyt_buttons', 0, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{
  "functionName": "closeDlg"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_curves', 'tab_curves', 'lyt_curves_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_curves', false, 1);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_rules', 'SELECT * FROM v_edit_inp_rules WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openRules","params":{"initialHeight":400,"initialWidth":300,"minHeight":390,"minWidth":290,"title":"Rule"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openRules","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_curves', 'SELECT * FROM v_edit_inp_curve WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openCurves","params":{"initialHeight":480,"initialWidth":650,"minHeight":480,"minWidth":560,"title":"Curve"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openCurves","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_roughness', 'SELECT id, matcat_id, period_id, init_age, end_age, roughness, descript, active::text as active FROM cat_mat_roughness WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[{"id":"id","value":"","filterVariant":"text"}],"sorting":[{"id":"id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openRoughness","params":{"initialHeight":400,"initialWidth":300,"minHeight":390,"minWidth":290,"title":"Roughness"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openRoughness"},"icon":"OpenInBrowser","text":"Open"}]}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_patterns', 'SELECT * FROM v_edit_inp_pattern WHERE pattern_id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"pattern_id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openPatterns","params":{"initialHeight":570,"initialWidth":715,"minHeight":570,"minWidth":713,"title":"Pattern"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openPatterns","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_controls', 'SELECT * FROM v_edit_inp_controls WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openControls","params":{"initialHeight":400,"initialWidth":300,"minHeight":390,"minWidth":290,"title":"Control"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openControls","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_roughness', 'id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "id",
  "header": "Id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_roughness', 'matcat_id', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_roughness', 'period_id', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_roughness', 'init_age', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_roughness', 'end_age', 4, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_roughness', 'roughness', 5, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_roughness', 'descript', 6, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_roughness', 'active', 7, true, NULL, NULL, NULL, '{
  "accessorKey": "active",
  "header": "active",
  "filterVariant": "checkbox",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_rules', 'id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "id",
  "header": "Id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_rules', 'sector_id', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_rules', 'text', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_rules', 'active', 3, true, NULL, NULL, NULL, '{
  "accessorKey": "active",
  "header": "active",
  "filterVariant": "checkbox",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_curves', 'id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "id",
  "header": "Id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_curves', 'descript', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_curves', 'expl_id', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_patterns', 'pattern_id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "pattern_id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_patterns', 'observ', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_curves', 'curve_type', 1, true, NULL, NULL, NULL, '{
  "accessorKey": "curve_type",
  "filterVariant": "select",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_patterns', 'tscode', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_patterns', 'tsparameters', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_patterns', 'expl_id', 4, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_patterns', 'log', 5, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_controls', 'id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "id",
  "header": "Id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_controls', 'sector_id', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_controls', 'text', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_controls', 'active', 3, true, NULL, NULL, NULL, '{
  "accessorKey": "active",
  "header": "active",
  "filterVariant": "checkbox",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ws', 'tbl_nvo_mng_curves', 'log', 4, true, NULL, NULL, NULL, NULL);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_roughness', '{"layouts":["lyt_roughness_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_curves', '{"layouts":["lyt_curves_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_patterns', '{"layouts":["lyt_patterns_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_controls', '{"layouts":["lyt_controls_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_rules', '{"layouts":["lyt_rules_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_roughness_1', 'lyt_nvo_roughness_1', 'layoutNonVisualObjectsRoughness1', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_roughness', 'nvo_roughness', 'nonVisualObjectsRoughness', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_roughness', 'tab_none', 'matcat_id', 'lyt_nvo_roughness_1', 0, NULL, 'combo', 'Matcat ID', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_roughness', 'tab_none', 'active', 'lyt_nvo_roughness_1', 1, NULL, 'check', 'Active', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_roughness', 'tab_none', 'period_id', 'lyt_nvo_roughness_1', 2, NULL, 'text', 'Period ID', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_roughness', 'tab_none', 'init_age', 'lyt_nvo_roughness_1', 3, NULL, 'text', 'Init Age', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_roughness', 'tab_none', 'end_age', 'lyt_nvo_roughness_1', 4, NULL, 'text', 'End Age', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_roughness', 'tab_none', 'roughness', 'lyt_nvo_roughness_1', 5, NULL, 'text', 'Roughness', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 5);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_roughness', 'tab_none', 'descript', 'lyt_nvo_roughness_1', 6, NULL, 'text', 'Descript', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 6);


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_curves_1', 'lyt_nvo_curves_1', 'layoutNonVisualObjectsCurves1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_curves_2', 'lyt_nvo_curves_2', 'layoutNonVisualObjectsCurves2', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_curves_3', 'lyt_nvo_curves_3', 'layoutNonVisualObjectsCurves3', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_curves', 'nvo_curves', 'nonVisualObjectsCurves', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'tbl_curves', 'lyt_nvo_curves_3', 0, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "style": "regular"
}'::json, NULL, 'tbl_nvo_curves', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'img_plot', 'lyt_nvo_curves_3', 1, NULL, 'label', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, '', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'descript', 'lyt_nvo_curves_2', 0, NULL, 'text', 'Description', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'id', 'lyt_nvo_curves_1', 0, NULL, 'text', 'Curve ID', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'curve_type', 'lyt_nvo_curves_1', 1, NULL, 'combo', 'Curve Type', NULL, NULL, false, false, false, false, false, 'SELECT DISTINCT curve_type AS id, curve_type AS idval FROM v_edit_inp_curve', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'expl_id', 'lyt_nvo_curves_1', 2, NULL, 'combo', 'Exploitation ID', NULL, NULL, false, false, false, false, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_curves', 'SELECT x_value, y_value FROM v_edit_inp_curve_value WHERE curve_id IS NOT NULL ', 5, 'tab', 'list', '{
  "orderBy": "id",
  "orderType": "ASC"
}'::json, NULL);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_patterns_1', 'lyt_nvo_patterns_1', 'layoutNonVisualObjectsPatterns1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_patterns_2', 'lyt_nvo_patterns_2', 'layoutNonVisualObjectsPatterns2', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_patterns_3', 'lyt_nvo_patterns_3', 'layoutNonVisualObjectsPatterns3', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_patterns', 'nvo_patterns', 'nonVisualObjectsPatterns', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'pattern_id', 'lyt_nvo_patterns_1', 0, NULL, 'text', 'Pattern ID', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, '', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'observ', 'lyt_nvo_patterns_1', 1, NULL, 'text', 'Observation', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, '', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'expl_id', 'lyt_nvo_patterns_1', 2, NULL, 'combo', 'Exploitation ID', NULL, NULL, false, false, false, false, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, '', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'tbl_patterns', 'lyt_nvo_patterns_2', 0, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "style": "regular"
}'::json, NULL, 'tbl_nvo_patterns', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'img_plot', 'lyt_nvo_patterns_3', 0, NULL, 'label', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_patterns', 'SELECT factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 FROM v_edit_inp_pattern_value WHERE pattern_id IS NOT NULL', 5, 'tab', 'list', '{
  "orderBy": "id",
  "orderType": "ASC"
}'::json, NULL);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_controls_1', 'lyt_nvo_controls_1', 'layoutNonVisualObjectsControls1', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_controls', 'nvo_controls', 'nonVisualObjectsControls', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_controls', 'tab_none', 'sector_id', 'lyt_nvo_controls_1', 0, NULL, 'combo', 'Sector ID', NULL, NULL, false, false, false, false, false, 'SELECT sector_id as id, name as idval FROM v_edit_sector WHERE sector_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_controls', 'tab_none', 'active', 'lyt_nvo_controls_1', 1, NULL, 'check', 'Active', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_controls', 'tab_none', 'text', 'lyt_nvo_controls_1', 2, NULL, 'textarea', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_rules_1', 'lyt_nvo_rules_1', 'layoutNonVisualObjectsRules1', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_rules', 'nvo_rules', 'nonVisualObjectsRules', NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_rules', 'tab_none', 'active', 'lyt_nvo_rules_1', 1, NULL, 'check', 'Active', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_rules', 'tab_none', 'text', 'lyt_nvo_rules_1', 2, NULL, 'textarea', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_rules', 'tab_none', 'sector_id', 'lyt_nvo_rules_1', 0, NULL, 'combo', 'Sector ID', NULL, NULL, false, false, false, false, false, 'SELECT sector_id as id, name as idval FROM v_edit_sector WHERE sector_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);

-- 05/12/2024

UPDATE sys_style SET stylevalue = replace(stylevalue,'max_vel','vel_max_compare') WHERE layername IN ('v_rpt_comp_arc_hourly', 'v_rpt_comp_arc');
UPDATE sys_style SET stylevalue = replace(stylevalue,'max_pressure','press_max_compare') WHERE layername IN  ('v_rpt_comp_node_hourly','v_rpt_comp_node');

INSERT INTO inp_dscenario_demand (dscenario_id, id, feature_id, feature_type, demand, pattern_id, demand_type, "source")
SELECT dscenario_id, id, feature_id, feature_type, demand, pattern_id, demand_type, "source" FROM _inp_dscenario_demand;