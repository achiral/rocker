# パッケージ管理

# このプロジェクトで利用するパッケージとそのバージョンなどの情報は renv.lock ファイルで管理される

# ライブラリの同期 -------------------------------------------------------------

# renv.lock ファイルを共有されたプロジェクト参加者は
renv::restore()
# を実行することによってその内容に沿ったパッケージをライブラリにインストールできる。
# 通常これはプロジェクトを開いたときに自動的に実行される。

# ライブラリの更新 -------------------------------------------------------------

# ライブラリにパッケージを追加するには以下のようにする

# (1) パッケージをインストール
# renvを使用してインストールを行う
# renvではBioConductorのパッケージはインストール出来ないため毎回インストールし直す
if (!requireNamespace("BiocManager", quietly = TRUE))
packages <- c(
  "BiocManager",        # 済
  "lattice",            # limma
  "mgcv",               # limma
  "multcomp",           # 済
  "openxlsx",           # 済 write.xlsx
  "palmerpenguins",     # 未
  "readxl",             # 済 read_excel
  "rJava",              # 済
  "S4Vectors"           # DEP/SummarizedExperiment
  "sandwich"            # gmm
  "tidyverse",          # 済
  "writexl",            # 済
  "xlsx"                # 済
)
renv::install(packages)


# 以下BiocManagerによりインストール(renvではインストールできない)
# pacagesでまとめてインストールする場合は時間がかかる
# 現在の環境では必要時に1つずつインストールしたほうが良い
# DEPパッケージはインストール出来ないため構成パッケージを個別にインストールする(未設定)
packages_BiocManager <- c(
  # "biomaRt",
  # "DEP",                  # error, proteomics用
  # "gmm",
  # "GO.db",
  # "mouse4302.db",
  # "org.Hs.eg.db",
  # "org.Mm.eg.db",
  # "PANTHER.db",
  # "SummarizedExperiment"  # DEP構成
)
BiocManager::install(packages_BiocManager)

# 以下個別インストール用
# BiocManager::install("biomaRt")
# BiocManager::install("DEP")                # error,proteomics用
# BiocManager::install("gmm")                # error,DEP
# BiocManager::install("GO.db")
# BiocManager::install("mouse4302.db")
# BiocManager::install("org.Hs.eg.db")
# BiocManager::install("org.Mm.eg.db")
# BiocManager::install("PANTHER.db")
# BiocManager::install("SummarizedExperiment") # DEP構成


# (2) renv.lock ファイルを更新
renv::snapshot(packages = c("renv", packages))
