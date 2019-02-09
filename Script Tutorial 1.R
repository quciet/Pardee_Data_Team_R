library(data.table)
library(openxlsx)
library(readxl)
###
###
class(12)
str(12)

str("haha") # or 'haha'
str(TRUE) # or T
str( as.character(12) )

class(c(12:16)) # or class(c(12,13,14,15,16))
str(c(12:16))
str(c(12,'haha',T))
str(c(T,F,T))
    
c(3:6)
v<-c(3:6) # or v=c(3:6)
v    # try print(v)
length(v)
###
###
df<-data.frame(Year=c(1992,1993,1994,1995,1996,1993,1997,1993),
               Country=c('China','China','United States','Russia','Russia','China','Russia','China'),
               Value=c(1146,2342,678,212,20,2342,NA,2342))
df

dt<-data.table(Year=c(1992,1993,1994,1995,1996,1993,1997,1993),
               Country=c('China','China','United States','Russia','Russia','China','Russia','China'),
               Value=c(1146,2342,678,212,20,2342,NA,2342)) 
## try dt<-as.data.table(df)
dt
class(dt)
str(dt)

# ?write.xlsx
write.xlsx(dt,"TestDT.xlsx",sheetName="test",colNames=T) 
# note: you can only use the relative path when you open the R script in the corresponding directory
# Otherwise, use absolute path instead, see an example below
# "/Users/Xyt/Desktop/Pardee Center/Influence Data/influence dataset 6.20.17.dta"

# ?read_excel
dt.test<-as.data.table(read_excel("TestDT.xlsx",sheet=NULL,n_max=Inf,col_names=TRUE,skip=0))
# default values: sheet=NULL,n_max=Inf,col_names=TRUE,skip=0
dt.test

nrow(dt.test) # try ncol() to get the number of columns
head(dt.test,2)
var.name<-names(dt.test)
var.name

table(dt.test$Country)       ## what will happen if you do table(dt.test)
summary(dt.test)
summary(dt.test$Value)
sd(dt.test$Value,na.rm=T)

dt.test[1,]  # try dt.test[,1]  dt.test[1] and dt.test[[1]]; Is there any difference? 
dt.test[3,2] ## indices can be chained together, try dt.test[3,][,2]

dt.test[,c("Country","Value"),with=F]
## what if we switch the names? dt.test[,c("Value","Country"),with=F]
## Also try dt.test[,names(dt.test)[1:2],with=F]

dt.test1<-data.table(dt.test)   # what would happen if you use normal assign dt.test1<-dt.test
dt.test1[,Value:=NULL]
dt.test1
# data.table does not support deleting rows by reference, so just use the index subset method introduced above

dt.test[Year==1997]  # what happens if no matches found? try dt.test[Year==2000]
dt.test[Year>=1993 & Value>1000] # or dt.test[Year>=1993][Value>1000]?

dt.test2<-data.table(dt.test)
dt.test2[Value >= 1000, Value := 33333]
dt.test2

dt.test3<-data.table(dt.test)
dt.test3[which(dt.test3$Value>=1000),3]<-33333  # run which(dt.test3$Value>=1000) and see the result
dt.test3

dt.test4<-data.table(dt.test)
is.na(dt.test4)
# see ?na.omit for optional arguments
# default for cols are all the columns, what if we change it to c("Year","Country")
# invert=FALSE is the default
na.omit(dt.test4,invert=T) 

dt.test5<-data.table(dt.test)
dt.test5[is.na(Value) == T, Value := 0]     
dt.test5

# see ?unique
unique(dt.test,by=c(1,2))

dt.test[which(duplicated(dt.test)==F),]

dt.test
duplicated(dt.test)
which(duplicated(dt.test)==T)
duplicated(dt.test,fromLast=T)
which(duplicated(dt.test,fromLast=T)==T)
dup<-sort(c(which(duplicated(dt.test)==T),which(duplicated(dt.test,fromLast=T)==T)))
dt.test[dup,]

names(dt.test)[names(dt.test)=="Value"]<-"GDP"
dt.test

# see ?setorder
setorder(dt.test)
dt.test

# see ?gsub
country<-unique(dt.test$Country)
country
gsub(pattern="States",replacement="States of America",country)
gsub(pattern="i",replacement="I",country)

# see ?strsplit,  note that this function returns a list 
# also see ?toString and ?paste
country2<-"China,Japan,Korea North"
strsplit(country2,",")[[1]]
toString(country)
paste(country,collapse=";")    
# Be aware of the difference between paste("China","Japan") and paste(c("China","Japan")) 

# see ?match  and ?agrep
country3<-c("China","United States","Soviet Union","Russia","Russia Federation")
match(country,country3)
agrep("Rusia",country3,ignore.case = FALSE, value=T,max.distance=0.1)
# the most basic but hard to understand function: ?grep
# check https://www.rstudio.com/wp-content/uploads/2016/09/RegExCheatsheet.pdf
grep("i[a-zA-Z]n",country3,value=T)
grep("in|i.n",country3,value=T)

# check ? trimws
country4<-c("China~","China~","United States","Soviet Union","Russia",
            "Russia Federation!","Côte d’Ivoire","Côte","Côte  ")
trimws(country4,which="both")
unique(grep("[^a-zA-Z\\s]",trimws(country4,which="both"),value=T,perl=T))
unique(grep("[[:graph:]]",trimws(country4,which="both"),value=T,perl=T))


# see ?list.files
list.files()