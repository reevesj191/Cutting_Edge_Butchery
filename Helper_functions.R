################################################################################
# Title: Analysis and Visualization Functions associated with the paper entitled:
# Modern stone tool users from Northern Kenya emphasize mass and edge length in the selection of cutting tools.
# Published in Proceedings of the Royal Society B
# Author: Jonathan S. Reeves
# Last Update: 26.4.2024
################################################################################
require(rethinking)
require(ggplot2)
require(dplyr)

PostPredPlot_pordlogit <- function(model, sim, var){
  
  phi <- link(model, data = sim)
  post <- extract.samples(model)
  
  for(s in 1:50){
    
    pk <- pordlogit(1:3,
                    phi[s,],
                    post$cutpoints[s,])
    
    for(i in 1:3){
      lines(var, pk[,i], col = col.alpha(cols[i],.3))
    }
  }
}



ggPostPredPlot_pordlogit <- function(model,
                                     sim, 
                                     var,
                                     n_samples = 50, 
                                     cols = NULL, 
                                     opac = .5, 
                                     wide = FALSE){
  
  phi <- link(model, data = sim)
  post <- extract.samples(model)
  
  post_list <- list()
  for(i in 1:n_samples){
    pk <- pordlogit(1:3,
                    phi[i,],
                    post$cutpoints[i,])
    pk <- as.data.frame(pk)
    pk$i <- i
    pk$var <- var
    post_list[[i]] <- pk
  }
  
  df <- do.call(rbind, post_list)
  
  post_sum <- as.data.frame(matrix(ncol = 0, nrow=nrow(sim_dat)))   
  
  V1 <- lapply(post_list, function(df) df[[1]])
  V1 <- as.data.frame(do.call(cbind, V1))
  
  post_sum$V1_mean <- rowMeans(V1)
  post_sum$V1_L_95 <- apply(V1,MARGIN = 1, HPDI)[1,]
  post_sum$V1_U_95 <- apply(V1,MARGIN = 1, HPDI)[2,]
  
  V2 <- lapply(post_list, function(df) df[[2]])
  V2 <- as.data.frame(do.call(cbind, V2))
  
  post_sum$V2_mean <- rowMeans(V2)
  post_sum$V2_L_95 <- apply(V2,MARGIN = 1, HPDI)[1,]
  post_sum$V2_U_95 <- apply(V2,MARGIN = 1, HPDI)[2,]
  
  
  V3 <- lapply(post_list, function(df) df[[3]])
  V3 <- as.data.frame(do.call(cbind, V3))
  
  post_sum$V3_mean <- rowMeans(V3)
  post_sum$V3_L_95 <- apply(V3,MARGIN = 1, HPDI)[1,]
  post_sum$V3_U_95 <- apply(V3,MARGIN = 1, HPDI)[2,]
  
  post_sum$var <- var
  
  # Plots 
  if(is.null(cols)){
    cols <- c( "#B40F20",
               "#DD8D29",
               "#E2D200",
               "#46ACC8")
  }
  
  sum_plot <- ggplot(data = post_sum, aes(x = var))+
    # Stage Space
    geom_ribbon(aes(min = 0, max = V1_mean, fill = "Stage 1"))+
    geom_ribbon(aes(min = V1_mean, max = V2_mean, fill = "Stage 2"))+
    geom_ribbon(aes(min = V2_mean, max = V3_mean, fill = "Stage 3"))+
    geom_ribbon(aes(min = V3_mean, max = 1, fill = "Stage 4"))+
    
    # mean lines
    geom_line(aes(y = V1_mean), color = "white", size =1.25)+
    geom_line(aes(y = V2_mean), color = "white", size =1.25)+
    geom_line(aes(y = V3_mean), color = "white", size =1.25)+
    
    #Upper 89%
    
    geom_line(aes(y = V1_U_95), color = "white", size =.75, linetype = "dashed")+
    geom_line(aes(y = V2_U_95), color = "white", size =.75, linetype = "dashed")+
    geom_line(aes(y = V3_U_95), color = "white", size =.75, linetype = "dashed")+
    #Lower 89%
    geom_line(aes(y = V1_L_95), color = "white", size =.75, linetype = "dashed")+
    geom_line(aes(y = V2_L_95), color = "white", size =.75, linetype = "dashed")+
    geom_line(aes(y = V3_L_95), color = "white", size =.75, linetype = "dashed")+
    scale_y_continuous(limits = c(0,1))+
    theme_bw()
  
  p <- ggplot(data = df) + 
    geom_line(aes(x = var, y = V1, group = i), color = cols[1], alpha = opac)+
    geom_line(aes(x = var, y = V2, group = i), color = cols[2], alpha = opac)+
    geom_line(aes(x = var, y = V3,group = i),color = cols[3], alpha = opac) + 
    scale_y_continuous(limits = c(0,1))
  dat <- list(plot = p, sum_plot=sum_plot, data = df, sum_data = post_sum)
  return(dat)
}

