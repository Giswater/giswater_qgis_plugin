DROP FUNCTION sanejament.gw_fct_om_visit_end ();

CREATE OR REPLACE FUNCTION sanejament.gw_fct_om_visit_end();
  RETURNS smallint AS
$BODY$
DECLARE
min_dia_arc date;
min_dia_node date;
min_dia_aux date;
max_dia_arc date;
max_dia_node date;
max_dia_aux date;



BEGIN

-- Initializing
	SET search_path = "sanejament", public;

  	
-- identifying period:
	SELECT min(dia) INTO min_dia_arc FROM temp_om_visit_arc ;
	SELECT min(dia) min_dia_node FROM temp_om_visit_node;

	SELECT max(dia) max_dia_arc FROM temp_om_visit_arc;
	SELECT max(dia) max_dia_node FROM temp_om_visit_node;
		
	SET min_dia_aux:=min(min_dia_arc, min_dia_node);
	SET max_dia_aux:=min(min_dia_arc, min_dia_node);
		
	
	DELETE FROM temp_om_visit_arc;
	DELETE FROM temp_om_visit_node;
		
					
-- insert into selector_date table
	DELETE * FROM selector_date WHERE cur_user=current_user();
	INSERT INTO selector_date (from_date, to_date, context, cur_user) VALUES (min_dia_aux, max_dia_aux, 'om_visit' current_user());
		
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
