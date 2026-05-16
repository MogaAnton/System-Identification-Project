# Advanced System Identification & Mathematical Modeling (MATLAB)

[cite_start]This repository contains a comprehensive, production-grade implementation of system identification techniques developed as a compulsory engineering project for the **System Identification** course [cite: 3] [cite_start]within the Control Engineering B.Sc. program [cite: 4] [cite_start]at the **Technical University of Cluj-Napoca (UTCN)**[cite: 4].

## 👥 Authors & Academic Context
* [cite_start]**Institution:** Technical University of Cluj-Napoca [cite: 4]
* [cite_start]**Course:** System Identification (Academic Year: 2025-2026) [cite: 1]
* [cite_start]**Development Team:** Coş Tudor-Adrian, Mastan Andrei-Mircea, Moga Anton-Ioan [cite: 157, 158, 159]
* [cite_start]**Group / Index:** 30332 / Index 2/9 [cite: 159]

---

## 🎯 Project Overview
[cite_start]The project is split into two distinct engineering challenges focused on regression analysis, mathematical optimization, and black-box dynamic system behavior prediction[cite: 10, 11, 86]. [cite_start]Both solutions were built completely from scratch in MATLAB without relying on high-level automated black-box toolboxes [cite: 42][cite_start], optimizing for execution performance and memory footprint[cite: 276, 277].

### 📊 [Part 1: Fitting an Unknown Static Function](./Part1_Static_Function_Fitting)
* [cite_start]**Objective:** Model an unknown, highly non-linear static system mapping two input variables to a single output scalar corrupted by zero-mean Gaussian noise[cite: 16, 17, 172].
* [cite_start]**Approach:** Implemented a custom multi-variable polynomial approximator and resolved the parameter vector utilizing the linear least-squares normal equations[cite: 18, 31, 32].
* [cite_start]**Highlights:** Explores algorithmic optimizations (vectorization over loops) [cite: 147] [cite_start]and hyperparameter sweeping to map out the exact frontier between underfitting and overfitting[cite: 397].

### 📈 [Part 2: Nonlinear ARX (NARX) Dynamic Identification](./Part2_Nonlinear_ARX_Identification)
* [cite_start]**Objective:** Build an autonomous black-box model of an unknown, noisy Single-Input Single-Output (SISO) dynamic system with up to 3rd-order lag[cite: 84, 85].
* [cite_start]**Approach:** Extended classical linear ARX auto-regressive behavior into the non-linear domain using complex polynomial expansions[cite: 86, 589].
* [cite_start]**Highlights:** Implemented dual evaluation engines—**One-Step-Ahead Prediction** and **Recursive Free-Running Simulation** [cite: 109, 110, 112][cite_start]—supported by a highly flexible, dynamic exponent combination matrix generator[cite: 610, 611].

---

## 🛠️ Core Engineering Highlights & Skillset Showcased
* [cite_start]**Mathematical Computing:** Multi-variable calculus, matrix transformations, regression modeling, and linear systems[cite: 31, 32, 598].
* [cite_start]**Performance Optimization:** Vectorization routines bypassing slow iterative loops (`for`/`while`) in MATLAB via `meshgrid` and column-stack transformations[cite: 147, 268].
* [cite_start]**Validation Protocols:** Rigorous data segregation using independent identification (training) sets and separate validation sets to confirm mathematical generalization[cite: 19, 39, 87].