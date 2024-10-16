from scipy.stats import poisson, gamma
import numpy as np 
import math
import pathlib
from scipy.integrate import quad
import matplotlib.pyplot as plt
from scipy.integrate import simps

from scipy.special import gammaln

def generalized_poisson_pdf(x, lam, alpha):
    if x < 0:
        return 0
    return (lam * (lam + alpha * x)**(x - 1) * np.exp(-(lam + alpha * x))) / np.math.factorial(x)


def normalize_array(x, y):
    # Calculate the area under the curve
    area = simps(y, x)
    
    # Check if the area is 1 (normalized)
    if not np.isclose(area, 1):
        print(f"Array is not normalized, area = {area}. Normalizing...")
        # Normalize the array by dividing by the area
        y_normalized = y / area
    else:
        print(f"Array is already normalized, area = {area}.")
        y_normalized = y

    return y_normalized

'''
This script, pmf.py, calculates the Posterior Density Curve for a given test mu_line value. 
The step size for test mu_line is set at 0.5. 
The calculations consider combinations of N_total = N_line + N_cont, where N_total is treated as integer values (rounded to the smallest integer). 
In realistic scenarios, N_total may include fractional values.
'''

def P_total(N_total, mu_cont, mu_line):
    """
    Calculates the total probability using the Poisson distribution.

    Parameters:
    - N_total: Total number of events (N_total) to consider.
    - mu_cont: Mean continuum (mu_cont) for the continuous distribution.
    - mu_line: Mean for the line distribution (mu_line).

    Returns:
    - total_prob: Total probability of observing the specified distribution.
    """
    total_prob = 0
    N_total = int(N_total)  # Ensuring N_total is an integer

    for N_line in range(N_total + 1):
        N_cont = N_total - N_line
        prob_line = poisson.pmf(N_line, mu_line)  # Poisson probability for line events
        prob_cont = poisson.pmf(N_cont, mu_cont)  # Poisson probability for continuous events
        total_prob += prob_line * prob_cont  # Combine probabilities
        
    return total_prob

'''
def P_total_gamma_approx(N_total, mu_cont, mu_line):
    """
    Calculates the total probability using the Gamma distribution approximation.

    Parameters:
    - N_total: Total number of events (N_total) to consider.
    - mu_cont: Mean continuum (mu_cont) for the continuous distribution.
    - mu_line: Mean for the line distribution (mu_line).

    Returns:
    - total_prob: Total probability of observing the specified distribution using the Gamma approximation.
    """

    total_prob = 0

    for N_line_frac in np.arange(0, N_total, 0.1):
        N_cont_frac = N_total - N_line_frac
        
        # Calculate probabilities, with checks for valid values (non-NaN and non-inf)
        prob_line = gamma.pdf(N_line_frac, a=mu_line, scale=1) if N_line_frac >= 0.1 else 0
        prob_cont = gamma.pdf(N_cont_frac, a=mu_cont, scale=1) if N_cont_frac >= 0.1 else 0
 


        # Skip any step where probability is NaN or inf
        if np.isnan(prob_line) or np.isnan(prob_cont) or np.isinf(prob_line) or np.isinf(prob_cont):
            print(f"Skipping due to invalid probability at N_line_frac: {N_line_frac}, N_cont_frac: {N_cont_frac}")
            continue
        
        # Accumulate the valid total probability
        total_prob += prob_line * prob_cont

    # Final check for total_prob to ensure it's not NaN or inf
    if np.isnan(total_prob) or np.isinf(total_prob):
        print("Warning: total_prob is NaN or inf. Setting it to 0.")
        total_prob = 0



    return total_prob
'''



def generalized_poisson_pdf(x, lam, alpha):
    """Compute the PDF of the Generalized Poisson Distribution."""
    if x < 0:
        return 0
    
    # Handle non-integer x by using the gamma function instead of factorial
    # factorial(x) = gamma(x + 1)
    return (lam * (lam + alpha * x)**(x - 1) * np.exp(-(lam + alpha * x))) / np.exp(gammaln(x + 1))

def compound_poisson_pdf(lam, alpha, beta, x):
    """Compute the PDF of a compound Poisson process."""
    # Simulate the number of Poisson events
    n_events = np.random.poisson(lam)
    
    # Simulate the sizes of events drawn from a Gamma distribution
    event_sizes = np.random.gamma(alpha, beta, n_events)
    
    # Compute the total size of the events
    total_size = np.sum(event_sizes)
    
    return total_size if total_size <= x else 0

