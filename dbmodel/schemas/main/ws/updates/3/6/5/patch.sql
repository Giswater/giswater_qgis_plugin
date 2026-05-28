/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME ,public;


DROP FUNCTION IF EXISTS gw_fct_pg2epa_check_nodarc;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_dma", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE plan_netscenario_dma ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_presszone", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE plan_netscenario_presszone ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_presszone", "column":"lastupdate", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_presszone", "column":"lastupdate_user", "dataType":"character varying(30)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_dma", "column":"lastupdate", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_netscenario_dma", "column":"lastupdate_user", "dataType":"character varying(30)", "isUtils":"False"}}$$);

CREATE TABLE plan_netscenario_valve (
netscenario_id integer, 
node_id character varying(16),
closed boolean  DEFAULT false,
CONSTRAINT plan_netscenario_valve_pkey PRIMARY KEY (netscenario_id, node_id)); 

ALTER TABLE plan_netscenario_dma ALTER COLUMN lastupdate SET DEFAULT now();
ALTER TABLE plan_netscenario_presszone ALTER COLUMN lastupdate SET DEFAULT now();

ALTER TABLE plan_netscenario_dma ALTER COLUMN lastupdate_user SET DEFAULT current_user;
ALTER TABLE plan_netscenario_presszone ALTER COLUMN lastupdate_user SET DEFAULT current_user;

DROP VIEW IF EXISTS v_om_waterbalance;
CREATE OR REPLACE VIEW v_om_waterbalance
 AS
 SELECT e.name AS exploitation,
    d.name AS dma,
    p.code AS period,
    om_waterbalance.auth_bill,
    om_waterbalance.auth_unbill,
    om_waterbalance.loss_app,
    om_waterbalance.loss_real,
    om_waterbalance.total_in,
    om_waterbalance.total_out,
    om_waterbalance.total,
    p.start_date::date AS crm_startdate,
    p.end_date::date AS crm_enddate,
    om_waterbalance.startdate AS wbal_startdate,
    om_waterbalance.enddate AS wbal_enddate,
    om_waterbalance.ili,
    om_waterbalance.auth,
    om_waterbalance.loss,
        CASE
            WHEN om_waterbalance.total > 0::double precision THEN (100::numeric::double precision * (om_waterbalance.auth_bill + om_waterbalance.auth_unbill) / om_waterbalance.total)::numeric(20,2)
            ELSE 0::numeric(20,2)
        END AS loss_eff,
    om_waterbalance.auth_bill AS rw,
    (om_waterbalance.total - om_waterbalance.auth_bill)::numeric(20,2) AS nrw,
        CASE
            WHEN om_waterbalance.total > 0::double precision THEN (100::numeric::double precision * om_waterbalance.auth_bill / om_waterbalance.total)::numeric(20,2)
            ELSE 0::numeric(20,2)
        END AS nrw_eff,
    d.the_geom
   FROM om_waterbalance
     JOIN exploitation e USING (expl_id)
     JOIN dma d USING (dma_id)
     JOIN ext_cat_period p ON p.id::text = om_waterbalance.cat_period_id::text;



CREATE OR REPLACE VIEW v_edit_plan_netscenario_dma
 AS
 SELECT n.netscenario_id,
    p.name AS netscenario_name,
    n.dma_id,
    n.dma_name AS name,
    n.pattern_id,
    n.graphconfig,
    n.the_geom,
    n.active
   FROM selector_netscenario,
    plan_netscenario_dma n
     JOIN plan_netscenario p USING (netscenario_id)
  WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_edit_plan_netscenario_presszone
 AS
 SELECT n.netscenario_id,
    p.name AS netscenario_name,
    n.presszone_id,
    n.presszone_name AS name,
    n.head,
    n.graphconfig,
    n.the_geom,
    n.active
   FROM selector_netscenario,
    plan_netscenario_presszone n
     JOIN plan_netscenario p USING (netscenario_id)
  WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_plan_netscenario_valve AS
 SELECT v.netscenario_id,
    v.node_id,
    v.closed,
    node.the_geom
   FROM selector_netscenario,
    plan_netscenario_valve v
    JOIN node USING (node_id)
  WHERE v.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;
  
  
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



