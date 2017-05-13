EADME

## Introduction

This repository contains materials to generate this paper in pdf in ACM
standard in Knitr. The R package [MutMin](http://eecs.osuosl.org/rahul/icse2016/)
contains the empirical observations using PIT mutation tool. For replicating
this research, provide your own data as an R package, with the same format as
_MutMin_, and require it in _src/paper.Rnw_ instead of _MutMin_.

## Layout

### src

This directory contains the source code in [knitr](http://yihui.name/knitr/) format.

- src/paper.Rnw
  The paper itself in Knitr, and other child documents as src/<children>.Rnw

- src/paper.bib
  The references used in the paper.

- etc/
  The ACM format specific files for generating pdf from pandoc markdown.
  The meta information such as title, author etc.

### build

This directory contains the generated pdf output.

## Building


### Requirements

You will need knitr to process the files, and associated R packages.

This can be accomplished with

```
    R -q
    install.packages(c('knitr','xtable','reshape2','scales','ggplot2'))
```

### Generate

First ensure that the data package for replication is installed correctly.

```
    make data
    
```

And then run make to generate the new pdf at build/acm\_sigproc.pdf

```
    make
```


