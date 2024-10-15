import matplotlib.pyplot as plt 
####EXTERNAL SCRIPTS
from pmf import global_calculation
from data import extract_data_for_year_and_index
from data import extract_data_flux
from data import obtain_poisson_cruve


from ccdf import calculation_of_ccdf
from ccdf import calculation_of_ccdf_second
from intersections import find_intersection_x_values


def plot_result(index, years, filtered_years, data, comm_x, interpolated_val, 
                filtered_x_list, filtered_ccd_list, old, new):
    """
    Plots various density and light curve results for the specified index.

    Parameters:
    - index: The index for the plots.
    - years: List of years corresponding to the data.
    - filtered_years: List of filtered years.
    - data: Data containing density values for each year.
    - comm_x: Common x-values for interpolation.
    - interpolated_val: Interpolated values for steady emission.
    - filtered_x_list: List of filtered x-values.
    - filtered_ccd_list: List of filtered CCDF values.
    - old: Tuple or list containing old flux values for reference lines.
    - new: Tuple or list containing new flux values for reference lines.
    """

    # Create subplots
    fig, (ax0, ax1, ax2, ax3) = plt.subplots(1, 4, figsize=(12, 4))

    # Plot density for the 6.4 keV line
    for k, year in zip(data, years):
        ax0.plot(k[1], k[0], label=str(year))  # Convert year to string for label
    ax0.set_title('Density for the 6.4 keV line')
    ax0.legend()

    # Plot density for steady emission
    for i, year in zip(interpolated_val, years):
        ax1.plot(comm_x, i, label=str(year))
    ax1.set_title('Density for\nSteady Emission')
    ax1.legend()

    # Plot filtered densities for steady emission
    for i, year in zip(filtered_ccd_list, filtered_years):
        ax2.plot(filtered_x_list, i, label=str(year))
    ax2.set_title('Filtered Density for\nSteady Emission')
    ax2.legend()

    # Prepare to plot the light curve with error bars
    label = ['2000', '2004', '2012', '2018', '2020']
    new_labels = [label.index(str(year)) + 0.2 for year in years]

    flux_pois, error_poiss_lower, error_poiss_upper = [], [], []
    for h in years:
        central_val, lower_bounds, upper_bounds = obtain_poisson_cruve(h, index)
        errors_lower = (central_val if central_val is not None else 0) - (lower_bounds if lower_bounds is not None else 0)
        errors_upper = (upper_bounds if upper_bounds is not None else 0) - (central_val if central_val is not None else 0)

        flux_pois.append(central_val)
        error_poiss_lower.append(errors_lower)
        error_poiss_upper.append(errors_upper)

    # Combine the lower and upper errors into a format acceptable for error bars
    error_poiss = [error_poiss_lower, error_poiss_upper]

    # Plot the Poisson light curve with error bars
    ax3.errorbar(label, flux_pois, yerr=error_poiss, fmt='o', color='magenta', 
                  capsize=5, capthick=2, ecolor='magenta', linestyle='None', 
                  marker='s', markersize=5, label='Poisson Lc')

    # Get x-axis limits for filling regions
    x_limits = ax3.get_xlim()

    # Plot old reference line and fill area
    ax3.axhline(y=old[0], color='black', linestyle='--')
    ax3.fill_between(x_limits, old[0], old[1], color='grey', alpha=0.5)

    # Plot new reference line and fill area
    ax3.axhline(y=new[0], color='blue', linestyle='--')
    ax3.fill_between(x_limits, new[0], new[1], color='lime', alpha=0.8)

    # Get original flux values and errors
    flux_orig, error_orig = [], []
    for h in years:
        c, d = extract_data_flux(h, index)
        flux_orig.append(c)
        error_orig.append(d)

    # Plot the Gaussian light curve with error bars
    ax3.errorbar(new_labels, flux_orig, yerr=error_orig, fmt='o', color='black', 
                  capsize=5, capthick=2, ecolor='black', linestyle='None', 
                  marker='s', markersize=5, label='Gaussian Lc')

    # Finalize the plot
    ax3.set_xlabel('Epoch')
    ax3.set_ylabel('Flux Value')
    ax3.legend()
    ax3.set_title('Light Curve')
    plt.suptitle(f'Index: {index}')
    plt.tight_layout()
    plt.savefig(f'plot_{index}.png')
    plt.show()
    
##############END OF PLOT#############
