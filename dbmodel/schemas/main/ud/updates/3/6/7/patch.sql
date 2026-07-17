/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"stylesheet", "dataType":"json", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"stylesheet", "dataType":"json", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"stylesheet", "dataType":"json", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"stylesheet", "dataType":"json", "isUtils":"False"}}$$);


CREATE OR REPLACE VIEW v_edit_sector
AS SELECT sector.sector_id,
    sector.name,
    sector.descript,
    sector.macrosector_id,
    sector.the_geom,
    sector.undelete,
    sector.active,
    sector.parent_id,
    sector.stylesheet
   FROM selector_sector,
    sector
  WHERE sector.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_dma
AS SELECT dma.dma_id,
    dma.name,
    dma.macrodma_id,
    dma.descript,
    dma.the_geom,
    dma.undelete,
    dma.expl_id,
    dma.pattern_id,
    dma.link,
    dma.minc,
    dma.maxc,
    dma.effc,
    dma.active,
    dma.stylesheet
   FROM selector_expl,
    dma
  WHERE dma.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;



--vu_connec
CREATE OR REPLACE VIEW vu_connec
AS SELECT connec.connec_id,
    connec.code,
    connec.customer_code,
    connec.top_elev,
    connec.y1,
    connec.y2,
    connec.connecat_id,
    connec.connec_type,
    cat_feature.system_id AS sys_type,
    connec.private_connecat_id,
        CASE
            WHEN connec.matcat_id IS NULL THEN cat_connec.matcat_id
            ELSE connec.matcat_id
        END AS matcat_id,
    connec.expl_id,
    exploitation.macroexpl_id,
    connec.sector_id,
    sector.macrosector_id,
    connec.demand,
    connec.state,
    connec.state_type,
        CASE
            WHEN ((connec.y1 + connec.y2) / 2::numeric) IS NOT NULL THEN ((connec.y1 + connec.y2) / 2::numeric)::numeric(12,3)
            ELSE connec.connec_depth
        END AS connec_depth,
    connec.connec_length,
    connec.arc_id,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.dma_id,
    dma.macrodma_id,
    connec.soilcat_id,
    connec.function_type,
    connec.category_type,
    connec.fluid_type,
    connec.location_type,
    connec.workcat_id,
    connec.workcat_id_end,
    connec.buildercat_id,
    connec.builtdate,
    connec.enddate,
    connec.ownercat_id,
    connec.muni_id,
    connec.postcode,
    connec.district_id,
    c.descript::character varying(100) AS streetname,
    connec.postnumber,
    connec.postcomplement,
    d.descript::character varying(100) AS streetname2,
    connec.postnumber2,
    connec.postcomplement2,
    connec.descript,
    cat_connec.svg,
    connec.rotation,
    concat(cat_feature.link_path, connec.link) AS link,
    connec.verified,
    connec.undelete,
    cat_connec.label,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    connec.accessibility,
    connec.diagonal,
    connec.publish,
    connec.inventory,
    connec.uncertain,
    connec.num_value,
    connec.pjoint_id,
    connec.pjoint_type,
    date_trunc('second'::text, connec.tstamp) AS tstamp,
    connec.insert_user,
    date_trunc('second'::text, connec.lastupdate) AS lastupdate,
    connec.lastupdate_user,
    connec.the_geom,
    connec.workcat_id_plan,
    connec.asset_id,
    connec.drainzone_id,
    connec.expl_id2,
    vst.is_operative,
    mu.region_id,
    mu.province_id,
    connec.adate,
    connec.adescript,
    connec.plot_code
   FROM connec
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN exploitation ON connec.expl_id = exploitation.expl_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN cat_feature ON connec.connec_type::text = cat_feature.id::text
     LEFT JOIN v_ext_streetaxis c ON c.id::text = connec.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = connec.streetaxis2_id::text
     LEFT JOIN value_state_type vst ON vst.id = connec.state_type
     LEFT JOIN ext_municipality mu ON connec.muni_id = mu.muni_id;


