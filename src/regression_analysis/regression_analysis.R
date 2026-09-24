# Regression analysis: session duration and videos viewed

install.packages("fixest")
# %%

library(tidyverse)
library(here)
library(fixest)

# Load packages required for data preparation, visualisation, and fixed-effects regression.


# %%

session_path <- here(
  "data",
  "processed",
  "cleaned_sessions.csv"
)

sessions <- read_csv(
  session_path,
  show_col_types = FALSE
)

glimpse(sessions)

# Load the cleaned session-level dataset and inspect its structure.


# %%

data_check <- sessions %>%
  summarise(
    total_sessions = n(),

    unique_sessions =
      n_distinct(session_id),

    unique_users =
      n_distinct(user_id),

    missing_session_duration =
      sum(is.na(session_duration_sec)),

    missing_videos_viewed =
      sum(is.na(videos_viewed)),

    missing_user_id =
      sum(is.na(user_id)),

    missing_login_time =
      sum(is.na(login_at)),

    zero_session_duration =
      sum(
        session_duration_sec == 0,
        na.rm = TRUE
      ),

    zero_videos_viewed =
      sum(
        videos_viewed == 0,
        na.rm = TRUE
      ),

    negative_session_duration =
      sum(
        session_duration_sec < 0,
        na.rm = TRUE
      ),

    negative_videos_viewed =
      sum(
        videos_viewed < 0,
        na.rm = TRUE
      )
  )

print(
  data_check,
  width = Inf
)

# Check the completeness and validity of variables needed for the regression.


# %%

model_data <- sessions %>%
  mutate(
    login_datetime =
      as.POSIXct(
        login_at,
        tz = "UTC"
      ),

    login_hour =
      as.integer(
        format(
          login_datetime,
          "%H"
        )
      )
  ) %>%
  filter(
    !is.na(session_duration_sec),
    !is.na(videos_viewed),
    !is.na(user_id),
    !is.na(login_datetime),
    session_duration_sec >= 0,
    videos_viewed >= 0
  ) %>%
  mutate(
    log_session_duration =
      log1p(session_duration_sec),

    log_videos_viewed =
      log1p(videos_viewed)
  )

nrow(model_data)

# Construct the modelling sample and create the transformed regression variables.


# %%

sample_summary <- model_data %>%
  summarise(
    observations = n(),

    unique_users =
      n_distinct(user_id),

    median_session_duration_sec =
      median(session_duration_sec),

    mean_session_duration_sec =
      mean(session_duration_sec),

    median_videos_viewed =
      median(videos_viewed),

    mean_videos_viewed =
      mean(videos_viewed)
  )

print(
  sample_summary,
  width = Inf
)

# Summarise the size and basic characteristics of the modelling sample.


# %%

descriptive_statistics <- tibble(
  variable = c(
    "Session duration (seconds)",
    "Videos viewed",
    "Login hour (UTC)"
  ),

  n = c(
    sum(!is.na(model_data$session_duration_sec)),
    sum(!is.na(model_data$videos_viewed)),
    sum(!is.na(model_data$login_hour))
  ),

  mean = c(
    mean(model_data$session_duration_sec),
    mean(model_data$videos_viewed),
    mean(model_data$login_hour)
  ),

  median = c(
    median(model_data$session_duration_sec),
    median(model_data$videos_viewed),
    median(model_data$login_hour)
  ),

  sd = c(
    sd(model_data$session_duration_sec),
    sd(model_data$videos_viewed),
    sd(model_data$login_hour)
  ),

  min = c(
    min(model_data$session_duration_sec),
    min(model_data$videos_viewed),
    min(model_data$login_hour)
  ),

  max = c(
    max(model_data$session_duration_sec),
    max(model_data$videos_viewed),
    max(model_data$login_hour)
  )
)

print(
  descriptive_statistics,
  width = Inf
)

# Summarise the central tendency and spread of the main analysis variables.


# %%

duration_distribution_plot <- ggplot(
  model_data,
  aes(
    x = log_session_duration
  )
) +
  geom_histogram(
    bins = 40
  ) +
  labs(
    title = "Distribution of Session Duration",
    subtitle = "Displayed on the log-transformed scale used in the regression",
    x = "Log(1 + Session Duration in Seconds)",
    y = "Number of Sessions"
  ) +
  theme_minimal()


