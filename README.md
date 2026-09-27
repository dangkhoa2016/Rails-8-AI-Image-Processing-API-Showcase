# Rails 8 AI Image Processing API — Visual Showcase

A static, bilingual visual showcase for the
[Rails-8-AI-Image-Processing-API](https://github.com/dangkhoa2016/Rails-8-AI-Image-Processing-API).

The page presents real outputs produced by the API, including BiRefNet background
removal, MobileSAM prompt-based segmentation, and deterministic libvips image
processing. It is a visual demonstration, not a model-quality benchmark.

## What this repository is for

This repository answers a simple question: **what can the API do?**

It contains:

- before/after background-removal examples;
- transparent PNG and neutral-background composites;
- MobileSAM point and box selection examples;
- human, dog, cat, and horse segmentation examples;
- deterministic processing examples for resize, contrast, saturation, tint,
  and sharpening;
- reproducible curl examples shown directly in the page;
- English and Vietnamese UI;
- SHA-256 integrity metadata for public site assets.

For black-box API verification, reproducible reports, and integrity evidence,
see the separate
[public verification repository](https://github.com/dangkhoa2016/Rails-8-AI-Image-Processing-API-Community-Acceptance-Kit).

## Local preview

No Rails server, GPU, or model runtime is required to view the showcase.

    cd site
    python3 -m http.server 8080

Then open http://127.0.0.1:8080.

## Reproducing API outputs

The scripts in scripts/ are optional helpers for regenerating selected
showcase outputs from a running deployment.

Runtime credentials are intentionally not stored in this repository.

    ./scripts/setup_runtime_env.sh
    ./scripts/run_people_animals.sh
    rm -f /tmp/showcase-e2e.env

The generated requests use the JWT returned by the deployment's normal sign-in
flow. Never commit deployment URLs, passwords, JWTs, refresh tokens, cookies,
or other secrets.

## Provenance and integrity

Source-image provenance is recorded in assets/provenance.json.

The public site asset manifest is site/SHA256SUMS. The current speaker and hat
examples use CC0 1.0 Wikimedia Commons source images. Other source and project
release bindings are documented in the provenance file.

## Repository roles

- **Main API repository** — application source and API implementation.
- **Visual Showcase** — human-friendly real-output demonstrations.
- **Public verification repository** — reproducible black-box tests, reports,
  evidence, and hashes.

Keeping these roles separate makes the public project easier to navigate:
visual explanation here, implementation in the main repository, and formal
verification in the verification repository.

## License

Repository code and documentation are released under the MIT License.

Third-party/public-domain/CC0 assets retain their own provenance and licensing
as documented in assets/provenance.json.
