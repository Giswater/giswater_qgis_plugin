/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--DROP
ALTER TABLE  arc_type  DROP CONSTRAINT IF EXISTS arc_type_epa_table_check;
ALTER TABLE  node_type  DROP CONSTRAINT IF EXISTS node_type_epa_table_check;
ALTER TABLE  arc_type  DROP CONSTRAINT IF EXISTS arc_type_man_table_check;
ALTER TABLE  node_type  DROP CONSTRAINT IF EXISTS node_type_man_table_check;
ALTER TABLE  connec_type  DROP CONSTRAINT IF EXISTS connec_type_man_table_check;

--INP

ALTER TABLE "inp_curve_id" DROP CONSTRAINT IF EXISTS "inp_curve_id_curve_type_fkey";
ALTER TABLE "inp_energy_el" DROP CONSTRAINT IF EXISTS "inp_energy_el_parameter_fkey";
ALTER TABLE "inp_energy_gl" DROP CONSTRAINT IF EXISTS "inp_energy_gl_parameter_fkey";
ALTER TABLE "inp_energy_gl" DROP CONSTRAINT IF EXISTS "inp_energy_gl_energ_type_fkey";
ALTER TABLE "inp_mixing" DROP CONSTRAINT IF EXISTS "inp_mixing_mix_type_fkey";

ALTER TABLE "inp_pipe" DROP CONSTRAINT IF EXISTS "inp_pipe_status_fkey";
ALTER TABLE "inp_shortpipe" DROP CONSTRAINT IF EXISTS "inp_shortpipe_status_fkey";
ALTER TABLE "inp_pump" DROP CONSTRAINT IF EXISTS "inp_pump_curve_id_fkey";
ALTER TABLE "inp_pump" DROP CONSTRAINT IF EXISTS "inp_pump_to_arc_fkey";
ALTER TABLE "inp_pump" DROP CONSTRAINT IF EXISTS "inp_pump_status_fkey";
ALTER TABLE "inp_reactions_el" DROP CONSTRAINT IF EXISTS "inp_reactions_el_parameter_fkey";
ALTER TABLE "inp_reactions_gl" DROP CONSTRAINT IF EXISTS "inp_reactions_gl_parameter_fkey";
ALTER TABLE "inp_reactions_gl" DROP CONSTRAINT IF EXISTS "inp_reactions_gl_react_type_fkey";

ALTER TABLE "inp_source" DROP CONSTRAINT IF EXISTS "inp_source_sourc_type_fkey" ;
ALTER TABLE "inp_tank" DROP CONSTRAINT IF EXISTS "inp_tank_curve_id_fkey";
ALTER TABLE "inp_times" DROP CONSTRAINT IF EXISTS "inp_times_statistic_fkey";
ALTER TABLE "inp_valve" DROP CONSTRAINT IF EXISTS "inp_valve_valv_type_fkey";
ALTER TABLE "inp_valve" DROP CONSTRAINT IF EXISTS "inp_valve_status_fkey";
ALTER TABLE "inp_pump_additional" DROP CONSTRAINT IF EXISTS "inp_pump_additional_status_fkey";


--DROP CHECK
ALTER TABLE inp_typevalue DROP CONSTRAINT IF EXISTS inp_typevalue_check;

ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_check";
ALTER TABLE "inp_project_id" DROP CONSTRAINT IF EXISTS "inp_project_id_check";

ALTER TABLE "inp_arc_type" DROP CONSTRAINT IF EXISTS "inp_arc_type_check";
ALTER TABLE "inp_node_type" DROP CONSTRAINT IF EXISTS "inp_node_type_check";
ALTER TABLE "inp_pump_additional" DROP CONSTRAINT IF EXISTS "inp_pump_additional_check";



ALTER TABLE inp_energy_el DROP CONSTRAINT IF EXISTS inp_energy_el_parameter_check;
ALTER TABLE inp_energy_gl DROP CONSTRAINT IF EXISTS inp_energy_gl_parameter_check;
ALTER TABLE inp_energy_gl DROP CONSTRAINT IF EXISTS inp_energy_gl_energ_type_check;
ALTER TABLE inp_mixing DROP CONSTRAINT IF EXISTS inp_mixing_mix_type_check;
ALTER TABLE inp_source DROP CONSTRAINT IF EXISTS inp_source_sourc_type_check;
ALTER TABLE inp_shortpipe DROP CONSTRAINT IF EXISTS inp_shortpipe_status_check;
ALTER TABLE inp_pump DROP CONSTRAINT IF EXISTS inp_pumpe_status_check;
ALTER TABLE inp_pipe DROP CONSTRAINT IF EXISTS inp_pipe_status_check;
ALTER TABLE inp_valve DROP CONSTRAINT IF EXISTS inp_valve_status_check;
ALTER TABLE inp_valve DROP CONSTRAINT IF EXISTS inp_valve_valv_type_check;
ALTER TABLE inp_curve_id DROP CONSTRAINT IF EXISTS inp_curve_id_curve_type_check;

ALTER TABLE inp_reactions_el DROP CONSTRAINT IF EXISTS inp_reactions_el_parameter_check;
ALTER TABLE inp_reactions_gl DROP CONSTRAINT IF EXISTS inp_reactions_gl_parameter_check;
ALTER TABLE inp_reactions_gl DROP CONSTRAINT IF EXISTS inp_reactions_gl_react_type_check;

ALTER TABLE inp_pump_additional DROP CONSTRAINT IF EXISTS inp_pump_additional_pattern_check;

ALTER TABLE inp_pump_importinp DROP CONSTRAINT IF EXISTS inp_pump_importinp_curve_id_fkey;
ALTER TABLE inp_valve_importinp DROP CONSTRAINT IF EXISTS inp_valve_importinp_to_arc_fkey;
ALTER TABLE inp_valve_importinp DROP CONSTRAINT IF EXISTS inp_valve_importinp_curve_id_fkey;


--DROP UNIQUE
ALTER TABLE "inp_pump_additional" DROP CONSTRAINT IF EXISTS "inp_pump_additional_unique";
