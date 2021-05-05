#Libraries required for the app
library(shiny)

#Define some basic molecular weights

#THM species:
chloroform_ug.umol <- 119.38
bromoform_ug.umol <- 252.73
dbcm_ug.umol <- 208.28  #abbreviation for dibromochloromethane
bdcm_ug.umol <- 163.8 #abbreviation for bromodichloromethane

# Define UI for application
ui <- fluidPage(
  titlePanel("Disinfection By Products - Guideline Conversion App"),

  br(),
  h3("For trihalomethane (THM) guidelines"),
  br(),


  sidebarPanel(helpText('What are the original guideline values?'),

               #Enter initial guideline value
               textInput('init_ug.L',
                         'Enter guideline (ug/L):',
                         value=200),

               #Choose all or individual species
               selectInput('select',
                           'What would you like to convert in terms of?',
                           choices = list('All THM' = 1,
                                          'Individual Species' = 2)
                           ),

               #Conditional Panel for THM Species
               conditionalPanel(
                 condition = 'input.select == 2',
                 checkboxGroupInput('thm_species',
                                    'Which THM species?',
                                    choices = c('Chloroform' = chloroform_ug.umol,
                                                'Bromoform' = bromoform_ug.umol,
                                                'Dibromocholoromethane' = dbcm_ug.umol,
                                                'Bromodichloromethane' = bdcm_ug.umol))
                 )
               ),

  mainPanel(h2('Conversions'),
            #Re-iteration of the input parameters in a nice sentence
            textOutput('all_select'),
            br(),

            #CONDITIONAL PANELS HERE TO SWAP BETWEEN INDIVIDUAL OR SELECT
            conditionalPanel(
              condition = 'input.select == 1',
              textOutput('umol_conv_THM'),
              textOutput('umolC_conv_THM'),
              textOutput('ugC_conv_THM')
              ),
            conditionalPanel(
              condition = 'input.select == 2',
              textOutput('umol_conv_INDV'),
              textOutput('umolC_conv_INDV'),
              textOutput('ugC_conv_INDV')
            ),
            br(),

            #How the upper and lower limits are calculated
            #For all THM
            conditionalPanel(
              condition = 'input.select == 1',
              p('where the upper limit is calculated as if', strong('chloroform'), 'forms 100% of THM, and the lower limit is calculated as if', strong('bromoform'), 'forms 100% of THM')
              ),

            #For indiv. species
            conditionalPanel(
              condition = 'input.select == 2',
              textOutput('range_sentence')
            )
            )
)



server <- function(input, output) {

    #First sentence summarizing the initial conditions:
    output$all_select <- renderText({
      select_names <- switch(input$select,
                             "1" = "all THM species",
                             "2" = "a select few species")
        paste('That means a guideline of', input$init_ug.L, 'ug/L of', select_names, 'is equivalent to:')
  })

    ### CONVERSIONS FOR 'ALL THM':###
    #Creating the umol/L all THM
    output$umol_conv_THM <- renderText({
      low_umol_conv_THM <- as.numeric(input$init_ug.L) * (1/bromoform_ug.umol)
      high_umol_conv_THM <- as.numeric(input$init_ug.L) * (1/chloroform_ug.umol)

      paste(format(low_umol_conv_THM, digits=2), 'to', format(high_umol_conv_THM, digits=2), 'umol/L THM')
    })

    #Creating the umol C/L all THM
    output$umolC_conv_THM <- renderText({
      low_umolC_conv_THM <- as.numeric(input$init_ug.L) * (1/bromoform_ug.umol) * 1 #1 mole of C per molecule bromoform
      high_umolC_conv_THM <- as.numeric(input$init_ug.L) * (1/chloroform_ug.umol) * 1 #1 mole of C per molecule chloroform

      paste(format(low_umolC_conv_THM, digits=2), 'to', format(high_umolC_conv_THM, digits=2), 'umol C/L THM')
    })

    #Creating the ug C/L all THM
    output$ugC_conv_THM <- renderText({
      low_ugC_conv_THM <- as.numeric(input$init_ug.L) * (1/bromoform_ug.umol) * 1 * 12.01
      high_ugC_conv_THM <- as.numeric(input$init_ug.L) * (1/chloroform_ug.umol) * 1 * 12.01

      paste(format(low_ugC_conv_THM, digits=2), 'to', format(high_ugC_conv_THM, digits=2), 'ug C/L THM')
    })


    ### CONVERSIONS FOR INDIVIDUAL SPECIES ###
    #Creating the umol/L for individual species
    output$umol_conv_INDV <- renderText({
      low_umol_conv_INDV <- as.numeric(input$init_ug.L) * (1/as.numeric(max(input$thm_species)))
      high_umol_conv_INDV <- as.numeric(input$init_ug.L) * (1/as.numeric(min(input$thm_species)))

      paste(format(low_umol_conv_INDV, digits=2), 'to', format(high_umol_conv_INDV, digits=2), 'umol/L THM')
    })

    #Creating the umol C/L for individual species
    output$umolC_conv_INDV <- renderText({
      low_umolC_conv_INDV <- as.numeric(input$init_ug.L) * (1/as.numeric(max(input$thm_species))) * 1 #1 mole of C per molecule bromoform
      high_umolC_conv_INDV <- as.numeric(input$init_ug.L) * (1/as.numeric(min(input$thm_species))) * 1 #1 mole of C per molecule chloroform

      paste(format(low_umolC_conv_INDV, digits=2), 'to', format(high_umolC_conv_INDV, digits=2), 'umol C/L THM')
    })

    #Creating the ug C/L for individual species
    output$ugC_conv_INDV <- renderText({
      low_ugC_conv_INDV <- as.numeric(input$init_ug.L) * (1/as.numeric(max(input$thm_species))) * 1 * 12.01
      high_ugC_conv_INDV <- as.numeric(input$init_ug.L) * (1/as.numeric(min(input$thm_species))) * 1 * 12.01

      paste(format(low_ugC_conv_INDV, digits=2), 'to', format(high_ugC_conv_INDV, digits=2), 'ug C/L THM')
    })


    #Final sentences on the upper & lower range based on user picks
   output$range_sentence <- renderText({

     high_range <- if(as.numeric(min(input$thm_species) == 119.38)) {
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

     low_range <- if(as.numeric(max(input$thm_species) == 119.38)) {
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

      paste('where the upper limit is calculated as if', high_range, 'forms 100% of THM, and the lower limit is calculated as if', low_range, 'forms 100% of THM')
   })

}

shinyApp(ui = ui, server = server)
