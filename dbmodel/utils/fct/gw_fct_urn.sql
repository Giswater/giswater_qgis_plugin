
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_urn()
RETURNS void AS
$BODY$
DECLARE 
urn_id_seq integer;

BEGIN 


	SELECT GREATEST (
		(SELECT max(node_id::integer) FROM node WHERE node_id ~ '^\d+$'),
		(SELECT max(arc_id::integer) FROM arc WHERE arc_id ~ '^\d+$'),
		(SELECT max(connec_id::integer) FROM connec WHERE connec_id ~ '^\d+$'),
		(SELECT max(gully_id::integer) FROM gully WHERE gully_id ~ '^\d+$'),
		(SELECT max(link_id::integer) FROM link WHERE link_id ~ '^\d+$'),
		(SELECT max(element_id::integer) FROM element WHERE element_id ~ '^\d+$'),
		(SELECT max(pol_id::integer) FROM polygon WHERE pol_id ~ '^\d+$'),
		(SELECT max(vnode_id::integer) FROM vnode WHERE vnode_id ~ '^\d+$'),
		(SELECT max(sector_id::integer) FROM sector WHERE sector_id ~ '^\d+$'),
		(SELECT max(dma_id::integer) FROM dma WHERE dma_id ~ '^\d+$'),
		(SELECT max(expl_id) FROM exploitation),
		(SELECT max(macrodma_id::integer) FROM macrodma WHERE macrodma_id ~ '^\d+$')
		) INTO urn_id_seq;
		
	RETURN urn_id_seq;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

