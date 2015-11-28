library(readr, jsonlite)

# https://www.kaggle.com/c/yelp-recsys-2013/forums/t/4465/reading-json-files-with-r-how-to
filenames <- c("business", "tip", "checkin", "review", "user")
filesToRead <- paste0('../yelp_data/yelp_academic_dataset_',filenames,'.json')
# Either gets lists of lists
eda.data <- lapply(filesToRead, function(x) fromJSON(read_lines(x, n_max=1)))
# Or dataframes
eda.data1 <- lapply(filesToRead, function(x) fromJSON(sprintf("[%s]", paste(read_lines(x, n_max=1000), collapse=","))))
# Name the data frames according to the order they got read in
names(eda.data) <- filenames
# Get the attributes
paste0('names(eda.data$',filenames,')')
#do.call(names, eda.data)

## EDA plots
library(lattice)
xyplot(eda.data$business$review_count~eda.data$business$stars)


stream_in(file(jfile[3]))
review_data <- stream_in(file(jfile[3]))

'read_json' <- function() {
    raw.json <- scan('../yelp_data/yelp_academic_dataset_checkin.json', what="raw()", sep="\n")
    json.data <- lapply(raw.json, function(x) fromJSON(x))
    business_id <- unlist(lapply(json.data, function(x) x$business_id))
}

system.time(edaBusiness <- fromJSON(sprintf("[%s]", paste0(read_lines(filesToRead), collapse=",",n_max=1))))
