# Part 1: Noisy Multi-Variable Function Fitting & Least-Squares Regression

## 📝 Project Objective
This project focuses on the challenge of modeling an unknown static non-linear system using noisy data. Given an input grid of two independent variables ($x_1, x_2$) and a scalar output matrix $Y$ corrupted by additive, zero-mean Gaussian noise, the goal was to design and implement a configurable-degree polynomial approximator $\hat{g}(x)$ capable of accurately mapping the underlying function $f(x_1, x_2)$ while filtering out environmental noise.

---

## 📐 Mathematical Formulation
The approximator handles multi-variable structural expansion up to degree $m$. For example, a 2nd-degree configuration transforms the system into:

$$\hat{g}(x) = [1, x_1, x_2, x_1^2, x_2^2, x_1x_2] \cdot \Theta$$

The parameter extraction engine constructs the global regressor matrix $\Phi$ and optimizes the weight vector $\Theta$ in a least-squares sense using a custom linear regression framework:

$$\Theta = (\Phi^T\Phi)^{-1}\Phi^T Y$$

---

## 💡 Engineering & Algorithmic Highlights

To build the regressor matrix $\Phi$, we engineered and evaluated three separate software architectures to find the optimal balance between performance, memory usage, and structural clarity:

1.  **Column-by-Column Matrix Generator:** Computes polynomial features natively using nested expansion loops.
2.  **Optimized Vectorized Grid Architecture (Selected Solution):** Leverages MATLAB’s native `meshgrid` operations and array virtualization (`[:]`). By entirely avoiding looping penalties, it delivers massive performance gains for large datasets.
3.  **Element-by-Element Stream Architecture:** Computes row vectors iteratively, serving as a safe layout for hardware with tight local memory allocations.

### 📈 Hyperparameter Optimization & Model Selection
The implementation features a dynamic tuning framework that sweeps degrees from $m = 1$ to $m = 15$ to locate the absolute global minimum of Mean Squared Error (MSE) on an independent validation dataset.

* **Underfitting Regimes:** Lower degrees ($m < 4$) lack the mathematical complexity to capture the true curvature of the non-linear surface.
* **Overfitting Regimes:** Higher degrees ($m > 10$) trigger structural over-parameterization, where the model mistakenly captures and models the random zero-mean noise.

---

## 📊 Visualizations

### Model Generalization Fit
*The surface plots confirm an excellent overlay between the synthesized polynomial model and the independent validation data, demonstrating strong generalization.*

| Raw Surface Over Noise | Optimal Surface Validation Overlay | Validation Curve (MSE vs. Degree) |
| :---: | :---: | :---: |
| ![Raw Input Mesh Placeholder](https://via.placeholder.com/300x200?text=Raw+Input+Mesh) | ![Validation Surface Overlay Placeholder](https://via.placeholder.com/300x200?text=Validation+Surface+Overlay) | ![MSE vs Degree Plot Placeholder](https://via.placeholder.com/300x200?text=MSE+vs+Degree+Plot) |

*(Note: Replace these placeholders with screenshots exported from your project slides!)*
