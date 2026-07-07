#!/bin/bash
# Runs every test_*.m in its own MATLAB process with a hard timeout, in parallel.
# A hung script (e.g. a blocking figure) is killed after TIMEOUT and recorded.

SB="/Users/samd/Documents/Code/Packages/Matlab/StatBrainz"
MATLAB="/Applications/MATLAB_R2024b.app/bin/matlab"
OUT="$SB/Tests/test_output"
TIMEOUT=100          # seconds per script
PAR=5                # parallel jobs
mkdir -p "$OUT/logs"
: > "$OUT/results.txt"

run_one() {
  local f="$1"
  local rel="${f#$SB/}"
  local safe=$(echo "$rel" | tr '/ ' '__')
  local log="$OUT/logs/$safe.log"
  local name=$(basename "$f" .m)

  # launch matlab in background, watchdog-kill on timeout
  "$MATLAB" -nodisplay -batch "addpath('$SB/Tests'); run_one_test('$f')" > "$log" 2>&1 &
  local pid=$!
  local waited=0
  while kill -0 "$pid" 2>/dev/null; do
    sleep 2; waited=$((waited+2))
    if [ "$waited" -ge "$TIMEOUT" ]; then
      kill -9 "$pid" 2>/dev/null
      pkill -9 -P "$pid" 2>/dev/null
      echo "TIMEOUT | $rel |" >> "$OUT/results.txt"
      echo "  [TIMEOUT] $rel"
      return
    fi
  done
  local res=$(grep "###RESULT###" "$log" | sed 's/###RESULT### //')
  if [ -z "$res" ]; then
    res="CRASH | $rel | (no result line; matlab exited unexpectedly)"
  fi
  echo "$res" >> "$OUT/results.txt"
  echo "  $res"
}
export -f run_one
export SB MATLAB OUT TIMEOUT

# collect files (bash 3.2 compatible)
FILES=()
while IFS= read -r line; do FILES+=("$line"); done < <(find "$SB/Tests" -name "test_*.m" -type f | sort)
echo "Running ${#FILES[@]} test scripts (timeout ${TIMEOUT}s, ${PAR} parallel)..."

# simple parallelism
i=0
for f in "${FILES[@]}"; do
  run_one "$f" &
  i=$((i+1))
  if [ $((i % PAR)) -eq 0 ]; then wait; fi
done
wait
echo "DONE_DRIVER"
