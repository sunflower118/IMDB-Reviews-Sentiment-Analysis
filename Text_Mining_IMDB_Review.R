#install.packages("readtext")
library(readtext)
#install.packages("tidyverse")
library(tidyverse)

### Original Dataset Please Download Here
# https://ai.stanford.edu/~amaas/data/sentiment/




### Import a few of .txt files in a folder --> Code: list.files()
train_neg <- list.files("C:/Users/jinru/Desktop/R/Project  Text Mining/Dataset_IMBD_Review/train/neg")
#return file names contained in the list of each FOILDER 
train_neg


### Task 1: read one .txt file content and print one ---> Code: For Loop & readChar() ---> return each .txt file content as a string

##  Error1: how to read text content not file name?
##  Thought: the values in "Train_Neg" are file names,For loop i is referred to file name only, thus mess up the reading content.
##  Solution: full file location needed to locate the file and paste i
for (i in train_neg) {
  #train_neg_text <- read.table(paste("C:/Users/jinru/Desktop/R/Project  Text Mining/Dataset_IMBD_Review/train/neg/", i, sep = ""),sep = "") 
  #train_neg_text <- readLines(paste("C:/Users/jinru/Desktop/R/Project  Text Mining/Dataset_IMBD_Review/train/neg/", i, sep = ""),encoding = "UTF-8") #字符设置 全球大部分的文字都可以被读出
  #train_neg_text <- readtext(paste("C:/Users/jinru/Desktop/R/Project  Text Mining/Dataset_IMBD_Review/train/neg/", i, sep = ""))
  train_neg_text <- readChar(paste("C:/Users/jinru/Desktop/R/Project  Text Mining/Dataset_IMBD_Review/train/neg/", i, sep = ""), nchars = 500000) # 是赋值回TRAIN_NEG_TEXT 并不是APPEND SAVE COMPUTER SPACE
  #nchars= maxium read how many letters included spaces, symbols
  #print(train_neg_text) Error1: PRINT i = each .txt file and return all .txt files  ---> Print inside foor loop: return all.looped values
}
#PRINT outside the loop: 因为是赋值， the last text file content 覆盖 the previous text file content, return only one 文本  


# read.table: output dataframe --> Transform each raw word to the CELL in DF format,but 标点符号跟着前一个单词变成一个CELL，还有像<br\>这种无效信息 也变成了一个CELL.
# readLine: output strings ---> 把 each file content 变成了一条STRING， 组成了由多个STRINGS构成的LIST.  
# readtext: output dataframe include [1] file name [2] the content in that file  ---> 未知如何读取的文本.
# readChar: output strings  ---> 直接输出所有文本AS STRING,组成一个LIST ---> 直接读取每一个RAW DATA



### Task2: remove 文本中无意义的标点符号 ---> code: gsub()
for (i in train_neg) {
  train_neg_text <- readChar(paste("C:/Users/jinru/Desktop/R/Project  Text Mining/Dataset_IMBD_Review/train/neg/", i, sep = ""), nchars = 500000) 
  train_neg_text <- gsub("[^[:alnum:]]", " ", train_neg_text) #gsub("pattern", "replacement", X=>string, string vector, ignore.case=T)
  # ^Alphanumeric: Any character except Alphanumeric                                                                    case_sensitive  
  # Error: <br> 字符没有意义  ---> Fixed: code gsub()
  train_neg_text <- gsub(" br ", "", train_neg_text)
  # Error: multiple spaces 没有语义 ---> Fixed: code gsub()
  #train_neg_text1 <- gsub("  ", " ", train_neg_text)
  #train_neg_text2 <- gsub("  ", " ", train_neg_text1)
  #train_neg_text3 <- gsub("  ", " ", train_neg_text2)
}
head(train_neg_split, 100)

# Error: 无法保证清除了没有语义或分割作用的SPACE 
### Thought1: For Loop to remove out
### Error: j 没有定位到EACH WORD 并且TRAIN_NEG_TEXT 只有最后一个文本
#for (j in train_neg_text) { 
#  print(j)}   
#for (j in train_neg_text) {
#  if (j == "  " |j == "    " | j == "   " | j == "     ") {
#    j <- " "
#  }
#}


### Correct Answer ---> str_split()
### Thought2: str_split(data, split by 一个或多个空格)
#strsplit(train_neg_text, split = "\\s+")
#Tip: 以上代码要写进FOR 循环里 


###  Task3: need keep  It's ,   We're ---> Code: gsub(\') 保留特殊字符'.
for (i in train_neg) {
  train_neg_text <- readChar(paste("C:/Users/jinru/Desktop/R/Project  Text Mining/Dataset_IMBD_Review/train/neg/", i, sep = ""), nchars = 500000) 
  train_neg_text <- gsub("[^[:alnum:]]", " ", train_neg_text) 
  train_neg_text <- gsub(" br ", "", train_neg_text)
  train_neg_text <- gsub("[^[:alnum:]\']", " ", train_neg_text) 
  train_neg_split <- str_split(train_neg_text, "\\s+", simplify = TRUE, n = 500)
}
head(train_neg_split, 100)



### Task4: each String splited by one word and return a data frame: preset: predefined length i.e 500 and tex padding 
#train_neg_split <- str_split(train_neg_text, "\\s+", simplify = TRUE, n = 500)
#Tip: 以上代码要写进FOR 循环里 


### Task5: 所有小的DATAFRAME组成大的DATAFRAME
#Error1: lack 初始化
train_neg_df <- NULL

for (i in train_neg) {
  train_neg_text <- readChar(paste("C:/Users/jinru/Desktop/R/Project  Text Mining/Dataset_IMBD_Review/train/neg/", i, sep = ""), nchars = 500000) 
  train_neg_text <- gsub("[^[:alnum:]]", " ", train_neg_text) 
  train_neg_text <- gsub(" br ", "", train_neg_text)
  train_neg_text <- gsub("[^[:alnum:]\']", " ", train_neg_text) 
  train_neg_split <- str_split(train_neg_text, "\\s+", simplify = TRUE, n = 500)   #return i = 1.txt ---> return content strings in 1.txt ---> return cleansed one 1.txt ---> RETURN SPLITTED TEXT 1DF 
  train_neg_df <- rbind(as.data.frame(train_neg_df), train_neg_split) #1DF BIND 2DF
  
  if((which(i == train_neg))/length(train_neg)  * 100 %% 5 == 0){ #which() return index --> i: 文件名, 文件名在TRAIN_NEG LIST里面的第几个
    print(paste(as.character(round(which(i == train_neg)/length(train_neg)  * 100 )), '% is completed.'))
  }
}
head(train_neg_df, 1)

#Thought: padding special value such as "pad"
train_neg_df[train_neg_df == ""] ="*pad*"
head(train_neg_df, 1)
dim(train_neg_df)

### Task6: 
# Tokenization, 把一个个单词转化成数字，注意存储
# 3:a， 4:the, 5:and （0专门用来pad， 1，2 作为备用字符）
# 建议： 3->出现次数最多的单词， 4->出现第二多的单词。。。

