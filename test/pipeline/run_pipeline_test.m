testtool = 'matlab.unittest.TestCase';
assert(~isempty(which(testtool)), ['Can''t find ' testtool '. Testing is not support!']);

clearvars
close all
clc
global env
include
env.verbose = 'ERROR';

testsuite = matlab.unittest.TestSuite.fromFolder([env.deep_root '/test/pipeline']);
res = run(testsuite);

disp(res);