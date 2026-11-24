**Pictures inside SVG drawings now follow the same local-file rules as every other picture. A security fix: update if you convert HTML you do not control.**

- A picture named inside an SVG drawing, by `<image>` or `<feImage>`, is read only where the page may read files, as an `<img>` is: never while local files are blocked (the default), only inside the `--allow` folders, anywhere with `--enable-local-file-access`. Before, such a picture was read from any file on the computer, so a page could copy a picture from the server's disk into its PDF.
- A picture blocked this way is reported as wkhtmltopdf reports it ("Blocked access to file …"), and the run ends with code 1, as with wkhtmltopdf. One named with a plain `href`, which wkhtmltopdf never loads, is left out without a message.
- An SVG file shown as a picture (`<img src="logo.svg">`, a background) shows only the pictures it carries in itself (`data:`): as with wkhtmltopdf, nothing it names is read or fetched.
- Pictures from the web inside a page's drawings now print, as with wkhtmltopdf.

Every file below was built by this repository's release workflow on GitHub's own machines, with build provenance and a software bill of materials (SBOM). Check a file before you run it:

```
gh attestation verify marqius-wkhtmltopdf-linux-x86_64 -R marqiushq/marqius-wkhtmltopdf
```

Check a Docker image with:

```
gh attestation verify oci://marqius/wkhtmltopdf:0.12.17 -R marqiushq/marqius-wkhtmltopdf
```
