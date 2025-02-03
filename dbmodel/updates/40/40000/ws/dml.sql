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

UPDATE sys_style SET stylevalue = replace(stylevalue,'max_vel','vel_max_compare') WHERE layername IN ( 'v_rpt_comp_arc');

INSERT INTO inp_dscenario_demand (dscenario_id, id, feature_id, feature_type, demand, pattern_id, demand_type, "source")
SELECT dscenario_id, id, feature_id, feature_type, demand, pattern_id, demand_type, "source" FROM _inp_dscenario_demand;

INSERT INTO config_param_user (parameter, value, cur_user)
SELECT
    'plan_netscenario_current' AS parameter,
    netscenario_id AS value,
    cur_user
FROM _selector_netscenario
ON CONFLICT (parameter, cur_user)
DO UPDATE SET
    value = excluded.value;

--10/12/2024
UPDATE sys_style SET stylevalue = replace(stylevalue,'vel','vel_compare') WHERE layername IN  ('v_rpt_comp_arc_hourly');

-- 12/12/24

update sys_message
set error_message = 'Feature is out of sector, feature_id: %feature_id%'
where id = 1010;

update sys_message
set error_message = 'Feature is out of dma, feature_id: %feature_id%'
where id = 1014;

update sys_message
set error_message = 'One or more arcs has the same node as Node1 and Node2. Node_id: %node_id%'
where id = 1040;

update sys_message
set error_message = 'One or more arcs was not inserted/updated because it has not start/end node. Arc_id: %arc_id%'
where id = 1042;

update sys_message
set error_message = 'Exists one o more connecs closer than configured minimum distance, connec_id: %connec_id%'
where id = 1044;

update sys_message
set error_message = 'Exists one o more nodes closer than configured minimum distance, node_id: %node_id%'
where id = 1046;

update sys_message
set error_message = 'There is at least one arc attached to the deleted feature. (num. arc,feature_id) = %num_arc%, %feature_id%'
where id = 1056;

update sys_message
set error_message = 'There is at least one element attached to the deleted feature. (num. element,feature_id) = %num_element%, %feature_id%'
where id = 1058;

update sys_message
set error_message = 'There is at least one document attached to the deleted feature. (num. document,feature_id) = %num_document%, %feature_id%'
where id = 1060;

update sys_message
set error_message = 'There is at least one visit attached to the deleted feature. (num. visit,feature_id) = %num_visit%, %feature_id%'
where id = 1062;

update sys_message
set error_message = 'There is at least one link attached to the deleted feature. (num. link,feature_id) = %num_link%, %feature_id%'
where id = 1064;

update sys_message
set error_message = 'There is at least one connec attached to the deleted feature. (num. connec,feature_id) = %num_connec%, %feature_id%'
where id = 1066;

update sys_message
set error_message = 'There is at least one gully attached to the deleted feature. (num. gully,feature_id)= %num_gully%, %feature_id%'
where id = 1068;

update sys_message
set error_message = 'The feature can''t be replaced, because it''s state is different than 1. State = %state_id%'
where id = 1070;

update sys_message
set error_message = 'Before downgrading the node to state 0, disconnect the associated features, node_id: %node_id%'
where id = 1072;

update sys_message
set error_message = 'Before downgrading the arc to state 0, disconnect the associated features, arc_id: %arc_id%'
where id = 1074;

update sys_message
set error_message = 'Before downgrading the connec to state 0, disconnect the associated features, connec_id: %connec_id%'
where id = 1076;

update sys_message
set error_message = 'Before downgrading the gully to state 0, disconnect the associated features, gully_id: %gully_id%'
where id = 1078;

update sys_message
set error_message = 'Nonexistent arc_id: %arc_id%'
where id = 1082;

update sys_message
set error_message = 'Nonexistent node_id: %node_id%'
where id = 1084;

update sys_message
set error_message = 'Node with state 2 over another node with state=2 on same alternative it is not allowed. The node is: %node_id%'
where id = 1096;

update sys_message
set error_message = 'It is not allowed to insert/update one node with state(1) over another one with state (1) also. The node is: %node_id%'
where id = 1097;

update sys_message
set error_message = 'It is not allowed to insert/update one node with state (2) over another one with state (2). The node is: %node_id%'
where id = 1100;

update sys_message
set error_message = 'Feature is out of exploitation, feature_id: %feature_id%'
where id = 2012;

update sys_message
set error_message = '(arc_id, geom type) = %arc_id%, %geom_type%'
where id = 2022;

update sys_message
set error_message = 'The feature does not have state(1) value to be replaced, state = %state_id%'
where id = 2028;

update sys_message
set error_message = 'The feature not have state(2) value to be replaced, state = %state_id%'
where id = 2030;

update sys_message
set error_message = 'It is impossible to validate the arc without assigning value of arccat_id, arc_id: %arc_id%'
where id = 2036;

