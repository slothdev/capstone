a <- merge(b.rest, r.rest, by = intersect("business_id", "business_id"))

# external data hu_liu
dict_huliu <- rbind(read.csv2("../data/external/opinion-lexicon-English/positive-words.txt", 
                              col.names=c("word"), 
                              comment.char=";") %>% mutate(score=1),
                    read.csv2("../data/external/opinion-lexicon-English/negative-words.txt", 
                              col.names=c("word"), 
                              comment.char=";") %>% mutate(score=-1))
words.pos <- read.csv2("../data/external/opinion-lexicon-English/positive-words.txt", 
                       col.names=c("word"), 
                       comment.char=";")
words.neg <- read.csv2("../data/external/opinion-lexicon-English/negative-words.txt", 
                       col.names=c("word"), 
                       comment.char=";")
words.pos <- stemDocument(as.vector(words.pos$word), language="english")
words.pos <- words.pos[!duplicated(words.pos)] %>% removePunctuation()
words.neg <- stemDocument(as.vector(words.neg$word), language="english")
words.neg <- words.neg[!duplicated(words.neg)] %>% removePunctuation()

# Split up into 1 to 5 star reviews
rev1 <- r.rest[r.rest$stars==1, "text"]
rev2 <- r.rest[r.rest$stars==2, "text"]
rev3 <- r.rest[r.rest$stars==3, "text"]
rev4 <- r.rest[r.rest$stars==4, "text"]
rev5 <- r.rest[r.rest$stars==5, "text"]

# Score relative difference of +/- words within review text
scoreReviewText <- function(txt, pos, neg) {
    t <- tolower(txt)
    t <- removeWords(t, words = stopwords("en"))
    t <- gsub("\\.", " ", t)
    t <- gsub("\\\n", "", t)
    t <- removePunctuation(t)
    t <- removeNumbers(t)
    s <- lapply(strsplit(t, " ", fixed=TRUE), function(x) ifelse(!duplicated(x), x, ""))
    sapply(s, function(x) sum(pos %in% x)-sum(neg %in% x))
}

scoreReviewText(revText, words.pos, words.neg)


stringr::str_count(rev1[1], "\\S+")

t <- gsub("\\.", " ", t)
t <- gsub("\\\n", "", t)
t <- tolower(sbad)
t <- removeWords(t, words = stopwords("en"))
t <- removePunctuation(t)
t <- removeNumbers(t)





business_flattened$cats <- sapply(business_flattened$categories, toString)
bus_types <- select(business_flattened,c(name,cats))
cats_unique <- bus_types %>% group_by(cats) %>% summarize(nrecs =n())

b_cat <- select(b.rest, c(business_id, categories))
b_cat$categories <- sapply(b.rest$categories, toString)
cat_unique <- b_cat %>% group_by(categories) %>% summarize(n=n())





##############################################################################

library(tm)
library(RWeka)
data(crude)

#Tokenizer for n-grams and passed on to the term-document matrix constructor
BigramTokenizer <- function(x) {RWeka::NGramTokenizer(x, Weka_control(min = 2, max = 2))}
txtTdmBi <- TermDocumentMatrix(crude, control = list(tokenize = BigramTokenizer))

getCorpus <- function(txt) {
    c <- Corpus(VectorSource(txt))
    c <- tm_map(c, removeNumbers)
    c <- tm_map(c, removePunctuation)
    c <- tm_map(c, tolower)
    c <- tm_map(c, removeWords, words = stopwords("en"))
    c <- tm_map(c, stemDocument, language = "english")
    c <- tm_map(c, PlainTextDocument)
    c
}


tdm.reviews.bin <- TermDocumentMatrix(reviews, control = list(weighting = weightBin))
tdm.reviews.bin <- removeSparseTerms( tdm.reviews.bin,1-(3/length(reviews)))

dtm = DocumentTermMatrix(corpus)
sparse = removeSparseTerms(dtm, cutoff) 
words = as.data.frame(as.matrix(sparse))
colnames(words) = make.names(colnames(words))

tdm4 <- TermDocumentMatrix(Corpus(VectorSource(t)), control = list(weighting = weightBin))
tdm4a <- removeSparseTerms(tdm4, 1-(3/length(reviews)))
pos.mat <- tdm.reviews.bin[rownames(tdm.reviews.bin) %in% pos, ]


data[,-1] <- lapply(data[,-1], as.integer)
trainSet.i <- trainSet
trainSet.i[,-1] <- lapply(trainSet.i[,-1], as.integer)
testSet.i <- testSet
testSet.i[,-1] <- lapply(testSet.i[,-1], as.integer)
validationSet.i <- validationSet
validationSet.i[,-1] <- lapply(validationSet.i[,-1], as.integer)


## RF - RF will inherently skip over NAs
mx.data <- Matrix(as.matrix(data*1), sparse=TRUE)
library(randomForest)
modRF <- randomForest(as.factor(stars)~., data=trainSet)
varImpPlot(modRF)
prediction <- predict(modRF, testSet, na.action=na.pass)
confusionMatrix(testSet$stars, predict(modRF, data=na.omit(testSet))) # 39.6%
# C50 Quinlan
library(C50); 
fitControl <- C5.0Control(winnow=TRUE)
modC50 <- C5.0(as.factor(trainSet$stars)~., na.action=na.pass, data=trainSet)



