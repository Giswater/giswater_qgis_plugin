/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- Insert into sys_feature_epa_type
INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('FRWEIR', 'ELEMENT', 'inp_frweir', NULL, true);
INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('FRORIFICE', 'ELEMENT', 'inp_frorifice', NULL, true);
INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('FROUTLET', 'ELEMENT', 'inp_froutlet', NULL, true);
INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('UNDEFINED', 'ELEMENT', NULL, NULL, true);

-- Adding flowregulator objects on cat_feature [Modified from first version]
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('EPUMP', 'FRELEM', 'ELEMENT', 've_frelem', 've_frelem_epump', true) ON CONFLICT (id) DO NOTHING;

INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer)
SELECT concat('E', upper(REPLACE(id, ' ', '_'))), 'GENELEM', 'ELEMENT', 've_genelem', concat('ve_genelem_', concat('e', lower(REPLACE(id, ' ', '_')))) FROM _element_type ON CONFLICT (id) DO NOTHING;

INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('EORIFICE', 'FRELEM', 'ELEMENT', 've_frelem', 've_frelem_eorifice', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('EOUTLET', 'FRELEM', 'ELEMENT', 've_frelem', 've_frelem_eoutlet', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('EWEIR', 'FRELEM', 'ELEMENT', 've_frelem', 've_frelem_eweir', true) ON CONFLICT (id) DO NOTHING;
-- Adding objects on config_info_layer and config_info_layer_x_type (this both tables controls the button info)

INSERT INTO cat_feature (id, feature_class, feature_type, shortcut_key, parent_layer, child_layer, descript, link_path, code_autofill, active, addparam)
VALUES('LINK', 'LINK', 'LINK', NULL, 'v_edit_link', 've_link_link', 'Link', NULL, true, true, NULL);

INSERT INTO cat_feature_link (id) VALUES ('LINK') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user (id, formname, descript, sys_role, idval, "label", dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, "source")
VALUES('edit_gully_linkcat_vdefault', 'config', 'Value default catalog for link connected to gully', 'role_edit', NULL, 'Default catalog for linkcat:', 'SELECT DISTINCT ON (cl.id) cl.id, cl.id AS idval FROM link l JOIN cat_link cl ON l.linkcat_id = cl.id WHERE l.link_type = ''LINK''', NULL, true, 20, 'ud', false, NULL, 'linkcat_id', NULL, false, 'text', 'combo', true, NULL, 'CC020', 'lyt_gully', true, true, false, NULL, NULL, NULL);

UPDATE sys_param_user
SET vdefault='CC040_I',"label"='Default catalog for linkcat:', dv_querytext='SELECT cat_link.id, cat_link.id AS idval FROM cat_link JOIN cat_feature ON cat_feature.id = cat_link.link_type WHERE cat_link.link_type = ''CONDUITLINK''', descript='Value default catalog for link', feature_field_id='linkcat_id', ismandatory=true, dv_isnullvalue=false, project_type='ud'
WHERE id='edit_gully_linkcat_vdefault';


INSERT INTO cat_link (id, link_type, matcat_id, descript, link, brand_id, model_id, svg, estimated_depth, active, label)
SELECT id, 'LINK' as link_type, matcat_id, descript, link, brand_id, model_id, svg, estimated_depth, active, label
FROM cat_connec ON CONFLICT DO NOTHING;

ALTER TABLE link ADD CONSTRAINT link_link_type_fkey FOREIGN KEY (link_type) REFERENCES cat_feature_link(id) ON DELETE RESTRICT ON UPDATE CASCADE;

INSERT INTO cat_link (id, link_type) VALUES ('UPDATE_LINK_40', 'LINK');

INSERT INTO link (link_id, code, feature_id, feature_type, exit_id, exit_type, userdefined_geom, state, state_type, expl_id, the_geom,
created_at, sector_id, omzone_id, _fluid_type, expl_visibility, epa_type, is_operative, created_by, updated_at,
updated_by, linkcat_id, workcat_id, workcat_id_end, builtdate, enddate, drainzone_id, uncertain, muni_id, verified,
top_elev1, top_elev2, y2, link_type)
SELECT nextval('SCHEMA_NAME.urn_id_seq'::regclass), link_id::text, feature_id::integer, feature_type, exit_id::integer, exit_type, userdefined_geom, state, 2, expl_id, the_geom,
tstamp, sector_id, dma_id, fluid_type, ARRAY[expl_id2], epa_type, is_operative, insert_user, lastupdate, lastupdate_user,
CASE
  WHEN conneccat_id IS NULL THEN
    CASE
      WHEN feature_type = 'GULLY' THEN
        (SELECT _connec_arccat_id FROM gully WHERE gully_id = feature_id::int4 LIMIT 1)
      WHEN feature_type = 'CONNEC' THEN
        (SELECT conneccat_id FROM connec WHERE connec_id = feature_id::int4 LIMIT 1)
      ELSE
        'UPDATE_LINK_40'
    END
  ELSE conneccat_id
END AS conneccat_id, workcat_id, workcat_id_end, builtdate, enddate, drainzone_id, uncertain, muni_id, verified,
CASE
  WHEN feature_type = 'GULLY' THEN
    (SELECT g.top_elev FROM gully g WHERE g.gully_id = feature_id::int4 LIMIT 1)
  WHEN feature_type = 'CONNEC' THEN
    (SELECT c.top_elev FROM connec c WHERE c.connec_id = feature_id::int4 LIMIT 1)
  ELSE NULL
END AS top_elev1, exit_topelev,
CASE
  WHEN exit_topelev IS NOT NULL AND exit_elev IS NOT NULL THEN
    exit_topelev - exit_elev
  ELSE NULL
END AS y2,
'LINK' AS link_type
FROM _link;

UPDATE link l
SET state_type = c.state_type
FROM connec c
WHERE l.feature_id = c.connec_id AND l.feature_type = 'CONNEC' AND l.state = 1;

UPDATE link l
SET state_type = g.state_type
FROM gully g
WHERE l.feature_id = g.gully_id AND l.feature_type = 'GULLY' AND l.state = 1;

UPDATE link SET state_type = (
  SELECT (value::json->>'plan_statetype_planned')::int2 FROM config_param_system WHERE parameter = 'plan_statetype_vdefault'
)
WHERE state = 2;


-- DO $func$
-- DECLARE
--   gullyr record;
--   connecr record;
-- BEGIN
--   FOR gullyr IN (SELECT g.gully_id, g._connec_arccat_id FROM gully g LEFT JOIN link l ON l.feature_id = g.gully_id WHERE l.feature_id IS NULL)
--   LOOP
--     EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": SRID_VALUE}, "form": {}, "feature": {"id": "[' || gullyr.gully_id || ']"},
--     "data": {"filterFields": {}, "pageInfo": {}, "feature_type": "GULLY", "linkcatId":"UPDATE_LINK_40"}}$$);';
--     UPDATE link SET uncertain=true WHERE feature_id = gullyr.gully_id;
--   END LOOP;

--   FOR connecr IN (SELECT c.connec_id, c.conneccat_id FROM connec c LEFT JOIN link l ON l.feature_id = c.connec_id WHERE l.feature_id IS NULL)
--   LOOP
--     EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": SRID_VALUE}, "form": {}, "feature": {"id": "[' || connecr.connec_id || ']"},
--     "data": {"filterFields": {}, "pageInfo": {}, "feature_type": "CONNEC", "linkcatId":"UPDATE_LINK_40"}}$$);';
--     UPDATE link SET uncertain=true WHERE feature_id = connecr.connec_id;
--   END LOOP;
-- END $func$;



INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'top_elev1', 'lyt_data_1', 36, 'integer', 'text', 'Top Elev 1', 'top_elev1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'y1', 'lyt_data_1', 37, 'integer', 'text', 'Y1', 'y1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'elevation1', 'lyt_data_1', 38, 'integer', 'text', 'Elevation1', 'elevation1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'top_elev2', 'lyt_data_1', 39, 'integer', 'text', 'Top elev 2', 'top_elev2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'y2', 'lyt_data_1', 40, 'integer', 'text', 'Y2', 'y2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'elevation2', 'lyt_data_1', 41, 'integer', 'text', 'Elevation2', 'elevation2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'omzone_id', 'lyt_data_1', 9, 'integer', 'combo', 'Omzone ID', 'Omzone ID', NULL, false, false, false, false, NULL, 'SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id = 0 UNION SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'omzone_name', 'lyt_data_1', 19, 'string', 'text', 'omzone_name', 'omzone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'macroomzone_id', 'lyt_data_1', 23, 'integer', 'text', 'Macroomzone ID', 'Macroomzone ID', NULL, false, false, false, false, NULL, 'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

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


INSERT INTO man_conduitlink SELECT link_id FROM link;

--- WEIR: insert man table
INSERT INTO ve_frelem_eweir (elementcat_id, state, state_type, num_elements, expl_id, sector_id, muni_id, the_geom, epa_type, node_id, order_id, to_arc, flwreg_length )
SELECT 'EWEIR-01', state, state_type, 1, expl_id, sector_id, muni_id, the_geom, 'WEIR', n.node_id, order_id, to_arc::int4, flwreg_length
FROM _inp_frweir
JOIN node n ON n.node_id = _inp_frweir.node_id::int4;

--- WEIR: insert epa table
INSERT INTO inp_frweir
SELECT element_id, weir_type, offsetval, cd, ec, cd2, flap, geom1, geom2, geom3, geom4, surcharge, road_width, road_surf, coef_curve
FROM _inp_frweir w JOIN ve_frelem_eweir r ON w.node_id::int4=r.node_id AND w.to_arc::int4 = r.to_arc::int4 AND w.order_id = r.order_id;

--- PUMP: insert man table
INSERT INTO ve_frelem_epump (elementcat_id, state, state_type, num_elements, expl_id, sector_id, muni_id, the_geom, epa_type, node_id, order_id, to_arc, flwreg_length )
SELECT 'EPUMP-01', state, state_type, 1, expl_id, sector_id, muni_id, the_geom, 'PUMP', n.node_id, order_id, to_arc::int4, flwreg_length
FROM _inp_frpump
JOIN node n ON n.node_id = _inp_frpump.node_id::int4;

--- PUMP: insert epa table
INSERT INTO inp_frpump (element_id, curve_id, status, startup, shutoff)
SELECT element_id, curve_id, status, startup, shutoff
FROM _inp_frpump w JOIN ve_frelem_epump r ON w.node_id::int4=r.node_id AND w.to_arc::int4 = r.to_arc::int4 AND w.order_id = r.order_id;

--- ORIFICE: insert man table
INSERT INTO ve_frelem_eorifice (elementcat_id, state, state_type, num_elements, expl_id, sector_id, muni_id, the_geom, epa_type, node_id, order_id, to_arc, flwreg_length )
SELECT 'EORIFICE-01', state, state_type, 1, expl_id, sector_id, muni_id, the_geom, 'ORIFICE', n.node_id, order_id, to_arc::int4, flwreg_length
FROM _inp_frorifice
JOIN node n ON n.node_id = _inp_frorifice.node_id::int4;

