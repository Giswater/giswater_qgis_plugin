/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_edit_inp_shortpipe AS 
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    concat(n.node_id, '_n2a') AS nodarc_id,
    inp_shortpipe.minorloss,
    c.to_arc,
    CASE WHEN c.node_id is not null THEN 'CV'::varchar(12) when v.closed is true THEN 'CLOSED'::varchar(12) 
	when v.closed is false THEN 'OPEN'::varchar(12) ELSE NULL::varchar(12) END status,
    inp_shortpipe.bulk_coeff,
    inp_shortpipe.wall_coeff,
    n.the_geom
   FROM selector_sector,
    v_node n
     JOIN inp_shortpipe USING (node_id)
     LEFT JOIN config_graph_checkvalve c ON c.node_id = n.node_id
     LEFT JOIN man_valve v ON v.node_id = n.node_id
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND n.is_operative IS TRUE;


CREATE OR REPLACE VIEW ve_epa_shortpipe AS 
 SELECT inp_shortpipe.node_id,
    inp_shortpipe.minorloss,
    c.to_arc,
        CASE
            WHEN c.node_id IS NOT NULL THEN 'CV'::character varying(12)
            WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
            WHEN v.closed IS FALSE THEN 'OPEN'::character varying(12)
            ELSE NULL::character varying(12)
        END AS status,
    inp_shortpipe.bulk_coeff,
    inp_shortpipe.wall_coeff,
    concat(inp_shortpipe.node_id, '_n2a') AS nodarc_id,
    v_rpt_arc.result_id,
    v_rpt_arc.flow_max AS flowmax,
    v_rpt_arc.flow_min AS flowmin,
    v_rpt_arc.flow_avg AS flowavg,
    v_rpt_arc.vel_max AS velmax,
    v_rpt_arc.vel_min AS velmin,
    v_rpt_arc.vel_avg AS velavg,
    v_rpt_arc.headloss_max,
    v_rpt_arc.headloss_min,
    v_rpt_arc.setting_max,
    v_rpt_arc.setting_min,
    v_rpt_arc.reaction_max,
    v_rpt_arc.reaction_min,
    v_rpt_arc.ffactor_max,
    v_rpt_arc.ffactor_min
   FROM inp_shortpipe
     LEFT JOIN v_rpt_arc ON concat(inp_shortpipe.node_id, '_n2a') = v_rpt_arc.arc_id::text
     LEFT JOIN config_graph_checkvalve c ON c.node_id::text = inp_shortpipe.node_id::text
     LEFT JOIN man_valve v ON v.node_id::text = inp_shortpipe.node_id::text;
	 

INSERT INTO config_graph_checkvalve SELECT node_id, to_arc, true FROM inp_shortpipe WHERE status = 'CV' 
ON CONFLICT (node_id) DO NOTHING;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_shortpipe", "column":"status"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_shortpipe", "column":"to_arc"}}$$);

CREATE OR REPLACE VIEW v_edit_dma
AS SELECT dma.dma_id,
    dma.name,
    dma.macrodma_id,
    dma.descript,
    dma.the_geom,
    dma.undelete,
    dma.expl_id,
    dma.pattern_id,
    dma.link,
    dma.minc,
    dma.maxc,
    dma.effc,
    dma.graphconfig::text AS graphconfig,
    dma.stylesheet::text AS stylesheet,
    dma.active,
    dma.avg_press,
    dma.expl_id2
   FROM selector_expl,
    dma
  WHERE dma.expl_id = selector_expl.expl_id OR dma.expl_id2 = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_dqa
AS SELECT dqa.dqa_id,
    dqa.name,
    dqa.expl_id,
    dqa.macrodqa_id,
    dqa.descript,
    dqa.undelete,
    dqa.the_geom,
    dqa.pattern_id,
    dqa.dqa_type,
    dqa.link,
    dqa.graphconfig::text AS graphconfig,
    dqa.stylesheet::text AS stylesheet,
    dqa.active,
    dqa.avg_press,
    dqa.expl_id2
   FROM selector_expl,
    dqa
  WHERE dqa.expl_id = selector_expl.expl_id OR dqa.expl_id2 = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_sector
AS SELECT sector.sector_id,
    sector.name,
    sector.descript,
    sector.macrosector_id,
    sector.the_geom,
    sector.undelete,
    sector.graphconfig::text AS graphconfig,
    sector.stylesheet::text AS stylesheet,
    sector.active,
    sector.parent_id,
    sector.pattern_id,
    sector.avg_press,
    sector.expl_id2
   FROM selector_sector,
    sector
  WHERE sector.sector_id = selector_sector.sector_id OR sector.expl_id2 = selector_expl.expl_id AND selector_sector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_presszone
AS SELECT presszone.presszone_id,
    presszone.name,
    presszone.expl_id,
    presszone.the_geom,
    presszone.graphconfig::text AS graphconfig,
    presszone.head,
    presszone.stylesheet::text AS stylesheet,
    presszone.active,
    presszone.descript,
    presszone.avg_press,
    presszone.presszone_type,
    presszone.expl_id2
   FROM selector_expl,
    presszone
  WHERE presszone.expl_id = selector_expl.expl_id OR presszone.expl_id2 = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;
  

-- 19/06/2024
CREATE OR REPLACE VIEW v_edit_plan_netscenario_dma
AS SELECT n.netscenario_id,
    p.name AS netscenario_name,
    n.dma_id,
    n.dma_name AS name,
    n.pattern_id,
    n.graphconfig,
    n.the_geom,
    n.active,
    n.stylesheet::text AS stylesheet,
    n.expl_id2
   FROM selector_netscenario,
    plan_netscenario_dma n
     JOIN plan_netscenario p USING (netscenario_id)
  WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_plan_netscenario_presszone
AS SELECT n.netscenario_id,
    p.name AS netscenario_name,
    n.presszone_id,
    n.presszone_name AS name,
    n.head,
    n.graphconfig,
    n.the_geom,
    n.active,
    n.presszone_type,
    n.stylesheet::text AS stylesheet,
    n.expl_id2
   FROM selector_netscenario,
    plan_netscenario_presszone n
     JOIN plan_netscenario p USING (netscenario_id)
  WHERE n.netscenario_id = selector_netscenario.netscenario_id AND selector_netscenario.cur_user = "current_user"()::text;
