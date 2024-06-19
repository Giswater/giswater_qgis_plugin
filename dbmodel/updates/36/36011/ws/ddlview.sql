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

	 