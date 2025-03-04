#AQI
# Load necessary libraries
library(readr)
library(caret)
library(dplyr)
library(ggplot2)
library(dplyr)
library(caTools)
library(e1071)
library(party)
library(rpart)
library(rpart.plot)
library(randomForest)
library(ggplot2)
library(glmnet)
library(tidyr)
library(forecast)


library(readr)
station_day <- read_csv("path_of_df")
View(station_day)
data<-(station_day)
data

#Exploratory Data Analysis(EDA)

#veiw structure 
str(data)

#missing values
summary(data)

# Check for missing values by row/column
sum(is.na(data))

# Explore unique values in categorical variables
unique(data$StationId)
unique(data$StationName)
unique(data$Date)

# For simplicity, let's remove rows with missing values
data <- na.omit(data)

# Plotting time series for PM2.5 levels
ggplot(data, aes(x = Date, y = PM2.5)) +
  geom_line() +
  ggtitle("Time Series of PM2.5 Levels")

# Plotting time series for PM10 levels
ggplot(data, aes(x = Date, y = PM10)) +
  geom_line() +
  ggtitle("Time Series of PM10 Levels")

# Plotting time series for NO2 levels
ggplot(data, aes(x = Date, y = NO2)) +
  geom_line() +
  ggtitle("Time Series of NO2 Levels")

# Plotting time series for SO2 levels
ggplot(data, aes(x = Date, y = SO2)) +
  geom_line() +
  ggtitle("Time Series of SO2 Levels")

# Plotting time series for CO levels
ggplot(data, aes(x = Date, y = CO)) +
  geom_line() +
  ggtitle("Time Series of CO Levels")

# Plotting time series for O3 levels
ggplot(data, aes(x = Date, y = O3)) +
  geom_line() +
  ggtitle("Time Series of O3 Levels")

dim(data)
colnames(data)

#Modelling 

# Split the dataset into predictors (X) and target (y)
X <- select(data, -PM2.5)  # Predictors
y <- data$PM2.5             # Target

# Split the dataset into training and testing sets
set.seed(123)
train_index <- createDataPartition(y, p = 0.8, list = FALSE)
train_data <- data[train_index, ]
test_data <- data[-train_index, ]

# Multiple Linear Regression
lm_model <- lm(PM2.5 ~ ., data = train_data)
lm_pred <- predict(lm_model, newdata = test_data)
lm_rmse <- sqrt(mean((test_data$PM2.5 - lm_pred)^2))
cat("Multiple Linear Regression RMSE:", lm_rmse, "\n")

# Decision Tree
dt_model <- rpart(PM2.5 ~ ., data = train_data)
dt_pred <- predict(dt_model, newdata = test_data)
dt_rmse <- sqrt(mean((test_data$PM2.5 - dt_pred)^2))
cat("Decision Tree RMSE:", dt_rmse, "\n")

# Random Forest
rf_model <- randomForest(PM2.5 ~ ., data = train_data)
rf_pred <- predict(rf_model, newdata = test_data)
rf_rmse <- sqrt(mean((test_data$PM2.5 - rf_pred)^2))
cat("Random Forest RMSE:", rf_rmse, "\n")

# Lasso Regression
lasso_model <- glmnet(as.matrix(select(train_data, -PM2.5)), train_data$PM2.5, alpha = 1)
lasso_pred <- predict(lasso_model, s = 0.01, newx = as.matrix(select(test_data, -PM2.5)))
lasso_rmse <- sqrt(mean((test_data$PM2.5 - lasso_pred)^2))
cat("Lasso Regression RMSE:", lasso_rmse, "\n")

# Polynomial Regression
poly_model <- lm(PM2.5 ~ poly(NO2, 2) + poly(SO2, 2) + poly(CO, 2) + poly(O3, 2), data = train_data)
poly_pred <- predict(poly_model, newdata = test_data)
poly_rmse <- sqrt(mean((test_data$PM2.5 - poly_pred)^2))
cat("Polynomial Regression RMSE:", poly_rmse, "\n")

