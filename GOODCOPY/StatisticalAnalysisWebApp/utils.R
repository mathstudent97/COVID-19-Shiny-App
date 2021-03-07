# The function below helps to source multiple files that are in the same directory. 
#With provided path, all selected ".R" files in the directory will be sourced. 
#Can be done recursively or not.


sourceDirectory <- function(path, recursive = FALSE, local = TRUE) {
  if (!dir.exists(path)) {
    warning(paste(path, "is not a valid path!"))
    return(NULL) # Just get out of fcn.
  }
  
  # Source it where the function is called (local).
  if (is.logical(local) && local) { env <- parent.frame() }
    # Source it in global environment.
  else if (is.logical(local) && !local) { env <- globalenv() }
    # Source it in defined environment.
  else if (is.environment(local)) { env <- local }
  else { stop("'local' must be TRUE, FALSE or an environment") }
  
  files <- list.files(path = path, pattern = ".*\\.R", all.files = F, full.names = TRUE, recursive = recursive)
  # Loop in every file.
  for (aFile in files) {
    tryCatch(
      {
        source(aFile, local = env)
        cat(aFile, "is sourced!")
        # Concatentate a file is sourced.
      },
      
        error = function(cond) {
          message("Loading the following file \" ", aFile, "\" failed.")
          message(cond)
        }
      
    )
  }
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
