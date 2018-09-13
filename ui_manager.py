# -*- coding: utf-8 -*-
from PyQt4 import QtGui, uic, QtCore
import os


def get_ui_class(ui_file_name):
    """ Get UI Python class from @ui_file_name """

    # Folder that contains UI files
    ui_folder_path = os.path.dirname(__file__) + os.sep + 'ui'
    ui_file_path = os.path.abspath(os.path.join(ui_folder_path, ui_file_name))
    return uic.loadUiType(ui_file_path)[0]


FORM_CLASS = get_ui_class('api_cf.ui')
class ApiCfUi(QtGui.QMainWindow, FORM_CLASS):
    dlg_closed = QtCore.pyqtSignal()
    def __init__(self):
        QtGui.QMainWindow.__init__(self)
        self.setupUi(self)

    def closeEvent(self, event):
        print('event: {0}'.format(event))
        self.dlg_closed.emit()
        return super(ApiCfUi, self).closeEvent(event)

FORM_CLASS = get_ui_class('api_config.ui')
class ApiConfigUi(QtGui.QMainWindow, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('api_search.ui')
class ApiSearchUi(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('add_doc.ui')
class AddDoc(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('add_element.ui')
class AddElement(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('add_picture.ui')
class AddPicture(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('add_sum.ui')
class AddSum(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)
        
        
FORM_CLASS = get_ui_class('add_visit.ui')
class AddVisit(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('arc_fusion.ui')
class ArcFusion(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('audit_check_project_result.ui')
class AuditCheckProjectResult(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('cad_add_circle.ui')
class Cad_add_circle(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)
        

FORM_CLASS = get_ui_class('cad_add_point.ui')
class Cad_add_point(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('change_node_type.ui')
class ChangeNodeType(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('csv2pg.ui')
class Csv2Pg(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('doc_management.ui')
class DocManagement(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('draw_profile.ui')
class DrawProfile(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('element_management.ui')
class ElementManagement(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('epa_result_compare_selector.ui')
class EpaResultCompareSelector(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('epa_result_manager.ui')
class EpaResultManager(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('event_full.ui')
class EventFull(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('event_standard.ui')
class EventStandard(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('event_ud_arc_rehabit.ui')
class EventUDarcRehabit(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('event_ud_arc_standard.ui')
class EventUDarcStandard(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('file_manager.ui')
class FileManager(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('gallery.ui')
class Gallery(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('gallery_zoom.ui')
class GalleryZoom(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('hydrology_selector.ui')
class HydrologySelector(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('info_show_info.ui')
class InfoShowInfo(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('load_documents.ui')
class LoadDocuments(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('load_profiles.ui')
class LoadProfiles(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('mincut.ui')
class Mincut(QtGui.QMainWindow, FORM_CLASS):
    def __init__(self):
        self.closeMainWin = True
        QtGui.QDialog.__init__(self)
        self.setupUi(self)

    def closeEvent(self, event):
        """ Overwrite closeEvent method """
        if self.closeMainWin:
            event.accept()
        else:
            # event.accept()
            QtGui.QMessageBox.information(self, "", "Press cancel to exit")
            event.ignore()


FORM_CLASS = get_ui_class('mincut_add_connec.ui')
class Mincut_add_connec(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('mincut_add_hydrometer.ui')
class Mincut_add_hydrometer(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('mincut_composer.ui')
class MincutComposer(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)        


FORM_CLASS = get_ui_class('mincut_edit.ui')
class Mincut_edit(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('mincut_fin.ui')
class Mincut_fin(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('mincut_selector.ui')
class Multi_selector(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('multirow_selector.ui')
class Multirow_selector(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)

FORM_CLASS = get_ui_class('new_workcat.ui')
class NewWorkcat(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('node_replace.ui')
class NodeReplace(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('plan_estimate_result_manager.ui')
class EstimateResultManager(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('plan_estimate_result_new.ui')
class EstimateResultNew(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('plan_estimate_result_selector.ui')
class EstimateResultSelector(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('plan_psector.ui')
class Plan_psector(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('psector_management.ui')
class Psector_management(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('psector_rapport.ui')
class Psector_rapport(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('selector_date.ui')
class SelectorDate(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('toolbox.ui')
class Toolbox(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('ud_catalog.ui')
class UDcatalog(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)

FORM_CLASS = get_ui_class('cf_ud_catalog.ui')
class CFUDcatalog(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)

FORM_CLASS = get_ui_class('ud_options.ui')
class UDoptions(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('ud_times.ui')
class UDtimes(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('visit_management.ui')
class VisitManagement(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        super(VisitManagement, self).__init__()
        self.setupUi(self)


FORM_CLASS = get_ui_class('workcat_end.ui')
class WorkcatEnd(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('ws_catalog.ui')
class WScatalog(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)

FORM_CLASS = get_ui_class('cf_ws_catalog.ui')
class CFWScatalog(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)

FORM_CLASS = get_ui_class('ws_options.ui')
class WSoptions(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('ws_times.ui')
class WStimes(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('workcat_end_list.ui')
class WorkcatEndList(QtGui.QDialog, FORM_CLASS):
    def __init__(self):
        QtGui.QDialog.__init__(self)
        self.setupUi(self)