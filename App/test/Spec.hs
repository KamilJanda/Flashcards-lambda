

module Queue
  ( MyQueue
  , empty   -- :: MyQueue a
  , isEmpty -- :: MyQueue a -> Bool
  , addQ     -- :: a -> MyQueue a -> MyQueue a
  , remQ     -- :: MyQueue a -> (a, MyQueue a)
  )where

empty :: MyQueue a
isEmpty :: MyQueue a -> Bool
addQ :: a -> MyQueue a -> MyQueue a
remQ :: MyQueue a -> (a, MyQueue a)

newtype MyQueue a = MyQueue [a] deriving (Show)


empty = MyQueue []
isEmpty (MyQueue a) = null a
addQ s (MyQueue a) = MyQueue $ a++[s]
remQ (MyQueue a) = (head a, MyQueue (tail a)) 


x = MyQueue [1,2,3]


-- main :: IO ()
-- main = putStrLn "Test suite not yet implemented"
