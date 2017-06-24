## Put comments here that give an overall description of what your
## functions do

## Write a short comment describing this function

makeCacheMatrix <- function(x = matrix()) {
  inv <- NULL
  set = function(newX) {
    x <<- newX
    inv <<- NULL
  }
  get = function() x
  setInv = function(m) inv <<- m
  getInv = function() inv
  list(get=get, set=set, setInv=setInv, getInv=getInv)
}


## Write a short comment describing this function

cacheSolve <- function(x, ...) {
  if (is.null(x$getInv())) {
    x$setInv(solve(x$get()))
  }
  x$getInv()
}
