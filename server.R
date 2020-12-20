function(input,output){
  
  output$plot_rank <- renderPlotly({
    data_agg1 <- workers_clean %>%
      filter(year == input$tahun) %>% 
      mutate(gap_earnings = total_earnings_male-total_earnings_female) %>% 
      group_by(major_category) %>%
      summarise(mean_gap = mean(gap_earnings))
    
    plot_ranking <- data_agg1 %>% 
      ggplot(aes(x = mean_gap, 
                 y = reorder(major_category,mean_gap),
                 text = glue("{major_category}
                         Gap Earnings: {mean_gap}"))) +
      geom_col(fill = "dodgerblue4") +
      geom_col(data = data_agg1 %>% 
                 filter(major_category == "Computer, Engineering, and Science"), 
               fill = "firebrick") +
      labs( x = NULL,
            y = NULL,
            title = "Gap Earnings on Male and Female 2016") +
      scale_y_discrete(labels = wrap_format(30)) + #title tdk terlalu panjang
      # menambahkan dollar symbol
      scale_x_continuous(labels = dollar_format(prefix = "$")) +
      theme_algoritma
    
    ggplotly(plot_ranking, tooltip = "text")
  })
  
  plot
  output$data_workers <- renderDataTable({
    DT::datatable(data = workers_clean, options = list(scrollX = T)
    )
    
    
  })
  
  output$plot_corr <- renderPlotly({
    plot_dist <- workers_clean %>% 
      ggplot(aes_string(x = "total_earnings_male", #aes_string() utk ambil sumbu dr input
                        y = input$numvar)) +
      geom_jitter(aes(col = major_category,
                      text = glue("{str_to_upper(major_category)}
                         Earnings Male: {total_earnings_male}
                         Earnings Female: {input$numvar}"))) +
      geom_smooth() +
      labs(y = glue("{input$numvar}"),
           x = "Total Earnings Male",
           title = "Distribution of Plot Earnings") +
      scale_color_brewer(palette = "Set3") +
      theme_algoritma +
      theme(legend.position = "none")
    ggplotly(plot_dist, tooltip = "text")
    
  })
  
  
  
  
  
}
