#!/usr/bin/env bash
set -Eeuo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
env_file="${SHOWCASE_ENV_FILE:-/tmp/showcase-e2e.env}"

[[ -f "$env_file" ]] || {
  echo "Missing runtime credential file: $env_file" >&2
  echo "Run scripts/setup_runtime_env.sh first." >&2
  exit 64
}

set -a
# shellcheck disable=SC1090
source "$env_file"
set +a

ruby "$root/scripts/run_people_animals.rb"

python3 - "$root" <<'PY'
from pathlib import Path
from PIL import Image, ImageEnhance
import sys

root = Path(sys.argv[1])
pairs = [
    ("dog", root / "assets/input/dog-puppy-white-cc0-1280.jpg"),
    ("horse", root / "assets/input/horse-white-cc0-1280.jpg"),
]
for name, source_path in pairs:
    source = Image.open(source_path).convert("RGB")
    for prompt in ("point", "box"):
        mask_path = root / f"assets/output/{name}-{prompt}-mask.png"
        mask = Image.open(mask_path).convert("L").resize(source.size)
        dimmed = ImageEnhance.Brightness(ImageEnhance.Color(source).enhance(0.22)).enhance(0.32)
        preview = Image.composite(source, dimmed, mask)
        out = root / f"assets/output/{name}-{prompt}-selection.webp"
        preview.save(out, "WEBP", quality=92, method=6)
        print(f"{out.name}=PASS bytes={out.stat().st_size}")
PY

ruby "$root/scripts/install_people_animals.rb"

echo "People/animal showcase outputs installed into site/."
