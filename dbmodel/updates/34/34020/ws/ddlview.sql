/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/07/16

CREATE OR REPLACE VIEW vi_junctions AS 
 SELECT DISTINCT ON (a.node_id) a.node_id,
    a.elevation,
    a.demand,
    a.pattern_id
   FROM ( SELECT rpt_inp_node.node_id,
            rpt_inp_node.elev AS elevation,
            rpt_inp_node.demand,
            rpt_inp_node.pattern_id
           FROM selector_inp_result,
            rpt_inp_node
             JOIN inp_junction ON inp_junction.node_id::text = rpt_inp_node.node_id::text
          WHERE rpt_inp_node.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND rpt_inp_node.epa_type::text = 'JUNCTION'::text
        UNION
         SELECT rpt_inp_node.node_id,
            rpt_inp_node.elev,
            rpt_inp_node.demand,
            rpt_inp_node.pattern_id
           FROM selector_inp_result,
            rpt_inp_node
             JOIN inp_valve ON inp_valve.node_id::text = rpt_inp_node.node_id::text
          WHERE rpt_inp_node.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND rpt_inp_node.epa_type::text = 'JUNCTION'::text
        UNION
         SELECT rpt_inp_node.node_id,
            rpt_inp_node.elev,
            rpt_inp_node.demand,
            rpt_inp_node.pattern_id
           FROM selector_inp_result,
            rpt_inp_node
             JOIN inp_pump ON inp_pump.node_id::text = rpt_inp_node.node_id::text
          WHERE rpt_inp_node.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND rpt_inp_node.epa_type::text = 'JUNCTION'::text
        UNION
         SELECT rpt_inp_node.node_id,
            rpt_inp_node.elev,
            rpt_inp_node.demand,
            rpt_inp_node.pattern_id
           FROM selector_inp_result,
            rpt_inp_node
             JOIN inp_tank ON inp_tank.node_id::text = rpt_inp_node.node_id::text
          WHERE rpt_inp_node.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND rpt_inp_node.epa_type::text = 'JUNCTION'::text
        UNION
         SELECT rpt_inp_node.node_id,
            rpt_inp_node.elev,
            rpt_inp_node.demand,
            rpt_inp_node.pattern_id
           FROM selector_inp_result,
            rpt_inp_node
             JOIN inp_inlet ON inp_inlet.node_id::text = rpt_inp_node.node_id::text
          WHERE rpt_inp_node.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND rpt_inp_node.epa_type::text = 'JUNCTION'::text
        UNION
         SELECT rpt_inp_node.node_id,
            rpt_inp_node.elev,
            rpt_inp_node.demand,
            rpt_inp_node.pattern_id
           FROM selector_inp_result,
            rpt_inp_node
             JOIN inp_shortpipe ON inp_shortpipe.node_id::text = rpt_inp_node.node_id::text
          WHERE rpt_inp_node.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND rpt_inp_node.epa_type::text = 'JUNCTION'::text
        UNION
         SELECT rpt_inp_node.node_id,
            rpt_inp_node.elev,
            rpt_inp_node.demand,
            rpt_inp_node.pattern_id
           FROM selector_inp_result,
            rpt_inp_node
          WHERE (rpt_inp_node.epa_type::text = ANY (ARRAY['JUNCTION'::character varying::text, 'SHORTPIPE'::character varying::text])) AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text) a
  ORDER BY a.node_id;


drop VIEW if exists vi_pjoint;
CREATE OR REPLACE VIEW vi_pjoint AS 
SELECT v_edit_inp_connec.pjoint_id,
     pjoint_type,
    sum(v_edit_inp_connec.demand) AS sum
   FROM v_edit_inp_connec
  WHERE v_edit_inp_connec.pjoint_id IS NOT NULL
  GROUP BY v_edit_inp_connec.pjoint_id, pjoint_type;


