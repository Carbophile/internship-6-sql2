INSERT INTO match_types (name) VALUES 
('Group Stage'), ('Quarter-final'), ('Semi-final'), ('Final');

INSERT INTO teams (name, country, representative, contact_email)
SELECT 
    'Team ' || i,
    (ARRAY['Croatia', 'Spain', 'Germany', 'Brazil', 'Argentina', 'France', 'Italy'])[floor(random() * 7 + 1)],
    'Rep ' || i,
    'contact' || i || '@team.com'
FROM generate_series(1, 100) AS i;

INSERT INTO players (team_id, first_name, last_name, birth_date)
SELECT 
    t.id,
    'PlayerFN ' || floor(random() * 1000),
    'PlayerLN ' || floor(random() * 1000),
    CURRENT_DATE - (floor(random() * 7000 + 6000) || ' days')::INTERVAL
FROM teams t
CROSS JOIN generate_series(1, 20);

INSERT INTO referees (first_name, last_name, birth_date)
SELECT 
    'RefFN ' || i,
    'RefLN ' || i,
    CURRENT_DATE - (floor(random() * 10000 + 8000) || ' days')::INTERVAL
FROM generate_series(1, 50) AS i;

INSERT INTO tournaments (name, year, city)
SELECT 
    'Tournament ' || i,
    2000 + floor(random() * 25),
    (ARRAY['Split', 'Zagreb', 'London', 'Paris', 'Berlin', 'Madrid'])[floor(random() * 6 + 1)]
FROM generate_series(1, 50) AS i;

INSERT INTO tournament_participation (tournament_id, team_id, points, placement)
SELECT 
    tour.id,
    team.id,
    floor(random() * 15),
    NULL
FROM tournaments tour
CROSS JOIN LATERAL (
    SELECT id FROM teams ORDER BY random() LIMIT 16
) team;

INSERT INTO matches (tournament_id, match_type_id, home_team_id, away_team_id, referee_id, match_date, home_score, away_score)
SELECT 
    tp1.tournament_id,
    (SELECT id FROM match_types ORDER BY random() LIMIT 1),
    tp1.team_id,
    tp2.team_id,
    (SELECT id FROM referees ORDER BY random() LIMIT 1),
    CURRENT_DATE - (floor(random() * 365) || ' days')::INTERVAL,
    floor(random() * 5),
    floor(random() * 5)
FROM tournament_participation tp1
JOIN tournament_participation tp2 ON tp1.tournament_id = tp2.tournament_id AND tp1.team_id < tp2.team_id
WHERE random() < 0.3;

INSERT INTO match_events (match_id, player_id, event_type, minute)
SELECT 
    m.id,
    (SELECT id FROM players p WHERE p.team_id = m.home_team_id OR p.team_id = m.away_team_id ORDER BY random() LIMIT 1),
    (ENUM_RANGE(NULL::event_type_enum))[floor(random() * 3 + 1)],
    floor(random() * 90 + 1)
FROM matches m
CROSS JOIN generate_series(1, 3);

UPDATE tournaments
SET winner_team_id = (
    SELECT team_id FROM tournament_participation tp 
    WHERE tp.tournament_id = tournaments.id 
    ORDER BY random() LIMIT 1
)
WHERE year < 2025;
