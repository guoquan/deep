classdef test_sample < matlab.unittest.TestCase
    % chech out this command :D
    % >> doc matlab.unittest.TestCase
    
    properties
        model
    end
 
    methods (TestClassSetup)
        function class_setup(testCase)
            testCase.model.v = 0;
        end
    end
    
    methods (TestClassTeardown)
        function class_teardown(testCase)
            testCase.model = rmfield(testCase.model, 'v');
        end
    end
    
    methods(TestMethodSetup)
        function method_setup(testCase)
            testCase.model.v = 1;
        end
    end
 
    methods(TestMethodTeardown)
        function method_teardown(testCase)
            testCase.model.v = 0;
        end
    end
 
    methods(Test)
        function test1(testCase)
            v = tested(testCase.model.v, 2);
            testCase.verifyEqual(v, 12, 'Not correct result in test1.');
        end
        
        function test2(testCase)
            v = tested(3, testCase.model.v);
            testCase.verifyEqual(v, 31, 'Not correct result in test2.');
        end
        
        function testbad(testCase)
            v = badtested(3, testCase.model.v);
            testCase.verifyEqual(v, 31, 'Not correct result in test2.');
        end
    end
end

function v3 = tested(v1, v2)
    v3 = v1 .* 10 + v2;
end
function v3 = badtested(v1, v2)
    v3 = randi(v1 + v2);
end