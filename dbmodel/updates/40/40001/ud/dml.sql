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
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('FRPUMP', 'FLWREG', 'ELEMENT', 'v_edit_element', 've_elem_frpump', true) ON CONFLICT (id) DO NOTHING;

INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer)
SELECT upper(REPLACE(id, ' ', '_')), 'GENELEMENT', 'ELEMENT', 'v_edit_element', concat('ve_elem_', lower(REPLACE(id, ' ', '_'))) FROM element_type ON CONFLICT (id) DO NOTHING;

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
VALUES('edit_gully_linkcat_vdefault', 'config', 'Value default catalog for link connected to gully', 'role_edit', NULL, 'Default catalog for linkcat:', 'SELECT DISTINCT ON (cl.id) cl.id, cl.id AS idval FROM link l JOIN cat_link cl ON l.linkcat_id = cl.id WHERE l.link_type = ''INLETPIPE''', NULL, true, 20, 'ud', false, NULL, 'linkcat_id', NULL, false, 'text', 'combo', true, NULL, 'CC020', 'lyt_gully', true, true, false, NULL, NULL, NULL);

UPDATE sys_param_user
SET vdefault='CC020',"label"='Default catalog for linkcat:',dv_querytext='SELECT cat_link.id, cat_link.id AS idval FROM cat_link JOIN cat_feature ON cat_feature.id = cat_link.link_type WHERE cat_feature.feature_type = ''INLETPIPE''',descript='Value default catalog for link connected to inletpipe',feature_field_id='linkcat_id',ismandatory=true,dv_isnullvalue=false,project_type='utils',id='edit_inletpipe_linkcat_vdefault'
WHERE id='edit_inletpipe_linkcat_vdefault'; -- TODO: update id


INSERT INTO cat_link (id, matcat_id, descript, link, brand_id, model_id, svg, estimated_depth, active, label)
SELECT id, matcat_id, descript, link, brand_id, model_id, svg, estimated_depth, active, label
FROM cat_connec ON CONFLICT DO NOTHING;

ALTER TABLE link ADD CONSTRAINT link_link_type_fkey FOREIGN KEY (link_type) REFERENCES cat_feature_link(id) ON DELETE RESTRICT ON UPDATE CASCADE;

INSERT INTO cat_link (id) VALUES ('UPDATE_LINK_40');

INSERT INTO link (link_id, code, feature_id, feature_type, exit_id, exit_type, userdefined_geom, state, expl_id, the_geom,
created_at, sector_id, omzone_id, fluid_type, expl_id2, epa_type, is_operative, created_by, updated_at,
updated_by, linkcat_id, workcat_id, workcat_id_end, builtdate, enddate, drainzone_id, uncertain, muni_id, verified,
macrominsector_id, top_elev1, top_elev2, y2, link_type)
SELECT nextval('SCHEMA_NAME.urn_id_seq'::regclass), link_id::text, feature_id, feature_type, exit_id, exit_type, userdefined_geom, state, expl_id, the_geom,
tstamp, sector_id, dma_id, fluid_type, expl_id2, epa_type, is_operative, insert_user, lastupdate, lastupdate_user,
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
macrominsector_id,
CASE
  WHEN feature_type = 'GULLY' THEN
    (SELECT g.top_elev FROM gully g WHERE g.gully_id=feature_id LIMIT 1)
  WHEN feature_type = 'CONNEC' THEN
    (SELECT c.top_elev FROM connec c WHERE c.connec_id = feature_id LIMIT 1)
  ELSE NULL
END AS top_elev1, exit_topelev,
CASE
  WHEN exit_topelev IS NOT NULL AND exit_elev IS NOT NULL THEN
    exit_topelev - exit_elev
  ELSE NULL
END AS y2,
CASE
  WHEN feature_type = 'GULLY' THEN
    'INLETPIPE'
  WHEN feature_type = 'CONNEC' THEN
    'SERVCONNECTION'
  ELSE NULL
END AS link_type
FROM _link;


DO $func$
DECLARE
  gullyr record;
  connecr record;
