#Source for the codes - https://cran.r-project.org/web/packages/Synth/Synth.pdf

install.packages("Synth") 
library(Synth)

#Basque data used for explanatory purposes
data("basque")

#Panel data with 774 observation for 17 different variables. 
#Variable explanation is available for reference in Page 6 of the  https://core.ac.uk/download/pdf/6287910.pdf


######################################################################################################

#Data preparation
#The data available here is in the form of a panel. This has to be converted into appropriate format usign the dataprep() value. 

dataprep.out <- dataprep(
                        #data
                        foo = basque, 
                        
                        #predictors that define our outcome variable gdp
                        predictors = c('school.illit', 'school.prim', 'school.med',
                                                      'school.high', 'school.post.high', 'invest'), 
                        
                        #output operator
                        predictors.op = 'mean',  
                        
                        #pre treatment years under consideration for synthetic control 
                        time.predictors.prior = 1964:1969,  
                        
                        #data preparation
                        special.predictors = list(
                          list('gdpcap', 1960:1969, 'mean'),
                          list('sec.agriculture', seq(1961,1969,2),'mean'),
                          list('sec.energy',seq(1961,1969,2),'mean'),
                          list('sec.industry', seq(1961,1969,2),'mean'),
                          list('sec.construction', seq(1961,1969,2),'mean'),
                          list('sec.services.venta', seq(1961,1969,2),'mean'),
                          list('sec.services.nonventa',seq(1961,1969,2),'mean'), 
                          list('popdens', 1969, 'mean')), 
                        
                        #outcome of interest
                        dependent = 'gdpcap', 
                        
                        #identifiers
                        unit.variable = 'regionno', 
                        unit.names.variable = 'regionname', 
                        time.variable = 'year', 
                        
                        #Treatment variable
                        treatment.identifier = 17, 
                        
                        #Control pool
                        controls.identifier = c(2:16, 18), 
                        
                        #Time period for establishing synthetic control, pre treatment
                        time.optimize.ssr = 1960:1969, 
                        
                        #Entire time period
                        time.plot = 1955:1997)


######################################################################################################
#Running synthetic control
synth.out <- synth(data.prep.obj = dataprep.out) #default optimx function is c("Nelder-Mead", "BFGS").


#Plotting results
path.plot(synth.res = synth.out, dataprep.res = dataprep.out,
          Ylab = "real per-capita GDP (1986 USD, thousand)", Xlab = "year",
          Ylim = c(0, 12), Legend = c("Basque country",
                                         "synthetic Basque country"), Legend.position = "bottomright")


######################################################################################################
# For placebo test:
#Do the same as above, but replace the treatment idenfier with one of the control identifiers and observe the synthetic control effect.