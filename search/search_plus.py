# -*- coding: utf-8 -*-
from qgis.core import QgsGeometry, QgsExpression, QgsFeatureRequest, QgsProject, QgsLayerTreeLayer   # @UnresolvedImport
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
        self.scale_zoom = 2500      
    
        # Create dialog
        self.dlg = SearchPlusDockWidget(self.iface.mainWindow())
        
        # Load configuration data from tables
        if not self.load_config_data():
            self.enabled = False
            return      
        
        # Set signals             
        self.dlg.adress_street.activated.connect(self.address_get_numbers)
        self.dlg.adress_street.activated.connect(self.address_zoom_street)
        self.dlg.adress_number.activated.connect(self.address_zoom_portal)     
        
        self.dlg.hydrometer_connec.activated.connect(self.hydrometer_get_hydrometers)        
        self.dlg.hydrometer_id.activated.connect(partial(self.hydrometer_zoom, self.params['hydrometer_urban_propierties_field_code'], self.dlg.hydrometer_id))    

        self.enabled = True     
    
      
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
            self.controller.log_warning("No data found in table 'config_param_system' related with 'searchplus'")
            return False            

            
    def get_layers(self): 
        ''' Iterate over all layers to get the ones set in config file '''
        
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
                    self.layers['street_layer'] = cur_layer 
                elif self.params['portal_layer'] == uri_table:    
                    self.layers['portal_layer'] = cur_layer  
                elif self.params['hydrometer_layer'] == uri_table:   
                    self.layers['hydrometer_layer'] = cur_layer        
                elif self.params['hydrometer_urban_propierties_layer'] == uri_table:
                    self.layers['hydrometer_urban_propierties_layer'] = cur_layer               
     
     
    def populate_dialog(self):
        ''' Populate the interface with values get from layers '''                      
          
        if not self.enabled:
            return False
                     
        # Get layers and full extent
        self.get_layers()       
                 
        # Tab 'Address'      
        status = self.address_populate('street_layer')
        if not status:
            self.dlg.tab_main.removeTab(2)                              
        
        # Tab 'Hydrometer'             
        status = self.populate_combo('hydrometer_urban_propierties_layer', self.dlg.hydrometer_connec, self.params['hydrometer_field_urban_propierties_code'])  
        status = self.populate_combo('hydrometer_layer', self.dlg.hydrometer_id, self.params['hydrometer_field_urban_propierties_code'], self.params['hydrometer_field_code'])
        if not status:
            self.dlg.tab_main.removeTab(1)
            
        # TODO: Tab 'Network'
        self.dlg.tab_main.removeTab(0)
            
        return True
    
    
    def hydrometer_get_hydrometers(self):
        ''' Populate hydrometers depending on selected connec. 
            Available hydrometers are linked with self.street_field_code column code in self.portal_layer and self.street_layer
        '''   
                                
        # Get selected connec
        selected = self.dlg.hydrometer_connec.currentText()
        
        # If any conenc selected, get again all hydrometers
        if selected == '':        
            self.controller.log_info("hydrometer_get_hydrometers")
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
        aux = self.params['hydrometer_field_urban_propierties_code'] +"  = '" + str(code) + "'" 
        
        # Check filter and existence of fields
        self.controller.log_info(aux)        
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
        records_sorted = sorted(records, key = operator.itemgetter(1))           
        self.dlg.hydrometer_id.blockSignals(True)
        self.dlg.hydrometer_id.clear()
        for record in records_sorted:
            self.dlg.hydrometer_id.addItem(str(record[1]), record)
        self.dlg.hydrometer_id.blockSignals(False)  
                
        
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

        # Zoom to selected feature of the layer
        self.zoom_to_selected_feature(self.layers['hydrometer_urban_propierties_layer'])
                    
        # Toggles 'Show feature count'
        self.show_feature_count()    
                
                
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
        
        # Zoom on it's centroid
        centroid = geom.centroid()
        self.iface.setActiveLayer(self.layers['street_layer'])        
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

        # Zoom to selected feature of the layer
        self.zoom_to_selected_feature(self.layers['portal_layer'])
                    
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
        
                
    def zoom_to_selected_feature(self, layer):
        """ Zoom to selected feature of the layer """
        
        if not layer:
            return
        self.iface.setActiveLayer(layer)
        self.iface.actionZoomToSelected().trigger()        
        scale = self.iface.mapCanvas().scale()
        if int(scale) < int(self.scale_zoom):
            self.iface.mapCanvas().zoomScale(float(self.scale_zoom))                 
                                                        
                     
    def unload(self):
        ''' Removes dialog '''       
        if self.dlg:
            self.dlg.deleteLater()
            del self.dlg            
                                                            
    
