function [row, col] = id_to_grid(id, num_cols)
    % Calculate grid coordinates from ID
    row = ceil(id / num_cols);  % Calculate row
    col = num_cols - mod(id - 1, num_cols);  % Calculate column
end