BEGIN
  FOR gullyr IN (SELECT gully_id, _connec_arccat_id FROM gully WHERE _connec_arccat_id IS NOT NULL)
  LOOP
    IF NOT EXISTS(SELECT 1 FROM link WHERE feature_id = gullyr.gully_id) THEN
      EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831}, "form": {}, "feature": {"id": "[' || gullyr.gully_id || ']"},
     "data": {"filterFields": {}, "pageInfo": {}, "feature_type": "GULLY", "linkcatId":"UPDATE_LINK_40"}}$$);';
      UPDATE link SET uncertain=true WHERE feature_id = gullyr.gully_id;
    END IF;
  END LOOP;

  FOR connecr IN (SELECT connec_id, conneccat_id  FROM connec)
  LOOP
    IF NOT EXISTS(SELECT 1 FROM link WHERE feature_id = connecr.connec_id) THEN
      EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": 25831}, "form": {}, "feature": {"id": "[' || connecr.connec_id || ']"},
     "data": {"filterFields": {}, "pageInfo": {}, "feature_type": "CONNEC", "linkcatId":"UPDATE_LINK_40"}}$$);';
      UPDATE link SET uncertain=true WHERE feature_id = connecr.connec_id;
    END IF;
  END LOOP;
END $func$;

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

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'dqa_id', 'lyt_data_1', 11, 'integer', 'text', 'dqa_id', 'dqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'dqa_name', 'lyt_data_1', 20, 'string', 'text', 'dqa_name', 'dqa_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'fluid_type', 'lyt_data_1', 15, 'string', 'text', 'fluid_type', 'fluid_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'macrodqa_id', 'lyt_data_1', 24, 'integer', 'text', 'macrodqa_id', 'macrodqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'minsector_id', 'lyt_data_1', 12, 'integer', 'text', 'minsector_id', 'minsector_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'epa_type', 'lyt_data_1', 26, 'string', 'text', 'epa_type', '', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'is_operative', 'lyt_data_1', 27, 'boolean', 'check', 'is_operative', '', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 32, 'date', 'datetime', 'Builtdate:', 'builtdate - Date the element was added. In insertion of new elements the date of the day is shown', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'exit_id', 'lyt_data_1', 5, 'string', 'text', 'Exit ID', 'Exit ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'exit_type', 'lyt_data_1', 4, 'string', 'combo', 'Exit type', 'Exit type', NULL, false, false, false, false, NULL, 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'expl_id', 'lyt_data_1', 7, 'integer', 'combo', 'Explotation ID', 'Explotation ID', NULL, false, false, false, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'feature_id', 'lyt_data_1', 3, 'string', 'text', 'Feature ID', 'Feature ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'feature_type', 'lyt_data_1', 2, 'string', 'combo', 'Feature type', 'Feature type', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'link_id', 'lyt_data_1', 1, 'integer', 'text', 'Link ID', 'Link ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'presszone_id', 'lyt_data_1', 10, 'integer', 'text', 'presszone_id', 'presszone_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'sector_id', 'lyt_data_1', 8, 'integer', 'combo', 'Sector ID', 'sector_id  - Sector identifier.', NULL, false, false, false, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'state', 'lyt_data_1', 6, 'integer', 'combo', 'State:', 'State:', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'uncertain', 'lyt_data_1', 34, 'boolean', 'check', 'Uncertain', 'Uncertain', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'conneccat_id', 'lyt_data_1', 29, 'string', 'typeahead', 'Connecat ID', 'connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ', true, NULL, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, 'action_catalog', false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 33, 'date', 'datetime', 'Enddate', 'enddate - End date of the element. It will only be filled in if the element is in a deregistration state.', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'gis_length', 'lyt_data_1', 16, 'double', 'text', 'Gis length', 'Gis length', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'macrosector_id', 'lyt_data_1', 22, 'integer', 'combo', 'Macrosector id', 'Macrosector id', NULL, false, false, false, false, NULL, 'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_none', 'n_hydrometer', 'lyt_data_1', 35, 'integer', 'text', 'N_hydrometer', 'N_hydrometer', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'presszone_name', 'lyt_data_1', 21, 'string', 'text', 'presszone_name', 'presszone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'sector_name', 'lyt_data_1', 18, 'string', 'text', 'sector_name', 'sector_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 30, 'string', 'typeahead', 'Workcat ID', 'workcat_id - Related to the catalog of work files (cat_work). File that registers the element', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 31, 'string', 'typeahead', 'Workcat ID end', 'workcat_id_end - ID of the  end of construction work.', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'top_elev1', 'lyt_data_1', 36, 'integer', 'text', 'Top Elev 1', 'top_elev1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'y1', 'lyt_data_1', 37, 'integer', 'text', 'Y1', 'y1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'elevation1', 'lyt_data_1', 38, 'integer', 'text', 'Elevation1', 'elevation1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'top_elev2', 'lyt_data_1', 39, 'integer', 'text', 'Top elev 2', 'top_elev2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'y2', 'lyt_data_1', 40, 'integer', 'text', 'Y2', 'y2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'elevation2', 'lyt_data_1', 41, 'integer', 'text', 'Elevation2', 'elevation2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'omzone_id', 'lyt_data_1', 9, 'integer', 'combo', 'Omzone ID', 'Omzone ID', NULL, false, false, false, false, NULL, 'SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id = 0 UNION SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'omzone_name', 'lyt_data_1', 19, 'string', 'text', 'omzone_name', 'omzone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_inletpipe', 'form_feature', 'tab_data', 'macroomzone_id', 'lyt_data_1', 23, 'integer', 'text', 'Macroomzone ID', 'Macroomzone ID', NULL, false, false, false, false, NULL, 'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);





INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'top_elev1', 'lyt_data_1', 36, 'integer', 'text', 'Top Elev 1', 'top_elev1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'y1', 'lyt_data_1', 37, 'integer', 'text', 'Y1', 'y1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'elevation1', 'lyt_data_1', 38, 'integer', 'text', 'Elevation1', 'elevation1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'top_elev2', 'lyt_data_1', 39, 'integer', 'text', 'Top elev 2', 'top_elev2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'y2', 'lyt_data_1', 40, 'integer', 'text', 'Y2', 'y2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'elevation2', 'lyt_data_1', 41, 'integer', 'text', 'Elevation2', 'elevation2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'omzone_id', 'lyt_data_1', 9, 'integer', 'combo', 'Omzone ID', 'Omzone ID', NULL, false, false, false, false, NULL, 'SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id = 0 UNION SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'omzone_name', 'lyt_data_1', 19, 'string', 'text', 'omzone_name', 'omzone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'macroomzone_id', 'lyt_data_1', 23, 'integer', 'text', 'Macroomzone ID', 'Macroomzone ID', NULL, false, false, false, false, NULL, 'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'top_elev1', 'lyt_data_1', 36, 'integer', 'text', 'Top Elev 1', 'top_elev1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'y1', 'lyt_data_1', 37, 'integer', 'text', 'Y1', 'y1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'elevation1', 'lyt_data_1', 38, 'integer', 'text', 'Elevation1', 'elevation1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'top_elev2', 'lyt_data_1', 39, 'integer', 'text', 'Top elev 2', 'top_elev2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'y2', 'lyt_data_1', 40, 'integer', 'text', 'Y2', 'y2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'elevation2', 'lyt_data_1', 41, 'integer', 'text', 'Elevation2', 'elevation2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'omzone_id', 'lyt_data_1', 9, 'integer', 'combo', 'Omzone ID', 'Omzone ID', NULL, false, false, false, false, NULL, 'SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id = 0 UNION SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'omzone_name', 'lyt_data_1', 19, 'string', 'text', 'omzone_name', 'omzone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'macroomzone_id', 'lyt_data_1', 23, 'integer', 'text', 'Macroomzone ID', 'Macroomzone ID', NULL, false, false, false, false, NULL, 'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

DO $func$
DECLARE
  linkr record;
BEGIN
  FOR linkr IN (SELECT link_id, link_type FROM v_edit_link)
  LOOP
    IF linkr.link_type = 'SERVCONNECTION' THEN
      INSERT INTO man_servconnection VALUES (linkr.link_id);
    END IF;
    IF linkr.link_type = 'INLETPIPE' THEN
      INSERT INTO man_inletpipe VALUES (linkr.link_id);
    END IF;
  END LOOP;
END $func$;


--- WEIR: insert man table
INSERT INTO ve_elem_frweir (elementcat_id, state, state_type, num_elements, expl_id, sector_id, muni_id, the_geom, flwreg_class, node_id, order_id, to_arc, flwreg_length )
SELECT 'FRWEIR-01', state, state_type, 1, expl_id, sector_id, muni_id, the_geom, 'WEIR', node_id, order_id, to_arc, flwreg_length
FROM _inp_flwreg_weir
JOIN node USING (node_id);

