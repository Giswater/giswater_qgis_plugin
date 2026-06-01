/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TABLE IF EXISTS flwreg CASCADE;
DROP TABLE IF EXISTS cat_flwreg CASCADE;

CREATE TABLE man_link (
	link_id int4 NOT NULL,
	CONSTRAINT man_link_pkey PRIMARY KEY (link_id),
	CONSTRAINT man_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE sys_feature_class DROP CONSTRAINT sys_feature_cat_check;
DELETE FROM sys_feature_class WHERE id = 'LINK';
DELETE FROM sys_feature_class WHERE type = 'FLWREG';

CREATE TABLE cat_feature_link (
	id varchar(30) NOT NULL,
	CONSTRAINT cat_feature_link_pkey PRIMARY KEY (id),
	CONSTRAINT cat_feature_link_fkey FOREIGN KEY (id) REFERENCES cat_feature(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE cat_link (
	id varchar(30) NOT NULL,
	link_type varchar(30) NOT NULL,
	matcat_id varchar(30) NULL,
	pnom varchar(16) NULL,
	dnom varchar(16) NULL,
	dint numeric(12, 5) NULL,
	dext numeric(12, 5) NULL,
	descript varchar(512) NULL,
	link varchar(512) NULL,
	brand_id varchar(50) NULL,
	model_id varchar(50) NULL,
	svg varchar(50) NULL,
	z1 numeric(12, 2) NULL,
	z2 numeric(12, 2) NULL,
	width numeric(12, 2) NULL,
	area numeric(12, 4) NULL,
	estimated_depth numeric(12, 2) NULL,
	thickness numeric(12, 2) NULL,
	cost_unit varchar(3) DEFAULT 'm'::character varying NULL,
	"cost" varchar(16) NULL,
	m2bottom_cost varchar(16) NULL,
	m3protec_cost varchar(16) NULL,
	active bool DEFAULT true NULL,
	"label" varchar(255) NULL,
	CONSTRAINT cat_link_pkey PRIMARY KEY (id),
	CONSTRAINT cat_link_linktype_fkey FOREIGN KEY (link_type) REFERENCES cat_feature_link(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_link_brand_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_link_cost_fkey FOREIGN KEY ("cost") REFERENCES plan_price(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_link_m2bottom_cost_fkey FOREIGN KEY (m2bottom_cost) REFERENCES plan_price(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_link_m3protec_cost_fkey FOREIGN KEY (m3protec_cost) REFERENCES plan_price(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_link_model_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX cat_link_cost_pkey ON cat_link USING btree (cost);
CREATE INDEX cat_link_m2bottom_cost_pkey ON cat_link USING btree (m2bottom_cost);
CREATE INDEX cat_link_m3protec_cost_pkey ON cat_link USING btree (m3protec_cost);

ALTER TABLE link DROP CONSTRAINT link_linkcat_id_fkey;
ALTER TABLE link ADD CONSTRAINT link_linkcat_id_fkey FOREIGN KEY (linkcat_id) REFERENCES cat_link(id) ON DELETE RESTRICT ON UPDATE CASCADE;



CREATE TABLE man_genelem (
    element_id int4 NOT NULL,
    CONSTRAINT man_genelem_pkey PRIMARY KEY (element_id),
	CONSTRAINT man_genelem_fkey_element_id FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE man_frelem (
    element_id int4 NOT NULL,
    node_id int4 NULL,
    order_id numeric NULL,
    to_arc int4 NULL,
    flwreg_length numeric NULL,
    CONSTRAINT man_frelem_pkey PRIMARY KEY (element_id),
	CONSTRAINT man_frelem_fkey_element_id FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT man_frelem_fkey_to_arc FOREIGN KEY (to_arc) REFERENCES arc(arc_id) ON UPDATE RESTRICT ON DELETE CASCADE
);

CREATE TABLE cat_feature_element (
    id varchar(30) NOT NULL,
    epa_default varchar(30) NOT NULL,
    CONSTRAINT cat_feature_element_pkey PRIMARY KEY (id),
    CONSTRAINT cat_feature_element_fkey_element_id FOREIGN KEY (id) REFERENCES cat_feature(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT cat_feature_element_inp_check CHECK (epa_default::text = ANY (ARRAY['ORIFICE'::text, 'WEIR'::text, 'OUTLET'::text, 'PUMP'::text, 'UNDEFINED'::text]))
);

INSERT INTO man_genelem (element_id) SELECT element_id FROM element;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_node", "column":"omzone_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_arc", "column":"omzone_id", "dataType":"integer", "isUtils":"False"}}$$);

UPDATE config_form_fields
SET layoutname='lyt_document_1', layoutorder=3, "datatype"='string', widgettype='combo', "label"='Doc type:', tooltip='Doc type:', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=true, dv_querytext='SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''', dv_orderby_id=NULL, dv_isnullvalue=true, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"labelPosition": "top"}'::json, widgetfunction='{"functionName": "filter_table", "parameters":{}}'::json, linkedobject='tbl_doc_x_node', hidden=false, web_layoutorder=3
WHERE formname='node' AND formtype='form_feature' AND columnname='doc_type' AND tabname='tab_documents';
UPDATE config_form_fields
SET layoutname='lyt_document_1', layoutorder=3, "datatype"='string', widgettype='combo', "label"='Doc type:', tooltip='Doc type:', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=true, dv_querytext='SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''', dv_orderby_id=NULL, dv_isnullvalue=true, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"labelPosition": "top"}'::json, widgetfunction='{"functionName": "filter_table", "parameters":{}}'::json, linkedobject='tbl_doc_x_connec', hidden=false, web_layoutorder=3
WHERE formname='connec' AND formtype='form_feature' AND columnname='doc_type' AND tabname='tab_documents';
UPDATE config_form_fields
SET layoutname='lyt_document_1', layoutorder=3, "datatype"='string', widgettype='combo', "label"='Doc type:', tooltip=NULL, placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=true, dv_querytext='SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''', dv_orderby_id=NULL, dv_isnullvalue=true, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"labelPosition": "top"}'::json, widgetfunction='{"functionName": "filter_table", "parameters":{}}'::json, linkedobject='tbl_doc_x_link', hidden=false, web_layoutorder=3
WHERE formname='v_edit_link' AND formtype='form_feature' AND columnname='doc_type' AND tabname='tab_documents';
UPDATE config_form_fields
SET layoutname='lyt_document_1', layoutorder=3, "datatype"='string', widgettype='combo', "label"='Doc type:', tooltip=NULL, placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=true, dv_querytext='SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''', dv_orderby_id=NULL, dv_isnullvalue=true, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"labelPosition": "top"}'::json, widgetfunction='{"functionName": "filter_table", "parameters":{}}'::json, linkedobject='tbl_doc_x_link', hidden=false, web_layoutorder=3
WHERE formname='ve_link_link' AND formtype='form_feature' AND columnname='doc_type' AND tabname='tab_documents';
UPDATE config_form_fields
SET layoutname='lyt_document_1', layoutorder=3, "datatype"='string', widgettype='combo', "label"='Doc type:', tooltip='Doc type:', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=true, dv_querytext='SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''', dv_orderby_id=NULL, dv_isnullvalue=true, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"labelPosition": "top"}'::json, widgetfunction='{"functionName": "filter_table", "parameters":{}}'::json, linkedobject='tbl_doc_x_arc', hidden=false, web_layoutorder=3
WHERE formname='arc' AND formtype='form_feature' AND columnname='doc_type' AND tabname='tab_documents';
UPDATE config_form_fields
SET layoutname='lyt_document_1', layoutorder=3, "datatype"='string', widgettype='combo', "label"='Doc type:', tooltip='Doc type:', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=true, dv_querytext='SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''', dv_orderby_id=NULL, dv_isnullvalue=true, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"labelPosition": "top"}'::json, widgetfunction='{"functionName": "filter_table", "parameters":{}}'::json, linkedobject='tbl_doc_x_gully', hidden=false, web_layoutorder=3
WHERE formname='gully' AND formtype='form_feature' AND columnname='doc_type' AND tabname='tab_documents';


INSERT INTO edit_typevalue (typevalue, id, idval, descript)
SELECT 'doc_type', id, id, comment
FROM doc_type;

ALTER TABLE doc DROP CONSTRAINT IF EXISTS doc_doc_type_fkey;

DROP TABLE IF EXISTS doc_type;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_arc_traceability", "column":"undelete"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_connec_traceability", "column":"undelete"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_gully_traceability", "column":"undelete"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_node_traceability", "column":"undelete"}}$$);


CREATE TABLE doc_x_element (
	doc_id varchar(30) NOT NULL,
	element_id int4 NOT NULL,
	CONSTRAINT doc_x_element_pkey PRIMARY KEY (doc_id, element_id),
	CONSTRAINT doc_x_element_fkey_doc_id FOREIGN KEY (doc_id) REFERENCES doc(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT doc_x_element_fkey_element_id FOREIGN KEY (element_id) REFERENCES element(element_id) ON DELETE CASCADE ON UPDATE CASCADE
);



SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_arc_traceability", "column":"expl_visibility", "dataType":"int[]"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_connec_traceability", "column":"expl_visibility", "dataType":"int[]"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_node_traceability", "column":"expl_visibility", "dataType":"int[]"}}$$);

UPDATE archived_psector_arc_traceability SET expl_visibility = ARRAY[expl_id];
UPDATE archived_psector_connec_traceability SET expl_visibility = ARRAY[expl_id];
UPDATE archived_psector_node_traceability SET expl_visibility = ARRAY[expl_id];

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_arc_traceability", "column":"expl_id2"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_connec_traceability", "column":"expl_id2"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_node_traceability", "column":"expl_id2"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector", "column":"creation_date", "dataType":"date"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"exploitation", "column":"owner_vdefault", "dataType":"varchar(30)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_feature", "column":"inventory_vdefault", "dataType":"boolean"}}$$);


CREATE TABLE sys_label (
	id integer PRIMARY KEY,
	idval text NOT NULL,
	label_type text
);

ALTER TABLE dimensions ALTER COLUMN muni_id SET DEFAULT 0;

CREATE TABLE minsector_mincut (
    minsector_id int4 NOT NULL,
    mincut_minsector_id int4 NOT NULL,
    CONSTRAINT minsector_mincut_pkey PRIMARY KEY (minsector_id, mincut_minsector_id),
    CONSTRAINT minsector_mincut_minsector_id_fkey FOREIGN KEY (minsector_id) REFERENCES minsector(minsector_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT minsector_mincut_mincut_minsector_id_fkey FOREIGN KEY (mincut_minsector_id) REFERENCES minsector(minsector_id) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE node_add ALTER COLUMN node_id TYPE int4 USING node_id::int4;
ALTER TABLE node_add ADD CONSTRAINT node_add_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE arc_add ALTER COLUMN arc_id TYPE int4 USING arc_id::int4;
ALTER TABLE arc_add ADD CONSTRAINT arc_add_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON DELETE CASCADE ON UPDATE CASCADE;


UPDATE sys_table SET criticity = NULL;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"sys_table", "column":"criticity", "newName":"project_template"}}$$);
ALTER TABLE sys_table ALTER COLUMN project_template TYPE integer[] USING ARRAY[project_template];
UPDATE sys_table SET project_template = NULL;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_function", "column":"function_alias", "dataType":"text"}}$$);

ALTER TABLE element_type RENAME TO _element_type;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"audit_check_data", "column":"result_id", "dataType":"varchar(50)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_node_traceability", "column":"macrominsector_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_arc_traceability", "column":"macrominsector_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_connec_traceability", "column":"macrominsector_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_gully_traceability", "column":"macrominsector_id"}}$$);

DELETE FROM config_toolbox WHERE id=3336;
DELETE FROM sys_function WHERE id=3336; -- gw_fct_graphanalytics_macrominsector

-- Update sys_table project_template to jsonb
DO $$
DECLARE
	roww record;
	layers text[] := ARRAY[]::text[];
	item text;
BEGIN

	FOR roww IN (SELECT * FROM sys_table WHERE project_template IS NOT NULL)
	LOOP
		IF 1 = ANY(roww.project_template) THEN
			layers := layers || roww.id;
		END IF;
	END LOOP;

	ALTER TABLE sys_table ALTER COLUMN project_template TYPE jsonb USING to_jsonb(project_template);

	FOREACH item IN ARRAY layers
	LOOP
		UPDATE sys_table SET project_template = '{"template": [1]}'::jsonb WHERE id = item;
	END LOOP;
END
$$;


DROP VIEW IF EXISTS vp_basic_arc;
DROP VIEW IF EXISTS vp_basic_node;
DROP VIEW IF EXISTS vp_basic_connec;
DROP VIEW IF EXISTS vp_basic_gully;

DROP VIEW IF EXISTS v_edit_exploitation;
DROP VIEW IF EXISTS v_edit_macrodqa;
DROP VIEW IF EXISTS v_edit_macrodma;
DROP VIEW IF EXISTS v_edit_macrosector;
DROP VIEW IF EXISTS v_edit_sector;
DROP VIEW IF EXISTS v_ui_sector;

DROP VIEW IF EXISTS v_state_element;
DROP VIEW IF EXISTS v_state_arc;
DROP VIEW IF EXISTS v_state_node;
DROP VIEW IF EXISTS v_state_connec;
DROP VIEW IF EXISTS v_state_link;
DROP VIEW IF EXISTS v_state_link_connec;

DROP VIEW IF EXISTS v_edit_flwreg CASCADE;
DROP VIEW IF EXISTS v_edit_inp_frpump CASCADE;
DROP VIEW IF EXISTS v_edit_inp_dscenario_frpump CASCADE;

DROP VIEW IF EXISTS vu_dma;
DROP VIEW IF EXISTS vu_link;
DROP VIEW IF EXISTS vu_arc;
DROP VIEW IF EXISTS vu_node;
DROP VIEW IF EXISTS vu_connec;

DROP VIEW IF EXISTS v_edit_plan_psector;;
DROP VIEW IF EXISTS v_ui_plan_psector;

CREATE OR REPLACE VIEW v_edit_plan_psector_x_other
AS SELECT plan_psector_x_other.id,
    plan_psector_x_other.psector_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    rpad(v_price_compost.descript::text, 125) AS price_descript,
    v_price_compost.price,
    plan_psector_x_other.measurement,
    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget,
    plan_psector_x_other.observ,
    plan_psector.atlas_id,
    plan_psector_x_other.the_geom
   FROM plan_psector_x_other
     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_other.psector_id
  ORDER BY plan_psector_x_other.psector_id;

CREATE OR REPLACE VIEW v_edit_cat_feature_link
AS SELECT cat_feature.id,
    cat_feature.feature_class AS system_id,
    cat_feature.code_autofill,
    cat_feature.shortcut_key,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM cat_feature
     JOIN cat_feature_link USING (id);


  CREATE OR REPLACE VIEW v_edit_cat_feature_element
AS SELECT
	cat_feature.id,
    cat_feature.feature_class AS system_id,
    cat_feature_element.epa_default,
    cat_feature.code_autofill,
    cat_feature.shortcut_key ,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM cat_feature
     JOIN cat_feature_element USING (id);


-- ====================
CREATE OR REPLACE VIEW ve_element
AS WITH sel_state AS (
    SELECT selector_state.state_id FROM selector_state WHERE selector_state.cur_user = CURRENT_USER
), sel_sector AS (
    SELECT selector_sector.sector_id FROM selector_sector WHERE selector_sector.cur_user = CURRENT_USER
), sel_expl AS (
    SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER
), sel_muni AS (
    SELECT selector_municipality.muni_id FROM selector_municipality WHERE selector_municipality.cur_user = CURRENT_USER
), element_selector AS (
    SELECT
        e.element_id,
        e.code,
        e.sys_code,
        e.top_elev,
        e.elementcat_id,
        e.num_elements,
        e.epa_type,
        e.state,
        e.state_type,
        e.expl_id,
        e.muni_id,
        e.sector_id,
        e.omzone_id,
        e.function_type,
        e.category_type,
        e.location_type,
        e.observ,
        e.comment,
        e.workcat_id,
        e.workcat_id_end,
        e.builtdate,
        e.enddate,
        e.ownercat_id,
        e.brand_id,
        e.model_id,
        e.serial_number,
        e.asset_id,
        e.verified,
        e.datasource,
        e.label_x,
        e.label_y,
        e.label_rotation,
        e.rotation,
        e.inventory,
        e.publish,
        e.trace_featuregeom,
        e.lock_level,
        e.expl_visibility,
        e.created_at,
        e.created_by,
        e.updated_at,
        e.updated_by,
        e.the_geom
    FROM element e
    WHERE EXISTS (SELECT 1 FROM sel_sector s WHERE s.sector_id = e.sector_id)
    AND EXISTS (SELECT 1 FROM sel_expl e WHERE e.expl_id = e.expl_id)
    AND EXISTS (SELECT 1 FROM sel_state s WHERE s.state_id = e.state)
    AND EXISTS (SELECT 1 FROM sel_muni m WHERE m.muni_id = e.muni_id)
), element_selected AS (
    SELECT
        e.element_id,
        e.code,
        e.sys_code,
        e.top_elev,
        cat_element.element_type,
        e.elementcat_id,
        e.num_elements,
        e.epa_type,
        e.state,
        e.state_type,
        e.expl_id,
        e.muni_id,
        e.sector_id,
        e.omzone_id,
        e.function_type,
        e.category_type,
        e.location_type,
        e.observ,
        e.comment,
        cat_element.link,
        e.workcat_id,
        e.workcat_id_end,
        e.builtdate,
        e.enddate,
        e.ownercat_id,
        e.brand_id,
        e.model_id,
        e.serial_number,
        e.asset_id,
        e.verified,
        e.datasource,
        e.label_x,
        e.label_y,
        e.label_rotation,
        e.rotation,
        e.inventory,
        e.publish,
        e.trace_featuregeom,
        e.lock_level,
        e.expl_visibility,
        e.created_at,
        e.created_by,
        e.updated_at,
        e.updated_by,
        e.the_geom
    FROM element_selector e
    JOIN cat_element ON e.elementcat_id::text = cat_element.id::text
)
SELECT * FROM element_selected;