DROP VIEW IF EXISTS v_ui_mincut;

CREATE OR REPLACE VIEW v_ui_mincut
AS SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    exploitation.name AS exploitation,
    ext_municipality.name AS municipality,
    om_mincut.postcode,
    ext_streetaxis.name AS streetaxis,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    cat_users.name AS assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.chlorine,
    om_mincut.turbidity,
    om_mincut.notified,
    om_mincut.output
   FROM om_mincut
     LEFT JOIN om_typevalue a ON a.id::integer = om_mincut.mincut_state AND a.typevalue = 'mincut_state'::text
     LEFT JOIN om_typevalue b ON b.id::integer = om_mincut.mincut_class AND b.typevalue = 'mincut_class'::text
     LEFT JOIN om_typevalue c ON c.id::integer = om_mincut.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
     LEFT JOIN exploitation ON exploitation.expl_id = om_mincut.expl_id
     LEFT JOIN macroexploitation ON macroexploitation.macroexpl_id = om_mincut.macroexpl_id
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = om_mincut.muni_id
     LEFT JOIN ext_streetaxis ON ext_streetaxis.id::text = om_mincut.streetaxis_id::text
     LEFT JOIN cat_users ON cat_users.id::text = om_mincut.assigned_to::text
  WHERE om_mincut.id > 0;



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
    presszone_id::character varying(16) AS presszone_id,
    l.dqa_id,
    l.minsector_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
    l.the_geom,
    s.name AS sector_name,
    d.name AS dma_name,
    q.name AS dqa_name,
    p.name AS presszone_name,
    s.macrosector_id,
    d.macrodma_id,
    q.macrodqa_id,
    l.expl_id2,
    l.epa_type,
    l.is_operative,
    l.staticpressure,
    l.connecat_id,
    l.workcat_id,
    l.workcat_id_end,
    l.builtdate ,
    l.enddate
   FROM link l
     LEFT JOIN sector s USING (sector_id)
     LEFT JOIN presszone p USING (presszone_id)
     LEFT JOIN dma d USING (dma_id)
     LEFT JOIN dqa q USING (dqa_id);

create or replace view v_link_connec as 
select * from vu_link
JOIN v_state_link_connec USING (link_id);


create or replace view v_link as 
select * from vu_link
JOIN v_state_link USING (link_id);

CREATE OR REPLACE VIEW v_edit_link AS SELECT *
FROM v_link l;


UPDATE config_form_fields SET layoutorder = attnum FROM pg_attribute 
WHERE attrelid = 'SCHEMA_NAME.v_edit_link'::regclass and attnum >0 AND columnname = attname AND formname = 'v_edit_link';

UPDATE config_report SET query_text = 
'SELECT w.exploitation as "Exploitation", w.dma as "Dma", period as "Period", 
total_in::numeric(20,2) as "Total inlet",
total_out::numeric(20,2) as "Total outlet",
total::numeric(20,2) as "Total injected",
auth_bill as "Auth. Bill", auth_unbill as "Auth. Unbill", auth as "Authorized", 
loss_app as "Losses App", loss_real as "Losses Real",loss as "Losses", 
(case when total > 0 then (auth/total)::numeric(20,2) else 0 end) as "Losses Efficiency" ,
rw as "Revenue", nrw as "Non Revenue", 
(case when total > 0 then (rw/total)::numeric(20,2) else 0.00 end) as "Revenue Efficiency",
w.ili::numeric(20,2) as "ILI"
FROM v_om_waterbalance w' where id = 102;

