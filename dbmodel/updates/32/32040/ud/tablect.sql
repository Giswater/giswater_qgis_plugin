/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- incorporate constraints not defined on 3.1
--------------------------------------------
ALTER TABLE gully ALTER COLUMN state SET NOT NULL;
ALTER TABLE gully ALTER COLUMN state_type SET NOT NULL;



--FLOW REGULATOR
ALTER TABLE "inp_flwreg_orifice" DROP CONSTRAINT IF EXISTS "inp_flwreg_orifice_shape_fkey";
ALTER TABLE "inp_flwreg_orifice" DROP CONSTRAINT IF EXISTS "inp_flwreg_orifice_ori_type_fkey";

ALTER TABLE "inp_flwreg_outlet" DROP CONSTRAINT IF EXISTS "inp_flwreg_outlet_outlet_type_fkey";
ALTER TABLE "inp_flwreg_outlet" DROP CONSTRAINT IF EXISTS "inp_flwreg_outlet_to_arc_fkey";

ALTER TABLE "inp_flwreg_pump" DROP CONSTRAINT IF EXISTS "inp_flwreg_pump_status_fkey";

ALTER TABLE "inp_flwreg_weir" DROP CONSTRAINT IF EXISTS "inp_flwreg_weir_weir_type_fkey";
ALTER TABLE "inp_flwreg_weir" DROP CONSTRAINT IF EXISTS "inp_flwreg_weir_flap_fkey";


-- DROP UNIQUE
ALTER TABLE "inp_flwreg_pump" DROP CONSTRAINT IF EXISTS "inp_flwreg_pump_unique";
ALTER TABLE "inp_flwreg_orifice" DROP CONSTRAINT IF EXISTS "inp_flwreg_orifice_unique";
ALTER TABLE "inp_flwreg_weir" DROP CONSTRAINT IF EXISTS "inp_flwreg_weir_unique";
ALTER TABLE "inp_flwreg_outlet" DROP CONSTRAINT IF EXISTS "inp_flwreg_outlet_unique";



--FLOW REGULATOR

ALTER TABLE "inp_flwreg_orifice" ADD CONSTRAINT "inp_flwreg_orifice_shape_fkey" FOREIGN KEY ("shape") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_orifice" ADD CONSTRAINT "inp_flwreg_orifice_ori_type_fkey" FOREIGN KEY ("ori_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_flwreg_outlet" ADD CONSTRAINT "inp_flwreg_outlet_outlet_type_fkey" FOREIGN KEY ("outlet_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_flwreg_pump" ADD CONSTRAINT "inp_flwreg_pump_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_flwreg_weir" ADD CONSTRAINT "inp_flwreg_weir_weir_type_fkey" FOREIGN KEY ("weir_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_weir" ADD CONSTRAINT "inp_flwreg_weir_flap_fkey" FOREIGN KEY ("flap") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;



-- ADD UNIQUE
ALTER TABLE "inp_flwreg_pump" ADD CONSTRAINT "inp_flwreg_pump_unique" UNIQUE (node_id, to_arc, flwreg_id);
ALTER TABLE "inp_flwreg_orifice" ADD CONSTRAINT "inp_flwreg_orifice_unique" UNIQUE (node_id, to_arc, flwreg_id);
ALTER TABLE "inp_flwreg_weir" ADD CONSTRAINT "inp_flwreg_weir_unique" UNIQUE (node_id, to_arc, flwreg_id);
ALTER TABLE "inp_flwreg_outlet" ADD CONSTRAINT "inp_flwreg_outlet_unique" UNIQUE (node_id, to_arc, flwreg_id);
