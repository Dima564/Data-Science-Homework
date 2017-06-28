library(data.table)

getOutcomeName <- function(outcome) {
  outcomeCodes <- list('heart attack' = 'Hospital 30-Day Death (Mortality) Rates from Heart Attack',
                       'heart failure' = 'Hospital 30-Day Death (Mortality) Rates from Heart Failure', 
                       'pneumonia' = 'Hospital 30-Day Death (Mortality) Rates from Pneumonia')
  if (!(outcome %in% names(outcomeCodes))) {
    stop("Invalid outcome")
  }
  as.character(outcomeCodes[outcome])
}

readData <- function(state=NULL, outcome) {
  outcomeColName <- getOutcomeName(outcome)

  if (!is.null(state) && !(state %in% state.abb)) {
    stop("Invalid state")
  }
  
  dd <- fread('outcome-of-care-measures.csv')
  
  stateFilter = rep(TRUE, nrow(dd))
  if (!is.null(state)) {
    stateFilter <- dd$State == state
  }
  
  dd <- subset(dd, stateFilter, select=c(outcomeColName, 'Hospital Name', 'State'))
  dd[[outcomeColName]] <- suppressWarnings(as.numeric(dd[[outcomeColName]]))
  subset(dd, !is.na(dd[[outcomeColName]]))
}

validateNum <- function(num, nrow) {
  if (num == 'best') {
    num <- 1
  } else if (num == 'worst') {
    num <- nrow
  } else if (!is.numeric(num)) {
    stop("invalid num")
  } else if (num > nrow) {
    num <- NA
  }
  num
}

rankhospital <- function(state, outcome,  num='best') {
  dd <- readData(state, outcome)
  outcomeColName <- getOutcomeName(outcome)
  num <- validateNum(num, nrow(dd))
  if (is.na(num)) {
    return(NA)
  }
  as.character(dd[order(get(outcomeColName), `Hospital Name`)][num, 'Hospital Name'])
}



best <- function(state, outcome) {
  rankhospital(state, outcome, 'best')
}

rankall <- function(outcome, num='best') {
  outcomeColName <- getOutcomeName(outcome)
  dd <- readData(state=NULL, outcome)
  # Note that there's bug in here. In case we supply num=='worst', 
  # we should calculate num not based on nrow in all data frame, but rather 
  # based on number of items in State group
  num <- validateNum(num, nrow(dd))
  dd[order(get(outcomeColName), `Hospital Name`), `Hospital Name`[num], by=State][order(State)]
  
}







