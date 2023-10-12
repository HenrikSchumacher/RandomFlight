#include "../RandomFlightPDF.hpp"
#include <string>
#include <iostream>
#include <iomanip>

// Simply compile with
//    clang main.cpp -Wall -std=c++20 -lstdc++ -Ofast -o ./main.out

int main()
{
    std::cout << "Test program for RandomFlight" << std::endl;
    
    std::cout << "" << std::endl;
    
    std::cout << "Printing the values of the PDF a random flight with 12 steps for x = 0 to x = 12 in steps if 0.1." << std::endl;
    
    std::cout << "" << std::endl;
    
    // Initialize a function object for the PDF of a random flight with 100 steps.
    RandomFlight::PDF<double> F ( 12 );
    
    for( double x = 0.; x < 12.; x += 0.001 )
    {
        // Just call the function object F on a real number to get the result.
        const double value = F(x);
        
        std::cout << "PDF(" << std::setprecision(16) << x << ") = " << std::setprecision(16) << value << std::endl;
    }
    
    return 0;
}
