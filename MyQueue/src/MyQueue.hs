module MyQueue
  ( MyQueue(MyQueue)
  , createEmptyQueue -- :: MyQueue a
  , emptyQ   -- :: MyQueue a -> MyQueue
  , isEmpty -- :: MyQueue a -> Bool
  , addQ     -- :: a -> MyQueue a -> MyQueue a
  , remQ     -- :: MyQueue a -> (a, MyQueue a)
  )where

createEmptyQueue :: MyQueue a
emptyQ :: MyQueue a -> MyQueue a
isEmpty :: MyQueue a -> Bool
addQ :: a -> MyQueue a -> MyQueue a
remQ :: MyQueue a -> (a, MyQueue a)


data MyQueue a = MyQueue [a] deriving (Show, Eq)

createEmptyQueue = MyQueue []
emptyQ (MyQueue a) = MyQueue []
isEmpty (MyQueue a) = null a
addQ s (MyQueue a) = MyQueue $ a++[s]
remQ (MyQueue a) = (head a, MyQueue (tail a)) 