# Show the distribution of session duration on the transformed regression scale.


# %%

relationship_plot <- ggplot(
  model_data,
  aes(
    x = log_session_duration,
    y = log_videos_viewed
  )
) +
  geom_point(
    alpha = 0.05
  ) +
  geom_smooth(
    method = "lm",
    se = TRUE
  ) +
  labs(
    title = "Session Duration and Videos Viewed",
    subtitle = "Raw association before accounting for time of day and user differences",
    x = "Log(1 + Session Duration in Seconds)",
    y = "Log(1 + Videos Viewed)"
  ) +
  theme_minimal()


# Visualise the raw relationship between session duration and videos viewed.


# %%

hourly_summary <- model_data %>%
  group_by(
    login_hour
  ) %>%
  summarise(
    number_of_sessions = n(),

    average_videos_viewed =
      mean(
        videos_viewed,
        na.rm = TRUE
      ),

    median_videos_viewed =
      median(
        videos_viewed,
        na.rm = TRUE
      ),

    .groups = "drop"
  )

print(
  hourly_summary,
  n = Inf
)

# Summarise video viewing across different session start times.


# %%

time_of_day_plot <- ggplot(
  hourly_summary,
  aes(
    x = login_hour,
    y = average_videos_viewed
  )
) +
  geom_line() +
  geom_point() +
  scale_x_continuous(
    breaks = 0:23
  ) +
  labs(
    title = "Average Videos Viewed by Session Start Time",
    subtitle = "Session start times are measured in UTC",
    x = "Login Hour (UTC)",
    y = "Average Videos Viewed"
  ) +
  theme_minimal()


# Explore whether session engagement differs across different times of day.


# %%

model_1 <- feols(
  log_videos_viewed ~
    log_session_duration,
  data = model_data,
  vcov = ~ user_id
)

summary(model_1)

# Model 1 estimates the unadjusted association with standard errors clustered by user.


# %%

model_2 <- feols(
  log_videos_viewed ~
    log_session_duration +
    i(login_hour),
  data = model_data,
  vcov = ~ user_id
)

summary(model_2)

# Model 2 adds time-of-day controls while retaining user-clustered standard errors.


# %%

model_3 <- feols(
  log_videos_viewed ~
    log_session_duration +
    i(login_hour) |
    user_id,
  data = model_data,
  vcov = ~ user_id
)

summary(model_3)

# Model 3 efficiently absorbs user fixed effects and clusters standard errors by user.


# %%

extract_model_effect <- function(
  fitted_model,
  model_name
) {

  coefficient_table <- coeftable(
    fitted_model
  )

  coefficient <- coefficient_table[
    "log_session_duration",
  ]

  tibble(
    model = model_name,

    estimate =
      unname(
        coefficient["Estimate"]
      ),

    clustered_std_error =
      unname(
        coefficient["Std. Error"]
      ),

    p_value =
      unname(
        coefficient["Pr(>|t|)"]
      ),

    observations =
      nobs(fitted_model),

    adjusted_r_squared =
      unname(
        r2(
          fitted_model,
          "ar2"
        )
      )
  )
}

# Extract the main coefficient and user-clustered inference from each model.


# %%

model_comparison <- bind_rows(
  extract_model_effect(
    model_1,
    "Model 1: Baseline"
  ),

  extract_model_effect(
    model_2,
    "Model 2: + Time of day"
  ),

  extract_model_effect(
    model_3,
    "Model 3: + User fixed effects"
  )
) %>%
  mutate(
    time_of_day_control = c(
      "No",
      "Yes",
      "Yes"
    ),

    user_fixed_effects = c(
      "No",
      "No",
      "Yes"
    ),

    ci_lower =
      estimate -
      1.96 * clustered_std_error,

    ci_upper =
      estimate +
      1.96 * clustered_std_error
  )

print(
  model_comparison,
  width = Inf
)

# Compare the main coefficient across the three regression specifications.


# %%

