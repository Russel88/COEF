#' Prune taxa in a phyloseq object by group
#'
#' Filter taxa to only include taxa that are present in a certain proportion in each group defined by a variable in sample_data()
#' @param phy phyloseq object
#' @param group Variable in phyloseq object to group by
#' @param P Proportion taxa has to be present in, in each group
#' @return Filtered phyloseq object
#' @export
prune_by_group <- function(phy, group, P = 0.5){

    grs <- sample_data(phy)[, group][[1]]
    grsu <- unique(grs)

    these <- list()
    for(i in seq_along(grsu)){
        subotu <- otu_table(phy)[, grs == grsu[i]]
        subcount <- apply(subotu, 1, function(x) sum(x > 0))
        these[[i]] <- names(subcount[subcount >= ceiling(sum(grs == grsu[i])*P)])
    }

    this <- unique(do.call(c, these))
    phynew <- prune_taxa(this, phy)
    return(phynew)
}
