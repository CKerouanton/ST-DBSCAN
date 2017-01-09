## ST-DBSCAN

ST-DBSCAN : An algorithm for clustering spatial-temporal data  

Birant, D., & Kut, A. (2007). ST-DBSCAN: An algorithm for clustering spatial–temporal data. Data & Knowledge Engineering, 60(1), 208-221.




# INPUTS :             

data = spatio-temporal data
x = data longitude
y = data latitude
time = data timestamps
eps = distance minimum for longitude and latitude               
eps2 =  temporal window                 
minpts = number of points to consider a cluster  
cldensity = TRUE or FALSE to display the number of points reachables for every point within a cluster

# OUTPUTS :

data$cluster = cluster number
data$cldensity = cluster points density