--- WEIR: insert epa table
INSERT INTO inp_flwreg_weir
SELECT element_id, weir_type, offsetval, cd, ec, cd2, flap, geom1, geom2, geom3, geom4, surcharge, road_width, road_surf, coef_curve
FROM _inp_flwreg_weir w JOIN ve_elem_frweir r ON w.node_id=r.node_id AND w.to_arc = r.to_arc AND w.order_id = r.order_id;

--- PUMP: insert man table
INSERT INTO ve_elem_frpump (elementcat_id, state, state_type, num_elements, expl_id, sector_id, muni_id, the_geom, flwreg_class, node_id, order_id, to_arc, flwreg_length )
SELECT 'FRPUMP-01', state, state_type, 1, expl_id, sector_id, muni_id, the_geom, 'PUMP', node_id, order_id, to_arc, flwreg_length
FROM _inp_flwreg_pump
JOIN node USING (node_id);

--- PUMP: insert epa table
INSERT INTO inp_flwreg_pump (element_id, curve_id, status, startup, shutoff)
SELECT element_id, curve_id, status, startup, shutoff
FROM _inp_flwreg_pump w JOIN ve_elem_frpump r ON w.node_id=r.node_id AND w.to_arc = r.to_arc AND w.order_id = r.order_id;

--- ORIFICE: insert man table
INSERT INTO ve_elem_frorifice (elementcat_id, state, state_type, num_elements, expl_id, sector_id, muni_id, the_geom, flwreg_class, node_id, order_id, to_arc, flwreg_length )
SELECT 'FRORIFICE-01', state, state_type, 1, expl_id, sector_id, muni_id, the_geom, 'ORIFICE', node_id, order_id, to_arc, flwreg_length
FROM _inp_flwreg_orifice
JOIN node USING (node_id);

--- ORIFICE: insert epa table
INSERT INTO inp_flwreg_orifice
SELECT element_id, ori_type, offsetval, cd, orate, flap, shape, geom1, geom2, geom3, geom4
FROM _inp_flwreg_orifice w JOIN ve_elem_frorifice r ON w.node_id=r.node_id AND w.to_arc = r.to_arc AND w.order_id = r.order_id;

--- OUTLET: insert man table
INSERT INTO ve_elem_froutlet (elementcat_id, state, state_type, num_elements, expl_id, sector_id, muni_id, the_geom, flwreg_class, node_id, order_id, to_arc, flwreg_length )
SELECT 'FROUTLET-01', state, state_type, 1, expl_id, sector_id, muni_id, the_geom, 'OUTLET', node_id, order_id, to_arc, flwreg_length
FROM _inp_flwreg_outlet
JOIN node USING (node_id);

--- OUTLET: insert epa table
INSERT INTO inp_flwreg_outlet
SELECT element_id, outlet_type, offsetval, curve_id, cd1, cd2, flap
FROM _inp_flwreg_outlet w JOIN ve_elem_froutlet r ON w.node_id=r.node_id AND w.to_arc = r.to_arc AND w.order_id = r.order_id;

INSERT INTO element_x_node
SELECT element_id, node_id FROM man_flwreg;

UPDATE config_form_fields SET isparent = false WHERE formname = 'v_edit_inp_netgully' AND columnname = 'node_type';
UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM inp_hydrograph WHERE id IS NOT NULL ' WHERE formname = 'inp_rdii' AND columnname = 'hydro_id';
UPDATE config_form_fields SET dv_querytext = 'SELECT snow_id as id, snow_id as idval FROM inp_snowpack WHERE snow_id IS NOT NULL ' WHERE formname = 'inp_snowpack' AND columnname = 'snow_id';
UPDATE config_form_fields SET dv_querytext = 'SELECT DISTINCT (lidco_id) AS id,  lidco_id  AS idval FROM inp_lid WHERE lidco_id IS NOT NULL ' WHERE formname = 'v_edit_inp_lid_usage' AND columnname = 'lidco_id';

UPDATE cat_feature SET child_layer='ve_node_overflow_storage' WHERE id='OVERFLOW_STORAGE';

