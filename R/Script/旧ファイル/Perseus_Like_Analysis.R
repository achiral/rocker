#Perseus_Like_Analysis
#log2-Impute(MNAR)-Subtract(Median):like a Perseus
#multcomp
  #https://astatsa.com/OneWay_Anova_with_TukeyHSD/_Rcode_tutorial/
  #エクセル入力
  #http://www.yujitakenoshita.org/post/read-excel-in-r/
  #列削除
  #http://byungdugjun.blogspot.com/2014/07/r-x-image-disease-1-1-1-2-2-0-3-0-1-4-1.html
  #BH法
  #https://stats.biopapyrus.jp/stats/fdr-bh.html
  #THSD
  #https://qiita.com/hfu62/items/f9f4803828fd7e1a5cec
  #My anova loop prints out the same results in R
  #https://stackoverflow.com/questions/50914023/my-anova-loop-prints-out-the-same-results-in-r
#############################################################
#############################################################
#############################################################
#log2-Impute(MNAR)-Subtract(Median):like a Perseus
#############################################################
#############################################################
#############################################################
#setwd("/Users/user/Dropbox/0_Work/R/Perseus_Like_Analysis/AMY") #作業ディレクトリ設定
#setwd("/Users/user/Dropbox/0_Work/R/Perseus_Like_Analysis/HIP") #作業ディレクトリ設定
#setwd("/Users/user/Dropbox/0_Work/R/Perseus_Like_Analysis/NAc") #作業ディレクトリ設定
setwd("/Users/user/Dropbox/0_Work/R/Perseus_Like_Analysis/PFC") #作業ディレクトリ設定
#setwd("/Users/user/Dropbox/0_Work/R/Perseus_Like_Analysis/STR") #作業ディレクトリ設定
getwd()#作業ディレクトリ確認
dir() #作業ディレクトリ内のファイル表示
##############################################################
#パッケージインストール
#install.packages("multcomp") #多重比較検定
#install.packages("tidyverse")
#install.packages("dplyr")
#ライブラリ読み込み
library(DEP)
library(tidyverse) #ライブラリtidyverse(ggplot2,dplyr),gcookbook読み込み
library(dplyr)
library(readxl) #エクセル入力(read_excel)
library(xlsx) #エクセル入力
library(openxlsx) #エクセル入出力(write.xlsx)
library(writexl) #xlsx出力
library(multcomp) #多重比較検定
#library(BH) #FDR
##############################################################
#xlsx入力
rm(list = ls(all.names = TRUE))
data <- read_excel("SWATH.xlsx", 2) #シート2(エクセルにてデータ整形)入力
ExpDesign <- read_excel("SWATH.xlsx", 3) #シート3(DEP.packcageのSEファイル)入力
dim(data) #The data.frame dimensions:
colnames(data) #The data.frame column names:
##############################################################
#分割
split <- str_split(data$`Peak Name`, pattern = "\\|", simplify = TRUE)
colnames(split) <- c("sp", "Protein.IDs", "GeneName") #列名変更
class(split)
x <- data.frame(split)
#文字抽出
Protein.IDs <- str_sub(x$`Protein.IDs`, start = 1, end = 6) #`Peak Name`列の1-6文字目(Protein.IDs)抽出
Gene.names <- str_sub(x$`GeneName`, start = 1, end = -7) #`GeneName`列の1文字目〜-7文字目(GeneName)抽出
Species <- str_sub(x$`GeneName`, start = -5, end = -1) #`GeneName`列の-5〜-1文字目(Species)抽出
#抽出文字結合
data <- cbind(data, Protein.IDs) #dataとProtein.IDsを列ベクトル単位で結合 
data <- cbind(data, Gene.names) #dataとGene.namesを列ベクトル単位で結合
data <- cbind(data, Species) #dataとSpeciesを列ベクトル単位で結合
#Search Duplication
data$Protein.IDs %>% duplicated() %>% any()
data$Gene.names %>% duplicated() %>% any()
data$Species %>% duplicated() %>% any()
#Duplication table
data %>% group_by(Protein.IDs) %>% summarize(frequency = n()) %>% arrange(desc(frequency)) %>% filter(frequency > 1)
data %>% group_by(Gene.names) %>% summarize(frequency = n()) %>% arrange(desc(frequency)) %>% filter(frequency > 1)
data %>% group_by(Species) %>% summarize(frequency = n()) %>% arrange(desc(frequency)) %>% filter(frequency > 1)
#Unique Uniprot ID
data_unique <- make_unique(data, "Gene.names", "Protein.IDs", delim = ";")
data$name %>% duplicated() %>% any() # Are there any duplicated names?
#SummarizedExperiment
Sample_columns <- grep("(SAL|PCP)", colnames(data_unique)) # get Sample column numbers
experimental_design <- ExpDesign #ExperimentalDesignSheet(label,condition,replicate)
###############################################################################
#Log2-transform
data_se <- make_se(data_unique, Sample_columns, experimental_design) #columns=データ数, #Log2-transformation
data1 <- data.frame(data_se@assays@data) #log2
#Impute:left-shifted Gaussian distribution (for MNAR)
data_imp_man <- impute(data_se, fun = "man", shift = 1.8, scale = 0.3) #Perseus,imputation
data2 <- data.frame(data_imp_man@assays@data) #Subtract前log2imp
#Subtract(Median):Perseus
standardize <- function(z) {
  colmed <- apply(z, 2, median) #Median of Each Sample's Protein Expression level
  colmad <- apply(z, 2, mad)  # median absolute deviation
  rv <- sweep(z, 2, colmed,"-")  #subtracting median expression
  #rv <- sweep(rv, 2, colmad, "/")  # dividing by median absolute deviation
  return(rv)
}
data3 <- data2 #Subtract前log2impをコピー
Sample_columns <- grep("(SC|PC)", colnames(data3)) # get Sample column numbers
data3[, Sample_columns] <- standardize(data3[Sample_columns]) #Subtract(Median),log2impsub
#############################################################
dat1 <- cbind(rownames(data1),data1) #log2
dat2 <- cbind(rownames(data2),data2) #log2imp
dat3 <- cbind(rownames(data3),data3) #log2impsub
#統合
dat <- cbind(data$Gene.names,data) #行名追加
dat4 <- left_join(dat, dat1, by = c("Gene.names" = "rownames(data1)")) #raw+log2
dat4 <- left_join(dat4, dat2, by = c("Gene.names" = "rownames(data2)")) #raw+log2+log2imp
dat4 <- left_join(dat4, dat3, by = c("Gene.names" = "rownames(data3)")) #raw+log2+log2imp+log2impsub
#xlsx出力
smp <- list("raw"=dat,"log2"=dat1,"log2imp"=dat2,"log2impsub"=dat3,"integ"=dat4) #リスト作成,rawdata,log2,imputation,subtract,integration
write.xlsx(smp, "data.xlsx") #シート出力
#############################################################
#DEP packageによる解析
#data3のlog2impsubを2べき乗にしてimpsubにし、再度log2-transformationをDEP packageで処理
data5 <- data3
data5[Sample_columns] <- 2^(data5[Sample_columns]) #log2impsub→impsub
data3impsub <- data5 #log2impsub→impsub
#抽出文字結合
data3impsub <- cbind(data3impsub, Protein.IDs) #data3impsubとProtein.IDsを列ベクトル単位で結合 
data3impsub <- cbind(data3impsub, Gene.names) #data3impsubとGene.namesを列ベクトル単位で結合
data3impsub <- cbind(data3impsub, Species) #data3impsubとSpeciesを列ベクトル単位で結合
#Unique Uniprot ID
data3impsub_unique <- make_unique(data3impsub, "Gene.names", "Protein.IDs", delim = ";")
#SummarizedExperiment
#Sample_columns2 <- grep("(SC|PC)", colnames(data3impsub)) # get Sample column numbers
ExpDesign2 <- data.frame(cbind(ExpDesign$No,data.frame(list(colnames(data3impsub[Sample_columns]))))) #ExpDesignにデータ解析後の情報を上書き
ExpDesign2 <- cbind(ExpDesign2,ExpDesign[,3:4]) #新たなExpDesignを作成
colnames(ExpDesign2) <- colnames(ExpDesign) #列名を修正
#txt出力
write.table (ExpDesign2, file = "ExpDesign2.txt", sep = "\t") #保存
#txt入力
ExpDesign2 <- read.table("ExpDesign2.txt",header=T, sep="\t", stringsAsFactors = F) #再入力
experimental_design2 <- ExpDesign2 #ExperimentalDesignSheet(label,condition,replicate)
###############################################################################
#Log2-transform
#Sample_columns2 <- grep("(SC|PC)", colnames(data3impsub)) # get Sample column numbers
data3impsub_se <- make_se(data3impsub_unique, Sample_columns, experimental_design2) #columns=データ数, #Log2-transformation
data3log2impsub <- data.frame(data3impsub_se@assays@data) #log2impsubに戻す=data3
#txt出力
#write.table (data3log2impsub, file = "data3log2impsub.txt", sep = "\t") #保存
###############################################################################
#plot
###############################################################################
#plot_frequency(data_se)
#plot_frequency(data_imp_man)
#plot_frequency(data3impsub_se)
#plot_numbers(data_se)
#plot_numbers(data_imp_man)
#plot_numbers(data3impsub_se)
#plot_coverage(data_se)
#plot_coverage(data_imp_man)
#plot_normalization(data_se, data_imp_man, data3impsub_se)
#plot_imputation(data_se, data_imp_man, data3impsub_se) 
#data_filt <- filter_missval(data_imp_man, thr = 0)
#plot_normalization(data_se, data_filt, data_imp_man)
#data_norm <- normalize_vsn(data_filt)
#plot_normalization(data_filt, data_norm, data_imp_man)
###############################################################################
###############################################################################
###############################################################################
#Analysis
#multicomp.Rにて実施
###############################################################################
###############################################################################
###############################################################################
#Differential enrichment analysis:limma
#data_diff <- test_diff(data3impsub_se, type = "control", control = "SC0") # Test every sample versus control
#data_diff_all_contrasts <- test_diff(data3impsub_se, type = "all") # Test all possible comparisons of samples
#data_diff_manual <- test_diff(data3impsub_se, type = "manual", test = c("SC10_vs_SC0","SC30_vs_SC0","PC0_vs_SC0","PC10_vs_SC0","PC30_vs_SC0")) # Test manually defined comparisons
#define cutoffs
#dep <- add_rejections(data_diff, alpha = 0.05, lfc = log2(1))
#dep2 <- add_rejections(data_diff_all_contrasts, alpha = 0.05, lfc = log2(1))
#dep3 <- add_rejections(data_diff_manual, alpha = 0.05, lfc = log2(1.5))
###############################################################################
#Visualization
###############################################################################
#PCA plot
#plot_pca(dep, x = 1, y = 2, indicate = "condition", label = FALSE, n = 500, point_size = 4, label_size = 3, plot = TRUE) # Plot the first and second principal components
#plot_pca(dep2, x = 1, y = 2, indicate = "condition", label = FALSE, n = 500, point_size = 4, label_size = 3, plot = TRUE) # Plot the first and second principal components
#Pearson correlation matrix
#plot_cor(dep, significant = TRUE, lower = 0, upper = 1, pal = "Reds")
#plot_cor(dep2, significant = TRUE, lower = 0, upper = 1, pal = "Reds")
#Heatmap of all significant proteins:proteins (rows) in all samples (columns)
#plot_heatmap(dep2, type = "centered", kmeans = TRUE, 
#             k = 6, col_limit = 4, show_row_names = FALSE,
#             indicate = c("condition", "replicate"))
#Heatmap of all significant proteins (rows) and the tested contrasts (columns)
#plot_heatmap(dep2, type = "contrast", kmeans = TRUE, 
#             k = 6, col_limit = 10, show_row_names = FALSE)
#Volcano plots of specific contrasts:samples (x axis) adjusted p value (y axis)
#plot_volcano(dep, contrast = "PC0_vs_SC0", label_size = 2, add_names = TRUE)
#plot_volcano(dep, contrast = "PC10_vs_SC0", label_size = 3, add_names = TRUE)
#plot_volcano(dep, contrast = "PC30_vs_SC0", label_size = 3, add_names = TRUE)
#plot_volcano(dep, contrast = "SC10_vs_SC0", label_size = 3, add_names = TRUE)
#plot_volcano(dep, contrast = "SC30_vs_SC0", label_size = 2, add_names = TRUE)
#Barplots
#plot_single(dep2, proteins = "SYN1") #protein of interest
#plot_single(dep2, proteins = "SYN1", type = "centered") #data centered
#Frequency plot of significant proteins and overlap of conditions
#plot_cond(dep)
#plot_cond(dep2)
#Results table
#data_results <- get_results(dep2)
# Number of significant proteins
#data_results %>% filter(significant) %>% nrow()
#The resulting table contains the following columns:
# Column names of the results table
#colnames(data_results)
#df_wide <- get_df_wide(dep2)
#df_long <- get_df_long(dep2)
#SSave analyzed data
#save(data_se, data_imp_man, data_diff, data_diff_all_contrasts, dep, dep2, file = "data.RData")
#xlsx出力
#smp <- list("df_wide"=df_wide,"df_long"=df_long) #リスト作成
#write.xlsx(smp, "AMY3.xlsx") #シート出力
# These data can be loaded in future R sessions using this command
#load("data.RData")
#############################################################
#############################################################
#############################################################
#multcomp
#############################################################
#############################################################
#############################################################
#rm(list = ls(all.names = TRUE))
##############################################################
#xlsx入力
#data <- read_excel("data.xlsx", 4) #シート4(log2impsub)入力
#data3 #log2impsubでよい
#list <- data$`rownames(data3)` #使用するか不明
data_rm  <- data3
data_rm[,1:2] <- NULL #列削除
#rownames(data_rm) <- list #不要
#############################################################
#NAc:SC0-2,SC30-4exclude→xlsxで作成
#PC <- gl(6,12,72, label=c("aSC0", "aSC10", "aSC30", "bPC0", "bPC10", "bPC30")) #カテゴリー6,繰返し12,要素72,ラベル6種
#PCP <- gl(2,36,72, label=c("SAL", "PCP")) #SAL/PCP 2,繰返し36,要素72(2x36リピート),ラベル2種
#CLZ <- gl(3,12,72, label=c("CLZ0", "CLZ10", "CLZ30")) #CLZ 3doses,繰返し12,要素72,ラベル3種
#xlsx入力
group <- read_excel("SWATH.xlsx", 4) #シート4(G)入力
#abPC <- factor(group$PC, levels = c("aSC0", "aSC10", "aSC30", "bPC0", "bPC10", "bPC30"))
#PCP <- factor(group$PCP, levels = c("SAL", "PCP"))
#CLZ <- factor(group$CLZ, levels = c("CLZ0", "CLZ10", "CLZ30"))
PC <- factor(group$PC, levels = c("SC0", "SC10", "SC30", "PC0", "PC10", "PC30"))
P <- factor(group$P, levels = c("S", "P"))
C <- factor(group$C, levels = c("C0", "C10", "C30"))
g <- cbind(PC,P,C)
#############################################################
#1wANOVA function
#############################################################
aof <- function(x) { 
  m <- data.frame(PC, x); 
  anova(aov(x ~ PC, m))
}
# apply analysis to the data and get the pvalues.
onewayANOVA <- apply(data_rm, 1, aof)
onewayANOVAp <- data.frame(lapply(onewayANOVA, function(x) { x["Pr(>F)"][1,] }))
onewayANOVAp2 <- data.frame(t(onewayANOVAp))
colnames(onewayANOVAp2) <- "p_PC" #列名の変更
#write.table(onewayANOVAp2, file="1wanova-results.txt", quote=F, sep='\t')
#onewayANOVAp3 <- read.delim2("1wanova-results.txt") #以下でsdataに統合
#onewayANOVAp3 <- cbind(onewayANOVAp3, rownames(onewayANOVAp3)) #以下でsdataに統合
#############################################################
#2wANOVA function
#############################################################
aof2 <- function(x) { 
  n <- data.frame(P,C, x); 
  anova(aov(x ~ P + C + P*C, n))
}
# apply analysis to the data and get the pvalues.
twowayANOVA <- apply(data_rm, 1, aof2)
twowayANOVAp <- data.frame(lapply(twowayANOVA, function(x) { x["Pr(>F)"][1:3,] }))
twowayANOVAp2 <- data.frame(t(twowayANOVAp))
colnames(twowayANOVAp2) <- c("p_P","p_C","p_PxC") #列名の取得
#sapply(twowayANOVAp2, class)
#write.table(twowayANOVAp2, file="2wanova-results.txt", quote=F, sep='\t')
#twowayANOVAp3 <- read.delim2("2wanova-results.txt") #以下でsdataに統合
#sapply(twowayANOVAp3, class)
sdata <- cbind(data_rm,c(onewayANOVAp2, twowayANOVAp2))
#sapply(sdata, class) #p値がnumericであることを確認
#write.table(sdata, file="anova-results.txt", quote=F, sep='\t')
#############################################################
#2wANOVA BH-FDR
#############################################################
#library(tidyverse) #ライブラリtidyverse(ggplot2,dplyr),gcookbook読み込み,#エラーが出るため再読み込み
#sort <- sdata %>% dplyr::arrange(p_PCP) #データフレーム上でソート(increasing order),FDR計算に使用できない
#sort_list <- list(sort$p_PCP) #p値のみリスト化,FDR計算に使用できない
#PCPp_sort <- sort(sdata$p_PCP)
#sapply(PCPp_sort, class) #p値がnumericであることを確認
#dfではBH-FDR計算できない
#PCPp <- data.frame(sort(t(twowayANOVAp[1,]))) # the p values must be sorted in increasing order! 
#CLZp <- data.frame(sort(t(twowayANOVAp[2,]))) # the p values must be sorted in increasing order! 
#PCPCLZp <- data.frame(sort(t(twowayANOVAp[3,]))) # the p values must be sorted in increasing order! 
#dfにしないとBH-FDR計算できるが、昇順にしなくても良い!!
#PCPp <- sort(t(twowayANOVAp[1,])) # the p values must be sorted in increasing order! 
#CLZp <- sort(t(twowayANOVAp[2,])) # the p values must be sorted in increasing order! 
#PCPCLZp <- sort(t(twowayANOVAp[3,])) # the p values must be sorted in increasing order! 
p_PC <- sdata$p_PC
p_P  <- sdata$p_P 
p_C <- sdata$p_C
p_PxC <- sdata$p_PxC
checkP <- data.frame(cbind(p_PC, p_P, p_C, p_PxC))
rownames(checkP) <- rownames(data3)
checkPr <- cbind(rownames(checkP),checkP)

