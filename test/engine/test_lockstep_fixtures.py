"""Verify lockstep fixture folders exist in the dev dbmodel."""

from __future__ import annotations

from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
DBMODEL = REPO_ROOT / "dbmodel"


def test_lockstep_fixture_patches_exist():
    paths = [
        DBMODEL / "schemas/addon/utils/updates/4/16/0/patch.sql",
        DBMODEL / "schemas/addon/cibs/updates/4/16/0/patch.sql",
        DBMODEL / "schemas/main/common/updates/4/16/0/patch.sql",
        DBMODEL / "schemas/main/ws/updates/4/16/0/patch.sql",
        DBMODEL / "schemas/main/ud/updates/4/16/0/patch.sql",
    ]
    for path in paths:
        assert path.is_file(), f"missing fixture patch: {path}"
