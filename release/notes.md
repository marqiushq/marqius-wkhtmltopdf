**Hidden parts of a page, and pages printed with `--no-images`, now come out as they do with wkhtmltopdf.**

- An element set to `visibility: hidden` prints nothing at all: no picture, background, border, underline, form field or list marker. Before, only its text was hidden. It still takes its room, so nothing moves, and anything inside it set to `visibility: visible` still prints.
- `--no-images` fetches no picture and prints none, in PDFs and in pictures: `<img>`, picture buttons, `<object>` and `<embed>`, `data:` pictures, background pictures and the pictures a drawing names. Before, any picture that could load was downloaded and printed. Each picture keeps the room its width and height give it, with its own border and background around it. Header and footer pages, and `--checkbox-svg` pictures, keep theirs, as with wkhtmltopdf.
- A picture button (`<input type="image">`) is as big as its width and height say.

Every file below was built by this repository's release workflow on GitHub's own machines, with build provenance and a software bill of materials (SBOM). Check a file before you run it:

```
gh attestation verify marqius-wkhtmltopdf-linux-x86_64 -R marqiushq/marqius-wkhtmltopdf
```

Check a Docker image with:

```
gh attestation verify oci://marqius/wkhtmltopdf:0.12.15 -R marqiushq/marqius-wkhtmltopdf
```
