SET search_path="SCHEMA_NAME",public;


-- DROP FUNCTION gw_fct_migration_elements();

CREATE OR REPLACE FUNCTION gw_fct_migration_elements()
  RETURNS void AS
$BODY$
DECLARE
   rec_elem record;
	rec_step integer;
	id_last integer;
BEGIN
FOR rec_elem IN SELECT * FROM "TABLE"
        LOOP

            --Insert arc

            INSERT INTO element (elementcat_id,units) VALUES (rec_elem.elementcat_id, rec_elem.units) RETURNING element_id INTO id_last;
            Insert INTO element_x_node (element_id,node_id) VALUES (id_last,rec_elem.node_id);

            
        END LOOP;


    RETURN;
  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

