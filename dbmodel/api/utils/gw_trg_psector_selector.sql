CREATE OR REPLACE FUNCTION ud.gw_trg_psector_selector()
  RETURNS trigger AS
$BODY$

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	

	INSERT INTO selector_psector (psector_id, cur_user) VALUES (NEW.psector_id, current_user);
	INSERT INTO selector_psector (psector_id, cur_user) VALUES (NEW.psector_id, 'qgisserver');

	
	
RETURN NEW;
			
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
