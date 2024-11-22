---
title: Digital Communications - Lab 2 Questionnaire
---

<style>
:root {
    --markdown-font-family: "Times New Roman", Times, serif;
    --markdown-font-size: 10.5pt;
}
</style>

<p class="supt1 center">Digital Communications</p>

# Quiz for Lab exercise 2 (A): Spread Spectrum

<p class="subt2 center">
Academic year 2024/2025
</p>

| Student names          | Grade |
| ---------------------- | ----- |
| Alonso Herreros Copete |       |

---

Fill in the data obtained in your simulations and give a reasoned answer to the following questions

## 1. Transmission @ Chip time (1 user)

What is the energy of channel $d[m]$?

> As calculated using $\sum_{k} |d[k]|^2$, the energy is $5.263$.

Fill the following table:

|       | Energy $p[n]$ | $P_e (σ_{z_c}²=0)$ | $P_e (σ_{z_c}²=1)$ | BER ($σ_{z_c}²=0$) | BER ($σ_{z_c}²=1$) |
| ----- | ------------- | ------------------ | ------------------ | ------------------ | ------------------ |
| $x_0$ | 4319.1        | 0.5327             | 0.5373             | 0.3093             | 0.3112             |
| $x_1$ | 37.6          | 0.0000             | 0.0590             | 0.0000             | 0.0295             |
| $x_2$ | 67.9          | 0.0000             | 0.0144             | 0.0000             | 0.0072             |
| $x_3$ | 74.6          | 0.0000             | 0.0154             | 0.0000             | 0.0077             |

In view of the simulations, explain the results obtained and relate them to the correlation function of each sequence.

> The following is the plot of the correlation function of all sequences:
>
> ![Correlation function of all sequences](./figures/1.3-corrs.png)
>
> While it may not be very easy to visualize, we can actually see that the
> correlation function of $x_0$ is the one with the highest peak, which is why
> it has the highest error probability. The correlation function of $x_1$
> oscillates with very high amplitude, which is why it has lower error
> probability, but it is still high. The correlation functions of $x_2$ and
> $x_3$ have very low amplitudes, and their error probabilities are the lowest.

In which order would you use the sequences given the previous results ?

> The order would be from lowest to highest error probability:
>
>
> $$
> x_2, x_3, x_1, x_0
> $$

## 2. CDMA: transmission of 2 users

Fill the following tables:

Ideal channel

|                     | Dot product | $P_e (σ_{z_c}²=0)$    | $P_e (σ_{z_c}²=1)$    | BER ($σ_{z_c}²=0)$    | BER ($σ_{z_c}²=1)$    |
| ------------------- | ----------- | --------------------- | --------------------- | --------------------- | --------------------- |
| $x_A=x_1$ $x_b=x_2$ |             | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: |
| $x_A=x_1$ $x_b=x_3$ |             | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: |
| $x_A=x_2$ $x_b=x_3$ |             | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: |

Channel proposed in (3)

|                     | Dot product | $P_e (σ_{z_c}²=0)$ | $P_e (σ_{z_c}²=1)$ | BER ($σ_{z_c}²=0)$ | BER ($σ_{z_c}²=1)$ |
| ------------------- | ----------- | ------------------ | ------------------ | ------------------ | ------------------ |
| $x_A=x_1$ $x_b=x_2$ |             | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: |
| $x_A=x_1$ $x_b=x_3$ |             | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: |
| $x_A=x_2$ $x_b=x_3$ |             | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: | A: $\;\big\vert\;$ B: |

In view of the simulations, explain the results obtained and relate them to the correlation function of each sequence.

What would be the order of pairs of sequences according to the results? Reason this order with the results obtained in the single user section.