--- ORIFICE: insert epa table
INSERT INTO inp_frorifice
SELECT element_id, ori_type, offsetval, cd, orate, flap, shape, geom1, geom2, geom3, geom4
FROM _inp_frorifice w JOIN ve_frelem_eorifice r ON w.node_id::int4=r.node_id AND w.to_arc::int4 = r.to_arc::int4 AND w.order_id = r.order_id;

--- OUTLET: insert man table
INSERT INTO ve_frelem_eoutlet (elementcat_id, state, state_type, num_elements, expl_id, sector_id, muni_id, the_geom, epa_type, node_id, order_id, to_arc, flwreg_length )
SELECT 'EOUTLET-01', state, state_type, 1, expl_id, sector_id, muni_id, the_geom, 'OUTLET', n.node_id, order_id, to_arc::int4, flwreg_length
FROM _inp_froutlet
JOIN node n ON n.node_id = _inp_froutlet.node_id::int4;

--- OUTLET: insert epa table
INSERT INTO inp_froutlet
SELECT element_id, outlet_type, offsetval, curve_id, cd1, cd2, flap
FROM _inp_froutlet w JOIN ve_frelem_eoutlet r ON w.node_id::int4=r.node_id AND w.to_arc::int4 = r.to_arc::int4 AND w.order_id = r.order_id;

INSERT INTO element_x_node
SELECT element_id, node_id FROM man_frelem;

UPDATE config_form_fields SET isparent = false WHERE formname = 'v_edit_inp_netgully' AND columnname = 'node_type';
UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM inp_hydrograph WHERE id IS NOT NULL ' WHERE formname = 'inp_rdii' AND columnname = 'hydro_id';
UPDATE config_form_fields SET dv_querytext = 'SELECT snow_id as id, snow_id as idval FROM inp_snowpack WHERE snow_id IS NOT NULL ' WHERE formname = 'inp_snowpack' AND columnname = 'snow_id';
UPDATE config_form_fields SET dv_querytext = 'SELECT DISTINCT (lidco_id) AS id,  lidco_id  AS idval FROM inp_lid WHERE lidco_id IS NOT NULL ' WHERE formname = 'v_edit_inp_lid_usage' AND columnname = 'lidco_id';

UPDATE cat_feature SET child_layer='ve_node_overflow_storage' WHERE id='OVERFLOW_STORAGE';

-- CONFIG_FORM_TABS
DELETE FROM config_form_tabs WHERE formname = 've_frelem' AND tabname = 'tab_none';
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('ve_frelem', 'tab_data', 'Data', 'Data', 'role_basic', NULL, '[
  {"actionName": "actionEdit", "disabled": false}
]'::json, 0, '{4}');

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('ve_frelem', 'tab_epa', 'EPA', 'Epa', 'role_basic', NULL, '[
  {"actionName": "actionEdit", "disabled": false}
]'::json, 1, '{4}');

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('ve_frelem', 'tab_documents', 'Documents', 'List of documents', 'role_basic', NULL, '[
  {"actionName": "actionEdit", "disabled": false}
]'::json, 2, '{4}');

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('ve_frelem', 'tab_features', 'Features', 'Manage features', 'role_basic', NULL, '[
  {"actionName": "actionEdit", "disabled": false}
]'::json, 3, '{4}');





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


-- 23/04/2025

-- node
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_node' AND columnname='sys_id';
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_node' AND columnname='id';

INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('node form','utils','tbl_element_x_node','feature_class',4,true,'feature_class');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('node form','utils','tbl_element_x_node','element_type',5,true,'element_type');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('node form','utils','tbl_element_x_node','location_type',16,true,'location_type');

UPDATE config_form_tableview SET columnindex=0,visible=false WHERE objectname='tbl_element_x_node' AND columnname='node_id';
UPDATE config_form_tableview SET columnindex=1 WHERE objectname='tbl_element_x_node' AND columnname='element_id';
UPDATE config_form_tableview SET columnindex=2 WHERE objectname='tbl_element_x_node' AND columnname='elementcat_id';
UPDATE config_form_tableview SET columnindex=3 WHERE objectname='tbl_element_x_node' AND columnname='num_elements';


-- arc
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_arc' AND columnname='sys_id';
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_arc' AND columnname='id';

INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('arc form','utils','tbl_element_x_arc','feature_class',4,true,'feature_class');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('arc form','utils','tbl_element_x_arc','element_type',5,true,'element_type');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('arc form','utils','tbl_element_x_arc','location_type',16,true,'location_type');

UPDATE config_form_tableview SET columnindex=0,visible=false WHERE objectname='tbl_element_x_arc' AND columnname='arc_id';
UPDATE config_form_tableview SET columnindex=1 WHERE objectname='tbl_element_x_arc' AND columnname='element_id';
UPDATE config_form_tableview SET columnindex=2 WHERE objectname='tbl_element_x_arc' AND columnname='elementcat_id';
UPDATE config_form_tableview SET columnindex=3 WHERE objectname='tbl_element_x_arc' AND columnname='num_elements';


-- connec
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_connec' AND columnname='sys_id';
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_connec' AND columnname='id';

INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('connec form','utils','tbl_element_x_connec','feature_class',4,true,'feature_class');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('connec form','utils','tbl_element_x_connec','element_type',5,true,'element_type');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('connec form','utils','tbl_element_x_connec','location_type',16,true,'location_type');

UPDATE config_form_tableview SET columnindex=0,visible=false WHERE objectname='tbl_element_x_connec' AND columnname='connec_id';
UPDATE config_form_tableview SET columnindex=1 WHERE objectname='tbl_element_x_connec' AND columnname='element_id';
UPDATE config_form_tableview SET columnindex=2 WHERE objectname='tbl_element_x_connec' AND columnname='elementcat_id';
UPDATE config_form_tableview SET columnindex=3 WHERE objectname='tbl_element_x_connec' AND columnname='num_elements';


-- gully
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_gully' AND columnname='sys_id';
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_gully' AND columnname='id';

INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('gully form','ud','tbl_element_x_gully','feature_class',4,true,'feature_class');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('gully form','ud','tbl_element_x_gully','element_type',5,true,'element_type');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('gully form','ud','tbl_element_x_gully','state_type',7,true,'state_type');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('gully form','ud','tbl_element_x_gully','location_type',13,true,'location_type');

UPDATE config_form_tableview SET columnindex=0,visible=false WHERE objectname='tbl_element_x_gully' AND columnname='gully_id';
UPDATE config_form_tableview SET columnindex=1 WHERE objectname='tbl_element_x_gully' AND columnname='element_id';
UPDATE config_form_tableview SET columnindex=2 WHERE objectname='tbl_element_x_gully' AND columnname='elementcat_id';
UPDATE config_form_tableview SET columnindex=3 WHERE objectname='tbl_element_x_gully' AND columnname='num_elements';
UPDATE config_form_tableview SET columnindex=8 WHERE objectname='tbl_element_x_gully' AND columnname='observ';
UPDATE config_form_tableview SET columnindex=9 WHERE objectname='tbl_element_x_gully' AND columnname='comment';
UPDATE config_form_tableview SET columnindex=10 WHERE objectname='tbl_element_x_gully' AND columnname='builtdate';
UPDATE config_form_tableview SET columnindex=11 WHERE objectname='tbl_element_x_gully' AND columnname='enddate';
UPDATE config_form_tableview SET columnindex=12 WHERE objectname='tbl_element_x_gully' AND columnname='descript';

UPDATE sys_table SET id='cat_gully', descript='Catalog of gullys.', sys_role='role_edit', context='{"level_1":"INVENTORY","level_2":"CATALOGS"}', orderby=10, alias='Gully catalog', notify_action=NULL, isaudit=NULL, keepauditdays=NULL, "source"='core', addparam=NULL WHERE id='cat_grate';

-- 06/05/2025
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'omzone_id', 'lyt_data_1', 1, 'integer', 'text', 'omzone_id', 'omzone_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'code', 'lyt_data_1', 2, 'string', 'text', 'code', 'code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 3, 'string', 'text', 'name', 'name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 4, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'omzone_type', 'lyt_data_1', 5, 'string', 'combo', 'omzone_type', 'omzone_type', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue=''sector_type''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'macroomzone', 'lyt_data_1', 6, 'string', 'combo', 'macroomzone_id', 'macroomzone_id', NULL, false, false, true, false, NULL, 'SELECT name as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'graphconfig', 'lyt_data_1', 7, 'string', 'text', 'graphconfig', 'graphconfig', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'stylesheet', 'lyt_data_1', 8, 'string', 'text', 'stylesheet', 'stylesheet', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'expl_id', 'lyt_data_2', 9, 'text', 'text', 'expl_id', 'expl_id', 'Ex: 1,2', false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'link', 'lyt_data_3', 10, 'text', 'text', 'link', 'link', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'undelete', 'lyt_data_1', 11, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 12, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'macroomzone_id', 'lyt_data_1', 1, 'integer', 'text', 'macroomzone_id', 'macroomzone_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "valueRelation":{"nullValue":true, "layer": "v_edit_macroomzone", "activated": true, "keyColumn": "macroomzone_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'code', 'lyt_data_1', 2, 'string', 'text', 'code', 'code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 3, 'string', 'text', 'name', 'name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 4, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'expl_id', 'lyt_data_1', 5, 'text', 'text', 'expl_id', 'expl_id', 'Ex: 1,2', false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 6, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'lock_level', 'lyt_data_1', 7, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

-- 06/05/2025
-- TODO: revise if this is needed
-- INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active)
-- VALUES(644, 'Gully which id is not an integer', 'ud', NULL, 'core', true, 'Check om-data', NULL, 3, 'gully which id is not an integer. Please, check your data before continue', NULL, NULL, 'SELECT CASE WHEN gully_id~E''^\\d+$'' THEN CAST (gully_id AS INTEGER)  ELSE 0 END  as feature_id, ''GULLY'' as type, gullycat_id, expl_id FROM t_gully', 'All gullies features with id integer.', '[gw_fct_om_check_data, gw_fct_admin_check_data]', true);

UPDATE config_form_fields SET widgetcontrols='{
  "setMultiline": false,
  "valueRelation": {
    "layer": "v_edit_exploitation",
    "activated": true,
    "keyColumn": "expl_id",
    "nullValue": false,
    "valueColumn": "name",
    "filterExpression": null
  }
}'::json WHERE formname IN ('v_edit_gully', 've_gully') AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_data';

-- 09/05/2025
UPDATE config_form_fields SET dv_querytext =  'SELECT id, resultdate AS idval FROM rpt_arc'
WHERE formname='generic' AND formtype='epa_selector' AND columnname='selector_date' AND tabname='tab_time';

UPDATE config_form_fields SET dv_querytext =  'SELECT id, resultdate AS idval FROM rpt_arc'
WHERE formname='generic' AND formtype='epa_selector' AND columnname='compare_date' AND tabname='tab_time';

UPDATE config_form_fields SET dv_querytext =  'SELECT id, resulttime AS idval FROM rpt_arc'
WHERE formname='generic' AND formtype='epa_selector' AND columnname='selector_time' AND tabname='tab_time';