CREATE OR REPLACE VIEW v_connec
AS SELECT vu_connec.connec_id,
    vu_connec.code,
    vu_connec.customer_code,
    vu_connec.top_elev,
    vu_connec.y1,
    vu_connec.y2,
    vu_connec.connecat_id,
    vu_connec.connec_type,
    vu_connec.sys_type,
    vu_connec.private_connecat_id,
    vu_connec.matcat_id,
    vu_connec.expl_id,
    vu_connec.macroexpl_id,
        CASE
            WHEN a.sector_id IS NULL THEN vu_connec.sector_id
            ELSE a.sector_id
        END AS sector_id,
        CASE
            WHEN a.macrosector_id IS NULL THEN vu_connec.macrosector_id
            ELSE a.macrosector_id
        END AS macrosector_id,
    vu_connec.demand,
    vu_connec.state,
    vu_connec.state_type,
    vu_connec.connec_depth,
    vu_connec.connec_length,
    v_state_connec.arc_id,
    vu_connec.annotation,
    vu_connec.observ,
    vu_connec.comment,
        CASE
            WHEN a.dma_id IS NULL THEN vu_connec.dma_id
            ELSE a.dma_id
        END AS dma_id,
        CASE
            WHEN a.macrodma_id IS NULL THEN vu_connec.macrodma_id
            ELSE a.macrodma_id
        END AS macrodma_id,
    vu_connec.soilcat_id,
    vu_connec.function_type,
    vu_connec.category_type,
    vu_connec.fluid_type,
    vu_connec.location_type,
    vu_connec.workcat_id,
    vu_connec.workcat_id_end,
    vu_connec.buildercat_id,
    vu_connec.builtdate,
    vu_connec.enddate,
    vu_connec.ownercat_id,
    vu_connec.muni_id,
    vu_connec.postcode,
    vu_connec.district_id,
    vu_connec.streetname,
    vu_connec.postnumber,
    vu_connec.postcomplement,
    vu_connec.streetname2,
    vu_connec.postnumber2,
    vu_connec.postcomplement2,
    vu_connec.descript,
    vu_connec.svg,
    vu_connec.rotation,
    vu_connec.link,
    vu_connec.verified,
    vu_connec.undelete,
    vu_connec.label,
    vu_connec.label_x,
    vu_connec.label_y,
    vu_connec.label_rotation,
    vu_connec.accessibility,
    vu_connec.diagonal,
    vu_connec.publish,
    vu_connec.inventory,
    vu_connec.uncertain,
    vu_connec.num_value,
        CASE
            WHEN a.exit_id IS NULL THEN vu_connec.pjoint_id
            ELSE a.exit_id
        END AS pjoint_id,
        CASE
            WHEN a.exit_type IS NULL THEN vu_connec.pjoint_type
            ELSE a.exit_type
        END AS pjoint_type,
    vu_connec.tstamp,
    vu_connec.insert_user,
    vu_connec.lastupdate,
    vu_connec.lastupdate_user,
    vu_connec.the_geom,
    vu_connec.workcat_id_plan,
    vu_connec.asset_id,
    vu_connec.drainzone_id,
    vu_connec.expl_id2,
    vu_connec.is_operative,
    vu_connec.region_id,
    vu_connec.province_id,
    vu_connec.adate,
    vu_connec.adescript,
    vu_connec.plot_code
   FROM vu_connec
     JOIN v_state_connec USING (connec_id)
     LEFT JOIN ( SELECT DISTINCT ON (vu_link.feature_id) vu_link.link_id,
            vu_link.feature_type,
            vu_link.feature_id,
            vu_link.exit_type,
            vu_link.exit_id,
            vu_link.state,
            vu_link.expl_id,
            vu_link.sector_id,
            vu_link.dma_id,
            vu_link.exit_topelev,
            vu_link.exit_elev,
            vu_link.fluid_type,
            vu_link.gis_length,
            vu_link.the_geom,
            vu_link.sector_name,
            vu_link.macrosector_id,
            vu_link.macrodma_id
           FROM vu_link
             JOIN selector_expl USING (expl_id)
          WHERE selector_expl.cur_user = CURRENT_USER AND vu_link.state = 2) a ON a.feature_id::text = vu_connec.connec_id::text;


