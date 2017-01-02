continuous_property_as_periodic_table <- 
   function (data, 
             scale.breaks = "",
             scale.labels = "",
             scale.title = "") {
      # data should have these columns:
      # data$Graph.Group
      # data$Graph.Period
      # data$Symbol
      # data$Property
      # data$Values
      # data$Unit
      
      if (any(c(scale.breaks, scale.labels, scale.title) == "")) {
         # for quick-and-dirty plots
         p <- 
            ggplot() +
            geom_point(data = data, 
                       # size 14 fits well with fig.width = 9, fig.height = 5.25
                       size = 14, 
                       # shape #22 allows both fill and colour to be 
                       # shape #15 only registers colour (is always filled)
                       # shape #0 only registers colour (is always empty)
                       shape = 15,
                       aes(y = Graph.Period, 
                           x = Graph.Group, 
                           colour = substitute(Values))) +
            geom_text(data = data, 
                      colour = "white",
                      size = 3,
                      fontface = "bold",
                      aes(label = Symbol, y = Graph.Period, x = Graph.Group)) +
            scale_x_continuous(breaks = seq(min(data$Graph.Group), 
                                            max(data$Graph.Group)),
                               limits = c(min(data$Graph.Group) - 1, 
                                          max(data$Graph.Group) + 1),
                               expand = c(0,0)) +
            scale_y_continuous(trans = "reverse",
                               breaks = seq(min(data$Graph.Period), 
                                            max(data$Graph.Period)),
                               limits = c(max(data$Graph.Period) + 1, 
                                          min(data$Graph.Period) - 1.5),
                               expand = c(0,0)) +
            # set breaks and labels in the colourbar legend
            scale_colour_continuous(# range of colour
                                    low = "#56B1F7", high = "#132B43",
                                    # colour if value is NA
                                    na.value = "grey70") +
            # plot title (usually property and unit)
            annotate("text", x = 8, y = 0.6, 
                     vjust = 0, 
                     # R's superscript syntax is quite cumbersome
                     label = paste0(unique(data$Property), 
                                    ifelse(test = unique(is.na(unique(data$Unit))),
                                           "",
                                           paste0("/(", 
                                                  unique(data$Unit[which(data$Unit != "")]),
                                                  ")"))),
                     parse = FALSE) +
            theme(panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  plot.margin = unit(c(0, 0, -0.85, -0.85), "line"),
                  axis.ticks = element_blank(),
                  axis.title = element_blank(),
                  axis.text = element_blank(),
                  legend.position = c(0.42, 0.91),
                  legend.justification = c(0.5, 1),
                  legend.direction = "horizontal",
                  legend.key.width = unit(2.5, "line"),
                  legend.title = element_blank(),
                  legend.background = element_rect(fill = "transparent"))
      } else {
         # use specified (pretty) breaks, labels and title
         p <- 
            ggplot() +
            geom_point(data = data, 
                       # size 14 fits well with fig.width = 9, fig.height = 5.25
                       size = 14, 
                       # shape #22 allows both fill and colour to be 
                       # shape #15 only registers colour (is always filled)
                       # shape #0 only registers colour (is always empty)
                       shape = 15,
                       aes(y = Graph.Period, 
                           x = Graph.Group, 
                           colour = substitute(Values))) +
            geom_text(data = data, 
                      colour = "white",
                      size = 3,
                      fontface = "bold",
                      aes(label = Symbol, y = Graph.Period, x = Graph.Group)) +
            scale_x_continuous(breaks = seq(min(data$Graph.Group), 
                                            max(data$Graph.Group)),
                               limits = c(min(data$Graph.Group) - 1, 
                                          max(data$Graph.Group) + 1),
                               expand = c(0,0)) +
            scale_y_continuous(trans = "reverse",
                               breaks = seq(min(data$Graph.Period), 
                                            max(data$Graph.Period)),
                               limits = c(max(data$Graph.Period) + 1, 
                                          min(data$Graph.Period) - 1.5),
                               expand = c(0,0)) +
            # set breaks and labels in the colourbar legend
            scale_colour_continuous(breaks = scale.breaks,
                                    labels = scale.labels,
                                    # range of colour
                                    low = "#56B1F7", high = "#132B43",
                                    # colour if value is NA
                                    na.value = "grey70") +
            # plot title (usually property and unit)
            annotate("text", x = 8, y = 0.6, 
                     vjust = 0, 
                     # R's superscript syntax is quite cumbersome
                     label = scale.title,
                     # parse required if using superscripts or subscripts
                     parse = TRUE) +
            theme(panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  plot.margin = unit(c(0, 0, -0.85, -0.85), "line"),
                  axis.ticks = element_blank(),
                  axis.title = element_blank(),
                  axis.text = element_blank(),
                  legend.position = c(0.42, 0.91),
                  legend.justification = c(0.5, 1),
                  legend.direction = "horizontal",
                  legend.key.width = unit(2.5, "line"),
                  legend.title = element_blank(),
                  legend.background = element_rect(fill = "transparent"))
      }
}