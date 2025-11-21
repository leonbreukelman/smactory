-- Create dedicated cognee_user as superuser with known temp password
CREATE USER cognee_user SUPERUSER PASSWORD 'smactory_temp_2025_change_me';

-- Optional: make it owner of the database (cognee likes this)
ALTER DATABASE cognee_db OWNER TO cognee_user;

-- Grant everything just in case
GRANT ALL PRIVILEGES ON DATABASE cognee_db TO cognee_user;
