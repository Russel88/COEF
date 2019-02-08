#' Total Least Squares for ggplot stat_smooth and geom_smooth
#' With bootstrapped confidence intervals
#' 
#' @param formula formula for the tls
#' @param data Input data.frame
#' @param ... Unused argument
#' @import boot
#' @export
tls <- function(formula,data,...){
  M <- model.frame(formula, data)
  d <- prcomp(cbind(M[,2], M[,1]))$rotation
  dfx <- c(mean(M[,1])-mean(M[,2])*(d[2,1]/d[1,1]), d[2,1]/d[1,1])
  
  # Bootstrapped intervals
  bootFun <- function(datax, ind, formula) {
    dx <- datax[ind,]
    Mx <- model.frame(formula, dx)
    dm <- prcomp(cbind(Mx[,2], Mx[,1]))$rotation
    c(mean(Mx[,1])-mean(Mx[,2])*(dm[2,1]/dm[1,1]), dm[2,1]/dm[1,1])
  } 
  bootTls <- boot(data=data, statistic=bootFun, R=1000, formula=formula)
  dfx <- list(dfx,bootTls$t[,1],bootTls$t[,2])
  class(dfx) <- "TLS"
  dfx  
}

#' Internal prediction functions for tls smooth
#' 
#' @param model Input model
#' @param xseq x-values used for prediction
#' @param se Predict error or not
#' @param level Confidence level
#' @export
predictdf.TLS <- function(model, xseq, se, level) {
  pred <- as.numeric(model[[1]] %*% t(cbind(1, xseq)))
  if(se) {
    preds <- sapply(1:length(model[[2]]), function(x) as.numeric(c(model[[2]][x],model[[3]][x]) %*% t(cbind(1, xseq))))
    data.frame(
      x = xseq,
      y = pred,
      ymin = apply(preds, 1, function(x) quantile(x, probs = (1-level)/2)),
      ymax = apply(preds, 1, function(x) quantile(x, probs = 1-((1-level)/2)))
    )
  } else {
    return(data.frame(x = xseq, y = pred))
  }
}
