# Scraper



Scraper is a simple ruby application that scrapes the text of news links from 20 random pages of the bbc news website.

It extracts the proper nouns from that list and then prints a word cound of those nouns into console, (for this exercise we can assume a proper noun is any word that is capitalised except the first word of a sentence).

Scraper isn't great code. It is not Object Orientated, it mostly works but the output is poor (see below), it doesn't always make best use of ruby syntax and there are no tests.

The challenge is to refactor Scraper into something that is easily understood and maintained by others.

There is no right or wrong answer. A solution that is eloquent, tested but doesn't quite work will be better than one that is over-enginered and does. 

### Problems with the output
The code runs but the output is poor. Instead of an ordered list such as:

> Video: 46
> BBC: 12
> Covd: 5
> Who: 3
> Coronavirus: 3
> Losing: 1
> All: 1
> BBC: 1

We get an unordered list where the counts are correct but full of repeated values.:

> Who: 3
> BBC: 1
> How: 12
> All: 1
> Covid: 5
> Where: 1
> Video: 46
> Video: 46
> Video: 46
> Video: 46
> Video: 46
> Losing: 1
> Video: 46
> Video: 46
> Coronavirus: 3

###
# Usage
###
```
# creating a new instance
s = Scraper.new('news', 20)
# extracting words
results = s.extract_words

# display the results in descending order
results.reverse_each do |k, v|
  p "#{k}: #{v}"
end
```
