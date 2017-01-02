---
layout: post
title: "All available elemental properties plotted as periodic tables"
date: 2015-01-30 20:00:00 GMT
tags:
- periodic table
- elemental properties
- ggplot2
published: true
comments: true
---



## Introduction

In the [previous post](http://chepec.se/2014/11/16/element-data.html) we showed how `ggplot2` can be used to effectively and quickly render a periodic table overlaid with near-arbitrary elemental data.

Let's use this newfound ability to visualise all the datasets we have available to us.



{% highlight r %}
library(ggplot2)
library(dplyr)
library(grid)
library(knitr)
{% endhighlight %}






## Available elemental properties

Some properties are not suited for this type of visualisation, and will be excluded (see `donotplot` vector below). Others are better visualised as discrete variables, although they are numeric in format. Such properties will be converted back to character (see `numericasdiscrete` below).


{% highlight r %}
# drop some redundant columns
values <- values[, -grep(pattern = "^Absolute.*", names(values))]
units <- units[, -grep(pattern = "^Absolute.*", names(units))]
# some columns are not suitable for this format of visualisation
donotplot <-
   c("Name",
     "Symbol",
     "Group",
     "Graph.Group",
     "Period",
     "Graph.Period",
     "EU_Number",
     "RTECS_Number",
     "Alternate_Names",
     "Electron_Configuration",
     "CAS_Number",
     "CID_Number",
     "Gmelin_Number",
     "NSC_Number",
     "Quantum_Numbers",
     "Space_Group_Name",
     "Space_Group_Number")
# some numeric columns are better visualised as discrete variables
numericasdiscrete <-
   c("DOT_Hazard_Class",
     "NFPA_Fire_Rating",
     "NFPA_Health_Rating",
     "NFPA_Reactivity_Rating")
for (i in 1:length(numericasdiscrete)) {
   values[, which(names(values) == numericasdiscrete[i])] <-
      as.character(values[, which(names(values) == numericasdiscrete[i])])
}
{% endhighlight %}


Here are all the elemental properties that have been deemed suitable for visualisation.


{% highlight r %}
str(values)
{% endhighlight %}



{% highlight text %}
## 'data.frame':	118 obs. of  80 variables:
##  $ Name                          : chr  "Hydrogen" "Helium" "Lithium" "Beryllium" ...
##  $ Symbol                        : chr  "H" "He" "Li" "Be" ...
##  $ Atomic_Number                 : num  1 2 3 4 5 6 7 8 9 10 ...
##  $ Atomic_Weight                 : num  1.01 4 6.94 9.01 10.81 ...
##  $ Density                       : num  8.99e-02 1.78e-01 5.35e+02 1.85e+03 2.46e+03 ...
##  $ Melting_Point                 : num  14 NA 454 1560 2348 ...
##  $ Boiling_Point                 : num  20.28 4.22 1615.15 2743.15 4273.15 ...
##  $ Phase                         : chr  "Gas" "Gas" "Solid" "Solid" ...
##  $ Critical_Pressure             : num  1293000 NA NA NA 3390000 ...
##  $ Critical_Temperature          : num  32.97 5.19 3223 NA NA ...
##  $ Heat_of_Fusion                : num  0.558 0.02 3 7.95 50 105 0.36 0.222 0.26 0.34 ...
##  $ Heat_of_Vaporization          : num  0.452 0.083 147 297 507 715 2.79 3.41 3.27 1.75 ...
##  $ Heat_of_Combustion            : num  NA NA -298 NA NA -393 NA NA NA NA ...
##  $ Specific_Heat                 : num  14300 NA 1820 240 1040 165 1030 154 904 140 ...
##  $ Adiabatic_Index               : chr  "7/5" "5/3" NA NA ...
##  $ Neel_Point                    : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ Thermal_Conductivity          : num  0.18 0.151 85 190 27 ...
##  $ Thermal_Expansion             : num  NA NA 4.60e-05 1.13e-05 6.00e-06 7.10e-06 NA NA NA NA ...
##  $ Density_Liquid                : num  NA NA 512 1690 2080 NA NA NA NA NA ...
##  $ Molar_Volume                  : num  1.12e-02 2.24e-02 1.30e-05 4.88e-06 4.39e-06 ...
##  $ Brinell_Hardness              : num  NA NA NA 6e+08 NA NA NA NA NA NA ...
##  $ Mohs_Hardness                 : num  NA NA 600000 5500000 9300000 500000 NA NA NA NA ...
##  $ Vickers_Hardness              : num  NA NA NA 1.67e+09 4.90e+10 ...
##  $ Bulk_Modulus                  : num  NA NA 1.1e+10 1.3e+11 3.2e+11 ...
##  $ Shear_Modulus                 : num  NA NA 4.20e+09 1.32e+11 NA ...
##  $ Young_Modulus                 : num  NA NA 4.90e+09 2.87e+11 NA ...
##  $ Poisson_Ratio                 : num  NA NA NA 0.032 NA NA NA NA NA NA ...
##  $ Refractive_Index              : num  1 1 NA NA NA ...
##  $ Speed_of_Sound                : num  1270 970 6000 13000 16200 ...
##  $ Valence                       : num  1 0 1 2 3 4 3 2 1 0 ...
##  $ Electronegativity             : num  2.2 NA 0.98 1.57 2.04 2.55 3.04 3.44 3.98 NA ...
##  $ ElectronAffinity              : num  72.8 0 59.6 0 26.7 ...
##  $ Autoignition_Point            : num  809 NA 452 NA NA ...
##  $ Flashpoint                    : num  255 NA NA NA NA ...
##  $ DOT_Hazard_Class              : chr  "2.1" "2.2" "4.3" "6.1" ...
##  $ DOT_Numbers                   : num  1966 1963 1415 1567 NA ...
##  $ EU_Number                     : chr  "EU215-605-7" "EU231-168-5" "EU231-102-5" "EU231-150-7" ...
##  $ NFPA_Fire_Rating              : chr  "4" "0" "2" "1" ...
##  $ NFPA_Health_Rating            : chr  "3" "1" "3" "3" ...
##  $ NFPA_Reactivity_Rating        : chr  "0" "0" "2" "0" ...
##  $ RTECS_Number                  : chr  "RTECSMW8900000" NA "RTECSDS1750000" "RTECSLW3850000" ...
##  $ Alternate_Names               : chr  NA NA NA NA ...
##  $ Block                         : chr  "s" "p" "s" "s" ...
##  $ Group                         : chr  "1" "18" "1" "2" ...
##  $ Period                        : chr  "1" "1" "2" "2" ...
##  $ Electron_Configuration        : chr  "1s1" "[Xe]4f56s2" "[He]2s2" "[Xe]4f75d16s2" ...
##  $ Color                         : chr  "Colorless" "Colorless" "Silver" "SlateGray" ...
##  $ Gas_phase                     : chr  "Diatomic" "Monoatomic" NA NA ...
##  $ CAS_Number                    : chr  "CAS1333-74-0" "CAS7440-59-7" "CAS7439-93-2" "CAS7440-41-7" ...
##  $ CID_Number                    : chr  "CID783" "CID23987" "CID3028194" "CID5460467" ...
##  $ Gmelin_Number                 : chr  "Gmelin3" "Gmelin16294" "Gmelin30" "Gmelin16256" ...
##  $ NSC_Number                    : chr  NA NA NA NA ...
##  $ Electrical_Type               : chr  NA NA "Conductor" "Conductor" ...
##  $ Electrical_Conductivity       : num  NA NA 1.1e+07 2.5e+07 1.0e-04 1.0e+05 NA NA NA NA ...
##  $ Resistivity                   : num  NA NA 9.4e-08 4.0e-08 1.0e+04 1.0e-05 NA NA NA NA ...
##  $ Superconducting_Point         : num  NA NA NA 0.026 NA NA NA NA NA NA ...
##  $ Magnetic_Type                 : chr  "Diamagnetic" "Diamagnetic" "Paramagnetic" "Diamagnetic" ...
##  $ Curie_Point                   : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ Mass_Magnetic_Susceptibility  : num  -2.48e-08 -5.90e-09 6.30e-09 -1.26e-08 -8.70e-09 ...
##  $ Molar_Magnetic_Susceptibility : num  -2.50e-11 -2.36e-11 4.37e-11 -1.14e-10 -9.41e-11 ...
##  $ Volume_Magnetic_Susceptibility: num  -2.23e-09 -1.05e-09 3.37e-06 -2.33e-05 -2.14e-05 ...
##  $ Percent_in_Universe           : num  7.5e+01 2.3e+01 6.0e-07 1.0e-07 1.0e-07 5.0e-01 1.0e-01 1.0 4.0e-05 1.3e-01 ...
##  $ Percent_in_Sun                : num  7.5e+01 2.3e+01 6.0e-09 1.0e-08 2.0e-07 3.0e-01 1.0e-01 9.0e-01 5.0e-05 1.0e-01 ...
##  $ Percent_in_Meteorites         : num  2.4 NA 1.7e-04 2.9e-06 1.6e-04 1.5 1.4e-01 4.0e+01 8.7e-03 NA ...
##  $ Percent_in_Earths_Crust       : num  1.5e-01 5.5e-07 1.7e-03 1.9e-04 8.6e-04 1.8e-01 2.0e-03 4.6e+01 5.4e-02 3.0e-07 ...
##  $ Percent_in_Oceans             : num  1.1e+01 7.2e-10 1.8e-05 6.0e-11 4.4e-04 ...
##  $ Percent_in_Humans             : num  1.0e+01 NA 3.0e-06 4.0e-08 7.0e-05 2.3e+01 2.6 6.1e+01 3.7e-03 NA ...
##  $ Atomic_Radius                 : num  5.30e-11 3.10e-11 1.67e-10 1.12e-10 8.70e-11 ...
##  $ Covalent_Radius               : num  3.70e-11 3.20e-11 1.34e-10 9.00e-11 8.20e-11 ...
##  $ Van_der_Waals_Radius          : num  1.20e-10 1.40e-10 1.82e-10 NA NA 1.70e-10 1.55e-10 1.52e-10 1.47e-10 1.54e-10 ...
##  $ Space_Group_Name              : chr  "P63/mmc" "Fm_\n3m" "Im_\n3m" "P63/mmc" ...
##  $ Space_Group_Number            : num  194 225 229 194 166 194 194 12 15 225 ...
##  $ HalfLife                      : num  Inf Inf Inf Inf Inf ...
##  $ Lifetime                      : num  Inf Inf Inf Inf Inf ...
##  $ Decay_Mode                    : chr  NA NA NA NA ...
##  $ Quantum_Numbers               : chr  "2S1/2" "1S0" "2S1/2" "1S0" ...
##  $ Neutron_Cross_Section         : num  3.32e-01 7.00e-03 4.50e-02 9.20e-03 7.55e+02 3.50e-03 1.91 2.80e-04 9.60e-03 4.00e-02 ...
##  $ Neutron_Mass_Absorption       : num  1.1e-02 1.0e-05 NA 3.0e-05 2.4 1.5e-05 4.8e-03 1.0e-06 2.0e-05 6.0e-04 ...
##  $ Graph.Period                  : num  1 1 2 2 2 2 2 2 2 2 ...
##  $ Graph.Group                   : num  1 18 1 2 13 14 15 16 17 18 ...
{% endhighlight %}


## Properties, visualised

Note: the physical state at which the values are stated are not always determined in this dataset. This is a weakness of the web-scraping algorithm, which does not record the notes accompanying many datapoints. This means that the usability of these plots are limited in scope. If someone has an open, curated dataset of elemental properties available, let me know!


We can plot periodic tables of all available properties with just one chunk (using some looping, of course).


{% highlight r %}
for (k in 1:dim(values)[2]) {
   # withhold some columns from plotting
   if (names(values)[k] %in% donotplot) {
      next
   }
   # numeric or character column?
   if (class(values[, k]) == "numeric") {
      p <-
         continuous_property_as_periodic_table(data = data.frame(
            Graph.Group = values$Graph.Group,
            Graph.Period = values$Graph.Period,
            Symbol = values$Symbol,
            Property = gsub("_", " ", names(values)[k]),
            Values = values[, k],
            Unit = units[, k]))
      print(p)
      cat(paste("Summary of", gsub("_", " ", names(values)[k])), "\n")
      print(summary(values[, k]))
   }
   if (class(values[, k]) == "character") {
      p <-
         discrete_property_as_periodic_table(data = data.frame(
            Graph.Group = values$Graph.Group,
            Graph.Period = values$Graph.Period,
            Symbol = values$Symbol,
            Values = values[, k]),
            scale.title = gsub("_", " ", names(values)[k]),
            scale.ncol = 3)
      print(p)
      cat(paste("Count of", gsub("_", " ", names(values)[k])), "\n")
      print(count(values, vars = values[, k]))
   }
}
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-1.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Atomic Number 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    1.00   30.25   59.50   59.50   88.75  118.00
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-2.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Atomic Weight 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   1.008  65.410 140.900 144.900 226.000 294.000       1
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-3.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Density 
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
##     0.09  2545.00  7140.00  7646.00 10380.00 22650.00       23
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-4.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Melting Point 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   14.01  544.40 1204.00 1297.00 1811.00 3823.00      17
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-5.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Boiling Point 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    4.22 1194.00 2816.00 2559.00 3604.00 5869.00      24
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-6.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Count of Phase 
## Source: local data frame [4 x 2]
## 
##     vars     n
##    (chr) (int)
## 1    Gas    11
## 2 Liquid     2
## 3  Solid    86
## 4     NA    19
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-7.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Critical Pressure 
##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max.      NA's 
##    227000   5043000   7991000  20650000  16000000 172000000        97
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-8.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Critical Temperature 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    5.19  150.90  416.90  963.70 1766.00 3223.00      97
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-9.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Heat of Fusion 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    0.02    5.40   10.00   13.77   18.70  105.00      25
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-10.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Heat of Vaporization 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0.083  73.220 272.500 265.900 380.000 800.000      24
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-11.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Heat of Combustion 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
## -9055.0  -829.0  -536.0 -1732.0  -345.5  -182.0     111
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-12.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Specific Heat 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    63.0   159.6   241.0   624.5   496.8 14300.0      30
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-13.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Count of Adiabatic Index 
## Source: local data frame [3 x 2]
## 
##    vars     n
##   (chr) (int)
## 1   5/3     6
## 2   7/5     5
## 3    NA   107
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-14.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Neel Point 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    12.5    69.0   100.0   127.2   155.0   393.0     107
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-15.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Thermal Conductivity 
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
##   0.0036  10.0000  23.5000  58.0400  81.5000 430.0000       24
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-16.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Thermal Expansion 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
## 0.00000 0.00001 0.00001 0.00002 0.00002 0.00012      55
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-17.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Density Liquid 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##     512    4240    6980    7706    9330   20000      49
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-18.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Molar Volume 
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
## 0.000004 0.000010 0.000017 0.002021 0.000023 0.022820       23
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-19.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Brinell Hardness 
##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max.      NA's 
## 1.400e+05 1.995e+08 4.900e+08 7.087e+08 8.070e+08 3.920e+09        59
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-20.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Mohs Hardness 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##  200000 1875000 3000000 3740000 6000000 9300000      63
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-21.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Vickers Hardness 
##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max.      NA's 
## 1.670e+08 4.060e+08 6.080e+08 2.108e+09 1.203e+09 4.900e+10        79
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-22.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Bulk Modulus 
##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max.      NA's 
## 1.100e+09 2.800e+10 4.500e+10 9.079e+10 1.400e+11 3.800e+11        49
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-23.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Shear Modulus 
##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max.      NA's 
## 1.300e+09 1.575e+10 2.650e+10 4.685e+10 4.725e+10 2.220e+11        58
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-24.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Young Modulus 
##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max.      NA's 
## 1.700e+09 3.700e+10 6.800e+10 1.105e+11 1.290e+11 5.280e+11        55
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-25.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Poisson Ratio 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##  0.0320  0.2525  0.2800  0.2924  0.3375  0.4500      64
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-26.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Refractive Index 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   1.000   1.000   1.001   1.075   1.001   2.417      99
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-27.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Speed of Sound 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##     206    1948    2750    3506    4626   18350      46
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-28.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Valence 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0.000   3.000   4.000   3.776   5.000   7.000      11
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-29.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Electronegativity 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0.700   1.285   1.625   1.737   2.175   3.980      24
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-30.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of ElectronAffinity 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    0.00   21.08   50.00   76.16  105.40  349.00      32
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-31.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Autoignition Point 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   373.2   430.4   593.2   594.6   728.2   903.2     100
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-32.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Flashpoint 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   255.2   260.6   290.2   463.6   655.6   918.2     112
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-33.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Count of DOT Hazard Class 
## Source: local data frame [10 x 2]
## 
##     vars     n
##    (chr) (int)
## 1    2.1     1
## 2    2.2     7
## 3    2.3     1
## 4    4.1    26
## 5    4.2     8
## 6    4.3     8
## 7    6.1     6
## 8      7     3
## 9      8     4
## 10    NA    54
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-34.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of DOT Numbers 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    1073    1748    2730    2516    3089    9192      52
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-35.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Count of NFPA Fire Rating 
## Source: local data frame [6 x 2]
## 
##    vars     n
##   (chr) (int)
## 1     0    17
## 2     1    13
## 3     2     6
## 4     3     7
## 5     4     4
## 6    NA    71
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-36.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Count of NFPA Health Rating 
## Source: local data frame [6 x 2]
## 
##    vars     n
##   (chr) (int)
## 1     0     3
## 2     1    15
## 3     2    13
## 4     3    12
## 5     4     2
## 6    NA    73
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-37.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Count of NFPA Reactivity Rating 
## Source: local data frame [6 x 2]
## 
##    vars     n
##   (chr) (int)
## 1     0    26
## 2     1     7
## 3     2     9
## 4     3     1
## 5     4     1
## 6    NA    74
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-38.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Count of Block 
## Source: local data frame [4 x 2]
## 
##    vars     n
##   (chr) (int)
## 1     d    40
## 2     f    28
## 3     p    37
## 4     s    13
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-39.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Count of Color 
## Source: local data frame [10 x 2]
## 
##         vars     n
##        (chr) (int)
## 1      Black     2
## 2  Colorless    11
## 3     Copper     1
## 4       Gold     1
## 5       Gray    14
## 6        Red     1
## 7     Silver    59
## 8  SlateGray     5
## 9     Yellow     2
## 10        NA    22
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-40.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Count of Gas phase 
## Source: local data frame [3 x 2]
## 
##         vars     n
##        (chr) (int)
## 1   Diatomic     5
## 2 Monoatomic     6
## 3         NA   107
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-41.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Count of Electrical Type 
## Source: local data frame [4 x 2]
## 
##            vars     n
##           (chr) (int)
## 1     Conductor    72
## 2     Insulator     5
## 3 Semiconductor     3
## 4            NA    38
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-42.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Electrical Conductivity 
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
##        0  1100000  4200000  8775000 11250000 62000000       38
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-43.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Resistivity 
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
## 0.00e+00 0.00e+00 0.00e+00 1.25e+13 0.00e+00 1.00e+15       38
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-44.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Superconducting Point 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0.015   0.490   1.083   2.059   3.410   9.250      85
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-45.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Count of Magnetic Type 
## Source: local data frame [5 x 2]
## 
##                vars     n
##               (chr) (int)
## 1 Antiferromagnetic     1
## 2       Diamagnetic    31
## 3     Ferromagnetic     4
## 4      Paramagnetic    29
## 5                NA    53
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-46.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Curie Point 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    20.0    32.0   222.0   416.2   631.0  1394.0     109
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-47.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Mass Magnetic Susceptibility 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0e+00   0e+00   0e+00   0e+00   0e+00   1e-05      36
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-48.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Molar Magnetic Susceptibility 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##       0       0       0       0       0       0      36
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-49.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Volume Magnetic Susceptibility 
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
## -0.00017 -0.00001  0.00001  0.00340  0.00026  0.11180       37
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-50.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Percent in Universe 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##  0.0000  0.0000  0.0000  1.2060  0.0002 75.0000      35
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-51.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Percent in Sun 
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
##  0.00000  0.00000  0.00000  0.95900  0.00002 75.00000       14
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-52.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Percent in Meteorites 
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
##  0.00000  0.00000  0.00002  0.94260  0.00071 40.00000       11
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-53.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Percent in Earths Crust 
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
##  0.00000  0.00000  0.00011  0.88240  0.00298 46.00000        4
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-54.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Percent in Oceans 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##  0.0000  0.0000  0.0000  0.9125  0.0000 86.0000       8
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-55.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Percent in Humans 
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
##  0.00000  0.00000  0.00000  1.33100  0.00014 61.00000       43
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-56.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Atomic Radius 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##       0       0       0       0       0       0      34
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-57.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Covalent Radius 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##       0       0       0       0       0       0      47
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-58.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Van der Waals Radius 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##       0       0       0       0       0       0      80
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-59.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of HalfLife 
##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
## 0.000e+00 4.333e+11       Inf       Inf       Inf       Inf
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-60.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Lifetime 
##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
## 0.000e+00 6.247e+11       Inf       Inf       Inf       Inf
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-61.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Count of Decay Mode 
## Source: local data frame [5 x 2]
## 
##              vars     n
##             (chr) (int)
## 1   AlphaEmission    32
## 2       BetaDecay     3
## 3   BetaPlusDecay     1
## 4 ElectronCapture     1
## 5              NA    81
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-62.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Neutron Cross Section 
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
##     0.00     1.16     8.28   871.60    81.50 49000.00       20
{% endhighlight %}

<img src="/figures/unnamed-chunk-3-63.svg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

{% highlight text %}
## Summary of Neutron Mass Absorption 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##  0.0000  0.0006  0.0023  0.2093  0.0165  7.3000      35
{% endhighlight %}


And that's all for today.





## sessionInfo()


{% highlight text %}
## R version 3.3.1 (2016-06-21)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 14.04.4 LTS
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=sv_SE.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=sv_SE.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=sv_SE.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=sv_SE.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] grid      stats     graphics  grDevices utils     datasets  base     
## 
## other attached packages:
## [1] dplyr_0.4.3   ggplot2_2.1.0 knitr_1.13   
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.5      digest_0.6.9     assertthat_0.1   R6_2.1.2        
##  [5] plyr_1.8.3       gtable_0.2.0     DBI_0.4-1        formatR_1.4     
##  [9] magrittr_1.5     evaluate_0.9     scales_0.4.0     stringi_1.0-1   
## [13] lazyeval_0.1.10  labeling_0.3     tools_3.3.1      stringr_1.0.0   
## [17] munsell_0.4.3    parallel_3.3.1   colorspace_1.2-6 methods_3.3.1
{% endhighlight %}
