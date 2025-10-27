# Example of simulation to study properties of a line transect study
# Refer to http://www.ruwpa.st-and.ac.uk/estimating.abundance/WiSP/downloadables/wisp_tutorial.pdf


library(wisp)

# Generate the survey region
myreg <- generate.region(x.length=100, y.width=100)
myreg
plot(myreg)


# Generate the density in the survey region
# I've given two options with the density gradient sifted in direction from north/south to east/west.
mydens <- generate.density(myreg, 
     southwest=0,southeast=0,northwest=10,nint.x=25, nint.y=10)
#mydens <- generate.density(myreg, 
#     southwest=0,southeast=10,northwest=0,nint.x=25, nint.y=10)

# The density plane is defined by its height at the southwest, southeast, and northwest corners of the region. 
# To view the density surface as a 3-D plot type
plot(mydens)

# To view a multi-coloured plot of the density, type
plot(mydens,method="image")

# Generate the individual animals
mypop.pars<-setpars.population(mydens, number.groups=250,
             size.method="poisson", size.min=1, size.max=5, size.mean=1,
             exposure.method="beta", exposure.min=2, exposure.max=10, exposure.mean=6,
             exposure.shape=1, type.values = c("Male","Female"),
             type.prob = c(0.48,0.52))

# generate a population called mypop,
mypop <- generate.population(mypop.pars, seed=12345)

# view the population 
plot(mypop, type="locations")

# Each dot is a group of animals; 
#     larger dots correspond to bigger groups of animals.
#     Lighter dots correspond to less detectable animals.
plot(mypop)
summary(mypop)


#-------------------- Design a survey ---------------

#  Design the survey
mydes.pars<-setpars.design.lt(myreg, 
      n.transects = 20, n.units = 20, 
      visual.range=1, # this is the strip half-width
      percent.on.effort = 1)

# Generate a design
mydes <- generate.design.lt(mydes.pars, seed=1212)
summary(mydes)
# Plot the design 
plot(mydes)


#---------------------- Generate and analyze a sample 
# Generate a sample
lt.survpars<-setpars.survey.lt(mypop, mydes, disthalf.min=.2, disthalf.max=.4)

mysamp <- generate.sample.lt(lt.survpars)
summary(mysamp)
plot(mysamp)

# generate an estimate
my.point.est<-point.est.lt(mysamp)
summary(my.point.est)

# get a confidence interval using bootstrapping
my.ci.est <-int.est.lt(mysamp)
summary(my.ci.est)