UPDATE config_form_fields SET dv_querytext =  'SELECT id, resulttime AS idval FROM rpt_arc'
WHERE formname='generic' AND formtype='epa_selector' AND columnname='compare_time' AND tabname='tab_time';


UPDATE config_form_fields SET columnname = 'negative_offset' WHERE columnname = 'negativeoffset';

UPDATE config_csv SET descript='Function to assist the import of timeseries for inp models. The csv file must containts next columns on same position: timseries, timser_type, times_type, descript, expl_id, date, hour, time, value (fill date/hour for ABSOLUTE or time for RELATIVE)' WHERE fid=385;


INSERT INTO inp_subcatchment (subc_id, outlet_id, rg_id, area, imperv, width, slope, clength, snow_id, nimp, nperv, simp, sperv, zero, routeto, rted, maxrate, minrate, decay,
drytime, maxinfil, suction, conduct, initdef, curveno, conduct_2, drytime_2, sector_id, hydrology_id, the_geom, descript, nperv_pattern_id, dstore_pattern_id, infil_pattern_id,
minelev, muni_id)
SELECT subc_id, outlet_id::int4, rg_id, area, imperv, width, slope, clength, snow_id, nimp, nperv, simp, sperv, zero, routeto, rted, maxrate, minrate, decay,
drytime, maxinfil, suction, conduct, initdef, curveno, conduct_2, drytime_2, sector_id, hydrology_id, the_geom, descript, nperv_pattern_id, dstore_pattern_id, infil_pattern_id,
minelev, muni_id
FROM _inp_subcatchment;

-- 16/05/2025
DELETE FROM edit_typevalue WHERE typevalue IN('dwfzone_type', 'drainzone_type') AND id='UNDEFINED';

INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_dwf_drain_type', '0', 'UNDEFINED', NULL, NULL) ON CONFLICT DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_dwf_drain_type', '1', 'TREATED', NULL, NULL) ON CONFLICT DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_dwf_drain_type', '2', 'UNTREATED', NULL, NULL) ON CONFLICT DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_dwf_drain_type', '3', 'MIXED', NULL, NULL) ON CONFLICT DO NOTHING;

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_dwf_drain_type', 'dwfzone', 'dwfzone_type', NULL, true) ON CONFLICT DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_dwf_drain_type', 'drainzone', 'drainzone_type', NULL, true) ON CONFLICT DO NOTHING;

-- 19/05/2025
INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('v_edit_dwfzone', 'Shows editable information about dwfzone.', 'role_edit', '{"template": [1]}', '{"level_1":"INVENTORY","level_2":"MAP ZONES"}', 1, 'Dwfzone', NULL, NULL, NULL, 'core', NULL);

UPDATE sys_table SET project_template = '{"template": [1]}'
WHERE id IN (
	'v_edit_cat_feature_gully',
	'cat_gully',
	'v_edit_drainzone',
	'v_edit_gully',
	've_pol_gully'
);

-- 21/05/2025
INSERT INTO sys_table (id, descript, sys_role) VALUES ('arc_add', 'arc_add', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_arc_traceability', 'archived_psector_arc_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_connec_traceability', 'archived_psector_connec_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_gully_traceability', 'archived_psector_gully_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_link_traceability', 'archived_psector_link_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_node_traceability', 'archived_psector_node_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_inp_arc', 'archived_rpt_inp_arc', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_inp_node', 'archived_rpt_inp_node', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_inp_raingage', 'archived_rpt_inp_raingage', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_lidperformance_sum', 'archived_rpt_lidperformance_sum', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_subcatchment', 'archived_rpt_subcatchment', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_subcatchrunoff_sum', 'archived_rpt_subcatchrunoff_sum', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_subcatchwashoff_sum', 'archived_rpt_subcatchwashoff_sum', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('cat_feature_element', 'cat_feature_element', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('cat_feature_link', 'cat_feature_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('cat_link', 'cat_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('config_form_help', 'config_form_help', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('doc_x_element', 'doc_x_element', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('doc_x_link', 'doc_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('dwfzone', 'dwfzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('element_x_link', 'element_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ext_region_x_province', 'ext_region_x_province', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_dscenario_frorifice', 'inp_dscenario_frorifice', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_dscenario_froutlet', 'inp_dscenario_froutlet', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_dscenario_frpump', 'inp_dscenario_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_dscenario_frweir', 'inp_dscenario_frweir', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_dscenario_lids', 'inp_dscenario_lids', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_frorifice', 'inp_frorifice', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_froutlet', 'inp_froutlet', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_frpump', 'inp_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_frweir', 'inp_frweir', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('macroomzone', 'macroomzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('man_frelem', 'man_frelem', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('man_genelem', 'man_genelem', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('man_conduitlink', 'man_conduitlink', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('minsector_mincut', 'minsector_mincut', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('node_add', 'node_add', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('om_visit_x_link', 'om_visit_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('omzone', 'omzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('sys_feature_class', 'sys_feature_class', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_cat_dwf', 'v_edit_cat_dwf', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_cat_feature_link', 'v_edit_cat_feature_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_dscenario_frorifice', 'v_edit_inp_dscenario_frorifice', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_dscenario_froutlet', 'v_edit_inp_dscenario_froutlet', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_dscenario_frpump', 'v_edit_inp_dscenario_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_dscenario_frweir', 'v_edit_inp_dscenario_frweir', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_dscenario_lids', 'v_edit_inp_dscenario_lids', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_frorifice', 'v_edit_inp_frorifice', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_froutlet', 'v_edit_inp_froutlet', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_frpump', 'v_edit_inp_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_frweir', 'v_edit_inp_frweir', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_macroomzone', 'v_edit_macroomzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_omzone', 'v_edit_omzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_rpt_arc', 'v_rpt_arc', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_rpt_node', 'v_rpt_node', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_doc_x_element', 'v_ui_doc_x_element', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_doc_x_link', 'v_ui_doc_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_dwfzone', 'v_ui_dwfzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_element_x_link', 'v_ui_element_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_macroomzone', 'v_ui_macroomzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_macrosector', 'v_ui_macrosector', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_om_visit_x_link', 'v_ui_om_visit_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_omzone', 'v_ui_omzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_sector', 'v_ui_sector', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_sys_style', 'v_ui_sys_style', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ve_epa_frorifice', 've_epa_frorifice', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ve_epa_froutlet', 've_epa_froutlet', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ve_epa_frpump', 've_epa_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ve_epa_frweir', 've_epa_frweir', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, "source") VALUES('ve_genelem', 'Specific view for general elements', 'role_basic', '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"ELEMENT"}', 'General elements', 1, 'core');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ve_visit_gully_singlevent', 've_visit_gully_singlevent', 'role_edit');

DELETE FROM sys_table WHERE id = 'audit_psector_arc_traceability';
DELETE FROM sys_table WHERE id = 'audit_psector_connec_traceability';
DELETE FROM sys_table WHERE id = 'audit_psector_gully_traceability';
DELETE FROM sys_table WHERE id = 'audit_psector_node_traceability';
DELETE FROM sys_table WHERE id = 'dma';
DELETE FROM sys_table WHERE id = 'doc_type';
DELETE FROM sys_table WHERE id = 'ext_rtc_dma_period';
DELETE FROM sys_table WHERE id = 'inp_backdrop';
DELETE FROM sys_table WHERE id = 'inp_dscenario_flwreg_orifice';
DELETE FROM sys_table WHERE id = 'inp_dscenario_flwreg_outlet';
DELETE FROM sys_table WHERE id = 'inp_dscenario_flwreg_pump';
DELETE FROM sys_table WHERE id = 'inp_dscenario_flwreg_weir';
DELETE FROM sys_table WHERE id = 'inp_dscenario_lid_usage';
DELETE FROM sys_table WHERE id = 'inp_flwreg_orifice';
DELETE FROM sys_table WHERE id = 'inp_flwreg_outlet';
DELETE FROM sys_table WHERE id = 'inp_flwreg_pump';
DELETE FROM sys_table WHERE id = 'inp_flwreg_weir';
DELETE FROM sys_table WHERE id = 'macrodma';
DELETE FROM sys_table WHERE id = 'man_type_fluid';
DELETE FROM sys_table WHERE id = 'om_reh_cat_works';
DELETE FROM sys_table WHERE id = 'om_reh_parameter_x_works';
DELETE FROM sys_table WHERE id = 'om_reh_value_loc_condition';
DELETE FROM sys_table WHERE id = 'om_reh_works_x_pcompost';
DELETE FROM sys_table WHERE id = 'rtc_scada_x_dma';
DELETE FROM sys_table WHERE id = 'rtc_scada_x_sector';
DELETE FROM sys_table WHERE id = 'sys_feature_cat';
DELETE FROM sys_table WHERE id = 'test';
DELETE FROM sys_table WHERE id = 'v_arc';
DELETE FROM sys_table WHERE id = 'v_connec';
DELETE FROM sys_table WHERE id = 'v_edit_cat_dwf_scenario';
DELETE FROM sys_table WHERE id = 'v_edit_dma';
DELETE FROM sys_table WHERE id = 'v_edit_element';
DELETE FROM sys_table WHERE id = 'v_edit_inp_dscenario_flwreg_orifice';
DELETE FROM sys_table WHERE id = 'v_edit_inp_dscenario_flwreg_outlet';
DELETE FROM sys_table WHERE id = 'v_edit_inp_dscenario_flwreg_pump';
DELETE FROM sys_table WHERE id = 'v_edit_inp_dscenario_flwreg_weir';
DELETE FROM sys_table WHERE id = 'v_edit_inp_dscenario_lid_usage';
DELETE FROM sys_table WHERE id = 'v_edit_inp_flwreg_orifice';
DELETE FROM sys_table WHERE id = 'v_edit_inp_flwreg_outlet';
DELETE FROM sys_table WHERE id = 'v_edit_inp_flwreg_pump';
DELETE FROM sys_table WHERE id = 'v_edit_inp_flwreg_weir';
DELETE FROM sys_table WHERE id = 'v_edit_macrodma';
DELETE FROM sys_table WHERE id = 'v_edit_plan_psector_x_connec';
DELETE FROM sys_table WHERE id = 'v_edit_plan_psector_x_gully';
DELETE FROM sys_table WHERE id = 'v_edit_review_audit_node';
DELETE FROM sys_table WHERE id = 'v_gully';
DELETE FROM sys_table WHERE id = 'v_link';
DELETE FROM sys_table WHERE id = 'v_link_connec';
DELETE FROM sys_table WHERE id = 'v_link_gully';
DELETE FROM sys_table WHERE id = 'v_node';
DELETE FROM sys_table WHERE id = 'v_price_x_arc';
DELETE FROM sys_table WHERE id = 'v_rpt_arc_all';
DELETE FROM sys_table WHERE id = 'v_rpt_comp_lidperformance_sum';
DELETE FROM sys_table WHERE id = 'v_rpt_comp_subcatchrunoff_sum';
DELETE FROM sys_table WHERE id = 'v_rpt_comp_subcatchwashoff_sum';
DELETE FROM sys_table WHERE id = 'v_rpt_lidperformance_sum';
DELETE FROM sys_table WHERE id = 'v_rpt_node_all';
DELETE FROM sys_table WHERE id = 'v_rpt_subcatchrunoff_sum';
DELETE FROM sys_table WHERE id = 'v_rpt_subcatchwashoff_sum';
DELETE FROM sys_table WHERE id = 'v_rtc_period_dma';
DELETE FROM sys_table WHERE id = 'v_rtc_period_hydrometer';
DELETE FROM sys_table WHERE id = 'v_rtc_period_node';
DELETE FROM sys_table WHERE id = 'v_rtc_period_pjoint';
DELETE FROM sys_table WHERE id = 'v_state_gully';
DELETE FROM sys_table WHERE id = 'v_state_link_connec';
DELETE FROM sys_table WHERE id = 'v_state_link_gully';
DELETE FROM sys_table WHERE id = 'v_ui_om_visitman_x_connec';
DELETE FROM sys_table WHERE id = 'vcv_dma';
DELETE FROM sys_table WHERE id = 've_arc';
DELETE FROM sys_table WHERE id = 've_connec';
DELETE FROM sys_table WHERE id = 've_gully';
DELETE FROM sys_table WHERE id = 've_node';
DELETE FROM sys_table WHERE id = 'vi_adjustments';
DELETE FROM sys_table WHERE id = 'vi_aquifers';
DELETE FROM sys_table WHERE id = 'vi_backdrop';
DELETE FROM sys_table WHERE id = 'vi_buildup';
DELETE FROM sys_table WHERE id = 'vi_conduits';
DELETE FROM sys_table WHERE id = 'vi_controls';
DELETE FROM sys_table WHERE id = 'vi_coordinates';
DELETE FROM sys_table WHERE id = 'vi_coverages';
DELETE FROM sys_table WHERE id = 'vi_curves';
DELETE FROM sys_table WHERE id = 'vi_dividers';
DELETE FROM sys_table WHERE id = 'vi_dwf';
DELETE FROM sys_table WHERE id = 'vi_evaporation';
DELETE FROM sys_table WHERE id = 'vi_files';
DELETE FROM sys_table WHERE id = 'vi_groundwater';
DELETE FROM sys_table WHERE id = 'vi_gully';
DELETE FROM sys_table WHERE id = 'vi_gully2node';
DELETE FROM sys_table WHERE id = 'vi_gwf';
DELETE FROM sys_table WHERE id = 'vi_hydrographs';
DELETE FROM sys_table WHERE id = 'vi_infiltration';
DELETE FROM sys_table WHERE id = 'vi_inflows';
DELETE FROM sys_table WHERE id = 'vi_junctions';
DELETE FROM sys_table WHERE id = 'vi_labels';
DELETE FROM sys_table WHERE id = 'vi_landuses';
DELETE FROM sys_table WHERE id = 'vi_lid_controls';
DELETE FROM sys_table WHERE id = 'vi_lid_usage';
DELETE FROM sys_table WHERE id = 'vi_loadings';
DELETE FROM sys_table WHERE id = 'vi_losses';
DELETE FROM sys_table WHERE id = 'vi_map';
DELETE FROM sys_table WHERE id = 'vi_options';
DELETE FROM sys_table WHERE id = 'vi_orifices';
DELETE FROM sys_table WHERE id = 'vi_outfalls';
DELETE FROM sys_table WHERE id = 'vi_outlets';
DELETE FROM sys_table WHERE id = 'vi_patterns';
DELETE FROM sys_table WHERE id = 'vi_polygons';
DELETE FROM sys_table WHERE id = 'vi_pumps';
DELETE FROM sys_table WHERE id = 'vi_raingages';
DELETE FROM sys_table WHERE id = 'vi_rdii';
DELETE FROM sys_table WHERE id = 'vi_report';
DELETE FROM sys_table WHERE id = 'vi_snowpacks';
DELETE FROM sys_table WHERE id = 'vi_storage';
DELETE FROM sys_table WHERE id = 'vi_subareas';
DELETE FROM sys_table WHERE id = 'vi_subcatchcentroid';
DELETE FROM sys_table WHERE id = 'vi_subcatchments';
DELETE FROM sys_table WHERE id = 'vi_symbols';
DELETE FROM sys_table WHERE id = 'vi_temperature';
DELETE FROM sys_table WHERE id = 'vi_timeseries';
DELETE FROM sys_table WHERE id = 'vi_transects';
DELETE FROM sys_table WHERE id = 'vi_treatment';
DELETE FROM sys_table WHERE id = 'vi_vertices';
DELETE FROM sys_table WHERE id = 'vi_washoff';
DELETE FROM sys_table WHERE id = 'vi_weirs';
DELETE FROM sys_table WHERE id = 'vi_xsections';
DELETE FROM sys_table WHERE id = 'vu_arc';
DELETE FROM sys_table WHERE id = 'vu_connec';
DELETE FROM sys_table WHERE id = 'vu_exploitation';
DELETE FROM sys_table WHERE id = 'vu_ext_municipality';
DELETE FROM sys_table WHERE id = 'vu_gully';
DELETE FROM sys_table WHERE id = 'vu_link';
DELETE FROM sys_table WHERE id = 'vu_link_connec';
DELETE FROM sys_table WHERE id = 'vu_link_gully';
DELETE FROM sys_table WHERE id = 'vu_macroexploitation';
DELETE FROM sys_table WHERE id = 'vu_macrosector';
DELETE FROM sys_table WHERE id = 'vu_node';
DELETE FROM sys_table WHERE id = 'vu_om_mincut';

UPDATE sys_table SET addparam='{
  "pkey": "element_id"
}'::json WHERE id='ve_frelem_eweir';
UPDATE sys_table SET addparam='{
  "pkey": "element_id"
}'::json WHERE id='ve_frelem_epump';
UPDATE sys_table SET addparam='{
  "pkey": "element_id"
}'::json WHERE id='ve_frelem_eoutlet';
UPDATE sys_table SET addparam='{
  "pkey": "element_id"
}'::json WHERE id='ve_frelem_eorifice';
UPDATE sys_table SET addparam='{
  "pkey": "element_id"
}'::json WHERE id='ve_frelem';

