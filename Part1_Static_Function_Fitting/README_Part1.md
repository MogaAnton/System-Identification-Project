# Part 1: Noisy Multi-Variable Function Fitting & Least-Squares Regression

## 📝 Problem Statement
[cite_start]Given a dataset containing an input grid of two independent variables ($x_1, x_2$) and a scalar output matrix $Y$ corrupted by additive, zero-mean Gaussian noise [cite: 17, 23, 24, 172][cite_start], the objective is to build a configurable-degree polynomial approximator $\hat{g}(x)$ that maps the true underlying static function $f(x_1, x_2)$ while ignoring environmental noise[cite: 15, 16, 25, 174].

---

## 📐 Mathematical Formulation
[cite_start]The approximator model handles multi-variable structural expansion up to degree $m$[cite: 25]. [cite_start]For example, a 2nd-degree configuration transforms the system into[cite: 28]:

$$\hat{g}(x) = [1, x_1, x_2, x_1^2, x_2^2, x_1x_2] \cdot \Theta$$

[cite_start]The core parameter extraction engine sets up the global regressor matrix $\Phi$ [cite: 180, 183] [cite_start]and optimizes the weight vector $\Theta$ in a least-squares sense using the linear regression framework[cite: 31, 32]:

$$\Theta = (\Phi^T\Phi)^{-1}\Phi^T Y$$

---

## 💡 Engineering & Algorithmic Highlights

[cite_start]To build the regressor matrix $\Phi$, we engineered and evaluated three separate software architectures to balance performance, memory usage, and structural clarity[cite: 240]:

1.  [cite_start]**Column-by-Column Matrix Generator:** Computes polynomial features natively using nested expansion loops[cite: 241, 252, 254].
2.  [cite_start]**Optimized Vectorized Grid Architecture (Best Solution):** Leverages MATLAB’s native `meshgrid` operations and array virtualization (`[:]`)[cite: 268, 307]. [cite_start]By entirely avoiding looping penalties, it delivers massive performance gains for large grids[cite: 398].
3.  [cite_start]**Element-by-Element Stream Architecture:** Computes row vectors iteratively [cite: 270, 330][cite_start], serving as a safe layout for hardware with tight local memory allocations[cite: 276, 277].

### 📈 Hyperparameter Optimization & Model Selection
[cite_start]The software includes a dynamic tuning framework that sweeps degrees from $m = 1$ to $m = 15$ [cite: 447] [cite_start]to locate the absolute global minimum of Mean Squared Error (MSE) on the validation dataset[cite: 378, 394].

* [cite_start]**Underfitting Regimes:** Lower degrees ($m < 4$) fail to capture the curvature of the non-linear surface[cite: 397].
* [cite_start]**Overfitting Regimes:** Higher degrees ($m > 10$) trigger structural over-parameterization, where the model mistakenly treats zero-mean noise as genuine system behavior[cite: 41, 397].

---

## 📊 Results Visualization

### Model Generalization Fit
*The surface plots confirm a pristine overlay between the synthesized polynomial model and the independent validation data, validating excellent generalization.*

| Raw Surface Over Noise | Optimal Surface Validation Overlay | Validation Curve (MSE vs. Degree) |
| :---: | :---: | :---: |
| ![Raw Data Placeholder](https://via.placeholder.com/300x200?text=Raw+Input+Mesh) | ![Overlay Placeholder](https://via.placeholder.com/300x200?text=Validation+Surface+Overlay) | ![Validation Curve](https://via.placeholder.com/300x200?text=MSE+vs+Degree+Plot) |

[cite_start]*(Note: Replace placeholders with your exported figures from your documentation slides!)* [cite: 285, 310, 374]