library(shiny)
library(lubridate)
library(reticulate)
library(tidyverse)
#library(imager)
#import("music")
#load("c:/users/samantha/documents/repos/ukulele_app/mountpoints/apps/strums.RData")

exercises <- c("chord changes", "fingerpicking", "strumming", "songs")

server <- function(input, output, session) {
  # Initialize the timer, 10 seconds, not active
  active <- reactiveVal(FALSE)
  timer <- reactiveVal(300)
  i <- reactiveVal(1)
#  strumnum <- reactiveVal(sample(1:32, 1))
  
  output$timeleft <- renderText({
    paste("Time left: ", seconds_to_period(timer()))
  })
  
  output$exercise <- renderText({
    paste("Exercise:", exercises[i()])
    
  })
  
#  output$strum <- renderPlot({
#    plot(im[[strumnum()]], axes = FALSE, rescale = FALSE)
#  })
  
  observe({
    invalidateLater(1000, session)
    isolate({
      if(active())
      {
        timer(timer()-1)
        if(timer()<1)
        {
          if(i() < 4){
            active(FALSE)
            showModal(modalDialog(
              title = "Important message",
              "Next exercise!",
              footer = actionButton("ok", "yup")))
            i(i() + 1)
            timer(300)
            
          }else {
            active(FALSE)
            showModal(modalDialog(title = "Important message",
                                  "All done!"))
          }
        }
      }
    })
  })
  
  # observers for actionbuttons
  observeEvent(input$start, {active(TRUE)})
  observeEvent(input$stop, {active(FALSE)})
  observeEvent(input$reset, {timer(300)})
  observeEvent(input$addtime, {timer(timer() + 60)})
  observeEvent(input$ok, {
    active(TRUE)
    removeModal()
  })
  observeEvent(input$restart, {
    timer(300)
    i(1)
  })
  observeEvent(input$newpattern, {strumnum(sample(1:32, 1))})
}
