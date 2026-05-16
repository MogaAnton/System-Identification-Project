# Advanced System Identification & Mathematical Modeling (MATLAB)

This repository contains a comprehensive, production-grade implementation of system identification techniques developed as a deep-dive technical initiative within the Control Engineering B.Sc. program at the **Technical University of Cluj-Napoca (UTCN)**.

## 👥 Authors & Academic Context
* **Institution:** Technical University of Cluj-Napoca
* **Focus Area:** System Identification & Control Engineering (Academic Year: 2025-2026)
* **Development Team:** Coş Tudor-Adrian, Mastan Andrei-Mircea, Moga Anton-Ioan
* **Group / Index:** 30332 / Index 2/9

---

## 🎯 Project Overview
This initiative focuses on solving two distinct engineering challenges in regression analysis, mathematical optimization, and black-box dynamic system behavior prediction. Both solutions were engineered completely from scratch in MATLAB without relying on high-level automated black-box toolboxes, optimizing directly for execution performance and minimal memory footprint.

### 📊 [Part 1: Fitting an Unknown Static Function](./Part1_Static_Function_Fitting)
* **Objective:** Model an unknown, highly non-linear static system mapping two input variables to a single output scalar corrupted by zero-mean Gaussian noise.
* **Approach:** Implemented a custom multi-variable polynomial approximator and resolved the parameter vector utilizing the linear least-squares normal equations.
* **Highlights:** Explores algorithmic architectures (vectorization over iterative loops) and hyperparameter sweeping to map out the exact frontier between underfitting and overfitting.

### 📈 [Part 2: Nonlinear ARX (NARX) Dynamic Identification](./Part2_Nonlinear_ARX_Identification)
* **Objective:** Build an autonomous black-box model of an unknown, noisy Single-Input Single-Output (SISO) dynamic system experiencing up to 3rd-order lag.
* **Approach:** Extended classical linear ARX auto-regressive behavior into the non-linear domain using complex polynomial expansions.
* **Highlights:** Implemented dual evaluation engines—**One-Step-Ahead Prediction** and **Recursive Free-Running Simulation**—supported by a highly flexible, dynamic exponent combination matrix generator.

---

## 🛠️ Core Engineering Highlights & Skillset Showcased
* **Mathematical Computing:** Multi-variable calculus, matrix transformations, regression modeling, and linear systems.
* **Performance Optimization:** Vectorization routines bypassing slow iterative loops (`for`/`while`) in MATLAB via `meshgrid` and column-stack transformations.
* **Validation Protocols:** Rigorous data segregation using independent identification (training) sets and separate validation sets to confirm mathematical generalization.
