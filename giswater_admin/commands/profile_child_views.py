"""Run gw_fct_admin_manage_child_views(MULTI-CREATE) with timing on an existing schema."""

from __future__ import annotations

import argparse

from ..engine.sql_runner import execute_function_call
from ..output import Out
from . import _helpers as h


def run(args: argparse.Namespace, out: Out) -> int:
    schema = args.schema
    target = h.safe_target_repr(args)
    if target:
        out.info(f"target: {target}")
    out.info(f"schema: {schema}")
    out.warn(
        "profile-child-views re-runs MULTI-CREATE on an existing schema; "
        "for create-path timings use: profile-create --kind ws --drop-if-exists"
    )
    out.info("action: MULTI-CREATE (profileTiming)")

    payload = {
        "client": {"device": 4, "infoType": 1, "lang": args.locale},
        "form": {},
        "feature": {},
        "data": {
            "filterFields": {},
            "pageInfo": {},
            "action": "MULTI-CREATE",
            "profileTiming": True,
        },
    }
    fn = f"{schema}.gw_fct_admin_manage_child_views"

    conn = h.open_conn(args, out)
    try:
        fx = execute_function_call(conn, fn, payload, commit=not args.dry_run, fetch_result=True)
        if args.dry_run:
            conn.rollback()
        elif fx.ok:
            conn.commit()
        else:
            conn.rollback()
    finally:
        conn.close()

    for step in fx.profile_steps:
        step_name = str(step.get("step", ""))
        prefix = h._profile_step_prefix(step_name)
        out.info(f"{prefix}: {step_name} +{step.get('ms')} ms")

    if not fx.profile_steps:
        out.warn(
            "no child_views_timing steps; reload gw_fct_admin_manage_child_views "
            "from dbmodel/schemas/network/common/fct/"
        )

    if args.json:
        out.result({"ok": fx.ok, "schema": schema, "profileSteps": fx.profile_steps})
        return 0 if fx.ok else 1

    if not fx.ok:
        out.error(fx.error or "function call failed")
    return 0 if fx.ok else 1
