x1 = IDEAL_WITH_NO_DELAY;
x2 = DELAY_0_25_NO_COMPENSATION;
x3 = DELAY_0_25_COMPENSATION;
x4 = DELAY_0_5_NO_COMPENSATION;

data_list = {x1, x2, x3, x4};
data_names = {'x1: Ideal No Delay', ...
              'x2: Delay 0.25 No Comp', ...
              'x3: Delay 0.25 Comp', ...
              'x4: Delay 0.5 No Comp'};

% Loop through each dataset
for i = 1:length(data_list)
    
    % Extract the current dataset
    y = data_list{i};
    
    if isa(y, 'timeseries') || isstruct(y)
        y = y.Data; 
    end
    y = double(y(:)); % Ensure it is a double-precision column vector

    num_order = 2; 
    den_order = 2; 
    
    % prony() finds the filter coefficients that produce this sequence
    [b, a] = prony(y, num_order, den_order);

    % ---------------------------------------------------------
    % 3. Create the Transfer Function & NTF
    % ---------------------------------------------------------
    Ts = 1; 
    H = tf(b, a, Ts, 'Variable', 'z^-1');
    
    % Calculate Noise Transfer Function (Closed Loop)
    ntf = 1 / (H + 1);
    [p, z_poles] = pzmap(ntf);

    % ---------------------------------------------------------
    % 4. Visualization (Combined Figure)
    % ---------------------------------------------------------
    figure('Color', 'w', 'Name', data_names{i});
    

    subplot(1, 2, 1);
    theta = 0:0.01:2*pi;
    plot(cos(theta), sin(theta), 'k--', 'LineWidth', 1); % Unit Circle
    hold on;
    plot(real(p), imag(p), 'Xk', 'MarkerSize', 12, 'LineWidth', 2); % Poles
    plot(real(z_poles), imag(z_poles), 'Or', 'MarkerSize', 12, 'LineWidth', 2); % Zeros
    axis([-1.5 1.5 -1.5 1.5]);
    axis equal; 
    grid on;
    title(['PZ Map: ' data_names{i}]);
    xlabel('Real'); ylabel('Imaginary');
    legend('Unit Circle', 'Poles', 'Zeros', 'Location', 'best');
    subplot(1, 2, 2);
    y_model = impz(b, a, length(y)); % Generate model response
    
    plot(y, 'bo', 'LineWidth', 1); hold on;
    plot(y_model, 'r-', 'LineWidth', 1.5);
    
    % Formatting Validation
    legend('Original Data', 'Prony Model');
    title(['Validation: ' data_names{i}]);
    grid on;
    xlabel('Samples'); ylabel('Amplitude');

end