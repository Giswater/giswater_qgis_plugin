/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE TABLE rpt_arc_stats (
  arc_id character varying(16),
  result_id character varying(30) NOT NULL,
  arc_type varchar (30),
  sector_id integer,
  arccat_id varchar (30),
  flow_max numeric,
  flow_min numeric,
  flow_avg numeric(12,2),
  vel_max numeric,
  vel_min numeric,
  vel_avg numeric(12,2),
  headloss_max numeric,
  headloss_min numeric,
  setting_max numeric,
  setting_min numeric,
  reaction_max numeric,
  reaction_min numeric,
  ffactor_max numeric,
  ffactor_min numeric,
  the_geom geometry(LINESTRING, SRID_VALUE),
  CONSTRAINT rpt_arc_stats_pkey PRIMARY KEY (arc_id, result_id),
  CONSTRAINT rpt_arc_stats_result_id_fkey FOREIGN KEY (result_id)
      REFERENCES rpt_cat_result (result_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE rpt_node_stats (
  node_id character varying(16),
  result_id character varying(30) NOT NULL,
  node_type varchar (30),
  sector_id integer,
  nodecat_id varchar (30),
  elevation numeric,
  demand_max numeric,
  demand_min numeric,
  demand_avg numeric(12,2),
  head_max numeric,
  head_min numeric,
  head_avg numeric(12,2),
  press_max numeric,
  press_min numeric,
  press_avg numeric(12,2),
  quality_max numeric,
  quality_min numeric,
  quality_avg numeric(12,2),
  the_geom geometry(POINT, SRID_VALUE),
  CONSTRAINT rpt_node_stats_pkey PRIMARY KEY (node_id, result_id),
  CONSTRAINT rpt_node_stats_result_id_fkey FOREIGN KEY (result_id)
      REFERENCES rpt_cat_result (result_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE);


CREATE INDEX rpt_arc_stats_geom ON rpt_arc_stats USING gist(the_geom);
CREATE INDEX rpt_arc_stats_flow_max ON rpt_arc_stats USING btree(flow_max);
CREATE INDEX rpt_arc_stats_flow_avg ON rpt_arc_stats USING btree(flow_avg);
CREATE INDEX rpt_arc_stats_flow_min ON rpt_arc_stats USING btree(flow_min);
CREATE INDEX rpt_arc_stats_vel_max ON rpt_arc_stats USING btree(vel_max);
CREATE INDEX rpt_arc_stats_vel_avg ON rpt_arc_stats USING btree(vel_avg);
CREATE INDEX rpt_arc_stats_vel_min ON rpt_arc_stats USING btree(vel_min);  


CREATE INDEX rpt_node_stats_geom ON rpt_node_stats USING gist(the_geom);
CREATE INDEX rpt_node_stats_head_max ON rpt_node_stats USING btree(head_max);
CREATE INDEX rpt_node_stats_head_avg ON rpt_node_stats USING btree(head_avg);
CREATE INDEX rpt_node_stats_head_min ON rpt_node_stats USING btree(head_min);
CREATE INDEX rpt_node_stats_press_max ON rpt_node_stats USING btree(press_max);
CREATE INDEX rpt_node_stats_press_avg ON rpt_node_stats USING btree(press_avg);
CREATE INDEX rpt_node_stats_press_min ON rpt_node_stats USING btree(press_min);  
CREATE INDEX rpt_node_stats_quality_max ON rpt_node_stats USING btree(quality_max);
CREATE INDEX rpt_node_stats_quality_avg ON rpt_node_stats USING btree(quality_avg);
CREATE INDEX rpt_node_stats_quality_min ON rpt_node_stats USING btree(quality_min);
CREATE INDEX rpt_node_stats_demand_max ON rpt_node_stats USING btree(demand_max);
CREATE INDEX rpt_node_stats_demand_avg ON rpt_node_stats USING btree(demand_avg);
CREATE INDEX rpt_node_stats_demand_min ON rpt_node_stats USING btree(demand_min);  

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
    l.builtdate,
    l.enddate,
    date_trunc('second'::text, l.lastupdate) AS lastupdate,
    l.lastupdate_user
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



drop view if exists v_ui_arc_x_relations;
CREATE OR REPLACE VIEW v_ui_arc_x_relations as
  WITH links_node AS (
         SELECT n.node_id,
            l.feature_id,
            l.exit_type AS proceed_from,
            l.exit_id AS proceed_from_id,
            l.state AS l_state,
            n.state AS n_state
           FROM node n
             JOIN link l ON n.node_id::text = l.exit_id::text
             where l.state = 1
        )
 SELECT row_number() OVER () + 1000000 AS rid,  
    v_connec.arc_id,
    v_connec.connec_type AS featurecat_id,
    v_connec.connecat_id AS catalog,
    v_connec.connec_id AS feature_id,
    v_connec.code AS feature_code,
    v_connec.sys_type,
    a.state as arc_state,
    v_connec.state AS feature_state,
    st_x(v_connec.the_geom) AS x,
    st_y(v_connec.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM v_connec
     JOIN link l ON v_connec.connec_id::text = l.feature_id::text
     JOIN arc a ON a.arc_id = v_connec.arc_id
  WHERE v_connec.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 AND l.state = 1 and a.state = 1
UNION
 SELECT DISTINCT ON (c.connec_id) row_number() OVER () + 2000000 AS rid,
    a.arc_id,
    c.connec_type AS featurecat_id,
    c.connecat_id AS catalog,
    c.connec_id AS feature_id,
    c.code AS feature_code,
    c.sys_type,
    a.state as arc_state,
    c.state AS feature_state,
    st_x(c.the_geom) AS x,
    st_y(c.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1::text = n.node_id::text
     JOIN v_connec c ON c.connec_id::text = n.feature_id::text;



CREATE OR REPLACE VIEW v_edit_plan_psector_x_connec AS 
 SELECT plan_psector_x_connec.id,
    plan_psector_x_connec.connec_id,
    plan_psector_x_connec.arc_id,
    plan_psector_x_connec.psector_id,
    plan_psector_x_connec.state,
    plan_psector_x_connec.doable,
    plan_psector_x_connec.descript,
    plan_psector_x_connec.link_id,
    plan_psector_x_connec.active,
    plan_psector_x_connec.insert_tstamp,
    plan_psector_x_connec.insert_user,
    exit_type
   FROM plan_psector_x_connec
   LEFT JOIN link USING (link_id);
  
  

CREATE OR REPLACE VIEW v_connec AS 
 SELECT vu_connec.connec_id,
    vu_connec.code,
    vu_connec.elevation,
    vu_connec.depth,
    vu_connec.connec_type,
    vu_connec.sys_type,
    vu_connec.connecat_id,
    vu_connec.expl_id,
    vu_connec.macroexpl_id,
        CASE
            WHEN a.sector_id IS NULL THEN vu_connec.sector_id
            ELSE a.sector_id
        END AS sector_id,
    vu_connec.sector_name,
    vu_connec.macrosector_id,
    vu_connec.customer_code,
    vu_connec.cat_matcat_id,
    vu_connec.cat_pnom,
    vu_connec.cat_dnom,
    vu_connec.connec_length,
    vu_connec.state,
    vu_connec.state_type,
    vu_connec.n_hydrometer,
    v_state_connec.arc_id,
    vu_connec.annotation,
    vu_connec.observ,
    vu_connec.comment,
        CASE
            WHEN a.minsector_id IS NULL THEN vu_connec.minsector_id
            ELSE a.minsector_id
        END AS minsector_id,
        CASE
            WHEN a.dma_id IS NULL THEN vu_connec.dma_id
            ELSE a.dma_id
        END AS dma_id,
        CASE
            WHEN a.dma_name IS NULL THEN vu_connec.dma_name
            ELSE a.dma_name
        END AS dma_name,
        CASE
            WHEN a.macrodma_id IS NULL THEN vu_connec.macrodma_id
            ELSE a.macrodma_id
        END AS macrodma_id,
        CASE
            WHEN a.presszone_id IS NULL THEN vu_connec.presszone_id
            ELSE a.presszone_id::character varying(30)
        END AS presszone_id,
        CASE
            WHEN a.presszone_name IS NULL THEN vu_connec.presszone_name
            ELSE a.presszone_name
        END AS presszone_name,
        CASE
            WHEN a.presszone_name IS NULL THEN vu_connec.staticpressure
            ELSE a.staticpressure
        END AS staticpressure,
        CASE
            WHEN a.dqa_id IS NULL THEN vu_connec.dqa_id
            ELSE a.dqa_id
        END AS dqa_id,
        CASE
            WHEN a.dqa_name IS NULL THEN vu_connec.dqa_name
            ELSE a.dqa_name
        END AS dqa_name,
        CASE
            WHEN a.macrodqa_id IS NULL THEN vu_connec.macrodqa_id
            ELSE a.macrodqa_id
        END AS macrodqa_id,
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
    vu_connec.publish,
    vu_connec.inventory,
    vu_connec.num_value,
    vu_connec.connectype_id,
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
    vu_connec.adate,
    vu_connec.adescript,
    vu_connec.accessibility,
    vu_connec.workcat_id_plan,
    vu_connec.asset_id,
    vu_connec.dma_style,
    vu_connec.presszone_style,
    vu_connec.epa_type,
    vu_connec.priority,
    vu_connec.valve_location,
    vu_connec.valve_type,
    vu_connec.shutoff_valve,
    vu_connec.access_type,
    vu_connec.placement_type,
    vu_connec.press_max,
    vu_connec.press_min,
    vu_connec.press_avg,
    vu_connec.demand,
    vu_connec.om_state,
    vu_connec.conserv_state,
    vu_connec.crmzone_id,
    vu_connec.crmzone_name,
    vu_connec.expl_id2,
    vu_connec.quality_max,
    vu_connec.quality_min,
    vu_connec.quality_avg,
    vu_connec.is_operative,
    vu_connec.region_id,
    vu_connec.province_id
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
            vu_link.presszone_id,
            vu_link.dqa_id,
            vu_link.minsector_id,
            vu_link.exit_topelev,
            vu_link.exit_elev,
            vu_link.fluid_type,
            vu_link.gis_length,
            vu_link.the_geom,
            vu_link.sector_name,
            vu_link.dma_name,
            vu_link.dqa_name,
            vu_link.presszone_name,
            vu_link.macrosector_id,
            vu_link.macrodma_id,
            vu_link.macrodqa_id,
            vu_link.expl_id2,
            vu_link.staticpressure
           FROM vu_link
           JOIN selector_expl USING (expl_id) WHERE cur_user =current_user AND vu_link.state = 2) 
           a ON a.feature_id::text = vu_connec.connec_id::text;


CREATE OR REPLACE VIEW v_rpt_arc AS
SELECT r.* FROM rpt_arc_stats r, selector_rpt_main s
WHERE r.result_id::text = s.result_id::text AND s.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_rpt_node AS
SELECT r.* FROM rpt_node_stats r, selector_rpt_main s
WHERE r.result_id::text = s.result_id::text AND s.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_rpt_compare_arc AS
SELECT r.* FROM rpt_arc_stats r, selector_rpt_compare s
WHERE r.result_id::text = s.result_id::text AND s.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_rpt_compare_node AS
SELECT r.* FROM rpt_node_stats r, selector_rpt_compare s
JOIN selector_rpt_compare USING (result_id);

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('netscenario manager', 'ws', 'plan_netscenario_arc', 'netscenari_id', 0, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('netscenario manager', 'ws', 'plan_netscenario_node', 'netscenari_id', 0, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('netscenario manager', 'ws', 'plan_netscenario_connec', 'netscenari_id', 0, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('netscenario manager', 'ws', 'plan_netscenario_dma', 'netscenari_id', 0, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('netscenario manager', 'ws', 'plan_netscenario_valve', 'netscenari_id', 0, false, NULL, NULL, NULL, NULL);


UPDATE config_form_fields SET hidden=false, iseditable=true, label = 'Exit elevation' where formname = 'v_edit_link' and columnname = 'exit_topelev';


INSERT INTO config_form_fields values ('ve_epa_pump', 'form_feature', 'tab_epa', 'effic_curve_id', 'lyt_epa_data_1', 11, 'string', 'combo', 'Eff. curve', 'Eff. curve', null, false, false, true, false, false, 'SELECT id as id, id as idval FROM v_edit_inp_curve WHERE curve_type = ''EFFICIENCY''', true, true, null, null, null, null, null, null, false);

UPDATE config_form_fields set widgettype = 'combo', dv_querytext = 'SELECT pattern_id as id, pattern_id as idval FROM v_edit_inp_pattern WHERE pattern_id is not null' 
where formname like 've_epa_pump' and columnname ='energy_pattern_id';

UPDATE config_form_fields set iseditable = false  where formname = 've_epa_pump' and columnname = 'avg_effic';


UPDATE sys_param_user SET "label"='Hydraulic timestep' WHERE id='inp_times_hydraulic_timestep';


UPDATE config_report SET query_text = 
'SELECT w.exploitation as "Exploitation", w.dma as "Dma", period as "Period", 
total_in::numeric(20,2) as "Total inlet",
total_out::numeric(20,2) as "Total outlet",
total::numeric(20,2) as "Total injected",
auth as "Authorized Vol.", 
loss as "Losses Vol.", 
(case when total > 0 then 100*(1-auth/total)::numeric(20,2) else 0.00 end) as "NRW"
FROM v_om_waterbalance w', 
filterparam = '[{"columnname":"Exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select name as id, name as idval FROM exploitation WHERE expl_id > 0 ORDER by name","isNullValue":"true"},
{"columnname":"Dma", "label":"Dma:", "widgettype":"combo","datatype":"text","layoutorder":2,
"dvquerytext":"Select name as id, name as idval FROM dma WHERE dma_id != -1 and dma_id!=0 ORDER BY name","isNullValue":"true"},
{"columnname":"Period", "label":"Period:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select code as id, code as idval FROM ext_cat_period WHERE id IS NOT NULL ORDER BY end_date DESC","isNullValue":"true"}]'
WHERE id = 102;

UPDATE config_report SET query_text = 
'SELECT n.exploitation as "Exploitation",
(sum(n.total))::numeric(20,2) as "Total injected", 
sum(auth) as "Authorized Vol.", 
sum(loss) as "Losses Vol.", 
(case when sum(n.total) > 0 THEN 100*(1-sum(auth)/sum(total))::numeric(20,2) else 0.00 end) as "NRW"
FROM v_om_waterbalance n  WHERE n.dma IS NOT NULL '
WHERE id = 103;


UPDATE config_report SET query_text = 
'SELECT n.exploitation as "Exploitation", n.dma as "Dma", 
(sum(n.total))::numeric(20,2) as "Total injected", 
sum(auth) as "Authorized Vol.", 
sum(loss) as "Losses Vol.", 
(case when sum(n.total) > 0 THEN 100*(1-sum(auth)/sum(total))::numeric(20,2) else 0.00 end) as "NRW"
FROM v_om_waterbalance n  WHERE n.dma IS NOT NULL '
WHERE id = 104;

UPDATE config_toolbox SET alias ='Mapzones Netscenario analysis'
where id = 3256;



. Manage null values on shortpipe status

UPDATE config_form_fields set dv_querytext = 'SELECT DISTINCT (id) AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_status_shortpipe''' 
WHERE formname in ('ve_epa_shortpipe', 'v_edit_inp_shortpipe') and columnname ='status';

UPDATE config_form_fields set dv_querytext = 'SELECT DISTINCT (id) AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_status_shortpipe_dscen''' 
WHERE formname in ('v_edit_inp_dscenario_shortpipe') and columnname ='status';

UPDATE config_form_fields set dv_isnullvalue =True  WHERE formname in ('ve_epa_shortpipe', 'v_edit_inp_shortpipe') and columnname ='status';

INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_value_status_shortpipe', 'CV', 'CV', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_value_status_shortpipe_dscen', 'CV', 'CV', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_value_status_shortpipe_dscen', 'OPEN', 'OPEN', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_value_status_shortpipe_dscen', 'CLOSED', 'CLOSED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;


ALTER TABLE inp_shortpipe DROP CONSTRAINT inp_shortpipe_status_check;
ALTER TABLE inp_shortpipe ADD CONSTRAINT inp_shortpipe_status_check CHECK (((status)::text = ANY ((ARRAY[''::character varying, 'CV'::character varying, 'OPEN'::character varying, 'CLOSED'::character varying])::text[])));

UPDATE sys_message SET hint_message='Unlink hydrometers first or set edit_connec_downgrade_force on config_param_system to true' WHERE id=3194;

INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('rpt_arc_stats', 'Table to store result stats in order to gain performance showing results', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('rpt_node_stats', 'Table to store result stats in order to gain performance showing results', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;


UPDATE cat_arc SET shape='CIRCULAR' WHERE shape IS NULL;
ALTER TABLE cat_arc ALTER COLUMN shape SET NOT NULL;

UPDATE config_fprocess SET orderby=4 WHERE fid=239 AND tablename='vi_curves';

UPDATE config_toolbox SET inputparams='[{"widgetname":"executeGraphDma", "label":"Execute Graph for DMA:", "widgettype":"check","datatype":"boolean","tooltip":"If true, graphaanalytics mapzones will be triggered for DMA and expl selected" , "layoutname":"grl_option_parameters","layoutorder":1,"value":""},
{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"period", "label":"Period:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"SELECT id, code as idval FROM ext_cat_period ORDER BY end_date DESC", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"method", "label":"Method:","widgettype":"combo","datatype":"text","isMandatory":true,"tooltip":"Water balance method", "dvQueryText":"SELECT id, idval FROM om_typevalue WHERE typevalue = ''waterbalance_method''", "layoutname":"grl_option_parameters","layoutorder":4, "value":""}
]'::json WHERE id=3142;

ALTER TABLE inp_connec DROP CONSTRAINT inp_connec_pattern_id_fkey;
ALTER TABLE inp_connec ADD CONSTRAINT inp_connec_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_connec DROP CONSTRAINT inp_demand_pattern_id_fkey;
ALTER TABLE inp_dscenario_connec ADD CONSTRAINT inp_demand_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_demand DROP CONSTRAINT inp_dscenario_demand_pattern_id_fkey;
ALTER TABLE inp_dscenario_demand ADD CONSTRAINT inp_dscenario_demand_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_inlet DROP CONSTRAINT inp_dscenario_inlet_pattern_id_fkey;
ALTER TABLE inp_dscenario_inlet ADD CONSTRAINT inp_dscenario_inlet_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_junction DROP CONSTRAINT inp_dscenario_junction_pattern_id_fkey;
ALTER TABLE inp_dscenario_junction ADD CONSTRAINT inp_dscenario_junction_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_dscenario_pump DROP CONSTRAINT inp_dscenario_pump_curve_id_fkey;
ALTER TABLE inp_dscenario_pump ADD CONSTRAINT inp_dscenario_pump_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_pump DROP CONSTRAINT inp_dscenario_pump_pattern_id_fkey;
ALTER TABLE inp_dscenario_pump ADD CONSTRAINT inp_dscenario_pump_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_dscenario_pump ADD CONSTRAINT inp_dscenario_pump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_dscenario_pump_additional DROP CONSTRAINT inp_dscenario_pump_additional_pattern_id_fkey;
ALTER TABLE inp_dscenario_pump_additional ADD CONSTRAINT inp_dscenario_pump_additional_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	 
ALTER TABLE inp_dscenario_pump_additional ADD CONSTRAINT inp_dscenario_pump_additional_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_dscenario_reservoir DROP CONSTRAINT inp_dscenario_reservoir_pattern_id_fkey;
ALTER TABLE inp_dscenario_reservoir ADD CONSTRAINT inp_dscenario_reservoir_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_tank DROP CONSTRAINT inp_dscenario_tank_curve_id_fkey;
ALTER TABLE inp_dscenario_tank ADD CONSTRAINT inp_dscenario_tank_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_dscenario_virtualpump DROP CONSTRAINT inp_dscenario_virtualpump_curve_id_fkey;
ALTER TABLE inp_dscenario_virtualpump ADD CONSTRAINT inp_dscenario_virtualpump_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_dscenario_virtualpump ADD CONSTRAINT inp_dscenario_virtualpump_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_dscenario_virtualpump ADD CONSTRAINT inp_dscenario_virtualpump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_junction DROP CONSTRAINT inp_junction_pattern_id_fkey;
ALTER TABLE inp_junction ADD CONSTRAINT inp_junction_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_pump DROP CONSTRAINT inp_pump_curve_id_fkey;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_pump DROP CONSTRAINT inp_pump_to_arc_fkey;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_to_arc_fkey FOREIGN KEY (to_arc)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
	  
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_pump_additional DROP CONSTRAINT inp_pump_additional_curve_id_fkey;
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_pump_additional DROP CONSTRAINT inp_pump_additional_pattern_id_fkey;
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_reservoir DROP CONSTRAINT inp_reservoir_pattern_id_fkey;
ALTER TABLE inp_reservoir ADD CONSTRAINT inp_reservoir_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_tank DROP CONSTRAINT inp_tank_curve_id_fkey;
ALTER TABLE inp_tank ADD CONSTRAINT inp_tank_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_valve DROP CONSTRAINT inp_valve_curve_id_fkey;
ALTER TABLE inp_valve ADD CONSTRAINT inp_valve_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_virtualpump DROP CONSTRAINT inp_virtualpump_curve_id_fkey;
ALTER TABLE inp_virtualpump ADD CONSTRAINT inp_virtualpump_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_virtualpump ADD CONSTRAINT inp_virtualpump_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	  
ALTER TABLE inp_virtualpump ADD CONSTRAINT inp_virtualpump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;	 

ALTER TABLE inp_virtualvalve DROP CONSTRAINT inp_virtualvalve_curve_id_fkey;
ALTER TABLE inp_virtualvalve ADD CONSTRAINT inp_virtualvalve_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