CREATE OR REPLACE VIEW ve_frelem AS
  SELECT ve_element.element_id,
    ve_element.code,
    ve_element.sys_code,
    ve_element.top_elev,
    ve_element.element_type,
    ve_element.elementcat_id,
    ve_element.num_elements,
    ve_element.epa_type,
    ve_element.state,
    ve_element.state_type,
    ve_element.expl_id,
    ve_element.muni_id,
    ve_element.sector_id,
    ve_element.omzone_id,
    ve_element.function_type,
    ve_element.category_type,
    ve_element.location_type,
    ve_element.observ,
    ve_element.comment,
    ve_element.link,
    ve_element.workcat_id,
    ve_element.workcat_id_end,
    ve_element.builtdate,
    ve_element.enddate,
    ve_element.ownercat_id,
    ve_element.brand_id,
    ve_element.model_id,
    ve_element.serial_number,
    ve_element.asset_id,
    ve_element.verified,
    ve_element.datasource,
    ve_element.label_x,
    ve_element.label_y,
    ve_element.label_rotation,
    ve_element.rotation,
    ve_element.inventory,
    ve_element.publish,
    ve_element.trace_featuregeom,
    ve_element.lock_level,
    ve_element.expl_visibility,
    man_frelem.node_id,
    man_frelem.order_id,
    concat (man_frelem.node_id,'_FR', man_frelem.order_id) AS nodarc_id,
    man_frelem.to_arc,
    man_frelem.flwreg_length,
    st_x(st_endpoint(st_setsrid(st_makeline(ve_element.the_geom, st_lineinterpolatepoint(a.the_geom, flwreg_length / st_length(a.the_geom))), SRID_VALUE)::geometry(LineString,SRID_VALUE))) AS symbol_x,
    st_y(st_endpoint(st_setsrid(st_makeline(ve_element.the_geom, st_lineinterpolatepoint(a.the_geom, flwreg_length / st_length(a.the_geom))), SRID_VALUE)::geometry(LineString,SRID_VALUE))) AS symbol_y,
    ve_element.created_at,
    ve_element.created_by,
    ve_element.updated_at,
    ve_element.updated_by,
    ve_element.the_geom
    FROM ve_element
    JOIN man_frelem ON ve_element.element_id = man_frelem.element_id
	  JOIN arc a ON arc_id = to_arc;


CREATE OR REPLACE VIEW ve_genelem AS
SELECT ve_element.element_id,
    ve_element.code,
    ve_element.sys_code,
    ve_element.top_elev,
    ve_element.element_type,
    ve_element.elementcat_id,
    ve_element.num_elements,
    ve_element.epa_type,
    ve_element.state,
    ve_element.state_type,
    ve_element.expl_id,
    ve_element.muni_id,
    ve_element.sector_id,
    ve_element.omzone_id,
    ve_element.function_type,
    ve_element.category_type,
    ve_element.location_type,
    ve_element.observ,
    ve_element.comment,
    ve_element.link,
    ve_element.workcat_id,
    ve_element.workcat_id_end,
    ve_element.builtdate,
    ve_element.enddate,
    ve_element.ownercat_id,
    ve_element.brand_id,
    ve_element.model_id,
    ve_element.serial_number,
    ve_element.asset_id,
    ve_element.verified,
    ve_element.datasource,
    ve_element.label_x,
    ve_element.label_y,
    ve_element.label_rotation,
    ve_element.rotation,
    ve_element.inventory,
    ve_element.publish,
    ve_element.trace_featuregeom,
    ve_element.lock_level,
    ve_element.expl_visibility,
    ve_element.created_at,
    ve_element.created_by,
    ve_element.updated_at,
    ve_element.updated_by,
    ve_element.the_geom
   FROM ve_element
   JOIN man_genelem ON ve_element.element_id = man_genelem.element_id;

CREATE OR REPLACE VIEW v_ext_raster_dem
AS
SELECT DISTINCT ON (r.id)
    r.id,
    c.code,
    c.alias,
    c.raster_type,
    c.descript,
    c.source,
    c.provider,
    c.year,
    r.rast,
    r.rastercat_id,
    r.envelope
FROM ext_raster_dem r
JOIN ext_cat_raster c ON c.id = r.rastercat_id
JOIN v_ext_municipality a ON st_dwithin(r.envelope, a.the_geom, 0::double precision);


CREATE OR REPLACE VIEW ve_pol_element
AS SELECT p.pol_id,
    e.element_id,
    p.the_geom,
    p.trace_featuregeom
    FROM element e
    JOIN polygon p ON p.feature_id = e.element_id;

CREATE OR REPLACE VIEW ve_pol_connec
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM polygon
    JOIN connec ON polygon.feature_id = connec.connec_id
    LEFT JOIN plan_psector_x_connec pp ON polygon.feature_id = pp.connec_id
    JOIN selector_expl se ON (se.cur_user =current_user AND se.expl_id = connec.expl_id) or (se.cur_user =current_user and se.expl_id = ANY(connec.expl_visibility))
    JOIN selector_sector sc ON (sc.cur_user = CURRENT_USER AND sc.sector_id = connec.sector_id)
    JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
    JOIN selector_state ss ON ss.cur_user = current_user AND connec.state = ss.state_id;

CREATE OR REPLACE VIEW ve_pol_node
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM polygon
    LEFT JOIN plan_psector_x_node pp ON polygon.feature_id = pp.node_id
    JOIN node ON polygon.feature_id = node.node_id
    JOIN selector_expl se ON (se.cur_user =current_user AND se.expl_id = node.expl_id) or (se.cur_user =current_user and se.expl_id = ANY(node.expl_visibility))
    JOIN selector_sector sc ON (sc.cur_user = CURRENT_USER AND sc.sector_id = node.sector_id)
    JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
    JOIN selector_state ss ON ss.cur_user = current_user AND node.state = ss.state_id;


CREATE OR REPLACE VIEW v_ui_element_x_link
AS SELECT
    element_x_link.link_id,
    element_x_link.element_id,
    cat_feature.feature_class,
    cat_element.element_type,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory
   FROM element_x_link
     JOIN element ON element.element_id::text = element_x_link.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
     JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
     JOIN cat_feature ON cat_feature.id::text = cfe.id::text;

CREATE OR REPLACE VIEW v_ui_element_x_node
AS SELECT element_x_node.node_id,
    element_x_node.element_id,
    cat_feature.feature_class,
    cat_element.element_type,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory
   FROM element_x_node
     JOIN element ON element.element_id::text = element_x_node.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
     JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
     JOIN cat_feature ON cat_feature.id::text = cfe.id::text;

CREATE OR REPLACE VIEW v_ui_element_x_connec
AS SELECT element_x_connec.connec_id,
    element_x_connec.element_id,
    cat_feature.feature_class,
    cat_element.element_type,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory
   FROM element_x_connec
     JOIN element ON element.element_id::text = element_x_connec.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::TEXT
     JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
     JOIN cat_feature ON cat_feature.id::text = cfe.id::text;

CREATE OR REPLACE VIEW v_ui_element_x_arc
AS SELECT element_x_arc.arc_id,
    element_x_arc.element_id,
    cat_feature.feature_class,
    cat_element.element_type,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory
   FROM element_x_arc
     JOIN element ON element.element_id::text = element_x_arc.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
     JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
     JOIN cat_feature ON cat_feature.id::text = cfe.id::text;

-- PSECTORS
CREATE OR REPLACE VIEW v_plan_psector_node
AS SELECT row_number() OVER () AS rid,
    node.node_id,
    plan_psector_x_node.psector_id,
    node.code,
    node.nodecat_id,
    cat_node.node_type,
    cat_feature.feature_class,
    node.state AS original_state,
    node.state_type AS original_state_type,
    plan_psector_x_node.state AS plan_state,
    plan_psector_x_node.doable,
    plan_psector.priority AS psector_priority,
    node.the_geom
   FROM selector_psector,
    node
     JOIN plan_psector_x_node USING (node_id)
     JOIN plan_psector USING (psector_id)
     JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_node.node_type::text
  WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

  CREATE OR REPLACE VIEW v_plan_psector_connec
AS SELECT row_number() OVER () AS rid,
    connec.connec_id,
    plan_psector_x_connec.psector_id,
    connec.code,
    connec.conneccat_id,
    cat_connec.connec_type,
    cat_feature.feature_class,
    connec.state AS original_state,
    connec.state_type AS original_state_type,
    plan_psector_x_connec.state AS plan_state,
    plan_psector_x_connec.doable,
    plan_psector.priority AS psector_priority,
    connec.the_geom
   FROM selector_psector,
    connec
     JOIN plan_psector_x_connec USING (connec_id)
     JOIN plan_psector USING (psector_id)
     JOIN cat_connec ON cat_connec.id::text = connec.conneccat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_connec.connec_type::text
  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_plan_psector_arc
AS SELECT row_number() OVER () AS rid,
    arc.arc_id,
    plan_psector_x_arc.psector_id,
    arc.code,
    arc.arccat_id,
    cat_arc.arc_type,
    cat_feature.feature_class,
    arc.state AS original_state,
    arc.state_type AS original_state_type,
    plan_psector_x_arc.state AS plan_state,
    plan_psector_x_arc.doable,
    plan_psector_x_arc.addparam::text AS addparam,
    plan_psector.priority AS psector_priority,
    arc.the_geom
   FROM selector_psector,
    arc
     JOIN plan_psector_x_arc USING (arc_id)
     JOIN plan_psector USING (psector_id)
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_arc.arc_type::text
  WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_ui_plan_psector
AS SELECT plan_psector.psector_id,
    plan_psector.ext_code,
    plan_psector.name,
    plan_psector.descript,
    p.idval AS priority,
    s.idval AS status,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.expl_id,
    t.idval AS psector_type,
    plan_psector.active,
    plan_psector.archived,
    plan_psector.workcat_id,
    plan_psector.parent_id
   FROM selector_expl,
    plan_psector
     JOIN exploitation USING (expl_id)
     LEFT JOIN plan_typevalue p ON p.id::text = plan_psector.priority::text AND p.typevalue = 'value_priority'::text
     LEFT JOIN plan_typevalue s ON s.id::text = plan_psector.status::text AND s.typevalue = 'psector_status'::text
     LEFT JOIN plan_typevalue t ON t.id::integer = plan_psector.psector_type AND t.typevalue = 'psector_type'::text
  WHERE plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_ui_om_visit
AS SELECT om_visit.id,
    om_visit_cat.name AS visit_catalog,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    exploitation.name AS exploitation,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.visit_type
   FROM om_visit
     LEFT JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
     LEFT JOIN exploitation ON exploitation.expl_id = om_visit.expl_id;

CREATE OR REPLACE VIEW ve_pol_connec
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM polygon
    JOIN connec ON polygon.feature_id::text = connec.connec_id::text
    JOIN selector_expl se ON (se.cur_user = CURRENT_USER AND se.expl_id = connec.expl_id) or (se.cur_user = CURRENT_USER and se.expl_id = ANY(connec.expl_visibility))
    JOIN selector_sector ss ON (ss.cur_user = CURRENT_USER AND ss.sector_id = connec.sector_id)
    JOIN selector_municipality sm ON (sm.cur_user = CURRENT_USER AND sm.muni_id = connec.muni_id);

CREATE OR REPLACE VIEW ve_pol_node
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM polygon
    JOIN node ON polygon.feature_id::text = node.node_id::text
    JOIN selector_expl se ON (se.cur_user =CURRENT_USER AND se.expl_id = node.expl_id) or (se.cur_user = CURRENT_USER and se.expl_id = ANY(node.expl_visibility))
    JOIN selector_sector ss ON (ss.cur_user = CURRENT_USER AND ss.sector_id = node.sector_id)
    JOIN selector_municipality sm ON (sm.cur_user = CURRENT_USER AND sm.muni_id = node.muni_id);

CREATE OR REPLACE VIEW ve_pol_element
AS SELECT polygon.pol_id,
    element.element_id,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM polygon
    JOIN element ON polygon.feature_id::text = element.element_id::text
    JOIN selector_expl se ON (se.cur_user =CURRENT_USER AND se.expl_id = element.expl_id) or (se.cur_user = CURRENT_USER and se.expl_id = ANY(element.expl_visibility))
    JOIN selector_sector ss ON (ss.cur_user = CURRENT_USER AND ss.sector_id = element.sector_id)
    JOIN selector_municipality sm ON (sm.cur_user = CURRENT_USER AND sm.muni_id = element.muni_id);

CREATE OR REPLACE VIEW v_ui_element
AS SELECT element.element_id,
    element.code,
    element.sys_code,
    element.top_elev,
    element.feature_type,
    cat_feature.feature_class,
    cat_element.element_type,
    element.elementcat_id,
    element.num_elements,
    element.state,
    element.state_type,
    element.expl_id,
    element.muni_id,
    element.sector_id,
    element.omzone_id,
    element.function_type,
    element.category_type,
    element.location_type,
    element.observ,
    element.comment,
    element.link,
    element.workcat_id,
    element.workcat_id_end,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.brand_id,
    element.model_id,
    element.serial_number,
    element.asset_id,
    element.verified,
    element.datasource,
    element.label_x,
    element.label_y,
    element.rotation,
    element.label_rotation,
    element.inventory,
    element.publish,
    element.trace_featuregeom,
    element.lock_level,
    element.expl_visibility,
    element.created_at,
    element.created_by,
    element.updated_at,
    element.updated_by,
    element.the_geom
   FROM element
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
     JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
     JOIN cat_feature ON cat_feature.id::text = cfe.id::text;

CREATE OR REPLACE VIEW v_state_arc
AS WITH p AS (
         SELECT plan_psector_x_arc.arc_id,
            plan_psector_x_arc.psector_id,
            plan_psector_x_arc.state
           FROM plan_psector_x_arc
          WHERE plan_psector_x_arc.active
        ), cf AS (
         SELECT config_param_user.value::boolean AS value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'utils_psector_strategy'::text AND config_param_user.cur_user::text = CURRENT_USER
        ), s AS (
         SELECT selector_psector.psector_id,
            selector_psector.cur_user
           FROM selector_psector
          WHERE selector_psector.cur_user = CURRENT_USER
        ), a AS (
         SELECT arc.arc_id,
            arc.state
           FROM arc
        )
(
         SELECT arc.arc_id
           FROM selector_state,
            arc
          WHERE arc.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
        EXCEPT ALL
         SELECT p.arc_id
           FROM s,
            p
          WHERE p.psector_id = s.psector_id AND p.state = 0
) UNION ALL
 SELECT DISTINCT p.arc_id
   FROM s,
    p
  WHERE p.psector_id = s.psector_id AND p.state = 1;

CREATE OR REPLACE VIEW v_state_node
AS WITH p AS (
         SELECT plan_psector_x_node.node_id,
            plan_psector_x_node.psector_id,
            plan_psector_x_node.state
           FROM plan_psector_x_node
          WHERE plan_psector_x_node.active
        ), cf AS (
         SELECT config_param_user.value::boolean AS value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'utils_psector_strategy'::text AND config_param_user.cur_user::text = CURRENT_USER
        ), s AS (
         SELECT selector_psector.psector_id,
            selector_psector.cur_user
           FROM selector_psector
          WHERE selector_psector.cur_user = CURRENT_USER
        ), n AS (
         SELECT node.node_id,
            node.state
           FROM node
        )
