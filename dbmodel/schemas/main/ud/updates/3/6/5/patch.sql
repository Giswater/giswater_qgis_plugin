/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_transects", "column":"sector_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"drainzone_id", "dataType":"integer", "isUtils":"False"}}$$);

CREATE OR REPLACE VIEW vi_transects AS
 SELECT inp_transects_value.text
   FROM selector_sector s,
    inp_transects t
     JOIN inp_transects_value ON tsect_id=t.id
  WHERE (t.sector_id = s.sector_id AND s.cur_user = "current_user"()::text) OR t.sector_id IS NULL
  ORDER BY t.id;


CREATE OR REPLACE VIEW v_edit_inp_transects AS
 SELECT DISTINCT t.id,
    t.tsect_id,
    c.sector_id,
    t.text
   FROM selector_sector,
    inp_transects c
JOIN inp_transects_value t on t.tsect_id = c.id
  WHERE c.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;
  
  
  CREATE OR REPLACE VIEW ve_pol_node
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
   FROM node
     JOIN v_state_node USING (node_id)
     JOIN v_expl_node USING (node_id)
     JOIN polygon ON polygon.feature_id::text = node.node_id::text;



CREATE OR REPLACE VIEW vu_link AS
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    l.dma_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
    l.the_geom,
    s.name AS sector_name,
    s.macrosector_id,
    d.macrodma_id,
    l.expl_id2,
    l.epa_type,
    l.is_operative,
    l.drainzone_id,
    r.name as drainzone_name,
    l.connecat_id,
    l.workcat_id,
    l.workcat_id_end,
    l.builtdate,
    l.enddate
   FROM link l
     LEFT JOIN sector s USING (sector_id)
     LEFT JOIN dma d USING (dma_id)
     LEFT JOIN drainzone r USING (drainzone_id);

create or replace view v_link_connec as 
select distinct on (link_id) * from vu_link_connec
JOIN v_state_link_connec USING (link_id);

create or replace view v_link_gully as 
select distinct on (link_id) * from vu_link_gully
JOIN v_state_link_gully USING (link_id);

create or replace view v_link as 
select distinct on (link_id) * from vu_link
JOIN v_state_link USING (link_id);

CREATE OR REPLACE VIEW v_edit_link AS SELECT *
FROM v_link l;

UPDATE config_form_fields SET layoutorder = attnum FROM pg_attribute 
WHERE attrelid = 'SCHEMA_NAME.v_edit_link'::regclass and attnum >0 AND columnname = attname AND formname = 'v_edit_link';

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 'v_edit_inp_transects',formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'inp_transects_value'  ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 'v_edit_inp_transects',formtype, tabname, columnname, null, null, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 've_node' AND columnname in ('sector_id') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields SET dv_isnullvalue = false WHERE formname='v_edit_inp_transects' and columnname in ('sector_id');

INSERT INTO sys_table(id, descript, sys_role,  source, context,alias )
VALUES ('v_edit_inp_transects' , 'Editable view of transects', 'role_epa', 'core','{"level_1":"EPA","level_2":"CATALOGS"}','Transects value')
ON CONFLICT (id) DO NOTHING;

UPDATE sys_table SET context=NULL, alias = NULL WHERE id = 'inp_transects_value';

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3276, 'gw_trg_edit_inp_transects', 'ud', 'function trigger', null, null, 'Function trigger that allows editing view of inp transects', 'role_epa', 'core')
ON CONFLICT (id) DO NOTHING;



update config_toolbox set device = '{4}' WHERE id in (3172,2110,3040,2768);

update config_report set 
alias = 'Conduit length by exploitation and catalog',
query_text = 'SELECT name as "Exploitation", arccat_id as "Arc Catalog", sum(gis_length) as "Length" FROM v_edit_arc JOIN exploitation USING (expl_id) GROUP BY arccat_id, name',
addparam = '{"orderBy":"1", "orderType": "DESC"}',
filterparam = '[{"columnname":"Exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select name as id, name as idval FROM exploitation WHERE expl_id > 0 ORDER BY name","isNullValue":"true"},
{"columnname":"Arc Catalog", "label":"Arc catalog:", "widgettype":"combo","datatype":"text","layoutorder":2,
"dvquerytext":"Select id as id, id as idval FROM cat_arc WHERE id IS NOT NULL ORDER BY id","isNullValue":"true"}]'
WHERE id = 100;

INSERT INTO config_report (id, alias, query_text, addparam, filterparam, sys_role, active, device) VALUES
(105, 'Nodes by exploitation and type', 'SELECT name as "Exploitation", node_type as "Node type", count(*) as "Units" FROM v_edit_node JOIN exploitation USING (expl_id) GROUP BY node_type, name',
 '{"orderBy":"1", "orderType": "DESC"}',
 '[{"columnname":"Exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select name as id, name as idval FROM exploitation WHERE expl_id > 0 ORDER BY name","isNullValue":"true"},
{"columnname":"Node type", "label":"Node type:", "widgettype":"combo","datatype":"text","layoutorder":2,
"dvquerytext":"Select id as id, id as idval FROM cat_feature_node join cat_feature USING (id) WHERE id IS NOT NULL AND active ORDER BY id","isNullValue":"true"}]',
'role_basic', true, '{4,5}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_param_system(parameter, value, descript, label, isenabled,  project_type,  datatype, widgettype, ismandatory)
VALUES ('om_profile_nonpriority_statetype', '{"state_type":""}', 
'Features with defined state type won''t be prioritised to be chosen on a profile in case of overlaying conduiuts, instead it will have an additional path cost added to it''s length', 
'Profile non priority state type', false, 'ud', 'json', 'linetext', false ) ON CONFLICT (parameter) DO NOTHING;

DROP TRIGGER IF EXISTS gw_trg_vi_transects ON vi_transects;
CREATE TRIGGER gw_trg_vi_transects INSTEAD OF INSERT OR UPDATE OR DELETE ON vi_transects
FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_transects');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_transects ON v_edit_inp_transects;
CREATE TRIGGER gw_trg_edit_inp_transects INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_transects
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_transects();
