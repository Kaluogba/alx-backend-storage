-- Task 8: Create an index on the table names for the first letter of the name

CREATE INDEX idx_name_first ON names (LEFT(name, 1));