(
         SELECT n.node_id
           FROM selector_state,
            n
          WHERE n.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
        EXCEPT ALL
         SELECT p.node_id
           FROM s,
            p,
            cf
          WHERE p.psector_id = s.psector_id AND p.state = 0 AND cf.value IS TRUE
) UNION ALL
 SELECT DISTINCT p.node_id
   FROM s,
    p,
    cf
  WHERE p.psector_id = s.psector_id AND p.state = 1 AND cf.value IS TRUE;


CREATE OR REPLACE VIEW v_state_link
AS WITH p AS (
         SELECT plan_psector_x_connec.connec_id,
            plan_psector_x_connec.psector_id,
            plan_psector_x_connec.state,
            plan_psector_x_connec.link_id
           FROM plan_psector_x_connec
          WHERE plan_psector_x_connec.active
        ), cf AS (
         SELECT config_param_user.value::boolean AS value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'utils_psector_strategy'::text AND config_param_user.cur_user::text = CURRENT_USER
        ), sp AS (
         SELECT selector_psector.psector_id,
            selector_psector.cur_user
           FROM selector_psector
          WHERE selector_psector.cur_user = CURRENT_USER
        ), se AS (
         SELECT selector_expl.expl_id,
            selector_expl.cur_user
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        ), l AS (
         SELECT link.link_id,
            link.state,
            link.expl_id,
            link.expl_visibility
           FROM link
        )
        (
         SELECT l.link_id
           FROM selector_state,
            se,
            l
          WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id = ANY(l.expl_visibility)) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
        EXCEPT ALL
         SELECT p.link_id
           FROM cf,
            sp,
            se,
            p
             JOIN l USING (link_id)
          WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value IS TRUE
        ) UNION ALL
        SELECT p.link_id
          FROM cf,
            sp,
            se,
            p
            JOIN l USING (link_id)
          WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value IS TRUE;

CREATE OR REPLACE VIEW v_state_element
AS SELECT element.element_id
   FROM selector_state,
    element
  WHERE element.state = selector_state.state_id AND selector_state.cur_user = CURRENT_USER;


CREATE OR REPLACE VIEW v_state_connec
AS WITH p AS (
         SELECT plan_psector_x_connec.connec_id,
            plan_psector_x_connec.psector_id,
            plan_psector_x_connec.state,
            plan_psector_x_connec.arc_id
           FROM plan_psector_x_connec
          WHERE plan_psector_x_connec.active
        ), cf AS (
         SELECT config_param_user.value::boolean AS value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'utils_psector_strategy'::text AND config_param_user.cur_user::text = CURRENT_USER
        ), s AS (
         SELECT selector_psector.psector_id,
            selector_psector.cur_user
           FROM selector_psector
          WHERE selector_psector.cur_user = CURRENT_USER
        ), c AS (
         SELECT connec.connec_id,
            connec.state,
            connec.arc_id
           FROM connec
        )
(
         SELECT c.connec_id,
            c.arc_id
           FROM selector_state,
            c
          WHERE c.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
        EXCEPT ALL
         SELECT p.connec_id,
            p.arc_id
           FROM cf,
            s,
            p
          WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text AND p.state = 0 AND cf.value IS TRUE
) UNION ALL
 SELECT DISTINCT ON (p.connec_id) p.connec_id,
    p.arc_id
   FROM cf,
    s,
    p
  WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text AND p.state = 1 AND cf.value IS TRUE;


CREATE OR REPLACE VIEW v_ui_doc_x_element
AS SELECT doc_x_element.doc_id,
  doc_x_element.element_id,
  doc.name as doc_name,
  doc.doc_type,
  doc.path,
  doc.observ,
  doc.date,
  doc.user_name
FROM doc_x_element
  JOIN doc ON doc.id::text = doc_x_element.doc_id::text;

CREATE OR REPLACE VIEW v_edit_plan_psector
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.descript,
    plan_psector.priority,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.atlas_id,
    plan_psector.gexpenses,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.the_geom,
    plan_psector.expl_id,
    plan_psector.psector_type,
    plan_psector.active,
    plan_psector.archived,
    plan_psector.ext_code,
    plan_psector.status,
    plan_psector.text3,
    plan_psector.text4,
    plan_psector.text5,
    plan_psector.text6,
    plan_psector.num_value,
    plan_psector.workcat_id,
    plan_psector.parent_id,
    plan_psector.creation_date
   FROM selector_expl,
    plan_psector
  WHERE plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_ui_plan_psector
AS SELECT plan_psector.psector_id,
    plan_psector.ext_code,
    plan_psector.name,
    plan_psector.descript,
    p.idval AS priority,
    s.idval AS status,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.expl_id,
    t.idval AS psector_type,
    plan_psector.active,
    plan_psector.archived,
    plan_psector.workcat_id,
    plan_psector.parent_id,
    plan_psector.creation_date
   FROM selector_expl,
    plan_psector
     JOIN exploitation USING (expl_id)
     LEFT JOIN plan_typevalue p ON p.id::text = plan_psector.priority::text AND p.typevalue = 'value_priority'::text
     LEFT JOIN plan_typevalue s ON s.id::text = plan_psector.status::text AND s.typevalue = 'psector_status'::text
     LEFT JOIN plan_typevalue t ON t.id::integer = plan_psector.psector_type AND t.typevalue = 'psector_type'::text
  WHERE plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW vcv_emitters AS
  SELECT DISTINCT node_id, sum(length/10000) as coef
    FROM selector_inp_result r,rpt_inp_arc a
    JOIN rpt_inp_node n USING(result_id)
    WHERE (a.node_1 = n.node_id OR a.node_2 = n.node_id) and r.result_id = n.result_id
    AND r.cur_user = "current_user"()::text
    GROUP BY node_id;


CREATE OR REPLACE VIEW v_edit_dimensions
AS SELECT dimensions.id,
    dimensions.distance,
    dimensions.depth,
    dimensions.the_geom,
    dimensions.x_label,
    dimensions.y_label,
    dimensions.rotation_label,
    dimensions.offset_label,
    dimensions.direction_arrow,
    dimensions.x_symbol,
    dimensions.y_symbol,
    dimensions.feature_id,
    dimensions.feature_type,
    dimensions.state,
    dimensions.expl_id,
    dimensions.observ,
    dimensions.comment,
    dimensions.sector_id,
    dimensions.muni_id
   FROM selector_expl,
    dimensions
     JOIN v_state_dimensions ON dimensions.id = v_state_dimensions.id
     LEFT JOIN selector_municipality m USING (muni_id)
     JOIN selector_sector s USING (sector_id)
  WHERE (m.cur_user = CURRENT_USER::text OR dimensions.muni_id IS NULL) AND s.cur_user = CURRENT_USER::text AND dimensions.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_ui_om_event
AS SELECT id,
    event_code,
    visit_id,
    position_id,
    position_value,
    parameter_id,
    value,
    value1,
    value2,
    geom1,
    geom2,
    geom3,
    xcoord,
    ycoord,
    compass,
    tstamp,
    text,
    index_val,
    is_last
   FROM om_visit_event;


DELETE FROM sys_table WHERE id IN ('vp_basic_arc', 'vp_basic_node', 'vp_basic_connec', 'vp_basic_gully');

UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL WHERE layer_id='v_edit_node';
UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL WHERE layer_id='v_edit_connec';
UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL WHERE layer_id='v_edit_arc';

INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('LINK', 'LINK', 'UNDEFINED', 'man_link');


DELETE FROM sys_feature_class WHERE id = 'ELEMENT' AND type = 'ELEMENT';
INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('FRELEM', 'ELEMENT', 'UNDEFINED', 'man_frelem');
INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('GENELEM', 'ELEMENT', 'UNDEFINED', 'man_genelem');


DELETE FROM cat_feature WHERE id = 'LINK';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source") VALUES(3286, 'arc_id column cannot be modified when state = 0 on plan_psector %psector_id%.', '', 2, true, 'utils', 'core');

INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('FRPUMP', 'ELEMENT', 'inp_frpump', NULL, true);

INSERT INTO config_typevalue (typevalue, id, camelstyle, idval, addparam) VALUES('sys_table_context', '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"ELEMENT"}', NULL, NULL, '{"orderBy":89}'::json);


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3388, 'gw_fct_admin_dynamic_trigger', 'utils', 'function', 'json', 'json', 'Function to insert or update columns dynamically through triggers', 'role_admin', NULL, 'core');

UPDATE config_report SET query_text='SELECT e.name as "Exploitation", vec.connec_id, vec.code, vec.customer_code FROM v_edit_connec vec JOIN exploitation e USING (expl_id) ' WHERE id=101;


ALTER TABLE config_info_layer DROP COLUMN tableparent_id;

UPDATE config_info_layer SET is_parent=true WHERE layer_id='v_edit_node';
UPDATE config_info_layer SET is_parent=true WHERE layer_id='v_edit_connec';
UPDATE config_info_layer SET is_parent=true WHERE layer_id='v_edit_arc';

INSERT INTO config_info_layer (layer_id, is_parent, is_editable, formtemplate, headertext, orderby)
VALUES('ve_frelem', true, true, 'info_feature', 'Flow regulator element', 4);

INSERT INTO config_info_layer (layer_id, is_parent, is_editable, formtemplate, headertext, orderby)
VALUES('ve_genelem', true, true, 'info_feature', 'Generic element', 4);

DELETE FROM config_info_layer WHERE layer_id IN ('v_edit_flwreg', 'v_edit_element');


-- config typevalue
update config_typevalue set addparam ='{"orderBy":10}' where id ='{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"POLYGON"}';
update config_typevalue set addparam ='{"orderBy":51}' where id ='{"level_1":"INVENTORY","level_2":"AUXILIAR"}';

-- sys table
DELETE FROM sys_table WHERE id = 'v_edit_flwreg';
INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, "source") VALUES('ve_frelem', 'Specific view for flowregulator elements', 'role_basic', '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"ELEMENT"}', 'Flow regulators', 2, 'core');

UPDATE sys_table SET context ='{"level_1":"INVENTORY","level_2":"OTHER"}' , orderby = 1 WHERE id = 'v_edit_dimensions';

INSERT INTO sys_table (id, descript, sys_role, context, "source") VALUES('v_edit_cat_feature_element', 'Catalog for elements', 'role_edit', '{"level_1":"INVENTORY","level_2":"CATALOGS"}', 'core');

