classdef test_strfunc < matlab.unittest.TestCase
 
    properties
        char_array
        char_cell
        char_string
    end
 
    methods(TestMethodSetup)
        function setup_strings(testCase)
            testCase.char_array = char('aaa', 'bb', 'c', 'dddd');
            testCase.char_cell = {'a', 'bb', 'cccc', 'ddd'};
            testCase.char_string = ['a', 'bcd'];
        end
    end
 
    methods(Test)
        function test_non_output_func(testCase)
            testCase.verifyWarningFree( ...
                @()(strfunc(@disp, testCase.char_array)), ...
                'Receive warning when run with array of strings.');
            
            testCase.verifyWarningFree( ...
                @()(strfunc(@disp, testCase.char_cell)), ...
                'Receive warning when run with cell of strings.');
            
            testCase.verifyWarningFree( ...
                @()(strfunc(@disp, testCase.char_string)), ...
                'Receive warning when run with a single string.');
        end
        
        function test_single_output_func(testCase)
            res = testCase.verifyWarningFree( ...
                @()(strfunc(@single_output_func, testCase.char_array)), ...
                'Receive warning when run with array of strings.');
            testCase.fatalAssertSize(res, [size(testCase.char_array, 1) 1]);
            testCase.fatalAssertInstanceOf(res, 'numeric');
            for idx = 1:size(testCase.char_array, 1)
                resi = single_output_func(strtrim(testCase.char_array(idx,:)));
                testCase.verifyEqual(res(idx), resi, ...
                    ['#' num2str(idx) ' result with array of strings is not correct. ' ...
                    num2str(resi) ' expacted but get ' num2str(res(idx))]);
            end
            
            res = testCase.verifyWarningFree( ...
                @()(strfunc(@single_output_func, testCase.char_cell)), ...
                'Receive warning when run with cell of strings.');
            testCase.fatalAssertSize(res, size(testCase.char_cell));
            testCase.fatalAssertInstanceOf(res, 'numeric');
            for idx = 1:numel(testCase.char_cell)
                resi = single_output_func(testCase.char_cell{idx});
                testCase.verifyEqual(res(idx), resi, ...
                    ['#' num2str(idx) ' result with cell of strings is not correct. ' ...
                    num2str(resi) ' expacted but get ' num2str(res(idx))]);
            end
            
            res = testCase.verifyWarningFree( ...
                @()(strfunc(@single_output_func, testCase.char_string)), ...
                'Receive warning when run with a single string.');
            testCase.fatalAssertSize(res, [1 1]);
            testCase.fatalAssertInstanceOf(res, 'numeric');
            resi = single_output_func(testCase.char_string);
            testCase.verifyEqual(res, resi, ...
                ['Result with a single string is not correct. ' ...
                num2str(resi) ' expacted but get ' num2str(res)]);
        end
        
        function test_multiple_output_func(testCase)
            [res1, res2] = testCase.verifyWarningFree( ...
                @()(strfunc(@multiple_output_func, testCase.char_array, 'UniformOutput', false)), ...
                'Receive warning when run with array of strings.');
            testCase.fatalAssertSize(res1, [size(testCase.char_array, 1) 1]);
            testCase.fatalAssertInstanceOf(res1, 'cell');
            testCase.fatalAssertSize(res2, [size(testCase.char_array, 1) 1]);
            testCase.fatalAssertInstanceOf(res2, 'cell');
            for idx = 1:size(testCase.char_array, 1)
                [resi1, resi2] = multiple_output_func(strtrim(testCase.char_array(idx, :)));
                testCase.verifyEqual(res1{idx}, resi1, ...
                    ['First output of #' num2str(idx) ' result with array of strings is not correct. ' ...
                    '''' resi1 ''' expacted but get ''' res1{idx} '''']);
                testCase.verifyEqual(res2{idx}, resi2, ...
                    ['Second output of #' num2str(idx) ' result with array of strings is not correct. ' ...
                    num2str(resi2) ' expacted but get ' num2str(res2{idx})]);
            end
            
            [res1, res2] = testCase.verifyWarningFree( ...
                @()(strfunc(@multiple_output_func, testCase.char_cell, 'UniformOutput', false)), ...
                'Receive warning when run with cell of strings.');
            testCase.fatalAssertSize(res1, size(testCase.char_cell));
            testCase.fatalAssertInstanceOf(res1, 'cell');
            testCase.fatalAssertSize(res2, size(testCase.char_cell));
            testCase.fatalAssertInstanceOf(res2, 'cell');
            for idx = 1:size(testCase.char_cell, 1)
                [resi1, resi2] = multiple_output_func(testCase.char_cell{idx});
                testCase.verifyEqual(res1{idx}, resi1, ...
                    ['First output of #' num2str(idx) ' result with cell of strings is not correct. ' ...
                    '''' resi1 ''' expacted but get ''' res1{idx} '''']);
                testCase.verifyEqual(res2{idx}, resi2, ...
                    ['Second output of #' num2str(idx) ' result with cell of strings is not correct. ' ...
                    num2str(resi2) ' expacted but get ' num2str(res2{idx})]);
            end
            
            [res1, res2] = testCase.verifyWarningFree( ...
                @()(strfunc(@multiple_output_func, testCase.char_string, 'UniformOutput', false)), ...
                'Receive warning when run with a single string.');
            testCase.fatalAssertSize(res1, [1 1]);
            testCase.fatalAssertInstanceOf(res1, 'cell');
            testCase.fatalAssertSize(res2, [1 1]);
            testCase.fatalAssertInstanceOf(res2, 'cell');
            [resi1, resi2] = multiple_output_func(testCase.char_string);
            testCase.verifyEqual(res1{:}, resi1, ...
                ['First output of #' num2str(idx) ' result with cell of strings is not correct. ' ...
                '''' resi1 ''' expacted but get ''' res1{:} '''']);
            testCase.verifyEqual(res2{:}, resi2, ...
                ['Second output of #' num2str(idx) ' result with cell of strings is not correct. ' ...
                num2str(resi2) ' expacted but get ' num2str(res2{:})]);
        end
    end
 
end

function out = single_output_func( in )
out = length(in);
end

function [out1, out2] = multiple_output_func( in )
out1 = ['begin_' in '_end'];
out2 = length(out1);
end