-- CAT_FEATURE
UPDATE cat_feature
	SET parent_layer='v_edit_flwreg'
	WHERE id='FRORIFICE';
UPDATE cat_feature
	SET parent_layer='v_edit_flwreg'
	WHERE id='FRPUMP';
UPDATE cat_feature
	SET parent_layer='v_edit_flwreg'
	WHERE id='FROUTLET';
UPDATE cat_feature
	SET parent_layer='v_edit_flwreg'
	WHERE id='FRWEIR';

-- CONFIG_FORM_FIELDS

-- ve_elem_frweir
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_elem_frweir', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''FRWEIR''', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'observ', 'lyt_data_1', 7, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'fluid_type', 'lyt_data_1', 12, 'string', 'combo', 'Fluid Type', 'Fluid Type', NULL, false, false, true, false, NULL, 'SELECT id, fluid_type as idval FROM man_type_fluid WHERE feature_type = ''ELEMENT''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 2, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 3, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'nodarc_id', 'lyt_data_2', 0, 'string', 'text', 'nodarc_id', 'nodarc_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'to_arc', 'lyt_data_2', 1, 'string', 'text', 'to_arc', 'to_arc', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'flwreg_length', 'lyt_data_2', 2, 'double', 'text', 'flwreg_length', 'flwreg_length', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'order_id', 'lyt_data_2', 3, 'double', 'text', 'order_id', 'order_id', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'flwreg_class', 'lyt_data_2', 4, 'string', 'text', 'flwreg_class', 'flwreg_class', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frweir', 'form_feature', 'tab_data', 'flwreg_type', 'lyt_data_2', 5, 'string', 'text', 'flwreg_type', 'flwreg_type', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL)
ON CONFLICT (formname, formtype, tabname, columnname) DO UPDATE SET
  layoutname = EXCLUDED.layoutname,
  layoutorder = EXCLUDED.layoutorder,
  datatype = EXCLUDED.datatype,
  widgettype = EXCLUDED.widgettype,
  label = EXCLUDED.label,
  tooltip = EXCLUDED.tooltip,
  placeholder = EXCLUDED.placeholder,
  ismandatory = EXCLUDED.ismandatory,
  isparent = EXCLUDED.isparent,
  iseditable = EXCLUDED.iseditable,
  isautoupdate = EXCLUDED.isautoupdate,
  isfilter = EXCLUDED.isfilter,
  dv_querytext = EXCLUDED.dv_querytext,
  dv_orderby_id = EXCLUDED.dv_orderby_id,
  dv_isnullvalue = EXCLUDED.dv_isnullvalue,
  dv_parent_id = EXCLUDED.dv_parent_id,
  stylesheet = EXCLUDED.stylesheet,
  widgetcontrols = EXCLUDED.widgetcontrols,
  widgetfunction = EXCLUDED.widgetfunction,
  linkedobject = EXCLUDED.linkedobject,
  hidden = EXCLUDED.hidden,
  web_layoutorder = EXCLUDED.web_layoutorder;