dictionary_vector<-unique(train_neg_df)
for (i in 1:length(train_neg_df)) {
  
}





########### ---------------------------------  Logistic Regression  ------------------------------------------------------------ 

##合并数据集

#list.files() ---> 链接：是直接打开文件夹的地址，获取的是文件夹下所有文件名
train_neg <- list.files("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/train/neg/")
train_pos <- list.files("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/train/pos/")
test_neg <- list.files("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/test/neg/")
test_pos <- list.files("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/test/pos/")

#paste() --> 链接：是直接定位单个文件名本身，获取的是a list of 文件名的路径
train_neg_full <- paste("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/train/neg/",train_neg, sep = "")
train_pos_full <- paste("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/train/pos/",train_pos, sep = "")
test_neg_full <- paste("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/test/neg/",test_neg, sep = "")
test_pos_full <- paste("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/test/pos/",test_pos, sep = "")

length(train_neg)
length(train_pos)
length(test_neg)
length(test_pos)

Y1 <- rep(0,length(train_neg))
Y2 <- rep(1,length(train_pos))
Y3 <- rep(0,length(test_neg))
Y4 <- rep(1,length(test_pos))

Y <- append(append(append(Y1,Y2),Y3),Y4) # the vector 

full_list_fileName <- append(append(append(train_neg_full, train_pos_full), test_neg_full), test_pos_full) # the vector


#readChar() --> 链接：是直接定位到单一文件名下的CONTENT, 将一个CONTENT（一句MOVIE 评语）变成一个STRING，获取的是 a list of contents.
full_list_content <- NULL
library(svMisc) # package: progress() function 

for (i in full_list_fileName) {
  
  start.time <- Sys.time()
  full_text <- readChar(i, nchars = 500000) 
  
  full_text <- gsub("[^[:alnum:]]", " ", full_text) #[^ab]: any character except a,b --> replace 非“大小写英文26个字母组成的单词”以及“数字”，with “空格" 
  full_text <- gsub(" br ", "", full_text) #remove <br>
  full_text <- gsub("[^[:alnum:]\']", " ", full_text) #find 分号 back  
  full_split <- str_split(full_text, "\\s+", simplify = TRUE, n = 500)#deal extra spaces    
  #return i = 1.txt ---> return content strings in 1.txt ---> return cleansed one 1.txt ---> RETURN SPLITTED TEXT 1.DF 
  
  full_list_content <- rbind(as.data.frame(full_list_content), full_split)#combine 1.df with 2.df...依次循环 
  
  progress(which(i == full_list_fileName),max.value = length(full_list_fileName),progress.bar = TRUE)
  #progress(numeric value, max.value, progress.bar = T)  
  #which() forces i(文件夹路径+文件名) to numeric value
}
head(full_list_fileName, 1)

dim(full_list_fileName)

## -----------------------------------  Bug Identification ----------------------------------------------------------------
#Error: progress runs too slow for finalized r-binding contents
#思路: 越到后面，之前bind files 越大，速度越慢
#      分流再结合 大数据：分布式计算

#step1: 设置5个
full_list_content_1<- NULL
full_list_content_2<- NULL
full_list_content_3<- NULL
full_list_content_4<- NULL
full_list_content_5<- NULL
#step2: 如何 full_list_content_1, full_list_content_2, full_list_content_3, full_list_content_4,full_list_content_5
#                    1-->1              2-->2             3 --> 3             4 --> 4             5  --> 5 
#                    6-->1              7-->2             8 --> 8             9 --> 9             10 --> 10
#        方法： 求余数 %%
for (i in 1:100) {
  print(i %% 5)
}

#       set a new variable k as 计数器 计算循环了多少次 并用K除以5得余数

#step3:  new functions: Sys.time() 当前时间
start_time = Sys.time()

for (i in 1:1000000){
  p <- 1
  p = p + 1
}

end_time = Sys.time()
end_time - start_time

------------------------------------------------------------------------------------------------------------------------
  install.packages("svMisc")
library(svMisc)
install.packages("tidyverse")
library(tidyverse)
install.packages("stringr")
library(stringr)

full_list_content <- NULL
k = 0
for (i in full_list_fileName) { #i: return a string - the location of each file name
  
  start.time <- Sys.time()
  full_text <- readChar(i, nchars = 500000) 
  
  full_text <- gsub("[^[:alnum:]]", " ", full_text) 
  full_text <- gsub(" br ", "", full_text)
  full_text <- gsub("[^[:alnum:]\']", " ", full_text) 
  full_split <- str_split(full_text, "\\s+", simplify = TRUE, n = 500)   

  
  #full_list_content <- rbind(as.data.frame(full_list_content), full_split)  换成新思路
  end.time <- Sys.time()
  time.taken <- end.time - start.time
  k = k + 1
  print(paste("Item", k, " process time: ",time.taken))
}
head(full_list_fileName, 1)

#step4: How to match Y 
Y <- append(append(append(Y1,Y2),Y3),Y4)
Y_1 <- NULL
Y_2 <- NULL
Y_3 <- NULL
Y_4 <- NULL
Y_5 <- NULL


for (i in 0:(length(Y)-1)) { 
  
  
  # full_list_content <- rbind(as.data.frame(full_list_content), full_split)
  if (i%%5==0) {
    Y_1 <- c(Y_1, Y[i])
    
  }
  
  if (i%%5==1) {
    Y_2 <- c(Y_2, Y[i])
    
  } 
  
  if (i%%5==2) {
    Y_3 <- c(Y_3, Y[i])
    
  } 
  
  if (i%%5==3) {
    Y_4 <- c(Y_4, Y[i])
    
  } 
  
  if (i%%5==4) {
    Y_5 <- c(Y_5, Y[i])
    
  } 
  
} 



### --------------------- 思路：中间完成步骤 ----------------------------------------------------------
Y <- append(append(append(Y1,Y2),Y3),Y4)
Y_1 <- NULL
Y_2 <- NULL
Y_3 <- NULL
Y_4 <- NULL
Y_5 <- NULL

full_list_content_1<- NULL
full_list_content_2<- NULL
full_list_content_3<- NULL
full_list_content_4<- NULL
full_list_content_5<- NULL

