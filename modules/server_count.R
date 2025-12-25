box::use(shiny[...])
box::use(dplyr[...])
box::use(ggplot2[...])
box::use(tidyr[...])
box::use(stringr[...])
box::use(purrr[...])
box::use(magrittr[`%>%`])
box::use(tm[termFreq])
box::use(tibble[rownames_to_column])



server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      raw_str = reactive({
        input$in_text %>% 
          str_to_lower()
      })
      
      raw_str_split_cleaned = reactive({
        out = str_split(raw_str(), ' ') %>%
          # returns a list, split by paragraph
          map(
            function(word) {
              word %>%
                str_extract('[a-z0-9\\.]+') %>%
                str_remove('[\\.\\,\\;\\:]$') # remove punctuation at the end
            }
          ) %>%
          flatten_chr()
        out = out[!is.na(out)] # remove non-matched words
      })
      
      exclusions_str = reactive({
        input$in_exclusions %>% 
          str_split(',') %>% 
          map(
            function(word) str_trim(word)
          ) %>% 
          flatten_chr()
      })
      
      output$out_counts <- renderText({
        
        # track stats
        input_stats = list()
        input_stats$word_count = length(raw_str_split_cleaned())
        input_stats$char_count = nchar(raw_str())
        
        out_str = str_c(
          input_stats$word_count, ' words, ',
          input_stats$char_count, ' characters'
        )
      })
      
      output$plot_text_histogram <- renderPlot({
        
        # get frequencies
        d_freq = termFreq(
          raw_str_split_cleaned(),
          control = list(
            wordLengths = c(1, Inf)
          )
        ) %>%
          as.data.frame() %>%
          rownames_to_column()
        colnames(d_freq) = c('word', 'count')
        
        # ordering and top n filtering
        d_freq = d_freq %>% 
          # remove exclusions - quick and dirty
          filter(!word %in% exclusions_str()) %>% 
          # ordering
          arrange(desc(count)) %>% 
          slice_head(n = input$in_top_n) %>% 
          mutate(word = factor(word, levels = word))
  
        # plot
        ggplot(d_freq, aes(x = word, y = count)) +
          geom_bar(stat = 'identity') +
          theme_minimal() +
          theme(
            text = element_text(
              size = input$in_font_size, family = 'Helvetica'
            ),
            axis.text.x = element_text(angle = 45, hjust = 1)
          )

      })
      
      
    }
  )
}