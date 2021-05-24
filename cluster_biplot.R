args <- commandArgs(trailingOnly = TRUE)
file <- args[1]
outname <- args[2]
startC <-args[3]
endC<-args[4]
rowNC<-args[5]
rm(args)

####https://github.com/kassambara/factoextra####
library("FactoMineR")

library("factoextra")
#file="FHC2.data"
#outname="FHC2Tax7"
#startC=8
#endC=28
#rowNC=7
A<-read.table(file,header=TRUE, sep="\t",stringsAsFactors=F)
d<-dim(A)
df<-data.matrix(A[1:d[1],startC:endC]);
colnames(df)=clonames(A)[startC:endC]
rownames(df)=A[,rownNC]

res.pca <- PCA(df,  graph = FALSE)
# Extract eigenvalues/variances
get_eig(res.pca)
# Visualize eigenvalues/variances
png(filename=paste0(outname,".eigan.png"), height=2800, width=3600, res=300)
fviz_screeplot(res.pca, addlabels = TRUE, ylim = c(0, 50))
dev.off()
# Extract the results for variables
var <- get_pca_var(res.pca)
var
# Coordinates of variables
head(var$coord)
# Contribution of variables
#head(var$contrib)
# Graph of variables: default plot
png(filename=paste0(outname,".var.png"), height=2800, width=3600, res=300)
#fviz_pca_var(res.pca, col.var = "black")

# Control variable colors using their contributions
fviz_pca_var(res.pca, col.var="contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE # Avoid text overlapping
             )
dev.off()
# Contributions of variables to PC1
png(filename=paste0(outname,".PC1.png"), height=2800, width=3600, res=300)
fviz_contrib(res.pca, choice = "var", axes = 1)
dev.off()
# Contributions of variables to PC2
png(filename=paste0(outname,".PC2.png"), height=2800, width=3600, res=300)
fviz_contrib(res.pca, choice = "var", axes = 2,
#top = 10
)
dev.off()
# Extract the results for individuals
ind <- get_pca_ind(res.pca)
#ind
# Coordinates of individuals
head(ind$coord)
# Graph of individuals
# 1. Use repel = TRUE to avoid overplotting
# 2. Control automatically the color of individuals using the cos2
    # cos2 = the quality of the individuals on the factor map
    # Use points only
# 3. Use gradient color
png(filename=paste0(outname,".strain.png"), height=2800, width=3600, res=300)
fviz_pca_ind(res.pca, col.ind = "cos2", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE # Avoid text overlapping (slow if many points)
             )
dev.off()



df2=t(df);
res.pca2 <- PCA(df2,  graph = FALSE)
png(filename=paste0(outname,".biplot.png"), height=2800, width=3600, res=300)
fviz_pca_biplot(res.pca2, repel = TRUE)
dev.off()

png(filename=paste0(outname,".sample.png"), height=2800, width=3600, res=300)
fviz_pca_ind(res.pca2, col.ind = "cos2", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE # Avoid text overlapping (slow if many points)
             )
dev.off()

###############Did not work so far
#group=c("Cotton2", "Cotton2","Cotton2","Cotton2","Poly2", "Poly2","Poly2","Poly2","Cotton3","Cotton3","Cotton3","Cotton3","Poly3","Poly3","Cotton4","Cotton4","Cotton4","Cotton4","Poly4","Poly4","Poly4")
#df2=cbind(df2, group)

#fviz_pca_ind(res.pca2,
#             label = "none", # hide individual labels
#             habillage = df2$group, # color by groups
#             palette = c("#00AFBB", "#E7B800", "#FC4E07"),
#             addEllipses = TRUE # Concentration ellipses
#             )
#########################################################
res.dist <- dist(df2, method = "euclidean")
# Compute hierarchical clustering
res.hc <- hclust(res.dist, method = "ward.D2")
# Visualize
png(filename=paste0(outname,".samplecluster.png"), height=2800, width=3600, res=300)
plot(res.hc, cex = 0.5)
dev.off()
res.hc <- eclust(df2, "hclust")
png(filename=paste0(outname,".samplecluster2.png"), height=2800, width=3600, res=300)
fviz_dend(res.hc, rect = TRUE) # dendrogam
dev.off()