k = 0 
for (i in full_list_fileName) { 
  
  start.time <- Sys.time()
  full_text <- readChar(i, nchars = 500000) 
  full_text <- gsub("[^[:alnum:]]", " ", full_text) 
  full_text <- gsub(" br ", "", full_text)
  full_text <- gsub("[^[:alnum:]\']", " ", full_text) 
  full_split <- str_split(full_text, "\\s+", simplify = TRUE, n = 500)   #return i = 1.txt ---> return content strings in 1.txt ---> return cleansed one 1.txt ---> RETURN SPLITTED TEXT 1.DF 
  
  # full_list_content <- rbind(as.data.frame(full_list_content), full_split)
  if (k%%5==0) {
    full_list_content_1 <- rbind(as.data.frame(full_list_content_1), full_split)
    Y_1 <- c(Y_1, Y[k+1])
  }
  
  if (k%%5==1) {
    full_list_content_2 <- rbind(as.data.frame(full_list_content_2), full_split)
    Y_2 <- c(Y_2, Y[k+1])
  }
  
  if (k%%5==2) {
    full_list_content_3 <- rbind(as.data.frame(full_list_content_3), full_split)
    Y_3 <- c(Y_3, Y[k+1])
  }
  
  if (k%%5==3) {
    full_list_content_4 <- rbind(as.data.frame(full_list_content_4), full_split)
    Y_4 <- c(Y_4, Y[k+1])
  }
  
  if (k%%5==4) {
    full_list_content_5 <- rbind(as.data.frame(full_list_content_5), full_split)
    Y_5 <- c(Y_5, Y[k+1])
  }
  
  
  end.time <- Sys.time()
  time.taken <- end.time - start.time
  k = k + 1  
  print(paste("Item", k, " process time: ",time.taken))
}

#Thought: padding special value such as "pad"
full_list_content_1[full_list_content_1 == ""] ="*pad*"
head(full_list_content_1, 1)
dim(full_list_content_1)



full_list_content_2[full_list_content_2 == ""] ="*pad*"
head(full_list_content_2, 1)
dim(full_list_content_2)


full_list_content_3[full_list_content_3 == ""] ="*pad*"
head(full_list_content_3, 1)
dim(full_list_content_3)



full_list_content_4[full_list_content_4 == ""] ="*pad*"
head(full_list_content_4, 1)
dim(full_list_content_4)


full_list_content_5[full_list_content_5 == ""] ="*pad*"
head(full_list_content_5, 1)
dim(full_list_content_5)

##################################################### Final Version #############################################################

##合并数据集
library(tidyverse)
library(stringr)
train_neg <- list.files("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/train/neg/")
train_pos <- list.files("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/train/pos/")
test_neg <- list.files("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/test/neg/")
test_pos <- list.files("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/test/pos/")


train_neg_full <- paste("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/train/neg/",train_neg, sep = "")
train_pos_full <- paste("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/train/pos/",train_pos, sep = "")
test_neg_full <- paste("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/test/neg/",test_neg, sep = "")
test_pos_full <- paste("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/test/pos/",test_pos, sep = "")

length(train_neg)
length(train_pos)
length(test_neg)
length(test_pos)

Y1 <- rep(0,length(train_neg))
Y2 <- rep(1,length(train_pos))
Y3 <- rep(0,length(test_neg))
Y4 <- rep(1,length(test_pos))

Y <- c(Y1,Y2,Y3,Y4)

# c() bind each vector of file name 
full_list_fileName <- c(train_neg_full, train_pos_full,test_neg_full,test_pos_full)

# 将FULL_LIST_CONTENT_FILE分成200份， 也将Y分成200份
# assign() 将字符串转换成变量，并存值进去
# get() 将字符串转换成变量，取得变量里面的值

#Error: 有单条电影评论超过规定的500字符限制，所以输出的数据集最后一个COLUMN 存储了剩下的所有单词字符。
#Solution: 将STR_SPLIT（）设成N=501， 最后删掉最后一个COLUMN。
#备注：丢失一部分信息，但在电脑能力范围之内。

#循环：当每次循环输出的是每一行，即N=1。 R会GUESS这是VECTOR，自动降级。所以会把COLUMNS名字换了导致问题。
#Solution: full_split[ ,1:500,drop=F]
m = 200
for (i in 1:m){                    
  assign(paste("full_list_content_", i, sep = ""), NULL)
  assign(paste("Y_", i, sep = ""), c())
}

k = 0   
for (i in full_list_fileName) { #full_list_fileName has 50000 items, return i as value as each file name
  
  start.time <- Sys.time()
  
  full_text <- readChar(i, nchars = 500000) 
  full_text <- iconv(full_text, 'UTF-8', 'ASCII',sub = " ") #原来UTF-8的编码改成ASCII(英文编码)
  full_text <- gsub("[^[:alnum:]\']", " ", full_text) 
  full_text <- gsub("br ", "", full_text)
  full_split <- str_split(full_text, "\\s+", simplify = TRUE, n = 501) 
  full_split <- full_split[ ,1:500,drop=F]
  full_split <- tolower(full_split)
  
  assign(paste("full_list_content_", k%%m + 1, sep = ""), 
         rbind(as.data.frame(get(paste("full_list_content_", k%%m + 1, sep = ""))), full_split)) 
  #rbind() 是为了GET()到变量FULL_LIST_CONTENT_M里面储存的FULL_SPLIT值
  #assign() 是为了把FULL_LIST_CONTENT_M 从STRING变为一个可以储存值的变量，相当于full_list_content_k%%m+1 <- rbind(full_list_content_k%%m+1, full_split)
  
  assign(paste("Y_", k%%m + 1, sep = ""),
         c(get(paste("Y_", k%%m + 1, sep = "")), Y[k+1]))
  
  end.time <- Sys.time()
  time.taken <- end.time - start.time
  k = k + 1
  print(paste("Item",k, " process time : ",time.taken))
  
}

full_list_content <- NULL
Y = c()
for (i in 1:m){
  start.time <- Sys.time()
  
  full_list_content <- rbind(full_list_content,get(paste("full_list_content_", i, sep = ""))) #data frame
  Y <- c(Y, get(paste("Y_", i, sep = ""))) #vector
  end.time <- Sys.time()
  time.taken <- end.time - start.time
  print(paste("batch",i, " append time : ",time.taken))
}

full_list_content[1,]
Y[1]

#Y 加入 full_list_content
full_list_content$Y = Y

#读出数据
write.csv(full_list_content, "C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/imdb_data.csv")


############################################################## END ##########################################################


## Data Cleanse 

full_list_content_df <- read.csv("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/imdb_data.csv")
head(full_list_content_df)

full_list_content_df <- full_list_content_df[ ,-1]
head(full_list_content_df)
dim(full_list_content_df)
#501*50000 matrix ---> 501 features included Y exclude the last feature potentialy contain more than one word

# Task 2-1: 根据当个单词出现的次数排名
# Error: 大写的Web 和小写的web 认成两个单词
# Solution: tolower(full_split)


#思路1.1: 先算每列UNIQUE的单词（50，000 ），再RBIND()50列组成50，000*50 行的DICTIONARY VECTOR；
#思路1.2：先算每行UNIQUE的单词（50 ），再RBIND() 50,000行组成50，000*50 行的DICTIONARY VECTOR。
#问题：如何排除下一行与上一行重复的单词
#问题：分开写两套循环，FOR VECTOR OF UNIQUE WORDS AND VECTOR OF COUNT
#问题：写成一套循环，因为用WHICH()需要涉及到MATCHED INDEX FOR BOTH VECTORS
#问题：如何将定位到第一个单词算出的COUNT_NUMBER加入到COUNT_WORDS， 活用INDEX 
#问题：if()条件判断语句输出结果是逻辑判断TRUE OR FALSE 结果， WHICH()函数并不是输出逻辑判断
#思路2：走一遍所有CELL，最终组成前100名出现最多单词的DICTIONARY


