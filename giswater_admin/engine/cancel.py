"""
Cooperative cancellation token. Engine checks ``token.cancelled`` between
files; the QGIS task adapter flips it from ``QgsTask.isCanceled()``.

Keeping this as a plain object (no threading primitives) avoids dragging
in stdlib threading for a use-case that's purely cooperative.
"""

from __future__ import annotations

from dataclasses import dataclass


@dataclass
class CancelToken:
    cancelled: bool = False

    def cancel(self) -> None:
        self.cancelled = True

    def reset(self) -> None:
        self.cancelled = False
