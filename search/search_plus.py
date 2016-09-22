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
        
        # load plugin settings
        self.load_plugin_settings()      
        
        # create dialog
        self.dlg = SearchPlusDockWidget(self.iface.mainWindow())
        
        # set signals
        self.dlg.ppoint_number.activated.connect(partial(self.ppoint_zoom, self.PPOINT_FIELD_NUMBER, self.dlg.ppoint_number))     
        self.dlg.ppoint_press_zone.activated.connect(partial(self.ppoint_zoom, self.PPOINT_FIELD_ZONE, self.dlg.ppoint_press_zone)) 
           
        self.dlg.adress_street.activated.connect(self.address_get_numbers)
        self.dlg.adress_street.activated.connect(self.address_zoom_street)
        self.dlg.adress_number.activated.connect(self.address_zoom_portal)  
        
        self.dlg.hydrometer_code.activated.connect(partial(self.hydrometer_zoom, self.HYDROMETER_FIELD_TO, self.dlg.hydrometer_code))
              
        self.dlg.urban_properties_block.activated.connect(partial(self.urban_zoom, self.URBAN_FIELD_BLOCK, self.dlg.urban_properties_block))        
        self.dlg.urban_properties_number.activated.connect(partial(self.urban_zoom, self.URBAN_FIELD_NUMBER, self.dlg.urban_properties_number))        
                 
    
    def load_plugin_settings(self):
        ''' Load plugin settings '''
        
        # get layers configuration to populate the GUI
        self.STREET_LAYER = self.settings.value('layers/STREET_LAYER', '').lower()
        self.STREET_FIELD_CODE = self.settings.value('layers/STREET_FIELD_CODE', '').lower()
        self.STREET_FIELD_NAME = self.settings.value('layers/STREET_FIELD_NAME', '').lower()
        self.PORTAL_LAYER = self.settings.value('layers/PORTAL_LAYER', '').lower()
        self.PORTAL_FIELD_CODE = self.settings.value('layers/PORTAL_FIELD_CODE', '').lower()
        self.PORTAL_FIELD_NUMBER = self.settings.value('layers/PORTAL_FIELD_NUMBER', '').lower()  
         
        self.PPOINT_LAYER = self.settings.value('layers/PPOINT_LAYER', '').lower()
        self.PPOINT_FIELD_ZONE = self.settings.value('layers/PPOINT_FIELD_ZONE', '').lower()
        self.PPOINT_FIELD_NUMBER = self.settings.value('layers/PPOINT_FIELD_NUMBER', '').lower()  
         
        self.HYDROMETER_LAYER = self.settings.value('layers/HYDROMETER_LAYER', '').lower()
        self.HYDROMETER_LAYER_TO = self.settings.value('layers/HYDROMETER_LAYER_TO', '').lower()
        self.HYDROMETER_FIELD = self.settings.value('layers/HYDROMETER_FIELD', '').lower()
        self.HYDROMETER_FIELD_TO = self.settings.value('layers/HYDROMETER_FIELD_TO', '').lower()
         
        self.URBAN_LAYER = self.settings.value('layers/URBAN_LAYER', '').lower()
        self.URBAN_FIELD_PZONE = self.settings.value('layers/URBAN_FIELD_PZONE', '').lower() 
        self.URBAN_FIELD_BLOCK = self.settings.value('layers/URBAN_FIELD_BLOCK', '').lower() 
        self.URBAN_FIELD_NUMBER = self.settings.value('layers/URBAN_FIELD_NUMBER', '').lower() 
          
        self.QML_PORTAL = self.settings.value('layers/QML_PORTAL', 'portal.qml').lower()                       
        self.QML_PPOINT = None          
        self.QML_HYDROMETER = None          
        self.QML_URBAN = None    

        # get initial Scale
        self.scale_zoom = self.settings.value('status/scale_zoom', 2500)
                 
    
    def load_config_data(self):
        ''' TODO: Load configuration data from tables '''
        
        # get layers configuration to populate the GUI

        # get initial Scale
        self.scale_zoom = self.settings.value('status/scale_zoom', 2500)

            
    def get_layers(self): 
        ''' Iterate over all layers to get the ones set in config file '''
        
        # Initialize class variables
        self.streetLayer = None
        self.portalLayer = None     
        self.ppointLayer = None 
        self.hydrometerLayer = None
        self.hydrometerLayerTo = None   
        self.urbanLayer = None   
         
        self.portalMemLayer = None            
        self.ppointMemLayer = None            
        self.hydrometerMemLayerTo = None
        self.urbanMemLayer = None
        
        # Iterate over all layers            
        layers = self.iface.legendInterface().layers()
        for cur_layer in layers:            
            name = cur_layer.name().lower()
            if self.STREET_LAYER == name:    
                self.streetLayer = cur_layer
            elif self.PORTAL_LAYER == name:  
                self.portalLayer = cur_layer       
            elif self.PPOINT_LAYER == name:  
                self.ppointLayer = cur_layer       
            elif self.HYDROMETER_LAYER == name:  
                self.hydrometerLayer = cur_layer       
            if self.HYDROMETER_LAYER_TO == name:  
                self.hydrometerLayerTo = cur_layer    
            if self.URBAN_LAYER == name:
                self.urbanLayer = cur_layer       
            
                         
    def populate_dialog(self):
        ''' Populate the interface with values get from layers '''                      
             
        # Get layers and full extent
        self.get_layers()       
        
        # Tab 'Hydrometer'            
        status = self.populate_combo(self.hydrometerLayer, self.dlg.hydrometer_code, self.HYDROMETER_FIELD_TO, self.HYDROMETER_FIELD)
        if not status:
            print "Error populating Tab 'Hydrometer'"
            self.dlg.tab_main.removeTab(3)
             
        # Tab 'Address'      
        status = self.address_populate(self.streetLayer)
        if not status:
            print "Error populating Tab 'Address'"   
            self.dlg.tab_main.removeTab(2)                       
        
        # Tab 'Ppoint'      
        status = self.populate_combo(self.ppointLayer, self.dlg.ppoint_press_zone, self.PPOINT_FIELD_ZONE)
        status_2 = self.populate_combo(self.ppointLayer, self.dlg.ppoint_number, self.PPOINT_FIELD_NUMBER)
        if not status or not status_2:
            print "Error populating Tab 'Ppoint'"
            self.dlg.tab_main.removeTab(1)              
             
        # Tab 'Urban Properties'      
        status = self.urban_populate(self.urbanLayer)
        if not status:
            print "Error populating Tab 'Urban Properties'"
            self.dlg.tab_main.removeTab(0)              
            
        return True
        
                
    def address_populate(self, layer):
        ''' Populate combo 'address_street' '''
        
        # Check if we have this search option available
        if layer is None:  
            print "Layer not found: Address"
            return False

        # Get layer features
        records = [(-1, '', '')]
        idx_field_code = layer.fieldNameIndex(self.STREET_FIELD_CODE)    
        idx_field_name = layer.fieldNameIndex(self.STREET_FIELD_NAME)
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
            Available civic numbers are linked with self.STREET_FIELD_CODE column code in self.PORTAL_LAYER and self.STREET_LAYER
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
        layer = self.portalLayer  
        idx_field_code = layer.fieldNameIndex(self.PORTAL_FIELD_CODE)            
        idx_field_number = layer.fieldNameIndex(self.PORTAL_FIELD_NUMBER)   
        aux = self.PORTAL_FIELD_CODE+" = '"+str(code)+"'" 
        
        # Check filter and existence of fields
        expr = QgsExpression(aux)     
        if expr.hasParserError():    
            message = expr.parserErrorString() + ": " + aux
            self.controller.show_warning(message)    
            return               
        if idx_field_code == -1:    
            message = "Field '{}' not found in layer '{}'. Open '{}' and check parameter '{}'" \
                .format(self.PORTAL_FIELD_CODE, layer.name(), self.setting_file, 'PORTAL_FIELD_CODE')            
            self.controller.show_warning(message)         
            return      
        if idx_field_number == -1:    
            message = "Field '{}' not found in layer '{}'. Open '{}' and check parameter '{}'" \
                .format(self.PORTAL_FIELD_NUMBER, layer.name(), self.setting_file, 'PORTAL_FIELD_NUMBER')            
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
        aux = self.PORTAL_FIELD_CODE+"='"+str(elem[0])+"' AND "+self.PORTAL_FIELD_NUMBER+"='"+str(elem[1])+"'"
        expr = QgsExpression(aux)     
        if expr.hasParserError():   
            message = expr.parserErrorString() + ": " + aux
            self.controller.show_warning(message)        
            return    
        
        # Get a featureIterator from an expression
        # Build a list of feature Ids from the previous result       
        # Select featureswith the ids obtained             
        it = self.portalLayer.getFeatures(QgsFeatureRequest(expr))
        ids = [i.id() for i in it]
        self.portalLayer.setSelectedFeatures(ids)
        
        # Copy selected features to memory layer     
        self.portalMemLayer = self.copy_selected(self.portalLayer, self.portalMemLayer, "Point")       

        # Zoom to point layer
        self.iface.mapCanvas().zoomScale(float(self.scale_zoom))
        
        # Load style
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
        it = self.ppointLayer.getFeatures(QgsFeatureRequest(expr))
        ids = [i.id() for i in it]
        self.ppointLayer.setSelectedFeatures(ids)
        
        # Copy selected features to memory layer     
        self.ppointMemLayer = self.copy_selected(self.ppointLayer, self.ppointMemLayer, "Point")       

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
        it = self.hydrometerLayerTo.getFeatures(QgsFeatureRequest(expr))
        ids = [i.id() for i in it]
        self.hydrometerLayerTo.setSelectedFeatures(ids)
        
        # Copy selected features to memory layer     
        self.hydrometerMemLayerTo = self.copy_selected(self.hydrometerLayerTo, self.hydrometerMemLayerTo, "Point")       

        # Zoom to point layer
        self.iface.mapCanvas().zoomScale(float(self.scale_zoom))
        
        # Load style
        if self.QML_HYDROMETER is not None:
            self.load_style(self.ppointMemLayer, self.QML_HYDROMETER)
            
            
    def urban_populate(self, layer):
        ''' Populate combos tab 'urban properties' '''
        
        status = self.populate_combo(layer, self.dlg.urban_properties_block, self.URBAN_FIELD_BLOCK)
        if not status:
            return False
        status = self.populate_combo(layer, self.dlg.urban_properties_number, self.URBAN_FIELD_NUMBER)   
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
        it = self.urbanLayer.getFeatures(QgsFeatureRequest(expr))
        ids = [i.id() for i in it]
        self.urbanLayer.setSelectedFeatures(ids)
        
        # Copy selected features to memory layer     
        self.urbanMemLayer = self.copy_selected(self.urbanLayer, self.urbanMemLayer, "Polygon")       

        # Zoom to point layer
        self.iface.mapCanvas().zoomScale(float(self.scale_zoom))
            
                
    def populate_combo(self, layer, combo, fieldname, fieldname_2=None):
        ''' Populate selected combo from features of selected layer '''        
        
        # Check if we have this search option available
        if layer is None:  
            print "Layer not found. Related fieldname: "+fieldname          
            return False

        # Fields management
        records = [(-1, '')]
        idx_field = layer.fieldNameIndex(fieldname) 
        if idx_field == -1:           
            message = "Field '{}' not found in layer '{}'.".format(fieldname, layer.name())           
            self.controller.show_warning(message)
            return False      
        if fieldname_2 is not None:
            idx_field_2 = layer.fieldNameIndex(fieldname_2) 
            if idx_field_2 == -1:           
                message = "Field '{}' not found in layer '{}'.".format(fieldname_2, layer.name())           
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
                                                         
