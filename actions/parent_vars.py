from ..core.actions.edit.layer_tools import GwLayerTools
from .. import global_vars


feature_id = None
snapper_manager = None
snapper = None
vertex_marker = None
rubber_polygon = None
add_layer = None
temp_layers_added = None
rubber_point = None

# parent_manage.py
ids = None
list_ids = None
layers = None
lazy_widget = None
lazy_init_function = None
geom_type = None

def init_global_vars():
	global add_layer
	add_layer = GwLayerTools()