update sys_message
set error_message = 'The exit arc must be reversed. Arc = %arc_id%'
where id = 2038;

update sys_message
set error_message = 'Reduced geometry is not a Linestring, (arc_id,geom type)= %arc_id%, %geom_type%'
where id = 2040;

update sys_message
set error_message = 'Query text = %query_text%'
where id = 2078;

update sys_message
set error_message = 'The x value is too large. The total length of the line is %line_length%'
where id = 2080;

update sys_message
set error_message = 'The extension does not exists. Extension = %extension%'
where id = 2082;

update sys_message
set error_message = 'The module does not exists. Module = %module%'
where id = 2084;

update sys_message
set error_message = 'There are [units] values nulls or not defined on price_value_unit table  = %units%'
where id = 2088;

update sys_message
set error_message = 'There is at least one node attached to the deleted feature. (num. node,feature_id)= %num_node%, %feature_id%'
where id = 2108;

update sys_message
set error_message = 'The selected arc has state=0 (num. node,feature_id)= %element_id%'
where id = 3002;

update sys_message
set error_message = 'The minimum arc length of this exportation is: %min_arc_length%'
where id = 3010;

update sys_message
set error_message = 'The position value is bigger than the full length of the arc. %arc_id%'
where id = 3012;

update sys_message
set error_message = 'The position id is not node_1 or node_2 of selected arc. %arc_id%'
where id = 3014;

update sys_message
set error_message = 'The inserted value is not present in a catalog. %catalog%'
where id = 3022;

update sys_message
set error_message = 'Can''t modify typevalue: %typevalue%'
where id = 3028;

update sys_message
set error_message = 'Can''t delete typevalue: %typevalue%'
where id = 3030;

update sys_message
set error_message = 'Can''t apply the foreign key %typevalue_name%'
where id = 3032;

update sys_message
set error_message = 'Selected state type doesn''t correspond with state %state_id%'
where id = 3036;

update sys_message
set error_message = 'Inserted value has unaccepted characters: %characters%'
where id = 3038;

update sys_message
set error_message = 'Selected node type doesn''t divide arc. Node type: %node_type%'
where id = 3046;

update sys_message
set error_message = 'Connect2network tool is not enabled for connec''s with state=2. Connec_id: %connec_id%'
where id = 3052;

update sys_message
set error_message = 'Connect2network tool is not enabled for gullies with state=2. Gully_id: %gully_id%'
where id = 3054;

update sys_message
set error_message = 'It is impossible to validate the arc without assigning value of arccat_id. Arc_id: %arc_id%'
where id = 3056;

update sys_message
set error_message = 'It is impossible to validate the connec without assigning value of connecat_id. Connec_id: %connec_id%'
where id = 3058;

update sys_message
set error_message = 'It is impossible to validate the node without assigning value of nodecat_id. Node_id: %node_id%'
where id = 3060;

update sys_message
set error_message = 'Selected gratecat_id has NULL width or length. Gratecat_id: %gratecat_id%'
where id = 3062;

update sys_message
set error_message = 'It is not possible to create the link. On inventory mode only one link is enabled for each connec. Connec_id: %connec_id%'
where id = 3076;

update sys_message
set error_message = 'It is not possible to create the link. On inventory mode only one link is enabled for each gully. Gully_id: %gully_id%'
where id = 3078;

update sys_message
set error_message = 'It is not possible to relate connect with state=1 over network feature with state=2, connect: %connec_id%'
where id = 3080;

update sys_message
set error_message = 'Feature is out of any presszone, feature_id: %feature_id%'
where id = 3108;

update sys_message
set error_message = '%id% does not exists, impossible to delete it'
where id = 3116;

update sys_message
set error_message = 'Node is connected to arc which is involved in psector %psector_list%'
where id = 3140;

update sys_message
set error_message = 'Node is involved in psector %psector_list%'
where id = 3142;

update sys_message
set error_message = 'Exploitation of the feature is different than the one of the related arc. Arc_id: %arc_id%'
where id = 3144;

update sys_message
set error_message = 'Backup name already exists %backup_name%'
where id = 3148;

update sys_message
set error_message = 'Backup has no data related to table %table_name%'
where id = 3150;

update sys_message
set error_message = 'Null values on geom1 or geom2 fields on element catalog %elementcat_id%'
where id = 3152;

update sys_message
set error_message = 'Input parameter has null value %table_name%'
where id = 3156;

update sys_message
set error_message = 'This feature with state = 2 is only attached to one psector %psector_id%'
where id = 3160;

update sys_message
set error_message = 'Id value for this catalog already exists %value%'
where id = 3166;

update sys_message
set error_message = 'You are trying to modify some network element with related connects (connec / gully) on psector not selected. %debugmsg%'
where id = 3180;