def P_total_gamma_approx(N_total, mu_cont, mu_line, method='generalized_poisson', alpha=1e-5, beta=1):
    """
    Calculates the total probability using different approximation methods.
    
    Parameters:
    - N_total: Total number of events (N_total) to consider.
    - mu_cont: Mean continuum (mu_cont) for the continuous distribution.
    - mu_line: Mean for the line distribution (mu_line).
    - method: Approximation method ('gamma', 'generalized_poisson', or 'compound_poisson').
    - alpha: Shape parameter for Generalized Poisson or Gamma distribution.
    - beta: Scale parameter for Gamma distribution (only needed for 'compound_poisson').

    Returns:
    - total_prob: Total probability of observing the specified distribution using the chosen approximation method.
    """

    total_prob = 0

    for N_line_frac in np.arange(0, N_total, 0.1):
        N_cont_frac = N_total - N_line_frac

        # Initialize probabilities to zero
        prob_line = 0
        prob_cont = 0

        # Calculate probabilities based on the chosen method
        if method == 'gamma':
            prob_line = gamma.pdf(N_line_frac, a=mu_line, scale=1) if N_line_frac >= 0 else 0
            prob_cont = gamma.pdf(N_cont_frac, a=mu_cont, scale=1) if N_cont_frac >= 0 else 0

        elif method == 'generalized_poisson':
            prob_line = generalized_poisson_pdf(N_line_frac, mu_line, alpha) if N_line_frac >= 0 else 0
            prob_cont = generalized_poisson_pdf(N_cont_frac, mu_cont, alpha) if N_cont_frac >= 0 else 0

        elif method == 'compound_poisson':
            # For compound Poisson, we calculate the probability differently
            prob_line = compound_poisson_pdf(mu_line, alpha, beta, N_line_frac) #if N_line_frac >= 0 else 0
            prob_cont = compound_poisson_pdf(mu_cont, alpha, beta, N_cont_frac) #if N_cont_frac >= 0 else 0

        # Skip any step where probability is NaN or inf
        if np.isnan(prob_line) or np.isnan(prob_cont):
            print(f"Skipping due to invalid probability at N_line_frac: {N_line_frac}, N_cont_frac: {N_cont_frac}")
            continue

        # Accumulate the valid total probability
        total_prob += prob_line * prob_cont



    return total_prob




def global_calculation(total_events, mu_cont):
    """
    Performs a global calculation of the Poisson distribution over a range of test mu_line values.

    Parameters:
    - total_events: Total number of events (N_total) to consider.
    - mu_cont: Mean continuum (mu_cont) used in the Poisson calculation.

    Returns:
    - total_prob: Array of calculated probabilities for each mu_line value.
    - mu_line_values: Array of mu_line values used for the calculation.
    """
    
    # Define the range for mu_line, covering from 0 to 2 * ceil(N_total) + 5
    mu_line_values = np.linspace(0, (2 * math.ceil(total_events) + 5), 200)
    threshold = 0.0

    probabilities = []
    for mu_line in mu_line_values:
        if total_events > threshold:
            # Calculate Poisson probability for each mu_line using the standard method
            probabilities.append(P_total(total_events, mu_cont, mu_line))
        else:
            # Calculate using the Gamma approximation for lower total events
            probabilities.append(P_total_gamma_approx(total_events, mu_cont, mu_line))

    total_prob = np.array(probabilities)

    return total_prob, mu_line_values




'''
def global_calculation_test(total_events, mu_cont):
    """
    Performs a global calculation of the Poisson distribution over a range of test mu_line values.

    Parameters:
    - total_events: Total number of events (N_total) to consider.
    - mu_cont: Mean continuum (mu_cont) used in the Poisson calculation.

    Returns:
    - total_prob: Array of calculated probabilities for each mu_line value.
    - mu_line_values: Array of mu_line values used for the calculation.
    """
    
    # Define the range for mu_line, covering from 0 to 2 * ceil(N_total) + 5
    mu_line_values = np.linspace(0, (2 * math.ceil(total_events) + 5), 200)

    prob_poiss,prob_gamma_approx = [],[]
    for mu_line in mu_line_values:
        prob_gamma_approx.append(P_total_gamma_approx(total_events, mu_cont, mu_line))
        prob_poiss.append(P_total(total_events, mu_cont, mu_line))
    
    total_prob_Poiss = np.array(prob_poiss)
    total_prob_Gamma = np.array(prob_gamma_approx)

    return total_prob_Poiss,total_prob_Gamma, mu_line_values


total_prob_Poiss, total_prob_Gamma, mu_line_values = global_calculation_test(1.5,2.4)


y1_normalized = normalize_array(mu_line_values, total_prob_Poiss)
y2_normalized = normalize_array(mu_line_values, total_prob_Gamma)






plt.plot(mu_line_values, y1_normalized, color='b', label='Poisson Distribution', linestyle='-')
plt.plot(mu_line_values, y2_normalized, color='r', label='Poisson Distribution (Gamma approx)', linestyle='--')


max_mu_line_poisson = mu_line_values[np.argmax(total_prob_Poiss)]
max_mu_line_poissonGammma = mu_line_values[np.argmax(total_prob_Gamma)]
print(max_mu_line_poisson,max_mu_line_poissonGammma)

# Add labels and title
plt.xlabel('Mu Line Values')
plt.ylabel('Probability')
plt.title('Gamma Approximation vs. Poisson Distribution')

plt.legend()
plt.show()

'''