-- 21/05/2025
UPDATE config_param_system SET value='{"DRAINZONE":{"mode":"Random", "column":"name"},"SECTOR":{"mode":"Random", "column":"name"},"DMA":{"mode":"Random", "column":"name"}, "DWFZONE" :{"mode":"Random", "column":"name"}}'
WHERE "parameter"='utils_graphanalytics_style';

UPDATE config_toolbox SET inputparams='[{"widgetname":"graphClass", "label":"Graph class:", "widgettype":"combo","datatype":"text","tooltip": "Graphanalytics method used", "layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["DWFZONE","MACROSECTOR","SECTOR"],
"comboNames":["Drainage area (DWFZONE + DRAINZONE)","(MACROSECTOR)","(SECTOR)"], "selectedId":""},{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text","tooltip": "Choose exploitation to work with", "layoutname":"grl_option_parameters","layoutorder":2, "dvQueryText":"SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC", "selectedId":""}, {"widgetname":"floodOnlyMapzone", "label":"Flood only one mapzone: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Flood only identified mapzones. The purpose of this is update only network elements affected by this flooding keeping rest of network as is. Recommended to gain performance when mapzones ecosystem is under work", "placeholder":"1001", "layoutname":"grl_option_parameters","layoutorder":3, "value":""}, {"widgetname":"forceOpen", "label":"Force open nodes: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there", "placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":5, "value":""}, {"widgetname":"forceClosed", "label":"Force closed nodes: (*)","widgettype":"text","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary close open node(s) to force algorithm to stop there","placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":6,"value":""}, {"widgetname":"usePlanPsector", "label":"Use selected psectors:", "widgettype":"check","datatype":"boolean","tooltip":"If true, use selected psectors. If false ignore selected psectors and only works with on-service network" , "layoutname":"grl_option_parameters","layoutorder":7,"value":""}, {"widgetname":"commitChanges", "label":"Commit changes:", "widgettype":"check","datatype":"boolean","tooltip":"If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables" , "layoutname":"grl_option_parameters","layoutorder":8,"value":""}, {"widgetname":"valueForDisconnected", "label":"Value for disconn. and conflict: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Value to use for disconnected features. Usefull for work in progress with dynamic mpzonesnode" , "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":9, "value":""}, {"widgetname":"updateMapZone", "label":"Mapzone constructor method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":10,"comboIds":[0,1,2,6], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT + PIPE BUFFER", "LINK + PIPE BUFFER", "EPA SUBCATCH"], "selectedId":""}, {"widgetname":"geomParamUpdate", "label":"Pipe buffer","widgettype":"text","datatype":"float","tooltip":"Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.", "layoutname":"grl_option_parameters","layoutorder":11, "isMandatory":false, "placeholder":"5-30", "value":""}]'::json WHERE id=2768;

-- 03/06/2025
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3424, 'gw_fct_graphanalytics_fluid_type', 'ud', 'function', 'json', 'json',
'Function to generate fluid_type of your arcs and nodes. Stop your mouse over labels for more information about input parameters.', 'role_plan', NULL, 'core', NULL);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active)
VALUES(637, 'Fluid type calculation	', 'ud	', NULL, 'core', true, 'Function process', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true);

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device)
VALUES(3424, 'Fluid type analysis', '{"featureType":[]}'::json, '[
{
  "label": "Process name:", 
  "value": null, 
  "tooltip": "Process name", 
  "comboIds": ["FLUIDTYPE"], 
  "datatype": "text", 
  "comboNames": ["Fluid type"], 
  "layoutname": "grl_option_parameters", 
  "selectedId": null,
  "widgetname": "processName", 
  "widgettype": "combo", 
  "layoutorder": 1
}, 
{
  "label": "Exploitation:", 
  "value": null, 
  "tooltip": "Choose exploitation to work with", 
  "datatype": "text", 
  "layoutname": "grl_option_parameters", 
  "selectedId": null, 
  "widgetname": "exploitation", 
  "widgettype": "combo", 
  "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC", 
  "layoutorder": 2
}, 
{
  "label": "Use selected psectors:", 
  "value": null, 
  "tooltip": "If true, use selected psectors. If false ignore selected psectors and only works with on-service network", 
  "datatype": "boolean",
  "layoutname": "grl_option_parameters", 
  "selectedId": null, 
  "widgetname": "usePlanPsector", 
  "widgettype": "check", 
  "layoutorder": 3}, 
{
  "label": "Commit changes:", 
  "value": null, 
  "tooltip": "If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables", 
  "datatype": "boolean", "layoutname": "grl_option_parameters", 
  "selectedId": null, 
  "widgetname": "commitChanges", 
  "widgettype": "check", 
  "layoutorder": 4}
]'::json, NULL, true, '{4}');

UPDATE config_form_tableview SET visible=true WHERE objectname='tbl_element_x_gully' AND columnname='gully_id';

