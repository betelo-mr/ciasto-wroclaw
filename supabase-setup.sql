-- =============================================
-- TABELA ZAPISÓW NA CIASTO
-- Uruchom ten SQL w Supabase SQL Editor
-- =============================================

-- Utwórz tabelę zapisów
CREATE TABLE cake_signups (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    sunday_date DATE NOT NULL,
    name VARCHAR(50) NOT NULL,
    cake_description VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Utwórz tabelę ustawień (na hasło admina)
CREATE TABLE app_settings (
    key VARCHAR(50) PRIMARY KEY,
    value TEXT NOT NULL
);

-- Włącz Row Level Security (RLS)
ALTER TABLE cake_signups ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_settings ENABLE ROW LEVEL SECURITY;

-- Polityki dla cake_signups
CREATE POLICY "Publiczny odczyt" ON cake_signups FOR SELECT USING (true);
CREATE POLICY "Publiczne dodawanie" ON cake_signups FOR INSERT WITH CHECK (true);
CREATE POLICY "Publiczne usuwanie" ON cake_signups FOR DELETE USING (true);

-- Polityka dla app_settings (tylko odczyt)
CREATE POLICY "Publiczny odczyt ustawień" ON app_settings FOR SELECT USING (true);

-- Indeks dla szybszego wyszukiwania
CREATE INDEX idx_cake_signups_sunday_date ON cake_signups(sunday_date);

-- Włącz Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE cake_signups;

-- =============================================
-- USTAW HASŁO ADMINA
-- Zamień 'ciasto2025' na swoje hasło!
-- =============================================
INSERT INTO app_settings (key, value) VALUES (
    'admin_password_hash',
    encode(sha256('ciasto2025'::bytea), 'hex')
);

-- =============================================
-- ŻEBY ZMIENIĆ HASŁO PÓŹNIEJ, URUCHOM:
-- UPDATE app_settings 
-- SET value = encode(sha256('NOWE_HASLO'::bytea), 'hex')
-- WHERE key = 'admin_password_hash';
-- =============================================
