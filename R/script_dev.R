# 分析・開発用のコード
#
# install_packages.R でインストールしたパッケージを普通にロードして使用する。
# 例:
#     library(palmerpenguins)
#     head(penguins)

################################################################################
setwd("/home/rstudio/project")
getwd()
################################################################################


library(DEP)
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
