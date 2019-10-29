
from time import sleep
from qgis.core import QgsTask, QgsApplication
from qgis.PyQt.QtCore import pyqtSignal, QObject
from .parent import ParentAction
import random
from time import sleep
from ..ui_manager import SelectorDate
from qgis.core import QgsApplication, QgsTask, QgsMessageLog, Qgis
MESSAGE_CATEGORY = 'Executing task'
class GwTask(QgsTask, QObject):
    """This shows how to subclass QgsTask"""
    fake_progress = pyqtSignal()
    def __init__(self, description, duration=0):
        QObject.__init__(self)
        super().__init__(description, QgsTask.CanCancel)
        self.exception = None
        self.duration = duration

    def set_max_progres(self):
        self.i = 100
    def run(self):
        """Here you implement your heavy lifting. This method should
        periodically test for isCancelled() to gracefully abort.
        This method MUST return True or False
        raising exceptions will crash QGIS so we handle them internally and
        raise them in self.finished
        """

        print(f"IN RUN")
        # dlg = SelectorDate()
        # dlg.open()

        QgsMessageLog.logMessage(f'Started task {self.description()}', MESSAGE_CATEGORY, Qgis.Info)
        if self.duration is 0:

            if self.isCanceled():
                print(f"IS CANCELED")
                return False
            if self.progress() >= 100:
                print(f"IS self.progress()")
                return True
            print(f"OUT RUN")
            return True
        else:
            print(f"TIMED")
            wait_time = self.duration / 100
            # self.fake_progress.connect(self.set_max_progres)
            sleep(wait_time)
            for i in range(100):
                sleep(wait_time)
                # use setProgress to report progress
                self.setProgress(i)

                # check isCanceled() to handle cancellation
                if self.isCanceled():
                    return False
                # simulate exceptions to show how to abort task
                # if random.randint(0, 500) == 42:
                #     # DO NOT raise Exception('bad value!')
                #     # this would crash QGIS
                #     self.exception = Exception('bad value!')
                #     return False
            return True

    def open_form(self):
        dlg =SelectorDate()
        dlg.open()

    def finished(self, result):
        """This method is automatically called when self.run returns. result
        is the return value from self.run.
        This function is automatically called when the task has completed (
        successfully or otherwise). You just implement finished() to do whatever
        follow up stuff should happen after the task is complete. finished is
        always called from the main thread, so it's safe to do GUI
        operations and raise Python exceptions here.
        """
        print(f" IN FINISHED")
        if result:
            print(f" IF RESULT")
            QgsMessageLog.logMessage(f'Task "{self.description()}" completed', MESSAGE_CATEGORY, Qgis.Success)
        else:
            print(f"ELSE RESULT")
            if self.exception is None:
                print(f"EXCEPTION IS NONE")
                QgsMessageLog.logMessage(f'Task "{self.description()}" not successful but without exception ',
                                         MESSAGE_CATEGORY, Qgis.Warning)
            else:
                print(f"EXCEPTION IS NOT NONE")
                QgsMessageLog.logMessage(f'Task "{self.description()}" Exception: {self.exception}',
                                         MESSAGE_CATEGORY, Qgis.Critical)
                raise self.exception


    def cancel(self):
        print(f"IN CANCEL")
        QgsMessageLog.logMessage(f'Task "{self.description()}" was cancelled', MESSAGE_CATEGORY, Qgis.Info)
        super().cancel()