CREATE OR REPLACE VIEW v_edit_connec
AS SELECT v_connec.connec_id,
    v_connec.code,
    v_connec.customer_code,
    v_connec.top_elev,
    v_connec.y1,
    v_connec.y2,
    v_connec.connecat_id,
    v_connec.connec_type,
    v_connec.sys_type,
    v_connec.private_connecat_id,
    v_connec.matcat_id,
    v_connec.expl_id,
    v_connec.macroexpl_id,
    v_connec.sector_id,
    v_connec.macrosector_id,
    v_connec.demand,
    v_connec.state,
    v_connec.state_type,
    v_connec.connec_depth,
    v_connec.connec_length,
    v_connec.arc_id,
    v_connec.annotation,
    v_connec.observ,
    v_connec.comment,
    v_connec.dma_id,
    v_connec.macrodma_id,
    v_connec.soilcat_id,
    v_connec.function_type,
    v_connec.category_type,
    v_connec.fluid_type,
    v_connec.location_type,
    v_connec.workcat_id,
    v_connec.workcat_id_end,
    v_connec.buildercat_id,
    v_connec.builtdate,
    v_connec.enddate,
    v_connec.ownercat_id,
    v_connec.muni_id,
    v_connec.postcode,
    v_connec.district_id,
    v_connec.streetname,
    v_connec.postnumber,
    v_connec.postcomplement,
    v_connec.streetname2,
    v_connec.postnumber2,
    v_connec.postcomplement2,
    v_connec.descript,
    v_connec.svg,
    v_connec.rotation,
    v_connec.link,
    v_connec.verified,
    v_connec.undelete,
    v_connec.label,
    v_connec.label_x,
    v_connec.label_y,
    v_connec.label_rotation,
    v_connec.accessibility,
    v_connec.diagonal,
    v_connec.publish,
    v_connec.inventory,
    v_connec.uncertain,
    v_connec.num_value,
    v_connec.pjoint_id,
    v_connec.pjoint_type,
    v_connec.tstamp,
    v_connec.insert_user,
    v_connec.lastupdate,
    v_connec.lastupdate_user,
    v_connec.the_geom,
    v_connec.workcat_id_plan,
    v_connec.asset_id,
    v_connec.drainzone_id,
    v_connec.expl_id2,
    v_connec.is_operative,
    v_connec.region_id,
    v_connec.province_id,
    v_connec.adate,
    v_connec.adescript,
    v_connec.plot_code
   FROM v_connec;
       
CREATE OR REPLACE VIEW ve_connec
AS SELECT v_connec.connec_id,
    v_connec.code,
    v_connec.customer_code,
    v_connec.top_elev,
    v_connec.y1,
    v_connec.y2,
    v_connec.connecat_id,
    v_connec.connec_type,
    v_connec.sys_type,
    v_connec.private_connecat_id,
    v_connec.matcat_id,
    v_connec.expl_id,
    v_connec.macroexpl_id,
    v_connec.sector_id,
    v_connec.macrosector_id,
    v_connec.demand,
    v_connec.state,
    v_connec.state_type,
    v_connec.connec_depth,
    v_connec.connec_length,
    v_connec.arc_id,
    v_connec.annotation,
    v_connec.observ,
    v_connec.comment,
    v_connec.dma_id,
    v_connec.macrodma_id,
    v_connec.soilcat_id,
    v_connec.function_type,
    v_connec.category_type,
    v_connec.fluid_type,
    v_connec.location_type,
    v_connec.workcat_id,
    v_connec.workcat_id_end,
    v_connec.buildercat_id,
    v_connec.builtdate,
    v_connec.enddate,
    v_connec.ownercat_id,
    v_connec.muni_id,
    v_connec.postcode,
    v_connec.district_id,
    v_connec.streetname,
    v_connec.postnumber,
    v_connec.postcomplement,
    v_connec.streetname2,
    v_connec.postnumber2,
    v_connec.postcomplement2,
    v_connec.descript,
    v_connec.svg,
    v_connec.rotation,
    v_connec.link,
    v_connec.verified,
    v_connec.undelete,
    v_connec.label,
    v_connec.label_x,
    v_connec.label_y,
    v_connec.label_rotation,
    v_connec.accessibility,
    v_connec.diagonal,
    v_connec.publish,
    v_connec.inventory,
    v_connec.uncertain,
    v_connec.num_value,
    v_connec.pjoint_id,
    v_connec.pjoint_type,
    v_connec.tstamp,
    v_connec.insert_user,
    v_connec.lastupdate,
    v_connec.lastupdate_user,
    v_connec.the_geom,
    v_connec.workcat_id_plan,
    v_connec.asset_id,
    v_connec.drainzone_id,
    v_connec.expl_id2,
    v_connec.is_operative,
    v_connec.region_id,
    v_connec.province_id,
    v_connec.adate,
    v_connec.adescript,
    v_connec.plot_code
   FROM v_connec;  
         
  
--SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"featureType":"CONNEC"},
-- "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-UPDATE", "newColumn":"plot_code" }}$$);




drop view if exists vi_subcatch2outlet;

CREATE OR REPLACE VIEW v_edit_inp_subc2outlet
AS SELECT a.subc_id,
    a.outlet_id,
    a.outlet_type,
    st_length2d(a.the_geom) AS length,
    a.hydrology_id,
    a.the_geom
   FROM ( SELECT s1.subc_id,
            s1.outlet_id,
            'JUNCTION'::text AS outlet_type,
            s1.hydrology_id,
            st_makeline(st_centroid(s1.the_geom), node.the_geom)::geometry(LineString, SRID_VALUE) AS the_geom
           FROM v_edit_inp_subcatchment s1
             JOIN node ON node.node_id::text = s1.outlet_id::text
        UNION
         SELECT s1.subc_id,
            s1.outlet_id,
            'SUBCATCHMENT'::text AS outlet_type,
            s1.hydrology_id,
            st_makeline(st_centroid(s1.the_geom), st_centroid(s2.the_geom))::geometry(LineString, SRID_VALUE) AS the_geom
           FROM v_edit_inp_subcatchment s1
             JOIN v_edit_inp_subcatchment s2 ON s1.outlet_id::text = s2.subc_id::text) a;

DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON cat_arc_shape;
ALTER TABLE cat_arc_shape DROP CONSTRAINT cat_arc_shape_check;
INSERT INTO cat_arc_shape VALUES ('UNKNOWN','UNKNOWN') ON CONFLICT (id) DO NOTHING;
ALTER TABLE cat_arc_shape ADD CONSTRAINT cat_arc_shape_check CHECK (epa::text = ANY (ARRAY['VERT_ELLIPSE'::character varying::text, 'ARCH'::character varying::text, 'BASKETHANDLE'::character varying::text, 'CIRCULAR'::character varying::text, 'CUSTOM'::character varying::text, 'DUMMY'::character varying::text, 'EGG'::character varying::text, 'FILLED_CIRCULAR'::character varying::text, 'FORCE_MAIN'::character varying::text, 'HORIZ_ELLIPSE'::character varying::text, 'HORSESHOE'::character varying::text, 'IRREGULAR'::character varying::text, 'MODBASKETHANDLE'::character varying::text, 'PARABOLIC'::character varying::text, 'POWER'::character varying::text, 'RECT_CLOSED'::character varying::text, 'RECT_OPEN'::character varying::text, 'RECT_ROUND'::character varying::text, 'RECT_TRIANGULAR'::character varying::text, 'SEMICIRCULAR'::character varying::text, 'SEMIELLIPTICAL'::character varying::text, 'TRAPEZOIDAL'::character varying::text, 'TRIANGULAR'::character varying::text, 'VIRTUAL'::character varying::text, 'UNKNOWN'::character varying::text]));

UPDATE cat_arc SET shape = 'UNKNOWN' WHERE shape is null;
ALTER TABLE cat_arc ALTER COLUMN shape SET NOT NULL;

INSERT INTO inp_typevalue VALUES ('inp_options_networkmode_', '3', '1D/2D SWMM-IBER WET');

UPDATE config_toolbox set inputparams = (replace(inputparams::text, '"$userExploitation"', '""'))::json where id = 2768;


