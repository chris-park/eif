iso = NULL

.onLoad = function(libname, pkgname) {  
  iso <<- reticulate::import("eif", delay_load = TRUE)
}