-- ve_elem_frorifice
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_elem_frorifice', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''FRORIFICE''', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'observ', 'lyt_data_1', 7, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'fluid_type', 'lyt_data_1', 12, 'string', 'combo', 'Fluid Type', 'Fluid Type', NULL, false, false, true, false, NULL, 'SELECT id, fluid_type as idval FROM man_type_fluid WHERE feature_type = ''ELEMENT''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 2, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 3, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'nodarc_id', 'lyt_data_2', 0, 'string', 'text', 'nodarc_id', 'nodarc_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'to_arc', 'lyt_data_2', 1, 'string', 'text', 'to_arc', 'to_arc', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'flwreg_length', 'lyt_data_2', 2, 'double', 'text', 'flwreg_length', 'flwreg_length', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'order_id', 'lyt_data_2', 3, 'double', 'text', 'order_id', 'order_id', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'flwreg_class', 'lyt_data_2', 4, 'string', 'text', 'flwreg_class', 'flwreg_class', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frorifice', 'form_feature', 'tab_data', 'flwreg_type', 'lyt_data_2', 5, 'string', 'text', 'flwreg_type', 'flwreg_type', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL)
ON CONFLICT (formname, formtype, tabname, columnname) DO UPDATE SET
  layoutname = EXCLUDED.layoutname,
  layoutorder = EXCLUDED.layoutorder,
  datatype = EXCLUDED.datatype,
  widgettype = EXCLUDED.widgettype,
  label = EXCLUDED.label,
  tooltip = EXCLUDED.tooltip,
  placeholder = EXCLUDED.placeholder,
  ismandatory = EXCLUDED.ismandatory,
  isparent = EXCLUDED.isparent,
  iseditable = EXCLUDED.iseditable,
  isautoupdate = EXCLUDED.isautoupdate,
  isfilter = EXCLUDED.isfilter,
  dv_querytext = EXCLUDED.dv_querytext,
  dv_orderby_id = EXCLUDED.dv_orderby_id,
  dv_isnullvalue = EXCLUDED.dv_isnullvalue,
  dv_parent_id = EXCLUDED.dv_parent_id,
  stylesheet = EXCLUDED.stylesheet,
  widgetcontrols = EXCLUDED.widgetcontrols,
  widgetfunction = EXCLUDED.widgetfunction,
  linkedobject = EXCLUDED.linkedobject,
  hidden = EXCLUDED.hidden,
  web_layoutorder = EXCLUDED.web_layoutorder;

-- ve_elem_froutlet
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_elem_froutlet', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''FROUTLET''', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'observ', 'lyt_data_1', 7, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'fluid_type', 'lyt_data_1', 12, 'string', 'combo', 'Fluid Type', 'Fluid Type', NULL, false, false, true, false, NULL, 'SELECT id, fluid_type as idval FROM man_type_fluid WHERE feature_type = ''ELEMENT''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 2, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 3, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'nodarc_id', 'lyt_data_2', 0, 'string', 'text', 'nodarc_id', 'nodarc_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'to_arc', 'lyt_data_2', 1, 'string', 'text', 'to_arc', 'to_arc', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'flwreg_length', 'lyt_data_2', 2, 'double', 'text', 'flwreg_length', 'flwreg_length', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'order_id', 'lyt_data_2', 3, 'double', 'text', 'order_id', 'order_id', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'flwreg_class', 'lyt_data_2', 4, 'string', 'text', 'flwreg_class', 'flwreg_class', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_froutlet', 'form_feature', 'tab_data', 'flwreg_type', 'lyt_data_2', 5, 'string', 'text', 'flwreg_type', 'flwreg_type', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL)
ON CONFLICT (formname, formtype, tabname, columnname) DO UPDATE SET
  layoutname = EXCLUDED.layoutname,
  layoutorder = EXCLUDED.layoutorder,
  datatype = EXCLUDED.datatype,
  widgettype = EXCLUDED.widgettype,
  label = EXCLUDED.label,
  tooltip = EXCLUDED.tooltip,
  placeholder = EXCLUDED.placeholder,
  ismandatory = EXCLUDED.ismandatory,
  isparent = EXCLUDED.isparent,
  iseditable = EXCLUDED.iseditable,
  isautoupdate = EXCLUDED.isautoupdate,
  isfilter = EXCLUDED.isfilter,
  dv_querytext = EXCLUDED.dv_querytext,
  dv_orderby_id = EXCLUDED.dv_orderby_id,
  dv_isnullvalue = EXCLUDED.dv_isnullvalue,
  dv_parent_id = EXCLUDED.dv_parent_id,
  stylesheet = EXCLUDED.stylesheet,
  widgetcontrols = EXCLUDED.widgetcontrols,
  widgetfunction = EXCLUDED.widgetfunction,
  linkedobject = EXCLUDED.linkedobject,
  hidden = EXCLUDED.hidden,
  web_layoutorder = EXCLUDED.web_layoutorder;

