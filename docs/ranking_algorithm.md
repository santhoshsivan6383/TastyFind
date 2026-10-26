# Dish Ranking Algorithm Specification

## 1. Motivation

Most existing food platforms aggregate review scores at the establishment level. A restaurant with an overall 4.0 rating may serve the single best Dosa in the district, while a 4.5-rated upscale bistro may serve an unexceptional Dosa at three times the price.

TastyFind solves this problem by rating and ranking **individual dishes** using three transparent criteria:
1. **Top Rated (Bayesian Weighted Rating)**
2. **Best Value (Taste-to-Rupee Affordability Index)**
3. **Nearest (Haversine Physical Proximity)**

---

## 2. Bayesian Weighted Rating (Top Rated Mode)

### Mathematical Formulation
To prevent a dish with a single 5.0-star rating from outranking an established dish with hundreds of 4.8-star reviews, TastyFind uses Bayesian estimation:

$$WR = \left(\frac{v}{v + m}\right) \times R + \left(\frac{m}{v + m}\right) \times C$$

Where:
- **$R$**: Arithmetic mean rating of the individual dish ($\frac{1}{v}\sum r_i$).
- **$v$**: Total count of verified reviews for that dish.
- **$m$**: Configurable minimum-review threshold parameter (default $m = 15$).
- **$C$**: Benchmark prior rating across the category and town (default $C = 4.0$).

### Behavior Analysis
| Dish Scenario | Raw Rating ($R$) | Reviews ($v$) | Prior ($C$) | Minimum ($m$) | Weighted Rating ($WR$) | Rank Outcome |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **New Dish** | 5.0 ★ | 1 | 4.0 ★ | 15 | **4.06 ★** | Dampened toward prior |
| **Moderate Dish** | 4.5 ★ | 30 | 4.0 ★ | 15 | **4.33 ★** | Significant empirical weight |
| **Established Dish** | 4.8 ★ | 543 | 4.0 ★ | 15 | **4.78 ★** | High confidence winner |
| **No Reviews** | 0.0 ★ | 0 | 4.0 ★ | 15 | **0.00 ★** | Disclosed as unreviewed |

Dishes with 0 reviews are handled cleanly and transparently without fabricating a rating score.

---

## 3. Best Value Algorithm (Best Value Mode)

The Best Value score quantifies culinary excellence relative to cost.

### Formulation
$$\text{Value Score} = \left(\frac{WR}{5.0}\right) \times \sqrt{\frac{P_{\text{baseline}}}{\max(P_{\text{dish}}, 20)}} \times 85$$

Where:
- **$WR$**: Bayesian weighted rating of the dish.
- **$P_{\text{dish}}$**: Current verified price in INR.
- **$P_{\text{baseline}}$**: Benchmark category price in town (e.g. ₹70 for standard Dosa).
- **Square root dampening**: Prevents ultra-cheap substandard items from overpowering exceptional quality dishes.
- Normalized scale: Returns a transparent score between 0 and 100.

### Badge Assignment
- Rank 1: **Best Value**
- Score $\ge 80$: **Great Value**
- Score $< 80$: Standard listing

---

## 4. Nearest Algorithm (Nearest Mode)

When user location permission is granted, distance in kilometers is computed using the spherical Haversine formula:

$$d = 2r \arcsin\left(\sqrt{\sin^2\left(\frac{\Delta \phi}{2}\right) + \cos(\phi_1)\cos(\phi_2)\sin^2\left(\frac{\Delta \lambda}{2}\right)}\right)$$

Where $r = 6371\text{ km}$.

If location permission is denied by the user, TastyFind:
1. Never blocks access to the application.
2. Allows manual town selection (e.g. Erode, Coimbatore, Salem).
3. Does **not** invent fake distances.
