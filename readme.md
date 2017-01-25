# Deep-learning Essential Experiment Pipeline


**DEEP (Deep-learning Essential Experiment Pipeline)**
is a set of useful routines helping researchers to carry out deep-learning experiments. **DEEP** provides a set of yet efficient implementation of state-of-the-art deep-learning **components** (layers, activation functions, *etc.*), **learning procedures**（back-propagation, pre-training, fine-tuning, *etc.*）as well as **experimental pipelines** (data-set division, cross-validation, *etc.*) to support *research-purpose experimental works*.

The project is implemented in **MATLAB**.

## Documentation

*Not finished yet.*

## Examples

*Not finished yet.*

## Implementation Notes

The project emphasizes on an easy-to-use interface, with the price of less-polished underlying implementation.

OOP (Object Oriented Programming) support in MATLAB is poor[^1]. The project employs **[Closure][clusure]** instead of OOP. Construction codes instantiate closures, which maintain states of objects, and return handles of closure functions to access or interactive with maintained objects. This also avoid unnecessary parameter passing, leaving a clean (with no parameter) interface handle. For a clear identification in the code, variables referenced across lexical scopes in closure are named to end with an underscore `_`.

For coding convenient, the project use **struct** in MATLAB as a map container. In this way DEEP provides a more clear interface while the overhead to the implementation is also negligible.

The project uses a **xUnit**-style test framework introduced by MATLAB R2013a. For downward compatibility, please refer to [xUnit test framework][xunit].

[^1]: This is due to heavy method call overhead, see [this discussion](http://stackoverflow.com/questions/1693429/is-matlab-oop-slow-or-am-i-doing-something-wrong).

[clusure]: http://en.wikipedia.org/wiki/Closure_%28computer_programming%29 "Closure"

[xunit]: http://www.mathworks.com/matlabcentral/fileexchange/22846-matlab-xunit-test-framework "xUnit"

## Contact

For any suggestion, please [email me directly](guoquanscu@gmail.com).