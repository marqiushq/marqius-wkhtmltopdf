**Missing fonts, a check of the computer, and updates: one command each.**

- When a page has letters no installed font has, such as Japanese, Hindi or emoji, the message names the free fonts that have them and gives one command that downloads them to where conversions look: `marqius-wkhtmltopdf fonts get "Noto Sans JP"`. In our Docker images it gives the `docker run` line that keeps them in a volume.
- `marqius-wkhtmltopdf --diagnose` checks this computer: it converts test pages, then looks at the fonts, the licence, the PATH and the internet (and, in a container, Docker), and gives the command to run next for anything to fix. Add `--json` for scripts.
- `marqius-wkhtmltopdf update` brings the newest version the way it was installed. A download is checked against the release's checksums and its GitHub build record before it replaces the program, and the version before is kept. `update --check` only says whether a newer one is out. Coming from 0.12.13 or earlier, which have no `update`, install 0.12.14 once with the install line you used.
- On Windows, stylesheets and pictures linked by a relative path, by a `file:///` address or over HTTP now load. As with wkhtmltopdf 0.12.6, files on disk need `--enable-local-file-access`.
- A website with an address that does not answer no longer holds up a conversion: its other addresses are tried at once.
- The Saudi riyal sign (U+20C1) prints.

Every file below was built by this repository's release workflow on GitHub's own machines, with build provenance and a software bill of materials (SBOM). Check a file before you run it:

```
gh attestation verify marqius-wkhtmltopdf-linux-x86_64 -R marqiushq/marqius-wkhtmltopdf
```

Check a Docker image with:

```
gh attestation verify oci://marqius/wkhtmltopdf:0.12.14 -R marqiushq/marqius-wkhtmltopdf
```
