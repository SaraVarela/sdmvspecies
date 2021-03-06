### R code from vignette source 'sdmvspecies.Rnw'
### Encoding: UTF-8

###################################################
### code chunk number 1: foo
###################################################

options(width = 60)
set.seed(0)


###################################################
### code chunk number 2: niche_Synthsis_Method
###################################################
# load the sdmvspecies library
library("sdmvspecies")
# load parallel library for use mutilcore CPU
library("parallel")
# find package's location
package.dir <- system.file(package="sdmvspecies")
# let see where is our sdmvspecies is installed in
package.dir
# find env dir under the package's location
env.dir <- paste(package.dir, "/external/env/", sep="")
# let see env dir
env.dir
# get the environment raster file
env.files <- list.files(env.dir, pattern="*.bil$", full.names=TRUE)
# see the file list
env.files
# put the environment file in a raster stack, 
# which require all the environment should have same resolution and extend
env.stack <- stack(env.files)
# let see the env.stack var
env.stack
# here let's configure the environment response function and weight
config <- list(
    c("bio1","1",2), 
    c("bio14", "2", 2), 
    c("bio5", "3", 1), 
    c("bio11", "4", 2), 
    c("bio16", "5", 1)
    )
# call the niche synthsis method
species.raster <- nicheSynthese(env.stack, config)
# let see the result raster,
# you should noticed that it's continue value map not distributin map
species.raster

# write the map to file, so you can use it latter in GIS software
# or further analysis.
# 
#writeRaster(species.raster, "synthese.img", "HFA", overwrite=TRUE)

# to make binary distribution map, you should chosee a threshold to make map
# see the map then to decide the threshold to binary
plot(species.raster)
# choice threshold, here we choice 4
threshold <- 14
# make binary map
distribution.map <- species.raster > threshold
# plot the map out
plot(distribution.map)


###################################################
### code chunk number 3: bell_shaped_response_function
###################################################
library("ggplot2")
library("grid") # needed for arrow function
env <- seq(5, 15, length=1000)
suitability <- dnorm(env, mean=10, sd=1.5)
plot.data <- data.frame(environment=env,suitability=suitability)
ggplot() +
theme_bw() +
    theme(axis.line=element_blank(),
      axis.text.x=element_blank(),
      axis.text.y=element_blank(),
      axis.ticks=element_blank(),
      legend.position="none",
      panel.background=element_blank(),
      panel.border=element_blank(),
      panel.grid.major=element_blank(),
      panel.grid.minor=element_blank(),
      plot.background=element_blank()) +
layer(geom='line', data=plot.data, mapping=aes(x=environment, y =suitability)) +
layer(geom='segment', mapping=aes(x = 4, y = 0, xend=17, yend=0), arrow = arrow(length = unit(0.5, "cm"))) +
layer(geom='segment', mapping=aes(x = 4, y = 0, xend=4, yend=0.3), arrow = arrow(length = unit(0.5, "cm")))
#plot(env, suitability, type="l", lwd=1)


###################################################
### code chunk number 4: linear_increasing_function
###################################################
library("ggplot2")
library("grid") # needed for arrow function
env <- seq(5, 15)
suitability <- 0.08*(env-4)
plot.data <- data.frame(environment=env,suitability=suitability)
ggplot() +
theme_bw() +
    theme(axis.line=element_blank(),
      axis.text.x=element_blank(),
      axis.text.y=element_blank(),
      axis.ticks=element_blank(),
      legend.position="none",
      panel.background=element_blank(),
      panel.border=element_blank(),
      panel.grid.major=element_blank(),
      panel.grid.minor=element_blank(),
      plot.background=element_blank()) +
layer(geom='line', data=plot.data, mapping=aes(x=environment, y =suitability)) +
layer(geom='segment', mapping=aes(x = 4, y = 0, xend=17, yend=0), arrow = arrow(length = unit(0.5, "cm"))) +
layer(geom='segment', mapping=aes(x = 4, y = 0, xend=4, yend=1), arrow = arrow(length = unit(0.5, "cm")))
#plot(env, suitability, type="l", lwd=1)


###################################################
### code chunk number 5: linear_decreasing_function
###################################################
library("ggplot2")
library("grid") # needed for arrow function
env <- seq(5, 15)
suitability <- 0.08*(15-env)+0.1
plot.data <- data.frame(environment=env,suitability=suitability)
ggplot() +
theme_bw() +
    theme(axis.line=element_blank(),
      axis.text.x=element_blank(),
      axis.text.y=element_blank(),
      axis.ticks=element_blank(),
      legend.position="none",
      panel.background=element_blank(),
      panel.border=element_blank(),
      panel.grid.major=element_blank(),
      panel.grid.minor=element_blank(),
      plot.background=element_blank()) +
layer(geom='line', data=plot.data, mapping=aes(x=environment, y =suitability)) +
layer(geom='segment', mapping=aes(x = 4, y = 0, xend=17, yend=0), arrow = arrow(length = unit(0.5, "cm"))) +
layer(geom='segment', mapping=aes(x = 4, y = 0, xend=4, yend=1), arrow = arrow(length = unit(0.5, "cm")))
#plot(env, suitability, type="l", lwd=1)


###################################################
### code chunk number 6: truncated_linear_increasing_function
###################################################
library("ggplot2")
library("grid") # needed for arrow function

