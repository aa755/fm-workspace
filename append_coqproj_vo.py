#!/usr/bin/env python3

import os
import subprocess
import re

workspace_root = os.getcwd()
build_dir = os.path.join(workspace_root, "_build", "default")
coqproject_path = os.path.join(workspace_root, "_CoqProject")

seen = set()
if os.path.exists(coqproject_path):
    with open(coqproject_path) as f:
        for line in f:
            if line.strip().startswith(("-Q", "-R")):
                seen.add(line.strip())

def extract_qr_flags(file_v):
    try:
        result = subprocess.run(
            ["dune", "coq", "top", file_v, "--toplevel=echo"],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True
        )
        qr_matches = re.findall(r"-(Q|R) ([^ ]+) ([^ ]+)", result.stdout)
        flags = []
        for kind, path, name in qr_matches:
            # Normalize absolute paths to _build/default/...
            if path.startswith(workspace_root):
                rel_path = os.path.relpath(path, workspace_root)
                path = os.path.join("_build/default", os.path.relpath(rel_path, "_build/default"))
            flags.append(f"-Q {path} {name}")
        return flags
    except subprocess.CalledProcessError:
        return []

new_entries = []

# Traverse for .vo files
for dirpath, _, filenames in os.walk(build_dir):
    for filename in filenames:
        if not filename.endswith(".vo"):
            continue
        full_vo = os.path.join(dirpath, filename)
        rel_vo = os.path.relpath(full_vo, build_dir)
        v_file = os.path.splitext(rel_vo)[0] + ".v"
        if not os.path.exists(v_file):
            continue
        flags = extract_qr_flags(v_file)
        for flag in flags:
            if flag not in seen:
                seen.add(flag)
                new_entries.append(flag)
                print(f"[+] {v_file}: {flag}")

if new_entries:
    with open(coqproject_path, "a") as f:
        for entry in new_entries:
            f.write(entry + "\n")
    print(f"\n✅ Appended {len(new_entries)} new entries to _CoqProject.")
else:
    print("✅ No new -Q/-R flags found. _CoqProject is up to date.")
