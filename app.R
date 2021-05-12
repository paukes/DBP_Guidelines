#Libraries required for the app
library(shiny)

#Define some basic molecular weights

#THM species:
chloroform_ug.umol <- 119.38
bromoform_ug.umol <- 252.73
dbcm_ug.umol <- 208.28  #abbreviation for dibromochloromethane
bdcm_ug.umol <- 163.8 #abbreviation for bromodichloromethane

#HAA species
bdcaa_ug.umol <- 207.83 #abbr for bromodichloroacetic acid
cdbaa_ug.umol <- 252.29 #abbr for chlorodibromoacetic acid
tbaa_ug.umol <- 296.74 #abbr for tribromoacetic acid
caa_ug.umol <- 94.5 #abbr for chloroacetic acid
baa_ug.umol <- 138.95 #abbr for bromoacetic acid
dcaa_ug.umol <- 128.94 #abbr for dichloroacetic acid
tcaa_ug.umol <- 163.38 #abbr for trichloroacetic acid
dbaa_ug.umol <- 217.84 #abbr for dibromoacetic acid
bcaa_ug.umol <- 173.39 #abbr for bromochloroacetic acid

# Define UI for application
ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "cosmo"),

  titlePanel("Disinfection By Product - Guideline Conversion App"),

  br(),
  p("This app allows you to take disinfection by-product guideline concentrations and convert them to more accurate and useful units (either on a molar basis of a DBP or as carbon)."),
  p("To start, choose either the trihalomethane (THM) or haloacetic acid (HAA) panel below:"),
  br(),


  tabsetPanel(

    #THM Panel - convert THM guidelines to other units
    tabPanel("THM",
             fluidRow(

               #THM Input parameters
               column(4,
                      wellPanel(helpText('What are the original THM guideline values?'),

                                #Enter initial guideline value
                                textInput('init_thm_ug.L',
                                          'Enter guideline (ug/L):',
                                          value=100),

                                #Choose all or individual species
                                selectInput('select_thm',
                                            'What would you like to convert in terms of?',
                                            choices = list('All THM' = 1,
                                                           'Individual Species' = 2)
                                ),

                                #Conditional Panel for THM Species
                                conditionalPanel(
                                  condition = 'input.select_thm == 2',
                                  checkboxGroupInput('thm_species',
                                                     'Which THM species?',
                                                     choices = c('Chloroform' = chloroform_ug.umol,
                                                                 'Bromoform' = bromoform_ug.umol,
                                                                 'Dibromocholoromethane' = dbcm_ug.umol,
                                                                 'Bromodichloromethane' = bdcm_ug.umol))
                                )
                      )),

               #Main panel that 'shows' the conversions
               column(8,
                      mainPanel(h2('Conversions'),
                                #Re-iteration of the input parameters in a nice sentence
                                textOutput('all_select_thm'),
                                br(),

                                #Conditional panel that shows the output depending on what was chosen
                                conditionalPanel(
                                  condition = 'input.select_thm == 1',
                                  textOutput('umol_conv_THM'),
                                  textOutput('umolC_conv_THM'),
                                  textOutput('ugC_conv_THM')
                                ),
                                conditionalPanel(
                                  condition = 'input.select_thm == 2',
                                  textOutput('umol_conv_INDV'),
                                  textOutput('umolC_conv_INDV'),
                                  textOutput('ugC_conv_INDV')
                                ),
                                br(),

                                #State what the upper and lower limits were calculated from
                                #For all THM
                                conditionalPanel(
                                  condition = 'input.select_thm == 1',
                                  p('where the upper limit is calculated as if', strong('chloroform'), 'forms 100% of THM, and the lower limit is calculated as if', strong('bromoform'), 'forms 100% of THM')
                                ),

                                #For indiv. species
                                conditionalPanel(
                                  condition = 'input.select_thm == 2',
                                  textOutput('range_sentence_thm')
                                )
                      )
               )
             )
    ),


    #HAA Panel - convert HAA guidelines to other units
    tabPanel("HAA",
             fluidRow(

               #HAA Input parameters
               column(4,
                      wellPanel(helpText('What are the original HAA guideline values?'),

                                #Enter initial guideline value
                                textInput('init_haa_ug.L',
                                          'Enter guideline (ug/L):',
                                          value= 80),

                                #Choose all or individual species
                                selectInput('select_haa',
                                            'What would you like to convert in terms of?',
                                            choices = list('All HAA (HAA9)' = 1,
                                                           'Individual Species' = 2)
                                ),

                                #Conditional Panel for HAA Species
                                conditionalPanel(
                                  condition = 'input.select_haa == 2',
                                  checkboxGroupInput('haa_species',
                                                     'Which HAA species?',
                                                     choices = c('Bromodichloroacetic acid' = bdcaa_ug.umol,
                                                                 'Chlorodibromoacetic acid' = cdbaa_ug.umol,
                                                                 'Tribromoacetic acid' = tbaa_ug.umol,
                                                                 'Chloroacetic acid' = caa_ug.umol,
                                                                 'Bromoacetic acid' = baa_ug.umol,
                                                                 'Dichloroacetic acid' = dcaa_ug.umol,
                                                                 'Trichloroacetic acid' = tcaa_ug.umol,
                                                                 'Dibromoacetic acid' = dbaa_ug.umol,
                                                                 'Bromochloroacetic acid' = bcaa_ug.umol))
                                )
                      )),

               #Main panel that 'shows' the conversions
               column(8,
                      mainPanel(h2('Conversions'),
                                #Re-iteration of the input parameters in a nice sentence
                                textOutput('all_select_haa'),
                                br(),

                                #Conditional panel that shows the output depending on what was chosen
                                conditionalPanel(
                                  condition = 'input.select_haa == 1',
                                  textOutput('umol_conv_HAA'),
                                  textOutput('umolC_conv_HAA'),
                                  textOutput('ugC_conv_HAA')
                                ),
                                conditionalPanel(
                                  condition = 'input.select_haa == 2',
                                  textOutput('umol_conv_INDVhaa'),
                                  textOutput('umolC_conv_INDVhaa'),
                                  textOutput('ugC_conv_INDVhaa')
                                ),
                                br(),

                                #State what the upper and lower limits were calculated from
                                #For all HAA
                                conditionalPanel(
                                  condition = 'input.select_haa == 1',
                                  p('where the upper limit is calculated as if', strong('chloroacetic acid'), 'forms 100% of HAA, and the lower limit is calculated as if', strong('tribromoacetic acid'), 'forms 100% of HAA')
                                ),

                                #For indiv. species
                                conditionalPanel(
                                  condition = 'input.select_haa == 2',
                                  textOutput('range_sentence_haa')
                                )
                      )
               )
             )
    )
  )
)



