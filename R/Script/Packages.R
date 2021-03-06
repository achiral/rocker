# R packages
#############################################################
# install packages
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager", repos='http://cran.us.r-project.org')
BiocManager::install()                              # update
BiocManager::install("airway")
BiocManager::install("aLFQ")
BiocManager::install("BaylorEdPsych")               # NA
# BiocManager::install("biomaRt")
BiocManager::install("ComplexHeatmap")              # heatmap
# BiocManager::install("DEP")                       # NA, proteomics
BiocManager::install("DESeq")
BiocManager::install("DESeq2")
BiocManager::install("EnhancedVolcano")
BiocManager::install("genefilter")                  # heatmap
# BiocManager::install("gmm")                       # NA, DEP
# BiocManager::install("GO.db")
BiocManager::install("gplots")                      # heatmap
BiocManager::install("imsbInfer")                   # NA
BiocManager::install("loadTransitonsMSExperiment")  # NA
# BiocManager::install("mouse4302.db")
BiocManager::install("MSstats")
BiocManager::install("mzR")
# BiocManager::install("org.Hs.eg.db")
# BiocManager::install("org.Mm.eg.db")
# BiocManager::install("PANTHER.db")
BiocManager::install("PECA")
BiocManager::install("RCyjs")                       # cyREST, Cytoscape
BiocManager::install("readinteger_binary")
# BiocManager::install("SummarizedExperiment")      # DEP
BiocManager::install("SWATH2stats")


install.packages("agricolae")                       
install.packages("BH")
# install.packages("BiocManager")                   # done
install.packages("cowplot")
install.packages("data.table")                      # MSstat
install.packages("devtools")
install.packages("doSNOW")                          # MSstat
# install.packages("dplyr")                         # tidyverse, MSstat
install.packages("foreach")                         # MSstat
install.packages("ggcorrplot") 
install.packages("ggrepel")                         # MSstat
install.packages("ggplot2")                         # MSstat
install.packages("ggThemeAssist")
install.packages("gplots")                          # MSstat
install.packages("gridExtra")                       # svg
install.packages("imputeMissings")
# install.packages("lattice")                       # done, limma
install.packages("lme4")                            # MSstat
install.packages("mgcv")                            # done, limma
install.packages("mice")
install.packages("minpack.lm")                      # MSstat
install.packages("missForest")
install.packages("mlbench")
# install.packages("multcomp")                      # done, multiple comparison
# install.packages("openxlsx")                      # done, exlx input
# install.packages("palmerpenguins")                # demo
# install.packages("readxl")                        # done, exlx input, read_excel
install.packages("reshape")                         # MSstat
install.packages("reshape2")                        # MSstat
# install.packages("rJava")                         # done
install.packages("randomForest")                    # MSstat
install.packages("rsvg")                            # svg出力
install.packages("rvg")                             # svg出力（https://www.karada-good.net/analyticsr/r-382）
# install.packages("S4Vectors")                     # done, DEP/SummarizedExperiment
# install.packages("sandwich")                      # done, gmm
install.packages("scales")                          # muted()
install.packages("sets")                            # set operation
install.packages("sgof")                            # bh(), Multiple Hypothesis Testing
install.packages("snow")                            # MSstat
install.packages("stringr")                         # MSstat
install.packages("survival")                        # MSstat
# install.packages("tablaxlsx")                     # NA, xlsx table output
install.packages("tidyr")                           # MSstat
# install.packages("tidyverse")                     # done, 
install.packages("VIM")
# install.packages("writexl")                       # done, xlsx output
# install.packages("xlsx")                          # done, xlsx output
# install.packages("xlsx2")                         # NA, xlsx output
install.packages("XLConnect")                       # xlsx in/output

#############################################################
# Load BioConductor Packages
# library(BaylorEdPsych)                            # NA
# library(biomaRt)
library(ComplexHeatmap)                             # heatmap
# library(DEP)                                      # NA, proteomics
library(DESeq)
library(DESeq2)
library(EnhancedVolcano)
library(genefilter)                                 # heatmap
# library(gmm)                                      # NA, DEP
# library(GO.db)
library(gplots)                                     # heatmap
library(imsbInfer)                                  # NA
library(loadTransitonsMSExperiment)                 # NA
# library(mouse4302.db)
library(MSstats)                                    # NA?
library(mzR)
# library(org.Hs.eg.db)
# library(org.Mm.eg.db)
# library(PANTHER.db)
library(PECA)
library(RCyjs)                                      # cyREST, Cytoscape
library(readinteger_binary)
# library(SummarizedExperiment)                     # DEP
library(SummarizedExperiment)
library(SWATH2stats)

#############################################################
# Load BaseR Packages
library(airway)
library(aLFQ)
library(agricolae)                                  
# library(BaylorEdPsych)                            # NA
library(BH)                                         # FDR
# library(BiocManager)                              # done
library(RColorBrewer)                               # color
library(cowplot)
library(data.table)                                 # MSstat
library(devtools)
library(doSNOW)                                     # MSstat
# library(dplyr)                                    # tidyverse, MSstat
library(foreach)                                    # MSstat
library(ggcorrplot)                                 
library(ggrepel)                                    # MSstat
library(ggplot2)                                    # MSstat
library(ggThemeAssist)
library(gplots)                                     # MSstat, heatmap
library(gridExtra)                                  # svg
library(imputeMissings)
# library(lattice)                                  # done, limma
library(lme4)                                       # MSstat
library(magrittr)
library(mgcv)                                       # done, limma
library(mice)
library(minpack.lm)                                 # MSstat
library(missForest)
library(mlbench)
# library(multcomp)                                 # done, multiple comparison
# library(openxlsx)                                 # done, exlx output(write.xlsx)
# library(palmerpenguins)                           # demo
# library(readxl)                                   # done, exlx input(read_excel)
library(reshape)                                    # MSstat
library(reshape2)                                   # MSstat
# library(rJava)                                    # done
library(randomForest)                               # MSstat
library(rsvg)                                       # svg
library(rvg)                                        # svg（https://www.karada-good.net/analyticsr/r-382）
# library(S4Vectors)                                # done, DEP/SummarizedExperiment
# library(sandwich)                                 # done, gmm
library(scales)                                     # muted()
library(sets)                                       # set operation
library(sgof)                                       # bh(), Multiple Hypothesis Testing
library(snow)                                       # MSstat
library(stringr)                                    # MSstat
library(survival)                                   # MSstat
# library(tablaxlsx)                                # NA, xlsx table output
library(tidyr)                                      # MSstat
library(tidyverse)                                  # ggplot2, dplyr
library(VIM)
library(writexl)                                    # xlsx output
library(xlsx)                                       # xlsx output
# library(xlsx2)                                    # NA, xlsx output
library(XLConnect)                                  # NA(JAVA8-11), xlsx in/output
#############################################################
installed.packages()
sessionInfo() 
#############################################################
