%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LAGUERRE_OPTIMAL_FIT(fo, x, n)
%
% Computes an optimal Laguerre fit to the exponentially distributed data
% (randomly generated), with alpha and x-scaling parameters being optimally
% found using the fminsearch function.
%
% Inputs:   fo       values of the function being fitted
%           x        domain of the function being fitted
%           n        highest order of the Laguerre polynomial being used
% 
% Outputs:  result   the vector of values of the Laguerre fit
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function result = laguerre_optimal_fit(fo, x, n)

  % Initial estimates for the values of alpha and lambda
  alpha_guess = 5;
  lambda_guess = 10;

  % Optimisation of alpha and scale using fminsearch
  params = fminsearch(@(params) fitting_error(fo, x, n, params), [alpha_guess, lambda_guess]);
  
  alpha = params(1);
  lambda = params(2);
  
  % Computing the fit based on the optimally scaled domain and optimised alpha
  xscaled = lambda*(x-x(1))/(x(length(x))-x(1));
  result = laguerre_fit(fo, xscaled, n, alpha);
  
  error_alpha5 = fitting_error(fo, x, n, params);    
  
  
  % Recomputing with alpha = 0 (for functions concentrated near the origin)
  alpha_guess = 0;
  lambda_guess = 10;
  params = fminsearch(@(params) fitting_error(fo, x, n, params), [alpha_guess, lambda_guess]);
  alpha = params(1);
  lambda = params(2);
  xscaled = lambda*(x-x(1))/(x(length(x))-x(1));
  result0 = laguerre_fit(fo, xscaled, n, alpha);
  error_alpha0 = fitting_error(fo, x, n, params);
  
  if (error_alpha5 > error_alpha0) result = result0;
end
