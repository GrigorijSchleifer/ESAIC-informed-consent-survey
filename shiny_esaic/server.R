server <- function(input, output) {
    survey_fragments <- read.csv("survey_fragments.csv")
    # survey_fragments <- read.csv("/Users/grigorijschleifer/Desktop/R/Shiny/ESAIC-survey/ESAIC-KAI-survey-2021/data/survey_fragments.csv")
    
    
    colnames(survey_fragments) <-
        c(
            "expert.level",
            "country",
            "ASA.Class",
            "Apfel.Score",
            "NYHA.Score",
            "ARISCAT.Score",
            "rRCI",
            "POSPOM",
            
            "method.future.evaluation",
            "who.obtains",
            "online.legal",
            "online.possible.internet",
            "online.possible.telefon",
            
            "lack of contact",
            "impossible to observe behavior",
            "no relation",
            "no confidence",
            "legal requirenments",
            "unsure if illigal",
            "no anamnestic info",
            
            "Less stressful",
            "Less waiting",
            "Standardized questionaires",
            "More efficient than face-to-face",
            
            "Obtain.both.parents.complex",
            "Obtain.both.parents.simple",
            "parents.legal.online",
            "id.card",
            "id.card.needed"
        )
    
    # survey_fragments <- read_csv("survey_fragments.csv")
    # survey_fragments <- survey_fragments %>%
    #     select(-X1)
    
    
    # place interactive element on top instead at the left side
    # set the axis text dynamically
    # centralize data frames for single scores 
    
    
    # make expert selection
    country_selected <- reactive ({
        if (input$country == "All") {
            survey_fragments
        } else {
            subset(survey_fragments, country == input$country)
        }
    })
    
    counted_result <- reactive({
        country_selected() %>%
            gather(key = "risk_score",
                   value = "Answer",
                   c(-country, -expert.level)) %>%
            # does it make sense to filter on "Yes" for the entire dataset
            dplyr::filter(Answer != "Not selected", !is.na(Answer)) %>%
            count(risk_score, Answer)
    })
    
    
    ################## who obtains the informed consent ##################
    
    output$who_obtains_consent <- renderPlot({
        
        counted_result <- counted_result() %>%
            dplyr::filter(risk_score == "who.obtains")
        
        
        who_obtains_counts <-
            data.frame(
                who_obtains = c(
                    "Anaesthesia technician",
                    "Consultant",
                    "other",
                    "Resident", 
                    "Special trained nurse" 
                ),
                n = c(0, 0, 0, 0, 0))
        
        for(i in counted_result$Answer) {
            who_obtains_counts$n[who_obtains_counts$who_obtains == i] <- counted_result$n[counted_result$Answer == i]
        }
        
        who_obtains_counts %>% 
            ggplot(aes(x = who_obtains, y = n, fill = who_obtains)) +
            geom_col() +
            labs(x = "", 
                 y = "", 
                 title = "Who in general obtains the informed consent?") +
            theme_light(base_size = 15) + 
            # theme(axis.title.x = element_text(size = 15, colour = 'black'),
            #       axis.title.y = element_text(size = 15, colour = 'black', angle = 90),
            #       # title = element_text(size = 25, colour = 'black'),
            theme(legend.position = "None") +
            scale_fill_brewer(palette = "Set2") +
            ylim(0, max(who_obtains_counts$n) + 10)
    })
    
    ################## future_evaluation_plot ##################
    
    output$future_evaluation_plot <- renderPlot({
        counted_result <- counted_result() %>% 
            dplyr::filter(risk_score == "method.future.evaluation")
        
        df_online_evaluation <-
            data.frame(
                how_online = c(
                    "in person",
                    "online via patient´s self assessment",
                    "online via videoconference",
                    "via telefone"
                ),
                n = c(0, 0, 0, 0)
            )
        
        for(i in counted_result$Answer) {
            df_online_evaluation$n[df_online_evaluation$how_online == i] <- counted_result$n[counted_result$Answer == i]
        }
        
        df_online_evaluation %>% 
            ggplot(aes(x = how_online, y = n, fill = how_online)) +
            geom_col() +
            labs(x = "", 
                 y = "", 
                 title = "How would you prefer to do preoperative evaluation in the future?") +
            theme_light(base_size = 15) + 
            # theme(axis.title.x = element_text(size = 15, colour = 'black'),
            #       axis.title.y = element_text(size = 20, colour = 'black', angle = 90),
            #       title = element_text(size = 25, colour = 'black'),
            theme(legend.position = "None") +
            scale_fill_brewer(palette = "Set2") +
            ylim(0, max(df_online_evaluation$n) + 10)
        
    })
    
    
    ################## legal_online_plot ##################
    
    
    output$legal_online_plot <- renderPlot({
        counted_result <- counted_result() %>%
            dplyr::filter(risk_score == "online.legal")
        
        
        legal_online_counts <-
            data.frame(
                legal_online = c(
                    "I do not know",
                    "No",
                    "Yes"   
                ),
                n = c(0, 0, 0))
        
        for(i in counted_result$Answer) {
            legal_online_counts$n[legal_online_counts$legal_online == i] <- counted_result$n[counted_result$Answer == i]
        }
        
        legal_online_counts %>% 
            ggplot(aes(x = legal_online, y = n, fill = legal_online)) +
            geom_col() +
            labs(x = "", 
                 y = "", 
                 title = "Is an online/telephone informed consent legal in your country?") +
            theme_light(base_size = 15) + 
            # theme(axis.title.x = element_text(size = 15, colour = 'black'),
            #       axis.title.y = element_text(size = 20, colour = 'black', angle = 90),
            #       title = element_text(size = 25, colour = 'black'),
            #       legend.position = "None") +
            theme(legend.position = "None") +
            scale_fill_brewer(palette = "Set2") +
            ylim(0, max(legal_online_counts$n) + 10)
    })
    
    ################## possible_online_plot ###############
    
    output$possible_online_plot <- renderPlot({
        counted_result <- counted_result() %>%
            dplyr::filter(risk_score %in% c("online.possible.internet", "online.possible.telefon"))
        
        
        possible_online_counts <-
            data.frame(
                possible_online = c(
                    "Different (please comment)",
                    "No (please comment)",
                    "Yes",
                    "Different (please comment)",
                    "No (please comment)",
                    "Yes"
                ),
                method = c(
                    "internet",
                    "internet",
                    "internet",
                    "telefon",
                    "telefon",
                    "telefon"
                ),
                n = c(0, 0, 0, 0, 0, 0))
        
        for(i in counted_result$Answer) {
            possible_online_counts$n[possible_online_counts$possible_online == i] <- counted_result$n[counted_result$Answer == i]
        }
        
        possible_online_counts %>% 
            ggplot(aes(x = possible_online, y = n, fill = possible_online)) +
            geom_col() +
            labs(x = "", 
                 y = "", 
                 title = "Is it possible to obtain informed consent online via internet or telefone?") +
            theme_light(base_size = 15) + 
            # theme(axis.title.x = element_text(size = 15, colour = 'black'),
            #       axis.title.y = element_text(size = 20, colour = 'black', angle = 90),
            #       title = element_text(size = 25, colour = 'black'),
            #       legend.position = "None") +
            theme(legend.position = "None") +
            facet_wrap(~method) + 
            scale_fill_brewer(palette = "Set2") +
            ylim(0, max(possible_online_counts$n) + 10)
        # ggarrange(a, a, labels = c("a", "a"), ncol = 2, nrow = 1)
    })
    
    
    ################## missing out if online ##################
    
    output$missing_out_if_online_plot <- renderPlot({
        row_names <- c(
            "lack of contact",
            "impossible to observe behavior",
            "no relation",
            "no confidence",
            "legal requirenments",
            "unsure if illigal",
            "no anamnestic info"
        )
        
        counted_result <- counted_result() %>%  
            dplyr::filter(risk_score %in% row_names)
        
        reasons_against_tbl <-
            data.frame(
                reasons_against = c(
                    "lack of contact",
                    "impossible to observe behavior",
                    "no relation",
                    "no confidence",
                    "legal requirenments",
                    "unsure if illigal",
                    "no anamnestic info"
                ),
                n = c(0, 0, 0, 0, 0, 0, 0))
        
        for(i in counted_result$risk_score) {
            reasons_against_tbl$n[reasons_against_tbl$reasons_against == i] <- counted_result$n[counted_result$risk_score == i]
        }
        
        reasons_against_tbl %>% 
            ggplot(aes(x = reasons_against, y = n, fill = reasons_against)) +
            geom_col() +
            labs(x = "", 
                 y = "", 
                 title = "What are your major concerns about online or telephone interviews?") +
            theme_light(base_size = 15) + 
            # theme(axis.title.x = element_text(size = 15, colour = 'black'),
            #       axis.title.y = element_text(size = 20, colour = 'black', angle = 90),
            #       title = element_text(size = 25, colour = 'black'),
            #       legend.position = "None") +
            theme(legend.position = "None") +
            scale_fill_brewer(palette = "Set2") +
            ylim(0, max(reasons_against_tbl$n) + 10)
    })
    
    
    ################## Advantages for online informed consent ##################
    
    
    output$advantages_for_online <- renderPlot({
        row_names_advantages <- c(
            "Less stressful",
            "Less waiting",
            "Standardized questionaires",
            "More efficient than face-to-face"
        )
        
        counted_result <- counted_result() %>%  
            dplyr::filter(risk_score %in% row_names_advantages)
        
        reasons_for_tbl <-
            data.frame(
                reasons_for = c(
                    "Less stressful",
                    "Less waiting",
                    "Standardized questionaires",
                    "More efficient than face-to-face"
                ),
                n = c(0, 0, 0, 0))
        
        for(i in counted_result$risk_score) {
            reasons_for_tbl$n[reasons_for_tbl$reasons_for == i] <- counted_result$n[counted_result$risk_score == i]
        }
        
        reasons_for_tbl %>% 
            ggplot(aes(x = reasons_for, y = n, fill = reasons_for)) +
            geom_col() +
            labs(x = "", 
                 y = "", 
                 title = "What could be a major advantage of online/telephone interviews?") +
            theme_light(base_size = 15) + 
            # theme(axis.title.x = element_text(size = 15, colour = 'black'),
            #       axis.title.y = element_text(size = 20, colour = 'black', angle = 90),
            #       title = element_text(size = 25, colour = 'black'),
            #       legend.position = "None") +
            theme(legend.position = "None") +
            scale_fill_brewer(palette = "Set2") +
            ylim(0, max(reasons_for_tbl$n) + 10)
    })
    
    

    ################## risk scores for anesthesia evaluation ##################
    
    output$risk_scores_plot <- renderPlot({
        counted_result <- counted_result()
        
        df_for_scores <-
            data.frame(
                risk_score = c(
                    "ASA.Class",
                    "Apfel.Score",
                    "NYHA.Score",
                    "ARISCAT.Score",
                    "rRCI",
                    "POSPOM"
                ),
                n = c(0, 0, 0, 0, 0, 0))
        
        for(i in counted_result$risk_score) {
            df_for_scores$n[df_for_scores$risk_score == i] <- counted_result$n[counted_result$risk_score == i]
        }
        
        df_for_scores %>% 
            ggplot(aes(x = risk_score, y = n, fill = risk_score)) +
            geom_col() +
            labs(x = "", 
                 y = "", 
                 title = "Which of the following Risc Scores do you routinely use?") +
            theme_light(base_size = 15) + 
            # theme(axis.title.x = element_text(size = 15, colour = 'black'),
            #       axis.title.y = element_text(size = 20, colour = 'black', angle = 90),
            #       title = element_text(size = 25, colour = 'black'),
            #       legend.position = "None") +
            theme(legend.position = "None") +
            scale_fill_brewer(palette = "Set2") + 
            ylim(0, max(df_for_scores$n) + 10)
    })
    
    
    ######################## Both parents plot #############################

    
    output$both_parents_plot <- renderPlot({
        
        counted_result <- counted_result() %>%  
            dplyr::filter(risk_score %in% c("Obtain.both.parents.complex", "Obtain.both.parents.simple")) %>% 
            dplyr::filter(Answer %in% c("Always both parents", "Just the one, who is present"))
        
        
        both_parents <-
            data.frame(
                both = c(
                    "Always both parents", 
                    "Just the one, who is present",
                    "Always both parents", 
                    "Just the one, who is present"
                ),
                method = c(
                    "complex procedures",
                    "complex procedures",
                    "simple procedures",
                    "simple procedures"
                ),
                n = c(0, 0, 0, 0))
        
        # here I use Answer as column index instead of risc_score becaus the score name is the same for the entire column
        for(i in counted_result$Answer) {
            both_parents$n[both_parents$both == i] <- counted_result$n[counted_result$Answer == i]
        }
        
        both_parents %>% 
            ggplot(aes(x = both, y = n, fill = both)) +
            geom_col() +
            labs(x = "", 
                 y = "", 
                 title = "Do you obtain Informed consent from both parents or just from one?") +
            theme_light(base_size = 15) + 
            # theme(axis.title.x = element_text(size = 15, colour = 'black'),
            #       axis.title.y = element_text(size = 20, colour = 'black', angle = 90),
            #       title = element_text(size = 25, colour = 'black'),
            #       legend.position = "None") +
            theme(legend.position = "None") +
            scale_fill_brewer(palette = "Set2") +
            facet_wrap(~method) +
            ylim(0, max(both_parents$n) + 10)
        
    })
    
    ################## parents legal online ##################
    
    output$parents_legal_online_counts <- renderPlot({
        
        counted_result <- counted_result() %>%
            dplyr::filter(risk_score == "parents.legal.online")
        
        
        parents_legal_online_counts <-
            data.frame(
                parents_legal_online = c(
                    "Yes", 
                    "No"
                ),
                n = c(0, 0))
        
        for(i in counted_result$Answer) {
            parents_legal_online_counts$n[parents_legal_online_counts$parents_legal_online == i] <- counted_result$n[counted_result$Answer == i]
        }
        
        parents_legal_online_counts %>% 
            ggplot(aes(x = parents_legal_online, y = n, fill = parents_legal_online)) +
            geom_col() +
            labs(x = "", 
                 y = "", 
                 title = "Do you know if it is legally allowed to obtain informed consent from the parent/caregiver via Internet or telephone?") +
            theme_light(base_size = 15) + 
            # theme(axis.title.x = element_text(size = 15, colour = 'black'),
            #       axis.title.y = element_text(size = 20, colour = 'black', angle = 90),
            #       title = element_text(size = 25, colour = 'black'),
            #       legend.position = "None") +
            theme(legend.position = "None") +
            scale_fill_brewer(palette = "Set2") +
            ylim(0, max(parents_legal_online_counts$n) + 10)
    
    })
    
    ################## id card ##################
    
    output$id_card <- renderPlot({
        
        counted_result <- counted_result() %>%
            dplyr::filter(risk_score == "id.card")
        
        
        id_card_counts <-
            data.frame(
                id_card_answer = c(
                    "Yes", 
                    "No"
                ),
                n = c(0, 0))
        
        for(i in counted_result$Answer) {
            id_card_counts$n[id_card_counts$id_card_answer == i] <- counted_result$n[counted_result$Answer == i]
        }
        
        id_card_counts %>% 
            ggplot(aes(x = id_card_answer, y = n, fill = id_card_answer)) +
            geom_col() +
            labs(x = "", 
                 y = "", 
                 title = "Do you routinely check the identity or legal responsibility of the parent/caregiver (i.e. ID card)") +
            theme_light(base_size = 15) + 
            # theme(axis.title.x = element_text(size = 15, colour = 'black'),
            #       axis.title.y = element_text(size = 20, colour = 'black', angle = 90),
            #       title = element_text(size = 25, colour = 'black'),
            #       legend.position = "None") +
            theme(legend.position = "None") +
            scale_fill_brewer(palette = "Set2") +
            ylim(0, max(id_card_counts$n) + 10)
        
    })
    
    ################## id card needed ##################
    
    output$id_card_needed <- renderPlot({
        
        counted_result <- counted_result() %>%
            dplyr::filter(risk_score == "id.card.needed")
        
        
        id_card_needed_counts <-
            data.frame(
                id_card_needed_answer = c(
                    "Yes", 
                    "No"
                ),
                n = c(0, 0))
        
        for(i in counted_result$Answer) {
            id_card_needed_counts$n[id_card_needed_counts$id_card_needed_answer == i] <- counted_result$n[counted_result$Answer == i]
        }
        
        id_card_needed_counts %>% 
            ggplot(aes(x = id_card_needed_answer, y = n, fill = id_card_needed_answer)) +
            geom_col() +
            labs(x = "", 
                 y = "", 
                 title = "Do you think it is necessary to verify the identity of the parent/guardian  (i.e. ID card)") +
            theme_light(base_size = 15) + 
            # theme(axis.title.x = element_text(size = 15, colour = 'black'),
            #       axis.title.y = element_text(size = 20, colour = 'black', angle = 90),
            #       title = element_text(size = 25, colour = 'black'),
            #       legend.position = "None") +
            theme(legend.position = "None") +
            scale_fill_brewer(palette = "Set2") +
            ylim(0, max(id_card_needed_counts$n) + 10)
        
    })
    
}




