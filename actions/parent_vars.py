from ..core.actions.edit.layer_tools import GwLayerTools
from .. import global_vars


feature_id = None
geom_type = None
snapper_manager = None
snapper = None
vertex_marker = None
rubber_polygon = None
dlg_dtext = None
rb_interpolate = None
interpolate_result = None
node1 = None
node2 = None
layer_node = None
add_layer = None
dlg_cf = None
temp_layers_added = None
rubber_point = None
user_current_layer = None
list_update = None

# parent_manage.py
project_type = None
xyCoordinates_conected = None
snapped_point  = None
x  = None
y = None
plan_om = None
ids = None
list_ids = None
layers = None
remove_ids = None
lazy_widget = None
lazy_init_function = None

def init_global_vars():
	global add_layer
	add_layer = GwLayerTools()