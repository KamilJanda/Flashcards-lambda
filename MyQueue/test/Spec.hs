import Test.HUnit
import MyQueue


notEmptyQueue=MyQueue [2]
emptyQueue = createEmptyQueue

testAdd = (addQ 2 (addQ 1 emptyQueue)) -- [1,2]

testRemove = remQ (MyQueue [1,2,3])


test1 = TestCase $ assertEqual "empty test" createEmptyQueue (emptyQ (MyQueue [1]))
test2 = TestCase $ assertBool "isEmpty test" (isEmpty createEmptyQueue)
test3 = TestCase $ assertEqual "addQ test" testAdd (MyQueue [1,2])
test4 = TestCase $ assertEqual "remQ test" testRemove (1,MyQueue [2,3])


tests = TestList [TestLabel "empty test" test1,TestLabel "isEmpty test" test2,TestLabel "addQ test" test3,TestLabel "remQ test" test4]

main :: IO Counts
main =  runTestTT $ tests


