classdef test_pipeline < matlab.unittest.TestCase
    properties
        model
        phases
        pipeline
    end
 
    methods (TestClassSetup)
        function class_setup(testCase)
            % define model
            testCase.model = struct();

            % define phases
            testCase.phases.p1.behave = @passign;
            testCase.phases.p1.value = 1;

            testCase.phases.p2.behave = @pplus;
            testCase.phases.p2.prec = 'p1';
            testCase.phases.p2.value = 2;

            testCase.phases.p3.behave = @passign2;
            testCase.phases.p3.value = 4;

            testCase.phases.p4.behave = @pmerge;
            testCase.phases.p4.prec = {'p2' 'p3'};

            testCase.phases.p5.behave = @pshow;
            testCase.phases.p5.prec = 'p4';
        end
    end
    
    methods (TestClassTeardown)
        function class_teardown(testCase)
            testCase.model = struct();
            testCase.phases = struct();
        end
    end
    
    methods(TestMethodSetup)
        function method_setup(testCase)
            testCase.pipeline = setup_pipeline(testCase.phases, testCase.model);
        end
    end
 
    methods(TestMethodTeardown)
        function method_teardown(testCase)
            testCase.pipeline = struct();
        end
    end
 
    methods(Test)
        function test_setup(testCase)
            status = testCase.pipeline.status();
            testCase.fatalAssertSize(status, [1, numel(fieldnames(testCase.phases))]);
            testCase.fatalAssertFalse(any(status), ...
                ['All status should be undone right after setup but phase ' num2str(find(status)) ' is/are set done!']);
        end
        
        function test_run_single(testCase)
            testCase.verifyError(@()(testCase.pipeline.p5.run()), 'deep0:generalerror', ...
                'Should throw error running with preceding(s) undone.');
            testCase.verifyError(@()(testCase.pipeline.p4.run()), 'deep0:generalerror', ...
                'Should throw error running with preceding(s) undone.');
            testCase.verifyError(@()(testCase.pipeline.p2.run()), 'deep0:generalerror', ...
                'Should throw error running with preceding(s) undone.');
            
            status = testCase.pipeline.status();
            testCase.fatalAssertFalse(any(status), ...
                ['All status should be undone but phase ' num2str(find(status)) ' is/are set done!']);
            
            testCase.verifyWarningFree(@()(testCase.pipeline.p1.run()), ...
                'Warning when run phase.');
            status = testCase.pipeline.status();
            testCase.verifyTrue(status(1), ...
                'Status of phase 1 should be done after run() call.');
            testCase.fatalAssertFalse(any(status(2:end)), ...
                ['2~5 phases should be undone but phase ' num2str(find(status)) ' are set done!']);
            phase_model = testCase.pipeline.p1.model();
            testCase.verifyEqual(phase_model.value, 1, ...
                ['Value should be 1 after phase 1 run(), but we get ' num2str(phase_model.value)]);
            
            testCase.verifyWarningFree(@()(testCase.pipeline.p3.run()), ...
                'Warning when run phase.');
            status = testCase.pipeline.status();
            testCase.verifyTrue(status(3), ...
                'Status of phase 3 should be done after run() call.');
            testCase.fatalAssertFalse(any(status([2 4 5])), ...
                ['Phases 2, 4, 5 should be undone but phase ' num2str(find(status)) ' are set done!']);
            phase_model = testCase.pipeline.p3.model();
            testCase.verifyEqual(phase_model.value2, 4, ...
                ['Value (in value2) should be 4 after phase 3 run(), but we get ' num2str(phase_model.value2)]);
            
            testCase.verifyError(@()(testCase.pipeline.p5.run()), 'deep0:generalerror', ...
                'Should throw error running with preceding(s) undone.');
            testCase.fatalAssertFalse(any(status([2 4 5])), ...
                ['Phases 2, 4, 5 should be undone but phase ' num2str(find(status)) ' are set done!']);
            
            
            testCase.verifyWarningFree(@()(testCase.pipeline.p2.run()), ...
                'Warning when run phase.');
            status = testCase.pipeline.status();
            testCase.verifyTrue(status(2), ...
                'Status of phase 2 should be done after run() call.');
            testCase.verifyWarningFree(@()(testCase.pipeline.p4.run()), ...
                'Warning when run phase.');
            status = testCase.pipeline.status();
            testCase.verifyTrue(status(4), ...
                'Status of phase 4 should be done after run() call.');
            testCase.verifyWarningFree(@()(testCase.pipeline.p5.run()), ...
                'Warning when run phase.');
            status = testCase.pipeline.status();
            testCase.verifyTrue(status(5), ...
                'Status of phase 5 should be done after run() call.');
            
            phase_model = testCase.pipeline.p1.model();
            testCase.verifyEqual(phase_model.value, 1, ...
                ['Value (in value) from phase 1 should be 1, but we get ' num2str(phase_model.value)]);
            phase_model = testCase.pipeline.p2.model();
            testCase.verifyEqual(phase_model.value, 3, ...
                ['Value (in value) from phase 2 should be 3, but we get ' num2str(phase_model.value)]);
            phase_model = testCase.pipeline.p3.model();
            testCase.verifyEqual(phase_model.value2, 4, ...
                ['Value (in value2) from phase 3 should be 4, but we get ' num2str(phase_model.value2)]);
            phase_model = testCase.pipeline.p4.model();
            testCase.verifyEqual(phase_model.value, 43, ...
                ['Value (in value) from phase 4 should be 43, but we get ' num2str(phase_model.value)]);
            phase_model = testCase.pipeline.p1.model();
            testCase.verifyEqual(phase_model.value, 1, ...
                ['Value (in value) from phase 5 should be 43, but we get ' num2str(phase_model.value)]);
        end
        
        function test_run_all(testCase)
            testCase.verifyWarningFree(@()(testCase.pipeline.run()), ...
                'Warning when run through all phases.');
            status = testCase.pipeline.status();
            testCase.verifyTrue(all(status), ...
                'All phases should be done after run() call.');
            
            phase_model = testCase.pipeline.p1.model();
            testCase.verifyEqual(phase_model.value, 1, ...
                ['Value (in value) from phase 1 should be 1, but we get ' num2str(phase_model.value)]);
            phase_model = testCase.pipeline.p2.model();
            testCase.verifyEqual(phase_model.value, 3, ...
                ['Value (in value) from phase 2 should be 3, but we get ' num2str(phase_model.value)]);
            phase_model = testCase.pipeline.p3.model();
            testCase.verifyEqual(phase_model.value2, 4, ...
                ['Value (in value2) from phase 3 should be 4, but we get ' num2str(phase_model.value2)]);
            phase_model = testCase.pipeline.p4.model();
            testCase.verifyEqual(phase_model.value, 43, ...
                ['Value (in value) from phase 4 should be 43, but we get ' num2str(phase_model.value)]);
            phase_model = testCase.pipeline.p1.model();
            testCase.verifyEqual(phase_model.value, 1, ...
                ['Value (in value) from phase 5 should be 43, but we get ' num2str(phase_model.value)]);
        end
        
        function test_reset(testCase)
            testCase.verifyWarningFree(@()(testCase.pipeline.run()), ...
                'Warning when run through all phases.');
            status = testCase.pipeline.status();
            testCase.fatalAssertTrue(all(status), ...
                'All phases should be done after run() call.');
            
            testCase.verifyWarningFree(@()(testCase.pipeline.p5.reset()), ...
                'Warning when reset phase 5.');
            status = testCase.pipeline.status();
            testCase.verifyFalse(status(5), ...
                'Phase 5 should be undone after reset() call to 5.');
            testCase.fatalAssertTrue(all(status(1:4)), ...
                'Phases 1~4 should be done.');
            
            testCase.pipeline.p2.reset(); % may cause warning when try to reset phase 5 as dependent
            status = testCase.pipeline.status();
            testCase.verifyFalse(any(status([2 4 5])), ...
                'Phases 2, 4, 5 should be undone after reset() call to 2.');
            testCase.fatalAssertTrue(all(status([1 3])), ...
                'Phases 1, 3 should be done.');
            
            testCase.pipeline.p1.reset(); % may cause warning when try to reset phase 2 as dependent
            status = testCase.pipeline.status();
            testCase.verifyFalse(any(status([1 2 4 5])), ...
                'Phases 1, 2, 4, 5 should be undone after reset() call to 1.');
            testCase.fatalAssertTrue(status(3), ...
                'Phase 3 should be done.');
            
            % run again and shoul still get correct result
            % 3 is not reseted
            testCase.verifyWarningFree(@()(testCase.pipeline.run()), ...
                'Warning when run through all phases.');
            phase_model = testCase.pipeline.p1.model();
            testCase.verifyEqual(phase_model.value, 1, ...
                ['Value (in value) from phase 1 should be 1, but we get ' num2str(phase_model.value)]);
            phase_model = testCase.pipeline.p2.model();
            testCase.verifyEqual(phase_model.value, 3, ...
                ['Value (in value) from phase 2 should be 3, but we get ' num2str(phase_model.value)]);
            phase_model = testCase.pipeline.p3.model();
            testCase.verifyEqual(phase_model.value2, 4, ...
                ['Value (in value2) from phase 3 should be 4, but we get ' num2str(phase_model.value2)]);
            phase_model = testCase.pipeline.p4.model();
            testCase.verifyEqual(phase_model.value, 43, ...
                ['Value (in value) from phase 4 should be 43, but we get ' num2str(phase_model.value)]);
            phase_model = testCase.pipeline.p1.model();
            testCase.verifyEqual(phase_model.value, 1, ...
                ['Value (in value) from phase 5 should be 43, but we get ' num2str(phase_model.value)]);
        end
    end
end

% phases definition for the tests
function run = passign(phase_, model_, update_model_)
    function run_handle()
        model = model_();
        model.value = phase_.value;
        update_model_(model);
    end
    run = @run_handle;
end

function run = passign2(phase_, model_, update_model_)
    function run_handle()
        model = model_();
        model.value2 = phase_.value;
        update_model_(model);
    end
    run = @run_handle;
end

function run = pplus(phase_, model_, update_model_)
    function run_handle()
        model = model_();
        model.value = model.value + phase_.value;
        update_model_(model);
    end
    run = @run_handle;
end

function run = pmerge(~, model_, update_model_)
    function run_handle()
        model = model_();
        model.value = model.value2 * 10 + model.value;
        update_model_(model);
    end
    run = @run_handle;
end

function run = pshow(~, model_, ~)
    function run_handle()
        model = model_();
        logi(['we got ' num2str(model.value) ' finally.']);
    end
    run = @run_handle;
end