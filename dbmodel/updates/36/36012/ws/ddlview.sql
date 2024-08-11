/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--26/07/2024
CREATE OR REPLACE VIEW v_ui_rpt_cat_result
AS SELECT DISTINCT ON (rpt_cat_result.result_id) rpt_cat_result.result_id,
    rpt_cat_result.expl_id,
    rpt_cat_result.sector_id,
    t2.idval AS network_type,
    t1.idval AS status,
    rpt_cat_result.iscorporate,
    rpt_cat_result.descript,
    rpt_cat_result.exec_date,
    rpt_cat_result.cur_user,
    rpt_cat_result.export_options,
    rpt_cat_result.network_stats,
    rpt_cat_result.inp_options,
    rpt_cat_result.rpt_stats,
    rpt_cat_result.addparam
   FROM selector_expl s,
    rpt_cat_result
     LEFT JOIN inp_typevalue t1 ON rpt_cat_result.status::text = t1.id::text
     LEFT JOIN inp_typevalue t2 ON rpt_cat_result.network_type::text = t2.id::text
  WHERE t1.typevalue::text = 'inp_result_status'::text AND t2.typevalue::text = 'inp_options_networkmode'::text AND ((s.expl_id = ANY (rpt_cat_result.expl_id)) AND s.cur_user = CURRENT_USER OR rpt_cat_result.expl_id = ARRAY[NULL]::INTEGER[]);


-- 07/08/2024
CREATE OR REPLACE VIEW vu_sector
AS SELECT s.sector_id,
    s.name,
    ms.name AS macrosector,
    s.descript,
    s.undelete,
    s.sector_type,
    s.active,
    s.parent_id,
    s.pattern_id,
    s.tstamp,
    s.insert_user,
    s.lastupdate,
    s.lastupdate_user,
    s.graphconfig,
    s.stylesheet
   FROM sector s
     LEFT JOIN macrosector ms ON ms.macrosector_id = s.macrosector_id
  ORDER BY s.sector_id;

CREATE OR REPLACE VIEW vu_dma
AS SELECT d.dma_id,
    d.name,
    d.descript,
    d.expl_id,
    md.name AS macrodma,
    d.active,
    d.undelete,
    d.minc,
    d.maxc,
    d.effc,
    d.avg_press,
    d.pattern_id,
    d.link,
    d.graphconfig,
    d.stylesheet,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user
   FROM dma d
     LEFT JOIN macrodma md ON md.macrodma_id = d.macrodma_id
  ORDER BY d.dma_id;

CREATE OR REPLACE VIEW vu_presszone
AS SELECT p.presszone_id,
    p.name,
    p.descript,
    p.expl_id,
    p.link,
    p.head,
    p.active,
    p.graphconfig,
    p.stylesheet,
    p.tstamp,
    p.insert_user,
    p.lastupdate,
    p.lastupdate_user
   FROM presszone p
  ORDER BY p.presszone_id;


CREATE OR REPLACE VIEW vu_dqa
AS SELECT d.dqa_id,
    d.name,
    d.descript,
    d.expl_id,
    md.name AS macrodma,
    d.active,
    d.undelete,
    d.the_geom,
    d.pattern_id,
    d.dqa_type,
    d.link,
    d.graphconfig,
    d.stylesheet,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user
   FROM dqa d
     LEFT JOIN macrodqa md ON md.macrodqa_id = d.macrodqa_id
  ORDER BY d.dqa_id;


DROP VIEW v_edit_inp_inlet;
CREATE OR REPLACE VIEW v_edit_inp_inlet AS 
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
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
    inp_inlet.overflow,
    inp_inlet.mixing_model,
    inp_inlet.mixing_fraction,
    inp_inlet.reaction_coeff,
    inp_inlet.init_quality,
    inp_inlet.source_type,
    inp_inlet.source_quality,
    inp_inlet.source_pattern_id,
    inp_inlet.pattern_id,
    inp_inlet.head,
    inp_inlet.demand,
    inp_inlet.demand_pattern_id,
    inp_inlet.emitter_coeff,
    n.the_geom
   FROM v_node n
     JOIN inp_inlet USING (node_id)
     JOIN v_sector_node s ON s.node_id::text = n.node_id::text
  WHERE n.is_operative IS TRUE;

CREATE TRIGGER gw_trg_edit_inp_node_inlet INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_inlet
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_inlet');


DROP VIEW v_edit_inp_dscenario_inlet;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_inlet AS 
 SELECT p.dscenario_id,
    n.node_id,
    p.initlevel,
    p.minlevel,
    p.maxlevel,
    p.diameter,
    p.minvol,
    p.curve_id,
    p.overflow,
    p.mixing_model,
    p.mixing_fraction,
    p.reaction_coeff,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
    p.head,
    p.pattern_id,
    p.demand,
    p.demand_pattern_id,
    p.emitter_coeff,
    n.the_geom
   FROM selector_inp_dscenario,  v_node n
     JOIN inp_dscenario_inlet p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
     JOIN v_sector_node s ON s.node_id::text = n.node_id::text
  WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND n.is_operative IS TRUE;


CREATE TRIGGER gw_trg_edit_inp_dscenario_junction INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_dscenario_inlet
FOR EACH ROW EXECUTE PROCEDURE ws36012.gw_trg_edit_inp_dscenario('INLET');