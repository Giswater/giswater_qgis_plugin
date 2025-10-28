/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 28/10/2025
CREATE OR REPLACE VIEW ve_plan_netscenario_dma
AS WITH plan_netscenario_current AS (
         SELECT config_param_user.value::integer AS netscenario_id
           FROM config_param_user
          WHERE config_param_user.cur_user::text = CURRENT_USER AND config_param_user.parameter::text = 'plan_netscenario_current'::text
         LIMIT 1
        ), sel_expl AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        )
 SELECT n.netscenario_id,
    p.name AS netscenario_name,
    n.dma_id,
    n.dma_name AS name,
    n.pattern_id,
    n.graphconfig,
    n.the_geom,
    n.active,
    n.stylesheet::text AS stylesheet,
    n.expl_id,
    n.muni_id,
    n.sector_id
   FROM plan_netscenario_dma n
     JOIN plan_netscenario p USING (netscenario_id)
     JOIN plan_netscenario_current pnc ON n.netscenario_id = pnc.netscenario_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_expl
          WHERE sel_expl.expl_id = p.expl_id));

CREATE OR REPLACE VIEW ve_plan_netscenario_presszone
AS WITH plan_netscenario_current AS (
         SELECT config_param_user.value::integer AS netscenario_id
           FROM config_param_user
          WHERE config_param_user.cur_user::text = CURRENT_USER AND config_param_user.parameter::text = 'plan_netscenario_current'::text
         LIMIT 1
        ), sel_expl AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        )
 SELECT n.netscenario_id,
    p.name AS netscenario_name,
    n.presszone_id,
    n.presszone_name AS name,
    n.head,
    n.graphconfig,
    n.the_geom,
    n.active,
    n.presszone_type,
    n.stylesheet::text AS stylesheet,
    n.expl_id,
    n.muni_id,
    n.sector_id
   FROM plan_netscenario_presszone n
     JOIN plan_netscenario p USING (netscenario_id)
     JOIN plan_netscenario_current pnc ON n.netscenario_id = pnc.netscenario_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_expl
          WHERE sel_expl.expl_id = p.expl_id));