UPDATE config_info_layer SET is_parent = true, formtemplate = 'info_feature' WHERE layer_id = 'v_edit_link';

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_link', 'tab_elements', 'Elements', 'List of related elements', 'role_basic', NULL, '[{"actionName":"actionEdit", "disabled":false},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionCatalog", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste","disabled":false},
{"actionName":"actionSection", "disabled":false},
{"actionName":"actionGetParentId", "disabled":false},
{"actionName":"actionLink",  "disabled":false}]'::json, 1, '{4,5}');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'tbl_documents', 'lyt_document_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json, 'tbl_doc_x_link', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'open_doc', 'lyt_document_2', 11, NULL, 'button', NULL, 'Open document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"147"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'btn_doc_new', 'lyt_document_2', 4, NULL, 'button', NULL, 'New document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'btn_doc_delete', 'lyt_document_2', 3, NULL, 'button', NULL, 'Delete document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json, '{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'hspacer_document_1', 'lyt_document_2', 10, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'doc_name', 'lyt_document_2', 0, 'string', 'typeahead', 'Doc id:', NULL, NULL, false, false, true, false, false, 'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table"}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'doc_type', 'lyt_document_1', 3, 'string', 'combo', 'Doc type:', NULL, NULL, false, false, true, false, true, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_link', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'date_from', 'lyt_document_1', 1, 'date', 'datetime', 'Date from:', NULL, NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":">="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'date_to', 'lyt_document_1', 2, 'date', 'datetime', 'Date to:', NULL, NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":"<="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'btn_doc_insert', 'lyt_document_2', 2, NULL, 'button', NULL, 'Insert document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_elements', 'hspacer_lyt_element', 'lyt_element_1', 10, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_elements', 'element_id', 'lyt_element_1', 1, 'string', 'typeahead', 'Element id:', 'Element id', NULL, false, false, true, false, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_elements', 'delete_element', 'lyt_element_1', 4, NULL, 'button', NULL, 'Delete element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}'::json, '{ "functionName": "delete_object", "parameters": {"columnfind": "element_id", "targetwidget": "tab_elements_tbl_elements", "sourceview": "element"}}'::json, 'tbl_element_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_elements', 'insert_element', 'lyt_element_1', 3, NULL, 'button', NULL, 'Insert element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
	  "functionName": "add_object",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_elements', 'new_element', 'lyt_element_1', 5, NULL, 'button', NULL, 'New element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
	  "functionName": "manage_element",
	  "module": "info",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_elements', 'open_element', 'lyt_element_1', 11, NULL, 'button', NULL, 'Open element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"144"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}'::json, '{
	  "functionName": "open_selected_element",
	  "module": "info",
	  "parameters": {
	    "columnfind": "element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_elements', 'btn_link', 'lyt_element_1', 12, NULL, 'button', NULL, 'Open link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"173"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_elements_tbl_elements",
    "columnfind": "link_id"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_elements', 'tbl_elements', 'lyt_element_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{"functionName": "open_selected_element", "module": "info", "parameters":{"columnfind":"element_id"}}'::json, 'tbl_element_x_link', false, 1);


INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'dqa_id', 'lyt_data_1', 11, 'integer', 'text', 'dqa_id', 'dqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'dqa_name', 'lyt_data_1', 20, 'string', 'text', 'dqa_name', 'dqa_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'fluid_type', 'lyt_data_1', 15, 'string', 'text', 'fluid_type', 'fluid_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'macrodqa_id', 'lyt_data_1', 24, 'integer', 'text', 'macrodqa_id', 'macrodqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'minsector_id', 'lyt_data_1', 12, 'integer', 'text', 'minsector_id', 'minsector_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'epa_type', 'lyt_data_1', 26, 'string', 'text', 'epa_type', '', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'is_operative', 'lyt_data_1', 27, 'boolean', 'check', 'is_operative', '', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 32, 'date', 'datetime', 'Builtdate:', 'builtdate - Date the element was added. In insertion of new elements the date of the day is shown', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'exit_id', 'lyt_data_1', 5, 'string', 'text', 'Exit ID', 'Exit ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'exit_type', 'lyt_data_1', 4, 'string', 'combo', 'Exit type', 'Exit type', NULL, false, false, false, false, NULL, 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'expl_id', 'lyt_data_1', 7, 'integer', 'combo', 'Explotation ID', 'Explotation ID', NULL, false, false, false, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'feature_id', 'lyt_data_1', 3, 'string', 'text', 'Feature ID', 'Feature ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'feature_type', 'lyt_data_1', 2, 'string', 'combo', 'Feature type', 'Feature type', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'link_id', 'lyt_data_1', 1, 'integer', 'text', 'Link ID', 'Link ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'presszone_id', 'lyt_data_1', 10, 'integer', 'text', 'presszone_id', 'presszone_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'sector_id', 'lyt_data_1', 8, 'integer', 'combo', 'Sector ID', 'sector_id  - Sector identifier.', NULL, false, false, false, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'state', 'lyt_data_1', 6, 'integer', 'combo', 'State:', 'State:', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'uncertain', 'lyt_data_1', 34, 'boolean', 'check', 'Uncertain', 'Uncertain', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'conneccat_id', 'lyt_data_1', 29, 'string', 'typeahead', 'Connecat ID', 'connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ', true, NULL, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, 'action_catalog', false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 33, 'date', 'datetime', 'Enddate', 'enddate - End date of the element. It will only be filled in if the element is in a deregistration state.', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'gis_length', 'lyt_data_1', 16, 'double', 'text', 'Gis length', 'Gis length', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'macrosector_id', 'lyt_data_1', 22, 'integer', 'combo', 'Macrosector id', 'Macrosector id', NULL, false, false, false, false, NULL, 'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_none', 'n_hydrometer', 'lyt_data_1', 35, 'integer', 'text', 'N_hydrometer', 'N_hydrometer', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL)
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'presszone_name', 'lyt_data_1', 21, 'string', 'text', 'presszone_name', 'presszone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'sector_name', 'lyt_data_1', 18, 'string', 'text', 'sector_name', 'sector_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 30, 'string', 'typeahead', 'Workcat ID', 'workcat_id - Related to the catalog of work files (cat_work). File that registers the element', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 31, 'string', 'typeahead', 'Workcat ID end', 'workcat_id_end - ID of the  end of construction work.', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);



INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'dqa_id', 'lyt_data_1', 11, 'integer', 'text', 'dqa_id', 'dqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'dqa_name', 'lyt_data_1', 20, 'string', 'text', 'dqa_name', 'dqa_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'fluid_type', 'lyt_data_1', 15, 'string', 'text', 'fluid_type', 'fluid_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'macrodqa_id', 'lyt_data_1', 24, 'integer', 'text', 'macrodqa_id', 'macrodqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'minsector_id', 'lyt_data_1', 12, 'integer', 'text', 'minsector_id', 'minsector_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'epa_type', 'lyt_data_1', 26, 'string', 'text', 'epa_type', '', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'is_operative', 'lyt_data_1', 27, 'boolean', 'check', 'is_operative', '', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 32, 'date', 'datetime', 'Builtdate:', 'builtdate - Date the element was added. In insertion of new elements the date of the day is shown', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'exit_id', 'lyt_data_1', 5, 'string', 'text', 'Exit ID', 'Exit ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'exit_type', 'lyt_data_1', 4, 'string', 'combo', 'Exit type', 'Exit type', NULL, false, false, false, false, NULL, 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'expl_id', 'lyt_data_1', 7, 'integer', 'combo', 'Explotation ID', 'Explotation ID', NULL, false, false, false, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'feature_id', 'lyt_data_1', 3, 'string', 'text', 'Feature ID', 'Feature ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'feature_type', 'lyt_data_1', 2, 'string', 'combo', 'Feature type', 'Feature type', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'link_id', 'lyt_data_1', 1, 'integer', 'text', 'Link ID', 'Link ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'presszone_id', 'lyt_data_1', 10, 'integer', 'text', 'presszone_id', 'presszone_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'sector_id', 'lyt_data_1', 8, 'integer', 'combo', 'Sector ID', 'sector_id  - Sector identifier.', NULL, false, false, false, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'state', 'lyt_data_1', 6, 'integer', 'combo', 'State:', 'State:', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'uncertain', 'lyt_data_1', 34, 'boolean', 'check', 'Uncertain', 'Uncertain', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'conneccat_id', 'lyt_data_1', 29, 'string', 'typeahead', 'Connecat ID', 'connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ', true, NULL, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, 'action_catalog', false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 33, 'date', 'datetime', 'Enddate', 'enddate - End date of the element. It will only be filled in if the element is in a deregistration state.', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'gis_length', 'lyt_data_1', 16, 'double', 'text', 'Gis length', 'Gis length', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'macrosector_id', 'lyt_data_1', 22, 'integer', 'combo', 'Macrosector id', 'Macrosector id', NULL, false, false, false, false, NULL, 'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_none', 'n_hydrometer', 'lyt_data_1', 35, 'integer', 'text', 'N_hydrometer', 'N_hydrometer', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'presszone_name', 'lyt_data_1', 21, 'string', 'text', 'presszone_name', 'presszone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'sector_name', 'lyt_data_1', 18, 'string', 'text', 'sector_name', 'sector_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 30, 'string', 'typeahead', 'Workcat ID', 'workcat_id - Related to the catalog of work files (cat_work). File that registers the element', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 31, 'string', 'typeahead', 'Workcat ID end', 'workcat_id_end - ID of the  end of construction work.', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('ve_link_link', 'tab_elements', 'Elements', 'List of related elements', 'role_basic', NULL, '[{"actionName":"actionEdit", "disabled":false},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionCatalog", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste","disabled":false},
{"actionName":"actionSection", "disabled":false},
{"actionName":"actionGetParentId", "disabled":false},
{"actionName":"actionLink",  "disabled":false}]'::json, 1, '{4,5}');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_documents', 'tbl_documents', 'lyt_document_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json, 'tbl_doc_x_link', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_documents', 'open_doc', 'lyt_document_2', 11, NULL, 'button', NULL, 'Open document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"147"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_documents', 'btn_doc_new', 'lyt_document_2', 4, NULL, 'button', NULL, 'New document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_documents', 'btn_doc_delete', 'lyt_document_2', 3, NULL, 'button', NULL, 'Delete document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json, '{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_documents', 'hspacer_document_1', 'lyt_document_2', 10, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_documents', 'doc_name', 'lyt_document_2', 0, 'string', 'typeahead', 'Doc id:', NULL, NULL, false, false, true, false, false, 'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table"}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_documents', 'doc_type', 'lyt_document_1', 3, 'string', 'combo', 'Doc type:', NULL, NULL, false, false, true, false, true, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_link', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_documents', 'date_from', 'lyt_document_1', 1, 'date', 'datetime', 'Date from:', NULL, NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":">="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_documents', 'date_to', 'lyt_document_1', 2, 'date', 'datetime', 'Date to:', NULL, NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":"<="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_documents', 'btn_doc_insert', 'lyt_document_2', 2, NULL, 'button', NULL, 'Insert document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_elements', 'hspacer_lyt_element', 'lyt_element_1', 10, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_elements', 'element_id', 'lyt_element_1', 1, 'string', 'typeahead', 'Element id:', 'Element id', NULL, false, false, true, false, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_elements', 'delete_element', 'lyt_element_1', 4, NULL, 'button', NULL, 'Delete element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}'::json, '{ "functionName": "delete_object", "parameters": {"columnfind": "element_id", "targetwidget": "tab_elements_tbl_elements", "sourceview": "element"}}'::json, 'tbl_element_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_elements', 'insert_element', 'lyt_element_1', 3, NULL, 'button', NULL, 'Insert element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
	  "functionName": "add_object",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_elements', 'new_element', 'lyt_element_1', 5, NULL, 'button', NULL, 'New element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
	  "functionName": "manage_element",
	  "module": "info",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_elements', 'open_element', 'lyt_element_1', 11, NULL, 'button', NULL, 'Open element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"144"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}'::json, '{
	  "functionName": "open_selected_element",
	  "module": "info",
	  "parameters": {
	    "columnfind": "element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_elements', 'btn_link', 'lyt_element_1', 12, NULL, 'button', NULL, 'Open link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"173"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_elements_tbl_elements",
    "columnfind": "link_id"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_elements', 'tbl_elements', 'lyt_element_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{"functionName": "open_selected_element", "module": "info", "parameters":{"columnfind":"element_id"}}'::json, 'tbl_element_x_link', false, 1);

DELETE FROM config_form_fields
WHERE formname = 'v_edit_link_connec';

DELETE FROM config_form_fields
WHERE formname = 'v_edit_link_gully';

UPDATE config_info_layer
SET is_parent = true
WHERE layer_id = 'v_edit_link';



DELETE FROM config_param_system WHERE "parameter"='admin_customform_param';


UPDATE sys_param_user
SET dv_querytext = 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type'' AND id IS NOT NULL'
WHERE id = 'edit_doctype_vdefault';



INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
VALUES('tbl_doc_x_element', 'SELECT * FROM v_ui_doc_x_element WHERE element_id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);


INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','link_id',0,false,'link_id');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','element_id',1,true,'element_id');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','elementcat_id',2,true,'elementcat_id');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','num_elements',3,true,'num_elements');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','feature_class',4,true,'feature_class');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','element_type',5,true,'element_type');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','state',6,true,'state');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','state_type',7,true,'state_type');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','observ',8,true,'observ');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','comment',9,true,'comment');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','builtdate',10,true,'builtdate');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','enddate',11,true,'enddate');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','link',12,true,'link');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','publish',13,true,'publish');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','inventory',14,true,'inventory');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','descript',15,true,'descript');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','location_type',16,true,'location_type');


INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('message_type','UI','UI');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('message_type','AUDIT','AUDIT');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('message_type','DEBUG','DEBUG');

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field) VALUES ('edit_typevalue','message_type','sys_message','message_type');

INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1101, 'INFO: Deactivated node proximity check.', 0, 'UD', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1103, 'CONNECT TO NETWORK', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1105, '-------------------------------------------------------------', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1107, 'Trying to connect %feature_type% with id %connect_id% to an arc with a diameter smaller than %check_arcdnom% and at maximum distance of %max_distance% meters.', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1109, 'Trying to connect %feature_type% with id %connect_id% to an arc at maximum ditance of %max_distance% meters.', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1111, 'Trying to connect %feature_type% with id %connect_id%.', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1113, 'FAILED: Link not created because connect %connect__id% is over arc %arc_id%', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1115, 'Create new link connected to the closest arc with the appropriate conditions.', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1117, 'Create new link connected to the selected arc: %arc_id%.', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1119, 'Create new link connected to the closest arc.', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1121, 'Creating new link by using geometry of existing one.', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1123, 'Reverse the direction of drawn link.', 0, 'generic', 'core', 'AUDIT');


INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('v_edit_plan_psector','form_feature','tab_none','creation_date','date','datetime','Creation Date:','Creation Date',false,false,true,false,'{"setMultiline":false}'::json,false)
  ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden,web_layoutorder)
	VALUES ('generic','psector','tab_general','creation_date','lyt_general_7',1,'date','datetime','Creation date:','Creation date:',false,false,true,false,false,'{"setMultiline":false}'::json,false,3);


UPDATE config_form_fields SET label = 'sys_ymax' WHERE columnname = 'sys_ymax';


DELETE FROM config_param_system WHERE "parameter"='basic_search_network_element';
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('basic_search_network_frelem', '{"sys_table_id":"ve_frelem","sys_id_field":"element_id","sys_search_field":"element_id","alias":"Flow regulator element","cat_field":"elementcat_id","orderby":"5","search_type":"element"}', 'Search configuration parameteres', 'Search flow regulator element:', NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('basic_search_network_genelem', '{"sys_table_id":"ve_genelem","sys_id_field":"element_id","sys_search_field":"element_id","alias":"General element","cat_field":"elementcat_id","orderby":"5","search_type":"element"}', 'Search configuration parameteres', 'Search general element:', NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- TODO: revise if this is necessary now with arc_id, node_id, connec_id integers
-- INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active)
-- VALUES(638, 'Arc which id is not an integer', 'utils', NULL, 'core', true, 'Check om-data', NULL, 3, 'arc which id is not an integer. Please, check your data before continue', NULL, NULL, 'SELECT CASE WHEN arc_id~E''^\\d+$'' THEN CAST (arc_id AS INTEGER)  ELSE 0 END  as feature_id, ''ARC'' as type, arccat_id, expl_id FROM t_arc', 'All arcs features with id integer.', '[gw_fct_om_check_data, gw_fct_admin_check_data]', true);

-- INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active)
-- VALUES(640, 'Node which id is not an integer', 'utils', NULL, 'core', true, 'Check om-data', NULL, 3, 'node which id is not an integer. Please, check your data before continue', NULL, NULL, 'SELECT CASE WHEN node_id~E''^\\d+$'' THEN CAST (node_id AS INTEGER)  ELSE 0 END  as feature_id, ''NODE'' as type, nodecat_id, expl_id FROM t_node', 'All nodes features with id integer.', '[gw_fct_om_check_data, gw_fct_admin_check_data]', true);

-- INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active)
-- VALUES(642, 'Connec which id is not an integer', 'utils', NULL, 'core', true, 'Check om-data', NULL, 3, 'connec which id is not an integer. Please, check your data before continue', NULL, NULL, 'SELECT CASE WHEN connec_id~E''^\\d+$'' THEN CAST (connec_id AS INTEGER)  ELSE 0 END  as feature_id, ''CONNEC'' as type, conneccat_id, expl_id FROM t_connec', 'All connecs features with id integer.', '[gw_fct_om_check_data, gw_fct_admin_check_data]', true);

DELETE FROM sys_fprocess WHERE fid IN (202, 542);

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('sys_label', 'Specific table to keep labels indexed and ready to translate', 'role_admin', 'core');




UPDATE config_form_tableview SET columnindex=0 WHERE objectname='tbl_relations' AND columnname='rid';
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('arc form', 'utils', 'tbl_relations', 'sys_table_id', 12, true, NULL, 'sys_table_id', NULL, NULL);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip,
    ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, hidden, dv_querytext)
VALUES
('v_edit_link', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 43, 'string', 'combo', 'Location Type', 'Location Type', false, false, true, false, '{"setMultiline":false}'::json, false, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE ((featurecat_id is null AND feature_type=''LINK'') ) AND active IS TRUE'),
('v_edit_link', 'form_feature', 'tab_data', 'annotation', 'lyt_data_1', 43, 'string', 'text', 'Annotation', 'Annotation', false, false, true, false, '{"setMultiline":false}'::json, false, NULL),
('v_edit_link', 'form_feature', 'tab_data', 'observ', 'lyt_data_1', 44, 'string', 'text', 'Observ', 'Observ', false, false, true, false, '{"setMultiline":false}'::json, false, NULL),
('v_edit_link', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 45, 'string', 'text', 'Comment', 'Comment', false, false, true, false, '{"setMultiline":false}'::json, false, NULL),
('v_edit_link', 'form_feature', 'tab_data', 'descript', 'lyt_data_1', 46, 'string', 'text', 'Descript', 'Descript', false, false, true, false, '{"setMultiline":false}'::json, false, NULL),
('v_edit_link', 'form_feature', 'tab_data', 'link', 'lyt_data_1', 47, 'string', 'hyperlink', 'Link', 'Link', false, false, true, false, '{"setMultiline":false}'::json, false, NULL),
('v_edit_link', 'form_feature', 'tab_data', 'num_value', 'lyt_data_1', 48, 'double', 'text', 'Num Value', 'Num Value', false, false, true, false, '{"setMultiline":false}'::json, false, NULL)
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE sys_param_user SET widgettype='text' WHERE id='qgis_composers_folderpath';


UPDATE config_form_fields SET dv_querytext =  'SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type'''
WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='fluid_type' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext =  'SELECT id, location_type AS idval FROM man_type_location WHERE id IS NOT NULL'
WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='location_type' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext =  'SELECT id, category_type AS idval FROM man_type_category WHERE id IS NOT NULL'
WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='category_type' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext =  'SELECT id, function_type AS idval FROM man_type_function WHERE id IS NOT NULL'
WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='function_type' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext =  'SELECT id, id AS idval FROM sys_feature_type WHERE id IS NOT NULL'
WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='feature_type_new' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext =  'SELECT id, id AS idval FROM cat_feature'
WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='featurecat_id' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext =  'SELECT ARRAY[''composer_plan'', ''composer_mincut''] AS id, ARRAY[''composer_plan'', ''composer_mincut''] AS idval'
WHERE formname='print' AND formtype='form_print' AND columnname='composer' AND tabname='tab_none';


INSERT INTO node_add (node_id) SELECT node_id FROM node ON CONFLICT (node_id) DO NOTHING;
INSERT INTO arc_add (arc_id) SELECT arc_id FROM arc ON CONFLICT (arc_id) DO NOTHING;


INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('v_edit_link', 'Shows editable information about links.', 'role_basic', '{"template": [1]}', '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"LINK"}', 1, 'Link (parent)', NULL, NULL, NULL, 'core', NULL) ON CONFLICT (id) DO NOTHING;

UPDATE sys_table SET project_template = '{"template": [1]}' WHERE id IN (
	'v_edit_cat_feature_node',
	'v_edit_cat_feature_arc',
	'v_edit_cat_feature_connec',
	'cat_material',
	'cat_node',
	'cat_arc',
	'cat_connec',
	'v_edit_macrosector',
	'v_edit_exploitation',
	'v_edit_sector',
	'v_edit_node',
	'v_edit_connec',
	'v_edit_arc',
	've_pol_node',
	've_pol_connec',
	'v_edit_dimensions',
	'v_ext_municipality',
	'v_ext_address',
	'v_ext_streetaxis',
	'v_ext_plot'
);

UPDATE sys_function SET function_alias = 'CALCULATE THE REACH OF HYDRANTS' WHERE function_name = 'gw_fct_graphanalytics_hydrant';


UPDATE sys_function SET function_alias = 'REPLACE FEATURE' WHERE function_name = 'gw_fct_setchangefeaturetype';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3290, '%v_count% operative connec(s) have been reconnected', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3292, '%v_count% planned connec(s) have been reconnected', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3294, '%v_count% operative gully(s) have been reconnected', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3296, '%v_count% planned gully(s) have been reconnected', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3298, '%v_count% operative/planned links(s) have been reconnected', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'REPLACE FEATURE' WHERE function_name = 'gw_fct_setfeaturereplace';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3300, 'Replace node id in %v_count% psector', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3302, 'Downgraded old feature %v_old_id% SETTING state: 0, workcat_id_end: %v_workcat_id_end%, enddate: %v_enddate%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3304, 'Update new feature, set state: 1, workcat_id: %v_workcat_id_end% builtdate: %v_enddate%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3306, 'Common values from old feature have been updated on new feature.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3308, 'New feature %v_id% inserted into connec table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3310, 'New feature %v_id% inserted into gully table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3312, 'Assign old data from %rec_addfields.column_name% addfield to the new feature.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3314, 'Reconnect arc %rec_arc.arc_id%.', null, 0, true, 'utils', 'core', 'AUDIT');



INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3316, 'Reconnect connec %rec_connec.connec_id%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3318, 'New feature %v_id% inserted into arc table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3288, 'Replace feature done successfully', null, 0, true, 'utils', 'core', 'UI');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3322, 'Node_1 is a delimiter of a mapzone if arc was defined as toArc it has been reconfigured with new arc_id.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3320, 'Node_2 is a delimiter of a mapzone if arc was defined as toArc it has been reconfigured with new arc_id.', null, 0, true, 'utils', 'core', 'UI');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3324, 'Some of the parameters on %trigger% are not valid', null, 2, true, 'utils', 'core', 'UI');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3326, 'Some values on %array_column% don''t exist in %id_table% . %id_column%', null, 2, true, 'utils', 'core', 'UI');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3328, 'Cannot delete register because it has reference on other tables', null, 2, true, 'utils', 'core', 'UI');

UPDATE sys_function SET function_alias = 'REPLACE FEATURE' WHERE function_name = 'gw_fct_setfeaturesreplace';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3332, 'New node is a delimiter of a different mapzone type than the old node. New mapzone delimiter and old mapzone delimiter needs to be configured.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3334, 'New node is a delimiter of a mapzone that needs to be configured.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3336, 'New node is not a delimiter of a mapzone. Configuration for old node need to be removed.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3338, 'New node and old node are delimiters of the same mapzone. Configuration will be updated.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3340, 'Reconnect arc %rec_arc.arc_id%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3342, 'Reconnect %v_count% links.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3344, 'Assign %v_count% elements to the new feature.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3346, 'New feature (%v_id%) inserted into node table.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'ARC DIVIDE' WHERE function_name = 'gw_fct_setarcdivide';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3348, 'Divide arc %v_arc_id%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3350, 'Insert new arcs into arc table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3352, 'Insert new arcs into man and epa table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3354, 'Copy values from old arc: %v_arc_id% to the new arcs: (%rec_aux1.arc_id%, %rec_aux2.arc_id%).', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3356, 'Update arc_id for disconnected node: %rec_node.node_id%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3358, 'Copy %v_count% elements from old to new arcs.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3360, 'Copy %v_count% documents from old to new arcs.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3362, 'Copy %v_count% visits from old to new arcs.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3364, 'New node is a delimiter of a mapzone that needs to be configured.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3366, 'Node_1 is a delimiter of a mapzone if old arc was defined as toArc it has been reconfigured with new arc_id.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'ARC DIVIDE' WHERE function_name = 'gw_fct_setarcdivide';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3368, 'Node_2 is a delimiter of a mapzone if old arc was defined as toArc it has been reconfigured with new arc_id.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3370, 'Set old arc to obsolete: %v_arc_id%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3382, 'Delete old arc: %v_arc_id%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3384, 'Arc with state =1, node with state = 2.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3386, 'Arc and node have both state = 2.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3388, 'Insert new arcs into arc table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3390, 'Insert new arcs into man and epa table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3392, 'Update values of arcs node_1 and node_2.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3394, 'Copy values from old arc: %v_arc_id% to the new arcs: (%rec_aux1.arc_id%, %rec_aux2.arc_id%).', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3396, 'Copy elements is not avaliable from old arc to new arc when node.state = 2', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3398, 'Copy documents is not avaliable from old arc to new arcs when node.state = 2', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3400, 'Copy visits is not avaliable from old arc to new arcs when node.state = 2', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3402, 'Reconnect disconnected nodes on this alternative', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3404, 'Update arc_id for disconnected node: %rec_node.node_id%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3406, 'Update psector''s arc_id value for connec and gully setting null value to force trigger to get new arc_id as closest as possible', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3408, 'Update psector_x_arc as doable for fictitious arcs.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3410, 'Insert old arc as downgraded into current psector: %v_psector%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3412, 'Set values on plan_psector_x_arc addparam.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3414, 'Arc divide done successfully', null, 0, true, 'utils', 'core', 'UI');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3416, 'Update values of arcs node_1 and node_2.', null, 0, true, 'utils', 'core', 'AUDIT');



UPDATE sys_function SET function_alias = 'END FEATURE' WHERE function_name = 'gw_fct_setendfeature';

-- SYS_LABEL
INSERT INTO sys_label (id, idval, label_type) VALUES (1001, 'INFO', 'prefix');
INSERT INTO sys_label (id, idval, label_type) VALUES (1002, 'WARNING', 'prefix');
INSERT INTO sys_label (id, idval, label_type) VALUES (1003, 'ERROR', 'prefix');
INSERT INTO sys_label (id, idval, label_type) VALUES(1004, 'CRITICAL ERRORS', 'prefix');
INSERT INTO sys_label (id, idval, label_type) VALUES(1005, 'HINT', 'prefix');

INSERT INTO sys_label (id, idval, label_type) VALUES(2000, '', 'separator'); -- break line
INSERT INTO sys_label (id, idval, label_type) VALUES(2007, '-------', 'separator');
INSERT INTO sys_label (id, idval, label_type) VALUES(2008, '--------', 'separator');
INSERT INTO sys_label (id, idval, label_type) VALUES(2009, '---------', 'separator');
INSERT INTO sys_label (id, idval, label_type) VALUES(2010, '----------', 'separator');
INSERT INTO sys_label (id, idval, label_type) VALUES(2011, '-----------', 'separator');
INSERT INTO sys_label (id, idval, label_type) VALUES(2014, '--------------', 'separator');
INSERT INTO sys_label (id, idval, label_type) VALUES(2022, '----------------------', 'separator');
INSERT INTO sys_label (id, idval, label_type) VALUES(2025, '-------------------------', 'separator');
INSERT INTO sys_label (id, idval, label_type) VALUES(2030, '------------------------------', 'separator');
INSERT INTO sys_label (id, idval, label_type) VALUES(2049, '-------------------------------------------------', 'header');

INSERT INTO sys_label (id, idval, label_type) VALUES(3001, 'INFO', 'header');
INSERT INTO sys_label (id, idval, label_type) VALUES(3002, 'WARNINGS', 'header');
INSERT INTO sys_label (id, idval, label_type) VALUES(3003, 'ERRORS', 'header');
INSERT INTO sys_label (id, idval, label_type) VALUES(3006, 'ARC DIVIDE = TRUE', 'header');
INSERT INTO sys_label (id, idval, label_type) VALUES(3008, 'ARC DIVIDE = FALSE', 'header');
INSERT INTO sys_label (id, idval, label_type) VALUES(3009, 'RESUME', 'header');
INSERT INTO sys_label (id, idval, label_type) VALUES(3010, 'CHECK SYSTEM', 'header');
INSERT INTO sys_label (id, idval, label_type) VALUES(3011, 'CHECK DB DATA', 'header');
INSERT INTO sys_label (id, idval, label_type) VALUES (3012, 'DETAILS', 'header');


INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3418, '%v_count% additional element(s) related to the downgraded node (%v_feature_id_value%) was/were also related to another operative feature(s) (element_id: %v_element_id%)', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3420, '%v_count_feature% node(s) have been downgraded', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3422, '%v_count% additional element(s) related to the downgraded connec (%v_feature_id_value%) was/were also related to another operative feature(s) (element_id:%v_element_id%)', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3424, '%v_count_feature% connec(s) have been downgraded', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3426, '%v_count_feature% additional element(s) related to the downgraded gully (%v_feature_id_value%) was/were also related to another operative feature(s) (element_id:%v_element_id%)', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3428, '%v_count_feature% gully(s) have been downgraded', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3430, 'Process done successfully', null, 0, true, 'utils', 'core', 'UI');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3432, '%v_count% additional element(s) related to the downgraded arc (%v_feature_id_value%) was/were also related to another operative feature(s) (element_id: %v_element_id%)', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3434, '%v_count_feature% arc(s) have been downgraded', null, 0, true, 'utils', 'core', 'AUDIT');


INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('admin_schema_cm', '{"schemaName":""}', 'System parameter which identifies existing schema cm linked to a parent schemas', NULL, NULL, NULL, true, NULL, 'utils', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);



UPDATE sys_function SET function_alias = 'DELETE FEATURE' WHERE function_name = 'gw_fct_setfeaturedelete';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3436, 'Number of disconnected elements: %v_count%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3438, 'Number of disconnected visits: %v_count%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3482, 'Number of disconnected documents: %v_count%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3484, 'Number of removed scada connections: %v_count%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3486, 'Number of removed links: %v_count%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3488, 'Disconnected parent node: %v_related_id%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3490, 'Removed polygon: %v_related_id%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3492, 'Delete node: %v_feature_id%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3494, 'Disconnected arcs: %v_arc_id%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3496, 'Number of removed links related to connecs: %v_count%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3498, 'Disconnected connecs: %v_related_id%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3500, 'Disconnected nodes: %v_related_id%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3502, 'Number of removed links related to gullies: %v_count%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3504, 'Disconnected gullies: %v_related_id%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3506, 'Removed polygon: %v_related_id%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3508, 'Delete arc: %v_feature_id%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3510, 'Removed link: %v_related_id%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3512, 'Delete %v_feature_type%: %v_feature_id%', null, 0, true, 'utils', 'core', 'AUDIT');



UPDATE sys_function SET function_alias = 'ARC FUSION' WHERE function_name = 'gw_fct_setarcfusion';


INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3372, 'Fusion arcs using node: %v_exists_node_id% .', null, 0, true, 'utils', 'core', 'AUDIT');


INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3376, 'New arc have been inserted: %arc_id% .', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3378, 'Copy values for addfield: %column_name% to the new arc.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3380, 'Reconnect: %v_count% nodes.', null, 0, true, 'utils', 'core', 'AUDIT');




INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3448, 'Copy: %v_count% elements from old arcs to new one.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3450, 'Copy: %v_count% documents from old arcs to new one.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3452, 'Copy: %v_count% visits from old arcs to new one.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3454, 'Change state of node: %v_node_id% to obsolete.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3456, 'Delete node: %v_node_id%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3458, 'Delete planned node: %v_node_id%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3460, 'There are: %v_count%  orphan nodes related to existing arcs. Column arc_id remains with initial value.', null, 0, true, 'utils', 'core', 'AUDIT');


INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3462, 'Connec: %feature_id% has been reconected with new arc_id but keeping the feature exit from initial node.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3464, 'Gully: %feature_id%  has been reconected with new arc_id but keeping the feature exit from initial node.', null, 0, true, 'utils', 'core', 'AUDIT');


INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3466, 'Reconnect operative: %v_count% connecs.', null, 0, true, 'utils', 'core', 'AUDIT');



INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3470, 'Reconnect operative: %v_count% gullies.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3472, 'Delete arcs: %arc_id1% , %arc_id2% .', null, 0, true, 'utils', 'core', 'AUDIT');



INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3476, 'Reconnect planned: %v_count% connecs.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3478, 'Arc fusion done successfully', null, 0, true, 'utils', 'core', 'UI');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3374, 'Arcs related to selected node have been removed: %arc_id1% , %arc_id2% .', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'FLOWTRACE ANALYTICS' WHERE function_name = 'gw_fct_graphanalytics_flowtrace';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3516, 'Number of arcs identifed on the process: %v_count%', null, 0, true, 'utils', 'core', 'AUDIT');

-- CONFIG_TYPEVALUE

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_features_1', 'lyt_features_1', 'layoutFeatures1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_features_2', 'lyt_features_2', 'layoutFeatures1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_features_2_arc', 'lyt_features_2_arc', 'layoutFeatures1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_features_2_connec', 'lyt_features_2_connec', 'layoutFeatures1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_features_2_gully', 'lyt_features_2_gully', 'layoutFeatures1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_features_2_link', 'lyt_features_2_link', 'layoutFeatures1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_features_2_node', 'lyt_features_2_node', 'layoutFeatures1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_features_3', 'lyt_features_3', 'layoutFeatures1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_features', 'tab_features', 'tabRelationsEdit', NULL);

-- CONFIG_FORM_TABS
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('ve_genelem', 'tab_data', 'Data', 'Data', 'role_basic', NULL, '[
  {"actionName": "actionEdit", "disabled": false}
]'::json, 0, '{4}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('ve_genelem', 'tab_epa', 'EPA', 'Epa', 'role_basic', NULL, '[
  {"actionName": "actionEdit", "disabled": false}
]'::json, 1, '{4}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('ve_genelem', 'tab_documents', 'Documents', 'List of documents', 'role_basic', NULL, '[
  {"actionName": "actionEdit", "disabled": false}
]'::json, 2, '{4}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('ve_genelem', 'tab_features', 'Features', 'Manage features', 'role_basic', NULL, '[
  {"actionName": "actionEdit", "disabled": false}
]'::json, 3, '{4}');

-- CONFIG_FORM_FIELDS
-- ve_frelem_epump
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_frelem_epump', 'form_feature', 'tab_data', 'muni_id', 'lyt_data_3', 1, 'integer', 'combo', 'municipality', 'muni_id', NULL, false, false, true, false, NULL, 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 56),
('ve_frelem_epump', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 3, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 4, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''EPUMP''', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'order_id', 'lyt_data_1', 22, 'double', 'text', 'order_id', NULL, NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'node_id', 'lyt_data_1', 1, 'string', 'text', 'node_id', NULL, NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'observ', 'lyt_data_3', 0, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, true, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'nodarc_id', 'lyt_data_2', 0, 'string', 'text', 'nodarc_id', 'nodarc_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EPUMP'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EPUMP'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EPUMP'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_features', 'btn_delete', 'lyt_features_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
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
('ve_frelem_epump', 'form_feature', 'tab_features', 'btn_expr_select', 'lyt_features_1', 4, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, '{
  "saveValue": false
}'::json, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_features', 'feature_id', 'lyt_features_1', 0, 'text', 'text', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_features', 'btn_snapping', 'lyt_features_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, '{
  "saveValue": false
}'::json, '{
  "functionName": "selection_init"
}'::json, NULL, false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_features', 'tbl_element_x_arc', 'lyt_features_2_arc', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json, NULL, 'tbl_element_x_arc', false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_features', 'tbl_element_x_connec', 'lyt_features_2_connec', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json, NULL, 'tbl_element_x_connec', false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_features', 'tbl_element_x_gully', 'lyt_features_2_gully', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json, NULL, 'tbl_element_x_gully', false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_features', 'tbl_element_x_link', 'lyt_features_2_link', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json, NULL, 'tbl_element_x_link', false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_features', 'tbl_element_x_node', 'lyt_features_2_node', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json, NULL, 'tbl_element_x_node', false, NULL),
('ve_frelem_epump', 'form_feature', 'tab_features', 'btn_insert', 'lyt_features_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
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

-- ve_epa_frpump
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_epa_frpump', 'form_feature', 'tab_epa', 'curve_id', 'lyt_epa_data_1', 0, 'string', 'text', 'Curve ID', 'Curve ID', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frpump', 'form_feature', 'tab_epa', 'status', 'lyt_epa_data_1', 1, 'string', 'text', 'Status', 'Status', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frpump', 'form_feature', 'tab_epa', 'startup', 'lyt_epa_data_1', 2, 'double', 'text', 'Startup', 'Startup', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frpump', 'form_feature', 'tab_epa', 'shutoff', 'lyt_epa_data_1', 3, 'double', 'text', 'Shutoff', 'Shutoff', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frpump', 'form_feature', 'tab_epa', 'percent', 'lyt_epa_data_2', 0, 'double', 'text', 'Percent', 'Percent', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frpump', 'form_feature', 'tab_epa', 'num_startup', 'lyt_epa_data_2', 1, 'integer', 'text', 'Number of Startups', 'Number of Startups', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frpump', 'form_feature', 'tab_epa', 'min_flow', 'lyt_epa_data_2', 2, 'double', 'text', 'Minimum Flow', 'Minimum Flow', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frpump', 'form_feature', 'tab_epa', 'avg_flow', 'lyt_epa_data_2', 3, 'double', 'text', 'Average Flow', 'Average Flow', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frpump', 'form_feature', 'tab_epa', 'max_flow', 'lyt_epa_data_2', 4, 'double', 'text', 'Maximum Flow', 'Maximum Flow', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frpump', 'form_feature', 'tab_epa', 'vol_ltr', 'lyt_epa_data_2', 5, 'double', 'text', 'Volume (Liters)', 'Volume (Liters)', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frpump', 'form_feature', 'tab_epa', 'powus_kwh', 'lyt_epa_data_2', 6, 'double', 'text', 'Power Usage (kWh)', 'Power Usage (kWh)', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frpump', 'form_feature', 'tab_epa', 'timoff_min', 'lyt_epa_data_2', 7, 'double', 'text', 'Time Off Minimum', 'Time Off Minimum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frpump', 'form_feature', 'tab_epa', 'timoff_max', 'lyt_epa_data_2', 8, 'double', 'text', 'Time Off Maximum', 'Time Off Maximum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

-- ve_genelem_ecover
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_genelem_ecover', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 3, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 4, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''ECOVER''', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, true, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'observ', 'lyt_data_3', 0, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'muni_id', 'lyt_data_3', 1, 'string', 'combo', 'Municipality id:', 'muni_id - Identifier of the municipality', NULL, false, false, true, NULL, NULL, 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL', true, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_features', 'btn_delete', 'lyt_features_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
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
('ve_genelem_ecover', 'form_feature', 'tab_features', 'btn_expr_select', 'lyt_features_1', 4, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, '{
  "saveValue": false
}'::json, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_features', 'feature_id', 'lyt_features_1', 0, 'text', 'text', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_features', 'btn_snapping', 'lyt_features_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, '{
  "saveValue": false
}'::json, '{
  "functionName": "selection_init"
}'::json, NULL, false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_features', 'tbl_element_x_arc', 'lyt_features_2_arc', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json, NULL, 'tbl_element_x_arc', false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_features', 'tbl_element_x_connec', 'lyt_features_2_connec', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json, NULL, 'tbl_element_x_connec', false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_features', 'tbl_element_x_gully', 'lyt_features_2_gully', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json, NULL, 'tbl_element_x_gully', false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_features', 'tbl_element_x_link', 'lyt_features_2_link', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json, NULL, 'tbl_element_x_link', false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_features', 'tbl_element_x_node', 'lyt_features_2_node', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json, NULL, 'tbl_element_x_node', false, NULL),
('ve_genelem_ecover', 'form_feature', 'tab_features', 'btn_insert', 'lyt_features_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
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

-- ve_genelem_estep
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_genelem_estep', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''ESTEP''', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 4, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 3, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, true, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'muni_id', 'lyt_data_3', 1, 'string', 'combo', 'Municipality id:', 'muni_id - Identifier of the municipality', NULL, false, false, true, NULL, NULL, 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL', true, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'observ', 'lyt_data_3', 0, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_features', 'btn_delete', 'lyt_features_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
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
('ve_genelem_estep', 'form_feature', 'tab_features', 'btn_expr_select', 'lyt_features_1', 4, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, '{
  "saveValue": false
}'::json, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_features', 'feature_id', 'lyt_features_1', 0, 'text', 'text', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_features', 'btn_snapping', 'lyt_features_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, '{
  "saveValue": false
}'::json, '{
  "functionName": "selection_init"
}'::json, NULL, false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_features', 'tbl_element_x_arc', 'lyt_features_2_arc', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json, NULL, 'tbl_element_x_arc', false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_features', 'tbl_element_x_connec', 'lyt_features_2_connec', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json, NULL, 'tbl_element_x_connec', false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_features', 'tbl_element_x_gully', 'lyt_features_2_gully', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json, NULL, 'tbl_element_x_gully', false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_features', 'tbl_element_x_link', 'lyt_features_2_link', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json, NULL, 'tbl_element_x_link', false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_features', 'tbl_element_x_node', 'lyt_features_2_node', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json, NULL, 'tbl_element_x_node', false, NULL),
('ve_genelem_estep', 'form_feature', 'tab_features', 'btn_insert', 'lyt_features_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
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


INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3440, 'Reconnect operative: %v_count% connecs.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3442, 'Reconnect operative: %v_count% gullies.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3444, 'Reconnect planned: %v_count% connecs.', null, 0, true, 'utils', 'core', 'AUDIT');


