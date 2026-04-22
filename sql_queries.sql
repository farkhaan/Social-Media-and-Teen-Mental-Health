
--Generates the master metrics shown in the top grid of the dashboard-- 
SELECT 
    COUNT(*) AS total_rows,
    ROUND((SUM(depression_label) * 100.0 / COUNT(*)), 2) AS depression_rate_pct,
    ROUND(AVG(anxiety_level), 2) AS avg_anxiety
FROM teen_mental_health;


-- Compares average metrics between depressed (1) and non-depressed (0) users-- 
SELECT 
    CASE WHEN depression_label = 1 THEN 'Depressed' ELSE 'Non-Depressed' END AS mental_state,
    ROUND(AVG(stress_level), 2) AS avg_stress,
    ROUND(AVG(anxiety_level), 2) AS avg_anxiety,
    ROUND(AVG(addiction_level), 2) AS avg_addiction,
    ROUND(AVG(sleep_hours), 2) AS avg_sleep_hours
FROM teen_mental_health
GROUP BY depression_label;


--Tracks self-reported offline interaction levels-- 
SELECT 
    social_interaction_level,
    COUNT(*) AS user_count
FROM teen_mental_health
GROUP BY social_interaction_level
ORDER BY user_count DESC;


--Calculates the percentage of users flagged with depression per gender-- 
SELECT 
    gender,
    COUNT(*) AS total_users,
    SUM(depression_label) AS depressed_count,
    ROUND((SUM(depression_label) * 100.0 / COUNT(*)), 2) AS depression_rate_pct
FROM teen_mental_health
GROUP BY gender
ORDER BY depression_rate_pct DESC;


--Bins screen time into blocks to reveal the U-shaped stress correlation-- 
SELECT 
    CASE 
        WHEN daily_social_media_hours <= 2 THEN '0-2 hrs (Low)'
        WHEN daily_social_media_hours <= 4 THEN '3-4 hrs (Moderate)'
        WHEN daily_social_media_hours <= 6 THEN '5-6 hrs (High)'
        ELSE '7-8+ hrs (Extreme)' 
    END AS screen_time_bracket,
    ROUND(AVG(stress_level), 2) AS avg_stress
FROM teen_mental_health
GROUP BY 
    CASE 
        WHEN daily_social_media_hours <= 2 THEN '0-2 hrs (Low)'
        WHEN daily_social_media_hours <= 4 THEN '3-4 hrs (Moderate)'
        WHEN daily_social_media_hours <= 6 THEN '5-6 hrs (High)'
        ELSE '7-8+ hrs (Extreme)' 
    END
ORDER BY screen_time_bracket;


--Calculates total users broken down by primary platform-- 
SELECT 
    platform_usage,
    COUNT(*) AS total_users
FROM teen_mental_health
GROUP BY platform_usage
ORDER BY total_users DESC;


--Tracks how mental health shifts year-over-year from age 13 to 19-- 
SELECT 
    age,
    COUNT(*) as age_demographic_size,
    ROUND(AVG(stress_level), 2) AS avg_stress,
    ROUND(AVG(anxiety_level), 2) AS avg_anxiety
FROM teen_mental_health
GROUP BY age
ORDER BY age ASC;


-- Categorizes users into 5 sleep health brackets-- 
SELECT 
    CASE 
        WHEN sleep_hours BETWEEN 4.0 AND 5.0 THEN '4-5 hrs (Severe Deprivation)'
        WHEN sleep_hours > 5.0 AND sleep_hours <= 6.0 THEN '5-6 hrs (Low Sleep)'
        WHEN sleep_hours > 6.0 AND sleep_hours <= 7.0 THEN '6-7 hrs (Moderate)'
        WHEN sleep_hours > 7.0 AND sleep_hours <= 8.0 THEN '7-8 hrs (Healthy)'
        WHEN sleep_hours > 8.0 AND sleep_hours <= 9.0 THEN '8-9 hrs (Optimal)'
    END AS sleep_bracket,
    COUNT(*) AS total_teens,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM teen_mental_health)), 2) AS pct_of_total
FROM teen_mental_health
GROUP BY 
    CASE 
        WHEN sleep_hours BETWEEN 4.0 AND 5.0 THEN '4-5 hrs (Severe Deprivation)'
        WHEN sleep_hours > 5.0 AND sleep_hours <= 6.0 THEN '5-6 hrs (Low Sleep)'
        WHEN sleep_hours > 6.0 AND sleep_hours <= 7.0 THEN '6-7 hrs (Moderate)'
        WHEN sleep_hours > 7.0 AND sleep_hours <= 8.0 THEN '7-8 hrs (Healthy)'
        WHEN sleep_hours > 8.0 AND sleep_hours <= 9.0 THEN '8-9 hrs (Optimal)'
    END
ORDER BY sleep_bracket ASC;