#计算循环花费时间：嵌套循环中，计算每层循环花费时间 - 最里面的循环每次花费时间 = 第一层循环N * 内套第二层循环M * 内套第三层循环J，依次内推。
#当要放START-TIME位置时，需要考虑1）总输出每轮循环花费时间的次数（N*M*J次或N*M次或N次）2）财经数据20年的数据，则三层循环是20*12*30（到天数)。
#如果循环不是线性走，而是每层循环越来越慢，则需要放计时器。在写代码的时候，提前思考是不是有可能越来越慢。通过别的方法避免，比如减少循环次数。多用向量化或矩阵计算。

# ----------------------------------------Method1: For Loop-------------------------------------------------------------

#for (m in 1:dim(full_list_content_df)[1]){
#  assign(paste("unique_column_row", m, sep = ""), sort(unique(full_list_content_df[m,])))
#  assign(paste("data_v", m, sep = ""), as.data.frame(get(paste(full_list_content_df[,]))))
#}


#full_list_content_df1 <- full_list_content_df[ , -51]

#下面的代码不适合分而治之，因为uniqList_words_byRow并不是恒定的，也是随着FOR 循环一起增长的，无法保证UNIQUE。
uniqList_words_byRow <- c()
count_words <- c()
#count = 0
for (j in 1:dim(full_list_content_df)[1]){
  start.time <- Sys.time()
  for (k in 1:dim(full_list_content_df)[2]){
    if(!(full_list_content_df[j,k] %in% uniqList_words_byRow)){
      uniqList_words_byRow <- c(uniqList_words_byRow, full_list_content_df[j,k])
      count_words <- c(count_words, 0)
    } 
    for (i in 1:length(uniqList_words_byRow)) {
      if (full_list_content_df[j,k] == uniqList_words_byRow[i]) {
        count_words[i] <- count_words[i] + 1
      }
    }
  }
  end.time <- Sys.time()
  time.taken <- end.time - start.time
  print(paste("Loop",j, " append time : ",time.taken))
}

print(uniqList_words_byRow)
print(count_words)


#----------------------------------Alternative version 1 -----------------------------------------
#Note: 当运算越来越慢的时候，考虑涉分布式计算，涉及到分布计算时程序写得越简单越好，方便最终合并。
#Solution: C() 会导致越到后面越慢，则将WORDS VECTOR 切分成无数份，每一份进原数据里面循环。

words = unique(as.vector(as.matrix(full_list_content_df[,1:500])))
count = c()
for (i in 1:length(words)){
  count = c(count, sum(full_list_content_df[,1:500]==words[i]))  
  progress(i,max.value = length(words),progress.bar = TRUE)
  print(i)
}

words[1:50]
count[1:50]


#----------------------------------Alternative version 2 ------------------------
#table(): parameter - dataset must be the matrix 
dict <- table(as.matrix(full_list_content_df[,1:500]))
dict <- as.data.frame(dict)
dict <- dict[order(dict$Freq, decreasing = TRUE),]
dim(dict)
#117937 2




#Data Structure Understanding:
#vector1 [i is vector's index]     Vector2 [i is vector's index]
#1  count [i1] = [j1,k1]             0  
#2
#3
#4
#5 


#df [j=1,k=1 are df's index]
#1[j1,k1] 2 3 4 5 ....
#52 ...





#------------------------------------Method2: Tidyverse ------------------------------------------------------------------------




#-----------------------------------------------Task1 END---------------------------------------------------------------------------


#Task2-2: Dictionary-Frequency Table Final Output
#  Change column names/ rearrange index 
#  Delete non-meaningful words via Frequency:
#     对于模型来讲，是针对单词出现的量大来让电脑有效判断。对于人来讲，单词量出现巨多的情况下，需要人为判断单词有没有意义。
#  Add a row named UnknowWords 

head(dict, 20)
class(dict)
dim(dict) #117937 2

# line chart
#Method1:
slice_df <- dict_df[8000:10000,]
ggplot(slice_df1, aes(x=Index, y = Count)) + geom_point() 
#Result: index 10000 以后的 COUNT <= 55 数量不足
#Result: Delete index first 12 -> meaningless words 


#Method2: dynamic method
for (i in 2:10) {
  print(i %% 5)
}

library(ggplot2)
for (i in 1:nrow(dict)) {
  if (i %% 10000 == 0) {
    ggplot(dict_df, aes(x=rownames(dict)[1:i], y = Count)) + geom_point() 
  }
}

#--------------------------Chart End-----------------------------------------------------


#Task2-1: Tokenlization
#Dictionary_ready
#Rule of Thumb: 
#    token 1~10 reserved for the placeholder
#    UNK is occupied in the placeholder
#    Special meaningful words (rare but meaningful tailored for the specific dataset)
#    Tip: When UNK occurred most frequently, it is calculated efficiently to be placed at token #1. 



rownames(dict) <- 1:nrow(dict)
head(dict)

a<-dim(dict)[1]
head(a)
dictionary_ready <- dict[c(-10000:-a), ]
tail(dictionary_ready)

dictionary_ready<-dictionary_ready[c(-1:-12), ]
head(dictionary_ready)




rownames(dictionary_ready) <- 1:nrow(dictionary_ready)
head(dictionary_ready)
dim(dictionary_ready) #9987 2


n <- dim(dictionary_ready)[1] + 9
n

dictionary_ready<-as.data.frame(dictionary_ready)
dictionary_ready<-cbind(dictionary_ready, c(10:n))
colnames(dictionary_ready) <- c("word", "count", "token")
head(dictionary_ready, 100)

class(dictionary_ready$word) 
#error: invalid factor level -> word column set by R as factor which underneath is number -> pass a string "UNK" to the word column, which will be set as NA
dictionary_ready$word <- as.character(dictionary_ready$word)
dictionary_ready<-rbind(dictionary_ready, c("UNK", 0, 1))
dictionary_ready<-rbind(dictionary_ready, c("UNK", 0, 1))


tail(dictionary_ready)
dim(dictionary_ready) #9988  3

#读出数据
write.csv(dictionary_ready, "C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/dictionary_IMBD.csv")

#---------------------------------------------------------------------End task2-----------------------------------------------------------------

#Task2-2 Tokenlization
#Full_list_content_df1:  
#dim(Full_list_content_df1)50000 , 500   (没有了Y列，没有了最后一个超过500个单词的列， 没有了前面INDEX列)

dictionary_df <- read.csv("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/dictionary_IMBD.csv")
dictionary_df <- dictionary_df[ , -1]
dim(dictionary_df)
head(dictionary_df)


head(full_list_content_df)
dim(full_list_content_df)
#50000 501


full_list_content_df1 <- full_list_content_df [ , -501]
head(full_list_content_df1)


