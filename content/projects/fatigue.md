+++
author = "Tom Fleet"
title = "Fatigue Damage Prediction"
date = "2020-09-28"
description = "ML approach to prediction of complex fatigue crack growth and thermo-mechanical loading interactions."
tags = [
    "python",
    "material science",
    "engineering",
    "machine learning"
]
katex = true
type = "page"
+++

*Using machine learning to predict fatigue crack growth under complex thermomechanical loads. Achieved a damage severity predicive accuracy of ±0.25mm and a positional predictive accuracy of ±7.0mm.*

Tom Fleet, Sep 2020

## Background

Repeated cyclic loading of a material will eventually lead to a phenomenon called "fatigue crack growth". I'm not going to explain the details here but I'd point you to [this](https://en.wikipedia.org/wiki/Fatigue_(material)) for more info. Essentially, a crack will start to form and repeated cyclic loading will progressively grow this crack until it is large enough such that the remaining material can no longer handle the stress and the component will break.

Ever since the [comet disasters](https://en.wikipedia.org/wiki/De_Havilland_Comet#Accidents_and_incidents) in the 1950's, understanding exactly how this process works and predicting how long (or more accurately: how many cycles) components can survive for has been a crucial part of the design process. This is done with the so-called Paris Law (although in reality, it's a lot more complicated than this theoretical abstraction).

$$da/dN = C(\Delta K)^m$$

Where $da$ is the increment in crack length, $dN$ is the increment in number of cycles, $C$ and $m$ are material-specific constants and $\Delta K$ is the increment in stress intensity factor (effectively a way of accounting for the increased stress around a defect such as a crack).

Pure loading fatigue is very well understood nowadays. However, when you combine fatigue crack growth with other environmental effects such as corrosion, thermal cycling etc. this can result in very unpredictable behaviour.

The aim of this project was to understand how one of these combinations (fatigue and thermal effects) could be better understood with the application of machine learning.

Experimental data on the effect of crack propagation on dynamic response (vibration) was generated in a series of earlier experiments on two different materials and given to me to work with for my MSc Advanced Materials thesis project in Spring 2020.

![Dynamic Response](/images/projects/msc_project/dynamic_response_by_material.png)

Starting notches were machined into test specimens which were then vibrated at their natural frequencies at a variety of temperatures. The cracks were then allowed to grow whilst natural frequency and amplitude measurements were continuously taken in order to determine the effect of crack propagation on dynamic properties.

The objectives of this work were to:

* Build a predictive model capable of accurately predicting damage severity and location from a simple vibration test.

* Use the introspection of the model to attempt to inform the fundamental underlying theory

## Results

After using [mlflow](https://mlflow.org) to record parameters and shortlist promising models, I chose a Ridge-regularised multiple Linear Regression model to enable easy introspection as this was a key objective of the project.

The models were able to predict the depth of the crack with high accuracy (shown below) for both materials.

| Material      | RMSE          | $R^2$   |
|:-------------:|:-------------:|:-----:|
| Aluminium     | 0.176 mm      | 0.95  |
| ABS           | 0.256 mm      | 0.86  |

![Model Accuracy](/images/projects/msc_project/combined_accuracy_altair.png)

Traditionally in engineering, data of this sort is usually fed into something like matlab and subject to curve fitting. This was done on this data as a benchmark against which to judge the ML model's accuracy. Below is a comparison of the RMSE between traditional polynomial curve fitting in matlab, and the ridge-regularised multiple linear regression model used in this project.

![Comparison vs Curve Fitting](/images/projects/msc_project/ml_vs_curve_fitting.png)

As you can see, the ML model significantly outperformed the traditional polynomial curve fitting method, shaving over 0.6mm off the average prediction error.

The predictions for Aluminium were also more accurate than those for ABS, the reduced accuracy for the ABS being explained by the anisotropic structure and stress crazing at the crack tip caused by the method of manufacture of the test specimens (FDM additive manufacturing).

### Feature Importance

A key part of the project was to understand the underlying factors behind these effects, rather than simply generate predictions. Hence the earlier decision to use a linear model as it's coefficients could be easily inspected.

A feature importance study was conducted, results shown below.

![Feature Importance](/images/projects/msc_project/relative_importance_in_crack_depth_prediction.png)

The data show that the natural frequency was the most important predictor for both materials. Temperature and crack position were shown to be comparatively less important - an interesting finding.

Infact, the comparatively low importance of crack position in the prediction of crack depth allowed me to pull crack position out of the feature pool entirely and predict it alongside crack depth and only sacrifice a small amount of accuracy (shown below).

![Multi Output Prediction](/images/projects/msc_project/multi_output_accuracy.png)

The end result was a model that could predict the severity of a thermomechanical fatigue crack to within ±0.22mm and simultaneously predict its position in the component to within ±7.0mm, an incredibly powerful result!

![Multi Output Crack Depth](/images/projects/msc_project/multi_output_crack_depth.png)

![Multi Output Crack Position](/images/projects/msc_project/multi_output_crack_position.png)

### Further Information

This work was submitted for publication in the academic journal [MDPI Sensors](https://www.mdpi.com/journal/sensors) and was accepted and published on 30/11/2020. Full text available [here](https://www.mdpi.com/1424-8220/20/23/6847)

[1] Fleet, T.; Kamei, K.; He, F.; Khan, M.A.; Khan, K.A.; Starr, A. A Machine Learning Approach to Model Interdependencies between Dynamic Response and Crack Propagation. Sensors 2020, 20, 6847. https://doi.org/10.3390/s20236847
