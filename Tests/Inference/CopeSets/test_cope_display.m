% Tests for cope_display (a plotting function: smoke tests)

rng(29)
dim = [20, 20]; c = 1;
muhat = repmat(linspace(0, 2, dim(2)), dim(1), 1);
lower_set = muhat > 0.7;
upper_set = muhat > 1.3;

%% The basic call runs
figure;
cope_display(lower_set, upper_set, muhat, c);
close all

%% Grey background for the region outside the lower set
figure;
cope_display(lower_set, upper_set, muhat, c, NaN, 1);
close all

%% Empty sets run
figure;
cope_display(false(dim), false(dim), muhat, 5);
close all

%% Error if the lower and upper sets have different sizes
try
    cope_display(lower_set, upper_set(1:10, :), muhat, c);
    errored = 0;
catch e
    errored = contains(e.message, 'dimensions of the upper and lower');
end
assert(errored == 1)

%% Contours of the sets (needs plot_contour)
figure;
cope_display(lower_set, upper_set, muhat, c, NaN, 0, 1);
close all

%% The true boundary (needs plot_contour)
figure;
cope_display(lower_set, upper_set, muhat, c, muhat);
close all
