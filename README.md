Bayesian causal inference unifies perceptual and neuronal processing of center-surround motion in area MT: Analysis & Simulation Code

This repository contains the code required to reproduce the analysis and figures presented in the paper "Bayesian causal inference unifies perceptual and neuronal processing of center-surround motion in area MT". The project utilizes a combination of Python for data analysis and MATLAB for model predictions and simulation.

```
ROC_CI_pred/
├── analysis/
│   ├── matlab/
│   │   ├── functions/
│   │   ├── Figs.5_S2_S3_plot_4DTuningCurves.m   # MATLAB scripts for Figure 5 
│   │   └── Generate_data_for_Figs.5_S2_S3...    # MATLAB script for running the model simulation
│   ├── old_matlab/
│   ├── old_python/
│   ├── plots/
│   └── python/                        # IPython notebooks for general figure analysis
│       ├── Fig.3_plotPosteriors.ipynb
│       ├── Fig.4d_2DTuningCurves.ipynb
│       ├── Fig.7_fit_data.ipynb
│       ├── Fig.S4_clusters.ipynb
│       ├── Figs.6_S5_fit_data.ipynb
│       └── forRefact.py
├── docs/
├── plots/
├── .gitignore
├── environment.yml
└── README.md
```

Getting Started
1. Prerequisites

Ensure you have the following installed:

    Python 3.x (with Jupyter/IPython, NumPy, Pandas, Matplotlib)

    MATLAB (tested on version R2023a)

2. Data Acquisition

The simulation data required to run these scripts is hosted externally due to file size constraints.

    Link to Data: [will be here]

    Download the dataset from the link above.

    Extract the contents into a local folder (e.g., /data/).

3. Configuration (Path Variables)

Before running any scripts, you must update the path variables to point to your local data directory.

    For Python: Open the notebooks in /python/ and update the ppath = Path() variable in the first cell.

    For MATLAB: Open the scripts in /matlab/ and update the dataPath variable at the top of the script.

Reproducing Figures
Analysis (Figures 1-4, 6+)

The primary analysis is handled via Python.

    Navigate to the /python/ directory.

    Launch the relevant .ipynb file to generate specific figures.

Model Predictions (Figure 5)

Figure 5 and the underlying model predictions are generated via MATLAB.

    Navigate to the /matlab/ directory.

    Run the main script (Generate_data_for_Figs.5_S2_S3, Figs.5_S2_S3_plot_4DTuningCurves.m) to execute the simulation and plot the results.

Contact & Citation

If you use this code or find it helpful for your research, please cite our paper:

Bayesian causal inference unifies perceptual and neuronal processing of center-surround motion in area MT
Gabor Lengyel, Sabyasachi Shivkumar, Gregory C. DeAngelis, Ralf M. Haefner
bioRxiv 2025.09.17.676722; doi: https://doi.org/10.1101/2025.09.17.676722 

For questions regarding the code, please open an issue or contact Gabor Lengyel.
