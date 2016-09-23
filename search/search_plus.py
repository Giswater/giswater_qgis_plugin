# -*- coding: utf-8 -*-
from qgis.core import QgsGeometry, QgsExpression, QgsFeatureRequest, QgsVectorLayer, QgsFeature, QgsMapLayerRegistry, QgsField, QgsProject, QgsLayerTreeLayer
from PyQt4.QtCore import QObject, QSettings, QTranslator, qVersion, QCoreApplication, QPyNullVariant   # @UnresolvedImport

from functools import partial
import operator
import os.path
from search_plus_dockwidget import SearchPlusDockWidget


class SearchPlus(QObject):


    def __init__(self, iface, srid, controller):
        ''' Constructor '''
        
        self.iface = iface
        self.srid = srid
        self.controller = controller
        
        # initialize plugin directory and locale
        self.plugin_dir = os.path.dirname(__file__)
        locale = QSettings().value('locale/userLocale')[0:2]
        locale_path = os.path.join(self.plugin_dir, 'i18n', 'SearchPlus_{}.qm'.format(locale))
        if os.path.exists(locale_path):
            self.translator = QTranslator()
            self.translator.load(locale_path)
            if qVersion() > '4.3.3':
                QCoreApplication.installTranslator(self.translator)                
        
        # load local settings of the plugin
        self.app_name = "searchplus"        
        self.setting_file = os.path.join(self.plugin_dir, 'config', self.app_name+'.config')   
        if not os.path.isfile(self.setting_file):
            message = "Config file not found at: "+self.setting_file            
            self.controller.show_warning(message)                
            return False        
        self.settings = QSettings(self.setting_file, QSettings.IniFormat)
        self.stylesFolder = self.plugin_dir+"/styles/"          
    
        # create dialog
        self.dlg = SearchPlusDockWidget(self.iface.mainWindow())
        
        # Load configuration data from tables
        if not self.load_config_data():
            self.enabled = False
            return      
        
        # set signals
        self.dlg.ppoint_number.activated.connect(partial(self.ppoint_zoom, self.params['ppoint_field_number'], self.dlg.ppoint_number))     
        self.dlg.ppoint_press_zone.activated.connect(partial(self.ppoint_zoom, self.params['ppoint_field_zone'], self.dlg.ppoint_press_zone)) 
           
        self.dlg.adress_street.activated.connect(self.address_get_numbers)
        self.dlg.adress_street.activated.connect(self.address_zoom_street)
        self.dlg.adress_number.activated.connect(self.address_zoom_portal)  
        
        self.dlg.hydrometer_code.activated.connect(partial(self.hydrometer_zoom, self.params['hydrometer_urban_propierties_field_code'], self.dlg.hydrometer_code))
              
        self.dlg.urban_properties_block.activated.connect(partial(self.urban_zoom, self.params['urban_propierties_field_block'], self.dlg.urban_properties_block))        
        self.dlg.urban_properties_number.activated.connect(partial(self.urban_zoom, self.params['urban_propierties_field_number'], self.dlg.urban_properties_number))        

        self.enabled = True
            
    
    def load_plugin_settings(self):
        ''' Load plugin settings '''
          
        self.QML_PORTAL = self.settings.value('layers/QML_PORTAL', 'portal.qml').lower()                       
        self.QML_PPOINT = None          
        self.QML_HYDROMETER = None          
        self.QML_URBAN = None    

        # get initial Scale
        self.scale_zoom = self.settings.value('status/scale_zoom', 2500)
                 
    
    def load_config_data(self):
        ''' Load configuration data from tables '''
        
        self.load_plugin_settings()
        
        self.params = {}
        sql = "SELECT * FROM "+self.controller.schema_name+".config_search_plus"
        row = self.controller.dao.get_row(sql)
        if not row:
            self.controller.show_warning("No data found in configuration table 'config_search_plus'")
            return False

        for i in range(0, len(row)):
            column_name = self.controller.dao.get_column_name(i)
            self.params[column_name] = str(row[i])
        
        return True

            
    def get_layers(self): 
        ''' Iterate over all layers to get the ones set in config file '''
        
        # Initialize class variables        
        self.portalMemLayer = None            
        self.ppointMemLayer = None            
        self.hydrometerMemLayerTo = None
        self.urbanMemLayer = None
        
        # Iterate over all layers    
        self.layers = {}        
        layers = self.iface.legendInterface().layers()
        for cur_layer in layers:            
            name = cur_layer.name().lower()
            if self.params['street_layer'] == name: 
                self.layers['street_layer'] = cur_layer 
            elif self.params['portal_layer'] == name:    
                self.layers['portal_layer'] = cur_layer 
            elif self.params['ppoint_layer'] == name:  
                self.layers['ppoint_layer'] = cur_layer     
            elif self.params['hydrometer_layer'] == name:   
                self.layers['hydrometer_layer'] = cur_layer      
            if self.params['hydrometer_urban_propierties_layer'] == name:
                self.layers['hydrometer_urban_propierties_layer'] = cur_layer  
            if self.params['urban_propierties_layer'] == name:
                self.layers['urban_propierties_layer'] = cur_layer     
           
                         
    def populate_dialog(self):
        ''' Populate the interface with values get from layers '''                      
             
        if not self.enabled:
            return False
                     
        # Get layers and full extent
        self.get_layers()       
        
        # Tab 'Hydrometer'            
        status = self.populate_combo('hydrometer_layer', self.dlg.hydrometer_code, 
                                     self.params['hydrometer_urban_propierties_field_code'], self.params['hydrometer_field_code'])
        if not status:
            print "Error populating Tab 'Hydrometer'"
            self.dlg.tab_main.removeTab(3)
              
        # Tab 'Address'      
        status = self.address_populate('street_layer')
        if not status:
            print "Error populating Tab 'Address'"   
            self.dlg.tab_main.removeTab(2)                       
        
        # Tab 'Ppoint'      
        status = self.populate_combo('ppoint_layer', self.dlg.ppoint_press_zone, self.params['ppoint_field_zone'])
        status_2 = self.populate_combo('ppoint_layer', self.dlg.ppoint_number, self.params['ppoint_field_number'])
        if not status or not status_2:
            print "Error populating Tab 'Ppoint'"
            self.dlg.tab_main.removeTab(1)              
              
        # Tab 'Urban Properties'      
        status = self.urban_populate('urban_propierties_layer')
        if not status:
            print "Error populating Tab 'Urban Properties'"
            self.dlg.tab_main.removeTab(0)              
            
        return True
        
                
    def address_populate(self, parameter):
        ''' Populate combo 'address_street' '''
        
        # Check if we have this search option available
        if not parameter in self.layers:
            layername = self.params[parameter]
            message = "Layer '{}' not found in parameter '{}'".format(layername, parameter)  
            self.controller.show_warning(message)          
            return False

        # Get layer features
        layer = self.layers[parameter]        
        records = [(-1, '', '')]
        idx_field_code = layer.fieldNameIndex(self.params['street_field_code'])    
        idx_field_name = layer.fieldNameIndex(self.params['street_field_name'])
        for feature in layer.getFeatures():
            geom = feature.geometry()
            attrs = feature.attributes() 
            field_code = attrs[idx_field_code]  
            field_name = attrs[idx_field_name]    
            if not type(field_code) is QPyNullVariant and geom is not None:
                elem = [field_code, field_name, geom.exportToWkt()]
            else:
                elem = [field_code, field_name, None]
            records.append(elem)

        # Fill combo 'address_street'
        self.dlg.adress_street.blockSignals(True)
        self.dlg.adress_street.clear()
        records_sorted = sorted(records, key = operator.itemgetter(1))            
        for i in range(len(records_sorted)):
            record = records_sorted[i]
            self.dlg.adress_street.addItem(record[1], record)
        self.dlg.adress_street.blockSignals(False)    
        
        return True
           
    
    def address_get_numbers(self):
        ''' Populate civic numbers depending on selected street. 
            Available civic numbers are linked with self.street_field_code column code in self.portal_layer and self.street_layer
        '''   
                           
        # get selected street
        selected = self.dlg.adress_street.currentText()
        if selected == '':
            print "Any record selected"            
            return
        
        # get street code
        elem = self.dlg.adress_street.itemData(self.dlg.adress_street.currentIndex())
        code = elem[0] # to know the index see the query that populate the combo
        records = [[-1, '']]
        
        # Set filter expression
        layer = self.layers['portal_layer'] 
        idx_field_code = layer.fieldNameIndex(self.params['portal_field_code'])            
        idx_field_number = layer.fieldNameIndex(self.params['portal_field_number'])   
        aux = self.params['portal_field_code']+" = '"+str(code)+"'" 
        
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
            
        # Get a featureIterator from an expression:
        # Get features from the iterator and do something
        it = layer.getFeatures(QgsFeatureRequest(expr))
        for feature in it: 
            attrs = feature.attributes() 
            field_number = attrs[idx_field_number]    
            if not type(field_number) is QPyNullVariant:
                elem = [code, field_number]
                records.append(elem)
                  
        # Fill numbers combo
        records_sorted = sorted(records, key = operator.itemgetter(1))           
        self.dlg.adress_number.blockSignals(True)
        self.dlg.adress_number.clear()
        for record in records_sorted:
            self.dlg.adress_number.addItem(str(record[1]), record)
        self.dlg.adress_number.blockSignals(False)  
        
                 
    def address_zoom_street(self):
        ''' Zoom on the street with the prefined scale '''
        
        # Get selected street
        selected = self.dlg.adress_street.currentText()
        if selected == '':
            print "Any record selected"            
            return

        data = self.dlg.adress_street.itemData(self.dlg.adress_street.currentIndex())
        wkt = data[2]   # to know the index see the query that populate the combo
        geom = QgsGeometry.fromWkt(wkt)
        if not geom:
            message = "Geometry not valid or not defined"
            self.controller.show_warning(message) 
            return
        
        # zoom on it's centroid
        centroid = geom.centroid()
        self.iface.mapCanvas().setCenter(centroid.asPoint())
        self.iface.mapCanvas().zoomScale(float(self.scale_zoom))
        
                
    def address_zoom_portal(self):
        ''' Show street data on the canvas when selected street and number in street tab '''  
                
        street = self.dlg.adress_street.currentText()
        civic = self.dlg.adress_number.currentText()
        if street == '' or civic == '':
            print "Any record selected"
            return  
                
        # Get selected portal
        elem = self.dlg.adress_number.itemData(self.dlg.adress_number.currentIndex())
        if not elem:
            # that means that user has edited manually the combo but the element
            # does not correspond to any combo element
            message = 'Element {} does not exist'.format(civic)
            self.controller.show_warning(message) 
            return
        
        # select this feature in order to copy to memory layer        
        aux = self.params['portal_field_code']+"='"+str(elem[0])+"' AND "+self.params['portal_field_number']+"='"+str(elem[1])+"'"
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
        layer.setSelectedFeatures(ids)
        
        # Copy selected features to memory layer     
        self.portalMemLayer = self.copy_selected(layer, self.portalMemLayer, "Point")       

        # Zoom to point layer
        self.iface.mapCanvas().zoomScale(float(self.scale_zoom))
        
        # Load style
        if self.QML_PORTAL is not None:        
            self.load_style(self.portalMemLayer, self.QML_PORTAL)    
          
    
    def generic_zoom(self, fieldname, combo, field_index=0):  
        
        # Get selected element from combo    
        element = combo.currentText()
        if element.strip() == '':
            print "Any record selected"
            return None
                
        elem = combo.itemData(combo.currentIndex())
        if not elem:
            # that means that user has edited manually the combo but the element
            # does not correspond to any combo element
            message = 'Element {} does not exist'.format(element)
            self.controller.show_warning(message) 
            return None
        
        # Select this feature in order to copy to memory layer       
        aux = fieldname+" = '"+str(elem[field_index])+"'"
        expr = QgsExpression(aux)     
        if expr.hasParserError():   
            message = expr.parserErrorString() + ": " + aux
            self.controller.show_warning(message)        
            return     
        
        return expr
            
            
    def ppoint_zoom(self, fieldname, combo):
        ''' Zoom to layer 'point' '''  

        expr = self.generic_zoom(fieldname, combo)
        if expr is None:
            return
        
        # Get a featureIterator from an expression
        # Build a list of feature Ids from the previous result       
        # Select featureswith the ids obtained  
        layer = self.layers['ppoint_layer']           
        it = layer.getFeatures(QgsFeatureRequest(expr))
        ids = [i.id() for i in it]
        layer.setSelectedFeatures(ids)
        
        # Copy selected features to memory layer     
        self.ppointMemLayer = self.copy_selected(layer, self.ppointMemLayer, "Point")       

        # Zoom to point layer
        self.iface.mapCanvas().zoomScale(float(self.scale_zoom))
        
        # Load style
        if self.QML_PPOINT is not None:
            self.load_style(self.ppointMemLayer, self.QML_PPOINT)
  
  
    def hydrometer_zoom(self, fieldname, combo):
        ''' Zoom to layer 'connec' '''  
        
        expr = self.generic_zoom(fieldname, combo)
        if expr is None:
            return        
  
        # Get a featureIterator from an expression
        # Build a list of feature Ids from the previous result       
        # Select featureswith the ids obtained 
        layer = self.layers['hydrometer_urban_propierties_layer']          
        it = layer.getFeatures(QgsFeatureRequest(expr))
        ids = [i.id() for i in it]
        layer.setSelectedFeatures(ids)
        
        # Copy selected features to memory layer     
        self.hydrometerMemLayerTo = self.copy_selected(layer, self.hydrometerMemLayerTo, "Point")       

        # Zoom to point layer
        self.iface.mapCanvas().zoomScale(float(self.scale_zoom))
        
        # Load style
        if self.QML_HYDROMETER is not None:
            self.load_style(self.ppointMemLayer, self.QML_HYDROMETER)
            
            
    def urban_populate(self, layer):
        ''' Populate combos tab 'urban properties' '''
        
        status = self.populate_combo(layer, self.dlg.urban_properties_block, self.params['urban_propierties_field_block'])
        if not status:
            return False
        status = self.populate_combo(layer, self.dlg.urban_properties_number, self.params['urban_propierties_field_number'])   
        if not status:
            return False

        return True
                
    
    def urban_zoom(self, fieldname, combo):
        ''' Zoom to layer 'urban' '''  
          
        expr = self.generic_zoom(fieldname, combo)
        if expr is None:
            return       
    
        # Get a featureIterator from an expression
        # Build a list of feature Ids from the previous result       
        # Select features with the ids obtained       
        layer = self.layers['urban_propierties_layer']      
        it = layer.getFeatures(QgsFeatureRequest(expr))
        ids = [i.id() for i in it]
        layer.setSelectedFeatures(ids)
        
        # Copy selected features to memory layer     
        self.urbanMemLayer = self.copy_selected(layer, self.urbanMemLayer, "Polygon")       

        # Zoom to point layer
        self.iface.mapCanvas().zoomScale(float(self.scale_zoom))
            
                
    def populate_combo(self, parameter, combo, fieldname, fieldname_2=None):
        ''' Populate selected combo from features of selected layer '''        
        
        # Check if we have this search option available
        if not parameter in self.layers:
            layername = self.params[parameter]
            message = "Layer '{}' not found in parameter '{}'".format(layername, parameter)  
            self.controller.show_warning(message)          
            return False

        # Fields management
        layer = self.layers[parameter]
        records = [(-1, '')]
        idx_field = layer.fieldNameIndex(fieldname) 
        if idx_field == -1:           
            message = "Field '{}' not found in the layer specified in parameter '{}'".format(fieldname, parameter)           
            self.controller.show_warning(message)
            return False      
        if fieldname_2 is not None:
            idx_field_2 = layer.fieldNameIndex(fieldname_2) 
            if idx_field_2 == -1:           
                message = "Field '{}' not found in the layer specified in parameter '{}'".format(fieldname_2, parameter)           
                self.controller.show_warning(message)
                return False   
        else:
            idx_field_2 = idx_field
            fieldname_2 = fieldname   
 
        # Iterate over all features to get distinct records
        for feature in layer.getFeatures():                                
            attrs = feature.attributes() 
            field = attrs[idx_field]  
            field_2 = attrs[idx_field_2]  
            if not type(field) is QPyNullVariant:
                elem = [field, field_2]               
                records.append(elem)
        
        combo.blockSignals(True)
        combo.clear()
        records_sorted = sorted(records, key = operator.itemgetter(1))            
        for i in range(len(records_sorted)):
            record = records_sorted[i]
            combo.addItem(record[1], record)
        combo.blockSignals(False)     
        
        return True
                    
                
    def manage_mem_layer(self, layer):
        ''' Delete previous features from all memory layers 
            Make layer not visible '''
        
        if layer is not None:
            try:
                layer.startEditing()        
                it = layer.getFeatures()
                ids = [i.id() for i in it]
                layer.dataProvider().deleteFeatures(ids)    
                layer.commitChanges()     
                self.iface.legendInterface().setLayerVisible(layer, False)
            except RuntimeError as e:
                self.controller.show_warning(str(e)) 


    def manage_mem_layers(self):
        ''' Delete previous features from all memory layers '''        
        self.manage_mem_layer(self.portalMemLayer)
        self.manage_mem_layer(self.ppointMemLayer)
        self.manage_mem_layer(self.hydrometerMemLayerTo)
      
    
    def copy_selected(self, layer, mem_layer, geom_type):
        ''' Copy from selected layer to memory layer '''
        
        self.manage_mem_layers()
        
        # Create memory layer if not already set
        if mem_layer is None: 
            uri = geom_type+"?crs=epsg:"+str(self.srid) 
            mem_layer = QgsVectorLayer(uri, "selected_"+layer.name(), "memory")                     
         
            # Copy attributes from main layer to memory layer
            attrib_names = layer.dataProvider().fields()
            names_list = attrib_names.toList()
            newattributeList = []
            for attrib in names_list:
                aux = mem_layer.fieldNameIndex(attrib.name())
                if aux == -1:
                    newattributeList.append(QgsField(attrib.name(), attrib.type()))
            mem_layer.dataProvider().addAttributes(newattributeList)
            mem_layer.updateFields()
            
            # Insert layer in the top of the TOC           
            root = QgsProject.instance().layerTreeRoot()           
            QgsMapLayerRegistry.instance().addMapLayer(mem_layer, False)
            node_layer = QgsLayerTreeLayer(mem_layer)
            root.insertChildNode(0, node_layer)                 
     
        # Prepare memory layer for editing
        mem_layer.startEditing()
        
        # Iterate over selected features   
        cfeatures = []
        for sel_feature in layer.selectedFeatures():
            attributes = []
            attributes.extend(sel_feature.attributes())
            cfeature = QgsFeature()    
            cfeature.setGeometry(sel_feature.geometry())
            cfeature.setAttributes(attributes)
            cfeatures.append(cfeature)
                     
        # Add features, commit changes and refresh canvas
        mem_layer.dataProvider().addFeatures(cfeatures)             
        mem_layer.commitChanges()
        self.iface.mapCanvas().refresh() 
        self.iface.mapCanvas().zoomToSelected(layer)
        
        # Make sure layer is always visible 
        self.iface.legendInterface().setLayerVisible(mem_layer, True)
                    
        return mem_layer
          

    def load_style(self, layer, qml):
        ''' Load QML style file into selected layer '''
        path_qml = self.stylesFolder+qml      
        if os.path.exists(path_qml): 
            layer.loadNamedStyle(path_qml)      
            
                
    def remove_memory_layers(self):
        ''' Iterate over all layers and remove memory ones '''         
        layers = self.iface.legendInterface().layers()
        for cur_layer in layers:     
            layer_name = cur_layer.name().lower()         
            if "selected_" in layer_name:
                QgsMapLayerRegistry.instance().removeMapLayer(cur_layer.id())  
                     
                     
    def unload(self):
        ''' Removes dialog '''       
        if self.dlg:
            self.dlg.deleteLater()
            del self.dlg            
                                                         
