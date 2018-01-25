#' Total Least Squares for ggplot stat_smooth and geom_smooth
#' 
#' @export
tls <- function(formula,data,...){
  M <- model.frame(formula, data)
  d <- prcomp(cbind(M[,2], M[,1]))$rotation
  df <- c(mean(M[,1])-mean(M[,2])*(d[2,1]/d[1,1]), d[2,1]/d[1,1])
  class(df) <- "TLS"
  df  
}

#' @export
predictdf.TLS <- function(model, xseq, se, level) {
  pred <- model %*% t(cbind(1, xseq))
  data.frame(x = xseq, y = c(pred))
}