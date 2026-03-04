import ast
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]

TASK_BASE_NAMES = {"GwTask", "QgsTask"}
EXECUTE_FUNCS = {"get_row", "get_rows", "execute_sql", "execute_returning", "execute_procedure", "check_function"}


def is_task_class(node: ast.ClassDef) -> bool:
    for base in node.bases:
        # class Foo(GwTask):  -> Name
        if isinstance(base, ast.Name) and base.id in TASK_BASE_NAMES:
            return True
        # class Foo(core.threads.task.GwTask): or similar -> Attribute chain
        if isinstance(base, ast.Attribute):
            cur = base
            while isinstance(cur, ast.Attribute):
                if cur.attr in TASK_BASE_NAMES:
                    return True
                cur = cur.value
            if isinstance(cur, ast.Name) and cur.id in TASK_BASE_NAMES:
                return True
    return False


def is_execute_procedure_call(call: ast.Call) -> bool:
    func = call.func
    if isinstance(func, ast.Name):
        return func.id in EXECUTE_FUNCS
    if isinstance(func, ast.Attribute):
        return func.attr in EXECUTE_FUNCS
    return False


def has_is_thread_true(call: ast.Call) -> bool:
    for kw in call.keywords:
        if kw.arg == "is_thread":
            # Python 3.8+ Constant; older NameConstant; be conservative
            if isinstance(kw.value, ast.Constant) and kw.value.value is True:
                return True
            # if you want to allow a symbol like `IS_THREAD`, extend this
            return False
    return False


def iter_python_files():
    """
    Yield all Python files under the repository root.

    We intentionally scan the whole repo so any GwTask/QgsTask subclass,
    regardless of package or path, gets checked.
    """
    for path in REPO_ROOT.rglob("*.py"):
        yield path


def main() -> int:
    violations = []

    for path in iter_python_files():
        try:
            source = path.read_text(encoding="utf-8")
        except Exception as e:
            print(f"WARNING: cannot read {path}: {e}", file=sys.stderr)
            continue

        try:
            tree = ast.parse(source, filename=str(path))
        except SyntaxError as e:
            print(f"WARNING: cannot parse {path}: {e}", file=sys.stderr)
            continue

        # map lineno -> source line for nicer messages
        lines = source.splitlines()

        for node in tree.body:
            if not isinstance(node, ast.ClassDef):
                continue
            if not is_task_class(node):
                continue

            class_name = node.name

            for item in node.body:
                if not isinstance(item, (ast.FunctionDef, ast.AsyncFunctionDef)):
                    continue
                func_name = item.name

                for sub in ast.walk(item):
                    if not isinstance(sub, ast.Call):
                        continue
                    if not is_execute_procedure_call(sub):
                        continue
                    if has_is_thread_true(sub):
                        continue

                    lineno = sub.lineno
                    line = lines[lineno - 1].strip() if 0 < lineno <= len(lines) else ""
                    violations.append(
                        f"{path}:{lineno} in {class_name}.{func_name} "
                        f"calls execute_procedure without is_thread=True\n    {line}"
                    )

    if violations:
        print("Found forbidden DB calls in task classes (missing is_thread=True):")
        print("\n".join(violations))
        return 1

    print("OK: all GwTask/QgsTask DB calls use is_thread=True")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
