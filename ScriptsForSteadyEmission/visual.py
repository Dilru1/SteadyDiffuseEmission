import numpy as np
import matplotlib.pyplot as plt

# Base settings
base_fig_size = (6, 4)  # Width, height in inches
base_font_size = 10  # Base font size for 6x4 inch figure

def adjust_font_size(fig_width, fig_height, base_size=base_font_size, base_fig_size=base_fig_size):
    scale_factor = (fig_width * fig_height) / (base_fig_size[0] * base_fig_size[1])
    return base_size * scale_factor**0.5

def adjust_visual_params(fig_width, fig_height, base_fig_size=base_fig_size):
    scale_factor = (fig_width * fig_height) / (base_fig_size[0] * base_fig_size[1])
    return {
        "figure.dpi": 100 * scale_factor**0.5,
        "lines.linewidth": 1.5 * scale_factor**0.5,
        "lines.markersize": 6 * scale_factor**0.5,
        "axes.linewidth": 1.0 * scale_factor**0.5,
        "xtick.major.size": 5 * scale_factor**0.5,
        "ytick.major.size": 5 * scale_factor**0.5,
        "xtick.minor.size": 3 * scale_factor**0.5,
        "ytick.minor.size": 3 * scale_factor**0.5,
    }

def update_plt_settings(fig_width, fig_height):
    font_size = adjust_font_size(fig_width, fig_height)
    visual_params = adjust_visual_params(fig_width, fig_height)
    
    plt.rcParams.update({
        "font.family": "serif",
        'font.size': font_size,
        'axes.labelsize': font_size,
        'xtick.labelsize': font_size * 0.8,
        'ytick.labelsize': font_size * 0.8,
        "legend.fontsize": font_size * 0.8,
        "legend.frameon": False,
        "pgf.texsystem": "pdflatex",
        **visual_params  # Merge the dynamically calculated visual parameters
    })



