box::use(shiny[...])
box::use(shinyjqui[jqui_resizable])

sidebar <- function(id) {
  tagList(
    # h3('this is the sidebar'),
    numericInput(
      NS(id, 'in_top_n'),
      label = 'Number of top words to show',
      value = 30, min = 0, max = 50, step = 1
    ),
    textAreaInput(
      NS(id, 'in_exclusions'),
      label = 'Exclusions (comma separated)',
      value = ''
    ),
    numericInput(
      NS(id, 'in_font_size'),
      label = 'Plot font size',
      value = 18, min = 2, max = 50, step = 1
    ),
    h5('made for z with ❤️'),
    tags$a(
      href = "https://github.com/aays/wordutils",
      icon('github')
    )
  )
}

example_text <- function(i) {
  c(
    'Words - so many words - can go here.',
    'Man hook hand hook car door',
    'And just let him die??',
    'Hewwo...',
    'What the fuck did you just say about me you little'
  )[i]
}

main <- function(id) {
  tagList(
    textAreaInput(
      NS(id, 'in_text'),
      label = 'Text',
      value = example_text(sample(seq(1, 5), 1)),
      width = '1000px',
      height = '400px'
    ),
    
    textOutput(
      NS(id, 'out_counts')
    ),
    
    jqui_resizable(
      plotOutput(
        NS(id, 'plot_text_histogram')
      )
    )
    
  )
}