/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;


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