# kaldiwhg

a tool for extracting a word hypotheses graph (WHG) from Kaldi results (https://github.com/kaldi-asr/kaldi)

## Prerequisites

guile (tested with version 2.2 and 3.0 under Ubuntu 20.04 and 20.10) or any other Scheme (port for bigloo exists)

## Installation

To use kaldiwhg as as script, just run `make` and make sure that `kaldiwhg` and `kaldiwhg.scm` are in your path.

## Usage

kaldiwhg wav-file

Options:
  -l out-dir-for-log-and-debug-files
  -o out-dir-for-parser-graph