UPDATE sys_table SET addparam='{
  "pkey": "element_id"
}'::json WHERE id='ve_genelem_estep';
UPDATE sys_table SET addparam='{
  "pkey": "element_id"
}'::json WHERE id='ve_genelem_eprotector';
UPDATE sys_table SET addparam='{
  "pkey": "element_id"
}'::json WHERE id='ve_genelem_eiot_sensor';
UPDATE sys_table SET addparam='{
  "pkey": "element_id"
}'::json WHERE id='ve_genelem_egate';
UPDATE sys_table SET addparam='{
  "pkey": "element_id"
}'::json WHERE id='ve_genelem_ecover';



UPDATE sys_function SET function_alias = 'ARC REVERSE FUNCTION' WHERE function_name = 'gw_fct_setarcreverse';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3562, 'No arcs have been selected', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3564, 'Selection mode ''Whole selection'' is not enabled in this function', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3566, 'Direction of %v_count% arcs has been changed.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3568, 'Reversed arcs: %v_array%', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'ARC LENGTH ANALYSIS' WHERE function_name = 'gw_fct_anl_arc_length';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3570, 'There are no arcs shorter than %v_arclength% meters.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3572, 'There are %v_count% arcs shorter than %v_arclength% meters.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'ARC DUPLICATED ANALYSIS' WHERE function_name = 'gw_fct_anl_arc_duplicated';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3574, 'There are no duplicated arcs.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3576, 'There are %v_count% duplicated arcs.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'ARC WITH SAME START - END NODE ANALYSIS' WHERE function_name = 'gw_fct_anl_arc_same_startend';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3578, 'There are no arcs with same start - end node.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3580, 'There are %v_count% arcs with same start - end nodes.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'ARC WITHOUT END NODES ANALYSIS' WHERE function_name = 'gw_fct_anl_arc_no_startend_node';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3582, 'There are no arcs without final nodes.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3584, 'Value of search nodes automatically set to %v_arcsearchnodes%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3586, 'There are %v_count_state1% arcs with state 1 without final nodes.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3588, 'There are %v_count_state2% arcs with state 2 without final nodes.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'CONNEC DUPLICATED ANALYSIS' WHERE function_name = 'gw_fct_anl_connec_duplicated';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3590, 'There are no duplicated connecs.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3592, 'There are %v_count% duplicated connecs.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'NODE DUPLICATED ANALYSIS' WHERE function_name = 'gw_fct_anl_node_duplicated';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3598, 'There are no duplicated nodes.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3600, 'There are %v_count% duplicated nodes.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_link', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 7, 'integer', 'combo', 'State type', 'state_type - The state type of the element. It allows to obtain more detail of the state. To select from those available depending on the chosen state', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, 'state', ' AND value_state_type.state', NULL, '{"setMultiline":false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL);
UPDATE sys_function SET function_alias = 'NODE ORPHAN (OM) ANALYSIS' WHERE function_name = 'gw_fct_anl_node_orphan';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3602, 'There are no orphan nodes.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3604, 'There are %v_count1% orphan nodes with isarcdivide=TRUE.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3606, 'There are %v_count2% orphan nodes with isarcdivide=FALSE.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3608, 'There are no orphan nodes with isarcdivide=FALSE.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'NODES T CANDIDATES ANALYSIS' WHERE function_name = 'gw_fct_anl_node_tcandidate';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3610, 'There are no nodes T candidates.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3612, 'There are %v_count% nodes T candidates.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'GET ADDRESS VALUES FROM CLOSEST STREET NUMBER' WHERE function_name = 'gw_fct_setclosestaddress';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3614, 'There are %affected_rows% %v_feature_type% address values updated.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'MASSIVE NODE ROTATION VALUES UPDATE' WHERE function_name = 'gw_fct_setnoderotation';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3616, 'This process works capturing compass values from arc in order to propagate to nodes.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3618, 'In case of arcs with different compass an average value is calculated.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3620, '%v_affectedrow% arcs have been analized and their compass values have been progagated to node rotation', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3622, '%count% %feature_type%S have been updated, which are the following:', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3624, 'ELEVATION UPDATED - FEATURE TYPE:%feature_type% ID: %feature_id%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3626, 'Intersection with feature %feature_id% has returned NULL value. Could be out of raster or some problem with algorithm', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3628, 'There are no features with NULL elevation', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3630, 'It is impossible to carry out the process. Your config_param_system variable for Raster DEM is in FALSE.', null, 0, true, 'utils', 'core', 'AUDIT');


UPDATE config_form_fields SET widgetfunction='{
  "functionName": "delete_manager_item",
  "parameters": {
    "sourcetable": "element",
    "targetwidget": "tab_none_tbl_element",
    "field_object_id": "element_id"
  }
}'::json WHERE formname='element_manager' AND formtype='form_element' AND columnname='delete' AND tabname='tab_none';



UPDATE sys_function SET function_alias = 'REPAIR NODES DUPLICATED' WHERE function_name = 'gw_fct_repair_node_duplicated';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3640, 'Process failed', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3642, 'Check your nodes id''s because there is no duplicated scenario.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3644, 'Value for target node is optative, If null system will try to check closest node.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3646, 'Removing node %v_node% -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3648, 'Duplicated node %v_targetnode% exists using system node tolerance %v_nodetolerance%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3650, 'Transfer topology to node %v_targetnode% -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3652, 'Downgrade node %v_node% to state 0 -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3654, 'Moving node %v_node% -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3656, 'Keeping topology -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3658, 'Transfer topology from node %v_targetnode% -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3660, 'No nodes have been selected', NULL, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'CREATE EMPTY DSCENARIO' WHERE function_name = 'gw_fct_create_dscenario_empty';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3662, 'Name: %v_name%', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3664, 'Descript: %v_descript%', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3666, 'Parent: %v_parent_id%', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3668, 'Type: %v_dscenario_type%', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3670, 'active: %v_active%', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3672, 'The dscenario (%v_scenarioid%) already exists with proposed name %v_name%. Please try another one.', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3674, 'The new dscenario have been created sucessfully', NULL, 0, true, 'utils', 'core', 'AUDIT');

UPDATE config_form_tableview SET visible=true WHERE objectname='tbl_element_x_arc' AND columnname='arc_id';
UPDATE config_form_tableview SET visible=true WHERE objectname='tbl_element_x_connec' AND columnname='connec_id';
UPDATE config_form_tableview SET visible=true WHERE objectname='tbl_element_x_link' AND columnname='link_id';
UPDATE config_form_tableview SET visible=true WHERE objectname='tbl_element_x_node' AND columnname='node_id';


UPDATE config_form_fields SET widgetfunction='{
  "functionName": "delete_manager_item",
  "parameters": {
    "sourcetable": "v_ui_element",
    "targetwidget": "tab_none_tbl_element",
    "field_object_id": "id"
  }
}'::json WHERE formname='element_manager' AND formtype='form_element' AND columnname='delete' AND tabname='tab_none';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}'::json WHERE formname='arc' AND formtype='form_feature' AND columnname='tbl_elements' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}'::json WHERE formname='arc' AND formtype='form_feature' AND columnname='open_element' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}'::json WHERE formname='node' AND formtype='form_feature' AND columnname='tbl_elements' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}'::json WHERE formname='node' AND formtype='form_feature' AND columnname='open_element' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}'::json WHERE formname='connec' AND formtype='form_feature' AND columnname='tbl_elements' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}'::json WHERE formname='connec' AND formtype='form_feature' AND columnname='open_element' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}'::json WHERE formname='v_edit_link' AND formtype='form_feature' AND columnname='tbl_elements' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}'::json WHERE formname='v_edit_link' AND formtype='form_feature' AND columnname='open_element' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}'::json WHERE formname='ve_link_link' AND formtype='form_feature' AND columnname='tbl_elements' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}'::json WHERE formname='ve_link_link' AND formtype='form_feature' AND columnname='open_element' AND tabname='tab_elements';


UPDATE config_form_fields SET "label"='Maximum Pipe diameter:', tooltip='Maximum Pipe diameter' WHERE formname='generic' AND formtype='link_to_connec' AND columnname='pipe_diameter' AND tabname='tab_none';

UPDATE config_toolbox SET
inputparams='[
{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text","tooltip": "Choose exploitation to work with", "layoutname":"grl_option_parameters","layoutorder":1, 
"dvQueryText":"SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC", "selectedId":"$userExploitation"},
{"widgetname": "usePlanPsector", "label": "Use masterplan psectors:", "widgettype": "check", "datatype": "boolean", "layoutname": "grl_option_parameters", "layoutorder": 6, "value": ""}, 
{"widgetname": "commitChanges", "label": "Commit changes:", "widgettype": "check", "datatype": "boolean", "layoutname": "grl_option_parameters", "layoutorder": 7, "value": ""}, 
{"widgetname": "updateMapZone", "label": "Update mapzone geometry method:", "widgettype": "combo", "datatype": "integer", "layoutname": "grl_option_parameters", "layoutorder": 8, "comboIds": [0, 1, 2, 3], "comboNames": ["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER"], "selectedId": ""}, 
{"widgetname": "geomParamUpdate", "label": "Geometry parameter:", "widgettype": "text", "datatype": "float", "layoutname": "grl_option_parameters", "layoutorder": 10, "isMandatory": false, "placeholder": "5-30", "value": ""}]'::json
WHERE id=2706;

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formactions_typevalue', 'actionSetGeom', 'Set Geom', NULL, NULL);

UPDATE config_form_tabs SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionSetGeom",
    "disabled": false
  }
]'::json WHERE formname='ve_genelem' AND tabname='tab_data';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {}
}'::json WHERE formname='element_manager' AND formtype='form_element' AND columnname='create' AND tabname='tab_none';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {}
}'::json WHERE formname='arc' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {}
}'::json WHERE formname='node' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {}
}'::json WHERE formname='connec' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {}
}'::json WHERE formname='v_edit_link' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {}
}'::json WHERE formname='ve_link_link' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';


INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3696, 'ERROR: The dscenario ( %v_scenarioid% ) already exists with proposed name %v_name%. Please try another one.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3698, 'ERROR: The table chosen does not fit with any epa dscenario. Please try another one.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3700, 'Process done successfully.', null, 0, true, 'utils', 'core', 'AUDIT');


UPDATE config_toolbox SET inputparams='[
  {
    "widgetname": "exploitation",
    "label": "Exploitation ids:",
    "widgettype": "combo",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "select expl_id as id, name as idval from exploitation where active is not false order by name",
    "selectedId": "1"
  }
]'::json WHERE id=2826;
UPDATE sys_function SET function_alias = 'DUPLICATE DSCENARIO' WHERE function_name = 'gw_fct_duplicate_dscenario';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3714, 'Copy from: %v_copyfrom%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3716, 'Expl: %v_expl_id%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3718, 'Dscenario named "%v_name%" created with values from dscenario ( %v_copyfrom% )', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3720, 'Copied values from dscenario ( %v_copyfrom% ) to new dscenario ( %v_scenarioid% )', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'MANAGE DSCENARIO VALUES' WHERE function_name = 'gw_fct_manage_dscenario_values';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3724, 'Target and source are the same.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3726, 'Target scenario: %v_target_name%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3728, 'Action: %v_action%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3730, 'Copy from scenario: %v_source_name%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3732, 'Dscenario type for target and source is not the same.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3734, 'Target and source have the same dscenario_type.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3736, '%v_count% row(s) has/have been removed from inp_dscenario_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3738, 'There was/were %v_count% row(s) related to this dscenario which has/have been keep on table inp_dscenario_ %object_rec%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3740, 'No rows have been inserted on inp_dscenario_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3742, '%v_count2% row(s) has/have been inserted on inp_dscenario_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3744, '%v_count% row(s) have been removed from inp_dscenario_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3746, '%v_count% row(s) have been keep from inp_dscenario_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3748, 'No rows have been inserted on inp_dscenario_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3750, '%v_count2% row(s) have been inserted on inp_dscenario_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3752, '1 row(s) has/have been removed from cat_dscenario table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3754, 'PROCESS HAS FAILED......', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_label (id, idval, label_type) VALUES(1006, 'WARNING-403', 'prefix');

INSERT INTO sys_label (id, idval, label_type) VALUES(1007, 'ERROR-403', 'prefix');

INSERT INTO sys_label (id, idval, label_type) VALUES(1008, 'ERROR-357', 'prefix');

--
UPDATE sys_function SET function_alias = 'FEATURE RELATIONS' WHERE function_name = 'gw_fct_getfeaturerelation';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3676, 'Connecs connected with the feature : %v_connect_connec%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3678, 'Gullies connected with the feature : %v_connect_gully%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3680, 'Nodes connected with the feature: %v_connect_node%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3682, 'Nodes connected with the feature: %v_connect_node%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3684, 'Arcs connected with the feature (on service): %v_connect_arc%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3686, 'Arcs connected with the feature (obsolete): %v_connect_arc%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3688, 'Polygon connected with the feature: %v_connect_pol%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3690, 'Links connected with the feature : %v_connect_connec%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3692, 'Gullies connected with the feature : %v_connect_gully%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3480, 'Polygon connected with the feature: %v_connect_pol%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3518, 'Elements connected with the feature: %v_element%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3520, 'Visits connected with the feature: %v_visit%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3522, 'Documents connected with the feature: %v_doc%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3524, 'Psectors connected with the feature: %,v_psector%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3526, 'IMPORTANT: Activate psector before deleting features.', null, 0, true, 'utils', 'core', 'AUDIT');

