# -*- coding: utf-8 -*-
from PyQt4 import QtGui, uic
import os

# Folder that contains UI files
# In this file we will add all classes currently located in that folder
ui_path = os.path.dirname(__file__) + os.sep + 'ui'


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'add_doc.ui'))
class AddDoc(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'add_element.ui'))
class AddElement(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'add_picture.ui'))
class AddPicture(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'add_sum.ui'))
class AddSum(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)
        
        
FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'add_visit.ui'))
class AddVisit(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'arc_fusion.ui'))
class ArcFusion(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'audit_check_project_result.ui'))
class AuditCheckProjectResult(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'cad_add_circle.ui'))
class Cad_add_circle(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)
        

FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'cad_add_point.ui'))
class Cad_add_point(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'change_node_type.ui'))
class ChangeNodeType(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'config.ui'))
class ConfigUtils(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'csv2pg.ui'))
class Csv2Pg(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'doc_management.ui'))
class DocManagement(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'draw_profile.ui'))
class DrawProfile(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'element_management.ui'))
class ElementManagement(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'epa_result_compare_selector.ui'))
class EpaResultCompareSelector(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'epa_result_manager.ui'))
class EpaResultManager(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'event_full.ui'))
class EventFull(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'event_standard.ui'))
class EventStandard(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'event_ud_arc_rehabit.ui'))
class EventUDarcRehabit(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'event_ud_arc_standard.ui'))
class EventUDarcStandard(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'file_manager.ui'))
class FileManager(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'gallery.ui'))
class Gallery(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'gallery_zoom.ui'))
class GalleryZoom(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'hydrology_selector.ui'))
class HydrologySelector(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'info_show_info.ui'))
class InfoShowInfo(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'load_documents.ui'))
class LoadDocuments(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'load_profiles.ui'))
class LoadProfiles(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'mincut.ui'))
class Mincut(QtGui.QMainWindow, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'mincut_add_connec.ui'))
class Mincut_add_connec(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'mincut_add_hydrometer.ui'))
class Mincut_add_hydrometer(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'mincut_edit.ui'))
class Mincut_edit(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'mincut_fin.ui'))
class Mincut_fin(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'mincut_selector.ui'))
class Multi_selector(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'multiexpl_selector.ui'))
class Multiexpl_selector(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'multipsector_selector.ui'))
class Multipsector_selector(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'multirow_selector.ui'))
class Multirow_selector(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'node_replace.ui'))
class Node_replace(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'plan_estimate_result_manager.ui'))
class EstimateResultManager(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'plan_estimate_result_new.ui'))
class EstimateResultNew(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'plan_estimate_result_selector.ui'))
class EstimateResultSelector(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'plan_psector.ui'))
class Plan_psector(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'psector_management.ui'))
class Psector_management(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'psector_rapport.ui'))
class Psector_rapport(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'selector_date.ui'))
class SelectorDate(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'state_selector.ui'))
class State_selector(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'toolbox.ui'))
class Toolbox(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'ud_catalog.ui'))
class UDcatalog(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'ud_options.ui'))
class UDoptions(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'ud_times.ui'))
class UDtimes(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'visit_management.ui'))
class VisitManagement(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        super(VisitManagement, self).__init__()
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'workcat_end.ui'))
class WorkcatEnd(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'ws_additional_pump.ui'))
class AdditionalPump(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'ws_catalog.ui'))
class WScatalog(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'ws_options.ui'))
class WSoptions(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS, _ = uic.loadUiType(os.path.join(ui_path, 'ws_times.ui'))
class WStimes(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)

