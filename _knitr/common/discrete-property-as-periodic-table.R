discrete_property_as_periodic_table <-
   function (data,
             scale.title = "",
             scale.ncol = 3) {
      # data should have these columns:
      # data$Graph.Group
      # data$Graph.Period
      # data$Symbol
      # data$data

      if (scale.title == "") {
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
                           colour = substitute(data))) +
            geom_text(data = data,
                      colour = "white",
                      size = 3,
                      fontface = "bold",
                      aes(label = Symbol, y = Graph.Period, x = Graph.Group)) +
            scale_x_continuous(breaks = seq(min(data$Graph.Group),
                                            max(data$Graph.Group)),
                               limits = c(min(data$Graph.Group) - 1,
                                          max(data$Graph.Group) + 1),
                               expand = c(0, 0)) +
            scale_y_continuous(trans = "reverse",
                               breaks = seq(min(data$Graph.Period),
                                            max(data$Graph.Period)),
                               limits = c(max(data$Graph.Period) + 1,
                                          min(data$Graph.Period) - 1.5),
                               expand = c(0, 0)) +
            scale_colour_discrete(na.value = "grey70") +
            # set the size of the legend boxes independent of geom_point's aes
            guides(colour = guide_legend(override.aes = list(size = 5),
                                         ncol = scale.ncol,
                                         byrow = TRUE,
                                         title.hjust = 0.5)) +
            theme(panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  plot.margin = unit(c(0, 0, -0.85, -0.85), "line"),
                  axis.ticks = element_blank(),
                  axis.title = element_blank(),
                  axis.text = element_blank(),
                  legend.position = c(0.42, 0.93),
                  legend.justification = c(0.5, 1),
                  legend.direction = "vertical",
                  legend.key.size = unit(0.8, "line"),
                  legend.title = element_text(size = 15,
                                              face = "plain"),
                  legend.key = element_rect(fill = "transparent",
                                            colour = "transparent"),
                  legend.background = element_rect(fill = "transparent"))
      } else {
         # use specified (pretty) title
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
                               expand = c(0, 0)) +
            scale_y_continuous(trans = "reverse",
                               breaks = seq(min(data$Graph.Period),
                                            max(data$Graph.Period)),
                               limits = c(max(data$Graph.Period) + 1,
                                          min(data$Graph.Period) - 1.5),
                               expand = c(0, 0)) +
            scale_colour_discrete(na.value = "grey70") +
            # set the size of the legend boxes independent of geom_point's aes
            guides(colour = guide_legend(override.aes = list(size = 5),
                                         title = scale.title,
                                         ncol = scale.ncol,
                                         byrow = TRUE,
                                         title.hjust = 0.5)) +
            theme(panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  plot.margin = unit(c(0, 0, -0.85, -0.85), "line"),
                  axis.ticks = element_blank(),
                  axis.title = element_blank(),
                  axis.text = element_blank(),
                  legend.position = c(0.42, 0.93),
                  legend.justification = c(0.5, 1),
                  legend.direction = "vertical",
                  legend.key.size = unit(0.8, "line"),
                  legend.title = element_text(size = 15,
                                              face = "plain"),
                  legend.key = element_rect(fill = "transparent",
                                            colour = "transparent"),
                  legend.background = element_rect(fill = "transparent"))
      }
}