--
UPDATE sys_function SET function_alias = 'ARC REPAIR FUNCTION' WHERE function_name = 'gw_fct_arc_repair';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3528, 'Repaired arcs: arc_id --> %arc_ids%', null, 0, true, 'utils', 'core', 'AUDIT');

DELETE FROM sys_table WHERE id='v_ui_om_visit_x_doc';
UPDATE sys_table SET sys_role='role_om' WHERE id='v_ui_doc_x_visit';
UPDATE sys_table SET sys_role='role_plan' WHERE id='doc_x_psector';
UPDATE sys_table SET sys_role='role_plan' WHERE id='v_ui_doc_x_psector';


UPDATE config_form_fields SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element",
    "targetwidget": "tbl_element",
    "field_object_id": "id"
  }
}'::json WHERE formname='element_manager' AND formtype='form_element' AND columnname='create' AND tabname='tab_none';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_arc",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}'::json WHERE formname='arc' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_arc",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}'::json WHERE formname='node' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_arc",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}'::json WHERE formname='v_edit_link' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_arc",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}'::json WHERE formname='ve_link_link' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';

UPDATE sys_function SET function_alias = 'MERGE PSECTOR' WHERE function_name = 'gw_fct_psector_merge';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3778, 'Deactivate topology control for connecs and gullies.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3780, 'Psectors must have the same priority, status, psector_type and expl_id to be merged.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3782, 'Create psector %v_new_psector_id% as %v_new_psector_name%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3784, 'Copied arcs with state 0: %v_list_features_obsolete%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3786, 'Copied nodes with state 0: %v_list_features_obsolete%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3788, 'Copied connecs with state 0: %v_list_features_obsolete%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3790, 'Copied connecs with state 1 (doable false): %v_list_connec_undoable%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3792, 'Copied gullies with state 0: %v_list_features_obsolete%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3794, 'Copied gullies with state 1: %v_list_gully_undoable%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3796, 'Copied other prices: %v_list_features_obsolete%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3798, 'Set %v_new_psector_name% as current psector.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3902, 'New %rec_type.id% inserted with state 1: %v_list_features_obsolete%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('project_type', '1', 'Basic', 'Basic', NULL);

-- check project messages
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4100, 'Giswater version: %version%', null, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4102, 'Version of plugin is different than the database version. DB: %version%, plugin: %qgis_version%.', null, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4104, 'PostgreSQL version: %version%', null, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4106, 'PostGIS version: %postgis_version%', null, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4108, 'QGIS version: %qgis_version%', null, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4110, 'O/S version: %os_version%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4112, 'Log volume (User folder): %logfoldervolume%', null, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4114, 'QGIS variables: gwProjectType: %v_qgis_project_type%, gwInfoType: %v_infotype%, gwProjectRole: %v_projectrole%, gwMainSchema: %v_mainschema%, gwAddSchema: %v_addschema%', null, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4116, 'Logged as %current_user% on %now%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4118, 'There is/are %v_count% layers that come from differen host: %v_layer_list%.', null, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4120, 'All layers come from current host', null, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4122, 'There is/are %v_count% layers that come from different database: %v_layer_list%.', null, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4124, 'All layers come from current database', null, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4126, 'There is/are %v_count% layers that come from different schema: %v_layer_list%.', null, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4128, 'All layers come from current schema', null, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4130, 'There is/are %v_count% layers that have been added by different user: %v_layer_list%.', null, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4132, 'All layers have been added by current user', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4134, 'Set feature state = 1 for addschema and user', null, 0, true, 'utils', 'core', 'AUDIT');


UPDATE sys_function SET function_alias = 'RESET USER PROFILE FUNCTION' WHERE function_name = 'gw_fct_admin_role_resetuserprofile';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3816, 'INFO: User %v_user% have been copied from %v_copyfromuser% values', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3818, 'INFO: User parameters and BASIC selectors have been copied (selector_state, selector_expl, selector_hydrometer, selector_workcat)', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3820, 'INFO: OM selectors have been copied (selector_audit, selector_date)', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3822, 'INFO: OM-WS selectors have been copied (selector_mincut_result)', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3824, 'INFO: There is no specific selectors for role_edit', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3826, 'INFO: EPA selectors have been copied (selector_sector, selector_rpt_main, selector_inp_result, selector_rpt_compare)', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3828, 'INFO: EPA-UD selectors have been copied (selector_rpt_main_tstep, selector_rpt_compare_tstep)', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3830, 'INFO: EPA-WS selectors have been copied (selector_inp_dscenario, selector_rpt_compare_tstep, selector_rpt_main_tstep)', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3832, 'INFO: Plan selectors have been copied (selector_plan_result, selector_psector)', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3834, 'ERROR-358: User and copied User has not the same role', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3836, 'ERROR-358: Copied user does not exist', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3838, 'INFO: User %v_user% have been reset', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3840, 'INFO: User parameters and BASIC selectors have been reset (selector_state, selector_expl, selector_hydrometer, selector_workcat)', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3842, 'ERROR-358: User does not exist', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'TOPOCONTROL FOR DATA MIGRATION' WHERE function_name = 'gw_fct_admin_manage_migra';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3904, 'Migration mode activated. Topocontrol is disabled', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3906, 'Work mode activated. Topocontrol is enabled', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'IMPORT FLOWMETER AGGREGATED VALUES FILE' WHERE function_name = 'gw_fct_import_scada_flowmeteragg_values';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3908, 'Reading values from temp_csv table -> Done!', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3910, 'Inserting values on ext_rtc_scada_x_data table -> Done!', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3912, 'Deleting values from temp_csv -> Done!', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3914, 'Refactorize value to one value per day -> Done!', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3916, 'Process finished with %i% rows inserted.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3918, 'Data from %v_count% scada tags have been imported.', null, 0, true, 'utils', 'core', 'AUDIT');



UPDATE sys_function SET function_alias = 'IMPORT HYDRO X DATA' WHERE function_name = 'gw_fct_import_hydrometer_x_data';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3928, 'Inserting values on ext_rtc_hydrometer_x_data table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3930, 'Deleting values from temp_csv -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3932, 'Process finished with %i% rows inserted.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3426, 'gw_fct_cm_integrate_production', 'utils', 'function', NULL, 'json', 'Function to integrate an specific campaign from campaign manage into production schema', 'role_admin', NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3428, 'gw_fct_cm_check_fprocess', 'utils', 'function', 'json', 'json', 'Executes a data validation rule, logs the outcome, and saves any violations to an exception table for review', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3430, 'gw_fct_cm_create_logreturn', 'utils', 'function', 'json', 'json', 'Retrieves data quality audit results as either a list of messages or a GeoJSON FeatureCollection for visualizing offending geometries', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3432, 'gw_fct_cm_getcampaign', 'utils', 'function', 'json', 'json', 'Builds and returns a dynamic form definition, including fields and values, for creating a new work campaign or editing an existing one', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3434, 'gw_fct_cm_getcmteam', 'utils', 'function', 'json', 'json', 'Fetches a list of work teams for a given campaign, filtering them by role based on the campaign''s managing organization', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3436, 'gw_fct_cm_get_dialog', 'utils', 'function', 'json', 'json', 'Builds a complete, data-driven dialog definition. It fetches fields, layouts, and tabs for a given form, and populates it with existing data for editing or default values for creation', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3438, 'gw_fct_cm_getformfields', 'utils', 'function', 'character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, json', 'text []', 'Fetches a detailed array of field definitions for a specific form, dynamically building complex properties for widgets like combo boxes, handling dependencies, default values, and role-based visibility', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3440, 'gw_fct_cm_getlot', 'utils', 'function', 'json', 'json', 'Saves a campaign lot by either inserting a new record or updating an existing one. It dynamically maps all provided fields and configures user access permissions in selector_lot upon creation', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3442, 'gw_fct_cm_getselectors', 'utils', 'function', 'json', 'json', 'Builds a complete, multi-tab selector interface. It dynamically generates each tab and its selectable items based on extensive database configurations, user roles, and current selections', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3444, 'gw_fct_cm_getworkorder', 'utils', 'function', 'json', 'json', 'Builds and returns a dynamic form definition for creating a new work order or editing an existing one', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3446, 'gw_fct_cm_json_object_delete_keys', 'utils', 'function', 'json, text[]', 'json', 'A simple utility function that removes one or more specified keys from a JSON object', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3448, 'gw_fct_cm_json_object_set_key', 'utils', 'function', 'json, text, anyelement', 'json', 'A utility function that adds a new key-value pair to a JSON object or updates the value of an existing key', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3450, 'gw_fct_cm_setcampaign', 'utils', 'function', 'json', 'json', 'Saves a work campaign by either inserting or updating the main record and its corresponding subtype (review or visit). It also configures user access permissions in selector_campaign', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3452, 'gw_fct_cm_setlot', 'utils', 'function', 'json', 'json', 'Saves a campaign lot by either inserting a new record or updating an existing one. It dynamically maps all provided fields and configures user access permissions in selector_lot upon creation', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3454, 'gw_fct_cm_setselectors', 'utils', 'function', 'json', 'json', 'Updates user selections in a selector table based on UI interactions (like checking a box or clicking ''select all'') and then immediately calls its getter counterpart (gw_fct_cm_getselectors) to return the refreshed state of the entire selector dialog', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3456, 'gw_fct_cm_setworkorder', 'utils', 'function', 'json', 'json', 'Saves a work order by dynamically inserting a new record or updating an existing one, mapping all provided fields from a JSON object to the table columns', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3458, 'gw_trg_cm_edit_cat_team', 'utils', 'trigger', NULL, NULL, 'A trigger function that intercepts DML operations (INSERT, UPDATE, DELETE) on a view and applies them to the underlying cat_team table. NOTE: This trigger is critically flawed as it references non-existent columns and will not work correctly', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3460, 'gw_trg_cm_log', 'utils', 'trigger', NULL, NULL, 'A generic trigger function that logs detailed changes (INSERT, UPDATE, DELETE) for a table into cm_log. It captures which columns were changed, their old and new values, and contextual information about the operation, such as the mission and feature type', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3462, 'gw_trg_cm_om_visit_lotmanage', 'utils', 'trigger', NULL, NULL, 'Manages the status of work lots and their contents. It automatically updates statuses when visits are created or completed, and adds unplanned items to a user''s current work lot', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3464, 'gw_trg_cm_update_selectors', 'utils', 'trigger', NULL, NULL, 'A trigger function intended to automatically update the selector_campaign and selector_campaign_lot tables. It populates these tables with the correct user permissions when a campaign or lot is created, updated, or deleted, ensuring users only see items relevant to their role and organization. NOTE: This function has critical bugs and will fail to execute as written', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3466, 'gw_trg_cm_edit_feature', 'utils', 'trigger', NULL, NULL, 'Intercepts DML operations on a view, packages the changed data and context into a JSON object, and forwards it to a centralized function (gw_fct_admin_dynamic_trigger) for processing. It also populates default values for new records', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3468, 'gw_fct_cm_polygon_geom', 'utils', 'function', 'json', 'json', 'Calculates the geometry of a campaign/lot by creating a bounding polygon that encompasses all the network elements contained within it.', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3470, 'gw_fct_cm_setcheckproject', 'utils', 'function', 'json', 'json', 'Creates a data quality audit by executing all active validation rules for the project. It then aggregates the results, including error messages and the geometries of failing features, into a single report', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3472, 'gw_trg_cm_campaign_x_feature_validate_type', 'utils', 'trigger', NULL, NULL, 'A conditional trigger that validates if a feature can be added to a campaign. It checks the feature''s specific type (e.g., ''PIPE'', ''VALVE'') against a predefined list of allowed types for that campaign''s review class. If the type is not allowed, the insertion is silently canceled', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3474, 'gw_trg_cm_edit_view_campaign_lot', 'utils', 'trigger', NULL, NULL, 'An INSTEAD OF UPDATE trigger for a view that redirects updates to the appropriate underlying table (om_campaign_x_<feature>). It updates specific fields like status and observations while also maintaining a rich audit trail. NOTE: This trigger is critically flawed due to a hardcoded column name and will only function correctly for ''node'' features', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3476, 'gw_trg_cm_edit_view_campaign', 'utils', 'trigger', NULL, NULL, 'An INSTEAD OF UPDATE trigger for a view that redirects updates of status and observation fields to the appropriate underlying table (om_campaign_x_<feature>). NOTE: This trigger is critically flawed due to a hardcoded column name and will only function correctly for ''node'' features', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3478, 'gw_trg_cm_lot_x_feature_check_campaign', 'utils', 'trigger', NULL, NULL, 'A validation trigger that ensures a feature can only be added to a work lot if that same feature is also part of the lot''s parent campaign. If the feature is not in the campaign, the insertion into the lot is silently canceled', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3480, 'gw_trg_cm_lot_x_feature', 'utils', 'trigger', NULL, NULL, 'Automatically copies feature data to a denormalized table when a feature is added to a work lot, and deletes it upon removal. NOTE: The INSERT logic is flawed', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3490, 'gw_trg_cm_feature_geom', 'utils', 'trigger', NULL, NULL, 'Update geometry values from child view into campaign table. Specific trigger because this process is too complex for dynamic trigger', NULL, NULL, 'core', NULL);

UPDATE sys_function SET function_alias = 'IMPORT INP CURVES' WHERE function_name = 'gw_fct_import_inp_curve';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3934, 'Checking exisiting curve id on table inp_curve -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3936, 'Curve id (%rec_csv.csv1%) have been imported succesfully', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3938, 'Curve id (%rec_csv.csv1%) already exists on inp_curve -> Import have been canceled for this curve', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device)
VALUES(3426, 'Integrate campaign into production', '{"featureType":[]}'::json,
'[{"widgetname": "campaignId", "label": "Campaign:", "widgettype": "combo", "datatype": "text", "tooltip": "Campaign to be inserted into production environment", "layoutname": "grl_option_parameters", "layoutorder": 1, "dvQueryText": "select campaign_id as id, name as idval from cm.om_campaign WHERE status = 8 order by name", "isNullValue": "true", "selectedId": ""}]', NULL, true, '{4}');

UPDATE sys_function SET function_alias = 'IMPORT INP PATTERNS' WHERE function_name = 'gw_fct_import_inp_pattern';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3940, 'Checking exisiting pattern id on table inp_pattern -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3942, 'Pattern id (%rec_csv.csv1%) have been imported succesfully', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3944, 'Pattern id (%rec_csv.csv1%) already exists on inp_pattern -> Import have been canceled for this pattern', null, 0, true, 'utils', 'core', 'AUDIT');


INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3844, 'IMPORT SCADA VALUES FILE', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3846, 'IMPORT FLOWMETER DAILY VALUES FILE', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3848, 'Reading values from temp_csv table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3850, 'Inserting values on ext_rtc_scada_x_data table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3852, 'Deleting values from temp_csv -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3854, 'Process finished with %i% rows inserted.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3856, 'Data from %v_count% scada tags have been imported.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3446, 'Reconnect planned: %v_count% gullies.', null, 0, true, 'utils', 'core', 'AUDIT');



INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3474, 'Reconnect planned: %v_count% gullies.', null, 0, true, 'utils', 'core', 'AUDIT');



UPDATE sys_function SET function_alias = 'IMPORT CAT FEATURE' WHERE function_name = 'gw_fct_import_cat_feature';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3946, 'Inserting values on cat_feature table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3948, 'Process finished', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'IMPORT ELEMENTS FILE' WHERE function_name = 'gw_fct_import_elements';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3950, 'Inserting values on element table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3952, 'Inserting values on %v_featuretable% table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');


UPDATE sys_table SET descript='Specific view for general elements', project_template='{"template": [1], "visibility": true, "levels_to_read": 3}'::jsonb, context='{"levels": ["INVENTORY", "NETWORK", "ELEMENT"]}', orderby=1, alias='General Elements', "source"='core', addparam='{"pkey": "element_id"}'::json WHERE id='ve_genelem';
UPDATE sys_table SET descript='Specific view for flowregulator elements', project_template='{"template": [1], "visibility": true, "levels_to_read": 3}'::jsonb, context='{"levels": ["INVENTORY", "NETWORK", "ELEMENT"]}', orderby=2, alias='Flow regulator Elements', "source"='core', addparam='{"pkey": "element_id"}'::json WHERE id='ve_frelem';

