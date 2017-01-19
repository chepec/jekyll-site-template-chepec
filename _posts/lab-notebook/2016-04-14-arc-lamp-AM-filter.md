---
layout: post
title: "Xenon arc lamp with AM filter"
date: 2016-04-14 18:00:00 GMT
permalink: /lab-notebook/:year/:month/:day/:title
tags:
- lab notebook
published: true
comments: false
---


<div style="border: 2px solid red; padding-left: 6px; padding-top: 2px; background-color: #D3D3D3; color: black;">
   NOTE: this post contains outdated results. Please refer to ["Lamps and filters" (Apr 23, 2016)]({{ site.url }}/lab-notebook/2016/04/23/lamps-filters) for up-to-date information.
</div>










## Methods

I measured the power from the arc lamp at distances of $\SIrange{30}{60}{\cm}$, using a Thorlabs PM160T power meter.


The power meter's sensor is circular, with a diameter of $\SI{10}{\mm}$ according to the manual.



{% highlight r %}
sensor.diameter <- 1.0 # cm
sensor.area <- pi * (0.5 * sensor.diameter)^2
area.corr.factor <- 1 / sensor.area
{% endhighlight %}

The sensor area is $\SI{0.7854}{\square\cm}$, and consequently we need to multiply the values we read out with a factor 1.273 to get proper power densities.

![The simple method used to center the power meter's detector]({{site.url}}/lab-notebok/assets/images/lnb-160414/power-meter-positioning.jpg)

![The power meter during a measurement]({{site.url}}/lab-notebook/assets/images/lnb-160414/power-meter-measuring.jpg)


The arc lamp housing is a Newport (Oriel instruments) model 67005, mfd. 2009-07, for lamp power 50--500W.  The tube of the lamp housing is fitted with an AM1.5 filter.
The housing contains an Xr arc lamp.

The arc lamp power supply is a Newport 69911, set to supply $\SI{200}{\watt}$.

![The power supply to the arc lamp]({{site.url}}/lab-notebook/assets/images/lnb-160414/arc-lamp-power-supply.jpg)




## Data (results)


{% highlight r %}
power <- read.csv(file = "distance-vs-power.csv")
power$corr.distance <- power$distance - 3.5 # cm
power$density <- round(power$power * area.corr.factor)
{% endhighlight %}

The units of the density values are $\si{\milli\watt\per\square\cm}$.


{% highlight r %}
# note: lm(log()) and lm(log10()) give very similar results,
# essentially indistinguishable visually
# we'll just use the natural logarithm
# xvec: pad the experimental distance range enough so the model
# reaches zero power to the right and the y-axis to the left
xvec <-
   c(seq(1, 26),
     power$corr.distance,
     seq(57, 63))
fit <-
   lm(density ~ logb(corr.distance, base = exp(1)),
      data = power)
power.predicted.log <-
   predict(fit, newdata = data.frame(corr.distance = xvec))
power.calc <-
   data.frame(distance = xvec,
              density.log = power.predicted.log)
{% endhighlight %}


<img src="/figures/lnb-160414-arclamp-powerdensity-1.svg" title="plot of chunk lnb-160414-arclamp-powerdensity" alt="plot of chunk lnb-160414-arclamp-powerdensity" style="display: block; margin: auto;" />

Note that the fitted model (an exponential) grows asymptotically as $x \rightarrow 0$.


{% highlight r %}
# attempting to use fitted model to calculate any power density
# the parameters of the fit
# y = a * exp(mx), where a is y-intercept, and m is slope
# y <- fit$coefficients[1] * exp(fit$coefficients[2] * xvec)
# (not correct, I'm still missing something)
{% endhighlight %}


The 1 Sun equivalent output ($\SI{100}{\mW\per\square\cm}$) is achieved at $\SI{42}{\cm}$ from the lamp (measured from the tip of the tube, as by previous workers).

The total power of the light drops exponentially with distance, as expected, which is confirmed by the good agreement between the fitted exponential (blue line) and the data points. The lower-right panel shows the residual (difference) between the exponential fit and the data.




## Remarks

The total power output of the lamp has clearly diminished since it was installed in 2009 or 2010. The last documented measure of the 1-Sun distance was in 2010 and put it at $\SI{59.3}{\cm}$.




## Notes

- [Newport arc lamp housing model 67005, 50W--500W](http://search.newport.com/?x1=sku&q1=67005)
- [Oriel Product Training:  Spectral Irradiance (PDF)](http://assets.newport.com/webDocuments-EN/images/Light_Sources.pdf)
- [Newport arc lamp housings: overview page](http://www.newport.com/Research-Arc-Lamp-Housings/379146/1033/info.aspx)
- [Oriel digital arc lamp power supplies, series 69900 (PDF)](http://assets.newport.com/pdfs/e5341.pdf)
- [Solar simulator guide: Newport](http://www.newport.com/Solar-Simulator-Guide/1016231/1033/content.aspx)
- [http://www.nxtbook.com/nxtbooks/newportcorp/resource2011/#/223](http://www.nxtbook.com/nxtbooks/newportcorp/resource2011/#/223)
- [http://www.nxtbook.com/nxtbooks/newportcorp/resource2011/index.php?startid=47](http://www.nxtbook.com/nxtbooks/newportcorp/resource2011/index.php?startid=47)

A video from Newport demonstrating the procedure for switching the lamp in an arc lamp housing similar (identical?) to ours (embedded below).

{% youtube cwhYITvA8EI %}







## Session info

<div style="border: 2px solid #0066CC; padding-left: 0px; padding-top: 0px; background-color:  #ffffe6; color: black;">


{% highlight text %}
## Commit:  2c48053104c15d57d7a6e066cd001ae1874f0b8d
## Author:  taha@luxor <taha@chepec.se>
## When:    2016-04-20 23:43:08
## 
##      Renamed the file, because we added a second xenon arc lamp to the lab.
##      
## 2 files changed, 185 insertions, 186 deletions
## 2016-04-14-Newport-illuminator.Rmd | -186 +  0  in 1 hunk
## 2016-04-14-arc-lamp-AM-filter.Rmd  | -  0 +185  in 1 hunk
{% endhighlight %}



{% highlight text %}
## Untracked files:
## 	Untracked:  2016-04-14-arc-lamp-AM-filter.Rproj
## 
## Unstaged changes:
## 	Modified:   .gitignore
## 	Modified:   2016-04-14-arc-lamp-AM-filter.Rmd
## 	Modified:   distance-vs-power.csv
{% endhighlight %}



{% highlight text %}
## R version 3.3.2 (2016-10-31)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 14.04.5 LTS
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] methods   grid      stats     graphics  grDevices utils     datasets  base     
## 
## other attached packages:
## [1] oceanoptics_0.1.0 common_0.0.0.9002 git2r_0.16.0      ggplot2_2.2.0    
## [5] knitr_1.15.1     
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.8      assertthat_0.1   plyr_1.8.4       gtable_0.2.0    
##  [5] magrittr_1.5     evaluate_0.10    scales_0.4.1     highr_0.6       
##  [9] stringi_1.1.2    lazyeval_0.2.0   labeling_0.3     tools_3.3.2     
## [13] stringr_1.1.0    munsell_0.4.3    colorspace_1.3-2 tibble_1.2
{% endhighlight %}



{% highlight text %}
## Linux 3.13.0-107-generic #154-Ubuntu SMP Tue Dec 20 09:57:27 UTC 2016 x86_64
{% endhighlight %}

</div>


