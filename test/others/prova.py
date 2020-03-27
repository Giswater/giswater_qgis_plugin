from qgis.PyQt.QtWidgets import QApplication, QDialog

def test_long_computation(qtbot):
    app = Application()

    # Watch for the app.worker.finished signal, then start the worker.
    with qtbot.waitSignal(app.worker.finished, timeout=10000) as blocker:
        blocker.connect(app.worker.failed)  # Can add other signals to blocker
        app.worker.start()
        # Test will block at this point until either the "finished" or the
        # "failed" signal is emitted. If 10 seconds passed without a signal,
        # TimeoutError will be raised.

    assert_application_results(app)

def test_exit_button(qtbot, monkeypatch):
    exit_calls = []
    monkeypatch.setattr(QApplication, "exit", lambda: exit_calls.append(1))
    button = get_app_exit_button()
    qtbot.click(button)
    assert exit_calls == [1]
