# # save.image(file = "survey_data_image.R")
# load("data/survey_data_image.R")
# survey_data <- bind_rows(data_180, data_282, data_1000)

survey_data <- read_csv("survey_data.csv")
survey_data <- survey_data %>%
    select(-c("X1"))


survey_fragments <- survey_data %>%
    select(
        c(
            "Your expert level",
            "Country where you work?",
            "[ASA-Class] Which of the following Scores do you routinely use in preoperative evaluation?",
            "[Apfel-Score] Which of the following Scores do you routinely use in preoperative evaluation?",
            "[NYHA-Score] Which of the following Scores do you routinely use in preoperative evaluation?",
            "[ARISCAT-Score] Which of the following Scores do you routinely use in preoperative evaluation?",
            "[rCRI] Which of the following Scores do you routinely use in preoperative evaluation?",
            "[POSPOM] Which of the following Scores do you routinely use in preoperative evaluation?", 
            
            "How would you prefer to do the anaesthesiological preoperative evaluation in the future?",
            "Who in general obtains the informed consent prior to anaesthesia?",
            "Is an online/telephone informed consent for elective surgery in accordance with the legal requirements in your country? (for complex procedures, higher risk patients)",
            
            "Is it possible to obtain informed consent online via internet, in your routine setting?",
            "Is it possible to obtain informed consent online via telefone, in your routine setting?",
            
            "[Lack of personal contact] What are your major concerns about online or telephone interviews? (More than one answer is possible)",
            "[Patient´s behaviour is impossible to observe] What are your major concerns about online or telephone interviews? (More than one answer is possible)",
            "[Personal relation with the patient cannot be build] What are your major concerns about online or telephone interviews? (More than one answer is possible)",
            "[Confidence in anaesthesia cannot be achieved] What are your major concerns about online or telephone interviews? (More than one answer is possible)",
            "[Impossible to fulfil legal requirements] What are your major concerns about online or telephone interviews? (More than one answer is possible)",
            "[I am not sure if it might be illegal in my country] What are your major concerns about online or telephone interviews? (More than one answer is possible)",
            "[Impossible to gather for anamnestic information] What are your major concerns about online or telephone interviews? (More than one answer is possible)",
            
            "[More relaxed for the patients] What could be a major advantage of online/telephone interviews? (More than one answer is possible)",
            "[Less anger/stress due to long waiting] What could be a major advantage of online/telephone interviews? (More than one answer is possible)",
            "[With specific questions all information could be obtained] What could be a major advantage of online/telephone interviews? (More than one answer is possible)",
            "[Together with special designed written information and professional pre-produced videos it might be more efficient than face-to-face meeting] What could be a major advantage of online/telephone interviews? (More than one answer is possible)",
            
            "Do you need to obtain written Informed consent for elective surgery due to legal requirements from both parents or just from one (complex procedures, higher risk patients)?",
            "Do you need to obtain written Informed consent for elective surgery due to legal requirements from both parents or just from one (simple procedures, low risk patients)?",
            "Do you know if it is legally allowed to obtain informed consent from the parent/caregiver via Internet or telephone?",
            "In case of personal presence of the parent/caregiver do you routinely check the identity or legal responsibility of the parent/caregiver (i.e. ID card)",
            "Do you think it is necessary to verify the identity of the parent/guardian  (i.e. ID card)",
            
        )
    )

# # wrap text to no more than 15 spaces
# library(stringr)
# diamonds$cut2 <- str_wrap(diamonds$cut, width = 15)

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


survey_fragments$online.legal[survey_fragments$online.legal == "No (please comment the reasons)"] <- "No"
survey_fragments$online.legal[survey_fragments$online.legal == "I do not know the legal requirements"] <- "I do not know"



# library(openxlsx)
write.xlsx(survey_data, 'survey_data.xlsx')
write.csv(survey_data, "survey_data.csv")

# store new fragments data to two different locations for shiny and all the rest
write_csv(survey_fragments, "survey_fragments.csv")
write_csv(survey_fragments, "shiny_esaic/survey_fragments.csv")


# variable.labels = c(

#     "id",
#     "submitdate",
#     "lastpage",
#     "startlanguage",
#     "seed",
#     "Gender",
#     "What is your age?",
#     "Profession",
#     "Your expert level",
#     "Years of experience",
# 

######################################################
################ Technical baseline ##################
######################################################

#   "How would you prefer to do the anaesthesiological preoperative evaluation in the future?",
#   "Who in general obtains the informed consent prior to anaesthesia?",
#   "Is an online/telephone informed consent for elective surgery in accordance with the legal requirements in your country? (for complex procedures, higher risk patients)",
#   "Is it possible to obtain informed consent online via internet, in your routine setting?",
#   "Is it possible to obtain informed consent online via telefone, in your routine setting?",




#   "[Comment] Is an online/telephone informed consent for elective surgery in accordance with the legal requirements in your country? (for complex procedures, higher risk patients)",
#   "Is an online/telephone informed consent for elective surgery in accordance with the legal requirements in your country? (for simple procedures, low risk patients)",
#   "[Comment] Is an online/telephone informed consent for elective surgery in accordance with the legal requirements in your country? (for simple procedures, low risk patients)",
#   "Thinking of Re-Do / repeated anaesthesia assuming the patient is well informed. Would an online/telephone informed consent then be allowed for elective surgery due to legal requirements in your country?",
#   "Is there a special regulation in your country during this pandemic situation favouring online or telephone informed consent?",
#   "Do you know if it is legally allowed to obtain informed consent via Internet or telephone (for simple procedures, low risk patients) in your country?",
#   "[Comment] Do you know if it is legally allowed to obtain informed consent via Internet or telephone (for simple procedures, low risk patients) in your country?",


