# High-AQI-Index-Detecting-and-Forecasting-using-Ensemble-Learning in R

**Project Title: Detection and Forecasting of High Air Quality Index (AQI) in Indian Cities**

Introduction:
This project aims to detect instances of high Air Quality Index (AQI) and forecast future AQI values for selected cities in India. The study utilizes ensemble learning techniques, including Multiple Linear Regression, Decision Tree, Random Forest, Lasso Regression, and Polynomial Regression, to analyze hourly and daily air quality data collected from various monitoring stations across multiple cities in India. The primary objective is to identify the most effective algorithm for predicting AQI and provide insights into air quality trends over the years.

Methodology:
The study employs Root Mean Square Error (RMSE) values to evaluate the performance of each algorithm. Initially, individual algorithms are assessed, and Random Forest emerges as the most accurate predictor. Subsequently, ensemble methods are explored to enhance prediction accuracy further. Random Forest is highlighted as the best-performing algorithm based on its superior RMSE values.

To assess AQI trends over time, data from the years 2015 to 2020 are compared using Random Forest, the algorithm with the lowest RMSE value. Additionally, the ARIMA model is employed for forecasting future AQI trends.

Tools and Packages:
The project is implemented using the R programming language, with R Studio serving as the primary development tool. Various R packages are utilized throughout the study, including readr, caret, dplyr, ggplot2, caTools, e1071, party, rpart, rpart.plot, randomForest, glmnet, tidyr, and forecast.

Data Source:
The dataset used for this study is sourced from Kaggle and comprises air quality data collected from monitoring stations in cities across India. The dataset includes hourly and daily AQI measurements, with relevant information from cities such as Ahmedabad, Aizawl, Amaravati, Amritsar, Bengaluru, Hyderabad and more.

Conclusion:
Through the application of ensemble learning techniques and thorough analysis of air quality data, this study provides valuable insights into detecting high AQI levels and forecasting future trends. The utilization of Random Forest as the primary algorithm, along with comparisons across multiple years, enhances our understanding of air quality dynamics in Indian cities.

This repository serves as a comprehensive guide to the methodologies employed and findings obtained during the course of the project, contributing to the broader discourse on air quality management and forecasting.

Few visualisation can be seen below. For more visualisations and details on the visualisation, access the .rmd file

<img width="716" alt="image" src="https://github.com/cnd-sw/High-AQI-Index-Detecting-and-Forecasting-using-Ensemble-Learning/assets/82866870/603aa08b-1c9a-4679-a98b-0b2a6ccaed81">

<img width="713" alt="image" src="https://github.com/cnd-sw/High-AQI-Index-Detecting-and-Forecasting-using-Ensemble-Learning/assets/82866870/33608f28-b854-4b7e-a579-aa05888593ee">

