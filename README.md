# Read Me

This is the repository for the code and data accompanying the analysis published in the paper entitled, "Modern stone tool users from Northern Kenya emphasize mass and edge length in the selection of cutting tools", published in the Proceedings of the Royal Society B

## Using this code
The repository is comprised of a series of interconnected files and folders. So it is best to keep the files and folders in their original places for ease of reproducibility. As long as the file structure is maintained, you should be able to open and run any of the analysis files (see below) without issue. Just make sure that you have installed all of the necessary packages defined at the beginning of each Rmd file. 

The code makes use of the rethinking package to implement all of the Bayesian analysis. Installing this package is more involved than simply using the "install.packages" function in R. I suggest that you visit the [Rethinking GitHub page](https://github.com/rmcelreath/rethinking) when installing this package. 

## Analysis Files

There are  4 R Markdown files. CE_Participant_level_Model.Rmd and Cutting_Edge_Global_Model.Rmd defines the Bayesian ordinal models published in the paper. They are also accompanied by the diagnostics provided by the "Rethinking" package that can be used to assess the quality of the model. The "Models" folder also contains a copy of the model results that can be used to generate the figures in the "CE_Figures.Rmd" document. The CE_Figures.Rmd provides the code that allows you to reproduce every figure except for Figure 1. Figure 1 is a compilation of photos. CE_Tables.rmd provides the code for the tables.

## Feedback, bugs, issues

Please don't hesitate to contact me with any issues you might encounter.