CREATE OR REPLACE VIEW v_inp_pjointpattern AS 
 SELECT row_number() OVER (ORDER BY a.pattern_id, a.idrow) AS id,
    a.idrow,
        CASE
            WHEN a.pjoint_type::text = 'VNODE'::text THEN concat('VN', a.pattern_id)::character varying
            ELSE a.pattern_id
        END AS pattern_id,
    a.pjoint_type,
    sum(a.factor_1)::numeric(10,8) AS factor_1,
    sum(a.factor_2)::numeric(10,8) AS factor_2,
    sum(a.factor_3)::numeric(10,8) AS factor_3,
    sum(a.factor_4)::numeric(10,8) AS factor_4,
    sum(a.factor_5)::numeric(10,8) AS factor_5,
    sum(a.factor_6)::numeric(10,8) AS factor_6,
    sum(a.factor_7)::numeric(10,8) AS factor_7,
    sum(a.factor_8)::numeric(10,8) AS factor_8,
    sum(a.factor_9)::numeric(10,8) AS factor_9,
    sum(a.factor_10)::numeric(10,8) AS factor_10,
    sum(a.factor_11)::numeric(10,8) AS factor_11,
    sum(a.factor_12)::numeric(10,8) AS factor_12,
    sum(a.factor_13)::numeric(10,8) AS factor_13,
    sum(a.factor_14)::numeric(10,8) AS factor_14,
    sum(a.factor_15)::numeric(10,8) AS factor_15,
    sum(a.factor_16)::numeric(10,8) AS factor_16,
    sum(a.factor_17)::numeric(10,8) AS factor_17,
    sum(a.factor_18)::numeric(10,8) AS factor_18
   FROM ( SELECT c.pjoint_type,
                CASE
                    WHEN b.id = (( SELECT min(sub.id) AS min
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 1
                    WHEN b.id = (( SELECT min(sub.id) + 1
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 2
                    WHEN b.id = (( SELECT min(sub.id) + 2
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 3
                    WHEN b.id = (( SELECT min(sub.id) + 3
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 4
                    WHEN b.id = (( SELECT min(sub.id) + 4
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 5
                    WHEN b.id = (( SELECT min(sub.id) + 5
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 6
                    WHEN b.id = (( SELECT min(sub.id) + 6
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 7
                    WHEN b.id = (( SELECT min(sub.id) + 7
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 8
                    WHEN b.id = (( SELECT min(sub.id) + 8
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 9
                    WHEN b.id = (( SELECT min(sub.id) + 9
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 10
                    WHEN b.id = (( SELECT min(sub.id) + 10
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 11
                    WHEN b.id = (( SELECT min(sub.id) + 11
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 12
                    WHEN b.id = (( SELECT min(sub.id) + 12
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 13
                    WHEN b.id = (( SELECT min(sub.id) + 13
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 14
                    WHEN b.id = (( SELECT min(sub.id) + 14
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 15
                    WHEN b.id = (( SELECT min(sub.id) + 15
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 16
                    WHEN b.id = (( SELECT min(sub.id) + 16
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 17
                    WHEN b.id = (( SELECT min(sub.id) + 17
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 18
                    WHEN b.id = (( SELECT min(sub.id) + 18
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 19
                    WHEN b.id = (( SELECT min(sub.id) + 19
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 20
                    WHEN b.id = (( SELECT min(sub.id) + 20
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 21
                    WHEN b.id = (( SELECT min(sub.id) + 21
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 22
                    WHEN b.id = (( SELECT min(sub.id) + 22
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 23
                    WHEN b.id = (( SELECT min(sub.id) + 23
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 24
                    WHEN b.id = (( SELECT min(sub.id) + 24
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 25
                    WHEN b.id = (( SELECT min(sub.id) + 25
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 26
                    WHEN b.id = (( SELECT min(sub.id) + 26
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 27
                    WHEN b.id = (( SELECT min(sub.id) + 27
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 28
                    WHEN b.id = (( SELECT min(sub.id) + 28
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 29
                    WHEN b.id = (( SELECT min(sub.id) + 29
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 30
                    ELSE NULL::integer
                END AS idrow,
            c.pjoint_id AS pattern_id,
            sum(c.demand::double precision * b.factor_1::double precision) AS factor_1,
            sum(c.demand::double precision * b.factor_2::double precision) AS factor_2,
            sum(c.demand::double precision * b.factor_3::double precision) AS factor_3,
            sum(c.demand::double precision * b.factor_4::double precision) AS factor_4,
            sum(c.demand::double precision * b.factor_5::double precision) AS factor_5,
            sum(c.demand::double precision * b.factor_6::double precision) AS factor_6,
            sum(c.demand::double precision * b.factor_7::double precision) AS factor_7,
            sum(c.demand::double precision * b.factor_8::double precision) AS factor_8,
            sum(c.demand::double precision * b.factor_9::double precision) AS factor_9,
            sum(c.demand::double precision * b.factor_10::double precision) AS factor_10,
            sum(c.demand::double precision * b.factor_11::double precision) AS factor_11,
            sum(c.demand::double precision * b.factor_12::double precision) AS factor_12,
            sum(c.demand::double precision * b.factor_13::double precision) AS factor_13,
            sum(c.demand::double precision * b.factor_14::double precision) AS factor_14,
            sum(c.demand::double precision * b.factor_15::double precision) AS factor_15,
            sum(c.demand::double precision * b.factor_16::double precision) AS factor_16,
            sum(c.demand::double precision * b.factor_17::double precision) AS factor_17,
            sum(c.demand::double precision * b.factor_18::double precision) AS factor_18
           FROM ( SELECT inp_connec.connec_id,
                    inp_connec.demand,
                    inp_connec.pattern_id,
                    connec.pjoint_id,
                    connec.pjoint_type
                   FROM inp_connec
                     JOIN connec USING (connec_id)) c
             JOIN inp_pattern_value b USING (pattern_id)
          GROUP BY c.pjoint_type, c.pjoint_id, (
                CASE
                    WHEN b.id = (( SELECT min(sub.id) AS min
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 1
                    WHEN b.id = (( SELECT min(sub.id) + 1
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 2
                    WHEN b.id = (( SELECT min(sub.id) + 2
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 3
                    WHEN b.id = (( SELECT min(sub.id) + 3
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 4
                    WHEN b.id = (( SELECT min(sub.id) + 4
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 5
                    WHEN b.id = (( SELECT min(sub.id) + 5
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 6
                    WHEN b.id = (( SELECT min(sub.id) + 6
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 7
                    WHEN b.id = (( SELECT min(sub.id) + 7
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 8
                    WHEN b.id = (( SELECT min(sub.id) + 8
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 9
                    WHEN b.id = (( SELECT min(sub.id) + 9
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 10
                    WHEN b.id = (( SELECT min(sub.id) + 10
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 11
                    WHEN b.id = (( SELECT min(sub.id) + 11
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 12
                    WHEN b.id = (( SELECT min(sub.id) + 12
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 13
                    WHEN b.id = (( SELECT min(sub.id) + 13
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 14
                    WHEN b.id = (( SELECT min(sub.id) + 14
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 15
                    WHEN b.id = (( SELECT min(sub.id) + 15
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 16
                    WHEN b.id = (( SELECT min(sub.id) + 16
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 17
                    WHEN b.id = (( SELECT min(sub.id) + 17
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 18
                    WHEN b.id = (( SELECT min(sub.id) + 18
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 19
                    WHEN b.id = (( SELECT min(sub.id) + 19
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 20
                    WHEN b.id = (( SELECT min(sub.id) + 20
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 21
                    WHEN b.id = (( SELECT min(sub.id) + 21
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 22
                    WHEN b.id = (( SELECT min(sub.id) + 22
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 23
                    WHEN b.id = (( SELECT min(sub.id) + 23
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 24
                    WHEN b.id = (( SELECT min(sub.id) + 24
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 25
                    WHEN b.id = (( SELECT min(sub.id) + 25
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 26
                    WHEN b.id = (( SELECT min(sub.id) + 26
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 27
                    WHEN b.id = (( SELECT min(sub.id) + 27
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 28
                    WHEN b.id = (( SELECT min(sub.id) + 28
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 29
                    WHEN b.id = (( SELECT min(sub.id) + 29
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 30
                    ELSE NULL::integer
                END)) a
  GROUP BY a.idrow, a.pattern_id, a.pjoint_type;
  

CREATE OR REPLACE VIEW v_edit_man_valve AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszone_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.district_id,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    v_node.the_geom,
    man_valve.closed,
    man_valve.broken,
    man_valve.buried,
    man_valve.irrigation_indicator,
    man_valve.pression_entry,
    man_valve.pression_exit,
    man_valve.depth_valveshaft,
    man_valve.regulator_situation,
    man_valve.regulator_location,
    man_valve.regulator_observ,
    man_valve.lin_meters,
    man_valve.exit_type,
    man_valve.exit_code,
    man_valve.drive_type,
    man_valve.cat_valve2,
    man_valve.ordinarystatus,
    v_node.adate,
    v_node.adescript,
    v_node.accessibility,
    shutter,
    brand,
    brand2,
    model,
    model2
   FROM v_node
     JOIN man_valve ON man_valve.node_id::text = v_node.node_id::text;
