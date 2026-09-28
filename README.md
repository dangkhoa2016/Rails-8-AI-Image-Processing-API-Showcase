# Rails 8 AI Image Processing API — Visual Showcase

<p align="center">
  <a href="https://github.com/dangkhoa2016/Rails-8-AI-Image-Processing-API-Showcase/releases"><img alt="Release" src="https://img.shields.io/github/v/release/dangkhoa2016/Rails-8-AI-Image-Processing-API-Showcase?sort=semver"></a>
  <a href="./LICENSE"><img alt="License" src="https://img.shields.io/github/license/dangkhoa2016/Rails-8-AI-Image-Processing-API-Showcase"></a>
  <img alt="Rails 8 API" src="https://img.shields.io/badge/API-Rails%208-CC0000?logo=rubyonrails&logoColor=white">
  <img alt="Static showcase" src="https://img.shields.io/badge/showcase-static-2ea44f">
  <img alt="Bilingual documentation" src="https://img.shields.io/badge/docs-English%20%7C%20Ti%E1%BA%BFng%20Vi%E1%BB%87t-blue">
</p>

> Language: **English** | [Tiếng Việt](README.vi.md)

A static, bilingual visual companion for
[Rails-8-AI-Image-Processing-API](https://github.com/dangkhoa2016/Rails-8-AI-Image-Processing-API).

This repository presents **real API outputs** in a human-friendly page: BiRefNet
background removal, MobileSAM prompt-based segmentation, and deterministic
libvips image processing. It is a visual demonstration of API behavior, **not a
model-quality benchmark** and not the Rails API server itself.

## What you can see

The showcase includes:

- before/after background-removal comparisons;
- transparent PNG cutouts and neutral-background composites;
- BiRefNet examples for people and multiple object shapes;
- MobileSAM point-prompt and box-prompt segmentation;
- people, dog, cat, and horse selection examples;
- deterministic resize, crop, contrast, saturation, tint, sharpening, and WebP examples;
- code snippets with deployment URL and authentication-token placeholders;
- English and Vietnamese UI;
- source-image provenance and SHA-256 integrity metadata.

The public page lives in <code>site/</code>.

## Project family

| Repository | Purpose |
| --- | --- |
| [Rails-8-AI-Image-Processing-API](https://github.com/dangkhoa2016/Rails-8-AI-Image-Processing-API) | Rails 8 application source, authentication, API endpoints, and AI/image-processing integration |
| **This repository** | Human-friendly visual examples generated from real API responses |
| [Community Acceptance Kit](https://github.com/dangkhoa2016/Rails-8-AI-Image-Processing-API-Community-Acceptance-Kit) | Reproducible black-box verification, reports, evidence, and integrity checks |

Keeping these roles separate makes the project easier to understand: implementation
in the API repository, visual explanation here, and formal public verification in
the acceptance kit.

## Deployment targets

This showcase is designed to be published as **static HTML**. The intended public
hosting layout is:

- **Cloudflare Pages** — canonical static deployment of the contents of <code>site/</code>.
- **Hugging Face Spaces (Static HTML)** — static mirror of the same reviewed showcase.
- **GitHub Pages** — **not an active deployment target for this project**.

A GitHub Pages deployment was tested earlier, but it conflicted with the account's
existing custom-domain routing. The Pages branch was removed and the project moved
forward with Cloudflare Pages plus a Hugging Face Static HTML mirror instead.

No permanent Cloudflare Pages or Hugging Face Space public URL is documented here
until that deployment is actually created and verified.

## Repository layout

| Path | Description |
| --- | --- |
| <code>site/index.html</code> | Static bilingual showcase UI |
| <code>site/assets/</code> | Public assets used by the static page |
| <code>site/SHA256SUMS</code> | SHA-256 manifest for the public site assets |
| <code>assets/input/</code> | Source and runtime-sized input images |
| <code>assets/output/</code> | Outputs produced from API calls or deterministic post-processing |
| <code>assets/provenance.json</code> | Source URL, license, description, and hash bindings for documented inputs |
| <code>scripts/setup_runtime_env.sh</code> | Secure interactive helper for creating the temporary runtime credential file |
| <code>scripts/run_people_animals.sh</code> | Regenerates selected people/animal examples and installs them into the site |
| <code>.env.example</code> | Placeholder-only reference for the runtime environment variables |

## Quick start: view the showcase locally

You do **not** need the Rails app, a GPU, BiRefNet, MobileSAM, or any model runtime
just to view the repository.

Requirements:

- Git
- Python 3, only to serve the static files

Clone and serve the site:

~~~bash
git clone https://github.com/dangkhoa2016/Rails-8-AI-Image-Processing-API-Showcase.git
cd Rails-8-AI-Image-Processing-API-Showcase/site
python3 -m http.server 8080
~~~

Open:

~~~text
http://127.0.0.1:8080
~~~

If your system exposes Python as <code>python</code> instead of
<code>python3</code>, use that command instead.

## Regenerating selected API outputs

This is optional. Use it only when you want to reproduce selected people/animal
showcase assets from a running API deployment.

### Requirements

You need:

- a reachable deployment of Rails-8-AI-Image-Processing-API;
- a valid test account for that deployment;
- Ruby with the standard library used by the scripts;
- Python 3;
- Pillow for the local selection-preview post-processing.

The AI inference happens in the API deployment. The machine running this showcase
helper does not need its own GPU if the remote deployment already provides the
required AI runtime.

### Runtime environment variables

The scripts expect exactly these values:

| Variable | Meaning |
| --- | --- |
| <code>BASE_URL</code> | Base URL of the running Rails API deployment, without a required trailing slash |
| <code>E2E_EMAIL</code> | Email address of the test account |
| <code>E2E_PASSWORD</code> | Password of the test account |

[.env.example](./.env.example) documents the schema with placeholders only.

### Recommended credential setup

Use the interactive helper:

~~~bash
./scripts/setup_runtime_env.sh
~~~

It prompts for the deployment URL, test email, and password, then writes a
shell-safe credential file to:

~~~text
/tmp/showcase-e2e.env
~~~

The helper creates the file with mode <code>600</code>. The password is entered
silently.

Then run:

~~~bash
./scripts/run_people_animals.sh
~~~

When you are finished:

~~~bash
rm -f /tmp/showcase-e2e.env
~~~

### Using .env.example manually

The example file is intentionally safe to commit. It contains no real credentials.

~~~bash
cp .env.example /tmp/showcase-e2e.env
chmod 600 /tmp/showcase-e2e.env
vi /tmp/showcase-e2e.env
SHOWCASE_ENV_FILE=/tmp/showcase-e2e.env ./scripts/run_people_animals.sh
rm -f /tmp/showcase-e2e.env
~~~

If you edit the file manually, keep it valid shell syntax. For passwords containing
shell-special characters, the interactive setup helper is safer because it writes
shell-escaped values automatically.

## What the regeneration helper does

The current people/animals workflow is intentionally scoped. It does **not**
regenerate every visual on the page.

The runner:

1. calls <code>POST /users/sign_in</code> and extracts the JWT returned by the normal sign-in flow;
2. calls <code>POST /images/remove-background</code> for transparent and neutral-background person outputs;
3. calls <code>POST /images/segment</code> for person, dog, and horse point/box masks;
4. uses Pillow locally to create dog/horse selection-preview WebP images from the masks;
5. copies the selected generated assets into <code>site/assets/</code>;
6. refreshes <code>site/SHA256SUMS</code>.

The static page also contains other curated examples, including object/background
removal and deterministic image transforms, which are maintained separately from
this focused helper.

## API endpoints used by the helper

| Endpoint | Purpose |
| --- | --- |
| <code>POST /users/sign_in</code> | Authenticate the test account and obtain a JWT |
| <code>POST /images/remove-background</code> | Generate BiRefNet background-removal outputs |
| <code>POST /images/segment</code> | Generate MobileSAM point/box segmentation masks |

The page itself also contains copyable curl examples that use placeholders rather
than embedded deployment credentials.

## Provenance and integrity

Source-image provenance is recorded in
[assets/provenance.json](./assets/provenance.json). Publicly sourced images keep
their documented license/provenance information; CC0 examples remain identified as
CC0 rather than being relicensed by this repository.

The public site asset manifest is [site/SHA256SUMS](./site/SHA256SUMS). From the
<code>site/</code> directory, verify the published assets with:

~~~bash
sha256sum -c SHA256SUMS
~~~

The manifest is useful for detecting accidental asset changes and for binding the
showcase page to the files that were reviewed.

## Security rules

Never commit or publish:

- real deployment passwords;
- JWTs or refresh tokens;
- cookies or session material;
- SMTP/API credentials;
- GitHub tokens;
- private deployment configuration.

The repository ignores local <code>.env</code>/<code>.env.*</code> files while
explicitly allowing the placeholder-only <code>.env.example</code>.

For reproducible runs, prefer a short-lived credential file under <code>/tmp</code>,
keep it mode <code>600</code>, and delete it immediately after the run.

## Updating the showcase safely

A typical content update should follow this sequence:

1. choose a source asset with clear provenance and redistribution terms;
2. record or update the source metadata in <code>assets/provenance.json</code>;
3. generate the intended output through the real API when the example is meant to represent an API response;
4. inspect the result visually;
5. install the reviewed asset into <code>site/assets/</code>;
6. refresh <code>site/SHA256SUMS</code>;
7. preview <code>site/</code> locally and verify all referenced assets;
8. keep English and Vietnamese public copy synchronized;
9. avoid describing visual examples as model-quality benchmarks.

## Releases and main

The initial public release is
[v1.0.0](https://github.com/dangkhoa2016/Rails-8-AI-Image-Processing-API-Showcase/releases/tag/v1.0.0).

Tagged releases are historical snapshots. The <code>main</code> branch may contain
newer visual or documentation improvements after a release while the existing
release tag remains unchanged.

## License

Repository code and documentation are released under the
[MIT License](./LICENSE).

Third-party, public-domain, and CC0 assets retain their own provenance and licensing
as documented in [assets/provenance.json](./assets/provenance.json).
