/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- Insert into sys_feature_epa_type
INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('WEIR', 'ELEMENT', 'inp_flwreg_weir', NULL, true);
INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('ORIFICE', 'ELEMENT', 'inp_flwreg_orifice', NULL, true);
INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('OUTLET', 'ELEMENT', 'inp_flwreg_outlet', NULL, true);

-- Adding flowregulator objects on cat_feature [Modified from first version]
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('FRORIFICE', 'FLWREG', 'ELEMENT', 'v_edit_element', 've_elem_frorifice', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('FROUTLET', 'FLWREG', 'ELEMENT', 'v_edit_element', 've_elem_froutlet', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('FRWEIR', 'FLWREG', 'ELEMENT', 'v_edit_element', 've_elem_frweir', true) ON CONFLICT (id) DO NOTHING;
-- Adding objects on config_info_layer and config_info_layer_x_type (this both tables controls the button info)


INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('INLETPIPE', 'LINK', 'UNDEFINED', 'man_inletpipe');

INSERT INTO cat_feature (id, feature_class, feature_type, shortcut_key, parent_layer, child_layer, descript, link_path, code_autofill, active, addparam)
VALUES('SERVCONNECTION', 'SERVCONNECTION', 'LINK', NULL, 'v_edit_link', 've_link_servconnection', 'Service connection link', NULL, true, true, NULL);
INSERT INTO cat_feature (id, feature_class, feature_type, shortcut_key, parent_layer, child_layer, descript, link_path, code_autofill, active, addparam)
VALUES('INLETPIPE', 'INLETPIPE', 'LINK', NULL, 'v_edit_link', 've_link_inletpipe', 'Inlet pipe link', NULL, true, true, NULL);

INSERT INTO cat_feature_link (id) VALUES ('SERVCONNECTION');
INSERT INTO cat_feature_link (id) VALUES ('INLETPIPE');

INSERT INTO sys_param_user (id, formname, descript, sys_role, idval, "label", dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, "source")
VALUES('edit_gully_linkcat_vdefault', 'config', 'Value default catalog for link connected to gully', 'role_edit', NULL, 'Default catalog for linkcat:', 'SELECT cat_link.id, cat_link.id AS idval FROM cat_link JOIN cat_feature ON cat_feature.id = cat_link.link_type WHERE cat_feature.feature_type = ''INLETPIPE''', NULL, true, 20, 'ud', false, NULL, 'linkcat_id', NULL, false, 'text', 'combo', true, NULL, 'CC020', 'lyt_gully', true, NULL, false, NULL, NULL, NULL);

UPDATE sys_param_user
SET vdefault='CC020',"label"='Default catalog for linkcat:',dv_querytext='SELECT cat_link.id, cat_link.id AS idval FROM cat_link JOIN cat_feature ON cat_feature.id = cat_link.link_type WHERE cat_feature.feature_type = ''INLETPIPE''',descript='Value default catalog for link connected to inletpipe',feature_field_id='linkcat_id',ismandatory=true,dv_isnullvalue=false,project_type='utils',id='edit_inletpipe_linkcat_vdefault'
WHERE id='edit_inletpipe_linkcat_vdefault'; -- TODO: update id


INSERT INTO cat_link (id, link_type, matcat_id, descript, link, brand_id, model_id, svg, estimated_depth, active, label)
SELECT id, 'SERVCONNECTION' AS link_type, matcat_id, descript, link, brand_id, model_id, svg, estimated_depth, active, label
FROM cat_connec ON CONFLICT DO NOTHING;

INSERT INTO cat_link (id, link_type) VALUES ('UPDATE_LINK_40','SERVCONNECTION');

INSERT INTO link (link_id, code, feature_id, feature_type, exit_id, exit_type, userdefined_geom, state, expl_id, the_geom,
tstamp, exit_topelev, exit_elev, sector_id, omzone_id, fluid_type, expl_id2, epa_type, is_operative, insert_user, lastupdate,
lastupdate_user, linkcat_id, workcat_id, workcat_id_end, builtdate, enddate, drainzone_id, uncertain, muni_id, verified,
macrominsector_id)
SELECT nextval('SCHEMA_NAME.urn_id_seq'::regclass), link_id::text, feature_id, feature_type, exit_id, exit_type, userdefined_geom, state, expl_id, the_geom,
tstamp, exit_topelev, exit_elev, sector_id, dma_id, fluid_type, expl_id2, epa_type, is_operative, insert_user, lastupdate,
lastupdate_user,
CASE
  WHEN conneccat_id IS NULL THEN
    CASE
      WHEN feature_type = 'GULLY' THEN
        (SELECT _connec_arccat_id FROM gully WHERE gully_id = feature_id LIMIT 1)
      WHEN feature_type = 'CONNEC' THEN
        (SELECT conneccat_id FROM connec WHERE connec_id = feature_id LIMIT 1)
      ELSE
        'UPDATE_LINK_40'
    END
  ELSE conneccat_id
END AS conneccat_id, workcat_id, workcat_id_end, builtdate, enddate, drainzone_id, uncertain, muni_id, verified,
macrominsector_id
FROM _link;



INSERT INTO macroexploitation (macroexpl_id, code, "name", descript, lock_level, active, updated_at)
SELECT macroexpl_id, macroexpl_id::text, "name", descript, NULL, active, now()
FROM _macroexploitation;

INSERT INTO exploitation (expl_id, code, "name", descript, macroexpl_id, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT expl_id, expl_id::text, "name", descript, macroexpl_id, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _exploitation;

INSERT INTO macrosector (macrosector_id, code, "name", descript, lock_level, active, the_geom, updated_at)
SELECT macrosector_id, macrosector_id::text, "name", descript, NULL, active, the_geom, now()
FROM _macrosector;

INSERT INTO macroomzone (macroomzone_id, code, "name", descript, expl_id, lock_level, active, the_geom, updated_at)
SELECT macrodma_id, macrodma_id::text, "name", descript, expl_id, NULL, active, the_geom, now()
FROM _macrodma;

INSERT INTO omzone (omzone_id, code, "name", descript, omzone_type, expl_id, macroomzone_id, minc, maxc, effc, link,
graphconfig, stylesheet, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT dma_id, dma_id::text, "name", descript, dma_type, expl_id, macrodma_id, minc, maxc, effc, link,
graphconfig, stylesheet, lock_level, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _dma;

INSERT INTO drainzone (drainzone_id, code, "name", drainzone_type, descript, expl_id, link, graphconfig, stylesheet, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT drainzone_id, drainzone_id::text, "name", drainzone_type, descript, expl_id, link, graphconfig, stylesheet, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _drainzone;

INSERT INTO sector (sector_id, code, "name", descript, macrosector_id, parent_id, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT sector_id, sector_id::text, "name", descript, macrosector_id, parent_id, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _sector;









