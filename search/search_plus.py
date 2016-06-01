# -*- coding: utf-8 -*-
from qgis.gui import QgsMessageBar
from qgis.core import QgsGeometry, QgsExpression, QgsFeatureRequest, QgsVectorLayer, QgsFeature, QgsMapLayerRegistry, QgsField, QgsProject, QgsLayerTreeLayer
from PyQt4.QtCore import QObject, QSettings, QTranslator, qVersion, QCoreApplication, Qt, pyqtSignal, QPyNullVariant

import operator
import os.path
from search_plus_dockwidget import SearchPlusDockWidget


class SearchPlus(QObject):


    def __init__(self, iface):
        ''' Constructor '''
        
        # Save reference to the QGIS interface
        self.iface = iface
        
        # initialize plugin directory and locale
        self.plugin_dir = os.path.dirname(__file__)
        locale = QSettings().value('locale/userLocale')[0:2]
        locale_path = os.path.join(self.plugin_dir, 'i18n', 'SearchPlus_{}.qm'.format(locale))
        if os.path.exists(locale_path):
            self.translator = QTranslator()
            self.translator.load(locale_path)
            if qVersion() > '4.3.3':
                QCoreApplication.installTranslator(self.translator)      
        else:
            print "Locale file not found at: "+locale_path            
        
        # load local settings of the plugin
        self.app_name = "searchplus"        
        self.setting_file = os.path.join(self.plugin_dir, 'config', self.app_name+'.config')   
        if not os.path.isfile(self.setting_file):
            message = "Config file not found at: "+self.setting_file            
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5)            
            return False        
        self.settings = QSettings(self.setting_file, QSettings.IniFormat)
            
        # load plugin settings
        self.loadPluginSettings()      
        
        # create dialog
        self.dlg = SearchPlusDockWidget(self.iface.mainWindow())
        
        # set signals
        self.dlg.cboStreet.currentIndexChanged.connect(self.getStreetNumbers)
        self.dlg.cboStreet.currentIndexChanged.connect(self.zoomOnStreet)
        self.dlg.cboNumber.currentIndexChanged.connect(self.displayStreetData)        
    
    
    def loadPluginSettings(self):
        ''' Load plugin settings '''
        
        # get layers configuration to populate the GUI
        self.STREET_LAYER = self.settings.value('layers/STREET_LAYER', '').lower()
        self.STREET_FIELD_CODE = self.settings.value('layers/STREET_FIELD_CODE', '').lower()
        self.STREET_FIELD_NAME = self.settings.value('layers/STREET_FIELD_NAME', '').lower()
        self.PORTAL_LAYER = self.settings.value('layers/PORTAL_LAYER', '').lower()
        self.PORTAL_FIELD_CODE = self.settings.value('layers/PORTAL_FIELD_CODE', '').lower()
        self.PORTAL_FIELD_NUMBER = self.settings.value('layers/PORTAL_FIELD_NUMBER', '').lower()   
        
        # get initial Scale
        self.defaultZoomScale = self.settings.value('status/defaultZoomScale', 2500)

            
    def getLayers(self): 
        ''' Iterate over all layers to get the ones set in config file '''
        
        self.streetLayer = None
        self.portalLayer = None     
        self.portalMemLayer = None            
        layers = self.iface.legendInterface().layers()
        for cur_layer in layers:            
            name = cur_layer.name().lower()
            if self.STREET_LAYER in name:      
                self.streetLayer = cur_layer
            elif self.PORTAL_LAYER in name:  
                self.portalLayer = cur_layer       
            
            
    # noinspection PyMethodMayBeStatic
    def tr(self, message):
        ''' Get the translation for a string using Qt translation API '''
        return QCoreApplication.translate('SearchPlus', message)


    def populateGui(self):
        ''' Populate the interface with values get from layers '''  
        
        # Remove unused tabs
        self.dlg.searchPlusTabMain.removeTab(4)          
        self.dlg.searchPlusTabMain.removeTab(3)          
        self.dlg.searchPlusTabMain.removeTab(2)          
        self.dlg.searchPlusTabMain.removeTab(1)          
             
        # Get layers and full extent
        self.getLayers()       
                
        # tab Streets      
        status = self.populateStreets()
        return status
        
                    
    def populateStreets(self):
        
        # Check if we have this search option available
        if self.streetLayer is None or self.portalLayer is None:  
            return False

        # Get layer features
        layer = self.streetLayer
        records = [(-1, '', '', '')]
        idx_id = layer.fieldNameIndex('id')
        idx_field_name = layer.fieldNameIndex(self.STREET_FIELD_NAME)
        idx_field_code = layer.fieldNameIndex(self.STREET_FIELD_CODE)    
        for feature in layer.getFeatures():
            geom = feature.geometry()
            attrs = feature.attributes()
            field_id = attrs[idx_id]    
            field_name = attrs[idx_field_name]    
            field_code = attrs[idx_field_code]  
            if not type(field_code) is QPyNullVariant and geom is not None:
                elem = [field_id, field_name, field_code, geom.exportToWkt()]
                records.append(elem)

        # Fill street combo
        self.dlg.cboStreet.blockSignals(True)
        self.dlg.cboStreet.clear()
        records_sorted = sorted(records, key = operator.itemgetter(1))            
        for i in range(len(records_sorted)):
            record = records_sorted[i]
            self.dlg.cboStreet.addItem(record[1], record)
        self.dlg.cboStreet.blockSignals(False)    
        
        return True
        
                 
    def zoomOnStreet(self):
        ''' Zoom on the street with the prefined scale '''
        # get selected street
        selected = self.dlg.cboStreet.currentText()
        if selected == '':
            return
        
        # get code
        data = self.dlg.cboStreet.itemData(self.dlg.cboStreet.currentIndex())
        wkt = data[3] # to know the index see the query that populate the combo
        geom = QgsGeometry.fromWkt(wkt)
        if not geom:
            message = self.tr('Can not correctly get geometry')
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5)
            return
        
        # zoom on it's centroid
        centroid = geom.centroid()
        self.iface.mapCanvas().setCenter(centroid.asPoint())
        self.iface.mapCanvas().zoomScale(float(self.defaultZoomScale))
    
    
    def getStreetNumbers(self):
        ''' Populate civic numbers depending on selected street. 
            Available civic numbers are linked with self.STREET_FIELD_CODE column code in self.PORTAL_LAYER and self.STREET_LAYER
        '''                      
        # get selected street
        selected = self.dlg.cboStreet.currentText()
        if selected == '':
            return
        
        # get street code
        sel_street = self.dlg.cboStreet.itemData(self.dlg.cboStreet.currentIndex())
        code = sel_street[2] # to know the index see the query that populate the combo
        records = [[-1, '']]
        
        # Set filter expression
        layer = self.portalLayer  
        idx_field_code = layer.fieldNameIndex(self.PORTAL_FIELD_CODE)            
        idx_field_number = layer.fieldNameIndex(self.PORTAL_FIELD_NUMBER)   
        aux = self.PORTAL_FIELD_CODE+"='"+str(code)+"'" 
        
        # Check filter and existence of fields
        expr = QgsExpression(aux)     
        if expr.hasParserError():   
            self.iface.messageBar().pushMessage(expr.parserErrorString() + ": " + aux, self.app_name, QgsMessageBar.WARNING, 10)        
            return               
        if idx_field_code == -1:    
            message = self.tr("Field '{}' not found in layer '{}'. Open '{}' and check parameter '{}'".
                format(self.PORTAL_FIELD_CODE, layer.name(), self.setting_file, 'PORTAL_FIELD_CODE'))            
            self.iface.messageBar().pushMessage(message, '', QgsMessageBar.WARNING)        
            return      
        if idx_field_number == -1:    
            message = self.tr("Field '{}' not found in layer '{}'. Open '{}' and check parameter '{}'".
                format(self.PORTAL_FIELD_NUMBER, layer.name(), self.setting_file, 'PORTAL_FIELD_NUMBER'))            
            self.iface.messageBar().pushMessage(message, '', QgsMessageBar.WARNING)        
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
        self.dlg.cboNumber.blockSignals(True)
        self.dlg.cboNumber.clear()
        for record in records_sorted:
            self.dlg.cboNumber.addItem(str(record[1]), record)
        self.dlg.cboNumber.blockSignals(False)  
        
    
    def manageMemLayer(self, layer):
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
                self.iface.messageBar().pushMessage(str(e), '', QgsMessageBar.WARNING)  


    def manageMemLayers(self):
        ''' Delete previous features from all memory layers '''        
        self.manageMemLayer(self.portalMemLayer)
      
    
    def copySelected(self, layer, mem_layer, geom_type):
        ''' Copy from selected layer to memory layer '''
        self.manageMemLayers()
        
        # Create memory layer if not already set
        if mem_layer is None: 
            uri = geom_type+"?crs=epsg:25831" 
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
    
    
    def displayStreetData(self):
        ''' Show street data on the canvas when selected street and number in street tab '''  
                
        street = self.dlg.cboStreet.currentText()
        civic = self.dlg.cboNumber.currentText()
        if street == '' or civic == '':
            return  
                
        # get selected portal
        elem = self.dlg.cboNumber.itemData(self.dlg.cboNumber.currentIndex())
        if not elem:
            # that means that user has edited manually the combo but the element
            # does not correspond to any combo element
            message = self.tr('Element {} does not exist'.format(civic))
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5)
            return
        
        # select this feature in order to copy to memory layer        
        aux = self.PORTAL_FIELD_CODE+"='"+str(elem[0])+"' AND "+self.PORTAL_FIELD_NUMBER+"='"+str(elem[1])+"'"
        expr = QgsExpression(aux)     
        if expr.hasParserError():   
            self.iface.messageBar().pushMessage(expr.parserErrorString() + ": " + aux, self.app_name, QgsMessageBar.WARNING, 5)        
            return    
        
        # Get a featureIterator from an expression
        # Build a list of feature Ids from the previous result       
        # Select featureswith the ids obtained             
        it = self.portalLayer.getFeatures(QgsFeatureRequest(expr))
        ids = [i.id() for i in it]
        self.portalLayer.setSelectedFeatures(ids)
        
        # Copy selected features to memory layer     
        self.portalMemLayer = self.copySelected(self.portalLayer, self.portalMemLayer, "Point")       

        # Zoom to point layer
        self.iface.mapCanvas().zoomScale(float(self.defaultZoomScale))
        
        # Load style
        #self.loadStyle(self.portalMemLayer, self.QML_PORTAL)         
          

    def run(self):
        ''' Run method activated byt the toolbar action button '''         
        if self.dlg and not self.dlg.isVisible():
            print "run"
            self.populateGui()       
            self.dlg.show()
            
                
    def removeMemoryLayers(self):
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
                                                         