-- 04/06/2025
INSERT INTO cat_element (id, element_type, matcat_id, geometry, descript, link, brand, "type", model, svg, active, geom1, geom2, isdoublegeom) VALUES('GATE-01', 'EGATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL, NULL, NULL);

-- CONFIG_FORM_FIELDS

-- ve_genelem_egate
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_genelem_egate', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''EGATE''', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 4, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 3, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, true, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'muni_id', 'lyt_data_3', 1, 'string', 'combo', 'Municipality id:', 'muni_id - Identifier of the municipality', NULL, false, false, true, NULL, NULL, 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL', true, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'observ', 'lyt_data_3', 0, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'btn_delete', 'lyt_features_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "112"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'btn_expr_select', 'lyt_features_1', 4, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, '{
  "saveValue": false
}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'feature_id', 'lyt_features_1', 0, 'text', 'text', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'btn_snapping', 'lyt_features_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, '{
  "saveValue": false
}'::json, '{
  "functionName": "selection_init"
}'::json, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'tbl_element_x_arc', 'lyt_features_2_arc', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json, NULL, 'tbl_element_x_arc', false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'tbl_element_x_connec', 'lyt_features_2_connec', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json, NULL, 'tbl_element_x_connec', false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'tbl_element_x_gully', 'lyt_features_2_gully', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json, NULL, 'tbl_element_x_gully', false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'tbl_element_x_link', 'lyt_features_2_link', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json, NULL, 'tbl_element_x_link', false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'tbl_element_x_node', 'lyt_features_2_node', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json, NULL, 'tbl_element_x_node', false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'btn_insert', 'lyt_features_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "111"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json, NULL, false, NULL)
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


-- ve_genelem_eiot_sensor
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 4, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 3, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, true, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'muni_id', 'lyt_data_3', 1, 'string', 'combo', 'Municipality id:', 'muni_id - Identifier of the municipality', NULL, false, false, true, NULL, NULL, 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL', true, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'observ', 'lyt_data_3', 0, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''EIOT_SENSOR''', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'btn_delete', 'lyt_features_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "112"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'btn_expr_select', 'lyt_features_1', 4, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, '{
  "saveValue": false
}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'feature_id', 'lyt_features_1', 0, 'text', 'text', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'btn_snapping', 'lyt_features_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, '{
  "saveValue": false
}'::json, '{
  "functionName": "selection_init"
}'::json, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'tbl_element_x_arc', 'lyt_features_2_arc', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json, NULL, 'tbl_element_x_arc', false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'tbl_element_x_connec', 'lyt_features_2_connec', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json, NULL, 'tbl_element_x_connec', false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'tbl_element_x_gully', 'lyt_features_2_gully', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json, NULL, 'tbl_element_x_gully', false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'tbl_element_x_link', 'lyt_features_2_link', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json, NULL, 'tbl_element_x_link', false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'tbl_element_x_node', 'lyt_features_2_node', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json, NULL, 'tbl_element_x_node', false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'btn_insert', 'lyt_features_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "111"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json, NULL, false, NULL)
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


-- ve_genelem_eprotector
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, true, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'muni_id', 'lyt_data_3', 1, 'string', 'combo', 'Municipality id:', 'muni_id - Identifier of the municipality', NULL, false, false, true, NULL, NULL, 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL', true, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'observ', 'lyt_data_3', 0, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 4, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 3, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''EPROTECTOR''', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'btn_delete', 'lyt_features_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "112"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'btn_expr_select', 'lyt_features_1', 4, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, '{
  "saveValue": false
}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'feature_id', 'lyt_features_1', 0, 'text', 'text', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'btn_snapping', 'lyt_features_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, '{
  "saveValue": false
}'::json, '{
  "functionName": "selection_init"
}'::json, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'tbl_element_x_arc', 'lyt_features_2_arc', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json, NULL, 'tbl_element_x_arc', false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'tbl_element_x_connec', 'lyt_features_2_connec', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json, NULL, 'tbl_element_x_connec', false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'tbl_element_x_gully', 'lyt_features_2_gully', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json, NULL, 'tbl_element_x_gully', false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'tbl_element_x_link', 'lyt_features_2_link', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json, NULL, 'tbl_element_x_link', false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'tbl_element_x_node', 'lyt_features_2_node', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json, NULL, 'tbl_element_x_node', false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'btn_insert', 'lyt_features_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "111"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json, NULL, false, NULL)
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


-- ve_frelem_eorifice
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'muni_id', 'lyt_data_3', 1, 'integer', 'combo', 'municipality', 'muni_id', NULL, false, false, true, false, NULL, 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 56),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'to_arc', 'lyt_data_2', 1, 'string', 'text', 'to_arc', 'to_arc', NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'observ', 'lyt_data_3', 0, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 3, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 4, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''EORIFICE''', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'flwreg_length', 'lyt_data_2', 2, 'double', 'text', 'flwreg_length', 'flwreg_length', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'order_id', 'lyt_data_2', 3, 'double', 'text', 'order_id', 'order_id', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'node_id', 'lyt_data_1', 1, 'string', 'text', 'node_id', NULL, NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, true, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'nodarc_id', 'lyt_data_2', 0, 'string', 'text', 'nodarc_id', 'nodarc_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'btn_delete', 'lyt_features_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "112"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'btn_expr_select', 'lyt_features_1', 4, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, '{
  "saveValue": false
}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'feature_id', 'lyt_features_1', 0, 'text', 'text', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'btn_snapping', 'lyt_features_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, '{
  "saveValue": false
}'::json, '{
  "functionName": "selection_init"
}'::json, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'tbl_element_x_arc', 'lyt_features_2_arc', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json, NULL, 'tbl_element_x_arc', false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'tbl_element_x_connec', 'lyt_features_2_connec', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json, NULL, 'tbl_element_x_connec', false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'tbl_element_x_gully', 'lyt_features_2_gully', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json, NULL, 'tbl_element_x_gully', false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'tbl_element_x_link', 'lyt_features_2_link', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json, NULL, 'tbl_element_x_link', false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'tbl_element_x_node', 'lyt_features_2_node', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json, NULL, 'tbl_element_x_node', false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'btn_insert', 'lyt_features_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "111"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json, NULL, false, NULL)
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

-- ve_epa_frorifice
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'orifice_type', 'lyt_epa_data_1', 0, 'string', 'combo', 'Orifice Type', 'Orifice Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'offsetval', 'lyt_epa_data_1', 1, 'double', 'text', 'Offset Value', 'Offset Value', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'cd', 'lyt_epa_data_1', 2, 'double', 'text', 'Discharge Coefficient', 'Discharge Coefficient', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'orate', 'lyt_epa_data_1', 3, 'double', 'text', 'Orifice Rate', 'Orifice Rate', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'flap', 'lyt_epa_data_1', 4, 'boolean', 'check', 'Flap', 'Flap', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'shape', 'lyt_epa_data_1', 5, 'string', 'text', 'Shape', 'Shape', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'geom1', 'lyt_epa_data_1', 6, 'double', 'text', 'Geom1', 'Geom1', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'geom2', 'lyt_epa_data_1', 7, 'double', 'text', 'Geom2', 'Geom2', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'geom3', 'lyt_epa_data_1', 8, 'double', 'text', 'Geom3', 'Geom3', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'geom4', 'lyt_epa_data_1', 9, 'double', 'text', 'Geom4', 'Geom4', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'max_flow', 'lyt_epa_data_2', 0, 'double', 'text', 'Maximum Flow', 'Maximum Flow', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'time_days', 'lyt_epa_data_2', 1, 'integer', 'text', 'Time Days', 'Time Days', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'time_hour', 'lyt_epa_data_2', 2, 'integer', 'text', 'Time Hour', 'Time Hour', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'max_veloc', 'lyt_epa_data_2', 3, 'double', 'text', 'Maximum Velocity', 'Maximum Velocity', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'mfull_flow', 'lyt_epa_data_2', 4, 'double', 'text', 'Full Flow', 'Full Flow', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'mfull_depth', 'lyt_epa_data_2', 5, 'double', 'text', 'Full Depth', 'Full Depth', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'max_shear', 'lyt_epa_data_2', 6, 'double', 'text', 'Maximum Shear', 'Maximum Shear', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'max_hr', 'lyt_epa_data_2', 7, 'double', 'text', 'Maximum Hydraulic Radius', 'Maximum Hydraulic Radius', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'max_slope', 'lyt_epa_data_2', 8, 'double', 'text', 'Maximum Slope', 'Maximum Slope', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'day_max', 'lyt_epa_data_2', 9, 'integer', 'text', 'Day Maximum', 'Day Maximum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'time_max', 'lyt_epa_data_2', 10, 'integer', 'text', 'Time Maximum', 'Time Maximum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'min_shear', 'lyt_epa_data_2', 11, 'double', 'text', 'Minimum Shear', 'Minimum Shear', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'day_min', 'lyt_epa_data_2', 12, 'integer', 'text', 'Day Minimum', 'Day Minimum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'time_min', 'lyt_epa_data_2', 13, 'integer', 'text', 'Time Minimum', 'Time Minimum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);


-- ve_frelem_eoutlet
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'muni_id', 'lyt_data_3', 1, 'integer', 'combo', 'municipality', 'muni_id', NULL, false, false, true, false, NULL, 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 56),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 3, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 4, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'flwreg_length', 'lyt_data_2', 2, 'double', 'text', 'flwreg_length', 'flwreg_length', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'order_id', 'lyt_data_2', 3, 'double', 'text', 'order_id', 'order_id', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'to_arc', 'lyt_data_2', 1, 'string', 'text', 'to_arc', 'to_arc', NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'node_id', 'lyt_data_1', 1, 'string', 'text', 'node_id', NULL, NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'observ', 'lyt_data_3', 0, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, true, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''EOUTLET''', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'nodarc_id', 'lyt_data_2', 0, 'string', 'text', 'nodarc_id', 'nodarc_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EOUTLET'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EOUTLET'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EOUTLET'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'btn_delete', 'lyt_features_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "112"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'btn_expr_select', 'lyt_features_1', 4, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, '{
  "saveValue": false
}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'feature_id', 'lyt_features_1', 0, 'text', 'text', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'btn_snapping', 'lyt_features_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, '{
  "saveValue": false
}'::json, '{
  "functionName": "selection_init"
}'::json, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'tbl_element_x_arc', 'lyt_features_2_arc', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json, NULL, 'tbl_element_x_arc', false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'tbl_element_x_connec', 'lyt_features_2_connec', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json, NULL, 'tbl_element_x_connec', false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'tbl_element_x_gully', 'lyt_features_2_gully', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json, NULL, 'tbl_element_x_gully', false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'tbl_element_x_link', 'lyt_features_2_link', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json, NULL, 'tbl_element_x_link', false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'tbl_element_x_node', 'lyt_features_2_node', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json, NULL, 'tbl_element_x_node', false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'btn_insert', 'lyt_features_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "111"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json, NULL, false, NULL)
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

