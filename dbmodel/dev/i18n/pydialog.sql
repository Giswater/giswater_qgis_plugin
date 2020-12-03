/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- get priority in terms of translate
select count(*), source from i18n.dbdialog group by source order by 1 desc


select count(*), source, lb_enen from i18n.pydialog group by source,lb_enen order by 1 desc

select * from i18n.pydialog

-- translate it

-- btn_accept
update i18n.dbdialog set lb_eses = 'Aceptar' where source = 'btn_accept' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'Aceptar' where source = 'btn_accept' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Acceptar' where source = 'btn_accept' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'Acceptar' where source = 'btn_accept' and tt_caes is null;

update i18n.dbdialog set lb_ptpt = 'Aceitar' where source = 'btn_accept' and lb_ptpt is null;
update i18n.dbdialog set tt_ptpt = 'Aceitar' where source = 'btn_accept' and tt_ptpt is null;

-- btn_cancel
update i18n.dbdialog set lb_eses = 'Cancelar' where source = 'btn_cancel' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'Cancelar' where source = 'btn_cancel' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Cancelar' where source = 'btn_cancel' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'Cancelar' where source = 'btn_cancel' and tt_caes is null;

update i18n.dbdialog set lb_ptpt = 'Cancelar' where source = 'btn_cancel' and lb_ptpt is null;
update i18n.dbdialog set tt_ptpt = 'Cancelar' where source = 'btn_cancel' and tt_ptpt is null;



"btn_close";"Close"
"btn_delete";"Delete"
"btn_insert";""
"btn_delete";""
"btn_cancel";"Close"
"btn_snapping";""
"lbl_visit_id";"Visit id:"
"lbl_link";"Link:"
"tab_relations";"Relations"
"tab_loginfo";"Info log"
"btn_open";"Open"
"btn_path";"..."
"lbl_parameter_id";"Parameter id:"
"lbl_code";"Code:"
"tab_arc";"Arc"
"lbl_text";"Text:"
"lbl_descript";"Description:"
"lbl_enabled";"Enabled:"
"lbl_template";"Template:"
"tab_connec";"Connec"
"tab_gully";"Gully"
"lbl_rotation";"Rotation:"
"lbl_position_value";"Position value:"
"lbl_workcat_id_end";"Workcat id end:"
"lbl_editable";"Editable:"
"tab_node";"Node"
"lbl_files";"Files:"
"lbl_position_id";"Position id:"
"lbl_state";"State:"
"lbl_mandatory";"Mandatory:"
"lbl_id";"Id:"
"lbl_query_text";"Query text:"
"lbl_observ";"Observations:"
"btn_doc_insert";""
"lbl_placeholder";"Placeholder:"
"lbl_value2";"Value 2:"
"lbl_enddate";"End date:"
"lbl_start_date";"From:"
"lbl_stylesheet";"Stylesheet:"
"tab_config";"Config"
"lbl_label";"Label:"
"lbl_title";"Title:"
"tab_update";"Update"
"lbl_user_name";"User name:"
"btn_open_doc";""
"btn_run";"Run"
"lbl_value";"Value:"
"btn_delete_file";"Delete file"
"lbl_editability";"Editability:"
"lbl_data_type";"Data type:"
"btn_add_geom";"Add geom"
"tab_info_log";"Info log"
"lbl_descript";"Descript:"
"lbl_geom1";"Geom 1:"
"lbl_feature_type";"Feature type:"
"lbl_geom3";"Geom 3:"
"lbl_tooltip";"Tooltip:"
"lbl_geom2";"Geom 2:"
"lbl_end_date";"To:"
"tab_rpt";"Rpt"
"lbl_event_id";"Event id:"
"lbl_info";"Info:"
"lbl_value1";"Value 1:"
"btn_ok";"Accept"
"tab_create";"Create"
"btn_doc_delete";""
"btn_add_file";"Add file"
"lbl_form_type";"Form type:"
"lbl_msg";"No results found"
"lbl_work_order";"Work order:"
"btn_doc_new";""
"lbl_doc_id";"Doc id:"
"lbl_active";"Active:"

