header <- dashboardHeader(title = "Gap Gender Analysis")

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(text = "Gap Earnings", 
             tabName = "gap", 
             icon = icon("dollar-sign")),
    menuItem(text = "Correlation Plot", 
             tabName = "corr", 
             icon = icon("chart-line")),
    menuItem(text = "Dataset", 
             tabName = "data", 
             icon = icon("database")),
    selectInput(inputId = "tahun", 
                label = "Select Year",
                choices = unique(workers_clean$year))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "gap", 
            h1("Jobs Gender Dashboard", align = "center"),
            plotlyOutput(outputId = "plot_rank")),
    tabItem(tabName = "corr", 
            radioButtons(inputId = "numvar", 
                         label = "Choose Y Axis", 
                         choices = workers_clean %>% 
                           select_if(is.numeric) %>% #untuk ambil semua kolom yg numeric
                           select(-c(year, total_earnings_male)) %>% 
                           colnames()
            ),
            plotlyOutput(outputId = "plot_corr")
    ),
    tabItem(tabName = "data", 
            dataTableOutput(outputId = "data_workers"))
  )
)

dashboardPage(
  header = header,
  body = body,
  sidebar = sidebar, 
  skin = "red"
)
