## Q1

url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url1, destfile = "US_comms.csv")
Us_comms <- as.data.frame(read.csv("US_comms.csv"), header = TRUE)
names(Us_comms)
summary(Us_comms[, 11])
summary(Us_comms[, 12])
## need ACR == 3 and AGS == 6
agricultureLogical <- (Us_comms$ACR == 3 & Us_comms$AGS == 6)
which(agricultureLogical)

## Q2
install.packages("jpeg")
library(jpeg)
pic_file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(pic_file, destfile = "Cute_photo.jpeg", mode = "wb")
cute_pic <- readJPEG("Cute_photo.jpeg", native = TRUE)
quantile(cute_pic, probs = c(.3, .8))


## Q3
library(dplyr)
library(data.table)

urls <- c("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv")
for (i in seq_along(urls)) {
  download.file(urls, destfile = c("edu_data.csv", "dom_data.csv"), mode = "wb")
}
dom_DF <- fread("dom_data.csv", skip = 5, nrows = 190, select = c(1, 2, 4, 5), col.names = c("CountryCode", "rank", "economy", "total"))
edu_df <- fread("edu_data.csv")
merged_CountryCode_df <- merge(dom_DF, edu_df, by = "CountryCode") %>% arrange(desc(rank))


## Q4

merged_countryCode_df$`Income Group` <- as.factor(merged_countryCode_df$`Income Group`)
class(merged_countryCode_df$`Income Group`)
levels(merged_countryCode_df$`Income Group`)
merged_GDPavg <- group_by(merged_countryCode_df, `Income Group`)
merged_GDPavg %>%
  filter("High income: OECD" %in% `Income Group` | "High income: nonOECD" %in% `Income Group`) %>% ## used | instead of & to filter by each of the selected levels in `Income Group`
  summarize(Average = mean(Rank, na.rm = T)) %>%
  arrange(desc(`Income Group`))

## Q5

merged_countryCode_df$Ranking <- cut(merged_countryCode_df$rank, breaks = 5)
merged_rank_vs_Income <- table(merged_countryCode_df$Ranking, merged_countryCode_df$`Income Group`)
merged_rank_vs_Income[1, 4]