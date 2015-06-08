[![Build Status](https://travis-ci.org/paulodiovani/sinos-river-parser.svg?branch=master)](https://travis-ci.org/paulodiovani/sinos-river-parser)

# Sinos River Level Reader

**WORK IN PROGRESS**

Reads the measurements from Sinos River published on
[a stupid Google Spreadsheet][sheet] by _comitesinos.com.br_.

[sheet]: https://docs.google.com/spreadsheet/pub?key=0AkXSgrDXAQJjdG1JZVFDcEpLQU5JY2dLTWZBcW9jVEE&gid=9

## Usage

First, install globaly.

While still in development you can install directly from github repository.

```bash
npm install -g https://github.com/paulodiovani/sinos-river-parser.git
```

After that, just run `sinos-level [OPTIONS] [INPUT_SOURCE]`.

The output from `--help` option os bellow.

```text
usage: sinos-level [OPTIONS] [INPUT_SOURCE]

INPUT_SOURCE:
  file or url to read from

OPTIONS:
  -h, --help                  Print this help
  -s, --source, --url, --file Set INPUT_SOURCE
  -y, --years                 Print available years at source
```

## Running the tests

Get the source, then...

```bash
git clone npm install -g https://github.com/paulodiovani/sinos-river-parser.git
cd sinos-river-parser
npm install
npm test
```
