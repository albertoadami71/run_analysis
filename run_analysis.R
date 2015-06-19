## List of necessary files in the work directory:
##     X_test.txt;
##     subject_test.txt
##     y_test.txt
##     X_train.txt; 
##     subject_train.txt; 
##     y_train.txt
##     activity_labels.txt
##     features.txt

##
## read test data files mentioned above
##

xtest <- read.table("X_test.txt")
stest <- read.table("subject_test.txt")
ytest <- read.table("y_test.txt")

##
## read train data files mentioned above
##

xtrain <- read.table("X_train.txt")
strain <- read.table("subject_train.txt")
ytrain <- read.table("y_train.txt")

##
## merge test and train data
##

xg<-rbind(xtest,xtrain)
yg<-rbind(ytest,ytrain)
sg<-rbind(stest,strain)

##
## read file activity_labels.txt and construct a table associating
## number and activity´s name 
##

##
## use function "scan" to get the file data sequentially.
## We obtain a vector with numbers and strings alternately, like this:
## "1"   "WALKING"    "2"  "WALKING_UPSTAIRS" ...and so on
## 
  
text<-scan("activity_labels.txt", what=character())
text<-as.data.frame(text)

##
## next step is separate elements in odd and even position
## odd: "1"  "2" ...
## even: "WALKING"  "WALKING_UPSTAIRS" ...
##

rowparity <- row(text)-2*ceiling(row(text)/2)
evenrow <-(rowparity==0)
oddrow <- (rowparity==-1)
id_activity <- text[oddrow]
name_activity <- text[evenrow]

##
## then, we construct a table (activity_table) with two columns: odd and even
##
##    "1"    "WALKING"
##    "2"    "WALKING_UPSTAIRS"  
##     ...   
##
activity_table <- data.frame( id_activity=as.numeric(id_activity), name_activity=as.character(name_activity))
activity_table$name_activity<-as.character(activity_table$name_activity)


##
## using the same procedure above, we read file features.txt 
## and construct a table (coltable) associating columns number and variable´s name, like this:
##
##         1  tBodyAcc-mean()-X
##         2  tBodyAcc-mean()-Y
##         3  tBodyAcc-mean()-Z
##         4  tBodyAcc-std()-X
##         5  tBodyAcc-std()-Y
##         ...
##

text<-scan("features.txt", what=character())
text<-as.data.frame(text)
rowparity <- row(text)-2*ceiling(row(text)/2)
oddrow <-(rowparity==0)
evenrow <- (rowparity==-1)
colnumber <- text[evenrow]
collabel <- text[oddrow]
coltable <- data.frame( colnumber=as.numeric(colnumber), collabel=as.character(collabel), stringsAsFactors = FALSE)


##
## now, we select from coltable the rows where the string 
## in second column has the term "-mean()" (using regex)
##

vermean<-regexpr("-mean()", coltable[,2], fixed=TRUE)>0

##
## the same with the term "-std"
##

verstd<-regexpr("-std()", coltable[,2], fixed=TRUE)>0

##
## then, we select from coltable the rows where 
## second column have the term "-mean" or "-std"
##
##         ...
##         45         tGravityAcc-std()-Y
##         46         tGravityAcc-std()-Z
##         81       tBodyAccJerk-mean()-X
##         82       tBodyAccJerk-mean()-Y
##         ...
##        

colextract<-coltable[(vermean|verstd),]

##
## below, we get from table xg (remember that xg = X_test join X_train)
## the columns where label contains the term "-mean" or "-std"
## (STEP 2 of Project requirements)
##

extract<-xg[,colextract[,1]] 

##
## put the labels in these selected columns
##

names(extract)=colextract[,2]

##
## put labels in columns subject and id_activity
##

names(sg)="subject"
names(yg)="id_activity"

##
## add columns subject and id_activity
##

tidy<-cbind(sg,yg,extract)

##
## to obtain the tidy data, it´s necessary associate the id_activity to name_activity
## we can do this, merging activity_table (see above) and tidy table 
##

tidy<-merge(activity_table,tidy, by="id_activity", sort=FALSE)

##
## now, a little change in initial columns and 
## we get the tidy data set asked for in STEP 4
##

tidy<-cbind(subject=tidy[,3],tidy) ## repeat column 3 in first position
tidy<-tidy[,-4] ## delete column 3

##
## to satisfy the STEP 5, we aggregate tidy data table by the columns
## subject and activity, calculating the mean value of aggregated elements
##

tidyaverage<-aggregate(tidy, by=list(tidy$subject,tidy$name_activity), FUN=mean)

##
## delete repeated and unnecessary columns
##
tidyaverage<-tidyaverage[,-(3:5)]

##
## rename the labels adding the term "avg" before the original variable name
##
labels <- names(tidyaverage)
labels<-paste("avg-",labels,sep="")
labels[1]<-"subject"
labels[2]<-"activity"
names(tidyaverage)<-labels

##
## order the final tidy table by column subject
##
tidyaverage<-tidyaverage[order(tidyaverage[,1]),]

##
## finally, export tidy data set to file "project.txt"
##
write.table(tidyaverage, file="project.txt", row.names=FALSE)
