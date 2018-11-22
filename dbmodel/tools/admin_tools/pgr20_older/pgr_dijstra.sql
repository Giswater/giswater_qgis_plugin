CREATE OR REPLACE FUNCTION public.pgr_dijkstra(
    sql text,
    source_id int8,
    target_id int8)
  RETURNS integer AS
$BODY$

/*
This is the pgr_dijkstra function for pg_routing on debian 9.4
We need to incorporate other change on gw_fct_mincut_inverted_flowtrace
on line 57, 58,59 must be:

				''SELECT v_edit_arc.arc_id::int4 as id, node_1::int4 as source, node_2::int4 as target, 
				(case when closed=true then -1 else 1 end)::float as cost,
				(case when closed=true then -1 else 1 end)::float as reverse_cost
*/

BEGIN
    SET search_path = "SCHEMA_NAME", public;
    PERFORM pgr_dijkstra($1, $2::int4, $3::int4, false, false); 
    RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;