-- ve_elem_frpump
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_elem_frpump', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''FRPUMP''', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'observ', 'lyt_data_1', 7, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'fluid_type', 'lyt_data_1', 12, 'string', 'combo', 'Fluid Type', 'Fluid Type', NULL, false, false, true, false, NULL, 'SELECT id, fluid_type as idval FROM man_type_fluid WHERE feature_type = ''ELEMENT''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 2, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 3, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'nodarc_id', 'lyt_data_2', 0, 'string', 'text', 'nodarc_id', 'nodarc_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'to_arc', 'lyt_data_2', 1, 'string', 'text', 'to_arc', 'to_arc', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'pump_type', 'lyt_data_2', 2, 'string', 'text', 'pump_type', 'pump_type', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'power', 'lyt_data_2', 3, 'double', 'text', 'power', 'power', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'curve_id', 'lyt_data_2', 4, 'string', 'text', 'curve_id', 'curve_id', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'speed', 'lyt_data_2', 5, 'double', 'text', 'speed', 'speed', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'pattern', 'lyt_data_2', 6, 'string', 'text', 'pattern', 'pattern', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'status', 'lyt_data_2', 7, 'string', 'text', 'status', 'status', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_elem_frpump', 'form_feature', 'tab_data', 'flwreg_length', 'lyt_data_2', 8, 'double', 'text', 'flwreg_length', 'flwreg_length', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL)
ON CONFLICT (formname, formtype, tabname, columnname) DO UPDATE SET
  layoutname = EXCLUDED.layoutname,
  layoutorder = EXCLUDED.layoutorder,
  datatype = EXCLUDED.datatype,
  widgettype = EXCLUDED.widgettype,
  label = EXCLUDED.label,
  tooltip = EXCLUDED.tooltip,
  placeholder = EXCLUDED.placeholder,
  ismandatory = EXCLUDED.ismandatory,
  isparent = EXCLUDED.isparent,
  iseditable = EXCLUDED.iseditable,
  isautoupdate = EXCLUDED.isautoupdate,
  isfilter = EXCLUDED.isfilter,
  dv_querytext = EXCLUDED.dv_querytext,
  dv_orderby_id = EXCLUDED.dv_orderby_id,
  dv_isnullvalue = EXCLUDED.dv_isnullvalue,
  dv_parent_id = EXCLUDED.dv_parent_id,
  stylesheet = EXCLUDED.stylesheet,
  widgetcontrols = EXCLUDED.widgetcontrols,
  widgetfunction = EXCLUDED.widgetfunction,
  linkedobject = EXCLUDED.linkedobject,
  hidden = EXCLUDED.hidden,
  web_layoutorder = EXCLUDED.web_layoutorder;

-- tab documents
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'date_from', 'lyt_document_1', 1, 'date', 'datetime', 'Date from:', 'Date from:', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":">="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_element', false, 1);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'date_to', 'lyt_document_1', 2, 'date', 'datetime', 'Date to:', 'Date to:', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":"<="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_element', false, 2);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'doc_type', 'lyt_document_1', 3, 'string', 'combo', 'Doc type:', 'Doc type:', NULL, false, false, true, false, true, 'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_element', false, 3);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'doc_name', 'lyt_document_2', 0, 'string', 'typeahead', 'Doc id:', 'Doc id:', NULL, false, false, true, false, false, 'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table"}'::json, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'btn_doc_insert', 'lyt_document_2', 2, NULL, 'button', '', 'Insert document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_element', false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'btn_doc_delete', 'lyt_document_2', 3, NULL, 'button', '', 'Delete document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json, '{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json, 'tbl_doc_x_element', false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'btn_doc_new', 'lyt_document_2', 4, NULL, 'button', '', 'New document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_element', false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'hspacer_document_1', 'lyt_document_2', 10, NULL, 'hspacer', '', '', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'open_doc', 'lyt_document_2', 11, NULL, 'button', '', 'Open document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"147"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_element', false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'tbl_documents', 'lyt_document_3', 1, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json, 'tbl_doc_x_element', false, 4);


-- CONFIG_FORM_TABS
DELETE FROM config_form_tabs WHERE formname = 'v_edit_flwreg' AND tabname = 'tab_none';
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('v_edit_flwreg', 'tab_data', 'Data', 'Data', 'role_basic', NULL, '[
  {"actionName": "actionEdit", "disabled": false}
]'::json, 0, '{4}');

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('v_edit_flwreg', 'tab_epa', 'EPA', 'Epa', 'role_basic', NULL, '[
  {"actionName": "actionEdit", "disabled": false}
]'::json, 1, '{4}');

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('v_edit_flwreg', 'tab_documents', 'Documents', 'List of documents', 'role_basic', NULL, '[
  {"actionName": "actionEdit", "disabled": false}
]'::json, 2, '{4}');
