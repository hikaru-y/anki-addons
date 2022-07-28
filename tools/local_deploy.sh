# NOTE: This script is still a WIP.

export MSYS=winsymlinks:nativestrict

# --- begin runfiles.bash initialization v2 ---
# Copy-pasted from the Bazel Bash runfiles library v2.
set -uo pipefail
f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null ||
    source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null ||
    source "$0.runfiles/$f" 2>/dev/null ||
    source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null ||
    source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null ||
    {
        echo >&2 "ERROR: cannot find $f"
        exit 1
    }
f=
set -e
# --- end runfiles.bash initialization v2 ---

# TODO: find out how to get the workspace name programmatically
runtime_location=$(rlocation "anki_addons/$1")

runtime_dir=$(dirname "$runtime_location")
package=$(basename "$runtime_location" ".ankiaddon")

# TODO: allow to specify the `addons21` directory via `.bazelrc.user` or something
addons21_dir="/d/_anki/addons21"

cd "$runtime_dir"
rm -rfv "$package"
unzip -o "$runtime_location" -d "$package"
ln -snf "${runtime_dir}/${package}" "${addons21_dir}/${package}"
