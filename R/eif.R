#' @title Extended Isolation Forest
#'
#' @description The \code{eif} function is an R wrapper around the original Python implementation 
#' of the Extended Isolation Forest (Hariri, Kind, Brunner (2018) <arXiv:1811.02141>) algorithm for 
#' anomaly detection, developed by the original authors of the paper. This extension improves the 
#' consistency and reliability of anomaly scores produced by the standard Isolation Forest 
#' (Liu, Ting, Zhou (2008) <doi:10.1109/ICDM.2008.17>). Extended Isolation Forests allows
#' for the slicing of the data to be carried out using hyperplanes with random slopes which 
#' results in improved score maps. 
#'
#' @param X (matrix) A numeric data matrix. 
#' @param ntrees (integer) Number of trees to be used in fitting the forest.
#' @param sample_size (integer) Number of rows to be sub-sampled in creating each tree.
#' This must be less than the number of observations in the dataset.
#' @param ExtensionLevel (integer) Degrees of freedom in choosing the hyperplanes 
#' for dividing up the data. This must be less than the dimension of the dataset. Setting
#' \code{ExtensionLevel = 0} will allow you to fit a standard isolation forest.
#' @return A named list of length two containing the isolation forest (in \code{iforest})
#' and anomaly scores (in \code{scores}).
#' @references \itemize{
#' \item Liu, Ting and Zhou. "Isolation Forest." IEEE International Conference on Data Mining (2008).
#' \item Hariri, Kind and Brunner. "Extended Isolation Forest." arXiv:1811.02141 (2018).
#' }
#' @examples
#' \dontrun{
#' eif(as.matrix(mtcars), ntrees = 10L, sample_size = 5L, ExtensionLevel = 1L)
#' }
#' @export
eif = function(X, ntrees, sample_size, ExtensionLevel) { 
  ## Python check
  if (!reticulate::py_module_available("eif")) {
    stop("Please install the 'eif' Python module by running py_install('eif') or equivalent.")
  }
  
  ## Type checks
  stopifnot(is.matrix(X),
            is.integer(ntrees),
            is.integer(sample_size),
            is.integer(ExtensionLevel))
  
  ## Input checks
  if (ExtensionLevel >= ncol(X)) {
    stop("The degrees of freedom must be less than the dimension of 'X'")
  }
  
  if (sample_size >= nrow(X)) {
    stop("The sample size must be less than the number of observations in 'X'")
  }
  
  if (!all(vapply(X, is.numeric, TRUE))) {
    stop("'X' must be a 'numeric' matrix")
  }
  
  ## Fit isolation forests
  ifor = iso$iForest(X = X, 
                     ntrees = ntrees, 
                     sample_size = sample_size, 
                     ExtensionLevel = ExtensionLevel)
  
  ## Compute scores for each observation in 'X'
  scores = ifor$compute_paths(X_in = X)

  ## Return results in a named list.
  list(iforest = ifor, scores = scores)
}