#Naive Thought
#Solution: 减少FOR 循环
for (i in 1:dim(dictionary_ready)[1]) {
  for (m in 1:dim(full_list_content_df1)[1]) {
    for (n in 1:dim(full_list_content_df1)[2]) {
      if (full_list_content_df1[m,n] == dictionary_ready[i,1]) {
        full_list_content_df1 <- str_replace(full_list_content_df1,full_list_content_df1[m,n],dictionary_ready[ i,3])
      } else (
        full_list_content_df1 <- str_replace(full_list_content_df1, full_list_content_df[m,n],"unknown")
      )
    }
  } 
}


# Method1: 
# How to replace third FOR loop in dictionary_df?
# Use Which() function to find which index(rownumber) for that word at and return the whole row

#error: str_replace(data, original_word, replace_by_word) 
# must be string to be replaced.


#dictionary_df[which(full_list_content_df1[i,j] == dictionary_df$word), 3]
#error: 如果中途停下CHECK后，再重新运行，则会导致 -> 因为每次循环要走ELSE{} 所以FULL_LIST_CONTENT_DF1会被改写 -> 被改写后的DF1包含1的值会再进循环
#solution: 右边用原数据集full_list_content_df[i,j]做判断，因为原数据集不会被改写



word_uniq<-dictionary_df$word

for (i in 1:dim(full_list_content_df1)[1]) {
  for (j in 1:dim(full_list_content_df1)[2]) {
    if (full_list_content_df1[i,j] %in% word_uniq){
      full_list_content_df1[i,j] <- dictionary_df[which(full_list_content_df[i,j] == dictionary_df$word), 3]
    } else {
      full_list_content_df1[i,j]<- 1
    }
  }
  print(i)
}

head(full_list_content_df1)

#读出数据
write.csv(full_list_content_df1, "C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/full_content_token_IMBD.csv")
full_content_token <- read.csv("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/full_content_token_IMBD.csv")



###################————————————————————————————————————————————END------------------------------------------------------------------------


x <- dim(dictionary_df)[1]
x
y<- dim(full_list_content_df)[1]
y

#### Task 3-1: produce specification 2's dataset structure
full_content_mtx <- matrix(rep(0,x*y), ncol = dim(dictionary_df)[1])
dim(full_content_mtx) #50000 * 9988


colnames(full_content_mtx) <-  dictionary_df$word
head(full_content_mtx)

dictionary_vector <- dictionary_df$word
dim(full_list_content_df) #50000 * 501
length(dictionary_vector) #9988 * 3

#Naive Thought:
for  (i in 1:dim(full_content_mtx)[1]) {
  for (j in 1:dim(full_content_mtx)[2]) {
    for (z in 1:dim(full_list_content_df)[2])
      current_obs = full_list_content_df[i, z]
    current_catagory = dictionary_vector[j]
    if (current_obs %in% current_catagory) {
      full_content_mtx[i,j] <- 1
    } 
  }
}
#________________________________________________________________________________________________________________

#Method 1: 
#each row as a vector in full_list_content_df


for (i in 1:dim(full_content_mtx)[1]){
  full_content_vector<-full_list_content_df[i, ]
  for (j in 1:length(full_content_vector)) {
    if (full_content_vector[j] %in% dictionary_vector) {
      m <- which(colnames(full_content_mtx) == as.character(full_content_vector[j]))
      full_content_mtx[i , m] <- 1
    }
  }
  print(i)
}


# 数据先备份，等号左边放输出（可以改的），等号右边放你的判断（不能对原数据备份）。
#i = 1  -> 50000, j=1 ->501
#full_content_vector<-full_content_list_df[1, ] (first observation)
#for (j in 1: length (vector1) ) {  if (vector1[j] %in% dictionary_vectory) { mtx[ ,which(mtx=vector1[j])] <-1} }
#a <- c(1,0,0,3,4,5)
#which(a == 3)

write.csv(full_content_mtx, "C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/full_content_mtx_IMBD.csv")


#Method 2:
full_content <- read.csv("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/imdb_data.csv")
full_content <- full_content[,-1]
dict <- read.csv("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/dictionary_IMBD.csv")
dict <- dict[ , -1]
dim(dict)[1]

output_mtx = matrix(rep(0, dim(full_content)[1] * dim(dict)[1]), nrow =  dim(full_content)[1])
dim(output_mtx)
colnames(output_mtx) = dict$word

for (i in 1:dim(output_mtx)[1]){
  sentence = full_content[i,-501]
  out_data = output_mtx[i,]
  index = match(sentence, dict$word)
  index = index[!is.na(index)]
  out_data[index] = 1
  output_mtx[i,] = out_data
  print(i)
}


#__________________________________________________________END_______________________________________________________________


#Model Application - specification 2
# 50000(rows) * 9980 (features - words from dictionary) 
full_content_mtx  <- read.csv("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/full_content_mtx_IMBD.csv")
dim(full_content_mtx) #50000 * 9989
full_content_mtx[1:10, 1:10]#Check front
full_content_mtx[1:10, 1000:1110] #Identify words as X15, X30...etc ??
full_content_mtx[49990:50000, 1:10] #Check tail
full_content_mtx[1:10, 9980:9989]

full_list_content_df <- read.csv("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/imdb_data.csv")
dim(full_list_content_df)
full_list_content_df[1:10 , 500:502]
full_content_mtx_y <- cbind(full_content_mtx, Y_Y = full_list_content_df[ , 502])
full_content_mtx_y[1:10, 9980:9990]





#Data Splitting
full_content_df <- as.data.frame(full_content_mtx_y[ , -1])
dim(full_content_df) #50000 * 9989
set.seed(12345)

training.index <- sample(1:nrow(full_content_df), 0.8*nrow(full_content_df))
length(training.index) #40000

training.dataset <- full_content_df[training.index, ]
training.dataset.x <- full_content_df[training.index, -9989]
training.dataset.y <- full_content_df[training.index, 9989]
nrow(training.dataset.x)#40000

rest.data <- full_content_df[-training.index, ]

#sample()：逻辑上讲，是在拿数据抽样，return数据，但这里是在用数据的index抽#样 所以as.numeric(rownames()): as.numeric("string") 
validation.index <- sample(as.numeric(rownames(rest.data)), 0.5*nrow(rest.data))
length(validation.index) #5000

validation.dataset <- full_content_df[validation.index, ]
validation.dataset.x <- full_content_df[validation.index, -9989]
validation.dataset.y <- full_content_df[validation.index, 9989]


test.dataset.x <- full_content_df[-c(validation.index, training.index), -9989]
test.dataset.y <- full_content_df[-c(validation.index, training.index), 9989]
nrow(test.dataset.x) #5000







##__________________________________________________________Logistic regression (Specification 2)

#Base Line

fit.logistic <-glm(Y_Y~., family=binomial(link="logit"), data = training.dataset) 
summary(fit.logistic)
model_summary <- summary(fit.logistic)
model_summary

