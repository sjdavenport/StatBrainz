#!/bin/bash
# Runs every test_*.m in the matlab_clone engine, one process per script, in
# parallel with a hard timeout. Output mirrors Tests/test_output/ (the MATLAB
# run) into Tests/test_output_clone/ so the two can be compared file by file.

SB="/workspace"
CLONE="/mounts/matlab_clone/build-arm/matlab_clone"
OUT="$SB/Tests/test_output_clone"
TIMEOUT=300
PAR=12
mkdir -p "$OUT"
: > "$OUT/results.txt"

run_one() {
  local f="$1"
  local rel="${f#$SB/Tests/}"
  local outfile="$OUT/${rel%.m}.txt"
  mkdir -p "$(dirname "$outfile")"
  # Stay in the repo root: the clone keeps addpath('./...') entries relative.
  local start=$(date +%s)
  timeout -s KILL "$TIMEOUT" "$CLONE" -e "cd('$SB'); addSB2path; set(0, 'DefaultFigureVisible', 'off'); try, run('$f'); fprintf('\nSTATUS: PASS\n'); catch e, fprintf(2, '\nERROR: %s\n', e.message); fprintf('\nSTATUS: FAIL\n'); end" > "$outfile" 2>&1
  local rc=$?
  local secs=$(( $(date +%s) - start ))
  local status
  if [ $rc -eq 137 ]; then status="TIMEOUT"
  elif grep -q "STATUS: PASS" "$outfile"; then status="OK"
  elif grep -q "STATUS: FAIL" "$outfile"; then status="FAIL"
  else status="CRASH"; fi
  local msg=$(grep -m1 "^ERROR:" "$outfile" | sed 's/^ERROR: //')
  [ "$status" = "CRASH" ] && msg="exit code $rc: $(tail -1 "$outfile")"
  echo "$status | $rel | ${secs}s | $msg" >> "$OUT/results.txt"
}
export -f run_one
export SB CLONE OUT TIMEOUT

find "$SB/Tests" -name "test_*.m" -type f -not -path "*/test_output*" | sort | \
  xargs -d '\n' -P "$PAR" -I{} bash -c 'run_one "$@"' _ {}
sort -o "$OUT/results.txt" "$OUT/results.txt"
echo "DONE: $(grep -c '^OK' "$OUT/results.txt") OK of $(wc -l < "$OUT/results.txt")"
