# Simulated Case for 6.4 keV Line Patterns

This repository contains code and documentation for simulating different patterns of the 6.4 keV line (increasing, decreasing, constant, peak, etc.) over five epochs. The simulation aims to understand the expected photon counts under specific assumptions.

## Project Description

In this simulation, we analyze various patterns of the 6.4 keV line using a constant continuum level. The goal is to generate simulated photon counts based on real observation times and specific assumptions regarding the photon rates.

### Assumptions
- **Constant continuum levels:** 12 × 10^(-8) ph cm^(-2) s^(-2)
- **Real observation time:** [Provide specifics if applicable, or just state it's based on actual observational data.]

## Simulation Details

### Case 1: Constant Pattern

In this case, the photon counts are simulated with the following values:
- **Continuum rates (`muc`):** 
  - [8 × 10^(-8) for each of the five epochs]
  
  ```python
  muc = [8e-8, 8e-8, 8e-8, 8e-8, 8e-8]
  ```

- **Line rates (`mul`):**
  - [12 × 10^(-8) for each of the five epochs]

  ```python
  mul = [12e-8, 12e-8, 12e-8, 12e-8, 12e-8]
  ```

### Expected Photon Counts

The expected photon counts are calculated as follows:

```python
expected_photons_cont = [n * u for n, u in zip(muc, EXP)]
expected_photons_line = [n * u for n, u in zip(mul, EXP)]
```

Where `EXP` represents the actual observation time for each epoch.

### Simulation Logic

The simulation iterates through the expected photon counts, generating Poisson random variables to simulate observed counts:

```python
ntot = []
nc = []
uncertainty = []
ntot_exp_values = []  

for i, j in zip(expected_photons_cont, expected_photons_line):
    poisson_RV_muc = np.random.poisson(i, 1)[0] 
    poisson_RV_mul = np.random.poisson(j, 1)[0]
      
    ntot_value = poisson_RV_muc + poisson_RV_mul
    ntot.append(ntot_value)
    nc.append(poisson_RV_muc)
    uncertainty.append(np.sqrt(ntot_value))
```

### Outputs

After running the simulation, the following outputs are generated:
- **Total counts (`ntot`)**: The sum of the constant and line photon counts.
- **Expected photon counts for continuum (`expected_photons_cont`)**.
- **Expected photon counts for line (`expected_photons_line`)**.

### Example Results

The final results will include:

```python
print("ntot:", ntot)
print("mucont:", expected_photons_cont)
print("exp:", EXP)
print("mul:", mul)
```

### Error Calculation

Simulated line values are calculated to assess the difference between observed and expected photon counts:

```python
simulatedline = [(a - b) / c for a, b, c in zip(ntot, expected_photons_cont, EXP)]
simulatedline_error = [np.sqrt(a + b) / c for a, b, c in zip(ntot, expected_photons_cont, EXP)]
```

## Running the Simulation

To run the simulation, make sure you have Python installed along with the required libraries. You can execute the main script to generate the simulations.

```bash
python simulate.py
```

## Contributing

Contributions are welcome! If you have suggestions or improvements, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
