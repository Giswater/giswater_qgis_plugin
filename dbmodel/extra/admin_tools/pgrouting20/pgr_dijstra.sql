CREATE OR REPLACE FUNCTION public.pgr_dijkstra(
    sql text,
    source_id int8,
    target_id int8)
  RETURNS integer AS
$BODY$
BEGIN
    SET search_path = "SCHEMA_NAME", public;
    RETURN pgr_dijkstra($1, $2::int4, $3::int4, false, false); 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;