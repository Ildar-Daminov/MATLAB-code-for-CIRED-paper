# Optimal ageing limit of oil-immersed transformers in flexible power systems

<img align="left" alt="Coding" width="110" src="https://www.cired2021.org/media/1719/cired-2021_logo-red-black-002.jpg">

  
This repository shares the MATLAB code and data for the conference paper 📋:\
Ildar Daminov, Anton Prokhorov, Raphael Caire, Marie-Cécile Alvarez-Herault, [“Optimal ageing limit of oil-immersed transformers in flexible power systems”](https://hal.archives-ouvertes.fr/G2ELAB/hal-03355187v1), in CIRED conference, Geneva, Switzerland (held online), 2021,DOI: 10.1049/icp.2021.1586
  
  
## Paper's abstract
This paper investigates the choice of optimal ageing limit of transformers in flexible power systems. In contrast to similar studies, the paper considers the remaining calendar life of transformers. Moreover, it is shown that for the same insulation ageing it is possible to transfer a different amount of energy through transformers. Hence, the paper uses a maximal energy transfer as criterion for defining the optimal ageing limit of transformers (both the existing and new ones). Results reveal that the optimal ageing limit for transformers should be equal to the ratio between the remaining insulation life and the remaining calendar life. Moreover, the paper presents the energy transfer through new transformer as function of various ageing limits and different durations of a calendar life. Hence, the choice of ageing limit can differ from traditionally used (normal) ageing limit if system operators consider the ratio between the remaining insulation life of transformers and their remaining calendar life. MATLAB code is available for readers in open access.

## How to run a code 
1. Copy this repository to your computer 
2. Open the main script (depending on the selected study - 'main_optim_energy_limit.m.m or main_random_load_profile.m or main_Figure6.m or main_Figure8.m)
3. Launch the script by clicking on the button "Run" (usually located at the top of MATLAB window).


## Description of files

The original paper in pdf:  
* FINAL PAPER.pdf

Main MATLAB scripts:
* main_random_load_profile.m    this script finds the random loading profile of transformer causing the normal ageing. In the 
                                paper, Figure 1 shows three random loading profiles generated with this script 
* main_optim_energy_limit.m     this script finds the optimal loading profile which maximizes the energy transfer through 
                                transformer (for 1 day and 7 days). In the paper these results are shown in Figure 4
* main_Figure6.m                this script generates the data for Figure 6
  
* main_Figure8.m                this script generates data and the Figure 8

Additional functions:  
* distrbution_transformer_optim.m         thermal model of ONAN distribution transformer in accordance with IEC 60076-7. This 
                                          function is called in optimal_energy_limit.m and in main_optim_energy_limit.m. 
  
* distrbution_transformer_random_load.m   the same thermal model of ONAN distribution transformer but with different outputs.
                                          This function is called in main_random_load_profile.m        
  
* optimal_energy_limit.m                  optimization problem formulated in MATLAB (Problem-based formulation). The objective 
                                          function is maximization of energy transfer through transformer. Constraints: 
                                          Hot spot temperature<=120 degC; Top-oil temperature<=105 degC and Ageing<=1 pu
 
* optimal_energy_limitFig6.m              The same as optimal_energy_limit.m but with additonal outputs (needed for Fig.6)                              
  
* PUL_to_1min.m                           Function which converts hour data into 1-min resolution
  
* createfigure8.m                         Function which creates the Figure 8 (used in main_Figure8.m)

Data: 
* Variable_ambient_temperature.mat        Data (168x1) on ambient temperature during 1 week (source: [MeteoBlue](https://www.meteoblue.com/fr/historyplus)) 
  
* ONAN_interm_results.mat                 Precalculated data for construction of Figure 6 (used in main_Figure6.m)
  
* Folder "Figures"                        Folder contains Figure 3, Figure 4 and Figure 8 from the paper

## How to cite this paper 
Ildar Daminov, Anton Prokhorov, Raphael Caire, Marie-Cécile Alvarez-Herault, “Optimal ageing limit of oil-immersed transformers in flexible power systems”, in CIRED conference, Geneva, Switzerland (held online), 2021,DOI: 10.1049/icp.2021.1586


## More about DTR of power transformers 
<img align="left" alt="Coding" width="250" src="https://sun9-19.userapi.com/impg/3dcwjraHJPNgrxtWv7gEjZTQkvv5T0BttTDwVg/e9rt2Xs8Y5A.jpg?size=763x1080&quality=95&sign=7c57483971f31f7009fbcdce5aafd97e&type=album">This paper is a part of PhD thesis "Dynamic Thermal Rating of Power Transformers: Modelling, Concepts, and Application case". The full text of PhD thesis is available on [Researchgate](https://www.researchgate.net/publication/363383515_Dynamic_Thermal_Rating_of_Power_Transformers_Modelling_Concepts_and_Application_case) or [HAL theses](https://tel.archives-ouvertes.fr/tel-03772184). Other GitHub repositories on DTR of power transformers:
* Article: Assessment of dynamic transformer rating, considering current and temperature limitations. [GitHub repository](https://github.com/Ildar-Daminov/Assessment_Dynamic_Thermal_Rating_of_Transformers)
* Article: Demand Response Coupled with Dynamic Thermal Rating for Increased Transformer Reserve and Lifetime. [GitHub repository](https://github.com/Ildar-Daminov/Demand-response-coupled-with-DTR-of-transformers)
* Article: Energy limit of oil-immersed transformers: A concept and its application in different climate conditions. [GitHub repository](https://github.com/Ildar-Daminov/Energy-limit-of-power-transformer)
* Conference paper: Application of dynamic transformer ratings to increase the reserve of primary substations for new load interconnection. [GitHub repository](https://github.com/Ildar-Daminov/Reserve-capacity-of-transformer-for-load-connection)
* Conference paper: Receding horizon algorithm for dynamic transformer rating and its application for real-time economic dispatch. [GitHub repository](https://github.com/Ildar-Daminov/Receding-horizon-algorithm-for-dynamic-transformer-rating)
