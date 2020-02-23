/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = ws_sample, public, pg_catalog;


-- 2020/02/20
DROP TRIGGER IF EXISTS gw_trg_vi_curves ON vi_curves;
CREATE TRIGGER gw_trg_vi_curves
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ws_sample.vi_curves
  FOR EACH ROW
  EXECUTE PROCEDURE ws_sample.gw_trg_vi('vi_curves');


DROP TRIGGER IF EXISTS gw_trg_vi_tanks ON vi_tanks;
CREATE TRIGGER gw_trg_vi_tanks
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ws_sample.vi_tanks
  FOR EACH ROW
  EXECUTE PROCEDURE ws_sample.gw_trg_vi('vi_tanks');

DROP TRIGGER IF EXISTS gw_trg_vi_pumps ON vi_pumps;
CREATE TRIGGER gw_trg_vi_pumps
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ws_sample.vi_pumps
  FOR EACH ROW
  EXECUTE PROCEDURE ws_sample.gw_trg_vi('vi_pumps');


DROP TRIGGER IF EXISTS gw_trg_vi_valves ON vi_valves;
CREATE TRIGGER gw_trg_vi_valves
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ws_sample.vi_valves
  FOR EACH ROW
  EXECUTE PROCEDURE ws_sample.gw_trg_vi('vi_valves');

