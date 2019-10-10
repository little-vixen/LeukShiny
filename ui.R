library(shiny)
library(shinythemes)
library(leaflet)

shinyUI(fluidPage(
  theme = shinytheme("slate"),
  
  titlePanel("Mortality in LA following Leukemia Diagnosis"),
  sidebarLayout(
    sidebarPanel(
      helpText("Display survival probability curves based on user input."),
      selectInput("spt",label="Parish of Residence",
                  choices=sort(c("Calcasieu","Union","Tangipahoa","Caldwell","Tensas","Jackson",
                               "Grant","Lincoln","Jefferson Davis","Lafayette","Vermilion",
                               "East Carroll","East Feliciana","St. Bernard","Iberville","Richland",
                               "St. Martin","Claiborne","Evangeline","St. Landry","Pointe Coupee",
                               "LaSalle","Webster","St. James","Plaquemines","Morehouse","Rapides",
                               "Avoyelles","Winn","Vernon","Catahoula","Assumption","De Soto",
                               "Caddo","Red River","Washington","Sabine","Jefferson","St. Tammany",
                               "Cameron","East Baton Rouge","Iberia","Natchitoches","Terrebonne",
                               "Bienville","Bossier","Allen","Ouachita","St. John the Baptist",
                               "St. Helena","West Feliciana","St. Mary","Lafourche","West Carroll",
                               "Concordia","Livingston","West Baton Rouge","Madison","Orleans",
                               "Ascension","Acadia","St. Charles","Beauregard","Franklin"))),
      
      ##YEAR OF DIAGNOSIS==========================================================================================================
      numericInput("year", label="Enter the year of diagnosis",value=2001, min=2001, max=2013),
      helpText("Note:  'Year should fall between 2001 and 2013"),
      
      ##AGE KEEP THIS =============================================
      numericInput("agedx",label="Enter your age at diagnosis",value=50),
      
      ## RACE KEEP THIS ==========================================
      checkboxInput("race",label="Select if you are of African American descent.",value=FALSE),
      
      
      ## MARITAL STATUS- KEEP THIS =================================================
      selectInput("married",label="Marital Status at Diagnosis",
                  choices=list("Single","Currently Married","Previously Married","Other"),selected="Single"),
      helpText("Note: 'currently married' includes life or domestic partners. Divorced includes divorced and seperated individuals."),
      
      ##GENDER ADD HERE ===============================================================
      selectInput("gender", label="Gender at birth",
                  choices=list("Male", "Female"),selected="Female"),
      
      ##RISK FACTORS ARE ALL INCLUSIVE AT THIS POINT, DON'T CHANGE
      tags$a(class="btn btn-default", href="https://www.cancercenter.com/cancer-types/leukemia?invsrc=non_branded_paid_search_google_atlanta&t_pur=prospecting&t_med=online&t_ch=paid_search&t_adg=77281968216&t_ctv=377188349019&t_mtp=e&t_pos=1t1&t_plc=kwd-45306790&t_si=google&t_tac=none&t_con=non_brand&t_bud=corp&t_d=c&t_tar=non_targeted&t_aud=any&kxconfid=s8ymtai82&dskid=%7btrackerid%7d&t_re=se&t_mtk=atl&t_mod=cpc&t_cam=6446074485&t_trm=leukemia&t_src=g&dstrackerid=43700046480540099&awsearchcpc=1&gclid=Cj0KCQjwivbsBRDsARIsADyISJ9fUk2CXofS2aOHEHw4MYxER1_HopHPa3CDilpOl8kFcbtO1HWU6xUaAulbEALw_wcB&gclsrc=aw.ds", "Resources for leukemia")
    ),
    mainPanel(
      leafletOutput("map"),
      textOutput("text"),
      plotOutput("survplot"),
      tableOutput("tab")
     )
  )
))