# Create a dataframe to store results
results <- data.frame(
  Model = c("Multiple Linear", "Decision Tree", "Random Forest", "Lasso Regression", "Polynomial"),
  RMSE = c(lm_rmse, dt_rmse, rf_rmse, lasso_rmse, poly_rmse)
)

# Plotting RMSE for different models
ggplot(results, aes(x = Model, y = RMSE)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  labs(title = "Root Mean Square Error (RMSE) of Different Models",
       x = "Model", y = "RMSE") +
  theme_minimal()

# Define model predictions
model_predictions <- list(
  lm = predict(lm_model, newdata = data),
  dt = predict(dt_model, newdata = data),
  rf = predict(rf_model, newdata = data),
  lasso = predict(lasso_model, s = 0.01, newx = as.matrix(select(data, -PM2.5))),
  poly = predict(poly_model, newdata = data)
)

# Bind model predictions to the original data
data <- cbind(data, sapply(model_predictions, as.vector))

# Plotting AQI over the years for each model
data_long <- tidyr::pivot_longer(data, starts_with("X"), names_to = "Model", values_to = "Predicted_PM2.5")

ggplot(data_long, aes(x = Date, y = Predicted_PM2.5, color = Model)) +
  geom_line() +
  labs(title = "Predicted AQI Over the Years for Different Models",
       x = "Date", y = "Predicted AQI") +
  theme_minimal()

# Plotting time series of AQI for each model
data_long <- tidyr::pivot_longer(data, starts_with("X"), names_to = "Model", values_to = "Predicted_PM2.5")

ggplot(data_long, aes(x = Date, y = Predicted_PM2.5, color = Model)) +
  geom_line() +
  labs(title = "Predicted AQI Over the Years for Different Models",
       x = "Date", y = "Predicted AQI") +
  theme_minimal()

# Scatter plot of observed vs. predicted AQI for each model
ggplot(data, aes(x = PM2.5, y = lm)) +
  geom_point(color = "blue") +
  geom_abline(slope = 1, intercept = 0, color = "red") +
  labs(title = "Observed vs. Predicted AQI (Multiple Linear Regression)",
       x = "Observed AQI", y = "Predicted AQI") +
  theme_minimal()

# Scatter plot of observed vs. predicted AQI for Decision Tree model
ggplot(data, aes(x = PM2.5, y = dt)) +
  geom_point(color = "blue") +
  geom_abline(slope = 1, intercept = 0, color = "red") +
  labs(title = "Observed vs. Predicted AQI (Decision Tree)",
       x = "Observed AQI", y = "Predicted AQI") +
  theme_minimal()

# Scatter plot of observed vs. predicted AQI for Lasso Regression model
ggplot(data, aes(x = PM2.5, y = lasso)) +
  geom_point(color = "blue") +
  geom_abline(slope = 1, intercept = 0, color = "red") +
  labs(title = "Observed vs. Predicted AQI (Lasso Regression)",
       x = "Observed AQI", y = "Predicted AQI") +
  theme_minimal()

# Scatter plot of observed vs. predicted AQI for Random Forest model
ggplot(data, aes(x = PM2.5, y = rf)) +
  geom_point(color = "blue") +
  geom_abline(slope = 1, intercept = 0, color = "red") +
  labs(title = "Observed vs. Predicted AQI (Random Forest)",
       x = "Observed AQI", y = "Predicted AQI") +
  theme_minimal()

# Scatter plot of observed vs. predicted AQI for Polynomial Regression model
ggplot(data, aes(x = PM2.5, y = poly)) +
  geom_point(color = "blue") +
  geom_abline(slope = 1, intercept = 0, color = "red") +
  labs(title = "Observed vs. Predicted AQI (Polynomial Regression)",
       x = "Observed AQI", y = "Predicted AQI") +
  theme_minimal()

# Define the predictions for each model
all_predictions <- list(
  "lm" = lm_pred,
  "dt" = dt_pred,
  "rf" = rf_pred,
  "lasso" = lasso_pred,
  "poly" = poly_pred
)

# Create a list of combinations of models
model_combinations <- list(
  c("lm"),
  c("dt"),
  c("rf"),
  c("lasso"),
  c("poly"),
  c("lm", "dt"),
  c("lm", "rf"),
  c("lm", "lasso"),
  c("lm", "poly"),
  c("dt", "rf"),
  c("dt", "lasso"),
  c("dt", "poly"),
  c("rf", "lasso"),
  c("rf", "poly"),
  c("lasso", "poly"),
  c("lm", "dt", "rf"),
  c("lm", "dt", "lasso"),
  c("lm", "dt", "poly"),
  c("lm", "rf", "lasso"),
  c("lm", "rf", "poly"),
  c("lm", "lasso", "poly"),
  c("dt", "rf", "lasso"),
  c("dt", "rf", "poly"),
  c("dt", "lasso", "poly"),
  c("rf", "lasso", "poly"),
  c("lm", "dt", "rf", "lasso"),
  c("lm", "dt", "rf", "poly"),
  c("lm", "dt", "lasso", "poly"),
  c("lm", "rf", "lasso", "poly"),
  c("dt", "rf", "lasso", "poly"),
  c("lm", "dt", "rf", "lasso", "poly")
)

# Calculate RMSE for each model combination and store in a vector
ensemble_rmse <- numeric(length(model_combinations))
ensemble_models <- character(length(model_combinations))
for (i in seq_along(model_combinations)) {
  models <- model_combinations[[i]]
  ensemble_predictions <- rowMeans(do.call(cbind, all_predictions[models]))
  ensemble_rmse[i] <- sqrt(mean((test_data$PM2.5 - ensemble_predictions)^2))
  ensemble_models[i] <- paste(models, collapse = ", ")
}

# Create a data frame with ensemble models and their RMSE
ensemble_results <- data.frame(Ensemble_Model = ensemble_models, RMSE = ensemble_rmse)

# Print all ensemble models with their RMSE values
ensemble_results

# Find the index of the best performing ensemble model
best_index <- which.min(ensemble_rmse)

# Print the best performing ensemble model and its RMSE
cat("Best Performing Ensemble Model:", ensemble_models[best_index], "\n")
cat("RMSE:", ensemble_rmse[best_index], "\n")

# Create a data frame with ensemble models and their RMSE
ensemble_results <- data.frame(Ensemble_Model = ensemble_models, RMSE = ensemble_rmse)

# Plotting RMSE values
ggplot(ensemble_results, aes(x = Ensemble_Model, y = RMSE)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  labs(title = "RMSE of Ensemble Models",
       x = "Ensemble Model", y = "RMSE") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

# Find the row with the minimum RMSE
best_model_row <- ensemble_results[which.min(ensemble_results$RMSE), ]

# Plotting RMSE values with best model highlighted
ggplot(ensemble_results, aes(x = Ensemble_Model, y = RMSE, fill = Ensemble_Model)) +
  geom_bar(stat = "identity", color = "black") +
  geom_bar(data = best_model_row, aes(x = Ensemble_Model, y = RMSE), stat = "identity", fill = "orange", color = "black") +
  labs(title = "RMSE of Ensemble Models",
       x = "Ensemble Model", y = "RMSE") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

#detecting high Air Quality Index (AQI) over the years

# Convert Date to proper date format
data$Date <- as.Date(data$Date, format = "%Y-%m-%d")
# Filter out missing values
data <- na.omit(data)

# EDA: Explore distribution of AQI values over the years
ggplot(data, aes(x = Date, y = AQI)) +
  geom_line() +
  labs(title = "AQI Over the Years",
       x = "Year", y = "AQI")

# Identify threshold for "high" AQI levels (e.g., based on regulatory standards)
threshold <- 200  # Example threshold value

# Detection: Identify instances where AQI exceeds the threshold
high_aqi <- data %>% filter(AQI > threshold)

# Visualization: Visualize high AQI instances over the years
ggplot(high_aqi, aes(x = Date, y = AQI)) +
  geom_point(color = "red") +
  labs(title = "High AQI Instances Over the Years",
       x = "Year", y = "AQI")

# Define function to categorize AQI levels
categorize_AQI <- function(AQI) {
  if (AQI >= 0 & AQI <= 50) {
    return("Good")
  } else if (AQI <= 100) {
    return("Moderate")
  } else if (AQI <= 150) {
    return("Unhealthy for Sensitive Groups")
  } else if (AQI <= 200) {
    return("Unhealthy")
  } else if (AQI <= 300) {
    return("Very Unhealthy")
  } else {
    return("Hazardous")
  }
}

# Create new column for AQI category
data$AQI_Category <- sapply(data$AQI, categorize_AQI)

# Visualization: Visualize AQI categories over the years
ggplot(data, aes(x = Date, fill = AQI_Category)) +
  geom_histogram(binwidth = 10, color = "black") +
  scale_fill_manual(values = c("Good" = "green", 
                               "Moderate" = "yellow", 
                               "Unhealthy for Sensitive Groups" = "orange", 
                               "Unhealthy" = "red", 
                               "Very Unhealthy" = "violet", 
                               "Hazardous" = "maroon")) +
  labs(title = "Distribution of AQI Categories",
       x = "Year", y = "Frequency") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

#"frequency" refers to the number of data points (or observations) falling within each bin of the histogram.

# Create a table of counts for each AQI category
category_counts <- table(single_year_data$AQI_Category)

# Calculate the count of each AQI category
aqi_counts <- table(data$AQI_Category)

# Create a pie chart
pie(aqi_counts, 
    labels = c("Good", "Moderate", "Unhealthy for Sensitive Groups", "Unhealthy", "Very Unhealthy", "Hazardous"), 
    col = c("green", "yellow", "orange", "red", "violet", "maroon"),
    main = "Distribution of AQI Categories")


# Convert Date column to year
data$Year <- as.integer(format(data$Date, "%Y"))

# Create a list to store pie charts for each year
pie_charts <- list()

# Iterate over each year
for (year in unique(data$Year)) {
  # Subset data for the current year
  year_data <- subset(data, Year == year)
  
  # Calculate the count of each AQI category for the current year
  aqi_counts <- table(year_data$AQI_Category)
  
  # Create a pie chart for the current year and store it in the list
  pie_charts[[as.character(year)]] <- pie(aqi_counts, 
                                          labels = c("Good", "Moderate", "Unhealthy for Sensitive Groups", "Unhealthy", "Very Unhealthy", "Hazardous"), 
                                          col = c("green", "yellow", "orange", "red", "violet", "maroon"),
                                          main = paste("Distribution of AQI Categories - Year", year))
}

# Show all pie charts
par(mfrow = c(3, 3))  # Adjust the layout based on the number of years if needed
for (i in seq_along(pie_charts)) {
  print(pie_charts[[i]])
}

#Forecasting

# Convert Date column to Date type
data$Date <- as.Date(data$Date)

colnames(data)

# Convert AQI column to numeric
data$AQI_Category <- as.numeric(data$AQI)

# Convert data to time series object
ts_data <- ts(data$AQI_Category, frequency = 365.25/7, start = c(2015, 1))

# Check the structure of ts_data
str(ts_data)
summary(ts_data)

# Fit ARIMA model
arima_model <- arima(ts_data, order = c(1,1,1))

# Forecast
forecast_values <- forecast(arima_model, h = 12)  #Example forecast for next 12 time periods
# Plot forecast
plot(forecast_values, main = "AQI Forecast", xlab = "Date", ylab = "AQI")
lines(fitted(arima_model), col = "blue")  # Plot fitted values




