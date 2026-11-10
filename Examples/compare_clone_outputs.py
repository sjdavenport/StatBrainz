"""Compare matlab_clone test outputs (Examples/example_output_clone) with the MATLAB
outputs (Examples/example_output), test by test. Writes Examples/example_output_clone/comparison.txt."""
import re
from pathlib import Path

TESTS = Path("/workspace/Examples")
REF = TESTS / "example_output"
NEW = TESTS / "example_output_clone"
NUM = re.compile(r"[-+]?(?:\d+\.?\d*|\.\d+)(?:[eE][-+]?\d+)?|NaN|-?Inf")


def clean(text):
    lines = []
    for line in text.splitlines():
        if line.startswith(("WARNING: package", "Warning:", "STATUS:", "ERROR:")):
            continue
        if re.match(r"\s*Columns \d+ through \d+|\s*Columns? \d+( and \d+)?$", line):
            continue
        lines.append(line.rstrip())
    return lines


def numbers(lines):
    out = []
    for line in lines:
        for tok in NUM.findall(line):
            out.append(float(tok.replace("Inf", "inf").replace("NaN", "nan")))
    return out


def close(a, b, tol=1e-3):
    if len(a) != len(b):
        return False
    for x, y in zip(a, b):
        if x != x and y != y:
            continue
        if abs(x - y) > tol * max(1.0, abs(x), abs(y)):
            return False
    return True


def status(text):
    if "STATUS: PASS" in text:
        return "OK"
    if "STATUS: FAIL" in text:
        return "FAIL"
    return "TIMEOUT/CRASH"


rows = []
for new in sorted(NEW.rglob("ex_*.txt")):
    rel = new.relative_to(NEW)
    ref = REF / rel
    ntext = new.read_text(errors="replace")
    ns = status(ntext)
    if not ref.exists():
        rows.append((str(rel), "-", ns, "no MATLAB reference"))
        continue
    rtext = ref.read_text(errors="replace")
    rs = status(rtext)
    if rs != "OK" or ns != "OK":
        rows.append((str(rel), rs, ns, ""))
        continue
    rl, nl = clean(rtext), clean(ntext)
    rn, nn = numbers(rl), numbers(nl)
    if [l.split() for l in rl if l.strip()] == [l.split() for l in nl if l.strip()]:
        verdict = "identical"
    elif close(rn, nn):
        verdict = "numbers match (format differs)"
    elif close(sorted(rn), sorted(nn)):
        verdict = "numbers match (order differs)"
    elif len(rn) == len(nn):
        verdict = f"values differ ({len(rn)} numbers)"
    else:
        verdict = f"output differs ({len(rn)} vs {len(nn)} numbers)"
    rows.append((str(rel), rs, ns, verdict))

with open(NEW / "comparison.txt", "w") as f:
    f.write("test | MATLAB | clone | comparison\n")
    for r in rows:
        f.write(" | ".join(r) + "\n")
print(open(NEW / "comparison.txt").read())
