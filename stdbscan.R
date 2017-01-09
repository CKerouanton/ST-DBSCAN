stdbscan = function (traj, 
                     x, 
                     y, 
                     time, 
                     eps, 
                     eps2, 
                     minpts, 
                     seeds = FALSE, 
                     cldensity = TRUE,
                     countmode = 1:length(x)) { 
 
  
  data_spatial<- as.matrix(dist(cbind(y, x)))
  data_temporal<- as.matrix(dist(time))
  n <- nrow(data_spatial)
  
  classn <- cv <- integer(n)
  isseed <- logical(n)
  cn <- integer(1)
  
  for (i in 1:n) {
    if (i %in% countmode)
      #cat("Processing point ", i, " of ", n, ".\n")
      unclass <- (1:n)[cv < 1]
    
    if (cv[i] == 0) {
      reachables <- intersect(unclass[data_spatial[i, unclass] <= eps],  unclass[data_temporal[i, unclass] <= eps2])
      if (length(reachables) + classn[i] < minpts)
        cv[i] <- (-1)                    
      else {
        cn <- cn + 1                   
        cv[i] <- cn
        isseed[i] <- TRUE
        reachables <- setdiff(reachables, i)
        unclass <- setdiff(unclass, i)       
        classn[reachables] <- classn[reachables] + 1
        while (length(reachables)) {
          cv[reachables] <- cn           
          ap <- reachables                           
          reachables <- integer()
          
          for (i2 in seq(along = ap)) {
            j <- ap[i2]
            
            jreachables <- intersect(unclass[data_spatial[j, unclass] <= eps], unclass[data_temporal[j, unclass] <= eps2])
            
            if (length(jreachables) + classn[j] >= minpts) {
              isseed[j] <- TRUE
              cv[jreachables[cv[jreachables] < 0]] <- cn
              reachables <- union(reachables, jreachables[cv[jreachables] == 0])
            }
            classn[jreachables] <- classn[jreachables] + 1
            unclass <- setdiff(unclass, j)
          }
        }
      }
    }
    if (!length(unclass))
      break
    
  }
  
  rm(classn)
  if (any(cv == (-1))) {
    cv[cv == (-1)] <- 0
  }
  out <- list(cluster = cv, eps = eps, minpts = minpts, density = classn)
  if (seeds && cn > 0) {
    out$isseed <- isseed
  }
  data$cluster = out$cluster
  if (cldensity > 0) {
    data$cldensity = out$density
  }
  return(data)
  }
