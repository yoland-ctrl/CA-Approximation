function [final_theta] = findCA(V, final_rad) %Calculate CA assuming drop is spherical cap
    % syms theta1 final_rad V
    % sol_theta = simplify(expand(simplify(solve(V == (final_rad/sin(theta1))*((final_rad/sin(theta1))*(1-cos(theta1))^2*(2+cos(theta1)))))));
    theta1 = pi - acos((V - (V^2 - 2*V*final_rad^2 + 9*final_rad^4)^(1/2) + final_rad^2)/(2*final_rad^2));
    final_theta = (180/pi)*theta1
end