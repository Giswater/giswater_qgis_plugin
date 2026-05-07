/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_plan_psector
AS
WITH base AS (
    SELECT plan_psector.psector_id,
        plan_psector.name,
        plan_psector.psector_type,
        plan_psector.descript,
        plan_psector.priority,
        COALESCE(a.suma, 0::numeric)::numeric(14,2) AS total_arc,
        COALESCE(b.suma, 0::numeric)::numeric(14,2) AS total_node,
        COALESCE(c.suma, 0::numeric)::numeric(14,2) AS total_other,
        plan_psector.text1,
        plan_psector.text2,
        plan_psector.observ,
        plan_psector.rotation,
        plan_psector.scale,
        plan_psector.active,
        plan_psector.gexpenses,
        plan_psector.vat,
        plan_psector.other,
        plan_psector.the_geom
       FROM plan_psector
         LEFT JOIN LATERAL ( SELECT sum(v_plan_arc.total_budget) AS suma
               FROM plan_psector_x_arc
                 JOIN LATERAL ( SELECT v_plan_arc_1.total_budget
                       FROM v_plan_arc v_plan_arc_1
                      WHERE v_plan_arc_1.arc_id = plan_psector_x_arc.arc_id
                     OFFSET 0) v_plan_arc ON true
              WHERE plan_psector_x_arc.psector_id = plan_psector.psector_id
                AND plan_psector_x_arc.doable IS TRUE) a ON true
         LEFT JOIN LATERAL ( SELECT sum(v_plan_node.budget) AS suma
               FROM plan_psector_x_node
                 JOIN LATERAL ( SELECT v_plan_node_1.budget
                       FROM v_plan_node v_plan_node_1
                      WHERE v_plan_node_1.node_id = plan_psector_x_node.node_id
                     OFFSET 0) v_plan_node ON true
              WHERE plan_psector_x_node.psector_id = plan_psector.psector_id
                AND plan_psector_x_node.doable IS TRUE) b ON true
         LEFT JOIN LATERAL ( SELECT sum((plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2)) AS suma
               FROM plan_psector_x_other
                 JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
              WHERE plan_psector_x_other.psector_id = plan_psector.psector_id) c ON true
     WHERE EXISTS ( SELECT 1
               FROM selector_psector
              WHERE selector_psector.psector_id = plan_psector.psector_id
                AND selector_psector.cur_user = CURRENT_USER)
), totals AS (
    SELECT base.psector_id,
        base.name,
        base.psector_type,
        base.descript,
        base.priority,
        base.total_arc,
        base.total_node,
        base.total_other,
        base.text1,
        base.text2,
        base.observ,
        base.rotation,
        base.scale,
        base.active,
        (base.total_arc + base.total_node + base.total_other)::numeric(14,2) AS pem,
        base.gexpenses,
        base.vat,
        base.other,
        base.the_geom
       FROM base
)
 SELECT totals.psector_id,
    totals.name,
    totals.psector_type,
    totals.descript,
    totals.priority,
    totals.total_arc,
    totals.total_node,
    totals.total_other,
    totals.text1,
    totals.text2,
    totals.observ,
    totals.rotation,
    totals.scale,
    totals.active,
    totals.pem,
    totals.gexpenses,
    (totals.pem * (100::numeric + totals.gexpenses) / 100::numeric)::numeric(14,2) AS pec,
    totals.vat,
    ((totals.pem * (100::numeric + totals.gexpenses) / 100::numeric) * (100::numeric + totals.vat) / 100::numeric)::numeric(14,2) AS pec_vat,
    totals.other,
    (((totals.pem * (100::numeric + totals.gexpenses) / 100::numeric) * (100::numeric + totals.vat) / 100::numeric) * (100::numeric + totals.other) / 100::numeric)::numeric(14,2) AS pca,
    totals.the_geom
   FROM totals;
