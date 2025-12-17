EXPLAIN ANALYZE
SELECT t.name, t.year, t.city, team.name as winner
FROM tournaments t
LEFT JOIN teams team ON t.winner_team_id = team.id;

EXPLAIN ANALYZE
SELECT team.name, team.representative
FROM tournament_participation tp
JOIN teams team ON tp.team_id = team.id
WHERE tp.tournament_id = 1;

EXPLAIN ANALYZE
SELECT p.first_name, p.last_name, p.birth_date, t.name as team_name
FROM players p
JOIN teams t ON p.team_id = t.id
WHERE t.id = 5;

EXPLAIN ANALYZE
SELECT m.match_date, t1.name as home, t2.name as away, mt.name as type, m.home_score, m.away_score
FROM matches m
JOIN teams t1 ON m.home_team_id = t1.id
JOIN teams t2 ON m.away_team_id = t2.id
JOIN match_types mt ON m.match_type_id = mt.id
WHERE m.tournament_id = 1;

EXPLAIN ANALYZE
SELECT m.match_date, mt.name as stage, m.home_score, m.away_score
FROM matches m
JOIN match_types mt ON m.match_type_id = mt.id
WHERE m.home_team_id = 10 OR m.away_team_id = 10;

EXPLAIN ANALYZE
SELECT me.event_type, p.first_name, p.last_name, me.minute
FROM match_events me
JOIN players p ON me.player_id = p.id
WHERE me.match_id = 100;

EXPLAIN ANALYZE
SELECT p.first_name, p.last_name, t.name as team, me.event_type, me.minute
FROM match_events me
JOIN matches m ON me.match_id = m.id
JOIN players p ON me.player_id = p.id
JOIN teams t ON p.team_id = t.id
WHERE m.tournament_id = 1 
  AND (me.event_type = 'yellow_card' OR me.event_type = 'red_card');

EXPLAIN ANALYZE
SELECT p.first_name, p.last_name, t.name as team, COUNT(me.id) as goals
FROM match_events me
JOIN matches m ON me.match_id = m.id
JOIN players p ON me.player_id = p.id
JOIN teams t ON p.team_id = t.id
WHERE m.tournament_id = 1 AND me.event_type = 'goal'
GROUP BY p.id, p.first_name, p.last_name, t.name;

EXPLAIN ANALYZE
SELECT 
    t.name,
    SUM(CASE 
        WHEN m.home_team_id = t.id AND m.home_score > m.away_score THEN 3
        WHEN m.away_team_id = t.id AND m.away_score > m.home_score THEN 3
        WHEN m.home_score = m.away_score THEN 1
        ELSE 0 
    END) as points,
    SUM(CASE WHEN m.home_team_id = t.id THEN m.home_score ELSE m.away_score END) - 
    SUM(CASE WHEN m.home_team_id = t.id THEN m.away_score ELSE m.home_score END) as goal_diff
FROM teams t
JOIN tournament_participation tp ON t.id = tp.team_id
JOIN matches m ON (m.home_team_id = t.id OR m.away_team_id = t.id) AND m.tournament_id = tp.tournament_id
WHERE tp.tournament_id = 1
GROUP BY t.id, t.name
ORDER BY points DESC, goal_diff DESC;

EXPLAIN ANALYZE
SELECT m.match_date, t1.name as home, t2.name as away, 
       CASE WHEN m.home_score > m.away_score THEN t1.name 
            WHEN m.away_score > m.home_score THEN t2.name 
            ELSE 'Draw' END as winner
FROM matches m
JOIN match_types mt ON m.match_type_id = mt.id
JOIN teams t1 ON m.home_team_id = t1.id
JOIN teams t2 ON m.away_team_id = t2.id
WHERE mt.name = 'Final';

EXPLAIN ANALYZE
SELECT mt.name, COUNT(m.id) as count
FROM match_types mt
LEFT JOIN matches m ON mt.id = m.match_type_id
GROUP BY mt.name;

EXPLAIN ANALYZE
SELECT t1.name, t2.name, mt.name as type, m.home_score, m.away_score
FROM matches m
JOIN teams t1 ON m.home_team_id = t1.id
JOIN teams t2 ON m.away_team_id = t2.id
JOIN match_types mt ON m.match_type_id = mt.id
WHERE m.match_date::date = CURRENT_DATE - INTERVAL '100 days';

EXPLAIN ANALYZE
SELECT p.first_name, p.last_name, COUNT(me.id) as goal_count
FROM match_events me
JOIN matches m ON me.match_id = m.id
JOIN players p ON me.player_id = p.id
WHERE m.tournament_id = 1 AND me.event_type = 'goal'
GROUP BY p.id
ORDER BY goal_count DESC;

EXPLAIN ANALYZE
SELECT t.name, t.year, tp.placement
FROM tournament_participation tp
JOIN tournaments t ON tp.tournament_id = t.id
WHERE tp.team_id = 20;

EXPLAIN ANALYZE
SELECT t.name as tournament_name, team.name as winner_team
FROM matches m
JOIN match_types mt ON m.match_type_id = mt.id
JOIN tournaments t ON m.tournament_id = t.id
JOIN teams team ON (
    CASE WHEN m.home_score > m.away_score THEN m.home_team_id 
         WHEN m.away_score > m.home_score THEN m.away_team_id 
    END
) = team.id
WHERE mt.name = 'Final' AND t.id = 1;

EXPLAIN ANALYZE
SELECT t.name, COUNT(DISTINCT tp.team_id) as team_count, COUNT(DISTINCT p.id) as player_count
FROM tournaments t
JOIN tournament_participation tp ON t.id = tp.tournament_id
JOIN players p ON tp.team_id = p.team_id
GROUP BY t.id, t.name;

EXPLAIN ANALYZE
SELECT t.name, p.first_name, p.last_name, COUNT(me.id) as total_goals
FROM teams t
JOIN players p ON t.id = p.team_id
JOIN match_events me ON p.id = me.player_id
WHERE me.event_type = 'goal'
GROUP BY t.id, p.id
ORDER BY t.name, total_goals DESC;

EXPLAIN ANALYZE
SELECT m.match_date, t1.name, t2.name, m.home_score, m.away_score
FROM matches m
JOIN teams t1 ON m.home_team_id = t1.id
JOIN teams t2 ON m.away_team_id = t2.id
WHERE m.referee_id = 5;
