/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE MATERIALIZED VIEW v_plan_psector_budget_reporting as
select psector_id, 'arc', arc_id, 1 as order, 'm' as units, 'Pipe' as descript, length::numeric(12,2) as measurement, mlarc_cost::numeric(12,2) as unitary_price, (mlarc_cost*length)::numeric(12,2) as cost from v_plan_psector_budget_detail 
union all
select psector_id, 'arc', arc_id, 2, 'm3m', 'Excavation', (length*m3mlexc)::numeric(12,2), mlexc_cost::numeric(12,2), (length*m3mlexc*mlexc_cost)::numeric(12,2) as exc_cost from v_plan_psector_budget_detail
union all
select psector_id, 'arc', arc_id, 3, 'm2m','Trench linning', (length*m2mltrenchl)::numeric(12,2), mltrench_cost::numeric(12,2), (length*m2mltrenchl*mltrench_cost)::numeric(12,2) as exc_cost from v_plan_psector_budget_detail
union all
select psector_id, 'arc', arc_id, 4, 'm2m','Base', (length*m2mlbase)::numeric(12,2), mlbase_cost::numeric(12,2), (length*m2mlbase*mlbase_cost)::numeric(12,2) as exc_cost from v_plan_psector_budget_detail
union all
select psector_id, 'arc', arc_id, 5, 'm2m','Pavement', (length*m2mlpav)::numeric(12,2), mlpav_cost::numeric(12,2), (length*m2mlpav*mlpav_cost)::numeric(12,2) as exc_cost from v_plan_psector_budget_detail
union all
select psector_id, 'arc', arc_id, 6, 'm3m','Pipe protection', (length*m3mlprotec)::numeric(12,2), mlprotec_cost::numeric(12,2), (length*m3mlprotec*mlprotec_cost)::numeric(12,2) as exc_cost from v_plan_psector_budget_detail
union all
select psector_id, 'arc', arc_id, 7, 'm3m','Trench filling', (length*m3mlfill)::numeric(12,2), mlfill_cost::numeric(12,2), (length*m3mlfill*mlfill_cost)::numeric(12,2) as exc_cost from v_plan_psector_budget_detail
union all
select psector_id, 'arc', arc_id, 8, 'm3m','Trench excess', (length*m3mlexcess)::numeric(12,2), mlexcess_cost::numeric(12,2), (length*m3mlexcess*mlexcess_cost)::numeric(12,2) as exc_cost from v_plan_psector_budget_detail
union all
select psector_id, 'arc', arc_id, 9, 'ml','Connections', 1::numeric(12,2), other_budget::numeric(12,2), (1*other_budget)::numeric(12,2) as exc_cost from v_plan_psector_budget_detail
union all
select psector_id, 'node', node_id, 1, 'u','Node', measurement::numeric(12,2), cost::numeric(12,2), (1*measurement*cost)::numeric(12,2) as exc_cost from v_plan_psector_budget_node
union all
select psector_id, 'other', price_id, 1, unit, b.descript, measurement, b.price, total_budget from v_plan_psector_budget_other b join plan_price p on p.id = price_id
order by 1,2,3,4;