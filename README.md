The tidy data in this project was created to organize and summarize a set of measures 
obtained and explained in: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. 
This site contains information about the variables and its units.

In the original data file we find several measures and features (561) about 30 subjects in 6 activities.

Our data summarize the information by subject identifier and activity name, calculating the average of aggregated values.

For example, if original data set has 4 (four)  tBodyAcc-mean()-Y measures for subject 10 in WALKING activity (number 1 in original data set):

		subject		activity	 tBodyAcc-mean()-Y
		10		1		0.1010
		10		1		0.0202	
		10		1		0.0101
		10		1		0.2020

then, we construct a row specifying subject, activity (by name) and the average (avg) of the 4 (four) measures:
		
		subject		  activity	avg-tBodyAcc-mean()-Y
		10		WALKING		0.0833


The project requires we extract only the measurements on the mean and standard deviation (std). 

To obtain the tidy data, we use the following steps:

1) List of necessary files in the work directory:
     X_test.txt;
     subject_test.txt
     y_test.txt
     X_train.txt; 
     subject_train.txt; 
     y_train.txt
     activity_labels.txt
     features.txt


2) Read test data files mentioned above;

3) Read train data files mentioned above;

4) Merge test and train data;

5) Read file “activity_labels.txt” and construct a table associating
 number and activity´s name; 

6) Use function "scan" to get the file data sequentially;
 We obtain a vector with numbers and strings alternately, like this:
 
"1"   "WALKING"    "2"  "WALKING_UPSTAIRS" ...and so on;
 
7) Next step is separate elements in odd and even position

 odd: "1"  "2" ...
 even: "WALKING"  "WALKING_UPSTAIRS" ...

8) then, we construct a table (activity_table) with two columns: odd and even

    "1"    "WALKING"
    "2"    "WALKING_UPSTAIRS"  
     ...   

9) Using the same procedure above, we read file “features.txt” 
 and construct a table (coltable) associating columns number and variable´s name, like this:

         1  	tBodyAcc-mean()-X
         2  	tBodyAcc-mean()-Y
         3  	tBodyAcc-mean()-Z
         4  	tBodyAcc-std()-X
         5  	tBodyAcc-std()-Y
         ...


10) Select from coltable the rows where the string 
 in second column has the term "-mean()" (using regex);

11) the same with the term "-std";

12) then, select from coltable the rows where 
 second column have the term "-mean" or "-std";

         ...
         45         tGravityAcc-std()-Y
         46         tGravityAcc-std()-Z
         81       tBodyAccJerk-mean()-X
         82       tBodyAccJerk-mean()-Y
         ...
        

13) Select from table xg (xg = X_test join X_train)
 the columns where label contains the term "-mean" or "-std"
 (STEP 2 of Project requirements);

14) Put the labels in these selected columns;

15) Put labels in columns subject and id_activity;

16) Add columns subject and id_activity;

17) To obtain the tidy data, it´s necessary associate the id_activity to name_activity.
We can do this, merging activity_table (see above) and tidy table (STEP 4);

18) To satisfy the STEP 5, we aggregate tidy data table by the columns
 subject and activity, calculating the mean value of aggregated elements;

19) Delete repeated and unnecessary columns;

20) Rename the labels adding the term "avg" before the original variable name;

21) Order the final tidy table by column subject;

22) Finally, export tidy data set to file "project.txt".