-- ve_epa_froutlet
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'outlet_type', 'lyt_epa_data_1', 0, 'string', 'combo', 'Outlet Type', 'Outlet Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'offsetval', 'lyt_epa_data_1', 1, 'double', 'text', 'Offset Value', 'Offset Value', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'curve_id', 'lyt_epa_data_1', 2, 'string', 'text', 'Curve ID', 'Curve ID', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'cd1', 'lyt_epa_data_1', 3, 'double', 'text', 'Discharge Coefficient 1', 'Discharge Coefficient 1', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'cd2', 'lyt_epa_data_1', 4, 'double', 'text', 'Discharge Coefficient 2', 'Discharge Coefficient 2', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'flap', 'lyt_epa_data_1', 5, 'boolean', 'check', 'Flap', 'Flap', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'max_flow', 'lyt_epa_data_2', 0, 'double', 'text', 'Maximum Flow', 'Maximum Flow', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'time_days', 'lyt_epa_data_2', 1, 'integer', 'text', 'Time Days', 'Time Days', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'time_hour', 'lyt_epa_data_2', 2, 'integer', 'text', 'Time Hour', 'Time Hour', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'max_veloc', 'lyt_epa_data_2', 3, 'double', 'text', 'Maximum Velocity', 'Maximum Velocity', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'mfull_flow', 'lyt_epa_data_2', 4, 'double', 'text', 'Full Flow', 'Full Flow', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'mfull_dept', 'lyt_epa_data_2', 5, 'double', 'text', 'Full Depth', 'Full Depth', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'max_shear', 'lyt_epa_data_2', 6, 'double', 'text', 'Maximum Shear', 'Maximum Shear', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'max_hr', 'lyt_epa_data_2', 7, 'double', 'text', 'Maximum Hydraulic Radius', 'Maximum Hydraulic Radius', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'max_slope', 'lyt_epa_data_2', 8, 'double', 'text', 'Maximum Slope', 'Maximum Slope', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'day_max', 'lyt_epa_data_2', 9, 'integer', 'text', 'Day Maximum', 'Day Maximum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'time_max', 'lyt_epa_data_2', 10, 'integer', 'text', 'Time Maximum', 'Time Maximum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'min_shear', 'lyt_epa_data_2', 11, 'double', 'text', 'Minimum Shear', 'Minimum Shear', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'day_min', 'lyt_epa_data_2', 12, 'integer', 'text', 'Day Minimum', 'Day Minimum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'time_min', 'lyt_epa_data_2', 13, 'integer', 'text', 'Time Minimum', 'Time Minimum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

-- ve_frelem_eweir
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_frelem_eweir', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'muni_id', 'lyt_data_3', 1, 'integer', 'combo', 'municipality', 'muni_id', NULL, false, false, true, false, NULL, 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 56),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 3, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 4, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'flwreg_length', 'lyt_data_2', 2, 'double', 'text', 'flwreg_length', 'flwreg_length', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'order_id', 'lyt_data_2', 3, 'double', 'text', 'order_id', 'order_id', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'to_arc', 'lyt_data_2', 1, 'string', 'text', 'to_arc', 'to_arc', NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'node_id', 'lyt_data_1', 1, 'string', 'text', 'node_id', NULL, NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''EWEIR''', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'observ', 'lyt_data_3', 0, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, true, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'nodarc_id', 'lyt_data_2', 0, 'string', 'text', 'nodarc_id', 'nodarc_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EWEIR'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EWEIR'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EWEIR'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'btn_delete', 'lyt_features_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "112"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'btn_expr_select', 'lyt_features_1', 4, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, '{
  "saveValue": false
}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'feature_id', 'lyt_features_1', 0, 'text', 'text', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'btn_snapping', 'lyt_features_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, '{
  "saveValue": false
}'::json, '{
  "functionName": "selection_init"
}'::json, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'tbl_element_x_arc', 'lyt_features_2_arc', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json, NULL, 'tbl_element_x_arc', false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'tbl_element_x_connec', 'lyt_features_2_connec', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json, NULL, 'tbl_element_x_connec', false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'tbl_element_x_gully', 'lyt_features_2_gully', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json, NULL, 'tbl_element_x_gully', false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'tbl_element_x_link', 'lyt_features_2_link', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json, NULL, 'tbl_element_x_link', false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'tbl_element_x_node', 'lyt_features_2_node', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json, NULL, 'tbl_element_x_node', false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'btn_insert', 'lyt_features_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "111"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json, NULL, false, NULL)
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

-- ve_epa_frweir
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_epa_frweir', 'form_feature', 'tab_epa', 'weir_type', 'lyt_epa_data_1', 0, 'string', 'combo', 'Weir Type', 'Weir Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'offsetval', 'lyt_epa_data_1', 1, 'double', 'text', 'Offset Value', 'Offset Value', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'cd', 'lyt_epa_data_1', 2, 'double', 'text', 'Discharge Coefficient', 'Discharge Coefficient', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'ec', 'lyt_epa_data_1', 3, 'double', 'text', 'End Contractions', 'End Contractions', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'cd2', 'lyt_epa_data_1', 4, 'double', 'text', 'Discharge Coefficient 2', 'Discharge Coefficient 2', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'flap', 'lyt_epa_data_1', 5, 'boolean', 'check', 'Flap', 'Flap', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'geom1', 'lyt_epa_data_1', 6, 'double', 'text', 'Geom1', 'Geom1', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'geom2', 'lyt_epa_data_1', 7, 'double', 'text', 'Geom2', 'Geom2', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'geom3', 'lyt_epa_data_1', 8, 'double', 'text', 'Geom3', 'Geom3', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'geom4', 'lyt_epa_data_1', 9, 'double', 'text', 'Geom4', 'Geom4', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'surcharge', 'lyt_epa_data_1', 10, 'double', 'text', 'Surcharge', 'Surcharge', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'road_width', 'lyt_epa_data_1', 11, 'double', 'text', 'Road Width', 'Road Width', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'road_surf', 'lyt_epa_data_1', 12, 'string', 'text', 'Road Surface', 'Road Surface', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'coef_curve', 'lyt_epa_data_1', 13, 'string', 'text', 'Coefficient Curve', 'Coefficient Curve', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'max_flow', 'lyt_epa_data_2', 0, 'double', 'text', 'Maximum Flow', 'Maximum Flow', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'time_days', 'lyt_epa_data_2', 1, 'integer', 'text', 'Time Days', 'Time Days', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'time_hour', 'lyt_epa_data_2', 2, 'integer', 'text', 'Time Hour', 'Time Hour', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'max_veloc', 'lyt_epa_data_2', 3, 'double', 'text', 'Maximum Velocity', 'Maximum Velocity', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'mfull_flow', 'lyt_epa_data_2', 4, 'double', 'text', 'Full Flow', 'Full Flow', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'mfull_dept', 'lyt_epa_data_2', 5, 'double', 'text', 'Full Depth', 'Full Depth', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'max_shear', 'lyt_epa_data_2', 6, 'double', 'text', 'Maximum Shear', 'Maximum Shear', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'max_hr', 'lyt_epa_data_2', 7, 'double', 'text', 'Maximum Hydraulic Radius', 'Maximum Hydraulic Radius', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'max_slope', 'lyt_epa_data_2', 8, 'double', 'text', 'Maximum Slope', 'Maximum Slope', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'day_max', 'lyt_epa_data_2', 9, 'integer', 'text', 'Day Maximum', 'Day Maximum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'time_max', 'lyt_epa_data_2', 10, 'integer', 'text', 'Time Maximum', 'Time Maximum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'min_shear', 'lyt_epa_data_2', 11, 'double', 'text', 'Minimum Shear', 'Minimum Shear', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'day_min', 'lyt_epa_data_2', 12, 'integer', 'text', 'Day Minimum', 'Day Minimum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'time_min', 'lyt_epa_data_2', 13, 'integer', 'text', 'Time Minimum', 'Time Minimum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}'::json WHERE formname='gully' AND formtype='form_feature' AND columnname='tbl_elements' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}'::json WHERE formname='gully' AND formtype='form_feature' AND columnname='open_element' AND tabname='tab_elements';

-- 05/06/2025
UPDATE config_form_fields SET "label"='Maximum Pipe diameter:', tooltip='Maximum Pipe diameter' WHERE formname='generic' AND formtype='link_to_gully' AND columnname='pipe_diameter' AND tabname='tab_none';

-- Massive update cause dma_id dissapears on ud projects
UPDATE config_form_fields SET columnname = 'omzone_id', label = 'omzone', tooltip = 'omzone_id' WHERE columnname = 'dma_id';

UPDATE config_form_tabs SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionSetGeom",
    "disabled": false
  }
]'::json WHERE formname='ve_frelem' AND tabname='tab_data';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {}
}'::json WHERE formname='gully' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';
--05/06/2025

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3702, 'New scenario type %v_type% with name ''%v_name%'' and id ''%v_scenarioid%'' have been created.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3704, 'INFO: %v_count% features have been inserted on table %v_targettable%.', null, 0, true, 'utils', 'core', 'AUDIT');



-- 09/06/2025
ALTER TABLE cat_feature DISABLE TRIGGER gw_trg_cat_feature_after;

INSERT INTO sys_feature_class (id, type, epa_default, man_table) VALUES ('VLINK', 'LINK', 'VIRTUAL', 'man_vlink');
INSERT INTO sys_feature_class (id, type, epa_default, man_table) VALUES ('VGULLY', 'GULLY', 'VIRTUAL', 'man_vgully');
INSERT INTO sys_feature_class (id, type, epa_default, man_table) VALUES ('VCONNEC', 'CONNEC', 'VIRTUAL', 'man_vconnec');
UPDATE sys_feature_class SET id = 'CONDUITLINK', man_table = 'man_conduitlink' WHERE id = 'LINK';
UPDATE sys_feature_class SET id = 'CJOIN', man_table = 'man_cjoin' WHERE id = 'CONNEC';
UPDATE sys_feature_class SET id = 'GINLET', man_table = 'man_ginlet' WHERE id = 'GULLY';

INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, descript, active) VALUES ('VLINK', 'VLINK', 'LINK', 'v_edit_link', 've_link_vlink', 'Virtual link', true);

UPDATE cat_feature SET id = 'CONDUITLINK', child_layer = 've_link_conduitlink' WHERE id = 'LINK';
UPDATE cat_feature SET id = 'CJOIN', child_layer = 've_connec_cjoin' WHERE id = 'CONNEC';
UPDATE cat_feature SET id = 'GINLET', child_layer = 've_gully_ginlet' WHERE id = 'GULLY';

INSERT INTO cat_feature_link (id) VALUES ('VLINK');

UPDATE cat_feature SET feature_class = 'VCONNEC', feature_type = 'CONNEC', id = 'VCONNEC' WHERE id = 'VCONNEC';
UPDATE cat_feature SET feature_class = 'VGULLY', feature_type = 'GULLY', id = 'VGULLY' WHERE id = 'VGULLY';


ALTER TABLE cat_feature ENABLE TRIGGER gw_trg_cat_feature_after;

-- Update sys_table context syntax and update config_typevalue references
DO $$
DECLARE
  level_values text[];
  output_json jsonb;
	layer record;