model_summary_co <- model_summary$coefficients
write.csv(model_summary_co, "C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/model_summary_co.csv")

prediction_logistic_t <- predict(fit.logistic, training.dataset.x, type="response")
prediction_stats_t <- ifelse(prediction_logistic_t >0.5, 1, 0)
head(prediction_stats_t)
train_accuracy <- sum(prediction_stats_t == training.dataset.y) / length(prediction_stats_t)
train_accuracy#1



prediction_logistic_v <- predict(fit.logistic, validation.dataset.x, type="response")
prediction_stats_v <- ifelse(prediction_logistic_v >0.5, 1, 0)
head(prediction_stats_v)
valid_accuracy <- sum(prediction_stats_v == validation.dataset.y) / length(prediction_stats_v)
valid_accuracy#0.9984


prediction_logistic <- predict(fit.logistic, test.dataset.x, type="response")
prediction_stats <- ifelse(prediction_logistic >0.5, 1, 0)
head(prediction_stats)
prediction_accuracy <- sum(prediction_stats == test.dataset.y) / length(prediction_stats)
prediction_accuracy #0.9988

## Case1: Overfitting due to the larger number of features and comparitive smaller number of observations (trainning dataset: 40000 * 9989)
## Case1 result: Training datset 100% accuracy rate but will do poorly in testing dataset.


## Case2: data splitting

## Case3: Multicolinearity 
## Case3 solution: cor()test
cor(training.dataset.x)

## Case4: the data cleansing and transformation suits best to the logistic regression
## Model: 直观上不能SUPPORT逻辑CHECK， MODEL SUMMARY 没有一个FEATURE是SIGNIFICANT， COEFFICIENTS偏高更倾向于正面的单词，COEFFICIENTS偏低更倾向于负面的单词

#---------------------------------------------------------------------------------------------------------------------------------------------------------------


## Logistic Regresssion (Specification 1)
#Base Line 

full_content_token <- read.csv("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/full_content_token_IMBD.csv")
full_content_token[1:10, 1:10]
full_content_token <- full_content_token[ ,-1]
dim(full_content_token)
full_content_token[1:10, 499:500]


full_list_content_df <- read.csv("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/imdb_data.csv")
dim(full_list_content_df)
full_list_content_df[ 1:6, 500:502]


full_content_token_withY <- cbind(full_content_token, Y_Y = full_list_content_df[ , 502])
full_content_token_withY[1:6, 490:501]


set.seed(12345)

training.index <- sample(1:nrow(full_content_token_withY), 0.8*nrow(full_content_token_withY))
length(training.index) #40000

training.dataset <- full_content_token_withY[training.index, ]
training.dataset.x <- full_content_token_withY[training.index, -501]
training.dataset.y <- full_content_token_withY[training.index, 501]
nrow(training.dataset.x)#40000

rest.data <- full_content_token_withY[-training.index, ]

#sample()：逻辑上讲，是在拿数据抽样，return数据，但这里是在用数据的index抽#样 所以as.numeric(rownames()): as.numeric("string") 
validation.index <- sample(as.numeric(rownames(rest.data)), 0.5*nrow(rest.data))
length(validation.index) #5000

validation.dataset <- full_content_token_withY[validation.index, ]
validation.dataset.x <- full_content_token_withY[validation.index, -501]
validation.dataset.y <- full_content_token_withY[validation.index, 501]


test.dataset.x <- full_content_token_withY[-c(validation.index, training.index), -501]
test.dataset.y <- full_content_token_withY[-c(validation.index, training.index), 501]
nrow(test.dataset.x) #5000





fit.logistic1 <-glm(Y_Y~., family=binomial(link="logit"), data = training.dataset) 
summary(fit.logistic1)
model_summary1 <- summary(fit.logistic1)
model_summary1

model_summary_co1 <- model_summary1$coefficients
write.csv(model_summary_co1, "C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/model_summary_co1.csv")


prediction_logistic_t <- predict(fit.logistic1, training.dataset.x, type="response")
prediction_stats_t <- ifelse(prediction_logistic_t >0.5, 1, 0)
head(prediction_stats_t)
train_accuracy <- sum(prediction_stats_t == training.dataset.y) / length(prediction_stats_t)
train_accuracy#0.55



prediction_logistic_v <- predict(fit.logistic1, validation.dataset.x, type="response")
prediction_stats_v <- ifelse(prediction_logistic_v >0.5, 1, 0)
head(prediction_stats_v)
valid_accuracy <- sum(prediction_stats_v == validation.dataset.y) / length(prediction_stats_v)
valid_accuracy#0.517


prediction_logistic <- predict(fit.logistic1, test.dataset.x, type="response")
prediction_stats <- ifelse(prediction_logistic >0.5, 1, 0)
head(prediction_stats)
prediction_accuracy <- sum(prediction_stats == test.dataset.y) / length(prediction_stats)
prediction_accuracy #0.519






##___________________________________________________________Logistic regression + Lasso/Ridge (Specification2)
#in this datatset: tunning parameters lambdas for 100 times. It is time comsuming for specification 2. 

install.packages("glmnet")
library(glmnet)

training.mtx.x <- as.matrix(training.dataset.x)
training.mtx.y <- training.dataset.y


lambdas <- 10^seq(2,-3, -0.1) 

ridge_reg <- glmnet(training.mtx.x, training.mtx.y, alpha= 0, family = "binomial", lambda = lambdas)# 100LAMBDAS build 100 models 
cv_ridge <- cv.glmnet(training.mtx.x, training.mtx.y, alpha = 0, lambda = lambdas) #  cv. find the best lambda
optimal.lambda <- cv_ridge$lambda.min
optimal.lambda

ridge_reg_model <- predict(ridge_reg, newx=training.mtx.x, s=optimal.lambda) #Use the model with the best lambda to predict
train_prob <- ifelse(ridge_reg_model> 0.5, 1, 0)
accuracy_train <- sum(train_prob == trainning.dataset.y) / length(trainning.dataset.y)


test.mtx.x <- as.matrix(test.dataset.x)
prediction_ridge <- predict(ridge_reg_model,newx=test.mtx.x, s=optimal.lambda)
test.prob <- ifelse(prediction_ridge>0.5, 1, 0)
accuracy_test <- sum(test.prob == test.dataset.y) / length(test.dataset.y)


lasso_reg <- glmnet(training.mtx.x, training.mtx.y, alpha = 1, family = "binomial", lambda = lambdas)
cv_lasso <- cv.glmnet(training.mtx.x, training.mtx.y, alpha = 1, family = "binomial", lambda = lambdas)
lambda_best <- cv_lasso$lambda.min
lambda_best

lasso_reg_model <- predict(lasso_reg, trainning.mtx.y, alpha = 1, family = "binomial", lambda = lambda_best)
train_prob <- ifelse(lasso_reg_model> 0.5, 1, 0)
accuracy_train <- sum(train_prob == trainning.datset.y) / length(training.dataset.y)

