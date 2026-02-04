# Customer Targeting for Conversion Lift (Bank Marketing)
**Decision Tree + SMOTENC + SHAP | Interpretable segmentation for campaign targeting**

## What this is
A compact case study on a common marketing ops question:  
**Which customers are more likely to subscribe, and how can we target them more efficiently?**

The full analysis (metrics, segmentation rules, SHAP interpretation) is documented in the PDF report.

## Key takeaways (high level)
- Demographics-only features provide **measurable but limited lift** under class imbalance.
- The main value is **interpretable segmentation** (age is the strongest driver; education/marital interact with age).
- Output: actionable high-/mid-value segments for channel allocation (calls vs scalable digital outreach).

## Files
- **Report (PDF):** [decision_tree_smote_shap_report.pdf](decision_tree_smote_shap_report.pdf)
- **Notebook (code):** [decision_tree_smote_shap.ipynb](decision_tree_smote_shap.ipynb)

## How to run
```bash
pip install pandas numpy scikit-learn imbalanced-learn shap matplotlib
jupyter notebook

