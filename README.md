# Emotion Detection from EEG Signals

Detecting whether a person feels **positive, negative or neutral** emotion from recorded EEG brain signals, as a step toward robots that can read human emotional state during human–robot interaction. This was my M.S. graduate paper at Rochester Institute of Technology (advisor: Dr. Ferat Sahin).

[![Watch the presentation on YouTube](https://img.youtube.com/vi/cSHnOIqt5nI/hqdefault.jpg)](https://www.youtube.com/watch?v=cSHnOIqt5nI)

▶️ **[Watch the video on YouTube](https://www.youtube.com/watch?v=cSHnOIqt5nI)** · 📄 [Full graduate paper (PDF)](docs/Detection_of_Mental_State_Using_EEG_Signals.pdf)

---

## Overview

As technology advances, it will be of immense value to understand a person's emotional state, especially during human–robot interaction. Emotions can be detected from several physiological signals, and this work uses **EEG**. The goal is to classify the emotion a person experiences over a time span from their recorded EEG.

**Pipeline**
1. **Data.** Multi-session EEG recordings in BioSemi `.bdf` format, recorded while participants viewed emotion-eliciting IAPS images. Sample files are in `eeg_read_bdf/Sample_readable_files/`.
2. **Pre-processing.** Reading BDF files and event markers, filtering, zero-meaning and segmenting trials by marker.
3. **Feature extraction.** Statistical, spectral (Fourier), wavelet (MSWT) and CSP features, with PCA and FDA for dimensionality reduction.
4. **Classification.** **SVM**, **k-nearest neighbours (KNN)**, **Random Forest** and **AdaBoost** are compared and tuned, and the best technique is selected.

## Skills and tools

`MATLAB` · `Python` · `EEG signal processing` · `Feature extraction` · `PCA` · `SVM / KNN / Random Forest / AdaBoost` · `Machine learning`

## Repository contents

All code is in `eeg_read_bdf/`:

| File(s) | What it does |
|---|---|
| `eeg_read_bdf.m`, `read_bdf_marker_chans.m`, `seggregating all data based on markers.m` | Read BDF recordings and split trials by event markers |
| `filtering_eeg.m`, `zeromeaning.m`, `fourier_transform.m` | Pre-processing |
| `statistical_feature_extraction.m`, `Spectral_Features_Extract.m`, `getmswtfeat.m`, `RegCsp.m` | Feature extraction |
| `PCA_ON_ALL_DATA.m`, `IncrementalPCA.m`, `FDA.m` | Dimensionality reduction |
| `machine_learning.m`, `Best_tree.m`, `Data_for_training_classificationLearner.m` | Classifier training and comparison |
| `Session1_all.m`, `Session2_all.m`, `Session3_all.m` | Per-session processing |
| `FeaturesExtracted/` | Extracted feature sets |

## Context

M.S. graduate paper, *Detection of Mental State of a Human Using EEG Signals*, Department of Electrical and Microelectronic Engineering, Rochester Institute of Technology, April 2020. Also on [Portfolium](https://portfolium.com/entry/emotion-detection-using-eeg-signals).
