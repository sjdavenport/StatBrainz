#!/bin/zsh
# Run every test_*.m under Tests/ in its own MATLAB process, capturing each
# test's combined stdout+stderr into Tests/test_output/<mirrored path>.txt
# A trailing STATUS: PASS/FAIL line is appended per test.

set -u
ROOT="/Users/samd/Documents/Code/Packages/Matlab/StatBrainz"
TESTS="$ROOT/Tests"
OUTDIR="$TESTS/test_output"
MATLAB="/Applications/MATLAB_R2024b.app/bin/matlab"
TIMEOUT=60

mkdir -p "$OUTDIR"

# Collect all test files
tests=("${(@f)$(find "$TESTS" -name 'test_*.m' -not -path "$OUTDIR/*" | sort)}")

pass=0; fail=0
for tf in $tests; do
    rel="${tf#$TESTS/}"            # path relative to Tests/
    name="${${rel:t}:r}"          # function name without dir or .m
    outrel="${rel:r}.txt"         # mirror path, .txt extension
    outfile="$OUTDIR/$outrel"
    mkdir -p "${outfile:h}"
    testdir="${tf:h}"

    echo "RUN $rel"
    # cd to repo root so addSB2path works; then cd to test dir and run the test.
    /usr/bin/perl -e 'alarm shift; exec @ARGV' $TIMEOUT \
        "$MATLAB" -nodisplay -batch \
        "cd('$ROOT'); addSB2path; cd('$testdir'); try, run('$tf'); fprintf('\nSTATUS: PASS\n'); catch e, fprintf(2,'\nERROR: %s\n', getReport(e)); fprintf('\nSTATUS: FAIL\n'); end" \
        > "$outfile" 2>&1
    rc=$?
    if [[ $rc -eq 142 || $rc -eq 14 ]]; then
        echo "\nSTATUS: TIMEOUT (${TIMEOUT}s)" >> "$outfile"
    fi

    if grep -q "STATUS: PASS" "$outfile"; then
        pass=$((pass+1))
    else
        fail=$((fail+1))
    fi
done

echo "DONE: $pass passed, $fail failed/timeout (of ${#tests} tests)"
