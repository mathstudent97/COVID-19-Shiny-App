# The point of this script is to point towards directories
# So to extract other functions in a good way
# Will write functions that will help source multiple files that
# are in the same directory 

sourceDirectory <- function(path){
  if(!dir.path(path)){
    warning(paste(path, " is not a valid path !!! "))
    return(NULL) # just get out of this function
  }
  
  env <- parent.frame()
  files <- list.files(path = path, pattern = ".*\\.R", 
                      all.files = F, full.names = TRUE,
                      recursive = FALSE)
  for(aFile in files){
    tryCatch(
      {
        source(aFile, local = env)
        cat(aFile, " is sourced !! ")
      },
      error = function(cond){
        message("Failed loading the following file \" ", aFile,
                "\" .")
        message(cond)
      }
    )
  }
  
}
# Basically the purpose of above function will specify the source
# directory and specify the correct path to read the files that I
# will write from
# First, test if the path I inputted is actually a path if it exists
# So if not, I will throw in a warning saying that this path
# is not valid (line 8-10)
# (Line 12) - set environment to the parent frame
# (Line 13) - files, will extract them from this method called list
# path is what was inputted; pattern...
# (Line 16) - loop in every file; 'afile' in list of files...
# (Line 20) - concatencate the file is sourced
# (Line 22) - if there's some error...
# (Line 23) - throw the condition; what condition I got from the error
 