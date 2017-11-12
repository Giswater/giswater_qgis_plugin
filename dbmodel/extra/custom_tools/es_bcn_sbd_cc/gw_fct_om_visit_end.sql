DROP FUNCTION IF EXISTS sanejament.gw_fct_om_visit_end ();

CREATE OR REPLACE FUNCTION sanejament.gw_fct_om_visit_end()
  RETURNS smallint AS
$BODY$
DECLARE
min_dia_aux date;
max_dia_aux date;



BEGIN

-- Initializing
	SET search_path = "sanejament", public;
	SET datestyle=European;


  	
-- identifying period:
	SELECT minim INTO min_dia_aux FROM (SELECT min(dia::date)as minim FROM temp_om_visit_node UNION SELECT min(dia::date) as minim FROM temp_om_visit_arc)a;
	SELECT maxim INTO max_dia_aux FROM (SELECT max(dia::date)as maxim FROM temp_om_visit_node UNION SELECT max(dia::date) as maxim FROM temp_om_visit_arc)a;
			
				
-- insert into selector_date table
	DELETE FROM selector_date WHERE cur_user=current_user;
	INSERT INTO selector_date (from_date, to_date, context, cur_user) VALUES (min_dia_aux, max_dia_aux, 'om_visit', current_user);


-- Delete values on temporal tables
	DELETE FROM temp_om_visit_arc;
	DELETE FROM temp_om_visit_node;



RETURN 0;	
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