update config_form_fields set tabname = 'tab_epa' where formname like 've_epa%' and tabname = 'tab_none';
update config_form_fields set dv_isnullvalue = true where tabname = 'tab_epa' and formname = 've_epa_orifice' and columnname in ('ori_type', 'shape', 'flap');
update config_form_fields set dv_isnullvalue = true where tabname = 'tab_epa' and formname = 've_epa_weir' and columnname in ('weir_type', 'flap');
update config_form_fields set dv_isnullvalue = true where tabname = 'tab_epa' and formname = 've_epa_pump' and columnname in ('curve_id', 'status');
update config_form_fields set dv_isnullvalue = true where tabname = 'tab_epa' and formname = 've_epa_outlet' and columnname in ('outlet_type', 'curve_id', 'flap');


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") 
VALUES(3298, 'gw_fct_import_inp_dwf', 'ud', 'function', 'json', 'json', 'Function to import DWF values. ', 'role_epa', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) 
VALUES(527, 'Import dwf values', 'ud', NULL, 'core' , NULL, 'Function process', NULL)
ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_csv (fid, alias, descript, functionname, active, orderby, addparam) 
VALUES(527, 'Import DWF', 'Function to import DWF values. The CSV file must contain the following columns in the exact same order:   dwfscenario_id, node_id, value, pat1, pat2, pat3, pat4', 'gw_fct_import_inp_dwf', true, 21, NULL)
ON CONFLICT (fid) DO NOTHING;

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


UPDATE config_form_fields SET widgetfunction='{"functionName": "open_selected_path", "parameters":{"targetwidget":"tab_hydrometer_tbl_hydrometer", "columnfind": "hydrometer_link"}}'::json WHERE columnname='btn_link' AND tabname='tab_hydrometer';


UPDATE sys_table SET id='v_edit_inp_subc2outlet' where id='vi_subcatch2outlet'; 

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") 
VALUES(3300, 'gw_trg_edit_inp_subc2outlet', 'ud', 'trigger function', NULL, NULL, NULL, 'role_master', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source") 
VALUES(3252, 'There is no subcatchment or outlet_id nearby', 'Place the line inside a subcatchment or use the snapping tool to set an outlet_id for the subcatchment.', 2, true, 'utils', 'core')
ON CONFLICT (id) DO NOTHING;

UPDATE sys_function SET descript ='Function to analyze graph of network. Dynamic analisys to sectorize network using the flow traceability function. 
Before working with this funcion, it is mandatory to configurate graphconfig on drainzone table'
WHERE function_name='gw_fct_graphanalytics_mapzones';

UPDATE sys_function SET descript='Function to analyze network as a graph. Analysis is only avaliable for DRAINZONE. Before starting, you need to configurate:
- Field graphconfig on drainzone table.
- Enable status for variable utils_graphanalytics_status on [config_param_system] table.
Stop your mouse over labels for more information about input parameters.'
WHERE function_name='gw_fct_graphanalytics_mapzones_advanced';

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(528, 'Check outlet_id existance in inp_subcatchment and inp_junction', 'ud', NULL, 'core', true, 'Check epa-data', NULL)
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) 
VALUES(529, 'Check missing data in Inp Weir', 'ud', NULL, 'core', true, 'Check epa-data', NULL)
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) 
VALUES(530, 'Check missing data in Inp Orifice', 'ud', NULL, 'core', true, 'Check epa-data', NULL)
ON CONFLICT (fid) DO NOTHING;


UPDATE config_toolbox SET inputparams =
'[
{"widgetname":"name", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for hydrology scenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"infiltration", "label":"Infiltration:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Infiltration", "dvQueryText":"SELECT id, idval FROM inp_typevalue WHERE typevalue =''inp_value_options_in''", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"text", "label":"Text:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Text of hydrology scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"hydrology scenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":5, "value":"true"}
]'
where id = 3290;

ALTER TABLE arc ALTER COLUMN dma_id DROP NOT NULL;
ALTER TABLE node ALTER COLUMN dma_id DROP NOT NULL;
ALTER TABLE connec ALTER COLUMN dma_id DROP NOT NULL;
ALTER TABLE gully ALTER COLUMN dma_id DROP NOT NULL;
ALTER TABLE link ALTER COLUMN dma_id DROP NOT NULL;

CREATE TRIGGER gw_trg_edit_inp_subc2outlet instead of insert or delete or Update 
on v_edit_inp_subc2outlet for each row execute function gw_trg_edit_inp_subc2outlet();
