## Put comments here that give an overall description of what your
## functions do

## Wrapper around R matrix, providing an inverse matrix caching functionality

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


## Function which calculates inverse of a CacheMatrix and levarages the cache

cacheSolve <- function(x, ...) {
  if (is.null(x$getInv())) {
    x$setInv(solve(x$get()))
  }
  x$getInv()
}