env <- seq(5, 15)
suitability <- 0.08*(env-4)
plot.data <- data.frame(environment=env,suitability=suitability)

env <- seq(15, 21)
suitability <- rep(0.88, length(env))
plot.data2 <- data.frame(environment=env,suitability=suitability)

ggplot() +
theme_bw() +
    theme(axis.line=element_blank(),
      axis.text.x=element_blank(),
      axis.text.y=element_blank(),
      axis.ticks=element_blank(),
      legend.position="none",
      panel.background=element_blank(),
      panel.border=element_blank(),
      panel.grid.major=element_blank(),
      panel.grid.minor=element_blank(),
      plot.background=element_blank()) +
layer(geom='line', data=plot.data, mapping=aes(x=environment, y =suitability)) + 
layer(geom='line', data=plot.data2, mapping=aes(x=environment, y =suitability)) +
layer(geom='segment', mapping=aes(x = 0, y = 0, xend=25, yend=0), arrow = arrow(length = unit(0.5, "cm"))) +
layer(geom='segment', mapping=aes(x = 0, y = 0, xend=0, yend=1), arrow = arrow(length = unit(0.5, "cm")))


###################################################
### code chunk number 7: truncated_linear_decrease_function
###################################################
library("ggplot2")
library("grid") # needed for arrow function

env <- seq(5, 15)
suitability <- 0.08*(16-env)
plot.data <- data.frame(environment=env,suitability=suitability)

env <- seq(-1, 5)
suitability <- rep(0.88, length(env))
plot.data2 <- data.frame(environment=env,suitability=suitability)

ggplot() +
theme_bw() +
    theme(axis.line=element_blank(),
      axis.text.x=element_blank(),
      axis.text.y=element_blank(),
      axis.ticks=element_blank(),
      legend.position="none",
      panel.background=element_blank(),
      panel.border=element_blank(),
      panel.grid.major=element_blank(),
      panel.grid.minor=element_blank(),
      plot.background=element_blank()) +
layer(geom='line', data=plot.data, mapping=aes(x=environment, y =suitability)) + 
layer(geom='line', data=plot.data2, mapping=aes(x=environment, y =suitability)) +
layer(geom='segment', mapping=aes(x = -3, y = 0, xend=20, yend=0), arrow = arrow(length = unit(0.5, "cm"))) +
layer(geom='segment', mapping=aes(x = -3, y = 0, xend=-3, yend=1), arrow = arrow(length = unit(0.5, "cm")))


###################################################
### code chunk number 8: comment configure code
###################################################
config <- list(
    c("bio1","1",2), 
    c("bio14", "2", 2), 
    c("bio5", "3", 1), 
    c("bio11", "4", 2), 
    c("bio16", "5", 1)
    )


###################################################
### code chunk number 9: pick_mean_method
###################################################
# load the sdmvspecies library
library("sdmvspecies")
# find package's location
package.dir <- system.file(package="sdmvspecies")
# let see where is our sdmvspecies is installed in
package.dir
# find env dir under the package's location
env.dir <- paste(package.dir, "/external/env/", sep="")
# let see env dir
env.dir
# get the environment raster file
file.name <- files <- c("bio1.bil", "bio12.bil", "bio7.bil", "bio5.bil")
files <- paste(env.dir, file.name, sep="")
# make raster stack
env.stack <- stack(files)
# run pick mean
species.raster <- pickMean(env.stack)
# plot map
plot(species.raster)


###################################################
### code chunk number 10: pick_median_method
###################################################
# load the sdmvspecies library
library("sdmvspecies")
# load parrllel to use mutilcore CPU
library("parallel")
# find package's location
package.dir <- system.file(package="sdmvspecies")
# let see where is our sdmvspecies is installed in
package.dir
# find env dir under the package's location
env.dir <- paste(package.dir, "/external/env/", sep="")
# let see env dir
env.dir
# get the environment raster file
file.name <- files <- c("bio1.bil", "bio12.bil", "bio7.bil", "bio5.bil")
files <- paste(env.dir, file.name, sep="")
# make raster stack
env.stack <- stack(files)
# run pick mean
species.raster <- pickMedian(env.stack)
# plot map
plot(species.raster)


###################################################
### code chunk number 11: artificial_bell_response_method
###################################################
# load the sdmvspecies library
library("sdmvspecies")
# load parrllel to use mutilcore CPU
#library("parallel")
# find package's location
package.dir <- system.file(package="sdmvspecies")
# let see where is our sdmvspecies is installed in
package.dir
# find env dir under the package's location
env.dir <- paste(package.dir, "/external/env/", sep="")
# let see env dir
env.dir
# get the environment raster file
file.name <- files <- c("bio1.bil", "bio12.bil", "bio7.bil", "bio5.bil")
files <- paste(env.dir, file.name, sep="")
# make raster stack
env.stack <- stack(files)
# config
config <- list(c("bio1",150, 50), c("bio12", 2000, 500), c("bio7", 400, 100), c("bio5", 300, 100))
# run pick mean
species.raster <- artificialBellResponse(env.stack, config)
# plot map
plot(species.raster)
# species distribution map
species.distribution.raster <- species.raster > 0.2
# plot map
plot(species.distribution.raster)


