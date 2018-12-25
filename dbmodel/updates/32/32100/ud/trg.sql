
DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_junction ON "SCHEMA_NAME".ve_inp_junction;
CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_junction 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_junction', 'JUNCTION');
 
DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_divider ON "SCHEMA_NAME".ve_inp_divider;
CREATE TRIGGER gw_trg_edit_inp_node_divider INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_divider
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_divider', 'DIVIDER');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_outfall ON "SCHEMA_NAME".ve_inp_outfall;
CREATE TRIGGER gw_trg_edit_inp_node_outfall INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_outfall
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_outfall', 'OUTFALL');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_storage ON "SCHEMA_NAME".ve_inp_storage;
CREATE TRIGGER gw_trg_edit_inp_node_storage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_storage 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_storage', 'STORAGE');