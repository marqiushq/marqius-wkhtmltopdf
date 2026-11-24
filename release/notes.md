**On Windows, text now prints at the size wkhtmltopdf prints it there.**

- wkhtmltopdf on Windows, and the libwkhtmltox inside DinkToPdf, print text bigger than on Linux: Arial at 12pt comes out at 10.8pt on an A4 page, where Linux prints 9.6pt. On Windows, marqius-wkhtmltopdf now does the same by default, with each letter as wide and each line as tall as there, so lines and pages break where they did. Before, it printed Linux's sizes on Windows. Linux and macOS output does not change.
- On Windows, `--dpi` now counts, as it does for wkhtmltopdf there.
- One size on every system, when you want it: `--marqius-text-size linux` keeps Linux's sizes on Windows, and `--marqius-text-size windows` gives Windows' sizes on Linux and macOS. Apps that cannot add an option (DinkToPdf, Rotativa) can set `MARQIUS_TEXT_SIZE=linux` or `windows` instead.

Every file below was built by this repository's release workflow on GitHub's own machines, with build provenance and a software bill of materials (SBOM). Check a file before you run it:

```
gh attestation verify marqius-wkhtmltopdf-linux-x86_64 -R marqiushq/marqius-wkhtmltopdf
```

Check a Docker image with:

```
gh attestation verify oci://marqius/wkhtmltopdf:0.12.16 -R marqiushq/marqius-wkhtmltopdf
```
