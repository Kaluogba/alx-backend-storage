-- Define the stored procedure ComputeAverageWeightedScoreForUser
DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUser(IN user_id INT)
BEGIN
    DECLARE total_score FLOAT;
    DECLARE total_weight FLOAT;
    DECLARE weighted_score FLOAT;

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
END //

DELIMITER ;