BEGIN

	FOR layer IN (SELECT * FROM config_typevalue WHERE typevalue = 'sys_table_context')
	LOOP
    -- Extract values of keys starting with 'level_' into an array
    IF layer.id::text NOT LIKE '{"levels":%}' THEN
      level_values := ARRAY(
          SELECT value::text
          FROM jsonb_each_text(layer.id::jsonb)
          WHERE key LIKE 'level_%'
          ORDER BY key
      );

      -- Build the resulting JSON
      output_json := jsonb_build_object('levels', level_values);

    UPDATE config_typevalue SET id = output_json WHERE id = layer.id AND typevalue = 'sys_table_context';
  END IF;

	END LOOP;
END
$$;


DO $$
DECLARE
  level_values text[];
  output_json jsonb;
	layer record;
BEGIN

	FOR layer IN (select * from sys_table where context is not null)
	LOOP
    IF layer.context::text NOT LIKE '{"levels":%}' THEN
      -- Extract values of keys starting with 'level_' into an array
      level_values := ARRAY(
          SELECT value::text
          FROM jsonb_each_text(layer.context::jsonb)
          WHERE key LIKE 'level_%'
          ORDER BY key
      );

      -- Build the resulting JSON
      output_json := jsonb_build_object('levels', level_values);

      UPDATE sys_table set context = output_json where id = layer.id;
    END IF;
	END LOOP;
END
$$;

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('config_typevalue', 'sys_table_context', 'sys_table', 'context', NULL, true);

UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_cat_feature_gully';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_drainzone';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_exploitation';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 3}'::jsonb WHERE id='ve_pol_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_ext_streetaxis';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_cat_feature_arc';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_cat_feature_connec';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias='Node' WHERE id='v_edit_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_material';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias='Municipality', orderBy = 1, context='{"levels": ["BASEMAP", "ADDRESS"]}' WHERE id='v_ext_municipality';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 3}'::jsonb WHERE id='ve_pol_gully';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_gully';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias='Link' WHERE id='v_edit_link';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_dwfzone';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias='Gully' WHERE id='v_edit_gully';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_sector';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_macrosector';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 3}'::jsonb WHERE id='ve_pol_connec';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_dimensions';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_ext_address';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_ext_plot';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias='Connec' WHERE id='v_edit_connec';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias='Arc' WHERE id='v_edit_arc';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_arc';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_cat_feature_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_connec';

UPDATE sys_style SET layername='v_ext_municipality' WHERE layername='ext_municipality' AND styleconfig_id=101;

DELETE FROM sys_table WHERE id = 'v_edit_link_connec';
DELETE FROM sys_table WHERE id = 'v_edit_link_gully';
DELETE FROM sys_table WHERE id = 've_link_link';

UPDATE config_typevalue SET addparam='{"orderBy":6}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "POLYGON"]}';
UPDATE config_typevalue SET addparam='{"orderBy":5}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "LINK"]}';
UPDATE config_typevalue SET addparam='{"orderBy":2}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "ARC"]}';
UPDATE config_typevalue SET addparam='{"orderBy":3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "CONNEC"]}';
UPDATE config_typevalue SET addparam='{"orderBy":4}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "GULLY"]}';
UPDATE config_typevalue SET addparam='{"orderBy":1}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "NODE"]}';

-- 19/06/2025
UPDATE config_form_fields SET ismandatory=false, iseditable=false WHERE formname = 'v_edit_arc' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false, iseditable=false WHERE formname ILIKE 've_arc%' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false, iseditable=false WHERE formname = 'v_edit_node' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false, iseditable=false WHERE formname ILIKE 've_node%' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true, iseditable=true WHERE formname = 'v_edit_connec' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true, iseditable=true WHERE formname ILIKE 've_connec%' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true, iseditable=true WHERE formname='v_edit_gully' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true, iseditable=true WHERE formname ILIKE 've_gully%' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Explotation ID', 'expl_id - Exploitation to which the element belongs. If the configuration is not changed, the program automatically selects it based on the geometry', NULL, false, false, false, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{
  "setMultiline": false,
  "labelPosition": "top",
  "valueRelation": {
    "nullValue": false,
    "layer": "v_edit_exploitation",
    "activated": true,
    "keyColumn": "expl_id",
    "valueColumn": "name",
    "filterExpression": null
  }
}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 2, 'integer', 'combo', 'Sector ID', 'sector_id  - Sector identifier.', NULL, false, false, false, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'dqa_id', 'lyt_bot_1', 3, 'integer', 'text', 'Dqa', 'dqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 4, 'integer', 'combo', 'State:', 'State:', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 5, 'integer', 'combo', 'State type', 'state_type - The state type of the element. It allows to obtain more detail of the state. To select from those available depending on the chosen state', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, 'state', ' AND value_state_type.state', NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'link_id', 'lyt_data_1', 1, 'integer', 'text', 'Link ID', 'Link ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'feature_type', 'lyt_data_1', 2, 'string', 'combo', 'Feature type', 'Feature type', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'feature_id', 'lyt_data_1', 3, 'string', 'text', 'feature_id', 'feature_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'exit_type', 'lyt_data_1', 4, 'string', 'combo', 'Exit type', 'Exit type', NULL, false, false, false, false, NULL, 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'exit_id', 'lyt_data_1', 5, 'string', 'text', 'Exit ID', 'Exit ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'omzone_id', 'lyt_data_1', 6, 'integer', 'combo', 'Omzone ID', 'Omzone ID', NULL, false, false, false, false, NULL, 'SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id = 0 UNION SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'presszone_id', 'lyt_data_1', 7, 'integer', 'text', 'Presszone', 'presszone_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'minsector_id', 'lyt_data_1', 8, 'integer', 'text', 'minsector_id', 'minsector_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'fluid_type', 'lyt_data_1', 9, 'string', 'text', 'fluid_type', 'fluid_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'gis_length', 'lyt_data_1', 10, 'double', 'text', 'Gis length', 'Gis length', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'sector_name', 'lyt_data_1', 11, 'string', 'text', 'sector_name', 'sector_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'dma_name', 'lyt_data_1', 12, 'string', 'text', 'dma_name', 'dma_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'dqa_name', 'lyt_data_1', 13, 'string', 'text', 'dqa_name', 'dqa_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'presszone_name', 'lyt_data_1', 14, 'string', 'text', 'presszone_name', 'presszone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'macroomzone_id', 'lyt_data_1', 15, 'integer', 'text', 'Macroomzone ID', 'Macroomzone ID', NULL, false, false, false, false, NULL, 'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'macrosector_id', 'lyt_data_1', 16, 'integer', 'combo', 'Macrosector id', 'Macrosector id', NULL, false, false, false, false, NULL, 'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'macrodqa_id', 'lyt_data_2', 1, 'integer', 'text', 'macrodqa_id', 'macrodqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'epa_type', 'lyt_data_2', 2, 'string', 'text', 'epa_type', 'epa_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'is_operative', 'lyt_data_2', 3, 'boolean', 'check', 'is_operative', 'is_operative', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'conneccat_id', 'lyt_data_2', 4, 'string', 'typeahead', 'Connecat ID', 'connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ', true, NULL, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, 'action_catalog', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_2', 5, 'string', 'typeahead', 'Workcat ID', 'workcat_id - Related to the catalog of work files (cat_work). File that registers the element', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_2', 6, 'string', 'typeahead', 'Workcat ID end', 'workcat_id_end - ID of the  end of construction work.', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_2', 7, 'date', 'datetime', 'Builtdate:', 'builtdate - Date the element was added. In insertion of new elements the date of the day is shown', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'enddate', 'lyt_data_2', 8, 'date', 'datetime', 'Enddate', 'enddate - End date of the element. It will only be filled in if the element is in a deregistration state.', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'uncertain', 'lyt_data_2', 9, 'boolean', 'check', 'Uncertain', 'uncertain - To set if the element''s location is uncertain', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'top_elev1', 'lyt_data_2', 10, 'integer', 'text', 'Top Elev 1', 'top_elev1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'depth1', 'lyt_data_2', 11, 'integer', 'text', 'Depth1', 'depth1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'elevation1', 'lyt_data_2', 12, 'integer', 'text', 'Elevation1', 'elevation1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'top_elev2', 'lyt_data_2', 13, 'integer', 'text', 'Top elev 2', 'top_elev2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'depth2', 'lyt_data_2', 14, 'integer', 'text', 'Depth2', 'depth2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'elevation2', 'lyt_data_2', 15, 'integer', 'text', 'Elevation2', 'elevation2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'date_to', 'lyt_document_1', 2, 'date', 'datetime', 'Date to:', 'Date to:', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":"<="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'doc_type', 'lyt_document_1', 3, 'string', 'combo', 'Doc type:', 'Doc type:', NULL, false, false, true, false, true, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_link', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'doc_name', 'lyt_document_2', 1, 'string', 'typeahead', 'Doc id:', 'Doc id:', NULL, false, false, true, false, false, 'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table"}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'btn_doc_insert', 'lyt_document_2', 2, NULL, 'button', NULL, 'Insert document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'btn_doc_delete', 'lyt_document_2', 3, NULL, 'button', NULL, 'Delete document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json, '{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'btn_doc_new', 'lyt_document_2', 4, NULL, 'button', NULL, 'New document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'hspacer_document_1', 'lyt_document_2', 5, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'open_doc', 'lyt_document_2', 6, NULL, 'button', NULL, 'Open document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"147"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'tbl_documents', 'lyt_document_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json, 'tbl_doc_x_link', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_elements', 'element_id', 'lyt_element_1', 1, 'string', 'typeahead', 'Element id:', 'Element id', NULL, false, false, true, false, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_elements', 'insert_element', 'lyt_element_1', 2, NULL, 'button', NULL, 'Insert element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
	  "functionName": "add_object",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_elements', 'delete_element', 'lyt_element_1', 3, NULL, 'button', NULL, 'Delete element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}'::json, '{ "functionName": "delete_object", "parameters": {"columnfind": "element_id", "targetwidget": "tab_elements_tbl_elements", "sourceview": "element"}}'::json, 'tbl_element_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_elements', 'new_element', 'lyt_element_1', 4, NULL, 'button', NULL, 'New element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_arc",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_elements', 'hspacer_lyt_element', 'lyt_element_1', 5, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_elements', 'open_element', 'lyt_element_1', 6, NULL, 'button', NULL, 'Open element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"144"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}'::json, '{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_elements', 'btn_link', 'lyt_element_1', 7, NULL, 'button', NULL, 'Open link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"173"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_elements_tbl_elements",
    "columnfind": "link_id"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_elements', 'tbl_elements', 'lyt_element_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}'::json, 'tbl_element_x_link', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'linkcat_id', 'lyt_top_1', 2, 'string', 'typeahead', 'Linkcat ID', 'linkcat_id - To be selected from the catalog of arcs. It is independent of the type of arch', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, 'link_type', ' AND cat_link.link_type IS NULL OR cat_link.link_type', NULL, '{
  "setMultiline": false,
  "labelPosition": "top",
  "valueRelation": {
    "layer": "cat_link",
    "activated": true,
    "keyColumn": "id",
    "nullValue": false,
    "valueColumn": "id",
    "filterExpression": null
  }
}'::json, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'link_type', 'lyt_top_1', 1, 'string', 'combo', 'Link Type', 'Type of link. It is auto-populated based on the linkcat_id', NULL, true, true, false, false, NULL, 'SELECT id, id as idval FROM cat_feature_link WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "v_edit_cat_feature_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Explotation ID', 'expl_id - Exploitation to which the element belongs. If the configuration is not changed, the program automatically selects it based on the geometry', NULL, false, false, false, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{
  "setMultiline": false,
  "labelPosition": "top",
  "valueRelation": {
    "nullValue": false,
    "layer": "v_edit_exploitation",
    "activated": true,
    "keyColumn": "expl_id",
    "valueColumn": "name",
    "filterExpression": null
  }
}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 2, 'integer', 'combo', 'Sector ID', 'sector_id  - Sector identifier.', NULL, false, false, false, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'dqa_id', 'lyt_bot_1', 3, 'integer', 'text', 'Dqa', 'dqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 4, 'integer', 'combo', 'State:', 'State:', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 5, 'integer', 'combo', 'State type', 'state_type - The state type of the element. It allows to obtain more detail of the state. To select from those available depending on the chosen state', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, 'state', ' AND value_state_type.state', NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'link_id', 'lyt_data_1', 1, 'integer', 'text', 'Link ID', 'Link ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'feature_type', 'lyt_data_1', 2, 'string', 'combo', 'Feature type', 'Feature type', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'feature_id', 'lyt_data_1', 3, 'string', 'text', 'feature_id', 'feature_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'exit_type', 'lyt_data_1', 4, 'string', 'combo', 'Exit type', 'Exit type', NULL, false, false, false, false, NULL, 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'exit_id', 'lyt_data_1', 5, 'string', 'text', 'Exit ID', 'Exit ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'omzone_id', 'lyt_data_1', 6, 'integer', 'combo', 'Omzone ID', 'Omzone ID', NULL, false, false, false, false, NULL, 'SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id = 0 UNION SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'presszone_id', 'lyt_data_1', 7, 'integer', 'text', 'Presszone', 'presszone_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'minsector_id', 'lyt_data_1', 8, 'integer', 'text', 'minsector_id', 'minsector_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'fluid_type', 'lyt_data_1', 9, 'string', 'text', 'fluid_type', 'fluid_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'gis_length', 'lyt_data_1', 10, 'double', 'text', 'Gis length', 'Gis length', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'sector_name', 'lyt_data_1', 11, 'string', 'text', 'sector_name', 'sector_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'dma_name', 'lyt_data_1', 12, 'string', 'text', 'dma_name', 'dma_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'dqa_name', 'lyt_data_1', 13, 'string', 'text', 'dqa_name', 'dqa_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'presszone_name', 'lyt_data_1', 14, 'string', 'text', 'presszone_name', 'presszone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'macroomzone_id', 'lyt_data_1', 15, 'integer', 'text', 'Macroomzone ID', 'Macroomzone ID', NULL, false, false, false, false, NULL, 'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'macrosector_id', 'lyt_data_1', 16, 'integer', 'combo', 'Macrosector id', 'Macrosector id', NULL, false, false, false, false, NULL, 'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'macrodqa_id', 'lyt_data_2', 1, 'integer', 'text', 'macrodqa_id', 'macrodqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'epa_type', 'lyt_data_2', 2, 'string', 'text', 'epa_type', 'epa_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'is_operative', 'lyt_data_2', 3, 'boolean', 'check', 'is_operative', 'is_operative', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'conneccat_id', 'lyt_data_2', 4, 'string', 'typeahead', 'Connecat ID', 'connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ', true, NULL, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, 'action_catalog', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_2', 5, 'string', 'typeahead', 'Workcat ID', 'workcat_id - Related to the catalog of work files (cat_work). File that registers the element', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_2', 6, 'string', 'typeahead', 'Workcat ID end', 'workcat_id_end - ID of the  end of construction work.', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_2', 7, 'date', 'datetime', 'Builtdate:', 'builtdate - Date the element was added. In insertion of new elements the date of the day is shown', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'enddate', 'lyt_data_2', 8, 'date', 'datetime', 'Enddate', 'enddate - End date of the element. It will only be filled in if the element is in a deregistration state.', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'uncertain', 'lyt_data_2', 9, 'boolean', 'check', 'Uncertain', 'uncertain - To set if the element''s location is uncertain', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'top_elev1', 'lyt_data_2', 10, 'integer', 'text', 'Top Elev 1', 'top_elev1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'depth1', 'lyt_data_2', 11, 'integer', 'text', 'Depth1', 'depth1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'elevation1', 'lyt_data_2', 12, 'integer', 'text', 'Elevation1', 'elevation1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'top_elev2', 'lyt_data_2', 13, 'integer', 'text', 'Top elev 2', 'top_elev2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'depth2', 'lyt_data_2', 14, 'integer', 'text', 'Depth2', 'depth2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'elevation2', 'lyt_data_2', 15, 'integer', 'text', 'Elevation2', 'elevation2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'date_to', 'lyt_document_1', 2, 'date', 'datetime', 'Date to:', 'Date to:', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":"<="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'doc_type', 'lyt_document_1', 3, 'string', 'combo', 'Doc type:', 'Doc type:', NULL, false, false, true, false, true, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_link', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'doc_name', 'lyt_document_2', 1, 'string', 'typeahead', 'Doc id:', 'Doc id:', NULL, false, false, true, false, false, 'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table"}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'btn_doc_insert', 'lyt_document_2', 2, NULL, 'button', NULL, 'Insert document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'btn_doc_delete', 'lyt_document_2', 3, NULL, 'button', NULL, 'Delete document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json, '{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'btn_doc_new', 'lyt_document_2', 4, NULL, 'button', NULL, 'New document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'hspacer_document_1', 'lyt_document_2', 5, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'open_doc', 'lyt_document_2', 6, NULL, 'button', NULL, 'Open document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"147"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'tbl_documents', 'lyt_document_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json, 'tbl_doc_x_link', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'element_id', 'lyt_element_1', 1, 'string', 'typeahead', 'Element id:', 'Element id', NULL, false, false, true, false, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'insert_element', 'lyt_element_1', 2, NULL, 'button', NULL, 'Insert element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
	  "functionName": "add_object",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'delete_element', 'lyt_element_1', 3, NULL, 'button', NULL, 'Delete element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}'::json, '{ "functionName": "delete_object", "parameters": {"columnfind": "element_id", "targetwidget": "tab_elements_tbl_elements", "sourceview": "element"}}'::json, 'tbl_element_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'new_element', 'lyt_element_1', 4, NULL, 'button', NULL, 'New element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_arc",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'hspacer_lyt_element', 'lyt_element_1', 5, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'open_element', 'lyt_element_1', 6, NULL, 'button', NULL, 'Open element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"144"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}'::json, '{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'btn_link', 'lyt_element_1', 7, NULL, 'button', NULL, 'Open link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"173"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_elements_tbl_elements",
    "columnfind": "link_id"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'tbl_elements', 'lyt_element_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}'::json, 'tbl_element_x_link', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'linkcat_id', 'lyt_top_1', 2, 'string', 'typeahead', 'Linkcat ID', 'linkcat_id - To be selected from the catalog of arcs. It is independent of the type of arch', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, 'link_type', ' AND cat_link.link_type IS NULL OR cat_link.link_type', NULL, '{
  "setMultiline": false,
  "labelPosition": "top",
  "valueRelation": {
    "layer": "cat_link",
    "activated": true,
    "keyColumn": "id",
    "nullValue": false,
    "valueColumn": "id",
    "filterExpression": null
  }
}'::json, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'link_type', 'lyt_top_1', 1, 'string', 'combo', 'Link Type', 'Type of link. It is auto-populated based on the linkcat_id', NULL, true, true, false, false, NULL, 'SELECT id, id as idval FROM cat_feature_link WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "v_edit_cat_feature_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 2);

