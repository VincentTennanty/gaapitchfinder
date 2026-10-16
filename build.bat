@echo off
set RSCRIPT=C:\PROGRA~1\R\R-4.3.3\bin\Rscript.exe
%RSCRIPT% -e "options(pkgType='binary', install.packages.compile.from.source='never'); for (pkg in c('leaflet','DT')) if (!requireNamespace(pkg, quietly=TRUE)) install.packages(pkg, type='binary', repos='https://cloud.r-project.org/')"
%RSCRIPT% -e "options(pkgType='binary', install.packages.compile.from.source='never'); devtools::document(); devtools::build(binary=FALSE, vignettes=FALSE)"
%RSCRIPT% -e "Sys.setenv(RSTUDIO_PANDOC='C:/PROGRA~1/RStudio/resources/app/bin/quarto/bin/tools'); pkgdown::build_site(preview=FALSE)"
