# For this moment you can find the original paper and  MATLAB code: 
<pre>
The original paper in pdf:  
  FINAL PAPER.pdf

Main MATLAB scripts:
  main_random_load_profile.m    this script finds the random loading profile of transformer causing the normal ageing. In the 
                                paper, Figure 1 shows three random loading profiles generated with this script 
  main_optim_energy_limit.m     this script finds the optimal loading profile which maximizes the energy transfer through 
                                transformer (for 1 day and 7 days). In the paper these results are shown in Figure 4
  main_Figure6.m                this script generates the data for Figure 6
  
  main_Figure8.m                this script generates data and the Figure 8

Additional functions and data:  
  distrbution_transformer_optim.m         thermal model of ONAN distribution transformer in accordance with IEC 60076-7. This 
                                          function is called in optimal_energy_limit.m and in main_optim_energy_limit.m. 
  
  distrbution_transformer_random_load.m   the same thermal model of ONAN distribution transformer but with different outputs.
                                          This function is called in main_random_load_profile.m        
  
  optimal_energy_limit.m                  optimization problem formulated in MATLAB (Problem-based formulation). The objective 
                                          function is maximization of energy transfer through transformer. Constraints: 
                                          Hot spot temperature<=120 degC; Top-oil temperature<=105 degC and Ageing<=1 pu
 
  optimal_energy_limitFig6.m              The same as optimal_energy_limit.m but with additonal outputs (needed for Fig.6)                              
  
  PUL_to_1min.m                           Function which converts hour data into 1-min resolution
  
  createfigure8.m                         Function which creates the Figure 8 (used in main_Figure8.m)
  
  Variable_ambient_temperature.mat        Data (168x1) on ambient temperature during 1 week
  
  ONAN_interm_results.mat                 Precalculated data for construction of Figure 6 (used in main_Figure6.m)
  
  
Folder with  MATLAB figures from paper    Folder contains Figure 3, Figure 4 and Figure 8 from the paper

</pre>