--25/06/2025

UPDATE sys_function SET function_alias = 'ARC ELEVATION ANALYSIS' WHERE function_name = 'gw_fct_anl_arc_elev';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3960, 'There are no arcs with both values of y and elev inserted.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3962, 'There are %v_count% arcs with both values of y and elev inserted.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'ARC INTERSECTION ANALYSIS' WHERE function_name = 'gw_fct_anl_arc_intersection';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3964, 'There are no intersected arcs.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3966, 'There are %v_count% intersected arcs.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'ARC INVERTED ANALYSIS' WHERE function_name = 'gw_fct_anl_arc_inverted';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3968, 'The analysis have been executed skipping arcs with TRUE value on ''inverted_slope'' column', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3970, 'If some resultant arc is really an arc with inverted slope, please set this value to TRUE', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'OUTFALL NODE ANALYSIS' WHERE function_name = 'gw_fct_anl_node_sink';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3972, 'The analysis have been executed skipping nodes with ''VERIFIED'' on colum verified', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3974, 'If you are looking to remove results please set column verified with this value', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'NODE ELEVATION ANALYSIS' WHERE function_name = 'gw_fct_anl_node_elev';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3976, 'There are no nodes with all values of top_elev, ymax and elev inserted.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3978, 'There are %v_count% nodes with all values of top_elev, ymax and elev inserted.', null, 0, true, 'utils', 'core', 'AUDIT');

--26/06/2025

UPDATE sys_function SET function_alias = 'NODE FLOW REGULATOR ANALYSIS' WHERE function_name = 'gw_fct_anl_node_flowregulator';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3980, 'The analysis have been executed skipping nodes with ''VERIFIED'' on colum verified', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'NODE WITH EXIT ARC OVER ENTRY ARC ANALYSIS' WHERE function_name = 'gw_fct_anl_node_exit_upper_intro';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3982, 'There are no flow regulator nodes.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3984, 'There are %v_count% flow regulator nodes.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3986, 'There are no nodes with exit arc over entry arc.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3988, 'There are %v_count% nodes with exit arc over entry arc.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'SECTION CONTROL ANALYSIS' WHERE function_name = 'gw_graphanalytics_upstream_section_control';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3990, 'In order to execute the process you need to specify starting node_id.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3992, 'You can use outfalls without doing it and execute the process for the entire layer.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3994, 'Node %v_node_id% does''t exist in the selected layer.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3996, 'Choose another node to continue.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3998, 'There are no arcs with unconsistent sections.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4000, 'There are %v_count% arcs with section (geom1) bigger than the section of the following arc.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'SLOPE CONSISTENCY ANALYSIS' WHERE function_name = 'gw_fct_anl_slope_consistency';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4002, 'There are no slope inconsistencies.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4004, 'There are %v_count% arcs with slope inconsistency.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'HYDRAULIC PERFORMANCE FOR SPECIFIC RESULT' WHERE function_name = 'gw_fct_epa_hydraulic_performance';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4006, 'Result_id: %v_eparesult%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4008, 'WWTP outfall_id''s: %v_wwtpoutfalls%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4010, 'Total precipitation volume: %v_rain%  10^6 LTS', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4012, 'Total DWF volume: %v_dwf%  10^6 LTS', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4014, 'Total infil.losses volume: %v_inf%  10^6 LTS', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4016, 'Total WWTP volume: %v_wwtp%  10^6 LTS', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4018, 'Hydraulic performance for this result: %(100*v_performance)::numeric(12,2)% %', null, 0, true, 'utils', 'core', 'AUDIT');
