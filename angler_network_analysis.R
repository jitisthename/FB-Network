library(igraph)
library(Matrix)
setwd("C:/Users/jltho/Desktop/R")

adj = read.csv("angler_pairs_edge_list.csv",stringsAsFactors = FALSE) #read in the data file
adj$rowid = seq(1:nrow(adj)) #add another rowid to make sure we don't lose data when we remove duplicates

#create a integer id for each unique lake to be used in sparse matrix
uniquelakes = data.frame(as.character(unique(unlist(adj[,c("from_lake","to_lake")]))),stringsAsFactors = F) #get list of unique lake
colnames(uniquelakes)="uniquelakes"
uniquelakes$id = seq(1:nrow(uniquelakes))

#merge row/column integers to adj dataframe for use in sparse matrix
adj = merge(x=adj,y=uniquelakes,by.x="from_lake",by.y="uniquelakes",all.x=TRUE)
colnames(adj)[colnames(adj)=="id"]="from"
adj = merge(x=adj,y=uniquelakes,by.x="to_lake",by.y="uniquelakes",all.x=TRUE)
colnames(adj)[colnames(adj)=="id"]="to"
adj = adj[!duplicated(adj),]

#create sparse matrix
#for angler network
lakes_matrix <- sparseMatrix(i=as.integer(adj$from), j=as.integer(adj$to), x=as.numeric(adj$weight), dims = c(length(uniquelakes$uniquelakes), length(uniquelakes$uniquelakes)))

#create graph from adjacency/edge list
g <- graph.adjacency(lakes_matrix, mode="directed", weighted=TRUE)

print("node count")
vcount(g) #prints the number of nodes in the graph/network
wt = E(g)$weight #set wt object with weights of connections/edges
print("simple statistics on edge attributes (weights)")
summary(wt) # simple statistics on edge attributes (weights)
# # 
#in degree
gs = graph.strength(g, vids = V(g), mode = c("in"), weights = wt) #like degree distribution except considers weights
#out degree
ogs = graph.strength(g, vids = V(g), mode = "out", weights = wt) #like degree distribution except considers weights
#total degree
tgs = graph.strength(g, vids = V(g), mode = "total", weights = wt) #like degree distribution except considers weights

#find clusters/components of the graph
clweak <- clusters(g, mode="weak") # finds maximal weakly connected components of graph
print("number of clusters in weakly connected graph")
clweak$no # number of clusters
nodes = which(clweak$membership == which.max(clweak$csize)) #get nodes of largest component/cluster

# get the number of nodes in the largest component
print("# of nodes in giant weakly connected component")
length(clweak$membership[which(clweak$membership == which.max(clweak$csize))]) # number of nodes in the largest component/cluster

## Longest geodesic distance in a network - diameter of the largest component in the network
print("diameter")
diameter(g, directed=TRUE, weights=wt)

## Network density
print("density")
ecount(g)/(vcount(g)*(vcount(g)-1)) #for a directed network

## Reciprocity (proportion of reciprocited ties)
print("reciprocity")
reciprocity(g)

df = data.frame(cbind(gs, ogs, tgs, V(g)))
colnames(df)=c("degree_in","degree_out","degree_tot","vid") #rename columns
df = merge(x=df,y=uniquelakes,by.x="vid",by.y="id") #join the Permanent_Identifier for each lake

write.csv(df, "angler_network_lake_attributes_0614.csv",row.names=F)
