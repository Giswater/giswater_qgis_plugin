/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--ADD
ALTER TABLE arc_type ADD CONSTRAINT arc_type_epa_table_check CHECK (epa_table IN ('inp_pipe'));

ALTER TABLE node_type ADD CONSTRAINT node_type_epa_table_check CHECK (epa_table IN ('inp_junction', 'inp_pump', 'inp_reservoir', 'inp_tank', 'inp_valve', 'inp_shortpipe'));

ALTER TABLE arc_type ADD CONSTRAINT arc_type_man_table_check CHECK (man_table IN ('man_pipe', 'man_varc'));

ALTER TABLE node_type ADD CONSTRAINT node_type_man_table_check CHECK (man_table IN ('man_expansiontank', 'man_tank', 'man_filter', 'man_flexunion', 'man_hydrant',
'man_junction', 'man_manhole', 'man_meter', 'man_netelement', 'man_netsamplepoint', 'man_netwjoin', 'man_pump', 'man_reduction', 'man_register', 'man_source', 'man_tank',
'man_valve', 'man_waterwell', 'man_wtp'));

ALTER TABLE connec_type ADD CONSTRAINT connec_type_man_table_check CHECK (man_table IN ('man_fountain', 'man_greentap', 'man_tap', 'man_wjoin'));



--ADD
--INP


ALTER TABLE  inp_typevalue add CONSTRAINT inp_typevalue_id_unique UNIQUE(id);
ALTER TABLE "inp_curve_id" ADD CONSTRAINT "inp_curve_id_curve_type_fkey" FOREIGN KEY ("curve_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_energy_el" ADD CONSTRAINT "inp_energy_el_parameter_fkey" FOREIGN KEY ("parameter") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_energy_gl" ADD CONSTRAINT "inp_energy_gl_parameter_fkey" FOREIGN KEY ("parameter") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_energy_gl" ADD CONSTRAINT "inp_energy_gl_energ_type_fkey" FOREIGN KEY ("energ_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_mixing" ADD CONSTRAINT "inp_mixing_mix_type_fkey" FOREIGN KEY ("mix_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_pipe" ADD CONSTRAINT "inp_pipe_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_shortpipe" ADD CONSTRAINT "inp_shortpipe_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_pump" ADD CONSTRAINT "inp_pump_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_reactions_el" ADD CONSTRAINT "inp_reactions_el_parameter_fkey" FOREIGN KEY ("parameter") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_reactions_gl" ADD CONSTRAINT "inp_reactions_gl_parameter_fkey" FOREIGN KEY ("parameter") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_reactions_gl" ADD CONSTRAINT "inp_reactions_gl_react_type_fkey" FOREIGN KEY ("react_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_source" ADD CONSTRAINT "inp_source_sourc_type_fkey" FOREIGN KEY ("sourc_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_valve" ADD CONSTRAINT "inp_valve_valv_type_fkey" FOREIGN KEY ("valv_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_valve" ADD CONSTRAINT "inp_valve_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_pump_additional" ADD CONSTRAINT "inp_pump_additional_status_fkey" FOREIGN KEY ("pattern") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;



--check typevalue
ALTER TABLE inp_energy_el ADD CONSTRAINT inp_energy_el_parameter_check CHECK ( parameter IN ('EFFIC','PATTERN','PRICE'));
ALTER TABLE inp_energy_gl ADD CONSTRAINT inp_energy_gl_parameter_check CHECK ( parameter IN ('EFFIC','PATTERN','PRICE'));
ALTER TABLE inp_energy_gl ADD CONSTRAINT inp_energy_gl_energ_type_check CHECK ( energ_type IN ('DEMAND CHARGE','GLOBAL'));
ALTER TABLE inp_mixing ADD CONSTRAINT inp_mixing_mix_type_check CHECK ( mix_type IN ('2COMP','FIFO','LIFO','MIXED'));
ALTER TABLE inp_source ADD CONSTRAINT inp_source_sourc_type_check CHECK ( sourc_type IN ('CONCEN','FLOWPACED','MASS','SETPOINT'));
ALTER TABLE inp_shortpipe ADD CONSTRAINT inp_shortpipe_status_check CHECK ( status IN ('CLOSED_PIPE','CV_PIPE','OPEN_PIPE'));
ALTER TABLE inp_pump ADD CONSTRAINT inp_pumpe_status_check CHECK ( status IN ('CLOSED_PUMP','OPEN_PUMP'));
ALTER TABLE inp_pipe ADD CONSTRAINT inp_pipe_status_check CHECK ( status IN ('CLOSED_PIPE','CV_PIPE','OPEN_PIPE'));
ALTER TABLE inp_valve ADD CONSTRAINT inp_valve_status_check CHECK ( status IN ('ACTIVE_VALVE','CLOSED_VALVE','OPEN_VALVE'));
ALTER TABLE inp_valve ADD CONSTRAINT inp_valve_valv_type_check CHECK ( valv_type IN ('FCV','GPV','PBV','PRV','PSV','TCV'));
ALTER TABLE inp_curve_id ADD CONSTRAINT inp_curve_id_curve_type_check CHECK ( curve_type IN ('EFFICIENCY','HEADLOSS','PUMP','VOLUME'));

ALTER TABLE inp_reactions_el ADD CONSTRAINT inp_reactions_el_parameter_check CHECK ( parameter IN ('BULK_EL','TANK_EL','WALL_EL'));
ALTER TABLE inp_reactions_gl ADD CONSTRAINT inp_reactions_gl_parameter_check CHECK ( parameter IN ('BULK_GL','TANK_GL','WALL_GL'));
ALTER TABLE inp_reactions_gl ADD CONSTRAINT inp_reactions_gl_react_type_check CHECK ( react_type IN  ('GLOBAL_GL','LIMITING POTENTIAL','ORDER','ROUGHNESS CORRELATION'));

ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_pattern_check CHECK ( pattern IN ('CLOSED_PUMP','OPEN_PUMP'));


-- ADD UNIQUE
ALTER TABLE "inp_pump_additional" ADD CONSTRAINT "inp_pump_additional_unique" UNIQUE (node_id, order_id);


ALTER TABLE inp_pump_importinp ADD CONSTRAINT inp_pump_importinp_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve_id (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_valve_importinp ADD CONSTRAINT inp_valve_importinp_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve_id (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_valve_importinp ADD CONSTRAINT inp_valve_importinp_to_arc_fkey FOREIGN KEY (to_arc)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