update sys_message
set error_message = 'It is not allowed to downgrade (state=0) on psector tables for planned features (state=2). Planned features only must have state=1 on psector. %psector_id%'
where id = 3182;

update sys_message
set error_message = 'It is not possible to downgrade connec because has operative hydrometer associated %feature_id%'
where id = 3194;

update sys_message
set error_message = 'Shortcut key is already defined for another feature %shortcut%'
where id = 3196;

update sys_message
set error_message = 'It''s not possible to break planned arcs by using operative nodes %arc_id%'
where id = 3202;

update sys_message
set error_message = 'Inserted feature_id does not exist on node/connec table %feature_id%'
where id = 3230;

update sys_message
set error_message = 'It''s not possible to connect to this arc because it exceed the maximum diameter configured: %diameter%'
where id = 3232;

update sys_message
set error_message = 'It''s not possible to upsert the arc because node_1 and node_2 belong to different mapzones. %zone%'
where id = 3236;

update sys_message
set error_message = 'It''s not possible to configure this node as mapzone header, because it''s not an operative nor planified node %zone%'
where id = 3242;

update sys_message
set error_message = 'It''s not possible to use selected arcs. They are not connected to node parent %nodeparent%'
where id = 3244;

update sys_message
set error_message = 'No arc exists with a smaller diameter than the maximum configuered on edit_link_check_arcdnom: %edit_link_check_arcdnom%'
where id = 3260;

update sys_message
set error_message = 'Wrong configuration. Check config_form_fields on column widgetcontrol key ''reloadfields'' for columnname: %parentname%'
where id = 3264;

update sys_message
set error_message = left(error_message, length(error_message)-1)
where error_message ilike '%.';

