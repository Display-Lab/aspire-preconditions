---
title: "Preconditions Report"
author: "DISPLAY Lab"
date: "14 November, 2019"
output: pdf_document
---



## Stepping Back Analysis Method

### Special Annotation
A stepping backwards preconditions analysis is accomplished by way of a special annotation function.
It filters the data back `x` number of months and runs the other annotations that are temporaly dependent.
The annotations that have been run on data with `x` months filtered out are named specially with `_x` appended.
For example, `positive_performance_gap_3` indicates a positive performance gap in the data 3 months back.

### Query After Swapping Annotation IRIS 
Initially the candidates are evaluated by applying causal pathway preconditions and querying the results.
To step back and evaluate what the candidates would have been `x` months ago, the annotations need to be altered to match the IRIs the causal pathways operate on.
This is accomplished by a simple IRI swapping scheme where the standard annotation gets swapped for the equivalent `x-1` special annotation, and the `x` special annotation gets swapped for the standard.

For example, after initial evaluation and query, stepping 1 month back:
1. All instances of the standard postive performance gap `psdo_0000104` changed to `positive_performance_gap_0`
1. All instances of `positive_performance_gap_1` changed to `psdo_0000104`
1. Swapping is also performed for `psdo_0000105`, `psdo_0000100` `psdo_0000099`, and `slowmo#Achievement`
1. Existing triples of the form `candidate acceptable_by causal_pathway` are deleted removing acceptability of the previous IRI set.
1. Causal pathways are applied writing in new `candidate acceptable_by causal_pathway` based on the newly swapped IRIs.
1. Summary queires are run and collected into summary file 

## Splitting up Candidates.
The list of candidates presents an I/O and memory challenge to deal with.
Essentially, the graph gets to big to store in memory and loading it takes too much time.
To mitigate this, the list of candidates is broken up into smaller lists that are then loaded & analyzed on their own.
This breaks up the loading time and memory footprint of the analysis.
The results of the stepping back summary for each of the sets can then be collected into a single report.

Number of candidates per set:
```
52155
52155
52155
52156
208621 Total Candidates
```



```r
summary(cars)
```

```
##      speed           dist       
##  Min.   : 4.0   Min.   :  2.00  
##  1st Qu.:12.0   1st Qu.: 26.00  
##  Median :15.0   Median : 36.00  
##  Mean   :15.4   Mean   : 42.98  
##  3rd Qu.:19.0   3rd Qu.: 56.00  
##  Max.   :25.0   Max.   :120.00
```

## Including Plots

You can also embed plots, for example:

![plot of chunk pressure](figure/pressure-1.png)

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
