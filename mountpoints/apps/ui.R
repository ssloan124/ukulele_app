library(shiny)

ui <- fluidPage(
  hr(),
  actionButton("start","Start"),
  actionButton("stop","Stop"),
  actionButton("reset","Reset"),
  actionButton("addtime", "Add 1 min"),
  actionButton("restart", "Restart exercises"),
  textOutput("timeleft"),
  textOutput("exercise"),
  column(8, tags$iframe(src="http://ukulelego.com/ukulele-chord-progressions/", style="border:0", width="950", height="700")),
  column(4, 
         wellPanel(
             strong("Metronome"),
             br(),
             actionButton("metrostart", "Start"), 
             actionButton("metrostop", "Stop"),
             sliderInput("vol", 
                         "Volume",
                         min = 0,
                         max = 100,
                         value = 10),
             numericInput("bpm",
                          "Beats per Minute",
                          value = 60),
             textInput("timesig",
                          "Time Signature",
                          value = "[4,4]"),
             strong("Strumming Pattern"),
             actionButton("newpattern", "New Pattern"),
             br(),
             plotOutput("strum"),
             strong("Strumming patterns provided by ukulelego.com!!")
             )
  )
)