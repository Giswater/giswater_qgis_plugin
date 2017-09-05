# -*- coding: utf-8 -*-
from qgis.core import QgsGeometry, QgsExpression, QgsFeatureRequest, QgsVectorLayer, QgsFeature, QgsMapLayerRegistry, QgsField, QgsProject, QgsLayerTreeLayer   # @UnresolvedImport
from PyQt4.QtCore import QObject, QPyNullVariant   # @UnresolvedImport

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
        ''' Constructor '''
        
        self.iface = iface
        self.srid = srid
        self.controller = controller    
    
        # Create dialog
        self.dlg = SearchPlusDockWidget(self.iface.mainWindow())
        
        # Load configuration data from tables
        if not self.load_config_data():
            self.enabled = False
            return      

        # Set parameters that were located in removed file 'searchplus.config'
        current_dir = os.path.dirname(__file__)           
        self.styles_folder = current_dir+"/styles/"          
        self.qml_portal = 'portal.qml'                              
        self.qml_hydrometer = 'hydrometer.qml'                
        self.scale_zoom = 5000      
        
        # Set signals             
        self.dlg.adress_street.activated.connect(partial(self.address_get_numbers))
        self.dlg.adress_street.activated.connect(partial(self.address_zoom_street))
        self.dlg.adress_number.activated.connect(partial(self.address_zoom_portal))     
        #self.dlg.hydrometer_code.activated.connect(partial(self.hydrometer_zoom, self.params['hydrometer_urban_propierties_field_code'], self.dlg.hydrometer_code))    

        self.enabled = True
        
        self.controller.log_info("searchplus enabled")        
    
      
    def load_config_data(self):
        ''' Load configuration data from tables '''
        
        self.params = {}
        sql = "SELECT parameter, value FROM "+self.controller.schema_name+".config_param_system"
        sql += " WHERE context = 'searchplus' ORDER BY parameter"
        rows = self.controller.get_rows(sql)
        if rows:
            for row in rows:
                self.params[row['parameter']] = str(row['value'])
            return True
        else:
            self.controller.log_warning("No data found in configuration table related with 'searchplus'")
            return False            

            
    def get_layers(self): 
        ''' Iterate over all layers to get the ones set in config file '''
        
        # Initialize class variables        
        self.portal_mem_layer = None                      
        self.hydrometer_mem_layer_to = None
        
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
                if self.params['street_layer'] == uri_table: 
                    self.controller.log_info("street_layer found")
                    self.layers['street_layer'] = cur_layer 
                elif self.params['portal_layer'] == uri_table:    
                    self.controller.log_info("portal_layer found")
                    self.layers['portal_layer'] = cur_layer  
                elif self.params['hydrometer_layer'] == uri_table:   
                    self.controller.log_info("hydrometer_layer found")
                    self.layers['hydrometer_layer'] = cur_layer        
                if self.params['hydrometer_urban_propierties_layer'] == uri_table:
                    self.controller.log_info("hydrometer_urban_propierties_layer found")
                    self.layers['hydrometer_urban_propierties_layer'] = cur_layer               
     
     
    def populate_dialog(self):
        ''' Populate the interface with values get from layers '''                      
          
        if not self.enabled:
            return False
                     
        # Get layers and full extent
        self.get_layers()       
        
        # Tab 'Hydrometer'             
        status = self.populate_combo('hydrometer_layer', self.dlg.hydrometer_code, 
                                     self.params['hydrometer_field_urban_propierties_code'], self.params['hydrometer_field_code'])
        if not status:
            self.dlg.tab_main.removeTab(3)
                 
        # Tab 'Address'      
        status = self.address_populate('street_layer')
        if not status:
            self.dlg.tab_main.removeTab(2)                              
            
        return True
        
                
    def address_populate(self, parameter):
        ''' Populate combo 'address_street' '''
        
        # Check if we have this search option available
        if not parameter in self.layers:  
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
            self.dlg.adress_street.addItem(str(record[1]), record)
        self.dlg.adress_street.blockSignals(False)    
        
        return True
           
    
    def address_get_numbers(self):
        ''' Populate civic numbers depending on selected street. 
            Available civic numbers are linked with self.street_field_code column code in self.portal_layer and self.street_layer
        '''   
                           
        # get selected street
        selected = self.dlg.adress_street.currentText()
        if selected == '':        
            return
        
        # get street code
        elem = self.dlg.adress_street.itemData(self.dlg.adress_street.currentIndex())
        code = elem[0] # to know the index see the query that populate the combo
        records = [[-1, '']]
        
        # Set filter expression
        layer = self.layers['portal_layer'] 
        idx_field_code = layer.fieldNameIndex(self.params['portal_field_code'])            
        idx_field_number = layer.fieldNameIndex(self.params['portal_field_number'])   
        aux = self.params['portal_field_code'] +"  = '" + str(code) + "'" 
        
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
        
        # Toggles 'Show feature count'
        self.show_feature_count()              
        
                
    def address_zoom_portal(self):
        ''' Show street data on the canvas when selected street and number in street tab '''  
                
        street = self.dlg.adress_street.currentText()
        civic = self.dlg.adress_number.currentText()
        if street == '' or civic == '':
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
        
        # Copy selected features to memory layer     
        self.portal_mem_layer = self.copy_selected(layer, self.portal_mem_layer, "Point")       

        # Zoom to generated memory layer
        self.zoom_to_scale()
        
        # Load style
        if self.qml_portal is not None:        
            self.load_style(self.portal_mem_layer, self.qml_portal)    
            
        # Toggles 'Show feature count'
        self.show_feature_count()                  
          
    
    def generic_zoom(self, fieldname, combo, field_index=0):  
        ''' Get selected element from the combo, and returns a feature request expression '''
        
        # Get selected element from combo    
        element = combo.currentText()
        if element.strip() == '':
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
    
  
    def hydrometer_zoom(self, fieldname, combo):
        ''' Zoom to layer 'v_edit_connec' '''  

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
        
        # Copy selected features to memory layer     
        self.hydrometer_mem_layer_to = self.copy_selected(layer, self.hydrometer_mem_layer_to, "Point")       

        # Zoom to generated memory layer
        self.zoom_to_scale()
        
        # Load style
        if self.qml_hydrometer is not None:
            self.load_style(self.hydrometer_mem_layer_to, self.qml_hydrometer)
            
        # Toggles 'Show feature count'
        self.show_feature_count()                  
            
            
    def populate_combo(self, parameter, combo, fieldname, fieldname_2=None):
        ''' Populate selected combo from features of selected layer '''        
        
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
        records_sorted = sorted(records, key = operator.itemgetter(1)) 
        combo.addItem('', '')                 
        for i in range(len(records_sorted)):
            record = records_sorted[i]
            combo.addItem(str(record[1]), record)
        combo.blockSignals(False)     
        
        return True
                    
        
    def show_feature_count(self):
        ''' Toggles 'Show Feature Count' of all the layers in the root path of the TOC '''   
                     
        root = QgsProject.instance().layerTreeRoot()
        for child in root.children():
            if isinstance(child, QgsLayerTreeLayer):
                child.setCustomProperty("showFeatureCount", True)     
        
                
    def zoom_to_scale(self):
        ''' Zoom to scale '''
        scale = self.iface.mapCanvas().scale()
        if int(scale) < int(self.scale_zoom):
            self.iface.mapCanvas().zoomScale(float(self.scale_zoom))                 
                                    
                
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
        self.manage_mem_layer(self.portal_mem_layer)
        self.manage_mem_layer(self.hydrometer_mem_layer_to)

    
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
           
     
        # Prepare memory layer for editing
        mem_layer.startEditing()
        
        # Iterate over selected features   
        cfeatures = []
        for sel_feature in layer.selectedFeatures():
            attributes = []
            attributes.extend(sel_feature.attributes())
            cfeature = QgsFeature()    
            if sel_feature.geometry() is not None:
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
        if layer is None:
            return
        path_qml = self.styles_folder+qml     
        if os.path.exists(path_qml) and os.path.isfile(path_qml): 
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
                                                            
    
