#!/usr/bin/perl

use warnings;
use strict;
use lscp;
use Getopt::Long::Descriptive;

my ( $OPTS, $USAGE ) = describe_options(
    'lscp %o',
    [ 'in_path|i=s', "Directory to read input files from", { required => 1 } ],
    [ 'out_path|o=s', "Directory to write output files to", { required => 1 } ],
    [ 'is_code!', "(default) Whether the input files are source code files or not", { default => 1 } ],
    [ 'do_identifiers!', "(default) Whether to extract identifiers", { default => 1 } ],
    [ 'do_string_literals!', "Whether to extract string literals", { default => 0 } ],
    [ 'do_comments!', "Whether to process comments", { default => 0 } ],
    [],
    [ 'do_remove_digits!', "(default) Whether to remove digits", { default => 1 } ],
    [ 'do_lower_case!', "(default) Whether to convert to lower case", { default => 1 } ],
    [ 'do_stemming!', "Whether to apply stemming", { default => 0 } ],
    [ 'do_tokenize!', "(default) Whether to tokenize words (e.g., camelCase, under_scores)", { default => 1 } ],
    [ 'do_remove_punctuation!', "(default) Whether to remove punctuation", { default => 1 } ],
    [ 'do_remove_small_words!', "(default) Whether to remove small words", { default => 1 } ],
    [ 'do_stopwords_english!', "Whether to remove English stop words", { default => 0 } ],
    [ 'do_stopwords_keywords!', "Whether to remove programming language keywords", { default => 0 } ],
    [ 'small_word_size=i', "(default = 1) Size threshold for small words", { default => 1 } ],
    [],
    [ 'log_level|l=s', "log level (debug, info, warning, error)", { default => "error" } ],
    [],
    [ 'help|h',  "print usage and exit", {shortcircuit => 1} ],
);

print( $USAGE->text ), exit if ( $OPTS->help );


my $preprocessor = lscp->new;

$preprocessor->setOption("logLevel", $OPTS->log_level);
$preprocessor->setOption("inPath", $OPTS->in_path);
$preprocessor->setOption("outPath", $OPTS->out_path);

$preprocessor->setOption("isCode", $OPTS->is_code); # processing source code (0: not source code)
$preprocessor->setOption("doIdentifiers", $OPTS->do_identifiers); # extract identifiers
$preprocessor->setOption("doStringLiterals", $OPTS->do_string_literals); # extract string literal (e.g., "XXX")
$preprocessor->setOption("doComments", $OPTS->do_comments); # process comments

$preprocessor->setOption("doRemoveDigits", $OPTS->do_remove_digits); # remove numbers
$preprocessor->setOption("doLowerCase", $OPTS->do_lower_case); # make them to lower case
$preprocessor->setOption("doStemming", $OPTS->do_stemming); # stem words
$preprocessor->setOption("doTokenize", $OPTS->do_tokenize); # separate some words (e.g,. camel case or snake calse etc.: camelCase,under_scores,dot.notation etc.)
$preprocessor->setOption("doRemovePunctuation", $OPTS->do_remove_punctuation); # remove punctuation
$preprocessor->setOption("doRemoveSmallWords", $OPTS->do_remove_small_words); # remove small words?
$preprocessor->setOption("smallWordSize", $OPTS->small_word_size);  # if doRemoveSmallWords is 1, decide the number of small word (in this case, one character words would be removed)
$preprocessor->setOption("doStopwordsEnglish", $OPTS->do_stopwords_english); # remove stop words
$preprocessor->setOption("doStopwordsKeywords", $OPTS->do_stopwords_keywords); # remove stop words in programing language

$preprocessor->preprocess();