#   "When do you need to obtain Informed consent for elective surgery based on legal requirements (for complex procedures, higher risk patients).",
#   "When do you need to obtain Informed consent for elective surgery based on legal requirements (for simple procedures, low risk patients).",


#     "When ensuring a certain guideline, which may include i.e. specific appointment (time and date) for the interview, secure data protected online service, asking if there is a relaxed environment without distraction, parents’ explicit agreement in online or telephone interview. Would this be an alternative to personal face-to-face meetings?",
#     "[Comment] When ensuring a certain guideline, which may include i.e. specific appointment (time and date) for the interview, secure data protected online service, asking if there is a relaxed environment without distraction, parents’ explicit agreement in online or telephone interview. Would this be an alternative to personal face-to-face meetings?",

#   "[Other] How would you prefer to do the anaesthesiological preoperative evaluation in the future?",
#   "[Comment] Is it possible to obtain informed consent online via internet, in your routine setting?",
#   "[Comment] Is it possible to obtain informed consent online via telefone, in your routine setting?",


####################################################################################################
############################### Anesthesiological Evaluation #######################################
####################################################################################################

#   "[ASA-Class] Which of the following Scores do you routinely use in preoperative evaluation?",
#   "[Apfel-Score] Which of the following Scores do you routinely use in preoperative evaluation?",
#   "[NYHA-Score] Which of the following Scores do you routinely use in preoperative evaluation?",
#   "[ARISCAT-Score] Which of the following Scores do you routinely use in preoperative evaluation?",
#   "[rCRI] Which of the following Scores do you routinely use in preoperative evaluation?",
#   "[POSPOM] Which of the following Scores do you routinely use in preoperative evaluation?",
#   "[Other] Which of the following Scores do you routinely use in preoperative evaluation?",


#   "[Other] What are your major concerns about online or telephone interviews? (More than one answer is possible)",
#   "[Lack of personal contact] What are your major concerns about online or telephone interviews? (More than one answer is possible)",
#   "[Patient´s behaviour is impossible to observe] What are your major concerns about online or telephone interviews? (More than one answer is possible)",
#   "[Personal relation with the patient cannot be build] What are your major concerns about online or telephone interviews? (More than one answer is possible)",
#   "[Confidence in anaesthesia cannot be achieved] What are your major concerns about online or telephone interviews? (More than one answer is possible)",
#   "[Impossible to fulfil legal requirements] What are your major concerns about online or telephone interviews? (More than one answer is possible)",
#   "[I am not sure if it might be illegal in my country] What are your major concerns about online or telephone interviews? (More than one answer is possible)",
#   "[Impossible to gather for anamnestic information] What are your major concerns about online or telephone interviews? (More than one answer is possible)",


#       What could be a major advantage of online/telephone interviews? (More than one answer is possible)",
#     "[If patients are from remote locations,  no travel or transportation is necessary] What could be a major advantage of online/telephone interviews? (More than one answer is possible)",
#     "[More relaxed for the patients] What could be a major advantage of online/telephone interviews? (More than one answer is possible)",
#     "[No waste of time waiting in the holding area] What could be a major advantage of online/telephone interviews? (More than one answer is possible)",
#     "[Less anger/stress due to long waiting] What could be a major advantage of online/telephone interviews? (More than one answer is possible)",
#     "[With specific questions all information could be obtained] What could be a major advantage of online/telephone interviews? (More than one answer is possible)",
#     "[Together with special designed written information and professional pre-produced videos it might be more efficient than face-to-face meeting] What could be a major advantage of online/telephone interviews? (More than one answer is possible)",
#     "[Other] What could be a major advantage of online/telephone interviews? (More than one answer is possible)",


########################################################################################
################################### Pediatrics #########################################
########################################################################################


#     "Do you need to obtain written Informed consent for elective surgery due to legal requirements from both parents or just from one (complex procedures, higher risk patients)?",
#     "[Comment] Do you need to obtain written Informed consent for elective surgery due to legal requirements from both parents or just from one (complex procedures, higher risk patients)?",
#     "Do you need to obtain written Informed consent for elective surgery due to legal requirements from both parents or just from one (simple procedures, low risk patients)?",
#     "[Comment] Do you need to obtain written Informed consent for elective surgery due to legal requirements from both parents or just from one (simple procedures, low risk patients)?",
#     "[Age above ...] What requirements does a child have to fulfil to sign independently?",
#     "[Comment] [Age above ...] What requirements does a child have to fulfil to sign independently?",
#     "[Having the mental capacity to understand the consequences of its decision] What requirements does a child have to fulfil to sign independently?",
#     "[Comment] [Having the mental capacity to understand the consequences of its decision] What requirements does a child have to fulfil to sign independently?",
#     "[other ...] What requirements does a child have to fulfil to sign independently?",
#     "[Comment] [other ...] What requirements does a child have to fulfil to sign independently?",
#     "Do you know if it is legally allowed to obtain informed consent from the parent/caregiver via Internet or telephone?",
#     "[Comment] Do you know if it is legally allowed to obtain informed consent from the parent/caregiver via Internet or telephone?",
#     "In case of personal presence of the parent/caregiver do you routinely check the identity or legal responsibility of the parent/caregiver (i.e. ID card)",
#     "[Comment] In case of personal presence of the parent/caregiver do you routinely check the identity or legal responsibility of the parent/caregiver (i.e. ID card)",
#     "Do you think it is necessary to verify the identity of the parent/guardian  (i.e. ID card)",
#     "[Comment] Do you think it is necessary to verify the identity of the parent/guardian  (i.e. ID card)"
















# )
# 
# names(survey_data) <- variable.labels
# survey_data <- survey_data[!is.na(survey_data$Gender), ]