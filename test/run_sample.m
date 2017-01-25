testtool = 'matlab.unittest.TestCase';
checkenv = which(testtool);
assert(~isempty(checkenv), ['Can''t find ' testtool '. Testing is not support!']);

clearvars
close all
clc
global env
include

%testsuite = matlab.unittest.TestSuite.fromClass(?test_sample);
testsuite = matlab.unittest.TestSuite.fromFolder([env.deep_root '/test']);
%runner = matlab.unittest.TestRunner.withNoPlugins;
%runner.addPlugin(matlab.unittest.plugins.TestSuiteProgressPlugin);
%res = runner.run(testsuite);
res = run(testsuite);

disp(res);