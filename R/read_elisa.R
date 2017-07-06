#' Load data from a ELISA plate reader
#'
#' Load excel sheet data from ELISA plate reader (96 Well plates), and add on descriptions of what is in the wells, and output a neat data.frame.
#' The excel file(s) should contain a sheet with OD measurements, and can contain additional sheets with descriptions of what is in the wells, e.g. WT, Contol and so on.
#' The measurements and desciptive sheets should be set up as a 96 Well plate with including A to H and 1 to 12.
#' 
#' @param paths The path(s) for the excel file(s)
#' @param descriptions Number of descriptive sheets. Default 0, i.e. only OD measurements are loaded
#' @return A dataframe with all data. Descriptions are called V1, V2, and so on, in the same order as in the excel sheets.
#' @import readxl
#' @export

read_elisa <- function(paths,descriptions = 0){

  library(readxl)

  read_elisa_sub <- function(path, description){
  
  # Load data
  mat <- as.data.frame(read_excel(path, col_names = FALSE))

  find.rows <- suppressWarnings(apply(mat,2,function(x) x %in% LETTERS[1:8]))
  sub.rows <- suppressWarnings(as.matrix(find.rows[,colSums(find.rows) == 8]))
  if(ncol(sub.rows) != 1) stop("There should only be data from 1 microtiter plate in each excel sheet!")
  
  find.cols <- suppressWarnings(t(apply(mat,1,function(x) as.integer(x) %in% seq(1,12))))
  sub.cols <- suppressWarnings(as.matrix(find.cols[rowSums(find.cols) == 12,]))
  if(ncol(sub.cols) != 1) stop("There should only be data from 1 microtiter plate in each excel sheet!")
  
  mat <- mat[which(sub.rows),which(sub.cols)]
  
  # Load descriptions
  if(descriptions != 0){
    des <- list()
    for(i in 1:description){
      des[[i]] <- as.data.frame(read_excel(path, sheet = i+1, col_names = FALSE))
      
      find.rows.d <- suppressWarnings(apply(des[[i]],2,function(x) x %in% LETTERS[1:8]))
      sub.rows.d <- suppressWarnings(as.matrix(find.rows.d[,colSums(find.rows.d) == 8]))
      if(ncol(sub.rows.d) != 1) stop("There should only be data from 1 microtiter plate in each excel sheet!")
      
      find.cols.d <- suppressWarnings(t(apply(des[[i]],1,function(x) as.integer(x) %in% seq(1,12))))
      sub.cols.d <- suppressWarnings(as.matrix(find.cols.d[rowSums(find.cols.d) == 12,]))
      if(ncol(sub.cols.d) != 1) stop("There should only be data from 1 microtiter plate in each excel sheet!")
      
      des[[i]] <- des[[i]][which(sub.rows.d),which(sub.cols.d)]
      
      # Combine in dataframe
      des.ul <- lapply(des,unlist)
      
      df <- as.data.frame(do.call(cbind,des.ul))
      df$OD <- unlist(mat)
    }
  } else {
    df <- data.frame(OD = unlist(mat))
  }
  
  if(length(paths) > 1) df$Plate <- gsub(".xls","",gsub(".xlsx","",gsub(".*\\/","",path)))
  
  return(df)
}

# Load sheets
dfs <- lapply(paths,function(x) read_elisa_sub(x, descriptions))

dfx <- as.data.frame(do.call(rbind, dfs))
rownames(dfx) <- NULL

return(dfx)
}

