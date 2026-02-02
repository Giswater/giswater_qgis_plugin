/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 02/02/2026

DROP VIEW IF EXISTS v_rpt_compare_node;
CREATE OR REPLACE VIEW v_rpt_comp_node_stats
AS SELECT r.node_id,
    r.result_id,
    r.node_type,
    r.sector_id,
    r.nodecat_id,
    r.top_elev AS elevation,
    r.demand_max,
    r.demand_min,
    r.demand_avg,
    r.head_max,
    r.head_min,
    r.head_avg,
    r.press_max,
    r.press_min,
    r.press_avg,
    r.quality_max,
    r.quality_min,
    r.quality_avg,
    r.the_geom
   FROM rpt_node_stats r,
    selector_rpt_compare s
     JOIN selector_rpt_compare USING (result_id);