server <- function(input, output) {

  #THM Output

  #First sentence summarizing the initial conditions:
  output$all_select_thm <- renderText({
    select_names_thm <- switch(input$select_thm,
                               "1" = "all THM species",
                               "2" = "a select few species")
    paste('That means a guideline of', input$init_thm_ug.L, 'ug/L of', select_names_thm, 'is equivalent to:')
  })

  ### CONVERSIONS FOR 'ALL THM':###
  #Creating the umol/L all THM
  output$umol_conv_THM <- renderText({
    low_umol_conv_THM <- as.numeric(input$init_thm_ug.L) * (1/bromoform_ug.umol)
    high_umol_conv_THM <- as.numeric(input$init_thm_ug.L) * (1/chloroform_ug.umol)

    paste(format(low_umol_conv_THM, digits=2), 'to', format(high_umol_conv_THM, digits=2), 'umol/L THM')
  })

  #Creating the umol C/L all THM
  output$umolC_conv_THM <- renderText({
    low_umolC_conv_THM <- as.numeric(input$init_thm_ug.L) * (1/bromoform_ug.umol) * 1 #1 mole of C per molecule bromoform
    high_umolC_conv_THM <- as.numeric(input$init_thm_ug.L) * (1/chloroform_ug.umol) * 1 #1 mole of C per molecule chloroform

    paste(format(low_umolC_conv_THM, digits=2), 'to', format(high_umolC_conv_THM, digits=2), 'umol C/L THM')
  })

  #Creating the ug C/L all THM
  output$ugC_conv_THM <- renderText({
    low_ugC_conv_THM <- as.numeric(input$init_thm_ug.L) * (1/bromoform_ug.umol) * 1 * 12.01
    high_ugC_conv_THM <- as.numeric(input$init_thm_ug.L) * (1/chloroform_ug.umol) * 1 * 12.01

    paste(format(low_ugC_conv_THM, digits=2), 'to', format(high_ugC_conv_THM, digits=2), 'ug C/L THM')
  })


  ### CONVERSIONS FOR INDIVIDUAL SPECIES ###
  #Creating the umol/L for individual species
  output$umol_conv_INDV <- renderText({
    low_umol_conv_INDV <- as.numeric(input$init_thm_ug.L) * (1/as.numeric(max(input$thm_species)))
    high_umol_conv_INDV <- as.numeric(input$init_thm_ug.L) * (1/as.numeric(min(input$thm_species)))

    paste(format(low_umol_conv_INDV, digits=2), 'to', format(high_umol_conv_INDV, digits=2), 'umol/L THM')
  })

  #Creating the umol C/L for individual species
  output$umolC_conv_INDV <- renderText({
    low_umolC_conv_INDV <- as.numeric(input$init_thm_ug.L) * (1/as.numeric(max(input$thm_species))) * 1 #1 mole of C per molecule THM
    high_umolC_conv_INDV <- as.numeric(input$init_thm_ug.L) * (1/as.numeric(min(input$thm_species))) * 1 #1 mole of C per molecule THM

    paste(format(low_umolC_conv_INDV, digits=2), 'to', format(high_umolC_conv_INDV, digits=2), 'umol C/L THM')
  })

  #Creating the ug C/L for individual species
  output$ugC_conv_INDV <- renderText({
    low_ugC_conv_INDV <- as.numeric(input$init_thm_ug.L) * (1/as.numeric(max(input$thm_species))) * 1 * 12.01
    high_ugC_conv_INDV <- as.numeric(input$init_thm_ug.L) * (1/as.numeric(min(input$thm_species))) * 1 * 12.01

    paste(format(low_ugC_conv_INDV, digits=2), 'to', format(high_ugC_conv_INDV, digits=2), 'ug C/L THM')
  })


  #Final sentences on the upper & lower range based on user picks
  output$range_sentence_thm <- renderText({

    high_range_thm <- if(as.numeric(min(input$thm_species) == 119.38)) {
      print("chloroform")
    } else {
      if(as.numeric(min(input$thm_species) == 252.73)) {
        print("bromoform")
      } else {
        if(as.numeric(min(input$thm_species) == 208.28)) {
          print("dibromochloromethane")
        } else {
          print("bromodichloromethane")
        }
      }
    }

    low_range_thm <- if(as.numeric(max(input$thm_species) == 119.38)) {
      print("chloroform")
    } else {
      if(as.numeric(max(input$thm_species) == 252.73)) {
        print("bromoform")
      } else {
        if(as.numeric(max(input$thm_species) == 208.28)) {
          print("dibromochloromethane")
        } else {
          print("bromodichloromethane")
        }
      }
    }

    paste('where the upper limit is calculated as if', high_range_thm, 'forms 100% of THM, and the lower limit is calculated as if', low_range_thm, 'forms 100% of THM')
  })



  #HAA Output

  #First sentence summarizing the initial conditions:
  output$all_select_haa <- renderText({
    select_names_haa <- switch(input$select_haa,
                               "1" = "all HAA species",
                               "2" = "a select few species")
    paste('That means a guideline of', input$init_haa_ug.L, 'ug/L of', select_names_haa, 'is equivalent to:')
  })

  ### CONVERSIONS FOR 'ALL HAA':###
  #Creating the umol/L all HAA
  output$umol_conv_HAA <- renderText({
    low_umol_conv_HAA <- as.numeric(input$init_haa_ug.L) * (1/tbaa_ug.umol)
    high_umol_conv_HAA <- as.numeric(input$init_haa_ug.L) * (1/caa_ug.umol)

    paste(format(low_umol_conv_HAA, digits=2), 'to', format(high_umol_conv_HAA, digits=2), 'umol/L HAA')
  })

  #Creating the umol C/L all HAA
  output$umolC_conv_HAA <- renderText({
    low_umolC_conv_HAA <- as.numeric(input$init_haa_ug.L) * (1/tbaa_ug.umol) * 2 #2 moles of C per molecule TBAA
    high_umolC_conv_HAA <- as.numeric(input$init_haa_ug.L) * (1/caa_ug.umol) * 2 #2 mole of C per molecule CAA

    paste(format(low_umolC_conv_HAA, digits=2), 'to', format(high_umolC_conv_HAA, digits=2), 'umol C/L HAA')
  })

  #Creating the ug C/L all HAA
  output$ugC_conv_HAA <- renderText({
    low_ugC_conv_HAA <- as.numeric(input$init_haa_ug.L) * (1/tbaa_ug.umol) * 2 * 12.01
    high_ugC_conv_HAA <- as.numeric(input$init_haa_ug.L) * (1/caa_ug.umol) * 2 * 12.01

    paste(format(low_ugC_conv_HAA, digits=2), 'to', format(high_ugC_conv_HAA, digits=2), 'ug C/L HAA')
  })


  ### CONVERSIONS FOR INDIVIDUAL HAA SPECIES ###
  #Creating the umol/L for individual species
  output$umol_conv_INDVhaa <- renderText({
    low_umol_conv_INDVhaa <- as.numeric(input$init_haa_ug.L) * (1/as.numeric(max(input$haa_species)))
    high_umol_conv_INDVhaa <- as.numeric(input$init_haa_ug.L) * (1/as.numeric(min(input$haa_species)))

    paste(format(low_umol_conv_INDVhaa, digits=2), 'to', format(high_umol_conv_INDVhaa, digits=2), 'umol/L HAA')
  })

  #Creating the umol C/L for individual species
  output$umolC_conv_INDVhaa <- renderText({
    low_umolC_conv_INDVhaa <- as.numeric(input$init_haa_ug.L) * (1/as.numeric(max(input$haa_species))) * 2 #2 moles of C per molecule HAA
    high_umolC_conv_INDVhaa <- as.numeric(input$init_haa_ug.L) * (1/as.numeric(min(input$haa_species))) * 2 #2 moles of C per molecule HAA

    paste(format(low_umolC_conv_INDVhaa, digits=2), 'to', format(high_umolC_conv_INDVhaa, digits=2), 'umol C/L HAA')
  })

  #Creating the ug C/L for individual species
  output$ugC_conv_INDVhaa <- renderText({
    low_ugC_conv_INDVhaa <- as.numeric(input$init_haa_ug.L) * (1/as.numeric(max(input$haa_species))) * 1 * 12.01
    high_ugC_conv_INDVhaa <- as.numeric(input$init_haa_ug.L) * (1/as.numeric(min(input$haa_species))) * 1 * 12.01

    paste(format(low_ugC_conv_INDVhaa, digits=2), 'to', format(high_ugC_conv_INDVhaa, digits=2), 'ug C/L HAA')
  })


  #Final sentences on the upper & lower range based on user picks
  output$range_sentence_haa <- renderText({

    high_range_haa <- if(as.numeric(min(input$haa_species) == 94.5)) {
      print("chloroacetic acid")
    } else {
      if(as.numeric(min(input$haa_species) == 138.95)) {
        print("bromoacetic acid")
      } else {
        if(as.numeric(min(input$haa_species) == 128.94)) {
          print("dichloroacetic acid")
        } else {
          if(as.numeric(min(input$haa_species) == 163.38)) {
            print("tricholoracetic acid")
          } else {
            if(as.numeric(min(input$haa_species) == 173.39)) {
              print("bromochloroacetic acid")
            } else {
              if(as.numeric(min(input$haa_species) == 217.84)) {
                print("dibromoacetic acid")
              } else {
                if(as.numeric(min(input$haa_species) == 207.83)) {
                  print("bromodichloroacetic acid")
                } else {
                  if(as.numeric(min(input$haa_species) == 252.29)) {
                    print("chlorodibromoacetic acid")
                  } else {
                    print("tribromoacetic acid")
                  }
                }
              }
            }
          }
        }
      }
    }

    low_range_haa <- if(as.numeric(max(input$haa_species) == 94.5)) {
      print("chloroacetic acid")
    } else {
      if(as.numeric(max(input$haa_species) == 138.95)) {
        print("bromoacetic acid")
      } else {
        if(as.numeric(max(input$haa_species) == 128.94)) {
          print("dichloroacetic acid")
        } else {
          if(as.numeric(max(input$haa_species) == 163.38)) {
            print("tricholoracetic acid")
          } else {
            if(as.numeric(max(input$haa_species) == 173.39)) {
              print("bromochloroacetic acid")
            } else {
              if(as.numeric(max(input$haa_species) == 217.84)) {
                print("dibromoacetic acid")
              } else {
                if(as.numeric(max(input$haa_species) == 207.83)) {
                  print("bromodichloroacetic acid")
                } else {
                  if(as.numeric(max(input$haa_species) == 252.29)) {
                    print("chlorodibromoacetic acid")
                  } else {
                    print("tribromoacetic acid")
                  }
                }
              }
            }
          }
        }
      }
    }

    paste('where the upper limit is calculated as if', high_range_haa, 'forms 100% of HAA, and the lower limit is calculated as if', low_range_haa, 'forms 100% of HAA')
  })

}

shinyApp(ui = ui, server = server)
