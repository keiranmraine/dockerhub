cat(".Rprofile: Setting UK repository\n")
r = getOption("repos") # hard code the UK repo for CRAN
r["CRAN"] = "http://cran.uk.r-project.org"
options(repos = r)
rm(r)
source("https://bioconductor.org/biocLite.R")
biocLite("BiocGenerics")
biocLite("poweRlaw")
biocLite("S4Vectors")
biocLite("IRanges")
biocLite("GenomeInfoDb")
biocLite("zlibbioc")
biocLite("XVector")
biocLite("GenomicRanges")
biocLite("copynumber")

