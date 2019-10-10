##Thane and Reni
##Modification:  A modified work for final project in Temporal spatial analysis for master's program:  please note we did not run these models 
##We did not create these algorithms...we just modified the app to show leukemia data with temporal effects
##https://github.com/carrollrm/LAmortBrCaShiny/blob/master/server.R
library(shiny)
library(crayon)
library(rgdal)
library(leaflet)

leukmap <- readOGR(dsn='leuk', layer='LAcounty')
t=c(1.01,2:160)
modelAFT=list(summary=1)
modelAFT$summary=read.csv("data\\modelTleuk.csv")[,-1]

## THIS INDEX IS STILL VALID FOR LEUKEMIA offset by 1
u=modelAFT$summary[2:65]
map=read.csv("data\\LAcountyORDER.csv")


##==================================================================================================================================================
##===========================================Basic files needed above, input fields below===========================================================
##==================================================================================================================================================

###SIDE NOTE-  i AM SO AWESOME AND THIS WORKS AS EXPECTED NO NEED TO FIX ANYTHING HERE AT ALL :)

shinyServer(function(input,output,session){
  
  output$map <- renderLeaflet({
    leaflet(df, options = leafletOptions(doubleClickZoom= FALSE)) %>%
      addPolygons( data = leukmap
                   , fillOpacity = 0
                   , opacity = 0.5
                   , color = "#000000"
                   , weight = 2
                   , layerId = leukmap$NAME)
  })
  
  observe({
    click <- input$map_shape_click
    if (is.null(click))
      return()
    text <- paste(click$id)
    leafletProxy(mapId = "map") %>%
      clearPopups() %>%
      addPopups(dat = click, lat = ~lat, lng = ~lng, popup = text)
    
    updateSelectInput(session, "spt", selected = click$id)
  })
  
  output$text <- renderText({
    paste("The plot below displays the survival probability curve for leukemia related mortality 
          following leukemia diagnosis for a ",input$agedx," year old ","natural ", input$gender, 
          
          ifelse(input$race==TRUE,"African American","non-African American"),
          " patient that resided in ",input$spt, " Parish",
          ifelse(input$married=="Single"," and was single",
          ifelse(input$married=="Currently Married"," and was currently married",
          ifelse(input$married=="Previously Married"," and was previously married",""))),
          " at the time of diagnosis in ", input$year, ".")
          ifelse(input$year==2005, print("Survival probability may be low due to the impact of huricane Katrina."), print(" "))
##==================================================================================================================================================
##==================================================================================================================================================
    
  })
  output$survplot <- renderPlot({
    sptnum=map$order[which(map$NAME==input$spt)]
        survprob=1/(1+(exp(-(modelAFT$summary[67]+                                                                                            ##sdu
            modelAFT$summary[69]*(input$agedx-61.45055)/13.6418+                                                                              ##age
            ifelse(input$race==TRUE,modelAFT$summary[70],0)+                                                                                 ##race

##=================================================================================================================================================
            
  ## changed some indexes below this point
            ifelse(input$married=="Single",0,
                   ifelse(input$married=="Currently Married",modelAFT$summary[72],                                                        ##married
                   ifelse(input$married=="Previously Married",                                                                           ##divorced
                          modelAFT$summary[73],modelAFT$summary[74]))) +
##============== ##Gender and year ================================================================================================================

ifelse(input$year==2001, modelAFT$summary[75],
       ifelse(input$year==2002, modelAFT$summary[76],
              ifelse(input$year==2003, modelAFT$summary[77],
                     ifelse(input$year==2004, modelAFT$summary[78],
                            ifelse(input$year==2005, modelAFT$summary[79],                                                       ##Katrina hits LA
                                   ifelse(input$year==2006, modelAFT$summary[80],
                                          ifelse(input$year==2007, modelAFT$summary[81],
                                                 ifelse(input$year==2008, modelAFT$summary[82],
                                                        ifelse(input$year==2009, modelAFT$summary[83],
                                                               ifelse(input$year==2010, modelAFT$summary[84],
                                                                      ifelse(input$year==2011, modelAFT$summary[85],
                                                                             ifelse(input$year==2012, modelAFT$summary[86],
                                                                                    ifelse(input$year==2013, modelAFT$summary[87],))))))))))))) +
                       
        ##---------------------Gender ---------------------------------------------------------
                     ifelse(input$gender=="Female",0,
                            ifelse(input$gender=="Male", modelAFT$summary[71])) +
  
##==========================================            ###ABOVE CODE NEEDED =======================================================================

            
            
            u[sptnum]))*t)^(1/modelAFT$summary[1]))                                                                                       ##deviance
        
        ###breaks around here which makes me the big sad...and i mean BIG SAD :c 
        ###UPDATE- I FIXED IT...no more big sad
    plot(survprob~t,ylab="Survival Probability",type="l",xlab="Months",
         ylim=c(0,1),main="")
  })
  output$tab <- renderTable({
    sptnum=map$order[which(map$NAME==input$spt)]
    survprob=1/(1+(exp(-(modelAFT$summary[67]+
            modelAFT$summary[69]*(input$agedx-61.45055)/13.6418+
            ifelse(input$race==TRUE,modelAFT$summary[70],0)+

##==================================================================================================================================================             

            ifelse(input$married=="Single",0,
                   ifelse(input$married=="Currently Married",modelAFT$summary[72],                                                         ##married
                   ifelse(input$married=="Previously Married",                                                                            ##divorced
                          modelAFT$summary[73],modelAFT$summary[74])))+
##==================================================================================================================================================
##==================================================================================================================================================
##==================================================================================================================================================


            u[sptnum]))*c(12,24,60))^(1/modelAFT$summary[1]))                                                                             ##deviance
    data <- matrix(survprob,nrow=1,ncol=3,dimnames=list(list(),list("Survival Probabilty at 1 year",
                      "Survival Probability at 2 years","Survival Probability at 5 years")))
    
    
    
  })
})