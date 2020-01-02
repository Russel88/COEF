#' Calculate partial Omega-squared (effect-size calculation) for PERMANOVA and add it to the input object
#' 
#' @param adonisOutput An adonis object
#' @return Original adonis object with the partial Omega-squared values added
#' @import vegan
#' @export
adonis_partialOmegaSq <- function(adonisOutput){
    if(!is(adonisOutput, "adonis")) stop("Input should be an adonis object")
    aov_tab <- adonisOutput$aov.tab
    heading <- attr(aov_tab, "heading")
    MS_res <- aov_tab[rownames(aov_tab) == "Residuals", "MeanSqs"]
    N <- aov_tab[rownames(aov_tab) == "Total", "Df"] + 1
    omega <- apply(aov_tab, 1, function(x) (x["Df"]*(x["MeanSqs"]-MS_res))/(x["Df"]*x["MeanSqs"]+(N-x["Df"])*MS_res))
    aov_tab$parOmegaSq <- c(omega[1:(length(omega)-2)], NA, NA)
    cn_order <- c("Df", "SumsOfSqs", "MeanSqs", "F.Model", "R2", "parOmegaSq", "Pr(>F)")
    aov_tab <- aov_tab[, cn_order]
    attr(aov_tab, "names") <- cn_order
    attr(aov_tab, "heading") <- heading
    adonisOutput$aov.tab <- aov_tab
    return(adonisOutput)
}
