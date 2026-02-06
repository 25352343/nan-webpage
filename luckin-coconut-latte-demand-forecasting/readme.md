# Luckin Coconut Latte Demand Forecasting

This project presents a city-level daily demand forecasting case study for Luckin Coffee’s Coconut Latte, with a focus on short-term operational planning and perishable inventory risk.

## Project Overview
- Forecast target: Daily Coconut Latte sales (units)
- Geographic level: City (Shanghai)
- Time granularity: Daily
- Forecast horizon: 14 days
- Key challenge: Short shelf life of coconut milk under promotional volatility

## Structure
- `01_data_generator.ipynb`: Synthetic data generation for city-level sales, promotions, temperature, and coconut milk usage.
- `02_eda_shanghai_coconut_latte.ipynb`: Exploratory analysis of demand patterns, promotion effects, and temperature sensitivity.
- `03_forecast_risks_shanghai_daily_sales.ipynb`: Demand forecasting using a rolling average baseline and regression models, with interpretation of forecast errors and perishability risk.

## Key Takeaways
- A rolling average provides a strong baseline for short-term demand forecasting.
- Temporal dependency is the primary source of short-term predictability.
- Forecast errors translate asymmetrically into perishable inventory risk, particularly during promotional periods.

## Notes
All data used in this project are synthetically generated for demonstration purposes.

