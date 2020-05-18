
# In development.- the goal is to call the .rmd files to produce a report.
# 
# McCrea Cobb

library(rmarkdown)
## Run a shiny interface to select parameters and call a Rmd that generates a report?
library(SppDistMonProj)

# Find the rmd file in the installed package
dir_path <- system.file("rmd", "data_analysis_knitr.Rmd", package = "SppDistMonProj")

out_dir <- getwd()

rmarkdown::render(dir_path,
                  output_file = "report",
                  output_dir = out_dir)
