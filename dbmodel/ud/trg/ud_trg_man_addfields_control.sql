
SET search_path='SCHEMA_NAME';


CREATE TRIGGER gw_trg_man_addfields_value_connec_gully AFTER INSERT OR UPDATE OF gully_id OR DELETE ON SCHEMA_NAME.control
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_man_addfields_value_control('GULLY');









  
