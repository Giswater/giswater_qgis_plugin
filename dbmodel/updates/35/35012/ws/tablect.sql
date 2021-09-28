/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



--2021/08/25
ALTER TABLE inp_pump DROP CONSTRAINT IF EXISTS inp_pump_to_arc_fkey;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_to_arc_fkey FOREIGN KEY (to_arc)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

--2021/09/03
ALTER TABLE inp_dscenario_demand DROP CONSTRAINT IF EXISTS inp_demand_unique;
ALTER TABLE inp_dscenario_demand ADD CONSTRAINT inp_dscenario_demand_unique UNIQUE(feature_id, dscenario_id);


-- 2021/09/26
ALTER TABLE inp_valve DROP CONSTRAINT inp_valve_valv_type_check;

ALTER TABLE inp_valve
  ADD CONSTRAINT inp_valve_valv_type_check CHECK (valv_type::text = ANY (ARRAY['FCV'::character varying, 'GPV'::character varying, 'PBV'::character varying, 'PRV'::character varying, 'PSV'::character varying, 'TCV'::character varying, 'PSRV'::character varying]));