UPDATE config_report SET query_text = 
'SELECT n.exploitation as "Exploitation",
(sum(n.total))::numeric(20,2) as "Total input", sum(rw) as "Revenue", sum(nrw) as "Non Revenue", 
(case when sum(n.total) > 0 THEN (sum(rw)/sum(n.total))::numeric(20,2) else 0.00 end) as "Revenue Efficiency",
sum(auth) as "Authorized", sum(loss) as "Losses", 
(case when sum(n.total) > 0 THEN (sum(auth)/sum(n.total))::numeric(20,2) else 0.00 end) as "Losses Efficiency"
FROM v_om_waterbalance n  WHERE n.dma IS NOT NULL' where id = 103;

UPDATE config_report SET query_text = 
'SELECT n.exploitation as "Exploitation", n.dma as "Dma", 
(sum(n.total))::numeric(20,2) as "Total input", sum(rw) as "Revenue", sum(nrw) as "Non Revenue", 
(case when sum(n.total) > 0 THEN (sum(rw)/sum(n.total))::numeric(20,2) else 0.00 end) as "Revenue Efficiency",
sum(auth) as "Authorized", sum(loss) as "Losses", 
(case when sum(n.total) > 0 THEN (sum(auth)/sum(n.total))::numeric(20,2) else 0.00 end) as "Losses Efficiency",
(avg(n.ili))::numeric(20,2) as "ILI"
FROM v_om_waterbalance n WHERE n.dma IS NOT NULL' where id = 104;

DELETE FROM sys_function WHERE id = 3106;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, hidden)
VALUES ('plan_netscenario_dma','form_feature', 'tab_none', 'active', 'lyt_data_1', 7, 'boolean', 'check', 'active', null, null, false, false, 
true, false, false, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, hidden)
VALUES ('v_edit_plan_netscenario_dma','form_feature', 'tab_none', 'active', 'lyt_data_1', 7, 'boolean', 'check', 'active', null, null, false, false, 
true, false, false, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, hidden)
VALUES ('plan_netscenario_presszone','form_feature', 'tab_none', 'active', 'lyt_data_1', 7, 'boolean', 'check', 'active', null, null, false, false, 
true, false, false, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, hidden)
VALUES ('v_edit_plan_netscenario_presszone','form_feature', 'tab_none', 'active', 'lyt_data_1', 7, 'boolean', 'check', 'active', null, null, false, false, 
true, false, false, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, hidden)
VALUES ('plan_netscenario_dma','form_feature', 'tab_none', 'lastupdate', 'lyt_data_1', 7, 'string', 'text', 'lastupdate', null, null, false, false, 
false, false, false, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, hidden)
VALUES ('plan_netscenario_dma','form_feature', 'tab_none', 'lastupdate_user', 'lyt_data_1', 7, 'string', 'text', 'lastupdate_user', null, null, false, false, 
false, false, false, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, hidden)
VALUES ('plan_netscenario_presszone','form_feature', 'tab_none', 'lastupdate', 'lyt_data_1', 7, 'string', 'text', 'lastupdate', null, null, false, false, 
false, false, false, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, hidden)
VALUES ('plan_netscenario_presszone','form_feature', 'tab_none', 'lastupdate_user', 'lyt_data_1', 7, 'string', 'text', 'lastupdate_user', null, null, false, false, 
false, false, false, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


UPDATE config_form_fields SET iseditable=false where formname='plan_netscenario' and columnname='netscenario_id';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=3 where formname='plan_netscenario' and columnname='descript';
UPDATE config_form_fields SET layoutorder=4 where formname='plan_netscenario' and columnname='netscenario_type';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=5 where formname='plan_netscenario' and columnname='expl_id';
UPDATE config_form_fields SET layoutorder=6 where formname='plan_netscenario' and columnname='parent_id';
UPDATE config_form_fields SET layoutorder=7 where formname='plan_netscenario' and columnname='active';
UPDATE config_form_fields SET iseditable=false and layoutorder=8 where formname='plan_netscenario' and columnname='log';


UPDATE config_form_fields SET dv_querytext = 
'SELECT DISTINCT (id) AS id,  idval  AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_status_valve'' '
WHERE formname in ('v_edit_inp_dscenario_valve', 've_epa_valve', 've_epa_shortpipe') and columnname = 'status';

UPDATE config_form_fields SET dv_querytext = 
'SELECT DISTINCT (id) AS id,  idval  AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_status_pipe'' '
WHERE formname in ('ve_epa_shortpipe', 'v_edit_inp_shortpipe', 'v_edit_inp_dscenario_shortpipe') and columnname = 'status';

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, "source") 
VALUES(3248, 'There is no street data available', 'Please draw tramified streets on om_streetaxis table', 2, false, 'ws', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source, context, orderby, alias, addparam)
VALUES ('v_edit_plan_netscenario_valve' , 'Editable view to visualize valve related to selected netscenario', 'role_master', 'core','{"level_1":"MASTERPLAN","level_2":"NETSCENARIO"}', 6, 'Netscenario valve', '{"pkey":"netscenario_id, node_id"}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source, addparam)
VALUES ('plan_netscenario_valve' , 'Table of valve related to selected netscenario', 'role_master', 'core', '{"pkey":"netscenario_id, node_id"}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (514, 'Import valve closed into netscenario', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;
	
INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby, addparam)
VALUES (514, 'Import netscenario closed valves ','The csv file must have the following fields:
netscenario_id, node_id, closed', 'gw_fct_import_netscenario_valve_closed', true, 23,null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3278, 'gw_fct_import_netscenario_valve_closed', 'ws', 'function', 'json', 'json', 'Function to import closed valve into netscenario', 'role_epa', null, 'core') ON CONFLICT (id) DO NOTHING;

UPDATE config_toolbox SET inputparams = b.inp FROM (SELECT json_agg(a.inputs) AS inp FROM
(SELECT json_array_elements(inputparams)as inputs, json_extract_path_text(json_array_elements(inputparams),'widgetname') as widget
FROM   config_toolbox 
WHERE id=2768)a WHERE widget!='usePlanPsector')b WHERE  id=2768;

UPDATE config_toolbox SET inputparams = b.inp FROM (SELECT json_agg(a.inputs) AS inp FROM
(SELECT json_array_elements(inputparams)as inputs, json_extract_path_text(json_array_elements(inputparams),'widgetname') as widget
FROM   config_toolbox 
WHERE id=3256)a WHERE widget!='dscenario_valve')b WHERE  id=3256;

UPDATE sys_function SET descript='Function to calculate water balance according stardards of IWA.
Before that: 
1) tables ext_cat_period, ext_rtc_hydrometer_x_data, ext_rtc_scada_x_data need to be filled.
2) DMA graph need to be executed.' WHERE id=3142;



