# This function helps to source multiple files which are in the same directory. 
#Providing it with a path, will source all .R files in the directory.
#This can be done recursively.
sourceDirectory <- function(path, recursive = FALSE, local = TRUE) {
  if (!dir.exists(path)) {
    warning(paste(path, "is not a valid directory!"))
    return(NULL)
  }
  
  
  # Source it where function is called (local).
  if (is.logical(local) && local) { env <- parent.frame() }
  
  # Source it in global environment.
  else if (is.logical(local) && !local) { env <- globalenv() }
  
  # Source it in defined environment.
  else if (is.environment(local)) { env <- local }
  else { stop("'local' must be TRUE, FALSE or an environment") }
  
  
  
  files <- list.files(path = path, pattern = ".*\\.R", all.files = F, full.names = TRUE, recursive = recursive)
  for (fileToSource in files) {
    tryCatch(
      {
        source(fileToSource, local = env)
        cat(fileToSource, "sourced.\n")
      },
      
      error = function(cond) {
        message("Loading of file \"", fileToSource, "\" failed.")
        message(cond)
      }
      
    )
  }
}
