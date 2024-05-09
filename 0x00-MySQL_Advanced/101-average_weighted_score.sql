-- Define the stored procedure ComputeAverageWeightedScoreForUsers
DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE user_id INT;
    DECLARE total_score FLOAT;
    DECLARE total_weight FLOAT;
    DECLARE weighted_score FLOAT;

    -- Declare cursor for iterating over users
    DECLARE user_cursor CURSOR FOR
        SELECT id
        FROM users;

    -- Declare continue handler to exit loop
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open cursor
    OPEN user_cursor;

    -- Start loop
    user_loop: LOOP
        -- Fetch user_id from cursor
        FETCH user_cursor INTO user_id;

        -- Exit loop if no more rows
        IF done THEN
            LEAVE user_loop;
        END IF;

        -- Initialize variables
        SET total_score = 0;
        SET total_weight = 0;

        -- Calculate total weighted score and total weight for the user
        SELECT SUM(corrections.score * projects.weight), SUM(projects.weight)
        INTO total_score, total_weight
        FROM corrections
        INNER JOIN projects ON corrections.project_id = projects.id
        WHERE corrections.user_id = user_id;

        -- Calculate the average weighted score
        IF total_weight > 0 THEN
            SET weighted_score = total_score / total_weight;
        ELSE
            SET weighted_score = 0;
        END IF;

        -- Update the average_score for the user
        UPDATE users
        SET average_score = weighted_score
        WHERE id = user_id;
    END LOOP;

    -- Close cursor
    CLOSE user_cursor;
END //

DELIMITER ;