q_PC <- data.frame(p.adjust(p_PC, method = "BH"))
q_P <- data.frame(p.adjust(p_P, method = "BH"))
q_C <- data.frame(p.adjust(p_C, method = "BH"))
q_PxC <- data.frame(p.adjust(p_PxC, method = "BH"))
checkQ <- data.frame(cbind(q_PC, q_P, q_C, q_PxC))
colnames(checkQ) <- c("q_PC", "q_P", "q_C","q_PxC") #列名の取得
rownames(checkQ) <- rownames(data3)
checkQr <- cbind(rownames(checkQ),checkQ)

#fdr.result <- bh(PCPp, 0.05) #bh()関数が動かない
#bhthresh <- cbind(PCq, PCPq, CLZq, PCPCLZq) # put the bh results in our table. 
#write.table(bhthresh, "bhthresh.txt", sep='\t', quote=F) # print to a file.
sdata <- cbind(sdata, checkQ)
#sapply(sdata, class) #p,q値がnumericであることを確認
#write.table(sdata, file="anova-results.txt", quote=F, sep='\t')
#############################################################
#TukeyHSD function
#diff群間の平均値の差(例)B-Aが-127.3であればデータBの平均がデータAの平均より-127.3大きい
#lwr,upr=下方信頼限界,情報信頼限界:信頼区間の下限値 (lower) と上限値 (upper)
#0を含まない場合 (例)B-A は含まず D-A は含む=2群間差は0ではないので有意差あり
#p.adj < 0.05=2群間に有意差あり(信頼区間内に0を含まない)
#############################################################
THSD <- function(x) { 
  nn <- data.frame(P,C, x); 
  TukeyHSD(aov(x ~ P + C + P*C, nn))
}
THSDresults <- apply(data_rm, 1, THSD) 
#plot(THSDresults[["SPTN1"]]) #SPTN1のプロット
#xx <- data.frame(THSDresults[["SPTN1"]][["PCP:CLZ"]])$`p.adj`
#xx$`p.adj`
#THSD_PCP <- data.frame(lapply(THSDresults, function(x) {x["PCP"]}))
#THSD_CLZ <- data.frame(lapply(THSDresults, function(x) {x["CLZ"]}))
THSD_PC <- data.frame(lapply(THSDresults, function(x) {x["P:C"]}))
#write.table(THSD_PCP, file="THSD_PCP.txt", quote=F, sep='\t')
#write.table(THSD_CLZ, file="THSD_CLZ.txt", quote=F, sep='\t')
#write.table(THSD_PCPCLZ, file="THSD_PCPCLZ.txt", quote=F, sep='\t')
#THSD_PCP2 <- read.table("THSD_PCP.txt",header=T, row.names=1)
#THSD_CLZ2 <- read.table("THSD_CLZ.txt",header=T, row.names=1)
#THSD_PCPCLZ2 <- read.table("THSD_PCPCLZ.txt",header=T, row.names=1)
#############################################################
#############################################################
#############################################################
#エラーが出るのでtidyverse再インストール,再読み込み
install.packages("tidyverse") #←←←←←←←←←←←←←←←←←←←←←←stop←←←←←
#############################################################
#############################################################
#############################################################
library(tidyverse) #ライブラリtidyverse(ggplot2,dplyr),gcookbook読み込み
#THSDp_PCP <- select(THSD_PCP, ends_with("p.adj")) #p値抽出
#THSDp_CLZ <- select(THSD_CLZ, ends_with("p.adj")) #p値抽出
THSDp_PC <- select(THSD_PC, ends_with("p.adj")) #p値抽出
THSDd_PC <- select(THSD_PC, ends_with(".diff")) #diff値抽出
#transpose
#THSDp_PCP2 <- data.frame(t(THSDp_PCP))
#THSDp_CLZ2 <- data.frame(t(THSDp_CLZ))
THSDp_PC2 <- data.frame(t(THSDp_PC))
THSDd_PC2 <- data.frame(t(THSDd_PC))
#列名変更
#colnames(THSDp_PCP2) <- str_c("THSDp", colnames(THSDp_PCP2), sep="_")
#colnames(THSDp_CLZ2) <- str_c("THSDp", colnames(THSDp_CLZ2), sep="_")
colnames(THSDp_PC2) <- str_c("THSDp", colnames(THSDp_PC2), sep="_")
colnames(THSDd_PC2) <- str_c("diff", colnames(THSDd_PC2), sep="_")
#結合
THSDpd <- cbind(THSDp_PC2, THSDd_PC2)
#THSDpd <- cbind(THSDp_PCP2,c(THSDp_CLZ2, THSDp_PCPCLZ2, THSDd_PCPCLZ2))
rownames(THSDpd) <- rownames(data3)
THSDpd <- cbind(rownames(THSDpd),THSDpd)
sdata <- cbind(sdata, THSDpd)
#sdata <- cbind(sdata,c(THSDp_PCP2, THSDp_CLZ2, THSDp_PCPCLZ2, THSDd_PCPCLZ2))
#############################################################
#Annotation
#############################################################
sdata2 <- cbind(rownames(sdata),sdata)
#抽出文字結合
sdata2 <- cbind(sdata2, Protein.IDs) #sdata2とProtein.IDsを列ベクトル単位で結合 
sdata2 <- cbind(sdata2, Gene.names) #sdata2とGene.namesを列ベクトル単位で結合
sdata2 <- cbind(sdata2, Species) #sdata2とSpeciesを列ベクトル単位で結合
sdata2 <- left_join(sdata2, data.frame(data[,c(5,79)]), by = "Protein.IDs")
#############################################################
#xlsx出力
library(writexl) #xlsx出力
sheets <- list("integ" = sdata2, "anovap" = checkPr, "anovaq" = checkQr, "THSDpd" = THSDpd) #assume sheet1-4 are data frames
write_xlsx(sheets, "stat.xlsx", format_headers = FALSE)
#txt出力
#write.table (sdata2, file = "integ.txt", sep = "\t") #保存
#############################################################
# ココで中断した場合以下から再開
#############################################################
#txt入力
#sdata2 <- read.table("integ.txt",header=T, sep="\t", stringsAsFactors = F)
#dim(sdata2) #The data.frame dimensions:
#colnames(sdata2) #The data.frame column names:
#############################################################
#DEPリスト作成
#############################################################
t(colnames(sdata2))
twANOVA_Pq005 <- sdata2 %>% filter(Species == "MOUSE") %>% filter(q_P < 0.05)
twANOVA_Cq005 <- sdata2 %>% filter(Species == "MOUSE") %>% filter(q_C < 0.05)
twANOVA_PxCq005 <- sdata2 %>% filter(Species == "MOUSE") %>% filter(q_PxC < 0.05)
sheets2 <- list("Pq005"=twANOVA_Pq005[,c(1,75:77, 79:81, 113:116)],
                "Cq005"=twANOVA_Cq005[,c(1,75:77, 79:81, 113:116)],
                "PxCq005"=twANOVA_PxCq005[,c(1,75:77, 79:81, 113:116)])
write_xlsx(sheets2, "DEPtwANOVA.xlsx", format_headers = FALSE)
#############################################################