coefficient_plot <- ggplot(
  model_comparison,
  aes(
    x = model,
    y = estimate
  )
) +
  geom_point(
    size = 3
  ) +
  geom_errorbar(
    aes(
      ymin = ci_lower,
      ymax = ci_upper
    ),
    width = 0.15
  ) +
  geom_hline(
    yintercept = 0,
    linetype = "dashed"
  ) +
  labs(
    title = "Estimated Association Across Regression Models",
    subtitle = "95% confidence intervals use standard errors clustered by user",
    x = NULL,
    y = "Coefficient on Log Session Duration"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(
      angle = 20,
      hjust = 1
    )
  )


# Visualise how the association changes after time controls and user fixed effects are added.


# %%

final_result <- coeftable(
  model_3
)[
  "log_session_duration",
]

print(
  final_result
)

# Report clustered statistical inference for the main coefficient in the final model.


# %%

diagnostic_data <- tibble(
  fitted_values =
    fitted(model_3),

  residuals =
    resid(model_3)
)

# Extract fitted values and residuals from the final fixed-effects model.

# %%

set.seed(123)

diagnostic_plot_data <- diagnostic_data %>%
  slice_sample(
    n = min(
      20000,
      nrow(diagnostic_data)
    )
  )

# Use a reproducible random subset for diagnostic plotting to keep large plots efficient.


# %%

residual_plot <- ggplot(
  diagnostic_plot_data,
  aes(
    x = fitted_values,
    y = residuals
  )
) +
  geom_point(
    alpha = 0.08
  ) +
  geom_smooth(
    method = "lm",
    se = FALSE
  ) +
  geom_hline(
    yintercept = 0,
    linetype = "dashed"
  ) +
  labs(
    title = "Residuals vs Fitted Values",
    subtitle = "Diagnostic plot based on a random sample of model residuals",
    x = "Fitted Values",
    y = "Residuals"
  ) +
  theme_minimal()


# Inspect residual patterns in the final fixed-effects model.


# %%

qq_plot <- ggplot(
  diagnostic_plot_data,
  aes(
    sample = residuals
  )
) +
  stat_qq(
    alpha = 0.15
  ) +
  stat_qq_line() +
  labs(
    title = "Q-Q Plot of Regression Residuals",
    subtitle = "Diagnostic plot based on a random sample of model residuals",
    x = "Theoretical Quantiles",
    y = "Sample Quantiles"
  ) +
  theme_minimal()


# Inspect the residual distribution of the final fixed-effects model.


# %%

output_dir <- here(
  "output",
  "regression"
)

dir.create(
  output_dir,
  recursive = TRUE,
  showWarnings = FALSE
)

# Create the output directory if it does not already exist.


# %%

ggsave(
  filename = here(
    "output",
    "regression",
    "session_duration_distribution.png"
  ),
  plot = duration_distribution_plot,
  width = 8,
  height = 5
)

ggsave(
  filename = here(
    "output",
    "regression",
    "session_duration_vs_videos.png"
  ),
  plot = relationship_plot,
  width = 8,
  height = 5
)

ggsave(
  filename = here(
    "output",
    "regression",
    "videos_viewed_by_login_hour.png"
  ),
  plot = time_of_day_plot,
  width = 8,
  height = 5
)

ggsave(
  filename = here(
    "output",
    "regression",
    "model_coefficient_comparison.png"
  ),
  plot = coefficient_plot,
  width = 8,
  height = 5
)

ggsave(
  filename = here(
    "output",
    "regression",
    "residuals_vs_fitted.png"
  ),
  plot = residual_plot,
  width = 8,
  height = 5
)

ggsave(
  filename = here(
    "output",
    "regression",
    "residual_qq_plot.png"
  ),
  plot = qq_plot,
  width = 8,
  height = 5
)

# Save the main regression and diagnostic figures.


# %%

write_csv(
  descriptive_statistics,
  here(
    "output",
    "regression",
    "descriptive_statistics.csv"
  )
)

write_csv(
  hourly_summary,
  here(
    "output",
    "regression",
    "hourly_summary.csv"
  )
)

write_csv(
  model_comparison,
  here(
    "output",
    "regression",
    "model_comparison.csv"
  )
)

# Save the descriptive and regression result tables for the final report.