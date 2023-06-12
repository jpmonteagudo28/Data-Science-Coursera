## I need to create a function that assigns x number of cards to each player
## the cards don't repeat
## the card is either a number/hand of any suit.
## the suits can repeat unless already a card of that number with same suit

setwd("/Users/jpmonteagudo/Desktop/R/Data-Science-Coursera")

start_war <- function(players){
  deck <-read.table("card_deck.txt", header = TRUE, sep = "")
  
  players <- 2:4
  n <- 4  # Number of partitions per player
  multiples <- round(52 / 2:n) 
    
  }
}