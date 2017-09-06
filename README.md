COEF: Collection Of Esoteric Functions
======================================

### Installation

    library(devtools)
    install_github("Russel88/COEF")

#### read\_elisa

Seamless loading of data from ELISA plate reader, including
descriptions.

It will load excel files, and can automatically locate the 96 well plate
as long as there is only data from 1 plate in 1 excel file.

The input is the path for where the excel file is located (e.g.
path="C:/Users/mystuff/file.xlsx"), or if several excel files should be
loaded at the same time write the path for the folder containing the
excel files (it should contain nothing else than excel files) and wrap
it in the dir function (e.g. path=dir("C:/Users/mystuff/")).

See the example data
[here](https://raw.githubusercontent.com/Russel88/COEF/master/ExampleData/test.xlsx),
which can be loaded like this:

    data <- read_elisa(path = "test.xlsx", descriptions = 2)

The following error might arise:

    Error in read_fun(path = path, sheet = sheet, limits = limits, shim = shim,  : 
      Evaluation error: zip file 'X.xlsx' cannot be opened.'

This is because 'X.xlsx' is in the path argument but does not exist.

#### fancy\_scientific

Numeric to fancy scientific notation. By [Brian
Diggs](https://groups.google.com/forum/#!topic/ggplot2/a_xhMoQyxZ4)
