require(igraph);

# canviar el nom del .csv
a=read.csv("G_dis_v5_mem__mapa_net.csv",sep=",")
a[is.na(a)]=0;

# 1 per jaccard "pur"
# incrementar per generar m?s clusters
PESDIF=1;

coincidents=function(v1,v2) {
  sum(v1*v2);
}

diferents=function(v1,v2) {
  sum(abs(v1-v2));
}

jaccard=function(v1,v2) {
coinc=sum(v1*v2);
diffe=sum(abs(v1-v2));
coinc/(coinc+PESDIF*diffe)
}

dice=function(v1,v2) {
coinc=sum(v1*v2);
diffe=sum(abs(v1-v2));
2.0*coinc/(2.0*coinc+diffe)
}

# !!! columnes amb les competencies
NC=dim(a)[2]-2;
aa=a[,3:(NC+2)]

# !!! nombre d'assignatures
NF=dim(a)[1]
jjj=matrix(1,NF,NF)
#ddd=matrix(1,54,54)

ccc=matrix(0,NF,NF);
for (i in 1:(NF-1)) { for (j in (i+1):NF) { ccc[i,j]=coincidents(aa[i,],aa[j,]);}}

for (i in 1:(NF-1)) { for (j in (i+1):NF) { jjj[i,j]=jaccard(aa[i,],aa[j,]); jjj[j,i]=jjj[i,j]; }}
#for (i in 1:(NF-1)) { for (j in (i+1):NF) { ddd[i,j]=dice(aa[i,],aa[j,]); ddd[j,i]=ddd[i,j]; }}

#q1=cmdscale(1/(0.001+jjj),2)
#
#plot(q1[,1],q1[,2])
#text(q1[,1]+10,q1[,2]+10,as.numeric(rownames(q1)))

#q2=cmdscale(1/(0.001+ddd),2)
#
#plot(q2[,1],q2[,2])
#text(q2[,1]+10,q2[,2]+10,as.numeric(rownames(q2)))

# fitxer amb el JACCARD
write.table(jjj,"out-jaccard.csv",row.names=TRUE,col.names=TRUE,sep=";");

g=graph.adjacency(jjj,mode="undirected",weighted=TRUE,diag=FALSE);

c=walktrap.community(g);

colors=rainbow(max(membership(c)));

plot(g,layout=layout.fruchterman.reingold,vertex.color=colors[membership(c)])


