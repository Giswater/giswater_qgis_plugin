"""Profile gw_fct_admin_manage_child_config for one child view."""

from __future__ import annotations

import argparse

from ..engine.sql_runner import execute_function_call
from ..log_format import format_profile_step
from ..output import Out
from . import _helpers as h


def run(args: argparse.Namespace, out: Out) -> int:
    schema = args.schema
    cat = args.cat_feature

    target = h.safe_target_repr(args)
    if target:
        out.info(f"target: {target}")
    out.info(f"schema: {schema}")
    out.info(f"cat_feature: {cat}")

    conn = h.open_conn(args, out)
    try:
        view_name, feature_type = _resolve_view(conn, schema, cat, args.feature_type)
        out.info(f"view_name: {view_name} feature_type: {feature_type}")

        payload = {
            "profileTiming": True,
            "feature": {"catFeature": cat},
            "data": {
                "view_name": view_name,
                "feature_type": feature_type,
            },
        }
        fn = f"{schema}.gw_fct_admin_manage_child_config"
        fx = execute_function_call(
            conn, fn, payload, commit=not args.dry_run, fetch_result=True
        )
        if args.dry_run:
            conn.rollback()
        elif fx.ok:
            conn.commit()
        else:
            conn.rollback()
    finally:
        conn.close()

    for step in fx.profile_steps:
        out.info(
            format_profile_step(
                str(step.get("step", "")),
                int(step.get("ms") or 0),
                style=out.style,
            )
        )

    if not fx.profile_steps:
        out.warn(
            "no child_config_timing steps; reload gw_fct_admin_manage_child_config "
            "from dbmodel/schemas/network/common/fct/"
        )

    if args.json:
        out.result({"ok": fx.ok, "schema": schema, "cat_feature": cat, "profileSteps": fx.profile_steps})
        return 0 if fx.ok else 1

    if not fx.ok:
        out.error(fx.error or "function call failed")
    return 0 if fx.ok else 1


def _resolve_view(conn, schema: str, cat: str, feature_type: str | None) -> tuple[str, str]:
    sql = (
        f'SELECT child_layer, lower(feature_type) '
        f'FROM "{schema}".cat_feature WHERE id = %s'
    )
    with conn.raw.cursor() as cur:  # type: ignore[attr-defined]
        cur.execute(sql, (cat,))
        row = cur.fetchone()
        if not row:
            raise RuntimeError(f"cat_feature '{cat}' not found in schema '{schema}'")
        view_name, ft = row[0], row[1]
        if not view_name:
            ft = feature_type or ft or "node"
            view_name = f"ve_{ft}_{cat.lower()}"
        if feature_type:
            ft = feature_type.lower()
        return view_name, ft
