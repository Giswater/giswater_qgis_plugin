/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW ve_epa_junction AS
SELECT inp_junction.*, 
aver_depth as depth_average,max_depth as depth_max, 
d.time_days as depth_max_day, 
d.time_hour as depth_max_hour,
hour_surch as surcharge_hour,
max_height as surgarge_max_height,
hour_flood as flood_hour,
max_rate as flood_max_rate, 
f.time_days as time_day, 
f.time_hour as time_hour, 
tot_flood as flood_total, 
max_ponded as flood_max_ponded
FROM inp_junction 
JOIN v_rpt_nodedepth_sum d USING (node_id)
JOIN v_rpt_nodesurcharge_sum s USING (node_id)
JOIN v_rpt_nodeflooding_sum f USING (node_id);

CREATE OR REPLACE VIEW ve_epa_storage AS
SELECT inp_storage.*, 
aver_vol, 
avg_full, 
ei_loss, 
max_vol, 
max_full, 
time_days, 
time_hour, 
max_out
FROM inp_storage 
JOIN v_rpt_storagevol_sum USING (node_id);

CREATE OR REPLACE VIEW ve_epa_outfall AS
SELECT inp_outfall.*, 
flow_freq, 
avg_flow, 
max_flow, 
total_vol
FROM inp_outfall
JOIN v_rpt_outfallflow_sum USING (node_id);

CREATE OR REPLACE VIEW ve_epa_conduit AS
SELECT inp_conduit.*, 
max_flow, 
time_days, 
time_hour, 
max_veloc, 
mfull_flow, 
mfull_dept, 
max_shear, 
max_hr, 
max_slope, 
day_max, 
time_max, 
min_shear, 
day_min, 
time_min
FROM inp_conduit JOIN v_rpt_arcflow_sum USING (arc_id);