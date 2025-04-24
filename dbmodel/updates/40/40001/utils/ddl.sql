/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TABLE IF EXISTS flwreg CASCADE;
DROP TABLE IF EXISTS cat_flwreg CASCADE;

CREATE TABLE man_servconnection (
	link_id int4 NOT NULL,
	CONSTRAINT man_servconnection_pkey PRIMARY KEY (link_id),
	CONSTRAINT man_servconnection_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE
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
    element_id varchar(16) NOT NULL,
    CONSTRAINT man_genelem_pkey PRIMARY KEY (element_id),
	CONSTRAINT man_genelem_fkey_element_id FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE man_frelem (
    element_id varchar(16) NOT NULL,
    node_id varchar NULL,
    order_id numeric NULL,
    to_arc varchar NULL,
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
WHERE formname='ve_link_servconnection' AND formtype='form_feature' AND columnname='doc_type' AND tabname='tab_documents';
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

-- ALTER TABLE element ADD COLUMN epa_type varchar(16) NULL;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"epa_type", "dataType":"varchar(16)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_arc_traceability", "column":"undelete"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_connec_traceability", "column":"undelete"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_gully_traceability", "column":"undelete"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_node_traceability", "column":"undelete"}}$$);


-- 22/04/2025
CREATE TABLE doc_x_element (
	doc_id varchar(30) NOT NULL,
	element_id varchar(16) NOT NULL,
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

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"omzone_id", "dataType":"integer", "isUtils":"False"}}$$);
