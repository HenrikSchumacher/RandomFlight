# RandomFlight
Implementation of the probability distribution function for random flights in 3D.


## Usage
This is a header-only C++ library: Merely include RandomFlightPDF.hpp into your C++ project and you have access to RandomFlight::PDF. The latter is a function object. Simply intitialize it with the number `n` of steps:

    RandomFlight::PDF F (n);

Then `F` is an instance of this function class. Then call `F` on an arbitrary value real `t`":

    double result = F(t);

That's it. You may also have a look at the usage example `Example/main.cpp`. For example, with clang you can compile it from the terminal with

    clang main.cpp -Wall -std=c++20 -lstdc++ -Ofast -o ./main.out

and then run

    ./main.out

That's it!
