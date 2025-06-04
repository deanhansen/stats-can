## ...
create_r_project <- function() {
  
  ## ...
  project_name <- readline(prompt = "Enter the sub-folder you'd like to create: ")
  project_name <- as.character(project_name)
  
  # Create the main project directory
  main_dir <- file.path(getwd(), "R", project_name)
  dir.create(main_dir)
  cat(paste("Created project directory:", main_dir, "\n"))
  
  # Define the files you want to create
  project_name_ <- sub(pattern = "-", replacement = "_", x = project_name)
  files <- paste0(project_name_, "_", c("data.R", "plot.R"))
  
  # Create the files within the project directory
  for (file in files) {
    file_to_create <- file.path(main_dir, file)
    file.create(file_to_create)
    cat(paste("Created file:", file_to_create, "\n"))
  }
  
  ## Add some default packages
  lines_data <- c(
    "library('statcanR')",
    "library('dplyr')",
    "library('readr')"
    )
  
  ## Add some default packages
  lines_plot <- c(
    "library('readr')",
    "library('dplyr')",
    "library('tidyr')",
    "library('ggplot2')",
    "library('scales')",
    "library('ggview')"
    )
  
  ## ...
  file_paths <- list.files(path = sprintf("R/%s/", project_name), full.names = TRUE, pattern = "\\.R")
  writeLines(lines_data, file_paths[1])
  writeLines(lines_plot, file_paths[2])
  
  cat(paste0("\nProject `", project_name, "` created successfully!"))

}
