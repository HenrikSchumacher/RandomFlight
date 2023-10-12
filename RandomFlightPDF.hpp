#pragma once

#include <vector>
#include <algorithm>
#include <math.h>
#include <type_traits>

namespace RandomFlight
{
    template<typename Real_ = double> class PDF
    {
        static_assert( std::is_floating_point_v<Real_>, " Type must be a real floating point type.");
        
    public:
        
        using Real = Real_;
        using Int = int;
        
        static constexpr Real zero = static_cast<Real>(0);
        static constexpr Real one  = static_cast<Real>(1);
        static constexpr Real half = static_cast<Real>(0.5);
        static constexpr Real two  = static_cast<Real>(2);
        
        
    private:
        
        Int  n       = 0;
        Real n_Real  = 0;
        
        std::vector<Real> a;
        
    public:
        
        PDF() = delete;
        
        explicit PDF( Int n_ )
        :   n         ( n_                   )
        ,   n_Real    ( static_cast<Real>(n) )
        ,   a         ( n_                   )
        {}
        
        ~PDF() = default;
        
        Real operator()( const Real r )
        {
            if( (r <= zero) || (r >= n_Real) )
            {
                return zero;
            }
            
            const Real r_plus_n = r + n_Real;
            
            const Int i_0 = static_cast<Int>( std::floor( half * (r_plus_n) ) );
            
            std::fill( &a[0], &a[n], zero );
            
            a[i_0] = half; // <-- So we don't have to multiply with 0.5 in the end.
            
            for( Int k = 1; k < n-1; ++k )
            {
                const Int i_begin = std::max( 0, i_0 - k );
                const Int i_end   = std::min( i_0 + 1, n - k );
                
                const Real two_k = static_cast<Real>( 2 * k );
                
                const Real two_k_plus_2 = two_k + two;
                
                const Real scale = one / two_k;
                
                for( Int i = i_begin; i < i_end; ++i )
                {
                    const Real t = r_plus_n - static_cast<Real>( 2 * i );
                    
                    a[i] = scale * ( a[i] * t + a[i+1] * ( two_k_plus_2 - t ) );
                }
            }
            
            return r * (a[1] - a[0]);
        }

        
    }; // class RandomFlight::PDF

    
} // namespace RandomFlight

