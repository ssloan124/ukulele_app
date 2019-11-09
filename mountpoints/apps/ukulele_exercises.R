library(shiny)
library(lubridate)
#https://stackoverflow.com/questions/49250167/how-to-create-a-countdown-timer-in-shiny
#https://stackoverflow.com/questions/33020558/embed-iframe-inside-shiny-app
#https://ukulelego.com/ukulele-chord-progressions/#c-g-am-f
#https://ukulelego.com/stuff/32-ukulele-strumming-patterns/
#https://ukulelego.com/tips/20-minute-beginners-practice-schedule/

exercises <- c("chord changes", "fingerpicking", "strumming", "songs")

ui <- fluidPage(
  hr(),
  actionButton("start","Start"),
  actionButton("stop","Stop"),
  actionButton("reset","Reset"),
  actionButton("addtime", "Add 1 min"),
  actionButton("restart", "Restart exercises"),
  textOutput("timeleft"),
  textOutput("exercise"),
  tags$iframe(id = "chords", src="http://ukulelego.com/ukulele-chord-progressions/", style="border:0", width="1200", height="1000")
)

server <- function(input, output, session) {
  # Initialize the timer, 10 seconds, not active
  active <- reactiveVal(FALSE)
  timer <- reactiveVal(5)
  i <- reactiveVal(1)


  output$timeleft <- renderText({
    paste("Time left: ", seconds_to_period(timer()))
  })
  
  output$exercise <- renderText({
    paste("Exercise:", exercises[i()])
    
  })
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
            timer(5)
            
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
  observeEvent(input$reset, {timer(5)})
  observeEvent(input$addtime, {timer(timer() + 60)})
  observeEvent(input$ok, {
    active(TRUE)
    removeModal()
  })
  observeEvent(input$restart, {
    timer(5)
    i(1)
    })
}
  
shinyApp(ui, server)
