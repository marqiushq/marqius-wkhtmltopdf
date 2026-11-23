# marqius-wkhtmltopdf: the maintained wkhtmltopdf replacement

**Turn HTML into PDF with the command your app already uses.** marqius-wkhtmltopdf is a drop-in replacement for wkhtmltopdf: the same command, the same options, the same HTML templates. Your code does not change. It prints Arabic, Hebrew, Hindi, Thai, Chinese, Japanese and Korean as well as English.

[Install](#install-in-one-minute) · [Your first PDF](#make-your-first-pdf) · [Languages](#print-arabic-chinese-hindi-and-more) · [Your library](#switch-your-library-in-one-step) · [The proof](#dont-take-our-word-for-it) · [Price](#price) · [Questions](#questions-developers-ask)

## Why this matters

wkhtmltopdf is how a great many apps make their invoices, receipts, reports and labels. Three things have changed:

- **It is no longer maintained.** Its project was [archived on 2 January 2023](https://github.com/wkhtmltopdf/wkhtmltopdf). Its last release came out in 2020, and nobody fixes its bugs or security holes.
- **New systems no longer include it.** Debian 13 and Ubuntu 26.04 have no wkhtmltopdf package, so `apt install wkhtmltopdf` fails there.
- **It is built on an old browser engine.** It needs Qt WebKit and its libraries, which no longer receive updates.

So the day your servers move to a new system, your PDFs stop. marqius-wkhtmltopdf keeps them working, and you keep your code.

| | wkhtmltopdf 0.12.6 | marqius-wkhtmltopdf |
|---|---|---|
| Maintained | No, archived in 2023 | Yes, with regular releases |
| Installs on Debian 13 and Ubuntu 26.04 | No | Yes: apt, dnf, apk, Homebrew, Docker, RubyGems |
| What you install | The program, Qt and its libraries | One program file |
| Needs an X server or Xvfb | Sometimes | Never |
| Your commands and options | | The same |
| Arabic, Hebrew, Chinese, Hindi and Thai text you can search and copy | Often broken | Yes |
| Time for the 86 public test documents | 19.8 seconds | 0.51 seconds¹ |

¹ The documents of the public [parity suite](https://github.com/marqiushq/wkhtmltopdf-parity), converted one after another: 39 times faster. With wkhtmltopdf's 200 ms script wait turned off, 5 times faster.

## Install in one minute

Pick the line for your system. Each one checks the download before it installs anything.

**Linux (x86-64 or ARM64) or an Apple silicon Mac, one line:**

```bash
curl -fsSL https://marqius.com/marqius-wkhtmltopdf.sh | bash
```

**Homebrew, on a Mac or on Linux:**

```bash
brew install marqiushq/tap/marqius-wkhtmltopdf
```

**Debian or Ubuntu:**

```bash
sudo curl -fsSLo /etc/apt/sources.list.d/marqius.sources https://packages.marqius.com/apt/marqius.sources
sudo apt update && sudo apt install marqius-wkhtmltopdf
```

Rocky Linux, Red Hat, Fedora, Amazon Linux and Alpine have signed repositories too: see [marqiushq/packages](https://github.com/marqiushq/packages).

**Docker,** for amd64 and arm64:

```bash
docker run --rm -v "$PWD:/data" marqius/wkhtmltopdf invoice.html invoice.pdf
```

**GitHub Actions:**

```yaml
- uses: marqiushq/setup-marqius-wkhtmltopdf@v1
```

**Ruby on Rails, with wicked_pdf or PDFKit:** in your Gemfile, replace `gem "wkhtmltopdf-binary"` with this line, then run `bundle install`:

```ruby
gem "marqius-wkhtmltopdf"
```

Do you work on a Mac and deploy to Linux? Add Linux to your `Gemfile.lock` once with `bundle lock --add-platform x86_64-linux aarch64-linux`. If your code names the program, point it at `MarqiusWkhtmltopdf.executable_path`, as the [gem's README](https://github.com/marqiushq/marqius-wkhtmltopdf-ruby#readme) shows.

## Make your first PDF

```bash
echo '<h1>Invoice 42</h1><p>Total €1,234.50</p>' > invoice.html
marqius-wkhtmltopdf --page-size A4 invoice.html invoice.pdf
```

Open `invoice.pdf`. The options you used with wkhtmltopdf work as they did, for example `--margin-top 20mm`, `--header-html header.html` or `--footer-center "Page [page] of [topage]"`.

## Print Arabic, Chinese, Hindi and more

marqius-wkhtmltopdf prints all of these, even on one page. Each one is tested on real invoices, letters and receipts, and the PDF keeps the words as text, so you can search and copy them.

| Language | On a Linux server | On a Mac or Windows |
|---|---|---|
| English, French, German, Spanish and other languages in Latin letters; Greek; Russian | Works with the fonts most servers have | Works |
| Arabic and Hebrew, from right to left | Works: the fonts are built in | Works |
| Hindi and Thai | Install `fonts-noto-core` | Works |
| Chinese, Japanese and Korean | Install `fonts-noto-cjk` | Works |

On Debian or Ubuntu, this one line installs the fonts for every language above:

```bash
sudo apt-get update && sudo apt-get install -y fonts-noto-core fonts-noto-cjk
```

In a Dockerfile, put the same line after `RUN`, without `sudo`. With the `marqius/wkhtmltopdf` image, [its page](https://hub.docker.com/r/marqius/wkhtmltopdf) shows how to add these fonts. On Alpine, Fedora, Red Hat or Arch, the program prints the line for your system when a font is missing.

Then try an invoice in eight languages:

```bash
cat > invoice.html <<'HTML'
<!doctype html>
<meta charset="utf-8">
<h1>Invoice 42</h1>
<p lang="ar" dir="rtl">فاتورة 42</p>
<p lang="he" dir="rtl">חשבונית 42</p>
<p lang="hi">चालान 42</p>
<p lang="th">ใบแจ้งหนี้ 42</p>
<p lang="zh">发票 42</p>
<p lang="ja">請求書 42</p>
<p lang="ko">청구서 42</p>
HTML
marqius-wkhtmltopdf invoice.html invoice.pdf
```

For a page all in Arabic or Hebrew, put `dir="rtl"` on its `<html>` tag. The page then reads from the right, and its tables and lists turn to match.

## Switch your library in one step

Most apps don't run wkhtmltopdf themselves: they use a library that runs it. You switch in one of two ways, and your code stays as it is.

**Option 1: point the library at the new program.** Most libraries have one setting for the wkhtmltopdf path. Set it to the path this prints:

```bash
command -v marqius-wkhtmltopdf
```

Not sure where your library keeps that setting? The program tells you:

```bash
marqius-wkhtmltopdf help libraries
marqius-wkhtmltopdf help snappy
```

The first line lists the libraries it knows. The second shows where Snappy takes the path, with an example; use any name from the list.

**Option 2: give it the name `wkhtmltopdf`,** so every program that runs `wkhtmltopdf` runs it instead:

```bash
sudo marqius-wkhtmltopdf install
```

`wkhtmltopdf -V` then says which program answers. A wkhtmltopdf already in `/usr/local/bin` is left alone unless you add `--force`, and `sudo marqius-wkhtmltopdf install --undo` puts everything back as it was.

**Tested with these libraries.** Each link is a working example:

| Language | Libraries |
|---|---|
| Python | [python-pdfkit](https://github.com/marqiushq/marqius-wkhtmltopdf-examples/tree/HEAD/examples/python-pdfkit), imgkit, [django-wkhtmltopdf](https://github.com/marqiushq/marqius-wkhtmltopdf-examples/tree/HEAD/examples/django-wkhtmltopdf) |
| PHP | [Snappy](https://github.com/marqiushq/marqius-wkhtmltopdf-examples/tree/HEAD/examples/knplabs-snappy), [laravel-snappy](https://github.com/marqiushq/marqius-wkhtmltopdf-examples/tree/HEAD/examples/laravel-snappy), [KnpSnappyBundle](https://github.com/marqiushq/marqius-wkhtmltopdf-examples/tree/HEAD/examples/knp-snappy-bundle), [phpwkhtmltopdf](https://github.com/marqiushq/marqius-wkhtmltopdf-examples/tree/HEAD/examples/phpwkhtmltopdf), [CakePdf](https://github.com/marqiushq/marqius-wkhtmltopdf-examples/tree/HEAD/examples/cakepdf) |
| Ruby | [wicked_pdf](https://github.com/marqiushq/marqius-wkhtmltopdf-examples/tree/HEAD/examples/wicked-pdf), [PDFKit](https://github.com/marqiushq/marqius-wkhtmltopdf-examples/tree/HEAD/examples/ruby-pdfkit) |
| JavaScript | [wkhtmltopdf for Node](https://github.com/marqiushq/marqius-wkhtmltopdf-examples/tree/HEAD/examples/node-wkhtmltopdf) |
| Go | [go-wkhtmltopdf](https://github.com/marqiushq/marqius-wkhtmltopdf-examples/tree/HEAD/examples/go-wkhtmltopdf) |
| Java | [java-wkhtmltopdf-wrapper](https://github.com/marqiushq/marqius-wkhtmltopdf-examples/tree/HEAD/examples/java-wkhtmltopdf-wrapper) |
| Elixir | [pdf_generator](https://github.com/marqiushq/marqius-wkhtmltopdf-examples/tree/HEAD/examples/elixir-pdf-generator) |
| .NET | [Rotativa.AspNetCore](https://github.com/marqiushq/marqius-wkhtmltopdf-examples/tree/HEAD/examples/rotativa-aspnetcore) |

It is also tested with Odoo 19 and 20 reports, printed through Odoo's own Print button.

## Don't take our word for it

Everything below runs in public, on GitHub's machines, and anyone can run it again.

- **[Your PDFs stay the same](https://github.com/marqiushq/wkhtmltopdf-parity).** 86 business and CSS test documents go through both programs on every release, and every pair of PDFs is compared. The average score is 0.99 out of 1, where 1 means the same text in the same places on the same number of pages. Every difference is published, including the ones we still have to fix. Run it on your own templates in a few minutes; nothing is uploaded.
- **[Your library keeps working](https://github.com/marqiushq/wkhtmltopdf-library-tests).** The test suites of 15 wkhtmltopdf libraries, written by their own authors, run once with wkhtmltopdf and once with marqius-wkhtmltopdf. In all 15, every test that passes with wkhtmltopdf also passes with marqius-wkhtmltopdf.
- **[Check your own PDFs on every pull request](https://github.com/marqiushq/wkhtmltopdf-parity-check).** A GitHub Action converts your templates with both programs and posts GO, REVIEW or NO-GO on the pull request.
- **Every download is signed.** GitHub records how each file was built, so you can check that the file you have is the one GitHub built from our public build recipe:

  ```bash
  gh attestation verify marqius-wkhtmltopdf-linux-x86_64 -R marqiushq/marqius-wkhtmltopdf
  gh attestation verify oci://docker.io/marqius/wkhtmltopdf:latest -R marqiushq/marqius-wkhtmltopdf
  ```

## What it does not do

- It replaces the **wkhtmltopdf program**. It does not replace **libwkhtmltox**, the library that some bindings load directly, such as DinkToPdf.
- A few options work differently, such as custom table-of-contents XSL style sheets (`--xsl-style-sheet`). The [developer manual](https://marqius.com/download/developer-manual.pdf) lists them.
- There is no build for Intel Macs yet. Write to hello@marqius.com if you need one.

## Price

Free for 30 days, with no card. Personal, teaching and open-source use is free with a [Community licence](https://marqius.com/wkhtmltopdf-buy/#community).

Anything done by or for a business, including internal tools and client work, needs a paid plan once the trial ends. [See the plans and prices](https://marqius.com/licence/marqius-wkhtmltopdf).

Your PDFs never stop. Without a licence after the trial, each page carries one line, “Prepared by Marqius, Purchase Licence”, and `marqius-wkhtmltopdf licence` shows the days left. [Licence terms](https://marqius.com/wkhtmltopdf/licence-agreement/)

## Questions developers ask

**Is wkhtmltopdf deprecated?**
Yes. Its repository was archived on 2 January 2023 and gets no fixes of any kind, security fixes included.

**`apt install wkhtmltopdf` says "Unable to locate package". What now?**
Debian 13 and Ubuntu 26.04 no longer include wkhtmltopdf. Install marqius-wkhtmltopdf from [our apt repository](#install-in-one-minute), then run `sudo marqius-wkhtmltopdf install` to give it the name `wkhtmltopdf`.

**wkhtmltopdf says a switch "is not support using unpatched qt, and will be ignored".**
The wkhtmltopdf package of Debian and Ubuntu was built without wkhtmltopdf's own Qt patches, so headers, footers, page numbers and tables of contents do not work. In marqius-wkhtmltopdf they all work, as they did in wkhtmltopdf with patched Qt.

**I get "cannot connect to X server" or "error while loading shared libraries".**
marqius-wkhtmltopdf needs no X server, no Xvfb and no shared libraries, so these errors cannot happen.

**Do I have to change my code?**
No. Keep your library, your templates and your calls. Point the library at marqius-wkhtmltopdf, or give it the name `wkhtmltopdf`.

**Will my PDFs look exactly the same?**
Very close, and you can see for yourself before you switch: run the [parity suite](https://github.com/marqiushq/wkhtmltopdf-parity#check-your-own-templates) on your own templates, or add the [parity check](https://github.com/marqiushq/wkhtmltopdf-parity-check) to your CI.

**Why can't I search or copy Arabic, Chinese or Hindi text in my wkhtmltopdf PDF?**
wkhtmltopdf often stores these scripts as shapes, not words: from its Arabic invoice in the [parity suite](https://github.com/marqiushq/wkhtmltopdf-parity), 2 of 56 words read back as written, against 48 from marqius-wkhtmltopdf. Its Chinese text has look-alike signs in place of some characters, so a search for the company's name finds nothing. The pages look the same; the text inside them does not.

**Why do letters show as boxes in my PDF?**
The computer that makes the PDF has no font for them. Convert the page with marqius-wkhtmltopdf and it names the missing letters, then prints the one line that installs fonts for them on your system.

**Does it work in Docker and on ARM64 servers?**
Yes. The [marqius/wkhtmltopdf](https://hub.docker.com/r/marqius/wkhtmltopdf) images run on amd64 and arm64, from a 10 MB download.

**Is it open source?**
The program is commercial software from Simple AI LLC. The examples, the test suites and the GitHub Actions around it are open source under the MIT licence.

## More

- [Developer manual](https://marqius.com/download/developer-manual.pdf): every option, and a chapter for each library
- [Switching guides](https://marqius.com/blog/wkhtmltopdf-deprecated-alternatives/) for Python, PHP, Ruby, .NET, Node.js and Go
- [Security guidance](https://marqius.com/wkhtmltopdf/security/) for HTML you did not write
- Questions: [hello@marqius.com](mailto:hello@marqius.com)

★ **Star this repository** to hear about new releases.

marqius-wkhtmltopdf is independent of the wkhtmltopdf project. It is proprietary software from Simple AI LLC.
