CREATE INDEX idx_matches_tournament_id ON matches(tournament_id);
CREATE INDEX idx_matches_home_team_id ON matches(home_team_id);
CREATE INDEX idx_matches_away_team_id ON matches(away_team_id);
CREATE INDEX idx_matches_referee_id ON matches(referee_id);
CREATE INDEX idx_matches_match_type_id ON matches(match_type_id);

CREATE INDEX idx_matches_match_date ON matches(match_date);

CREATE INDEX idx_match_events_match_id ON match_events(match_id);
CREATE INDEX idx_match_events_player_id ON match_events(player_id);

CREATE INDEX idx_match_events_event_type ON match_events(event_type);

CREATE INDEX idx_players_team_id ON players(team_id);

CREATE INDEX idx_tourn_part_tournament_id ON tournament_participation(tournament_id);
CREATE INDEX idx_tourn_part_team_id ON tournament_participation(team_id);

CREATE INDEX idx_match_events_player_event ON match_events(player_id, event_type);