update config_toolbox set device = '{4}' WHERE id in (2768,2110);

INSERT INTO config_report (id, alias, query_text, addparam, filterparam, sys_role, active, device) VALUES
(105, 'Nodes by exploitation and type', 'SELECT name as "Exploitation", node_type as "Node type", count(*) as "Units" FROM v_edit_node JOIN exploitation USING (expl_id) GROUP BY node_type, name',
 '{"orderBy":"1", "orderType": "DESC"}',
 '[{"columnname":"Exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select name as id, name as idval FROM exploitation WHERE expl_id > 0 ORDER BY name","isNullValue":"true"},
{"columnname":"Node type", "label":"Node type:", "widgettype":"combo","datatype":"text","layoutorder":2,
"dvquerytext":"Select id as id, id as idval FROM cat_feature_node join cat_feature USING (id) WHERE id IS NOT NULL AND active ORDER BY id","isNullValue":"true"}]',
'role_basic', true, '{4,5}')
ON CONFLICT (id) DO NOTHING;

UPDATE config_form_fields set columnname ='bulk_coeff' where columnname ='buk_coeff';

UPDATE config_form_fields set columnname ='init_quality' where columnname ='initial_quality';

UPDATE config_form_fields SET dv_querytext = 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_value_status_pipe''', 
dv_orderby_id=true, dv_isnullvalue = true, widgettype='combo' WHERE  columnname 
ilike 'status' and formname = 've_epa_connec';

UPDATE config_form_fields set columnname ='energy_pattern_id' where columnname ='price_pattern' and formname = 've_epa_pump';

UPDATE config_form_list SET query_text = replace(query_text, 'name,','') where listname ='tbl_mincut_manager';

UPDATE config_param_system SET value = '{"activated":false}' WHERE parameter ='edit_arc_check_conflictmapzones';


UPDATE config_param_system
SET value='{"table":"plan_netscenario","table_id":"netscenario_id","selector":"selector_netscenario","selector_id":"netscenario_id","label":"netscenario_id, ''-'', name ","query_filter":" ", "selectionMode":"removePrevious"}'
WHERE "parameter"='basic_selector_tab_netscenario';

ALTER TABLE IF EXISTS plan_netscenario_dma
    ADD CONSTRAINT plan_netscenario_dma_netscenario_id_fkey FOREIGN KEY (netscenario_id)
    REFERENCES plan_netscenario (netscenario_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE IF EXISTS plan_netscenario_presszone
    ADD CONSTRAINT plan_netscenario_presszone_netscenario_id_fkey FOREIGN KEY (netscenario_id)
    REFERENCES plan_netscenario (netscenario_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE IF EXISTS plan_netscenario_arc
    ADD CONSTRAINT plan_netscenario_arc_netscenario_id_dma_id_fkey FOREIGN KEY (netscenario_id, dma_id)
    REFERENCES plan_netscenario_dma (netscenario_id, dma_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE IF EXISTS plan_netscenario_node
    ADD CONSTRAINT plan_netscenario_node_netscenario_id_dma_id_fkey FOREIGN KEY (netscenario_id, dma_id)
    REFERENCES plan_netscenario_dma (netscenario_id, dma_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE IF EXISTS plan_netscenario_connec
    ADD CONSTRAINT plan_netscenario_connec_netscenario_id_dma_id_fkey FOREIGN KEY (netscenario_id, dma_id)
    REFERENCES plan_netscenario_dma (netscenario_id, dma_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;
    
ALTER TABLE IF EXISTS plan_netscenario_arc
    ADD CONSTRAINT plan_netscenario_arc_netscenario_id_presszone_id_fkey FOREIGN KEY (netscenario_id, presszone_id)
    REFERENCES plan_netscenario_presszone (netscenario_id, presszone_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE IF EXISTS plan_netscenario_node
    ADD CONSTRAINT plan_netscenario_node_netscenario_id_presszone_id_fkey FOREIGN KEY (netscenario_id, presszone_id)
    REFERENCES plan_netscenario_presszone (netscenario_id, presszone_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE IF EXISTS plan_netscenario_connec
    ADD CONSTRAINT plan_netscenario_connec_netscenario_id_presszone_id_fkey FOREIGN KEY (netscenario_id, presszone_id)
    REFERENCES plan_netscenario_presszone (netscenario_id, presszone_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE IF EXISTS plan_netscenario_valve 
    ADD CONSTRAINT plan_netscenario_valve_netscenario_id_fkey FOREIGN KEY (netscenario_id)
    REFERENCES plan_netscenario(netscenario_id) MATCH SIMPLE 
    ON UPDATE CASCADE 
    ON DELETE CASCADE;

ALTER TABLE IF EXISTS plan_netscenario_valve 
    ADD CONSTRAINT plan_netscenario_valve_node_id_fkey FOREIGN KEY (node_id)
    REFERENCES man_valve(node_id) MATCH SIMPLE 
    ON UPDATE CASCADE 
    ON DELETE CASCADE;

CREATE TRIGGER gw_trg_edit_plan_netscenario
    INSTEAD OF INSERT OR DELETE OR UPDATE 
    ON SCHEMA_NAME.v_edit_plan_netscenario_valve
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMA_NAME.gw_trg_edit_plan_netscenario('VALVE');