-- 18/12/2024
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_results', 'SELECT dscenario_id as id, name, descript, dscenario_type, parent_id, expl_id, active::TEXT, log FROM v_edit_cat_dscenario', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{
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
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [
    {
      "name": "btn_toggle_active",
      "widgetfunction": {
        "functionName": "toggle_active",
        "params": {}
      },
      "color": "default",
      "text": "Toggle active",
      "disableOnSelect": true,
      "moreThanOneDisable": true
    },
    {
      "name": "btn_create_crm",
      "widgetfunction": {
        "functionName": "create_crm",
        "params": {}
      },
      "color": "success",
      "text": "Create from CRM",
      "disableOnSelect": false,
      "moreThanOneDisable": false
    },
    {
      "name": "btn_create_mincut",
      "widgetfunction": {
        "functionName": "create_mincut",
        "params": {}
      },
      "color": "success",
      "text": "Create from Mincut",
      "disableOnSelect": false,
      "moreThanOneDisable": false
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

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_pump_1', 'lyt_pump_1', 'lytPump1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_virtualvalve_1', 'lyt_virtualvalve_1', 'lytVirtualValve1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_additional_1', 'lyt_additional_1', 'lytAdditional1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_junction_1', 'lyt_junction_1', 'lytJunction1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_connec_1', 'lyt_connec_1', 'lytConnec1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_inlet_1', 'lyt_inlet_1', 'lytInlet1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_demand_1', 'lyt_demand_1', 'lytDemand1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_pipe_1', 'lyt_pipe_1', 'lytPipe1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_virtualpump_1', 'lyt_virtualpump_1', 'lytVirtualPump1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_shortpipe_1', 'lyt_shortpipe_1', 'lytShortPipe1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_valve_1', 'lyt_valve_1', 'lytValve1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_tank_1', 'lyt_tank_1', 'lytTank1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_reservoir_1', 'lyt_reservoir_1', 'lytReservoir1', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_virtualvalve', 'tab_virtualvalve', 'tabVirtualValve', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_pump', 'tab_pump', 'tabPump', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_additional', 'tab_additional', 'tabAdditional', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_junction', 'tab_junction', 'tabJunction', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_connec', 'tab_connec', 'tabConnec', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_inlet', 'tab_inlet', 'tabInlet', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_demand', 'tab_demand', 'tabDemand', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_pipe', 'tab_pipe', 'tabPipe', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_virtualpump', 'tab_virtualpump', 'tabVirtualPump', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_shortpipe', 'tab_shortpipe', 'tabShortPipe', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_valve', 'tab_valve', 'tabValve', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_tank', 'tab_tank', 'tabTank', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_reservoir', 'tab_reservoir', 'tabReservoir', NULL);

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_pump', 'Pump', 'Pump', 'role_baisc', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_virtualvalve', 'Virtualvalve', 'Virtualvalve', 'role_baisc', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_additional', 'Additional', 'Additional', 'role_baisc', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_junction', 'Junction', 'Junction', 'role_baisc', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_connec', 'Connec', 'Connec', 'role_baisc', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_inlet', 'Inlet', 'Inlet', 'role_baisc', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_demand', 'Demand', 'Demand', 'role_baisc', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_pipe', 'Pipe', 'Pipe', 'role_baisc', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_virtualpump', 'Virtualpump', 'Virtualpump', 'role_baisc', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_shortpipe', 'Shortpipe', 'Shortpipe', 'role_baisc', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_valve', 'Valve', 'Valve', 'role_baisc', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_tank', 'Tank', 'Tank', 'role_baisc', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_reservoir', 'Reservoir', 'Reservoir', 'role_baisc', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_controls', 'Controls', 'Controls', 'role_baisc', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_rules', 'Rules', 'Rules', 'role_baisc', NULL, NULL, 0, '{5}');

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_pump', '{"layouts":["lyt_pump_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_virtualvalve', '{"layouts":["lyt_virtualvalve_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_additional', '{"layouts":["lyt_additional_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_junction', '{"layouts":["lyt_junction_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_connec', '{"layouts":["lyt_connec_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_inlet', '{"layouts":["lyt_inlet_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_demand', '{"layouts":["lyt_demand_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_pipe', '{"layouts":["lyt_pipe_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_virtualpump', '{"layouts":["lyt_virtualpump_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_shortpipe', '{"layouts":["lyt_shortpipe_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_valve', '{"layouts":["lyt_valve_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_tank', '{"layouts":["lyt_tank_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_reservoir', '{"layouts":["lyt_reservoir_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_controls', '{"layouts":["lyt_controls"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_rules', '{"layouts":["lyt_rules"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_none', 'tab_main', 'lyt_dscenario_1', 1, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_virtualvalve",
    "tab_pump",
    "tab_additional",
    "tab_controls",
    "tab_rules",
    "tab_junction",
    "tab_connec",
    "tab_inlet",
    "tab_demand",
    "tab_pipe",
    "tab_virtualpump",
    "tab_shortpipe",
    "tab_valve",
    "tab_tank",
    "tab_reservoir"
  ]
}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_demand', 'tbl_demand', 'lyt_demand_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_demand', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_pipe', 'tbl_pipe', 'lyt_pipe_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_pipe', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_virtualpump', 'tbl_virtualpump', 'lyt_virtualpump_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_virtualpump', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_shortpipe', 'tbl_shortpipe', 'lyt_shortpipe_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_shortpipe', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_valve', 'tbl_valve', 'lyt_valve_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_valve', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_tank', 'tbl_tank', 'lyt_tank_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_tank', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_reservoir', 'tbl_reservoir', 'lyt_reservoir_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_reservoir', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_virtualvalve', 'tbl_virtualvalve', 'lyt_virtualvalve_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_virtualvalve', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_pump', 'tbl_pump', 'lyt_pump_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_pump', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_additional', 'tbl_additional', 'lyt_additional_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_additional', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_controls', 'tbl_controls', 'lyt_controls_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_controls', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_rules', 'tbl_rules', 'lyt_rules_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_rules', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_junction', 'tbl_junction', 'lyt_junction_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_junction', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_connec', 'tbl_connec', 'lyt_connec_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_connec', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_inlet', 'tbl_inlet', 'lyt_inlet_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_inlet', false, 0);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_pipe', 'SELECT dscenario_id AS id, arc_id, minorloss, status, roughness, dint, bulk_coeff, wall_coeff FROM inp_dscenario_pipe where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
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
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "arc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "arc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_additional', 'SELECT id, node_id, order_id, power, curve_id, speed, pattern_id, status, energy_price, energy_pattern_id, effic_curve_id FROM inp_dscenario_pump_additional where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
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
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_rules', 'SELECT id, sector_id, "text", active::text FROM inp_dscenario_rules where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
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
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "sector_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "sector_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_virtualpump', 'SELECT dscenario_id AS id, arc_id, power, curve_id, speed, pattern_id, status, effic_curve_id, energy_price, energy_pattern_id, pump_type FROM inp_dscenario_virtualpump where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
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
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "arc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "arc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_inlet', 'SELECT dscenario_id AS id, node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, head, pattern_id, overflow, mixing_model, mixing_fraction, reaction_coeff, init_quality, source_type, source_quality, source_pattern_id, demand, demand_pattern_id, emitter_coeff FROM inp_dscenario_inlet where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
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
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_shortpipe', 'SELECT dscenario_id AS id, node_id, minorloss, status, bulk_coeff, wall_coeff FROM inp_dscenario_shortpipe where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
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
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_reservoir', 'SELECT dscenario_id AS id, node_id, pattern_id, head, init_quality, source_type, source_quality, source_pattern_id FROM inp_dscenario_reservoir where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
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
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_virtualvalve', 'SELECT dscenario_id AS id, arc_id, valv_type, pressure, diameter, flow, coef_loss, curve_id, minorloss, status FROM inp_dscenario_virtualvalve where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
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
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "arc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "arc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_controls', 'SELECT id, sector_id, "text", active::text FROM inp_dscenario_controls where id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
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
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "sector_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "sector_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_junction', 'SELECT dscenario_id AS id, node_id, demand, pattern_id, peak_factor,emitter_coeff,init_quality,source_type,source_quality,source_pattern_id FROM inp_dscenario_junction where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
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
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_valve', 'SELECT dscenario_id AS id, node_id, valv_type, pressure, flow, coef_loss, curve_id, minorloss, status, add_settings, init_quality FROM inp_dscenario_valve where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
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
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_demand', 'SELECT dscenario_id AS id, feature_id, feature_type,demand,pattern_id,demand_type,"source" FROM inp_dscenario_demand where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
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
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "feature_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "feature_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_tank', 'SELECT dscenario_id AS id, node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, overflow, mixing_model, mixing_fraction, reaction_coeff, init_quality, source_type, source_quality, source_pattern_id FROM inp_dscenario_tank  where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
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
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_pump', 'SELECT dscenario_id AS id, node_id, power, curve_id, speed, pattern_id, status, effic_curve_id, energy_price, energy_pattern_id FROM inp_dscenario_pump where dscenario_id is not null', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "DESC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
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
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_connec', 'SELECT dscenario_id AS id, connec_id, demand, pattern_id, peak_factor, status, minorloss, custom_roughness, custom_length, custom_dint, emitter_coeff, init_quality, source_type, source_quality, source_pattern_id FROM inp_dscenario_connec where dscenario_id is not null', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
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
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "connec_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "connec_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
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

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_junction', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_connec', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_pump', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_additional', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_controls', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_inlet', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_rules', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_demand', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_pipe', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_virtualpump', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_shortpipe', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_valve', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_tank', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_reservoir', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_virtualvalve', 'id', NULL, false, NULL, NULL, NULL, NULL);

UPDATE config_toolbox SET inputparams='[
  {
    "widgetname": "name",
    "label": "Scenario name:",
    "widgettype": "text",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "value": ""
  },
  {
    "widgetname": "descript",
    "label": "Scenario descript:",
    "widgettype": "text",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "value": ""
  },
  {
    "widgetname": "exploitation",
    "label": "Exploitation:",
    "widgettype": "combo",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "layoutorder": 4,
    "dvQueryText": "SELECT expl_id as id, name as idval FROM v_edit_exploitation",
    "selectedId": "",
    "comboIds": [],
    "comboNames": []
  },
  {
    "widgetname": "period",
    "label": "Source CRM period:",
    "widgettype": "combo",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "layoutorder": 5,
    "dvQueryText": "SELECT id, code as idval FROM ext_cat_period",
    "selectedId": "",
    "comboIds": [],
    "comboNames": []
  },
  {
    "widgetname": "onlyIsWaterBal",
    "label": "Only hydrometers with waterbal true:",
    "widgettype": "check",
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "layoutorder": 6,
    "value": null
  },
  {
    "widgetname": "pattern",
    "label": "Feature pattern:",
    "widgettype": "combo",
    "tooltip": "This value will be stored on pattern_id of inp_dscenario_demand table in order to be used on the inp file exportation ONLY with the pattern method FEATURE PATTERN.",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "layoutorder": 7,
    "comboIds": [
      1,
      2,
      3,
      4,
      5,
      6,
      7
    ],
    "comboNames": [
      "NONE",
      "SECTOR-DEFAULT",
      "DMA-DEFAULT",
      "DMA-PERIOD",
      "HYDROMETER-PERIOD",
      "HYDROMETER-CATEGORY",
      "FEATURE-PATTERN"
    ],
    "selectedId": ""
  },
  {
    "widgetname": "demandUnits",
    "label": "Demand units:",
    "tooltip": "Choose units to insert volume data on demand column. This value need to be the same that flow units used on EPANET. On the other hand, it is assumed that volume from hydrometer data table is expresed on m3/period and column period_seconds is filled.",
    "widgettype": "combo",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "layoutorder": 8,
    "comboIds": [
      "LPS",
      "LPM",
      "MLD",
      "CMH",
      "CMD",
      "CFS",
      "GPM",
      "MGD",
      "AFD"
    ],
    "comboNames": [
      "LPS",
      "LPM",
      "MLD",
      "CMH",
      "CMD",
      "CFS",
      "GPM",
      "MGD",
      "AFD"
    ],
    "selectedId": ""
  }
]'::json WHERE id=3110;

-- 20/12/2024
DROP FUNCTION IF EXISTS gw_fct_import_epanet_inp(p_data json);

DELETE FROM config_function
	WHERE id=2522; --gw_fct_import_epanet_inp

DELETE FROM config_toolbox
	WHERE id=2522; --gw_fct_import_epanet_inp

DELETE FROM sys_function
	WHERE id=2522; --gw_fct_import_epanet_inp

UPDATE config_form_fields SET formname = 'v_rpt_node_stats' WHERE formname = 'v_rpt_node';
UPDATE config_form_fields SET formname = 'v_rpt_node' WHERE formname = 'v_rpt_node_all';
UPDATE config_form_fields SET formname = 'v_rpt_arc_stats' WHERE formname = 'v_rpt_arc';
UPDATE config_form_fields SET formname = 'v_rpt_arc' WHERE formname = 'v_rpt_arc_all';

-- recover data from old tables
INSERT INTO rpt_arc_stats
SELECT arc_id, result_id, arc_type, sector_id, arccat_id, flow_max, flow_min, flow_avg, vel_max, vel_min, vel_avg,
headloss_max, headloss_min, setting_max, setting_min, reaction_max, reaction_min, ffactor_max, ffactor_min, NULL,
NULL, NULL, the_geom
FROM _rpt_arc_stats;

INSERT INTO archived_rpt_arc_stats
SELECT arc_id, result_id, arc_type, sector_id, arccat_id, flow_max, flow_min, flow_avg, vel_max, vel_min, vel_avg,
headloss_max, headloss_min, setting_max, setting_min, reaction_max, reaction_min, ffactor_max, ffactor_min, NULL,
NULL, NULL, the_geom
FROM _archived_rpt_arc_stats;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder,
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet,
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_pipe', 'form_feature', 'tab_epa', 'tot_headloss_max', 'lyt_epa_data_2', 21, 'string', 'text', 'Max Tot Headloss:', 'Max Tot Headloss', NULL,
false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder,
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet,
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_pipe', 'form_feature', 'tab_epa', 'tot_headloss_min', 'lyt_epa_data_2', 22, 'string', 'text', 'Min Tot Headloss:', 'Min Tot Headloss', NULL,
false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder,
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet,
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_rpt_arc', 'form_feature', 'tab_none', 'length', NULL, NULL, 'double', 'text', 'length', 'length', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder,
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet,
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_rpt_arc', 'form_feature', 'tab_none', 'tot_headloss', NULL, NULL, 'double', 'text', 'tot_headloss', 'tot_headloss', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder,
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet,
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_rpt_arc_stats', 'form_feature', 'tab_none', 'length', NULL, NULL, 'double', 'text', 'length', 'length', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder,
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet,
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_rpt_arc_stats', 'form_feature', 'tab_none', 'tot_headloss_max', NULL, NULL, 'double', 'text', 'tot_headloss_max', 'tot_headloss_max', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder,
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet,
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_rpt_arc_stats', 'form_feature', 'tab_none', 'tot_headloss_min', NULL, NULL, 'double', 'text', 'tot_headloss_min', 'tot_headloss_min', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

-- 21/01/2025
INSERT INTO arc_add (arc_id, flow_max, flow_min, flow_avg, vel_max, vel_min, vel_avg, tot_headloss_max, tot_headloss_min, result_id)
SELECT arc_id, flow_max, flow_min, flow_avg, vel_max, vel_min, vel_avg, NULL, NULL, result_id
FROM _arc_add_;


-- 23/01/2025
UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false,"text":"Cancel mincut", "onContextMenu":"Cancel mincut"}'::json
	WHERE formname='mincut_manager' AND formtype='form_mincut' AND columnname='cancel_mincut';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false,"text":"Cancel mincut", "onContextMenu":"Delete mincut"}'::json
	WHERE formname='mincut_manager' AND formtype='form_mincut' AND columnname='delete';

UPDATE config_function SET "style"='{
  "style": {
    "point": {
      "style": "unique",
      "values": {
        "width": 3.5,
        "color": [
          255,
          165,
          1
        ],
        "transparency": 1
      }
    },
    "line": {
      "style": "categorized",
      "field": "hydrant_id",
      "width": 2,
      "transparency": 0.5
    },
    "polygon": {
      "style": "unique",
      "values": {
        "width": 3,
        "color": [
          255,
          1,
          1
        ],
        "transparency": 0.5
      }
    }
  }
}'::json WHERE id=3160;


-- 27/01/2025

-- Insert missing mapzone sector widgets
INSERT INTO config_form_fields VALUES ('v_ui_sector','form_feature','tab_none','muni_id','lyt_data_1',4,'text','text','muni_id','muni_id','1,2',false,false,true,false, NULL,'SELECT muni_id as id, name as idval FROM ext_municipality WHERE muni_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_sector','form_feature','tab_none','expl_id','lyt_data_1',5,'text','text','expl_id','expl_id','1,2',false,false,true,false, NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_sector','form_feature','tab_none','avg_press','lyt_data_1',14,'numeric','text','average pressure','avg_press', NULL,false,false,true,false,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_sector','form_feature','tab_none','link','lyt_data_1',15,'text','text','link','link', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);

-- Insert missing mapzone dma widgets
INSERT INTO config_form_fields VALUES ('v_ui_dma','form_feature','tab_none','muni_id','lyt_data_1',4,'text','text','muni_id','muni_id','1,2',false,false,true,false, NULL,'SELECT muni_id as id, name as idval FROM ext_municipality WHERE muni_id IS NOT NULL',true,false, NULL, NULL,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_dma','form_feature','tab_none','sector_id','lyt_data_1',6,'text','text','sector_id','sector_id','1,2',false,false,true,false, NULL,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false, NULL, NULL,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_dma','form_feature','tab_none','minc','lyt_data_1',11,'double','text','minc','minc', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_dma','form_feature','tab_none','maxc','lyt_data_1',12,'double','text','maxc','maxc', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);

-- Update mapzone dma widgets
UPDATE config_form_fields SET datatype = 'text', widgettype = 'text', placeholder = '1,2' WHERE formname = 'v_ui_dma' AND formtype = 'form_feature' AND tabname = 'tab_none' AND columnname = 'expl_id';
UPDATE config_form_fields SET columnname='macrodma', datatype='string', label='macrodma', tooltip='macrodma', dv_querytext='SELECT name as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL', hidden=false WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='macrodma_id' AND tabname='tab_none';

-- Insert missing mapzone presszone widgets
INSERT INTO config_form_fields VALUES ('v_ui_presszone','form_feature','tab_none','muni_id','lyt_data_1',4,'text','text','muni_id','muni_id','1,2',false,false,true,false, NULL,'SELECT muni_id as id, name as idval FROM ext_municipality WHERE muni_id IS NOT NULL',true,false, NULL, NULL,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_presszone','form_feature','tab_none','sector_id','lyt_data_1',6,'text','text','sector_id','sector_id','1,2',false,false,true,false, NULL,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false, NULL, NULL,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_presszone','form_feature','tab_none','undelete','lyt_data_1',6,'boolean','check','undelete','undelete',NULL,false,false,true,false, NULL,NULL,true,false, NULL, NULL,NULL,NULL, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_presszone','form_feature','tab_none','link','lyt_data_1',9,'text','text','link','link', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_presszone','form_feature','tab_none','avg_press','lyt_data_1',13,'numeric','text','average pressure','avg_press', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);

-- Update mapzone presszone widgets
UPDATE config_form_fields SET datatype = 'text', widgettype = 'text', placeholder = '1,2' WHERE formname = 'v_ui_presszone' AND formtype = 'form_feature' AND tabname = 'tab_none' AND columnname = 'expl_id';

-- Insert missing mapzone dqa widgets
INSERT INTO config_form_fields VALUES ('v_ui_dqa','form_feature','tab_none','muni_id','lyt_data_1',4,'text','text','muni_id','muni_id','1,2',false,false,true,false, NULL,'SELECT muni_id as id, name as idval FROM ext_municipality WHERE muni_id IS NOT NULL',true,false, NULL, NULL,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_dqa','form_feature','tab_none','sector_id','lyt_data_1',6,'text','text','sector_id','sector_id','1,2',false,false,true,false, NULL,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false, NULL, NULL,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_dqa','form_feature','tab_none','avg_press','lyt_data_1',15,'numeric','text','average pressure','avg_press', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);

-- Update mapzone dqa widgets
UPDATE config_form_fields SET datatype = 'text', widgettype = 'text', placeholder = '1,2' WHERE formname = 'v_ui_dqa' AND formtype = 'form_feature' AND tabname = 'tab_none' AND columnname = 'expl_id';
UPDATE config_form_fields SET "datatype"='string', "label"='macrodqa', tooltip='macrodqa', columnname='macrodqa', dv_querytext='SELECT name as id, name as idval FROM macrodqa WHERE macrodqa_id IS NOT NULL' WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='macrodqa_id' AND tabname='tab_none';

-- Insert supplyzone types
INSERT INTO edit_typevalue VALUES('supplyzone_type', 'DISTRIBUTION', 'DISTRIBUTION', NULL, NULL);
INSERT INTO edit_typevalue VALUES('supplyzone_type', 'SOURCE', 'SOURCE', NULL, NULL);
INSERT INTO edit_typevalue VALUES('supplyzone_type', 'UNDEFINED', 'UNDEFINED', NULL, NULL);

-- Insert mapzone supplyzones widgets
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'supplyzone_id', 'lyt_data_1', 1, 'integer', 'text', 'supplyzone_id', 'supplyzone_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"NULLValue":true, "layer": "v_edit_supplyzone", "activated": true, "keyColumn": "supplyzone_id", "valueColumn": "name", "filterExpression": null}}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 2, 'string', 'text', 'name', 'name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'supplyzone_type', 'lyt_data_1', 3, 'string', 'combo', 'supplyzone_type', 'supplyzone_type', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue=''supplyzone_type''', true, true, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'macrosector', 'lyt_data_1', 4, 'string', 'combo', 'macrosector', 'macrosector', NULL, false, false, true, false, NULL, 'SELECT name as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 5, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 6, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'undelete', 'lyt_data_1', 7, 'boolean', 'check', 'undelete', 'undelete', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'parent_id', 'lyt_data_1', 8, 'string', 'combo', 'parent_id', 'parent_id', NULL, false, false, true, false, false, 'SELECT supplyzone_id as id,name as idval FROM v_ui_supplyzone WHERE supplyzone_id > -1 AND active IS TRUE', true, true, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"NULLValue":true, "layer": "v_edit_supplyzone", "activated": true, "keyColumn": "supplyzone_id", "valueColumn": "name", "filterExpression": "supplyzone_id > -1 AND active IS TRUE"}}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'pattern_id', 'lyt_data_1', 9, 'string', 'combo', 'pattern_id', 'pattern_id', NULL, false, false, true, false, false, 'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL', true, true, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"NULLValue":true, "layer": "v_edit_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'graphconfig', 'lyt_data_1', 10, 'string', 'text', 'graphconfig', 'graphconfig', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'stylesheet', 'lyt_data_1', 11, 'string', 'text', 'stylesheet', 'stylesheet', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_supplyzone','form_feature','tab_none','avg_press','lyt_data_1',12,'numeric','text','average pressure','avg_press', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_supplyzone','form_feature','tab_none','link','lyt_data_1',13,'text','text','link','link', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_supplyzone','form_feature','tab_none','muni_id','lyt_data_1',14,'text','text','muni_id','muni_id', '1,2',false,false,true,false, NULL,'SELECT muni_id as id, name as idval FROM ext_municipity WHERE muni_id IS NOT NULL', true, true, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_supplyzone','form_feature','tab_none','expl_id','lyt_data_1',15,'text','text','expl_id','expl_id', '1,2',false,false,true,false, NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, true, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);


-- Insert mapzone macrodma widgets
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'macrodma_id', 'lyt_data_1', 1, 'integer', 'text', 'macrodma_id', 'macrodma_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "valueRelation":{"NULLValue":true, "layer": "v_edit_macrodma", "activated": true, "keyColumn": "macrodma_id", "valueColumn": "name", "filterExpression": null}}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 2, 'string', 'text', 'name', 'name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 3, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 4, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'undelete', 'lyt_data_1', 5, 'boolean', 'check', 'undelete', 'undelete', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'expl_id', 'lyt_data_1',6, 'text', 'text', 'expl_id', 'expl_id', '1', false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

-- Insert mapzone macrosector widgets
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'macrosector_id', 'lyt_data_1', 1, 'integer', 'text', 'macrosector_id', 'macrosector_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "valueRelation":{"NULLValue":true, "layer": "v_edit_macrosector", "activated": true, "keyColumn": "macrosector_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 2, 'string', 'text', 'name', 'name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 3, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 4, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'undelete', 'lyt_data_1', 5, 'boolean', 'check', 'undelete', 'undelete', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

-- 28/01/2025

-- Insert new error messages
INSERT INTO sys_message
(id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES(3276, 'Some exploitation ids don''t exist', 'Insert exploitation ids that exist', 1, true, 'utils', 'core');

INSERT INTO sys_message (id,error_message,hint_message,log_level,show_user,project_type,"source")
	VALUES (3278,'Some municipality ids don''t exist','Insert municipality ids that exist',1,true,'utils','core');

INSERT INTO sys_message (id,error_message,hint_message,log_level,show_user,project_type,"source")
	VALUES (3280,'Some sector ids don''t exist','Insert sector ids that exist',1,true,'utils','core');

-- Insert new supplyzone trigger to sys_function
INSERT INTO sys_function
(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3378, 'gw_trg_edit_supplyzone', 'ws', 'trigger', NULL, NULL, 'Trigger to insert, update or delete elements in supplyzone from v_ui_supplyzone or v_edit_supplyzone', 'role_edit', NULL, 'core');

-- 29/01/2025
UPDATE config_param_system SET value='{"sys_display_name":"concat(connec_id, '' : '', conneccat_id)","sys_tablename":"v_edit_connec","sys_pk":"connec_id","sys_fct":"gw_fct_getinfofromid","sys_filter":"","sys_geom":"the_geom"}' WHERE "parameter"='basic_search_v2_tab_network_connec';

UPDATE config_form_fields SET datatype = 'integer', widgettype = 'combo', label = 'Verified', tooltip = 'verified', iseditable = true,
dv_querytext = 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_verified''',
dv_orderby_id = true, dv_isnullvalue = true, widgetcontrols = '{"setMultiline": false, "labelPosition": "top"}'::json WHERE columnname = 'verified';

-- 31/01/2025

UPDATE config_csv SET descript='The csv file must have the following fields:
dscenario_name, feature_id, feature_type, value, demand_type, pattern_id, source' WHERE fid=501;
