# ST-DBSCAN

### ST-DBSCAN: An algorithm for clustering spatial–temporal data

Birant, D., & Kut, A. (2007). ST-DBSCAN: An algorithm for clustering spatial–temporal data. Data & Knowledge Engineering, 60(1), 208-221.




## INPUTS :             

data = spatio-temporal data <br>
x = data longitude <br>
y = data latitude <br>
time = data timestamps <br>
eps = distance minimum for longitude and latitude <br>           
eps2 =  temporal window <br> 
minpts = number of points to consider a cluster <br> 
cldensity = TRUE or FALSE to display the number of points reachables for every point within a cluster <br>

## OUTPUTS :

data$cluster = cluster number <br>
data$cldensity = cluster points density <br>