prediction_lasso <- predict(lasso_reg_model, newx = test.mtx.x, s=lambda_best)
test.prob <- ifselse(prediction_lasso>0.5, 1, 0)
accuracy_test <- sum(test.prob == test.dataset.y) / length(test.dataset.y)




##____________________________________Logistic regression + LASSO/RIDGE (Specification1)

#Improt data.x
full_content_token <- read.csv("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/full_content_token_IMBD.csv")
full_content_token[1:10, 1:10]
full_content_token <- full_content_token[ ,-1]
dim(full_content_token) #50000 * 500
full_content_token[1:10, 499:500]
#Import data.y
full_list_content_df <- read.csv("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/imdb_data.csv")
dim(full_list_content_df)
full_list_content_df[ 1:6, 500:502]
#combination specification1.data
full_content_token_withY <- cbind(full_content_token, Y_Y = full_list_content_df[ , 502])
full_content_token_withY[1:6, 490:501]


set.seed(12345)

training.index <- sample(1:nrow(full_content_token_withY), 0.8*nrow(full_content_token_withY))
length(training.index) #40000

training.dataset <- full_content_token_withY[training.index, ]
training.dataset.x <- full_content_token_withY[training.index, -501]
training.dataset.y <- full_content_token_withY[training.index, 501]
dim(training.dataset.x)#40000

rest.data <- full_content_token_withY[-training.index, ]

#sample()：逻辑上讲，是在拿数据抽样，return数据，但这里是在用数据的index抽#样 所以as.numeric(rownames()): as.numeric("string") 
validation.index <- sample(as.numeric(rownames(rest.data)), 0.5*nrow(rest.data))

length(validation.index) #5000

validation.dataset <- full_content_token_withY[validation.index, ]
validation.dataset.x <- full_content_token_withY[validation.index, -501]
validation.dataset.y <- full_content_token_withY[validation.index, 501]
dim(validation.dataset.x)

test.dataset.x <- full_content_token_withY[-c(validation.index,training.index), -501]
test.dataset.y <- full_content_token_withY[-c(validation.index,training.index), 501]
dim(test.dataset.x) #5000

#install.packages("glmnet")
library(glmnet)

training.mtx.x <- as.matrix(training.dataset.x)
class(training.mtx.x)
dim(training.mtx.x)
length(training.dataset.y)

lambdas <- 10^seq(2,-3, -0.1) 

ridge_reg <- glmnet(training.mtx.x, training.dataset.y, alpha= 0, family = "binomial", lambda = lambdas)# 100LAMBDAS build 100 models 
cv_ridge <- cv.glmnet(training.mtx.x, training.dataset.y, alpha = 0, lambda = lambdas) #  cv. find the best lambda
optimal.lambda <- cv_ridge$lambda.min
optimal.lambda #1: model is simple

ridge_reg_model <- predict(ridge_reg, newx=training.mtx.x, s=optimal.lambda) #Use the model with the best lambda to predict
train_prob <- ifelse(ridge_reg_model> 0.5, 1, 0)
accuracy_train <- sum(train_prob == training.dataset.y) / length(training.dataset.y)
accuracy_train #0.5012

validation.mtx.x <- as.matrix(validation.dataset.x)
class(validation.mtx.x) #matrix, array
dim(validation.mtx.x)
validation.mtx.x[1:20, 1:10]
prediction_ridge_v <- predict(ridge_reg, newx = validation.mtx.x, s=optimal.lambda)
vali.prob <- ifelse(prediction_ridge_v>0.5, 1, 0)
accuracy_vali <- sum(vali.prob == validation.dataset.y) / length(validation.dataset.y)
accuracy_vali #0.4982


test.mtx.x <- as.matrix(test.dataset.x)
prediction_ridge <- predict(ridge_reg,newx=test.mtx.x, s=optimal.lambda)
test.prob <- ifelse(prediction_ridge>0.5, 1, 0)
accuracy_test <- sum(test.prob == test.dataset.y) / length(test.dataset.y)
accuracy_test #0.4988




lasso_reg <- glmnet(training.mtx.x, training.dataset.y, alpha = 1, family = "binomial", lambda = lambdas)
cv_lasso <- cv.glmnet(training.mtx.x, training.dataset.y, alpha = 1, family = "binomial", lambda = lambdas)
lambda_best <- cv_lasso$lambda.min
lambda_best #0.00398



lasso_reg_model <- predict(lasso_reg,  newx =training.mtx.x,s = lambda_best)
train_prob <- ifelse(lasso_reg_model> 0.5, 1, 0)
accuracy_train <- sum(train_prob == training.dataset.y) / length(training.dataset.y)
accuracy_train #0.5025


prediction_lasso <- predict(lasso_reg, newx = test.mtx.x, s=lambda_best)
test.prob <- ifelse(prediction_lasso>0.5, 1, 0)
accuracy_test <- sum(test.prob == test.dataset.y) / length(test.dataset.y)
accuracy_test #0.5002






## ______________________________Logistic Regression + PCA (Specification 2)
#Import data
full_content_mtx  <- read.csv("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/full_content_mtx_IMBD.csv")
dim(full_content_mtx) #50000 * 9989
full_list_content_df <- read.csv("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/imdb_data.csv")
dim(full_list_content_df)
full_content_mtx_y <- cbind(full_content_mtx, Y_Y = full_list_content_df[ , 502])
dim(full_content_mtx_y) #50000 * 9990
full_content_mtx_y[1:10, 9980:9990]
full_content_mtx_y[49990:50000, 1:10]

full_content_mtx_y <- full_content_mtx_y[ , -1]
dim(full_content_mtx_y) #50000 * 9989




#Data Splitting
set.seed(12345)

full_content_df <- full_content_mtx_y
training.index <- sample(1:nrow(full_content_df), 0.8*nrow(full_content_df))
length(training.index) #40000

training.dataset <- full_content_df[training.index, ]
training.dataset.x <- full_content_df[training.index, -9989]
training.dataset.y <- full_content_df[training.index, 9989]
nrow(training.dataset.x)#40000

rest.data <- full_content_df[-training.index, ]

#sample()：逻辑上讲，是在拿数据抽样，return数据，但这里是在用数据的index抽#样 所以as.numeric(rownames()): as.numeric("string") 
validation.index <- sample(as.numeric(rownames(rest.data)), 0.5*nrow(rest.data))
length(validation.index) #5000

validation.dataset <- full_content_df[validation.index, ]
validation.dataset.x <- full_content_df[validation.index, -9989]
validation.dataset.y <- full_content_df[validation.index, 9989]
dim(validation.dataset)

test.dataset.x <- full_content_df[-c(validation.index, training.index), -9989]
test.dataset.y <- full_content_df[-c(validation.index, training.index), 9989]
dim(test.dataset.x) #5000

#ERROR: Data Scaling (train) NO NEED FOR BINARY/DISCRETE DATASET
#training.dataset <- scale(training.dataset, center = TRUE)
#training.dataset.x <- training.dataset[ , -9989]
#training.dataset.y <- full_content_df[training.index, 9989]