UPDATE sys_style
	SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.22.3-Białowieża" styleCategories="Symbology|Labeling" labelsEnabled="1" hasScaleBasedVisibilityFlag="1" minScale="5000">
  <renderer-v2 type="singleSymbol" referencescale="-1" enableorderby="0" symbollevels="0" forceraster="0">
    <symbols>
      <symbol name="0" type="line" clip_to_extent="1" force_rhr="0" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleLine" enabled="1" locked="1" pass="0">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="round" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="round" name="joinstyle" type="QString"/>
            <Option value="0,0,0,51" name="line_color" type="QString"/>
            <Option value="dash" name="line_style" type="QString"/>
            <Option value="0.6" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <prop k="align_dash_pattern" v="0"/>
          <prop k="capstyle" v="round"/>
          <prop k="customdash" v="5;2"/>
          <prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="customdash_unit" v="MM"/>
          <prop k="dash_pattern_offset" v="0"/>
          <prop k="dash_pattern_offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="dash_pattern_offset_unit" v="MM"/>
          <prop k="draw_inside_polygon" v="0"/>
          <prop k="joinstyle" v="round"/>
          <prop k="line_color" v="0,0,0,51"/>
          <prop k="line_style" v="dash"/>
          <prop k="line_width" v="0.6"/>
          <prop k="line_width_unit" v="MM"/>
          <prop k="offset" v="0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="ring_filter" v="0"/>
          <prop k="trim_distance_end" v="0"/>
          <prop k="trim_distance_end_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="trim_distance_end_unit" v="MM"/>
          <prop k="trim_distance_start" v="0"/>
          <prop k="trim_distance_start_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="trim_distance_start_unit" v="MM"/>
          <prop k="tweak_dash_pattern_on_corners" v="0"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style blendMode="0" fieldName="name" useSubstitutions="0" fontStrikeout="0" multilineHeight="1" fontItalic="0" textOpacity="1" capitalization="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" previewBkgrdColor="255,255,255,255" textColor="0,0,0,255" fontKerning="1" namedStyle="Normal" fontWordSpacing="0.1875" allowHtml="0" fontLetterSpacing="0.1875" fontFamily="Arial" isExpression="0" fontUnderline="0" fontSizeUnit="Point" fontWeight="50" fontSize="8.25" legendString="Aa" textOrientation="horizontal">
        <families/>
        <text-buffer bufferSize="1" bufferDraw="1" bufferOpacity="1" bufferBlendMode="0" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferColor="255,255,255,255" bufferJoinStyle="128" bufferSizeUnits="MM" bufferNoFill="0"/>
        <text-mask maskSize="0" maskJoinStyle="128" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskType="0" maskOpacity="1" maskEnabled="0" maskSizeUnits="MM" maskedSymbolLayers=""/>
        <background shapeSizeUnit="MM" shapeBorderWidth="0" shapeJoinStyle="64" shapeSizeY="0" shapeOffsetY="0" shapeRadiiX="0" shapeRotation="0" shapeSVGFile="" shapeOffsetUnit="MM" shapeFillColor="255,255,255,255" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiUnit="MM" shapeOpacity="1" shapeRadiiY="0" shapeSizeX="0" shapeDraw="0" shapeOffsetX="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeSizeType="0" shapeBorderColor="128,128,128,255" shapeBlendMode="0" shapeRotationType="0" shapeType="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeBorderWidthUnit="MM">
          <symbol name="markerSymbol" type="marker" clip_to_extent="1" force_rhr="0" alpha="1">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="152,125,183,255" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="35,35,35,255" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="2" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <prop k="angle" v="0"/>
              <prop k="cap_style" v="square"/>
              <prop k="color" v="152,125,183,255"/>
              <prop k="horizontal_anchor_point" v="1"/>
              <prop k="joinstyle" v="bevel"/>
              <prop k="name" v="circle"/>
              <prop k="offset" v="0,0"/>
              <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="offset_unit" v="MM"/>
              <prop k="outline_color" v="35,35,35,255"/>
              <prop k="outline_style" v="solid"/>
              <prop k="outline_width" v="0"/>
              <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="outline_width_unit" v="MM"/>
              <prop k="scale_method" v="diameter"/>
              <prop k="size" v="2"/>
              <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="size_unit" v="MM"/>
              <prop k="vertical_anchor_point" v="1"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
          <symbol name="fillSymbol" type="fill" clip_to_extent="1" force_rhr="0" alpha="1">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer class="SimpleFill" enabled="1" locked="0" pass="0">
              <Option type="Map">
                <Option value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale" type="QString"/>
                <Option value="255,255,255,255" name="color" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="128,128,128,255" name="outline_color" type="QString"/>
                <Option value="no" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="solid" name="style" type="QString"/>
              </Option>
              <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="color" v="255,255,255,255"/>
              <prop k="joinstyle" v="bevel"/>
              <prop k="offset" v="0,0"/>
              <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="offset_unit" v="MM"/>
              <prop k="outline_color" v="128,128,128,255"/>
              <prop k="outline_style" v="no"/>
              <prop k="outline_width" v="0"/>
              <prop k="outline_width_unit" v="MM"/>
              <prop k="style" v="solid"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </background>
        <shadow shadowOffsetGlobal="1" shadowRadiusUnit="MM" shadowOffsetDist="1" shadowOffsetUnit="MM" shadowUnder="0" shadowColor="0,0,0,255" shadowRadiusAlphaOnly="0" shadowBlendMode="6" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowRadius="1.5" shadowOpacity="0.69999999999999996" shadowDraw="0" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowScale="100" shadowOffsetAngle="135"/>
        <dd_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </dd_properties>
        <substitutions/>
      </text-style>
      <text-format rightDirectionSymbol=">" decimals="3" wrapChar="" leftDirectionSymbol="&lt;" formatNumbers="0" addDirectionSymbol="0" useMaxLineLengthForAutoWrap="1" reverseDirectionSymbol="0" autoWrapLength="0" placeDirectionSymbol="0" multilineAlign="0" plussign="0"/>
      <placement polygonPlacementFlags="2" priority="5" repeatDistance="0" repeatDistanceUnits="MM" offsetType="0" geometryGeneratorEnabled="0" offsetUnits="MapUnit" layerType="LineGeometry" centroidWhole="0" dist="0" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" quadOffset="4" distMapUnitScale="3x:0,0,0,0,0,0" lineAnchorType="0" lineAnchorPercent="0.5" rotationUnit="AngleDegrees" geometryGenerator="" lineAnchorClipping="0" fitInPolygonOnly="0" placementFlags="9" yOffset="0" geometryGeneratorType="PointGeometry" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" preserveRotation="1" overrunDistanceUnit="MM" xOffset="0" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" centroidInside="0" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" rotationAngle="0" overrunDistance="0" distUnits="MM" maxCurvedCharAngleIn="25" placement="2" maxCurvedCharAngleOut="-25"/>
      <rendering minFeatureSize="0" obstacleType="0" mergeLines="0" scaleMin="1" fontLimitPixelSize="0" unplacedVisibility="0" displayAll="0" upsidedownLabels="0" drawLabels="1" labelPerPart="0" scaleMax="10000000" limitNumLabels="0" fontMaxPixelSize="10000" scaleVisibility="0" obstacleFactor="0.59999999999999998" maxNumLabels="2000" obstacle="1" fontMinPixelSize="3" zIndex="0"/>
      <dd_properties>
        <Option type="Map">
          <Option value="" name="name" type="QString"/>
          <Option name="properties" type="Map">
            <Option name="Size" type="Map">
              <Option value="true" name="active" type="bool"/>
              <Option value="var(''map_scale'')" name="expression" type="QString"/>
              <Option name="transformer" type="Map">
                <Option name="d" type="Map">
                  <Option value="1" name="exponent" type="double"/>
                  <Option value="4" name="maxOutput" type="double"/>
                  <Option value="3000" name="maxValue" type="double"/>
                  <Option value="11" name="minOutput" type="double"/>
                  <Option value="0" name="minValue" type="double"/>
                  <Option value="0" name="nullOutput" type="double"/>
                </Option>
                <Option value="0" name="t" type="int"/>
              </Option>
              <Option value="3" name="type" type="int"/>
            </Option>
          </Option>
          <Option value="collection" name="type" type="QString"/>
        </Option>
      </dd_properties>
      <callout type="simple">
        <Option type="Map">
          <Option value="pole_of_inaccessibility" name="anchorPoint" type="QString"/>
          <Option value="0" name="blendMode" type="int"/>
          <Option name="ddProperties" type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
          <Option value="false" name="drawToAllParts" type="bool"/>
          <Option value="0" name="enabled" type="QString"/>
          <Option value="point_on_exterior" name="labelAnchorPoint" type="QString"/>
          <Option value="&lt;symbol name=&quot;symbol&quot; type=&quot;line&quot; clip_to_extent=&quot;1&quot; force_rhr=&quot;0&quot; alpha=&quot;1&quot;>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;layer class=&quot;SimpleLine&quot; enabled=&quot;1&quot; locked=&quot;0&quot; pass=&quot;0&quot;>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;0&quot; name=&quot;align_dash_pattern&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;square&quot; name=&quot;capstyle&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;5;2&quot; name=&quot;customdash&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;customdash_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;customdash_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;dash_pattern_offset&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;dash_pattern_offset_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;dash_pattern_offset_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;draw_inside_polygon&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;bevel&quot; name=&quot;joinstyle&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;60,60,60,255&quot; name=&quot;line_color&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;solid&quot; name=&quot;line_style&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0.3&quot; name=&quot;line_width&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;line_width_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;offset&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;offset_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;offset_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;ring_filter&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;trim_distance_end&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_end_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;trim_distance_end_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;trim_distance_start&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_start_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;trim_distance_start_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;tweak_dash_pattern_on_corners&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;use_custom_dash&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;width_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;prop k=&quot;align_dash_pattern&quot; v=&quot;0&quot;/>&lt;prop k=&quot;capstyle&quot; v=&quot;square&quot;/>&lt;prop k=&quot;customdash&quot; v=&quot;5;2&quot;/>&lt;prop k=&quot;customdash_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;customdash_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;dash_pattern_offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;dash_pattern_offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;dash_pattern_offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;draw_inside_polygon&quot; v=&quot;0&quot;/>&lt;prop k=&quot;joinstyle&quot; v=&quot;bevel&quot;/>&lt;prop k=&quot;line_color&quot; v=&quot;60,60,60,255&quot;/>&lt;prop k=&quot;line_style&quot; v=&quot;solid&quot;/>&lt;prop k=&quot;line_width&quot; v=&quot;0.3&quot;/>&lt;prop k=&quot;line_width_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;ring_filter&quot; v=&quot;0&quot;/>&lt;prop k=&quot;trim_distance_end&quot; v=&quot;0&quot;/>&lt;prop k=&quot;trim_distance_end_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;trim_distance_end_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;trim_distance_start&quot; v=&quot;0&quot;/>&lt;prop k=&quot;trim_distance_start_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;trim_distance_start_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;tweak_dash_pattern_on_corners&quot; v=&quot;0&quot;/>&lt;prop k=&quot;use_custom_dash&quot; v=&quot;0&quot;/>&lt;prop k=&quot;width_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol" type="QString"/>
          <Option value="0" name="minLength" type="double"/>
          <Option value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale" type="QString"/>
          <Option value="MM" name="minLengthUnit" type="QString"/>
          <Option value="0" name="offsetFromAnchor" type="double"/>
          <Option value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale" type="QString"/>
          <Option value="MM" name="offsetFromAnchorUnit" type="QString"/>
          <Option value="0" name="offsetFromLabel" type="double"/>
          <Option value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale" type="QString"/>
          <Option value="MM" name="offsetFromLabelUnit" type="QString"/>
        </Option>
      </callout>
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>1</layerGeometryType>
</qgis>'
	WHERE layername='v_ext_streetaxis' AND styleconfig_id=101;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(3694, 'Any node was found at these coordinates.', 'Please select a node to place your element.', 1, true, 'ud', 'core', 'UI');


UPDATE sys_function SET function_alias = 'IMPORT CAT-PERIOD VALUES' WHERE function_name = 'gw_fct_import_cat_period';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3872, 'Reading values from temp_csv table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3874, 'Inserting values on ext_cat_period table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3876, 'Deleting values from temp_csv -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3878, 'Process finished with %i% rows inserted.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_param_user (id, formname, descript, sys_role, idval, "label", dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, "source")
VALUES('edit_connec_linkcat_vdefault', 'config', 'Value default catalog for link connected to connec', 'role_edit', NULL, 'Default catalog for linkcat:', 'SELECT DISTINCT ON (cl.id) cl.id, cl.id AS idval FROM link l JOIN cat_link cl ON l.linkcat_id = cl.id WHERE l.link_type = ''CONDUITLINK''', NULL, true, 20, 'ud', false, NULL, 'linkcat_id', NULL, false, 'text', 'combo', true, NULL, 'CC040_I', 'lyt_connec', true, true, false, NULL, NULL, NULL);

UPDATE sys_param_user
SET vdefault='CC040_I',"label"='Default catalog for linkcat:', dv_querytext='SELECT cat_link.id, cat_link.id AS idval FROM cat_link JOIN cat_feature ON cat_feature.id = cat_link.link_type WHERE cat_link.link_type = ''CONDUITLINK''', descript='Value default catalog for link', feature_field_id='linkcat_id', ismandatory=true, dv_isnullvalue=false, project_type='ud'
WHERE id='edit_connec_linkcat_vdefault';



UPDATE sys_function SET function_alias = 'IMPORT CATALOG' WHERE function_name = 'gw_fct_import_catalog';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4136, 'Nothing to import', null, 0, true, 'utils', 'core', 'AUDIT');


-- messages reserved for singular/plural logic on dynamic checks
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(5000, 'There is ', NULL, 0, true, 'utils', 'core', 'UI');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(5002, 'There are ', NULL, 0, true, 'utils', 'core', 'UI');

UPDATE sys_function SET function_alias = 'IMPORT DB PRICES FILE' WHERE function_name = 'gw_fct_import_dbprices';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3920, 'Nothing to import', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3926, 'Process finished', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4138, 'Inserting values on plan_price table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

DELETE FROM config_form_fields WHERE formname ILIKE '%node%' AND columnname = 'tstamp';


ALTER TABLE cat_element DROP CONSTRAINT cat_element_elementtype_id_fkey;
ALTER TABLE cat_element ADD CONSTRAINT cat_element_fkey_element_type FOREIGN KEY (element_type) REFERENCES cat_feature_element(id);


ALTER TABLE exploitation ADD CONSTRAINT exploitation_cat_owner_id_fkey FOREIGN KEY (owner_vdefault) REFERENCES cat_owner(id);


ALTER TABLE sys_param_user
ADD CONSTRAINT chk_widgets_requires_dv_querytext
CHECK (
  (widgettype NOT IN ('combo', 'typeahead')) OR dv_querytext IS NOT NULL
);

ALTER TABLE config_param_system
ADD CONSTRAINT chk_widgets_requires_dv_querytext
CHECK (
  (widgettype NOT IN ('combo', 'typeahead')) OR dv_querytext IS NOT NULL
);


CREATE TRIGGER gw_trg_edit_cat_feature INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_cat_feature_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_cat_feature('link');

CREATE TRIGGER gw_trg_edit_cat_feature INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_cat_feature_element
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_cat_feature('element');

-- CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON link
-- FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('link');

-- CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON cat_link
-- FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('link');

DROP TRIGGER IF EXISTS gw_trg_edit_element ON man_frelem;
DROP TRIGGER IF EXISTS gw_trg_edit_element ON man_genelem;
DROP TRIGGER IF EXISTS gw_trg_edit_element ON element;

CREATE TRIGGER gw_trg_ui_doc_x_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_element
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('element');

CREATE TRIGGER gw_trg_edit_element INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_frelem
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_element('parent');

CREATE TRIGGER gw_trg_edit_element INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_genelem
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_element('parent');

CREATE TRIGGER gw_trg_ui_plan_psector INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_plan_psector
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_plan_psector();

CREATE TRIGGER gw_trg_edit_psector INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_plan_psector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_psector('plan');

CREATE TRIGGER gw_trg_edit_psector_x_other INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_plan_psector_x_other FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_psector_x_other('plan');

CREATE TRIGGER gw_trg_edit_dimensions INSTEAD OF
INSERT
    OR
DELETE
    OR
UPDATE
    ON
    v_edit_dimensions FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dimensions('dimensions');

CREATE TRIGGER gw_trg_edit_element INSTEAD OF
DELETE
    ON
    v_ui_element FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_element();
