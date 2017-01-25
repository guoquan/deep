testtool = 'matlab.unittest.TestCase';
checkenv = which(testtool);
assert(~isempty(checkenv), ['Can''t find ' testtool '. Testing is not support!']);

clearvars
close all
clc
global env
include

testsuite = matlab.unittest.TestSuite.fromFolder([env.deep_root '/test/utils']);
res = run(testsuite);

disp(res);