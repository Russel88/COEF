#' Estimate maximum possible Bayes factor from p-value
#' 
#' @param x p-value
#' @return Maximum possible Bayes factor

#' @export
p2bayes <- function(x) {
  -1/(exp(1)*x*log(x))
}
