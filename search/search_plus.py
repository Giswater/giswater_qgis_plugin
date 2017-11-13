# -*- coding: utf-8 -*-
from PyQt4 import uic
from PyQt4.QtGui import QCompleter, QSortFilterProxyModel, QStringListModel
from PyQt4.QtCore import QObject, QPyNullVariant, Qt
from qgis.core import QgsGeometry, QgsExpression, QgsFeatureRequest, QgsProject, QgsLayerTreeLayer, QgsExpressionContextUtils   # @UnresolvedImport

from functools import partial
import operator
import os
import sys
from search.ui.search_plus_dockwidget import SearchPlusDockWidget

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater      


class SearchPlus(QObject):


    def __init__(self, iface, srid, controller):
        """ Constructor """
        
        self.iface = iface
        self.srid = srid
        self.controller = controller
        self.project_type = self.controller.get_project_type()
        self.feature_cat = {}
        # Create dialog
        self.dlg = SearchPlusDockWidget(self.iface.mainWindow())

        # Load configuration data from tables
        if not self.load_config_data():
            self.enabled = False
            return

        # Set signals
        self.dlg.address_exploitation.currentIndexChanged.connect(partial(self.fill_postal_code, self.dlg.address_postal_code))
        self.dlg.address_exploitation.currentIndexChanged.connect(partial(self.address_populate, self.dlg.address_street, 'street_layer', 'street_field_code', 'street_field_name'))
        self.dlg.address_exploitation.currentIndexChanged.connect(partial(self.address_get_numbers, self.dlg.address_exploitation, 'expl_id', False))
        self.dlg.address_postal_code.currentIndexChanged.connect(partial(self.address_get_numbers, self.dlg.address_postal_code, 'postcode', False))
        self.dlg.address_street.activated.connect(partial(self.address_get_numbers, self.dlg.address_street, self.params['portal_field_code'], True))
        self.dlg.address_number.activated.connect(partial(self.address_zoom_portal))

        self.dlg.network_geom_type.activated.connect(partial(self.network_geom_type_changed))
        self.dlg.network_code.activated.connect(partial(self.network_zoom, self.dlg.network_code, self.dlg.network_geom_type))
        self.dlg.network_code.editTextChanged.connect(partial(self.filter_by_list, self.dlg.network_code))

        self.dlg.hydrometer_connec.activated.connect(partial(self.hydrometer_get_hydrometers))
        self.dlg.hydrometer_id.activated.connect(partial(self.hydrometer_zoom, self.params['hydrometer_urban_propierties_field_code'], self.dlg.hydrometer_connec))
        self.dlg.hydrometer_id.editTextChanged.connect(partial(self.filter_by_list, self.dlg.hydrometer_id))

        self.enabled = True


    def fill_postal_code(self, combo):
        """ Fill @combo """

        # Get exploitation code: 'expl_id'
        elem = self.dlg.address_exploitation.itemData(self.dlg.address_exploitation.currentIndex())
        code = elem[0]

        # Get postcodes related with selected 'expl_id'
        sql = "SELECT DISTINCT(postcode) FROM " + self.controller.schema_name + ".ext_address"
        if code != -1:
            sql += " WHERE expl_id = '" + str(code) + "'"
        sql += " ORDER BY postcode"
        rows = self.controller.get_rows(sql)

        records = [(-1, '', '')]
        for row in rows:
            field_code = row[0]
            elem = [field_code, field_code, None]
            records.append(elem)

        # Fill combo
        combo.blockSignals(True)
        combo.clear()
        records_sorted = sorted(records, key=operator.itemgetter(1))
        for i in range(len(records_sorted)):
            record = records_sorted[i]
            combo.addItem(str(record[1]), record)
            combo.blockSignals(False)

        return True


    def load_config_data(self):
        """ Load configuration data from tables """
        
        self.params = {}
        sql = "SELECT parameter, value FROM "+self.controller.schema_name+".config_param_system"
        sql += " WHERE context = 'searchplus' ORDER BY parameter"
        rows = self.controller.get_rows(sql)
        if rows:
            for row in rows:
                self.params[row['parameter']] = str(row['value'])
            return True
        else:
            self.controller.log_warning("Parameters related with 'searchplus' not set in table 'config_param_system'")
            return False            

        # Get scale zoom
        self.scale_zoom = 2500
        sql = "SELECT value FROM "+self.schema_name+".config_param_system"
        sql += " WHERE parameter = 'scale_zoom'"
        row = self.dao.get_row(sql)
        if row:
            self.scale_zoom = row['value']


    def dock_dialog(self):
        """ Dock dialog into left dock widget area """
        
        # Get path of .ui file
        ui_path = os.path.join(self.controller.plugin_dir, 'search', 'ui', 'search_plus_dialog.ui')
        if not os.path.exists(ui_path):
            self.controller.show_warning("File not found", parameter=ui_path)
            return False
        
        # Make it dockable in left dock widget area
        self.dock = uic.loadUi(ui_path)
        self.iface.addDockWidget(Qt.LeftDockWidgetArea, self.dlg)
        self.dlg.setFixedHeight(162)
        
        # Set his backgroundcolor
        p = self.dlg.palette()
        self.dlg.setAutoFillBackground(True)
        p.setColor(self.dlg.backgroundRole(), Qt.white)
        self.dlg.setPalette(p)   
        
        return True
    
            
    def get_layers(self): 
        """ Iterate over all layers to get the ones set in config file """
        
        # Check if we have any layer loaded
        layers = self.iface.legendInterface().layers()
        if len(layers) == 0:
            return            
        
        # Iterate over all layers to get the ones specified parameters '*_layer'
        self.layers = {}

        for cur_layer in layers:     
            layer_source = self.controller.get_layer_source(cur_layer)  
            uri_table = layer_source['table']
            if uri_table is not None:
                if self.params['expl_layer'] == uri_table:
                    self.layers['expl_layer'] = cur_layer
                if self.params['street_layer'] == uri_table:
                    self.layers['street_layer'] = cur_layer
                if self.params['portal_layer'] == uri_table:
                    self.layers['portal_layer'] = cur_layer
                if self.params['hydrometer_layer'] == uri_table:
                    self.layers['hydrometer_layer'] = cur_layer        
                if self.params['hydrometer_urban_propierties_layer'] == uri_table:
                    self.layers['hydrometer_urban_propierties_layer'] = cur_layer               
                if self.params['network_layer_arc'] == uri_table:
                    self.layers['network_layer_arc'] = cur_layer               
                if self.params['network_layer_connec'] == uri_table:
                    self.layers['network_layer_connec'] = cur_layer               
                if self.params['network_layer_element'] == uri_table:
                    self.layers['network_layer_element'] = cur_layer               
                if self.params['network_layer_gully'] == uri_table:
                    self.layers['network_layer_gully'] = cur_layer               
                if self.params['network_layer_node'] == uri_table:
                    self.layers['network_layer_node'] = cur_layer               
     
     
    def populate_dialog(self):
        """ Populate the interface with values get from layers """

        if not self.enabled:
            return False

        # Get layers and full extent
        self.get_layers()
        
        # TODO: Tab 'WorkCat'
        self.dlg.tab_main.removeTab(3)

        # Tab 'Address'
        status = self.address_populate(self.dlg.address_exploitation, 'expl_layer', 'expl_field_code', 'expl_field_name')
        if not status:
            self.dlg.tab_main.removeTab(2)
        else:
            # Get project variable 'expl_id'
            expl_id = QgsExpressionContextUtils.projectScope().variable('expl_id') 
            self.controller.log_info(expl_id) 
            if expl_id is not None:
                # Set SQL to get 'expl_name'
                sql = "SELECT " + self.params['expl_field_name'] + " FROM " + self.controller.schema_name + "." + self.params['expl_layer']
                sql += " WHERE " + self.params['expl_field_code'] + " = " + str(expl_id)
                self.controller.log_info(sql)
                row = self.controller.get_row(sql)
                if row:
                    utils_giswater.setSelectedItem(self.dlg.address_exploitation, row[0])   

        # Tab 'Hydrometer'
        self.populate_combo('hydrometer_urban_propierties_layer', self.dlg.hydrometer_connec, self.params['hydrometer_field_urban_propierties_code'])
        status = self.populate_combo('hydrometer_layer', self.dlg.hydrometer_id, self.params['hydrometer_field_urban_propierties_code'], self.params['hydrometer_field_code'])
        if not status:
            self.dlg.tab_main.removeTab(1)

        # Tab 'Network'
        self.network_code_create_lists()
        status = self.network_geom_type_populate()
        if not status:
            self.dlg.tab_main.removeTab(0)

        return True
    
     
    def network_code_create_lists(self):
        """ Create one list for each geom type and other one with all geom types """
     
        self.list_arc = []     
        self.list_connec = []     
        self.list_element = []     
        self.list_gully = []     
        self.list_node = []  
        self.list_all = []  
           
        # # Check which layers are available and get its list of codes
        if 'network_layer_arc' in self.layers:
            self.list_arc = self.network_code_layer('network_layer_arc')
        if 'network_layer_connec' in self.layers:
            self.list_connec = self.network_code_layer('network_layer_connec')
        if 'network_layer_element' in self.layers:
            self.list_element = self.network_code_layer('network_layer_element')
        if 'network_layer_gully' in self.layers:
            self.list_gully = self.network_code_layer('network_layer_gully')
        if 'network_layer_node' in self.layers:
            self.list_node = self.network_code_layer('network_layer_node')
        
        self.list_all = self.list_arc + self.list_connec + self.list_element + self.list_gully + self.list_node
        self.list_all = sorted(set(self.list_all))
        self.set_model_by_list(self.list_all, self.dlg.network_code)
        
        return True
    
    
    def network_code_layer(self, layername):
        """ Get codes of selected layer and add them to the combo 'network_code' """
        
        viewname = self.params[layername]
        feature_type = viewname.split("_")
        feat_id = str(feature_type[2])
        if str(feature_type[2]) == "arc":
            feature_type[2] = "cat_arc"
        sql = ("SELECT DISTINCT(" + str(feat_id) + "_id), " + str(feature_type[2]) + "type_id"
               " FROM " + self.controller.schema_name + "." + viewname + ""
               " WHERE " + str(feat_id) + "_id IS NOT NULL"
               " ORDER BY " + str(feat_id) + "_id")
        rows = self.controller.get_rows(sql)
        if not rows:
            return False
        
        list_codes = ['']
        for row in rows:
            list_codes.append(row[0] + " " + row[1])
                
        return list_codes       
        
     
    def network_geom_type_populate(self):
        """ Populate combo 'network_geom_type' """
        
        # Add null value
        self.dlg.network_geom_type.clear() 
        self.dlg.network_geom_type.addItem('')   
                   
        # Check which layers are available
        if 'network_layer_arc' in self.layers:  
            self.dlg.network_geom_type.addItem(self.controller.tr('Arc'))
        if 'network_layer_connec' in self.layers:  
            self.dlg.network_geom_type.addItem(self.controller.tr('Connec'))
        if 'network_layer_element' in self.layers:  
            self.dlg.network_geom_type.addItem(self.controller.tr('Element'))
        if 'network_layer_gully' in self.layers:  
            self.dlg.network_geom_type.addItem(self.controller.tr('Gully'))
        if 'network_layer_node' in self.layers:  
            self.dlg.network_geom_type.addItem(self.controller.tr('Node'))

        return self.dlg.network_geom_type > 0
    
    
    def network_geom_type_changed(self):
        """ Get 'geom_type' to filter 'code' values """
           
        geom_type = utils_giswater.getWidgetText(self.dlg.network_geom_type)
        list_codes = []
        if geom_type == self.controller.tr('Arc'):
            list_codes = self.list_arc
        elif geom_type == self.controller.tr('Connec'):
            list_codes = self.list_connec
        elif geom_type == self.controller.tr('Element'):
            list_codes = self.list_element
        elif geom_type == self.controller.tr('Gully'):
            list_codes = self.list_gully
        elif geom_type == self.controller.tr('Node'):
            list_codes = self.list_node
        else:
            list_codes = self.list_all
        self.set_model_by_list(list_codes, self.dlg.network_code)
        
        return True


    def set_model_by_list(self, string_list, widget):
        
        model = QStringListModel()
        model.setStringList(string_list)
        self.proxy_model = QSortFilterProxyModel()
        self.proxy_model.setSourceModel(model)
        self.proxy_model.setFilterKeyColumn(0)
        proxy_model_aux = QSortFilterProxyModel()
        proxy_model_aux.setSourceModel(model)
        proxy_model_aux.setFilterKeyColumn(0)
        widget.setModel(proxy_model_aux)
        widget.setModelColumn(0)
        completer = QCompleter()
        completer.setModel(self.proxy_model)
        completer.setCompletionColumn(0)
        completer.setCompletionMode(QCompleter.UnfilteredPopupCompletion)
        widget.setCompleter(completer)
        
        # TODO buscar como filtrar cuando no existe, que no muestre todos, sino que no muestre ninguno
        #self.controller.log_info(str(self.proxy_model.filterCaseSensitivity()))


    def filter_by_list(self, widget):
        self.proxy_model.setFilterFixedString(widget.currentText())


    def network_zoom(self, network_code, network_geom_type):
        """ Zoom feature with the code set in 'network_code' of the layer set in 'network_geom_type' """
        
        # Get selected code from combo
        element = utils_giswater.getWidgetText(network_code)
        if element == 'null':
            return

        # Split element. [0]: feature_id, [1]: feature_type
        row = element.split(' ', 1)
        feature_id = str(row[0])

        # Get selected layer
        geom_type = utils_giswater.getWidgetText(network_geom_type).lower()
        if geom_type == "null":
            sql = ("SELECT feature_type FROM "+self.controller.schema_name+"."+"cat_feature WHERE id='"+row[1]+"'")
            geom_type = self.controller.get_row(sql)
            geom_type = geom_type[0].lower()
        fieldname = geom_type + "_id"

        # Check if the expression is valid
        aux = fieldname + " = '" + feature_id + "'"
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = expr.parserErrorString() + ": " + aux
            self.controller.show_warning(message)
            return

        for value in self.feature_cat.itervalues():
            if value.type.lower() == geom_type:
                layer = self.controller.get_layer_by_layername(value.layername)
                if layer:
                    it = layer.getFeatures(QgsFeatureRequest(expr))
                    ids = [i.id() for i in it]
                    layer.selectByIds(ids)
                    # If any feature found, zoom it and exit function
                    if layer.selectedFeatureCount() > 0:
                        self.zoom_to_selected_features(layer)
                        return
                    
        
    def hydrometer_get_hydrometers(self):
        """ Populate hydrometers depending on selected connec """   
                                
        # Get selected connec
        selected = utils_giswater.getWidgetText(self.dlg.hydrometer_connec)
        
        # If any conenc selected, get again all hydrometers
        if selected == 'null':        
            self.populate_combo('hydrometer_layer', self.dlg.hydrometer_id, self.params['hydrometer_field_urban_propierties_code'], self.params['hydrometer_field_code'])            
            return
        
        # Get connec_id
        elem = self.dlg.hydrometer_connec.itemData(self.dlg.hydrometer_connec.currentIndex())
        code = elem[0] # to know the index see the query that populate the combo   
        records = [[-1, '']]
        
        # Set filter expression
        layer = self.layers['hydrometer_layer'] 
        idx_field_code = layer.fieldNameIndex(self.params['hydrometer_field_urban_propierties_code'])            
        idx_field_number = layer.fieldNameIndex(self.params['hydrometer_field_code'])   
        aux = self.params['hydrometer_field_urban_propierties_code'] + "  = '" + str(code) + "'"
        
        # Check filter and existence of fields       
        expr = QgsExpression(aux)     
        if expr.hasParserError():    
            message = expr.parserErrorString() + ": " + aux
            self.controller.show_warning(message)    
            return               
        if idx_field_code == -1:    
            message = "Field '{}' not found in layer '{}'. Open '{}' and check parameter '{}'" \
                .format(self.params['hydrometer_field_urban_propierties_code'], layer.name(), self.setting_file, 'hydrometer_field_urban_propierties_code')            
            self.controller.show_warning(message)         
            return      
        if idx_field_number == -1:    
            message = "Field '{}' not found in layer '{}'. Open '{}' and check parameter '{}'" \
                .format(self.params['hydrometer_field_code'], layer.name(), self.setting_file, 'hydrometer_field_code')            
            self.controller.show_warning(message)         
            return      
            
        # Get a featureIterator from an expression:
        # Get features from the iterator and do something
        it = layer.getFeatures(QgsFeatureRequest(expr))
        for feature in it: 
            attrs = feature.attributes() 
            field_number = attrs[idx_field_number]    
            if not type(field_number) is QPyNullVariant:
                elem = [code, field_number]
                records.append(elem)
                  
        # Fill hydrometers
        records_sorted = sorted(records, key=operator.itemgetter(1))
        self.dlg.hydrometer_id.blockSignals(True)
        self.dlg.hydrometer_id.clear()
        hydrometer_list = []
        #hydrometer_list.append('')
        for record in records_sorted:
            self.dlg.hydrometer_id.addItem(str(record[1]), record)
            if record[1] != '':
                hydrometer_list.append(str(record[1]))
        self.set_model_by_list(hydrometer_list, self.dlg.hydrometer_id)
        self.hydrometer_zoom(self.params['hydrometer_urban_propierties_field_code'], self.dlg.hydrometer_connec)
        self.dlg.hydrometer_id.blockSignals(False)  
                
        
    def hydrometer_zoom(self, fieldname, combo):
        """ Zoom to layer set in parameter 'hydrometer_urban_propierties_layer' """  

        expr = self.generic_zoom(fieldname, combo)
        if expr is None:
            return        
  
        # Build a list of feature id's from the expression and select them  
        try:
            layer = self.layers['hydrometer_urban_propierties_layer']
        except KeyError as e:
            self.controller.show_warning(str(e))    
            return False      
        it = layer.getFeatures(QgsFeatureRequest(expr))
        ids = [i.id() for i in it]
        layer.selectByIds(ids)

        # Zoom to selected feature of the layer
        self.zoom_to_selected_features(layer)
                    
        # Toggles 'Show feature count'
        self.show_feature_count()    
                
                
    def address_populate(self, combo, layername, field_code, field_name):
        """ Populate @combo """
        
        # Check if we have this search option available
        if layername not in self.layers:
            return False

        # Get features
        layer = self.layers[layername]        
        records = [(-1, '', '')]
        idx_field_code = layer.fieldNameIndex(self.params[field_code])
        idx_field_name = layer.fieldNameIndex(self.params[field_name])
        
        it = layer.getFeatures()
                             
        if layername == 'street_layer':
            
            # Get 'expl_id'
            field_expl_id = 'expl_id'
            elem = self.dlg.address_exploitation.itemData(self.dlg.address_exploitation.currentIndex())
            expl_id = elem[0]
            records = [[-1, '']]
            
            # Set filter expression
            aux = field_expl_id + " = '" + str(expl_id) + "'"       
    
            # Check filter and existence of fields
            expr = QgsExpression(aux)
            if expr.hasParserError():
                message = expr.parserErrorString() + ": " + aux
                self.controller.show_warning(message)
                return   
            
            it = layer.getFeatures(QgsFeatureRequest(expr))                        
        
        # Iterate over features
        for feature in it:        
            geom = feature.geometry()
            attrs = feature.attributes()                
            value_code = attrs[idx_field_code]
            value_name = attrs[idx_field_name]
            if not type(value_code) is QPyNullVariant and geom is not None:
                elem = [value_code, value_name, geom.exportToWkt()]
            else:
                elem = [value_code, value_name, None]
            records.append(elem)

        # Fill combo     
        combo.blockSignals(True)
        combo.clear()
        records_sorted = sorted(records, key = operator.itemgetter(1))
        for record in records_sorted:
            combo.addItem(str(record[1]), record)
        combo.blockSignals(False)     
        
        return True
           

    def address_get_numbers(self, combo, field_code, fill_combo=False):
        """ Populate civic numbers depending on value of selected @combo. Build an expression with @field_code """

        # Get selected street
        selected = utils_giswater.getWidgetText(combo)
        if selected == 'null':
            return

        # Get street code
        elem = combo.itemData(combo.currentIndex())
        code = elem[0]  # to know the index see the query that populate the combo
        records = [[-1, '']]
        
        # Set filter expression
        layer = self.layers['portal_layer']
        idx_field_code = layer.fieldNameIndex(field_code)
        idx_field_number = layer.fieldNameIndex(self.params['portal_field_number'])
        aux = field_code + "  = '" + str(code) + "'"

        # Check filter and existence of fields
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = expr.parserErrorString() + ": " + aux
            self.controller.show_warning(message)
            return
        if idx_field_code == -1:
            message = "Field '{}' not found in layer '{}'. Open '{}' and check parameter '{}'" \
                .format(self.params['portal_field_code'], layer.name(), self.setting_file, 'portal_field_code')
            self.controller.show_warning(message)
            return
        if idx_field_number == -1:
            message = "Field '{}' not found in layer '{}'. Open '{}' and check parameter '{}'" \
                .format(self.params['portal_field_number'], layer.name(), self.setting_file, 'portal_field_number')
            self.controller.show_warning(message)
            return

        self.dlg.address_number.blockSignals(True)
        self.dlg.address_number.clear()

        if fill_combo:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            for feature in it:
                attrs = feature.attributes()
                field_number = attrs[idx_field_number]
                if not type(field_number) is QPyNullVariant:
                    elem = [code, field_number]
                    records.append(elem)

            # Fill numbers combo
            records_sorted = sorted(records, key=operator.itemgetter(1))
            for record in records_sorted:
                self.dlg.address_number.addItem(str(record[1]), record)
            self.dlg.address_number.blockSignals(False)

        # Get a featureIterator from an expression:
        # Select featureswith the ids obtained
        it = layer.getFeatures(QgsFeatureRequest(expr))
        ids = [i.id() for i in it]
        layer.selectByIds(ids)

        # Zoom to selected feature of the layer
        self.zoom_to_selected_features(layer)


    def zoom_to_layer(self, combo, layer):
        """ Zoom to @layer """
        
        selected = utils_giswater.getWidgetText(combo)
        if selected == 'null':
            return
        data = combo.itemData(combo.currentIndex())

        wkt = data[2]  # to know the index see the query that populate the combo
        geom = QgsGeometry.fromWkt(wkt)
        if not geom:
            message = "Geometry not valid or not defined"
            self.controller.show_warning(message)
            return

        # Zoom on it's centroid
        centroid = geom.centroid()
        self.iface.setActiveLayer(self.layers[layer])
        self.iface.mapCanvas().setCenter(centroid.asPoint())
        self.iface.mapCanvas().zoomScale(float(self.scale_zoom))

        # Toggles 'Show feature count'
        self.show_feature_count()
        
                
    def address_zoom_portal(self):
        """ Show street data on the canvas when selected street and number in street tab """  
                
        # Get selected street
        street = utils_giswater.getWidgetText(self.dlg.address_street)                 
        civic = utils_giswater.getWidgetText(self.dlg.address_number)                 
        if street == 'null' or civic == 'null':
            return  
                
        # Get selected portal
        elem = self.dlg.address_number.itemData(self.dlg.address_number.currentIndex())
        if not elem:
            # that means that user has edited manually the combo but the element
            # does not correspond to any combo element
            message = 'Element {} does not exist'.format(civic)
            self.controller.show_warning(message) 
            return
        
        # select this feature in order to copy to memory layer        
        aux = self.params['portal_field_code'] + " = '" + str(elem[0]) + "' AND " + self.params['portal_field_number'] + " = '" + str(elem[1]) + "'"
        expr = QgsExpression(aux)     
        if expr.hasParserError():   
            message = expr.parserErrorString() + ": " + aux
            self.controller.show_warning(message)        
            return    
        
        # Get a featureIterator from an expression
        # Build a list of feature Ids from the previous result       
        # Select featureswith the ids obtained         
        layer = self.layers['portal_layer']    
        it = self.layers['portal_layer'].getFeatures(QgsFeatureRequest(expr))
        ids = [i.id() for i in it]
        layer.selectByIds(ids)   

        # Zoom to selected feature of the layer
        self.zoom_to_selected_features(self.layers['portal_layer'])
                    
        # Toggles 'Show feature count'
        self.show_feature_count()                  
          
    
    def generic_zoom(self, fieldname, combo, field_index=0):  
        """ Get selected element from the combo, and returns a feature request expression """
        
        # Get selected element from combo
        element = utils_giswater.getWidgetText(combo)                    
        if element == 'null':
            return None
                
        elem = combo.itemData(combo.currentIndex())
        if not elem:
            # that means that user has edited manually the combo but the element
            # does not correspond to any combo element
            message = 'Element {} does not exist'.format(element)
            self.controller.show_warning(message) 
            return None
        
        # Check if the expression is valid
        aux = fieldname + " = '" + str(elem[field_index]) + "'"
        expr = QgsExpression(aux)    
        if expr.hasParserError():   
            message = expr.parserErrorString() + ": " + aux
            self.controller.show_warning(message)        
            return     
        
        return expr
                        
            
    def populate_combo(self, parameter, combo, fieldname, fieldname_2=None):
        """ Populate selected combo from features of selected layer """        
        
        # Check if we have this search option available
        if not parameter in self.layers: 
            return False

        # Fields management
        layer = self.layers[parameter]
        records = []
        idx_field = layer.fieldNameIndex(fieldname) 
        if idx_field == -1:           
            message = "Field '{}' not found in the layer specified in parameter '{}'".format(fieldname, parameter)           
            self.controller.show_warning(message)
            return False      

        idx_field_2 = idx_field
        if fieldname_2 is not None:
            idx_field_2 = layer.fieldNameIndex(fieldname_2) 
            if idx_field_2 == -1:           
                message = "Field '{}' not found in the layer specified in parameter '{}'".format(fieldname_2, parameter)           
                self.controller.show_warning(message)
                return False   
 
        # Iterate over all features to get distinct records
        list_elements = []
        for feature in layer.getFeatures():                                
            attrs = feature.attributes() 
            field = attrs[idx_field]  
            field_2 = attrs[idx_field_2]  
            if not type(field) is QPyNullVariant:
                if field not in list_elements:
                    elem = [field, field_2]               
                    list_elements.append(field)
                    records.append(elem)
        
        # Fill combo box
        combo.blockSignals(True)
        combo.clear()
        records_sorted = sorted(records, key=operator.itemgetter(1))
        combo.addItem('', '')
        hydrometer_list = []
        hydrometer_list.append('')       
        for i in range(len(records_sorted)):
            record = records_sorted[i]
            combo.addItem(str(record[1]), record)
            if record[1] != '':
                hydrometer_list.append(record[1])
        self.set_model_by_list(hydrometer_list, self.dlg.hydrometer_id)
        combo.blockSignals(False)     
        
        return True
                    
        
    def show_feature_count(self):
        """ Toggles 'Show Feature Count' of all the layers in the root path of the TOC """   
                     
        root = QgsProject.instance().layerTreeRoot()
        for child in root.children():
            if isinstance(child, QgsLayerTreeLayer):
                child.setCustomProperty("showFeatureCount", True)     
        
                
    def zoom_to_selected_features(self, layer):
        """ Zoom to selected features of the @layer """
        
        if not layer:
            return
        self.iface.setActiveLayer(layer)
        self.iface.actionZoomToSelected().trigger()        
        scale = self.iface.mapCanvas().scale()
        if int(scale) < int(self.scale_zoom):
            self.iface.mapCanvas().zoomScale(float(self.scale_zoom))                 
                                                        
                     
    def unload(self):
        """ Removes dialog """       
        if self.dlg:
            self.dlg.deleteLater()
            del self.dlg                                                           
    