##_______________________________________PCA
help(glmpca())
#install.packages("glmpca")
#library(glmpca)
#test.spc2 <- glmpca(training.dataset.x, L = 4000, fam = "binom", minibatch = "stochastic")


library(logisticPCA)
#text_cv = cv.lpca(training.dataset.x, ks = 100, ms = 1：10) 
#cv.lpca 求出最佳M
#plot(text_cv) 
#logpca_model = logisticPCA(training.dataset.x, k = 100, m = which.min(logpca_cv))


#Data visulization
#party = rownames(house_votes84)
#plot(logpca_model, type = "scores") + geom_point(aes(colour = party)) + 
#ggtitle("Logistic PCA") + scale_colour_manual(values = c("blue", "red"))

#head(fitted(logpca_model, type = "response"))  
#fitted 求出线性或者概率算法的PARAMETERS
#predict(logpca_model, new.dataset, type = "PCs")
#针对NEW.DATASET进行PCA转换



training.dataset.x <as.matrix(training.dataset.x)

logpca.model <-logisticPCA(training.dataset.x, k=10,m=4,quiet = FALSE, max_iters = 10) 
plot(logpca.model, type="trace")
pcs_train <- logpca.model$PCs
pcs_train
logpca.model$PCs[1:10,1:10] #PCs: train.dataset.x after PCA 


#Train.final.dataset.x: Principle Components X.variables deduction Observations values
pred.train.pca <- predict(logpca.model, training.dataset.x, type="PCs")
pred.train.pca

#Test.final.dataset.x
test.dataset.x <- as.matrix(test.dataset.x)
pred.test.pca <- predict(logpca.model, test.dataset.x, type = "PCs" )
pred.test.pca

#Logistic regression with PCA dataset
train.pca.full <- cbind(pred.train.pca, training.dataset.y)
train.pca.full <- as.data.frame(train.pca.full)
logistic.pca <- glm(training.dataset.y~., family = binomial(link="logit"), data = train.pca.full)
summary(logistic.pca)


pred.train.pca <- as.data.frame(pred.train.pca)
prediction_logistic_t <- predict(logistic.pca, pred.train.pca, type="response")
prediction_stats_t <- ifelse(prediction_logistic_t >0.5, 1, 0)
head(prediction_stats_t)
train_accuracy <- sum(prediction_stats_t == training.dataset.y) / length(prediction_stats_t)
train_accuracy#0.9865


pred.test.pca <- as.dta.frame(pred.test.pca)
prediction_logistic <- predict(logistic.pca, pred.test.pca, type="response")
prediction_stats <- ifelse(prediction_logistic >0.5, 1, 0)
head(prediction_stats)
prediction_accuracy <- sum(prediction_stats == test.dataset.y) / length(prediction_stats)
prediction_accuracy #0.9886




### Logistic regression + PCA (Specification1)


#Improt data.x
full_content_token <- read.csv("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/full_content_token_IMBD.csv")
full_content_token[1:10, 1:10]
full_content_token <- full_content_token[ ,-1]
dim(full_content_token) #50000 * 500
full_content_token[1:10, 499:500]

#Standardize the data.x

txt_token_scale <- scale(full_content_token, center = TRUE)
txt_token_scale[1:10, 1:10]


#Import Y
full_list_content_df <- read.csv("C:/Users/jinru/Desktop/R/Second_Project _Text Mining/Dataset_IMBD_Review/imdb_data.csv")
dim(full_list_content_df)
full_list_content_df[ 1:6, 500:502]

#Combine Specification1 data
full_content_token_Y <- cbind(txt_token_scale, Y_Y = full_list_content_df[ , 502])
full_content_token_Y[1:6, 490:501]

#Data splitting

set.seed(12345)

training.index <- sample(1:nrow(full_content_token_Y), 0.8*nrow(full_content_token_Y))
length(training.index) #40000

training.dataset <- full_content_token_Y[training.index, ]
training.dataset.x <- full_content_token_Y[training.index, -501]
training.dataset.y <- full_content_token_Y[training.index, 501]
nrow(training.dataset.x)#40000

rest.data <- full_content_token_Y[-training.index, ]

#sample()：逻辑上讲，是在拿数据抽样，return数据，但这里是在用数据的index抽#样 所以as.numeric(rownames()): as.numeric("string") 
validation.index <- sample(1:nrow(rest.data), 0.5*nrow(rest.data))
length(validation.index) #5000

validation.dataset <- full_content_token_Y[validation.index, ]
validation.dataset.x <- full_content_token_Y[validation.index, -501]
validation.dataset.y <- full_content_token_Y[validation.index, 501]


test.dataset.x <- rest.data[-validation.index, -501]
test.dataset.y <- rest.data[-validation.index, 501]
nrow(test.dataset.x) #5000

#PCA
txt.pca <- prcomp(training.dataset.x)
print(txt.pca)

summary(txt.pca)
#pcaCharts(txt.pca)

#training.data.pca
training.data.pca <- txt.pca$x[ , 1:246]
training.data.pca[1:10, 1:10]
training.data.pca<-as.data.frame(training.data.pca)

training.pca <- cbind(training.data.pca, training.dataset.y)
training.pca[1:10, 240:247]
class(training.pca)
training.pca <- as.data.frame(training.pca)

fit.logistic1 <-glm(training.dataset.y~., family=binomial(link="logit"), data = training.pca) 
summary(fit.logistic1)
model_summary1 <- summary(fit.logistic1)
model_summary1


prediction_logistic_t <- predict(fit.logistic1, training.data.pca, type="response")
prediction_stats_t <- ifelse(prediction_logistic_t >0.5, 1, 0)
head(prediction_stats_t)
train_accuracy <- sum(prediction_stats_t == training.dataset.y) / length(prediction_stats_t)
train_accuracy#0.54

#predict on validation
validation.data.pca <- as.matrix(validation.dataset.x) %*% as.matrix(txt.pca$rotation[ , 1:246])
validation.data.pca[1:10, 1:10]
validation.data.pca<-as.data.frame(validation.data.pca)

prediction_logistic_v <- predict(fit.logistic1, validation.data.pca, type="response")
prediction_stats_v <- ifelse(prediction_logistic_v >0.5, 1, 0)
head(prediction_stats_v)
valid_accuracy <- sum(prediction_stats_v == validation.dataset.y) / length(prediction_stats_v)
valid_accuracy#0.546

#predict on test

test.data.pca <- as.matrix(test.dataset.x) %*% as.matrix(txt.pca$rotation[ , 1:246])
test.data.pca <- as.data.frame(test.data.pca)

prediction_logistic <- predict(fit.logistic1, test.data.pca, type="response")
prediction_stats <- ifelse(prediction_logistic >0.5, 1, 0)
head(prediction_stats)
prediction_accuracy <- sum(prediction_stats == test.dataset.y) / length(prediction_stats)
prediction_accuracy #0.5242















#SVM









#Neural Network

































































































































































































































































