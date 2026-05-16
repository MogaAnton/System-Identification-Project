# Part 2: Polynomial Nonlinear AutoRegressive with Exogenous Input (NARX) Modeling

## 📝 Project Objective
While static systems are memoryless, real-world physical processes feature behaviors deeply dependent on historical states. This initiative expands on linear modeling by developing an autonomous, black-box **Polynomial NARX model** designed to capture complex system lag, memory transitions, and non-linear interactions over time within a noisy Single-Input Single-Output (SISO) dynamic system.

---

## 📐 Model Architecture
The mathematical representation of our NARX structure uses system delays ($n_a, n_b$) and an activation polynomial function $p$ of degree $m$:

$$\hat{y}(k) = p(y(k-1), \dots, y(k-n_a), u(k-1), \dots, u(k-n_b))$$

Given an expansion where $n_a=n_b=1$ and degree $m=2$, the expanded state space computes as:

$$y(k) = a y(k-1) + b u(k-1) + c y^2(k-1) + v u^2(k-1) + w u(k-1)y(k-1) + z$$

Since the equations remain fully **linear in their parameters**, the multi-dimensional parameter matrix $\Theta$ is resolved efficiently via regression mappings.

---

## 💡 Engineering Features & Technical Accomplishments

### 1. Dual-Mode Evaluation Engines
To evaluate the model's robustness under different operational constraints, the execution engine was built to run in two distinct mathematical modes:
* **One-Step-Ahead Prediction Mode:** Utilizes actual historical system outputs $y(k-i)$ to forecast the immediate next state. This represents an ideal scenario, yielding exceptional tracking accuracy.
* **Autonomous Simulation Mode:** Operates entirely independently of real system feedback. It recursively feeds back its own previous estimations $\tilde{y}(k-i)$ to predict future states. This approach exposes cumulative structural drift, serving as the ultimate test for true model validity.

### 2. Exponent-Table Combinatorial Generator
To support high-order configurations without hardcoding rigid nested loops, we engineered an **Exponent-Table Polynomial Expansion routine**. It programmatically generates an index lookup table matching all valid feature combinations up to degree $m$, calculating rows using compact product transformations:

$$\Phi_k(r) = \prod_{i} d_i^{\text{pow}(r,i)}$$

This approach decouples structural configuration from implementation limits, providing high architectural flexibility.

---

## 📊 Hyperparameter Sweep Metrics & Insights
We conducted an extensive multi-dimensional sweep across orders $n_a = n_b \in [1, 6]$ and degrees $m \in [1, 3]$ to pinpoint the absolute best-performing configuration.

### Performance Summary Table

| Dataset Context | Evaluation Mode | Optimal Parameters ($n_a = n_b, m$) | Resulting Mean Squared Error (MSE) |
| :--- | :--- | :---: | :---: |
| **Identification Set** | Prediction Criterion | $n_a=n_b=6, \ m=3$ | **0.000000** |
| **Identification Set** | Simulation Criterion | $n_a=n_b=2, \ m=3$ | **0.022938** |
| **Validation Set** | Prediction Criterion | $n_a=n_b=5, \ m=1$ | **0.000015** |
| **Validation Set** | Simulation Criterion | $n_a=n_b=6, \ m=1$ | **0.161346** |

### 🔍 Key Engineering Takeaway
While complex models ($m=3$) achieved a near-zero error rate on training data, testing against independent validation data revealed a classic overfitting profile. The models that generalized best across unseen operational data ultimately utilized linear mappings ($m=1$) paired with deeper historical memory horizons.

---

## 📈 System Track Projections
*Below are our tracking performance comparisons against validation data over time, illustrating prediction accuracy versus simulated drift.*

| One-Step-Ahead Prediction Tracking | Free-Running Simulation Performance |
| :---: | :---: |
| <img width="765" height="485" alt="image" src="https://github.com/user-attachments/assets/e3eb45a6-16c0-4420-bc2b-fcddcae7a8e2" />| <img width="781" height="482" alt="image" src="https://github.com/user-attachments/assets/9c6426cf-2a37-40e3-a94e-391143bdd721" />|
