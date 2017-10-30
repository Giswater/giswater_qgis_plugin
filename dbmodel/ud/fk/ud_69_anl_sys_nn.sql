--DROP

ALTER TABLE anl_flow_node ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE anl_flow_node ALTER COLUMN expl_id DROP NOT NULL;
ALTER TABLE anl_flow_node ALTER COLUMN context DROP NOT NULL;
ALTER TABLE anl_flow_node ALTER COLUMN cur_user DROP NOT NULL;


ALTER TABLE anl_flow_arc ALTER COLUMN arc_id DROP NOT NULL;
ALTER TABLE anl_flow_arc ALTER COLUMN expl_id DROP NOT NULL;
ALTER TABLE anl_flow_arc ALTER COLUMN context DROP NOT NULL;
ALTER TABLE anl_flow_arc ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE anl_arc_profile_value ALTER COLUMN arc_id DROP NOT NULL;
ALTER TABLE anl_arc_profile_value ALTER COLUMN profile_id DROP NOT NULL;


--SET

ALTER TABLE anl_flow_node ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE anl_flow_node ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE anl_flow_node ALTER COLUMN context SET NOT NULL;
ALTER TABLE anl_flow_node ALTER COLUMN cur_user SET NOT NULL;


ALTER TABLE anl_flow_arc ALTER COLUMN arc_id SET NOT NULL;
ALTER TABLE anl_flow_arc ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE anl_flow_arc ALTER COLUMN context SET NOT NULL;
ALTER TABLE anl_flow_arc ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE anl_arc_profile_value ALTER COLUMN arc_id SET NOT NULL;
ALTER TABLE anl_arc_profile_value ALTER COLUMN profile_id SET NOT NULL;
