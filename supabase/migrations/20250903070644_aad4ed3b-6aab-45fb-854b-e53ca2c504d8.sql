-- Add missing validation constraints for schools table (only add what doesn't exist)

-- First, clean up existing data that might not match constraints
UPDATE public.schools 
SET 
  name = CASE 
    WHEN name ~ '^[a-zA-Z\s\-\.&'']+$' THEN name
    ELSE 'School ' || id::text
  END,
  city = CASE 
    WHEN city ~ '^[a-zA-Z\s\-\.]+$' THEN city
    ELSE 'Unknown City'
  END,
  state = CASE 
    WHEN state ~ '^[a-zA-Z\s]+$' THEN state
    ELSE 'Unknown State'
  END,
  contact = CASE 
    WHEN contact ~ '^[\+]?[0-9]+$' AND length(contact) BETWEEN 10 AND 15 THEN contact
    ELSE '1234567890'
  END
WHERE 
  name !~ '^[a-zA-Z\s\-\.&'']+$' OR
  city !~ '^[a-zA-Z\s\-\.]+$' OR
  state !~ '^[a-zA-Z\s]+$' OR
  contact !~ '^[\+]?[0-9]+$' OR
  length(contact) < 10 OR
  length(contact) > 15;

-- Add missing constraints (using IF NOT EXISTS equivalent for PostgreSQL)
DO $$ 
BEGIN
  -- Add name format constraint if it doesn't exist
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                 WHERE constraint_name = 'schools_name_format' AND table_name = 'schools') THEN
    ALTER TABLE public.schools ADD CONSTRAINT schools_name_format CHECK (name ~ '^[a-zA-Z\s\-\.&'']+$');
  END IF;

  -- Add address length constraint if it doesn't exist
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                 WHERE constraint_name = 'schools_address_length' AND table_name = 'schools') THEN
    ALTER TABLE public.schools ADD CONSTRAINT schools_address_length CHECK (length(trim(address)) >= 5 AND length(address) <= 200);
  END IF;

  -- Add city length constraint if it doesn't exist
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                 WHERE constraint_name = 'schools_city_length' AND table_name = 'schools') THEN
    ALTER TABLE public.schools ADD CONSTRAINT schools_city_length CHECK (length(trim(city)) >= 2 AND length(city) <= 50);
  END IF;

  -- Add city format constraint if it doesn't exist
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                 WHERE constraint_name = 'schools_city_format' AND table_name = 'schools') THEN
    ALTER TABLE public.schools ADD CONSTRAINT schools_city_format CHECK (city ~ '^[a-zA-Z\s\-\.]+$');
  END IF;

  -- Add state length constraint if it doesn't exist
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                 WHERE constraint_name = 'schools_state_length' AND table_name = 'schools') THEN
    ALTER TABLE public.schools ADD CONSTRAINT schools_state_length CHECK (length(trim(state)) >= 2 AND length(state) <= 50);
  END IF;

  -- Add state format constraint if it doesn't exist
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                 WHERE constraint_name = 'schools_state_format' AND table_name = 'schools') THEN
    ALTER TABLE public.schools ADD CONSTRAINT schools_state_format CHECK (state ~ '^[a-zA-Z\s]+$');
  END IF;

  -- Add contact length constraint if it doesn't exist
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                 WHERE constraint_name = 'schools_contact_length' AND table_name = 'schools') THEN
    ALTER TABLE public.schools ADD CONSTRAINT schools_contact_length CHECK (length(trim(contact)) >= 10 AND length(contact) <= 15);
  END IF;

  -- Add contact format constraint if it doesn't exist
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                 WHERE constraint_name = 'schools_contact_format' AND table_name = 'schools') THEN
    ALTER TABLE public.schools ADD CONSTRAINT schools_contact_format CHECK (contact ~ '^[\+]?[0-9]+$');
  END IF;

  -- Add email length constraint if it doesn't exist
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                 WHERE constraint_name = 'schools_email_length' AND table_name = 'schools') THEN
    ALTER TABLE public.schools ADD CONSTRAINT schools_email_length CHECK (length(trim(email_id)) >= 5 AND length(email_id) <= 100);
  END IF;

  -- Add email format constraint if it doesn't exist
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                 WHERE constraint_name = 'schools_email_format' AND table_name = 'schools') THEN
    ALTER TABLE public.schools ADD CONSTRAINT schools_email_format CHECK (email_id ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
  END IF;
END $$;

-- Create validation trigger function (replace if exists)
CREATE OR REPLACE FUNCTION validate_school_fields()
RETURNS TRIGGER AS $$
BEGIN
  -- Validate and trim all fields
  NEW.name = trim(NEW.name);
  NEW.address = trim(NEW.address);
  NEW.city = trim(NEW.city);
  NEW.state = trim(NEW.state);
  NEW.contact = trim(NEW.contact);
  NEW.email_id = trim(NEW.email_id);
  
  -- Check for empty fields after trimming
  IF NEW.name = '' THEN
    RAISE EXCEPTION 'School name cannot be empty or contain only whitespace';
  END IF;
  
  IF NEW.address = '' THEN
    RAISE EXCEPTION 'Address cannot be empty or contain only whitespace';
  END IF;
  
  IF NEW.city = '' THEN
    RAISE EXCEPTION 'City cannot be empty or contain only whitespace';
  END IF;
  
  IF NEW.state = '' THEN
    RAISE EXCEPTION 'State cannot be empty or contain only whitespace';
  END IF;
  
  IF NEW.contact = '' THEN
    RAISE EXCEPTION 'Contact cannot be empty or contain only whitespace';
  END IF;
  
  IF NEW.email_id = '' THEN
    RAISE EXCEPTION 'Email cannot be empty or contain only whitespace';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop trigger if exists and recreate
DROP TRIGGER IF EXISTS validate_school_fields_trigger ON public.schools;
CREATE TRIGGER validate_school_fields_trigger
  BEFORE INSERT OR UPDATE ON public.schools
  FOR EACH ROW
  EXECUTE FUNCTION validate_school_fields();