library(onsr)
library(tidyverse)
library(DHSCcolours)


#' Create chart of job adverts
#'
#' Code downloads job advert data via ONS API then
#' saves a chart of indexed values for 2022 for all
#' industries and healthcare.
#'
#' @export
#'
run_analysis <- function() {
  logger$info("Download data from ONS")
  job_ads <- ons_get(id = "online-job-advert-estimates")
  
  logger$info("Transforming data")
  health_jobs <- job_ads %>%
    filter(
      !is.na(.data$v4_1),
      .data$AdzunaJobsCategory %in% c("Healthcare and Social care", "All industries"),
      .data$Time == 2022
    ) %>%
    mutate(
      week_no = as.numeric(str_extract(.data$Week, "[0-9]+"))
    ) %>%
    arrange(.data$week_no)
  
  logger$info("Creating plot")
  plt <- ggplot() +
    theme_dhsc() +
    theme(
      axis.title.y = element_blank(),
      panel.grid.major.y = element_blank(),
      axis.text.x = element_text(angle = 0, hjust = 0.5)
    ) +
    geom_line(
      data = health_jobs,
      mapping = aes(x = week_no, y = v4_1, colour = AdzunaJobsCategory),
      linewidth = 1
    ) +
    scale_colour_dhsc_d() +
    labs(
      x = "Week No.",
      title = "Adverts by category, indexed and non-deduplicated",
      subtitle = "Values for 2022 and indexed at 100 for average in Feb 2020."
    )
  
  print(plt)
  
  output_chart_path <- file.path("output", "job_advert_chart.svg")
  
  logger$info("Saving to file %s", output_chart_path)
  # save as svg for best resolution
  ggsave(
    plt,
    dpi = 300, width = 12, height = 8, units = "in",
    filename = output_chart_path
  )
}
