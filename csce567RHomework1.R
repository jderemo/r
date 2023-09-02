
library(readr)
gasSales <- read_csv("C:/Users/Jeffrey DeRemo/Desktop/csce 567/Estimated_Gasoline_Sales__Beginning_1995.csv")
View(Estimated_Gasoline_Sales_Beginning_1995)
library(ggplot2)
library(plotly)
table(gasSales$county)

gasSales = setNames(gasSales, c("Year","county","Gallons") )

gasSales= gasSales[gasSales$county == "New York City"|gasSales$county == "Suffolk"|gasSales$county == "Nassau" |
                     gasSales$county == "Erie", ]
ggplotly(ggplot(gasSales, aes(Year, Gallons, color = county))+geom_point()
+ xlab("Year")+
  ylab("Thousans of gallons")+ ggtitle("Estimated Gasoline Sales 1995-2016") )


ggplotly(ggplot(gasSales,aes(county, Gallons, fill = county)) + geom_col() +facet_wrap(~Year)+
  xlab("County") +
  ylab("Thousans of gallons")+ ggtitle("Gasoline Sales 1995-2016"))



ggplotly(ggplot(gasSales, aes(county,Gallons))+ geom_boxplot()+
  xlab("County") +
  ylab("Thousans of gallons")+ ggtitle("Gasoline Sales 1995-2016")
)
